
"""
Delete named dataset.

The driver will attempt to delete the named dataset in a driver specific
fashion. Full featured drivers will delete all associated files, database
objects, or whatever is appropriate. The default behaviour when no driver
specific behaviour is provided is to attempt to delete the passed name as a
single file.

It is unwise to have open dataset handles on this dataset when it is deleted.
"""
delete(dataset::Ptr{GDAL.GDALDatasetH}, filename::AbstractString) =
    GDAL.deletedataset(dataset, filename)

"""
Rename a dataset.

This may including moving the dataset to a new directory or filesystem.

It is unwise to have open dataset handles on this dataset when it is being
renamed.
"""
rename(dataset::Ptr{GDAL.GDALDatasetH},
       newname::AbstractString,
       oldname::AbstractString) =
    GDAL.renamedataset(dataset, newname, oldname)

"Copy the files associated with a dataset."
copy(dataset::Ptr{GDAL.GDALDatasetH},
     newname::AbstractString,
     oldname::AbstractString) =
    GDAL.copydatasetfiles(dataset, newname, oldname)

"""
Copy all dataset raster data.

This function copies the complete raster contents of one dataset to another
similarly configured dataset. The source and destination dataset must have the
same number of bands, and the same width and height. The bands do not have to
have the same data type.

This function is primarily intended to support implementation of driver
specific `CreateCopy()` functions. It implements efficient copying, in
particular "chunking" the copy in substantial blocks and, if appropriate,
performing the transfer in a pixel interleaved fashion.

Currently the only papszOptions value supported are : "INTERLEAVE=PIXEL" to
force pixel interleaved operation and "COMPRESSED=YES" to force alignment on
target dataset block sizes to achieve best compression. More options may be
supported in the future.
"""
copy{T <: AbstractString}(source::Ptr{GDAL.GDALDatasetH},
                          dest::Ptr{GDAL.GDALDatasetH},
                          options::Vector{T},
                          progressfunc::GDAL.GDALProgressFunc,
                          progressdata::Ptr{Void}) =
    GDAL.datasetcopywholeraster(source, dest, Ptr{Ptr{UInt8}}(pointer(options)),
                                progressfunc, progressData)

"""
Create a copy of a dataset.

This method will attempt to create a copy of a raster dataset with the
indicated filename, and in this drivers format. Band number, size, type,
projection, geotransform and so forth are all to be copied from the
provided template dataset.

Note: many sequential write once formats (such as JPEG and PNG) don't implement
the `Create()` method but do implement this `CreateCopy()` method. If the
driver doesn't implement `CreateCopy()`, but does implement `Create()` then the
default `CreateCopy()` mechanism built on calling `Create()` will be used.

It is intended that `CreateCopy()` will often be used with a source dataset
which is a virtual dataset allowing configuration of band types, and other
information without actually duplicating raster data (see the VRT driver). This
is what is done by the gdal_translate utility for example.

This function will validate the creation option list passed to the driver
with the `GDALValidateCreationOptions()` method. This check can be disabled by
defining the configuration option `GDAL_VALIDATE_CREATION_OPTIONS=NO`.

After you have finished working with the returned dataset, it is required to
close it with `GDALClose()`. This does not only close the file handle, but also
ensures that all the data and metadata has been written to the dataset
(`GDALFlushCache()` is not sufficient for that purpose).

In some situations, the new dataset can be created in another process through
the GDAL API Proxy mechanism.

### Parameters
* `filename`      the name for the new dataset. UTF-8 encoded.
* `dataset`       the dataset being duplicated.
* `strict`        `TRUE` if the copy must be strictly equivelent, or more
normally `FALSE` if the copy may adapt as needed for the output format.
* `options`       additional format dependent options controlling creation
of the output file. `The APPEND_SUBDATASET=YES` option can be specified to
avoid prior destruction of existing dataset.
* `progressfunc`  function to be used to report progress of the copy.
* `progressdata`  application data passed into progress function.

### Returns
a pointer to the newly created dataset (may be read-only access).
"""
function createcopy(filename::AbstractString,
                    driver::Ptr{GDAL.GDALDriverH},
                    dataset::Ptr{GDAL.GDALDatasetH},
                    strict::Bool = false,
                    progressfunc::Ptr{GDAL.GDALProgressFunc} = Ptr{GDAL.GDALProgressFunc}(0),
                    progressdata::Ptr{Void} = C_NULL)
    GDAL.createcopy(driver, filename, dataset, strict,
                    Ptr{Ptr{UInt8}}(pointer(options)),
                    progressfunc, progressdata)
end

function createcopy{T <: AbstractString}(
                    filename::AbstractString,
                    driver::Ptr{GDAL.GDALDriverH},
                    dataset::Ptr{GDAL.GDALDatasetH},
                    options::Vector{T},
                    strict::Bool = false,
                    progressfunc::Ptr{GDAL.GDALProgressFunc} = Ptr{GDAL.GDALProgressFunc}(0),
                    progressdata::Ptr{Void} = C_NULL)
    GDAL.createcopy(driver, filename, dataset, strict, C_NULL,
                    progressfunc, progressdata)
end

"""
Open a raster file as a GDALDataset.

This function will try to open the passed file, or virtual dataset name by
invoking the Open method of each registered `GDALDriver` in turn. The first
successful open will result in a returned dataset. If all drivers fail then
`NULL` is returned and an error is issued.

Several recommendations:

If you open a dataset object with `GA_Update` access, it is not recommended to
open a new dataset on the same underlying file. The returned dataset should
only be accessed by one thread at a time. To use it from different threads,
you must add all necessary code (mutexes, etc.) to avoid concurrent use of the
object. (Some drivers, such as GeoTIFF, maintain internal state variables that
are updated each time a new block is read, preventing concurrent use.)

Starting with GDAL 1.6.0, if `GDALOpenShared()` is called on the same
`pszFilename` from two different threads, a different `GDALDataset` object will
be returned as it is not safe to use the same dataset from different threads,
unless the user does explicitly use mutexes in its code.

For drivers supporting the VSI virtual file API, it is possible to open a file
in a `.zip` archive (see `VSIInstallZipFileHandler()`), a `.tar/.tar.gz/.tgz`
archive (see `VSIInstallTarFileHandler()`), or a HTTP / FTP server
(see `VSIInstallCurlFileHandler()`)

In some situations (dealing with unverified data), the datasets can be opened
in another process through the GDAL API Proxy mechanism.

See also: `GDALOpenShared()`, `GDALOpenEx()`

### Parameters
* `filename`  the name of the file to access. In the case of exotic drivers
this may not refer to a physical file, but instead contain information for the
driver on how to access a dataset. It should be in UTF-8 encoding.
* `access`      the desired access, either `GA_Update` or `GA_ReadOnly`. Many
drivers support only read only access.
"""
function open(filename::AbstractString,
              access::GDAL.GDALAccess=GDAL.GA_ReadOnly,
              shared::Bool = false)
    if shared
        dataset = GDAL.openshared(filename, access)
    else
        dataset = GDAL.open(filename, access)
    end
    dataset
end

"""
Close GDAL dataset.

For non-shared datasets (opened with `GDALOpen()`) the dataset is closed
using the C++ "delete" operator, recovering all dataset related resources.

For shared datasets (opened with `GDALOpenShared()`) the dataset is
dereferenced, and closed only if the referenced count has dropped below 1.
"""
closedataset(dataset::Ptr{GDAL.GDALDatasetH}) = GDAL.close(dataset)

"Fetch raster width in pixels."
width(dataset::Ptr{GDAL.GDALDatasetH}) = GDAL.getrasterxsize(dataset)

"Fetch raster height in pixels."
height(dataset::Ptr{GDAL.GDALDatasetH}) = GDAL.getrasterysize(dataset)

"Fetch the number of raster bands on this dataset."
nband(dataset::Ptr{GDAL.GDALDatasetH}) = GDAL.getrastercount(dataset)

"Fetch a band object for a dataset from its index"
fetchband(dataset::Ptr{GDAL.GDALDatasetH}, i::Integer) = GDAL.getrasterband(dataset, i)

"""
Add a band to a dataset.

This method will add a new band to the dataset if the underlying format
supports this action. Most formats do not.

Note that the new `GDALRasterBand` is not returned. It may be fetched after
successful completion of the method through `GetRasterBand(GetRasterCount())`
as the newest band will always be the last band.

### Parameters
* `eType`           the data type of the pixels in the new band.
* `options`    a list of NAME=VALUE option strings. The supported options
are format specific. `NULL` may be passed by default.
"""
addband(dataset::Ptr{GDAL.GDALDatasetH},
        eType::GDAL.GDALDataType) = GDAL.addband(dataset, eType, C_NULL)

addband{T <: AbstractString}(dataset::Ptr{GDAL.GDALDatasetH},
                             eType::GDAL.GDALDataType,
                             options::Vector{T}) =
    GDAL.addband(dataset, eType, Ptr{Ptr{UInt8}}(pointer(options)))

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
            dataset::Ptr{GDAL.GDALDatasetH},
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
    GDAL.datasetrasterio(dataset, access, xoffset, yoffset, _width, _height,
                      pointer(buffer), xsize, ysize, _gdaltype(T), _nband,
                      pointer(bands), nPixelSpace, nLineSpace, nBandSpace)
    buffer
end

function rasterio!{T <: Real}(
            dataset::Ptr{GDAL.GDALDatasetH},
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
            dataset::Ptr{GDAL.GDALDatasetH},
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

# "Fetch a format specific internally meaningful handle."
# _getinternalhandle(dataset::GDALDatasetH, request::Ptr{UInt8}) =
#     GDALGetInternalHandle(dataset, request)::Ptr{Void}

# """
# Add one to dataset reference count. The reference is one after instantiation.

# ### Returns
# the post-increment reference count.
# """
# _referencedataset(dataset::GDALDatasetH) = GDALReferenceDataset(dataset)::Cint

# """
# Subtract one from dataset reference count. The reference is one after
# instantiation. Generally when the reference count has dropped to zero the
# dataset may be safely deleted (closed).

# ### Returns
# the post-decrement reference count.
# """
# _dereferencedataset(dataset::GDALDatasetH) =
#     GDALDereferenceDataset(dataset)::Cint

# """
# Build raster overview(s).

# If the operation is unsupported for the indicated dataset, then CE_Failure is
# returned, and CPLGetLastErrorNo() will return CPLE_NotSupported.

# ### Parameters
# * `pszResampling`   one of "NEAREST", "GAUSS", "CUBIC", "AVERAGE", "MODE",
# "AVERAGE_MAGPHASE" or "NONE" controlling the downsampling method applied.
# * `nOverviews`      number of overviews to build.
# * `panOverviewList` the list of overview decimation factors to build.
# * `nListBands`      number of bands to build overviews for in `panBandList`.
# Build for all bands if this is 0.
# * `panBandList`     list of band numbers.
# * `pfnProgress`     a function to call to report progress, or `NULL`.
# * `pProgressData`   application data to pass to the progress function.

# ### Returns
# `CE_None` on success or `CE_Failure` if the operation doesn't work.

# For example, to build overview level 2, 4 and 8 on all bands the following
# call could be made:

# ```C
#    int       anOverviewList[3] = { 2, 4, 8 };
#    poDataset->BuildOverviews( "NEAREST", 3, anOverviewList, 0, NULL, 
#                               GDALDummyProgress, NULL );
# ```
# """
# _buildoverviews(arg1::GDALDatasetH,
#                 pszResampling::Ptr{UInt8},
#                 nOverviews::Integer,
#                 panOverviewList::Ptr{Cint},
#                 nListBands::Integer,
#                 panBandList::Ptr{Cint},
#                 pfnProgress::GDALProgressFunc,
#                 pProgressData::Ptr{Void}) =
#     GDALBuildOverviews(pszResampling, nOverviews, panOverviewList, nListBands,
#                        panBandList, pfnProgress, pProgressData)::CPLErr

# function buildoverviews(hDS::GDALDatasetH,
#                         resampling::ASCIIString,
#                         overviewlist::Vector{Cint},
#                         bandList::Vector{Cint})
#     result = _buildoverviews(hDS, pointer(resampling),
#                              length(overviewlist),
#                              pointer(overviewlist),
#                              length(bandlist),
#                              pointer(bandlist),
#                              C_NULL, C_NULL)
#     (result == CE_Failure) && error("Failed to build overviews")
# end

# """
# Fetch all open GDAL dataset handles.

# NOTE: This method is not thread safe. The returned list may change at any time
# and it should not be freed.

# ### Parameters
# * `pnCount`     integer into which to place the count of dataset pointers being
# returned.

# ### Returns
# a pointer to an array of dataset handles.
# """
# opendatasets(hDS::Ptr{Ptr{GDALDatasetH}}, pnCount::Ptr{Cint}) = 
#     GDALGetOpenDatasets(hdS, pnCount)

# """
# Adds a mask band to the dataset.

# The default implementation of the `CreateMaskBand()` method is implemented
# based on similar rules to the .ovr handling implemented using the
# `GDALDefaultOverviews` object. A TIFF file with the extension .msk will be
# created with the same basename as the original file, and it will have one band.
# The mask images will be deflate compressed tiled images with the same block
# size as the original image if possible.

# If you got a mask band with a previous call to `GetMaskBand()`, it might be
# invalidated by CreateMaskBand(). So you have to call `GetMaskBand()` again.

# See also: http://trac.osgeo.org/gdal/wiki/rfc15_nodatabitmask

# ### Parameters
# * `nFlags`  ignored. `GMF_PER_DATASET` will be assumed.

# ### Returns
# `CE_None` on success or `CE_Failure` on an error.
# """
# _createdatasetmaskband(hDS::GDALDatasetH,
#                        nFlags::Integer = GMF_PER_DATASET) =
#     GDALCreateDatasetMaskBand(hDS, nFlags)::CPLErr

# function createdatasetmaskband(hDS::GDALDatasetH)
#     result = _createdatasetmaskband(hDS)
#     (result == CE_Failure) && error("Failed to create dataset mask band")
# end
