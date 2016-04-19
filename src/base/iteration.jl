# immutable RasterDataset
#     dataset::Dataset
#     nrasters::Int
#     RasterDataset(dataset::Dataset) = new(dataset, nraster(dataset))
# end
# Base.eltype(rd::RasterDataset) = RasterBand
# Base.length(rd::RasterDataset) = rd.nrasters
# Base.start(rd::RasterDataset) = 1
# Base.next(rd::RasterDataset, i::Int) = (fetchband(rd.dataset, i), i+1)
# Base.done(rd::RasterDataset, i::Int) = (i > rd.nrasters)

immutable BlockIterator
    rows::Cint
    cols::Cint
    ni::Cint
    nj::Cint
    n::Cint
    xbsize::Cint
    ybsize::Cint
end
function BlockIterator(raster::RasterBand)
    (xbsize, ybsize) = getblocksize(raster)
    rows = height(raster)
    cols = width(raster)
    ni = ceil(Cint, rows/ybsize)
    nj = ceil(Cint, cols/xbsize)
    BlockIterator(rows, cols, ni, nj, ni*nj, xbsize, ybsize)
end
Base.start(obj::BlockIterator) = 0
function Base.next(obj::BlockIterator, iter::Int)
    j = floor(Int, iter / obj.ni)
    i = iter % obj.ni
    nrows = ((i+1)* obj.ybsize < obj.rows) ? obj.ybsize : obj.rows - i* obj.ybsize
    ncols = ((j+1)* obj.xbsize < obj.cols) ? obj.xbsize : obj.cols - j*obj.xbsize
    (((i,j),(nrows,ncols)), iter+1)
end
Base.done(obj::BlockIterator, iter::Int) = (iter == obj.n)

immutable WindowIterator
    blockiter::BlockIterator
end
function WindowIterator(raster::RasterBand)
    WindowIterator(BlockIterator(raster))
end
Base.start(obj::WindowIterator) = Base.start(obj.blockiter)
function Base.next(obj::WindowIterator, iter::Int)
    handle = obj.blockiter
    (((i,j),(nrows,ncols)), iter) = Base.next(handle, iter)
    (((1:ncols)+j*handle.xbsize, (1:nrows)+i*handle.ybsize), iter)
end
Base.done(obj::WindowIterator, iter::Int) = Base.done(obj.blockiter, iter)

type BufferIterator{T <: Real}
    raster::RasterBand
    w::WindowIterator
    buffer::Array{T, 2}
end
function BufferIterator(raster::RasterBand)
    BufferIterator(raster, WindowIterator(raster),
                   Array(getdatatype(raster), getblocksize(raster)...))
end
Base.start(obj::BufferIterator) = Base.start(obj.w)
function Base.next(obj::BufferIterator, iter::Int)
    ((cols,rows), iter) = Base.next(obj.w, iter)
    rasterio!(obj.raster, obj.buffer, rows, cols)
    (obj.buffer[1:length(cols),1:length(rows)], iter)
end
Base.done(obj::BufferIterator, iter::Int) = Base.done(obj.w, iter)

# immutable FeatureDataset
#     dataset::Dataset
#     nlayers::Int
#     FeatureDataset(dataset::Dataset) = new(dataset, nlayer(dataset))
# end
# Base.eltype(rd::FeatureDataset) = FeatureLayer
# Base.length(rd::FeatureDataset) = rd.nlayers
# Base.start(fc::FeatureDataset) = 1
# Base.next(fc::FeatureDataset, i::Int) = (fetchlayer(fc.dataset, i), i+1)
# Base.done(fc::FeatureDataset, i::Int) = (i > fc.nlayers)

Base.start(layer::FeatureLayer) = Feature(C_NULL)
Base.next(layer::FeatureLayer, state::Feature) = (state, state)
Base.eltype(layer::FeatureLayer) = Feature
Base.length(layer::FeatureLayer) = nfeature(layer, true)

function Base.done(layer::FeatureLayer, state::Feature)
    destroy(state)
    ptr = ccall((:OGR_L_GetNextFeature,GDAL.libgdal),
                Ptr{GDAL.OGRFeatureH},(Ptr{GDAL.OGRLayerH},),layer.ptr)
    state.ptr = ptr
    (ptr == C_NULL)
end

immutable DictIterator
    layer::FeatureLayer
end
Base.start(obj::DictIterator) = Base.start(obj.layer)
function Base.next(obj::DictIterator, f::Feature)
    properties = Dict{Int, Any}()
    for i in 0:(nfield(f)-1)
        if isfieldset(f, i)
            properties[i] = fetchfield(f, i)
        end
    end
    geometries = Geometry[fetchgeomfield(f, i) for i in 0:(ngeomfield(f)-1)]
    (Dict(:properties => properties, :geom => geometries), f)
end
Base.done(obj::DictIterator, f::Feature) = Base.done(obj.layer, f)
