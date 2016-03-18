
"""
Read/write a region of image data from multiple bands.

This method allows reading a region of one or more `GDALRasterBands` from this
dataset into a buffer, or writing data from a buffer into a region of the
`GDALRasterBands`. It automatically takes care of data type translation if the
data type (`eBufType`) of the buffer is different than that of the
`GDALRasterBand`. The method also takes care of image decimation / replication
if the buffer size (`nBufXSize x nBufYSize`) is different than the size of the
region being accessed (`nXSize x nYSize`).

The `nPixelSpace`, `nLineSpace` and `nBandSpace` parameters allow reading into
or writing from various organization of buffers.

For highest performance full resolution data access, read and write on "block
boundaries" as returned by `GetBlockSize()`, or use the `ReadBlock()` and
`WriteBlock()` methods.

### Parameters
* `eRWFlag`     Either `GF_Read` to read a region of data, or `GF_Write` to
write a region of data.
* `nXOff`       The pixel offset to the top left corner of the region of the
band to be accessed. This would be zero to start from the left side.
* `nYOff`       The line offset to the top left corner of the region of the
band to be accessed. This would be zero to start from the top.
* `nXSize`      The width of the region of the band to be accessed in pixels.
* `nYSize`      The height of the region of the band to be accessed in lines.
* `pData`       The buffer into which the data should be read, or from which it
should be written. It must contain ≥`nBufXSize * nBufYSize * nBandCount` words
of type `eBufType`. It is organized in left to right, top to bottom pixel
order. Spacing is controlled by the `nPixelSpace`, and `nLineSpace` parameters
* `nBufXSize`   The width of the buffer image into which the desired region is
to be read, or from which it is to be written.
* `nBufYSize`   The height of the buffer image into which the desired region is
to be read, or from which it is to be written.
* `eBufType`    The type of the pixel values in `pBuffer`. The pixel values
will be auto-translated to/from the `GDALRasterBand` data type as needed.
* `nBandCount`  The number of bands being read or written.
* `panBandMap`  The list of nBandCount band numbers being read/written. Note
band numbers are 1 based. May be `NULL` to select the first `nBandCount` bands
* `nPixelSpace` The byte offset from the start of one pixel value in `pBuffer`
to the start of the next pixel value within a scanline. If defaulted (0) the
size of the datatype `eBufType` is used.
* `nLineSpace`  The byte offset from the start of one scanline in pBuffer to
the start of the next. If defaulted (0) the size of the datatype
`eBufType * nBufXSize` is used.
* `nBandSpace`  the byte offset from the start of one bands data to the start
of the next. If defaulted (0) the value will be `nLineSpace * nBufYSize`
implying band sequential organization of the data buffer.
* `psExtraArg`  (new in GDAL 2.0) pointer to a GDALRasterIOExtraArg structure
with additional arguments to specify resampling and progress callback, or
`NULL` for default behaviour. The `GDAL_RASTERIO_RESAMPLING` configuration
option can also be defined to override the default resampling to one of
`BILINEAR`, `CUBIC`, `CUBICSPLINE`, `LANCZOS`, `AVERAGE` or `MODE`.
"""
function rasterio!{T <: Real}(
            dataset::Dataset,
            buffer::Array{T, 3},
            bands::Vector{Cint},
            _width::Integer,
            _height::Integer,
            access::GDAL.GDALRWFlag = GDAL.GF_Read,
            xoffset::Integer = 0,
            yoffset::Integer = 0,
            nPixelSpace::Integer = 0,
            nLineSpace::Integer = 0,
            nBandSpace::Integer = 0)
    xsize, ysize, zsize = size(buffer)
    _nband = length(bands)
    @assert _nband == zsize
    GDAL.datasetrasterio(dataset.ptr, access, xoffset, yoffset, _width,
                         _height, pointer(buffer), xsize, ysize, _gdaltype(T),
                         _nband, pointer(bands), nPixelSpace, nLineSpace,
                         nBandSpace)
    buffer
end

function rasterio!{T <: Real}(
            dataset::Dataset,
            buffer::Array{T, 3},
            bands::Vector{Cint},
            access::GDAL.GDALRWFlag = GDAL.GF_Read,
            xoffset::Integer = 0,
            yoffset::Integer = 0,
            nPixelSpace::Integer = 0,
            nLineSpace::Integer = 0,
            nBandSpace::Integer = 0)
    rasterio!(dataset, buffer, bands, width(dataset), height(dataset), access,
              xoffset, yoffset, nPixelSpace, nLineSpace, nBandSpace)
end

function rasterio!{T <: Real, U <: Integer}(
            dataset::Dataset,
            buffer::Array{T, 3},
            bands::Vector{Cint},
            rows::UnitRange{U},
            cols::UnitRange{U},
            access::GDAL.GDALRWFlag = GDAL.GF_Read,
            nPixelSpace::Integer = 0,
            nLineSpace::Integer = 0,
            nBandSpace::Integer = 0)
    _width = cols[end] - cols[1] + 1
    _width < 0 && error("invalid window width")
    _height = rows[end] - rows[1] + 1
    _height < 0 && error("invalid window height")
    rasterio!(dataset, buffer, bands, _width, _height, access, cols[1], rows[1],
              nPixelSpace, nLineSpace, nBandSpace)
end

"""
Read/write a region of image data for this band.

This method allows reading a region of a `GDALRasterBand` into a buffer, or
writing data from a buffer into a region of a `GDALRasterBand`. It
automatically takes care of data type translation if the data type (`eBufType`)
of the buffer is different than that of the `GDALRasterBand`. The method also
takes care of image decimation / replication if the buffer size
`(nBufXSize x nBufYSize)` is different than the size of the region being
accessed `(nXSize x nYSize)`.

The `nPixelSpace` and `nLineSpace` parameters allow reading into or writing
from unusually organized buffers. This is primarily used for buffers containing
more than one bands raster data in interleaved format.

Some formats may efficiently implement decimation into a buffer by reading from
lower resolution overview images.

For highest performance full resolution data access, read and write on "block
boundaries" returned by `GetBlockSize()`, or use the `ReadBlock()` and 
`WriteBlock()` methods.

### Parameters
* `eRWFlag`     Either GF_Read to read a region of data, or GF_Write to write a
region of data.
* `nXOff`       The pixel offset to the top left corner of the region of the
band to be accessed. This would be zero to start from the left side.
* `nYOff`       The line offset to the top left corner of the region of the
band to be accessed. This would be zero to start from the top.
* `nXSize`      The width of the region of the band to be accessed in pixels.
* `nYSize`      The height of the region of the band to be accessed in lines.
* `pData`       The buffer into which the data should be read, or from which it
should be written. This buffer must contain at least `(nBufXSize * nBufYSize)`
words of type `eBufType`. It is organized in left to right, top to bottom pixel
order. Spacing is controlled by the `nPixelSpace`, and `nLineSpace` parameters.
* `nBXSize`     The width of the buffer image into which the desired region is
to be read, or from which it is to be written.
* `nBYSize`     The height of the buffer image into which the desired region is
to be read, or from which it is to be written.
* `eBufType`    The type of the pixel values in the `buffer`. The pixel values
will be auto-translated to/from the `GDALRasterBand` data type as needed.
* `nPixelSpace` The byte offset from the start of one pixel value in `buffer`
to the start of the next pixel value within a scanline. If defaulted (0) the
size of the datatype `eBufType` is used.
* `nLineSpace`  The byte offset from the start of one scanline in `buffer` to
the start of the next. If defaulted (0) the size of the datatype
`(eBufType * nBufXSize)` is used.
* `psExtraArg`  (new in GDAL 2.0) pointer to a GDALRasterIOExtraArg structure
with additional arguments to specify resampling and progress callback, or
`NULL` for default behaviour. The `GDAL_RASTERIO_RESAMPLING` configuration
option can also be defined to override the default resampling to one of
`BILINEAR`, `CUBIC`, `CUBICSPLINE`, `LANCZOS`, `AVERAGE` or `MODE`.

### Returns
`CE_Failure` if the access fails, otherwise `CE_None`.
"""
function rasterio!{T <: Real}(rasterband::RasterBand,
                              buffer::Array{T,2},
                              _width::Integer,
                              _height::Integer,
                              xoffset::Integer = 0,
                              yoffset::Integer = 0,
                              access::GDAL.GDALRWFlag = GDAL.GF_Read,
                              nPixelSpace::Integer = 0,
                              nLineSpace::Integer = 0)
    xsize, ysize = size(buffer)
    GDAL.rasterio(rasterband.ptr, access, xoffset, yoffset, _width, _height,
                  pointer(buffer), xsize, ysize, _gdaltype(T),
                  nPixelSpace, nLineSpace)
    buffer
end

function rasterio!{T <: Real}(rasterband::RasterBand,
                              buffer::Array{T,2},
                              xoffset::Integer = 0,
                              yoffset::Integer = 0,
                              access::GDAL.GDALRWFlag = GDAL.GF_Read,
                              nPixelSpace::Integer = 0,
                              nLineSpace::Integer = 0)
    rasterio!(rasterband, buffer, width(rasterband), height(rasterband),
              xoffset, yoffset, access, nPixelSpace, nLineSpace)
end

function rasterio!{T <: Real, U <: Integer}(rasterband::RasterBand,
                                            buffer::Array{T,2},
                                            rows::UnitRange{U},
                                            cols::UnitRange{U},
                                            access::GDAL.GDALRWFlag = GDAL.GF_Read,
                                            nPixelSpace::Integer = 0,
                                            nLineSpace::Integer = 0)
    _width = cols[end] - cols[1] + 1
    _width < 0 && error("invalid window width")
    _height = rows[end] - rows[1] + 1
    _height < 0 && error("invalid window height")
    rasterio!(rasterband, buffer, _width, _height, cols[1], rows[1], access,
              nPixelSpace, nLineSpace)
end

function fetch!{T <: Real}(dataset::Dataset, buffer::Array{T,2}, i::Integer)
    checknull(dataset) && error("Can't read closed dataset")
    rasterio!(fetchband(dataset, i), buffer, GDAL.GF_Read)
end

function fetch!{T <: Real}(dataset::Dataset,
                           buffer::Array{T,3},
                           indices::Vector{Cint})
    checknull(dataset) && error("Can't read closed dataset")
    rasterio!(dataset, buffer, indices, GDAL.GF_Read)
end

function fetch!{T <: Real}(dataset::Dataset, buffer::Array{T,3})
    checknull(dataset) && error("Can't read closed dataset")
    _nband = nband(dataset)
    @assert size(buffer, 3) == _nband
    rasterio!(dataset, buffer, collect(Cint, 1:_nband), GDAL.GF_Read)
end

function fetch!{T <: Real}(dataset::Dataset,
                           buffer::Array{T,2},
                           i::Integer,
                           width::Integer,
                           height::Integer,
                           xoffset::Integer,
                           yoffset::Integer)
    checknull(dataset) && error("Can't read closed dataset")
    rasterio!(fetchband(dataset, i), buffer, width, height, xoffset, yoffset)
end

function fetch!{T <: Real}(dataset::Dataset,
                       buffer::Array{T,3},
                       indices::Vector{Cint},
                       width::Integer,
                       height::Integer,
                       xoffset::Integer,
                       yoffset::Integer)
    checknull(dataset) && error("Can't read closed dataset")
    rasterio!(dataset, buffer, indices, width, height, xoffset, yoffset)
end

function fetch!{T <: Real, U <: Integer}(dataset::Dataset,
                                         buffer::Array{T,2},
                                         i::Integer,
                                         rows::UnitRange{U},
                                         cols::UnitRange{U})
    checknull(dataset) && error("Can't read closed dataset")
    rasterio!(fetchband(dataset, i), buffer, width, rows, cols)
end

function fetch!{T <: Real, U <: Integer}(dataset::Dataset,
                                         buffer::Array{T,3},
                                         indices::Vector{Cint},
                                         rows::UnitRange{U},
                                         cols::UnitRange{U})
    checknull(dataset) && error("Can't read closed dataset")
    rasterio!(dataset, buffer, indices, rows, cols)
end

function fetch(dataset::Dataset, i::Integer)
    checknull(dataset) && error("Can't read closed dataset")
    band = fetchband(dataset, i)
    buffer = Array(getdatatype(band), width(band), height(band))
    rasterio!(band, buffer)
end

function fetch(dataset::Dataset, indices::Vector{Cint})
    checknull(dataset) && error("Can't read closed dataset")
    buffer = Array(getdatatype(fetchband(dataset, indices[1])),
                   width(dataset), height(dataset), length(indices))
    rasterio!(dataset, buffer, indices)
end

function fetch(dataset::Dataset)
    checknull(dataset) && error("Can't read closed dataset")
    buffer = Array(getdatatype(fetchband(dataset, 1)),
                   width(dataset), height(dataset), nband(dataset))
    fetch!(dataset, buffer)
end

function fetch(dataset::Dataset,
               i::Integer,
               width::Integer,
               height::Integer,
               xoffset::Integer,
               yoffset::Integer)
    checknull(dataset) && error("Can't read closed dataset")
    band = fetchband(dataset, i)
    buffer = Array(getdatatype(band), width(band), height(band))
    rasterio!(band, buffer, width, height, xoffset, yoffset)
end

function fetch{T <: Integer}(dataset::Dataset,
                             indices::Vector{T},
                             width::Integer,
                             height::Integer,
                             xoffset::Integer,
                             yoffset::Integer)
    checknull(dataset) && error("Can't read closed dataset")
    buffer = Array(getdatatype(fetchband(dataset, indices[1])),
                   width(dataset), height(dataset), length(indices))
    rasterio!(dataset, buffer, indices, width, height, xoffset, yoffset)
end

function fetch{U <: Integer}(dataset::Dataset,
                             i::Integer,
                             rows::UnitRange{U},
                             cols::UnitRange{U})
    checknull(dataset) && error("Can't read closed dataset")
    band = fetchband(dataset, i)
    buffer = Array(getdatatype(band), width(band), height(band))
    rasterio!(band, buffer, rows, cols)
end

function fetch{U <: Integer}(dataset::Dataset,
                             indices::Vector{Cint},
                             rows::UnitRange{U},
                             cols::UnitRange{U})
    checknull(dataset) && error("Can't read closed dataset")
    buffer = Array(getdatatype(fetchband(dataset, indices[1])),
                   width(dataset), height(dataset), length(indices))
    rasterio!(dataset, buffer, indices, rows, cols)
end

function update!{T <: Real}(dataset::Dataset, buffer::Array{T,2}, i::Integer)
    checknull(dataset) && error("Can't write closed dataset")
    rasterio!(fetchband(dataset, i), buffer, GDAL.GF_Write)
end

function update!{T <: Real}(dataset::Dataset,
                            buffer::Array{T,3},
                            indices::Vector{Cint})
    checknull(dataset) && error("Can't write closed dataset")
    rasterio!(dataset, buffer, indices, GDAL.GF_Write)
end

function update!{T <: Real}(dataset::Dataset,
                            buffer::Array{T,2},
                            i::Integer,
                            width::Integer,
                            height::Integer,
                            xoffset::Integer,
                            yoffset::Integer)
    checknull(dataset) && error("Can't write closed dataset")
    rasterio!(fetchband(dataset, i), buffer, width, height,
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
    rasterio!(dataset, buffer, indices, width, height,
              xoffset, yoffset, GDAL.GF_Write)
end

function update!{T <: Real, U <: Integer}(dataset::Dataset,
                                          buffer::Array{T,2},
                                          i::Integer,
                                          rows::UnitRange{U},
                                          cols::UnitRange{U})
    checknull(dataset) && error("Can't write closed dataset")
    rasterio!(fetchband(dataset, i), buffer, rows, cols, GDAL.GF_Write)
end

function update!{T <: Real, U <: Integer}(dataset::Dataset,
                                          buffer::Array{T,3},
                                          indices::Vector{Cint},
                                          rows::UnitRange{U},
                                          cols::UnitRange{U})
    checknull(dataset) && error("Can't write closed dataset")
    rasterio!(dataset, buffer, indices, rows, cols, GDAL.GF_Write)
end