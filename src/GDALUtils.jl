module GDALUtils

    import GDAL

    include("metadata.jl")
    include("driver.jl")
    include("dataset.jl")
    include("rasterband.jl")
    include("color.jl")
    include("gcp.jl")
    include("type.jl")

    opendataset(filename::AbstractString, access::GDAL.GDALAccess=GDAL.GA_ReadOnly,
                shared::Bool = false) =
        Dataset(open(filename, access, shared))

    createdataset(filename::AbstractString,
                  width::Int,
                  height::Int,
                  nbands::Int,
                  dtype::DataType,
                  drivername::AbstractString,
                  options::Vector{ASCIIString} = Vector{ASCIIString}()) =
        Dataset(GDAL.create(driver(drivername), filename, width, height,
                            nbands, _gdaltype(dtype), Ptr{Ptr{UInt8}}(pointer(options))))

    function writedataset(dataset::Dataset,
                          filename::AbstractString,
                          strict::Bool = false,
                          options::Vector{ASCIIString} = Vector{ASCIIString}())
        checknull(dataset) && error("Can't write closed dataset")
        closedataset(createcopy(driver(dataset.ptr), filename,
                                dataset.ptr, strict, options))
    end

    function writedataset(dataset::Dataset,
                         filename::AbstractString,
                         drivername::AbstractString,
                         strict::Bool = false,
                         options::Vector{ASCIIString} = Vector{ASCIIString}())
        checknull(dataset) && error("Can't write closed dataset")
        closedataset(createcopy(driver(name), filename, dataset.ptr,
                                strict, options))
    end

    function fetch!{T <: Real}(dataset::Dataset, buffer::Array{T,2}, i::Integer)
        checknull(dataset) && error("Can't read closed dataset")
        rasterio!(fetchband(dataset.ptr, i), buffer, GDAL.GF_Read)
    end

    function fetch!{T <: Real}(
                dataset::Dataset,
                buffer::Array{T,3},
                indices::Vector{Cint})
        checknull(dataset) && error("Can't read closed dataset")
        rasterio!(dataset.ptr, buffer, indices, GDAL.GF_Read)
    end

    function fetch!{T <: Real}(dataset::Dataset, buffer::Array{T,3})
        checknull(dataset) && error("Can't read closed dataset")
        _nband = nband(dataset.ptr)
        @assert size(buffer, 3) == _nband
        rasterio!(dataset.ptr, buffer, collect(Cint, 1:_nband), GDAL.GF_Read)
    end

    function fetch!{T <: Real}(dataset::Dataset,
                               buffer::Array{T,2},
                               i::Integer,
                               width::Integer,
                               height::Integer,
                               xoffset::Integer,
                               yoffset::Integer)
        checknull(dataset) && error("Can't read closed dataset")
        rasterio!(fetchband(dataset.ptr, i), buffer,
                  width, height, xoffset, yoffset, GDAL.GF_Read)
    end

    function fetch!{T <: Real}(dataset::Dataset,
                           buffer::Array{T,3},
                           indices::Vector{Cint},
                           width::Integer,
                           height::Integer,
                           xoffset::Integer,
                           yoffset::Integer)
        checknull(dataset) && error("Can't read closed dataset")
        rasterio!(dataset.ptr, buffer, indices, width, height,
                  xoffset, yoffset, GDAL.GF_Read)
    end

    function fetch!{T <: Real, U <: Integer}(dataset::Dataset,
                                             buffer::Array{T,2},
                                             i::Integer,
                                             rows::UnitRange{U},
                                             cols::UnitRange{U})
        checknull(dataset) && error("Can't read closed dataset")
        rasterio!(fetchband(dataset.ptr, i), buffer,
                  width, rows, cols, GDAL.GF_Read)
    end

    function fetch!{T <: Real, U <: Integer}(dataset::Dataset,
                                             buffer::Array{T,3},
                                             indices::Vector{Cint},
                                             rows::UnitRange{U},
                                             cols::UnitRange{U})
        checknull(dataset) && error("Can't read closed dataset")
        rasterio!(dataset.ptr, buffer, indices, rows, cols, GDAL.GF_Read)
    end

    function fetch(dataset::Dataset, i::Integer)
        checknull(dataset) && error("Can't read closed dataset")
        band = fetchband(dataset.ptr, i)
        buffer = Array(datatypeof(band), width(band), height(band))
        rasterio!(band, buffer, GDAL.GF_Read)
    end

    function fetch(dataset::Dataset, indices::Vector{Cint})
        checknull(dataset) && error("Can't read closed dataset")
        buffer = Array(datatypeof(fetchband(dataset.ptr, indices[1])),
                       width(dataset.ptr), height(dataset.ptr),
                       length(indices))
        rasterio!(dataset.ptr, buffer, indices, GDAL.GF_Read)
    end

    function fetch(dataset::Dataset)
        checknull(dataset) && error("Can't read closed dataset")
        buffer = Array(datatypeof(fetchband(dataset.ptr, 1)),
                       width(dataset.ptr), height(dataset.ptr),
                       nband(dataset.ptr))
        fetch!(dataset, buffer)
    end

    function fetch(dataset::Dataset,
                   i::Integer,
                   width::Integer,
                   height::Integer,
                   xoffset::Integer,
                   yoffset::Integer)
        checknull(dataset) && error("Can't read closed dataset")
        band = fetchband(dataset.ptr, i)
        buffer = Array(datatypeof(band), width(band), height(band))
        rasterio!(band, buffer, width, height, xoffset, yoffset, GDAL.GF_Read)
    end

    function fetch{T <: Integer}(dataset::Dataset,
                                 indices::Vector{T},
                                 width::Integer,
                                 height::Integer,
                                 xoffset::Integer,
                                 yoffset::Integer)
        checknull(dataset) && error("Can't read closed dataset")
        buffer = Array(datatypeof(fetchband(dataset.ptr, indices[1])),
                       width(dataset.ptr), height(dataset.ptr),
                       length(indices))
        rasterio!(dataset.ptr, buffer, indices, width, height, xoffset, yoffset, GDAL.GF_Read)
    end

    function fetch{U <: Integer}(dataset::Dataset,
                                 i::Integer,
                                 rows::UnitRange{U},
                                 cols::UnitRange{U})
        checknull(dataset) && error("Can't read closed dataset")
        band = fetchband(dataset.ptr, i)
        buffer = Array(datatypeof(band), width(band), height(band))
        rasterio!(band, buffer, rows, cols, GDAL.GF_Read)
    end

    function fetch{U <: Integer}(dataset::Dataset,
                                 indices::Vector{Cint},
                                 rows::UnitRange{U},
                                 cols::UnitRange{U})
        checknull(dataset) && error("Can't read closed dataset")
        buffer = Array(datatypeof(fetchband(dataset.ptr, indices[1])),
                       width(dataset.ptr), height(dataset.ptr), length(indices))
        rasterio!(dataset.ptr, buffer, indices, rows, cols, GDAL.GF_Read)
    end

    function update!{T <: Real}(dataset::Dataset, buffer::Array{T,2}, i::Integer)
        checknull(dataset) && error("Can't write closed dataset")
        rasterio!(fetchband(dataset.ptr, i), buffer, GDAL.GF_Write)
    end

    function update!{T <: Real}(dataset::Dataset,
                                buffer::Array{T,3},
                                indices::Vector{Cint})
        checknull(dataset) && error("Can't write closed dataset")
        rasterio!(dataset.ptr, buffer, indices, GDAL.GF_Write)
    end

    function update!{T <: Real}(dataset::Dataset,
                                buffer::Array{T,2},
                                i::Integer,
                                width::Integer,
                                height::Integer,
                                xoffset::Integer,
                                yoffset::Integer)
        checknull(dataset) && error("Can't write closed dataset")
        rasterio!(fetchband(dataset.ptr, i), buffer, width, height,
                  xoffset, yoffset, GDAL.GF_Write)
    end

    function update!{T <: Real}(dataset::Dataset,
                                buffer::Array{T,3},
                                indices::Vector{Cint},
                                width::Integer,
                                height::Integer,
                                xoffset::Integer,
                                yoffset::Integer)
        checknull(dataset) && error("Can't write closed dataset")
        rasterio!(dataset.ptr, buffer, indices, width, height,
                  xoffset, yoffset, GDAL.GF_Write)
    end

    function update!{T <: Real, U <: Integer}(dataset::Dataset,
                                              buffer::Array{T,2},
                                              i::Integer,
                                              rows::UnitRange{U},
                                              cols::UnitRange{U})
        checknull(dataset) && error("Can't write closed dataset")
        rasterio!(fetchband(dataset.ptr, i), buffer, rows, cols, GDAL.GF_Write)
    end

    function update!{T <: Real, U <: Integer}(dataset::Dataset,
                                              buffer::Array{T,3},
                                              indices::Vector{Cint},
                                              rows::UnitRange{U},
                                              cols::UnitRange{U})
        checknull(dataset) && error("Can't write closed dataset")
        rasterio!(dataset.ptr, buffer, indices, rows, cols, GDAL.GF_Write)
    end

end # module
