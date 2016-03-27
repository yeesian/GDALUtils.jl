
"""
Fetch the "natural" block size of this band.

GDAL contains a concept of the natural block size of rasters so that
applications can organized data access efficiently for some file formats.
The natural block size is the block size that is most efficient for accessing
the format. For many formats this is simple a whole scanline in which case
`*pnXSize` is set to `GetXSize()`, and *pnYSize is set to 1.

However, for tiled images this will typically be the tile size.

Note that the X and Y block sizes don't have to divide the image size evenly,
meaning that right and bottom edge blocks may be incomplete. See `ReadBlock()`
for an example of code dealing with these issues.
"""
function getblocksize(rasterband::RasterBand)
    xy = Array(Cint, 2); x = pointer(xy); y = x + sizeof(Cint)
    GDAL.getblocksize(rasterband.ptr, x, y)
    xy
end

"Fetch the pixel data type for this band."
getdatatype(rasterband::RasterBand) =
    _jltype[GDAL.getrasterdatatype(rasterband.ptr)]

"Fetch the width in pixels of this band."
width(rasterband::RasterBand) = GDAL.getrasterbandxsize(rasterband.ptr)

"Fetch the height in pixels of this band."
height(rasterband::RasterBand) = GDAL.getrasterbandysize(rasterband.ptr)

"Find out if we have update permission for this band."
getaccess(rasterband::RasterBand) = GDAL.getrasteraccess(rasterband.ptr)


"Fetch a band object for a dataset from its index"
fetchband(dataset::Dataset, i::Integer) =
    RasterBand(GDAL.getrasterband(dataset.ptr, i))

"""Fetch the band number (1+) within its dataset, or 0 if unknown.

This method may return a value of 0 to indicate overviews, or free-standing
`GDALRasterBand` objects without a relationship to a dataset.
"""
indexof(rasterband::RasterBand) = GDAL.getbandnumber(rasterband.ptr)

"""
Fetch the handle to its dataset handle, or `NULL` if this cannot be determined.

Note that some `GDALRasterBands` are not considered to be a part of a dataset,
such as overviews or other "freestanding" bands.
"""
getdataset(rasterband::RasterBand) =
    Dataset(GDAL.getbanddataset(rasterband.ptr))

"""
Return raster unit type.

Return a name for the units of this raster's values. For instance, it might be
"m" for an elevation model in meters, or "ft" for feet.
"""
getunittype(rasterband::RasterBand) = GDAL.getrasterunittype(rasterband.ptr)

"Set unit type."
setunittype(rasterband::RasterBand, unitstring::AbstractString) =
    GDAL.setrasterunittype(rasterband.ptr, unitstring)

"""
Fetch the raster value offset.

This (in combination with `GetScale()`) is used to transform raw pixel values
into the units returned by `GetUnits()`. For e.g. this might be used to store
elevations in `GUInt16` bands with a precision of 0.1, starting from -100.

    Units value = (raw value * scale) + offset

For file formats that don't know this intrinsically, a value of 0 is returned.
"""
getoffset(rasterband::RasterBand) =
    GDAL.getrasteroffset(rasterband.ptr, C_NULL)

"Set scaling offset."
setoffset(rasterband::RasterBand, offset::Cdouble) =
    GDAL.setrasteroffset(band.ptr, offset)

"""
Fetch the raster value scale.

This value (in combination with the `GetOffset()` value) is used to transform
raw pixel values into the units returned by `GetUnits()`. For example this
might be used to store elevations in GUInt16 bands with a precision of 0.1,
and starting from -100.

    Units value = (raw value * scale) + offset

For file formats that don't know this intrinsically a value of one is returned.
"""
getscale(rasterband::RasterBand) = GDAL.getrasterscale(rasterband.ptr, C_NULL)

"Set scaling ratio."
setscale(rasterband::RasterBand, scale::Cdouble) =
    GDAL.setrasterscale(rasterband.ptr, scale)

"""
Fetch the no data value for this band.

If there is no out of data value, an out of range value will generally be
returned. The no data value for a band is generally a special marker value
used to mark pixels that are not valid data. Such pixels should generally
not be displayed, nor contribute to analysis operations.

### Parameters
* `pbSuccess`   pointer to a boolean to use to indicate if a value is actually
associated with this layer. May be `NULL` (default).

### Returns
the nodata value for this band.
"""
getnodatavalue(rasterband::RasterBand) =
    GDAL.getrasternodatavalue(rasterband.ptr, C_NULL)

"Set the no data value for this band."
function setnodatavalue(rasterband::RasterBand, value::Real)
    result = GDAL.setrasternodatavalue(rasterband.ptr, value)
    (result == GDAL.CE_Failure) && error("Could not set nodatavalue")
end

# """
#     GDALDeleteRasterNoDataValue(GDALRasterBandH hBand) -> CPLErr
# Remove the no data value for this band.
# """
# function deleterasternodatavalue{T <: GDALRasterBandH}(arg1::Ptr{T})
#     ccall((:GDALDeleteRasterNoDataValue,libgdal),CPLErr,(Ptr{GDALRasterBandH},),arg1)
# end


# """
#     GDALGetRasterCategoryNames(GDALRasterBandH hBand) -> char **
# Fetch the list of category names for this raster.
# """
# function getrastercategorynames{T <: GDALRasterBandH}(arg1::Ptr{T})
#     bytestring(unsafe_load(ccall((:GDALGetRasterCategoryNames,libgdal),Ptr{Cstring},(Ptr{GDALRasterBandH},),arg1)))
# end


# """
#     GDALSetRasterCategoryNames(GDALRasterBandH hBand,
#                                char ** papszNames) -> CPLErr
# Set the category names for this band.
# """
# function setrastercategorynames{T <: GDALRasterBandH}(arg1::Ptr{T},arg2)
#     ccall((:GDALSetRasterCategoryNames,libgdal),CPLErr,(Ptr{GDALRasterBandH},Ptr{Cstring}),arg1,arg2)
# end


# """
#     GDALGetRasterMinimum(GDALRasterBandH hBand,
#                          int * pbSuccess) -> double
# Fetch the minimum value for this band.
# """
# function getrasterminimum{T <: GDALRasterBandH}(arg1::Ptr{T},pbSuccess)
#     ccall((:GDALGetRasterMinimum,libgdal),Cdouble,(Ptr{GDALRasterBandH},Ptr{Cint}),arg1,pbSuccess)
# end


# """
#     GDALGetRasterMaximum(GDALRasterBandH hBand,
#                          int * pbSuccess) -> double
# Fetch the maximum value for this band.
# """
# function getrastermaximum{T <: GDALRasterBandH}(arg1::Ptr{T},pbSuccess)
#     ccall((:GDALGetRasterMaximum,libgdal),Cdouble,(Ptr{GDALRasterBandH},Ptr{Cint}),arg1,pbSuccess)
# end


# """
#     GDALGetRasterStatistics(GDALRasterBandH hBand,
#                             int bApproxOK,
#                             int bForce,
#                             double * pdfMin,
#                             double * pdfMax,
#                             double * pdfMean,
#                             double * pdfStdDev) -> CPLErr
# Fetch image statistics.
# """
# function getrasterstatistics{T <: GDALRasterBandH}(arg1::Ptr{T},bApproxOK::Integer,bForce::Integer,pdfMin,pdfMax,pdfMean,pdfStdDev)
#     ccall((:GDALGetRasterStatistics,libgdal),CPLErr,(Ptr{GDALRasterBandH},Cint,Cint,Ptr{Cdouble},Ptr{Cdouble},Ptr{Cdouble},Ptr{Cdouble}),arg1,bApproxOK,bForce,pdfMin,pdfMax,pdfMean,pdfStdDev)
# end


# """
#     GDALComputeRasterStatistics(GDALRasterBandH hBand,
#                                 int bApproxOK,
#                                 double * pdfMin,
#                                 double * pdfMax,
#                                 double * pdfMean,
#                                 double * pdfStdDev,
#                                 GDALProgressFunc pfnProgress,
#                                 void * pProgressData) -> CPLErr
# Compute image statistics.
# """
# function computerasterstatistics{T <: GDALRasterBandH}(arg1::Ptr{T},bApproxOK::Integer,pdfMin,pdfMax,pdfMean,pdfStdDev,pfnProgress::Ptr{GDALProgressFunc},pProgressData)
#     ccall((:GDALComputeRasterStatistics,libgdal),CPLErr,(Ptr{GDALRasterBandH},Cint,Ptr{Cdouble},Ptr{Cdouble},Ptr{Cdouble},Ptr{Cdouble},Ptr{GDALProgressFunc},Ptr{Void}),arg1,bApproxOK,pdfMin,pdfMax,pdfMean,pdfStdDev,pfnProgress,pProgressData)
# end


# """
#     GDALSetRasterStatistics(GDALRasterBandH hBand,
#                             double dfMin,
#                             double dfMax,
#                             double dfMean,
#                             double dfStdDev) -> CPLErr
# Set statistics on band.
# """
# function setrasterstatistics{T <: GDALRasterBandH}(hBand::Ptr{T},dfMin::Real,dfMax::Real,dfMean::Real,dfStdDev::Real)
#     ccall((:GDALSetRasterStatistics,libgdal),CPLErr,(Ptr{GDALRasterBandH},Cdouble,Cdouble,Cdouble,Cdouble),hBand,dfMin,dfMax,dfMean,dfStdDev)
# end

# """
#     GDALComputeRasterMinMax(GDALRasterBandH hBand,
#                             int bApproxOK,
#                             double adfMinMax) -> void
# Compute the min/max values for a band.
# """
# function computerasterminmax{T <: GDALRasterBandH}(hBand::Ptr{T},bApproxOK::Integer,adfMinMax::Array_2_Cdouble)
#     ccall((:GDALComputeRasterMinMax,libgdal),Void,(Ptr{GDALRasterBandH},Cint,Array_2_Cdouble),hBand,bApproxOK,adfMinMax)
# end

# """
#     GDALGetRasterHistogram(GDALRasterBandH hBand,
#                            double dfMin,
#                            double dfMax,
#                            int nBuckets,
#                            int * panHistogram,
#                            int bIncludeOutOfRange,
#                            int bApproxOK,
#                            GDALProgressFunc pfnProgress,
#                            void * pProgressData) -> CPLErr
# Compute raster histogram.
# """
# function getrasterhistogram{T <: GDALRasterBandH}(hBand::Ptr{T},dfMin::Real,dfMax::Real,nBuckets::Integer,panHistogram,bIncludeOutOfRange::Integer,bApproxOK::Integer,pfnProgress::Ptr{GDALProgressFunc},pProgressData)
#     ccall((:GDALGetRasterHistogram,libgdal),CPLErr,(Ptr{GDALRasterBandH},Cdouble,Cdouble,Cint,Ptr{Cint},Cint,Cint,Ptr{GDALProgressFunc},Ptr{Void}),hBand,dfMin,dfMax,nBuckets,panHistogram,bIncludeOutOfRange,bApproxOK,pfnProgress,pProgressData)
# end


# """
#     GDALGetRasterHistogramEx(GDALRasterBandH hBand,
#                              double dfMin,
#                              double dfMax,
#                              int nBuckets,
#                              GUIntBig * panHistogram,
#                              int bIncludeOutOfRange,
#                              int bApproxOK,
#                              GDALProgressFunc pfnProgress,
#                              void * pProgressData) -> CPLErr
# Compute raster histogram.
# """
# function getrasterhistogramex{T <: GDALRasterBandH}(hBand::Ptr{T},dfMin::Real,dfMax::Real,nBuckets::Integer,panHistogram,bIncludeOutOfRange::Integer,bApproxOK::Integer,pfnProgress::Ptr{GDALProgressFunc},pProgressData)
#     ccall((:GDALGetRasterHistogramEx,libgdal),CPLErr,(Ptr{GDALRasterBandH},Cdouble,Cdouble,Cint,Ptr{GUIntBig},Cint,Cint,Ptr{GDALProgressFunc},Ptr{Void}),hBand,dfMin,dfMax,nBuckets,panHistogram,bIncludeOutOfRange,bApproxOK,pfnProgress,pProgressData)
# end


# """
#     GDALGetDefaultHistogram(GDALRasterBandH hBand,
#                             double * pdfMin,
#                             double * pdfMax,
#                             int * pnBuckets,
#                             int ** ppanHistogram,
#                             int bForce,
#                             GDALProgressFunc pfnProgress,
#                             void * pProgressData) -> CPLErr
# Fetch default raster histogram.
# """
# function getdefaulthistogram{T <: GDALRasterBandH}(hBand::Ptr{T},pdfMin,pdfMax,pnBuckets,ppanHistogram,bForce::Integer,pfnProgress::Ptr{GDALProgressFunc},pProgressData)
#     ccall((:GDALGetDefaultHistogram,libgdal),CPLErr,(Ptr{GDALRasterBandH},Ptr{Cdouble},Ptr{Cdouble},Ptr{Cint},Ptr{Ptr{Cint}},Cint,Ptr{GDALProgressFunc},Ptr{Void}),hBand,pdfMin,pdfMax,pnBuckets,ppanHistogram,bForce,pfnProgress,pProgressData)
# end


# """
#     GDALGetDefaultHistogramEx(GDALRasterBandH hBand,
#                               double * pdfMin,
#                               double * pdfMax,
#                               int * pnBuckets,
#                               GUIntBig ** ppanHistogram,
#                               int bForce,
#                               GDALProgressFunc pfnProgress,
#                               void * pProgressData) -> CPLErr
# Fetch default raster histogram.
# """
# function getdefaulthistogramex{T <: GDALRasterBandH}(hBand::Ptr{T},pdfMin,pdfMax,pnBuckets,ppanHistogram,bForce::Integer,pfnProgress::Ptr{GDALProgressFunc},pProgressData)
#     ccall((:GDALGetDefaultHistogramEx,libgdal),CPLErr,(Ptr{GDALRasterBandH},Ptr{Cdouble},Ptr{Cdouble},Ptr{Cint},Ptr{Ptr{GUIntBig}},Cint,Ptr{GDALProgressFunc},Ptr{Void}),hBand,pdfMin,pdfMax,pnBuckets,ppanHistogram,bForce,pfnProgress,pProgressData)
# end


# """
#     GDALSetDefaultHistogram(GDALRasterBandH hBand,
#                             double dfMin,
#                             double dfMax,
#                             int nBuckets,
#                             int * panHistogram) -> CPLErr
# Set default histogram.
# """
# function setdefaulthistogram{T <: GDALRasterBandH}(hBand::Ptr{T},dfMin::Real,dfMax::Real,nBuckets::Integer,panHistogram)
#     ccall((:GDALSetDefaultHistogram,libgdal),CPLErr,(Ptr{GDALRasterBandH},Cdouble,Cdouble,Cint,Ptr{Cint}),hBand,dfMin,dfMax,nBuckets,panHistogram)
# end


# """
#     GDALSetDefaultHistogramEx(GDALRasterBandH hBand,
#                               double dfMin,
#                               double dfMax,
#                               int nBuckets,
#                               GUIntBig * panHistogram) -> CPLErr
# Set default histogram.
# """
# function setdefaulthistogramex{T <: GDALRasterBandH}(hBand::Ptr{T},dfMin::Real,dfMax::Real,nBuckets::Integer,panHistogram)
#     ccall((:GDALSetDefaultHistogramEx,libgdal),CPLErr,(Ptr{GDALRasterBandH},Cdouble,Cdouble,Cint,Ptr{GUIntBig}),hBand,dfMin,dfMax,nBuckets,panHistogram)
# end


# """
#     GDALGetRandomRasterSample(GDALRasterBandH,
#                               int,
#                               float *) -> int
# """
# function getrandomrastersample{T <: GDALRasterBandH}(arg1::Ptr{T},arg2::Integer,arg3)
#     ccall((:GDALGetRandomRasterSample,libgdal),Cint,(Ptr{GDALRasterBandH},Cint,Ptr{Cfloat}),arg1,arg2,arg3)
# end

# """
#     GDALComputeBandStats(GDALRasterBandH hBand,
#                          int nSampleStep,
#                          double * pdfMean,
#                          double * pdfStdDev,
#                          GDALProgressFunc pfnProgress,
#                          void * pProgressData) -> CPLErr
# """
# function computebandstats{T <: GDALRasterBandH}(hBand::Ptr{T},nSampleStep::Integer,pdfMean,pdfStdDev,pfnProgress::Ptr{GDALProgressFunc},pProgressData)
#     ccall((:GDALComputeBandStats,libgdal),CPLErr,(Ptr{GDALRasterBandH},Cint,Ptr{Cdouble},Ptr{Cdouble},Ptr{GDALProgressFunc},Ptr{Void}),hBand,nSampleStep,pdfMean,pdfStdDev,pfnProgress,pProgressData)
# end


# """
#     GDALOverviewMagnitudeCorrection(GDALRasterBandH hBaseBand,
#                                     int nOverviewCount,
#                                     GDALRasterBandH * pahOverviews,
#                                     GDALProgressFunc pfnProgress,
#                                     void * pProgressData) -> CPLErr
# """
# function overviewmagnitudecorrection{T <: GDALRasterBandH}(hBaseBand::Ptr{T},nOverviewCount::Integer,pahOverviews,pfnProgress::Ptr{GDALProgressFunc},pProgressData)
#     ccall((:GDALOverviewMagnitudeCorrection,libgdal),CPLErr,(Ptr{GDALRasterBandH},Cint,Ptr{GDALRasterBandH},Ptr{GDALProgressFunc},Ptr{Void}),hBaseBand,nOverviewCount,pahOverviews,pfnProgress,pProgressData)
# end


# """
#     GDALGetDefaultRAT(GDALRasterBandH hBand) -> GDALRasterAttributeTableH
# Fetch default Raster Attribute Table.
# """
# function getdefaultrat{T <: GDALRasterBandH}(hBand::Ptr{T})
#     checknull(ccall((:GDALGetDefaultRAT,libgdal),Ptr{GDALRasterAttributeTableH},(Ptr{GDALRasterBandH},),hBand))
# end


# """
#     GDALSetDefaultRAT(GDALRasterBandH hBand,
#                       GDALRasterAttributeTableH hRAT) -> CPLErr
# Set default Raster Attribute Table.
# """
# function setdefaultrat{T <: GDALRasterBandH}(arg1::Ptr{T},arg2::Ptr{GDALRasterAttributeTableH})
#     ccall((:GDALSetDefaultRAT,libgdal),CPLErr,(Ptr{GDALRasterBandH},Ptr{GDALRasterAttributeTableH}),arg1,arg2)
# end


# """
#     GDALAddDerivedBandPixelFunc(const char * pszName,
#                                 GDALDerivedPixelFunc pfnPixelFunc) -> CPLErr
# This adds a pixel function to the global list of available pixel functions for derived bands.
# ### Parameters
# * **pszFuncName**: Name used to access pixel function
# * **pfnNewFunction**: Pixel function associated with name. An existing pixel function registered with the same name will be replaced with the new one.
# ### Returns
# CE_None, invalid (NULL) parameters are currently ignored.
# """
# function addderivedbandpixelfunc(pszName,pfnPixelFunc::Ptr{GDALDerivedPixelFunc})
#     ccall((:GDALAddDerivedBandPixelFunc,libgdal),CPLErr,(Cstring,Ptr{GDALDerivedPixelFunc}),pszName,pfnPixelFunc)
# end


"""
Copy all raster band raster data.

This function copies the complete raster contents of one band to another
similarly configured band. The source and destination bands must have the same
width and height. The bands do not have to have the same data type.

It implements efficient copying, in particular "chunking" the copy in
substantial blocks.

Currently the only `papszOptions` value supported is : "COMPRESSED=YES" to
force alignment on target dataset block sizes to achieve best compression.
More options may be supported in the future.

### Parameters
* `hSrcBand`        the source band
* `hDstBand`        the destination band
* `papszOptions`    transfer hints in "StringList" Name=Value format.
* `pfnProgress`     progress reporting function.
* `pProgressData`   callback data for progress function.

### Returns
`CE_None` on success, or `CE_Failure` on failure.
"""
copywholeraster(source::RasterBand, dest::RasterBand, options) =
    GDAL.rasterbandcopywholeraster(source.ptr, dest.ptr, pointer(options))

copywholeraster(source::RasterBand, dest::RasterBand) =
    GDAL.rasterbandcopywholeraster(source.ptr, dest.ptr, C_NULL,C_NULL,C_NULL)

"""
Return the number of overview layers available.

### Returns
overview count, zero if none.
"""
noverview(rasterband::RasterBand) = GDAL.getoverviewcount(rasterband.ptr)

"Fetch overview raster band object."
fetchoverview(rasterband::RasterBand, i::Integer) =
    RasterBand(GDAL.getoverview(rasterband.ptr, i-1))

"""
Fetch best overview satisfying `nsamples` number of samples.

Returns the most reduced overview of the given band that still satisfies the
desired number of samples `nsamples`. This function can be used with zero as the
number of desired samples to fetch the most reduced overview. The same band as was
passed in will be returned if it has not overviews, or if none of the overviews
have enough samples.
"""
getsampleoverview(rasterband::RasterBand, nsamples::Integer) =
    RasterBand(GDAL.getrastersampleoverview(rasterband.ptr, nsamples))

# """
#     GDALGetRasterSampleOverviewEx(GDALRasterBandH hBand,
#                                   GUIntBig nDesiredSamples) -> GDALRasterBandH
# Fetch best sampling overview.
# """
# function getrastersampleoverviewex{T <: GDALRasterBandH}(arg1::Ptr{T},arg2::GUIntBig)
#     checknull(ccall((:GDALGetRasterSampleOverviewEx,libgdal),Ptr{GDALRasterBandH},(Ptr{GDALRasterBandH},GUIntBig),arg1,arg2))
# end

"Color Interpretation value for band"
getcolorinterp(rasterband::RasterBand) =
    GDAL.getrastercolorinterpretation(rasterband.ptr)

"Set color interpretation of a band."
setcolorinterp(rasterband::RasterBand, color::GDAL.GDALColorInterp) =
    GDAL.setrastercolorinterpretation(rasterband.ptr, color)

"""
Fetch the color table associated with band.

If there is no associated color table, the return result is `NULL`. The
returned color table remains owned by the `GDALRasterBand`, and can't be
depended on for long, nor should it ever be modified by the caller.
"""
getcolortable(rasterband::RasterBand) =
    GDAL.getrastercolortable(rasterband.ptr)

"""
Set the raster color table.

The driver will make a copy of all desired data in the colortable. It remains
owned by the caller after the call.

### Parameters
* `poCT`    the color table to apply. This may be NULL to clear the color table
(where supported).

### Returns
`CE_None` on success, or `CE_Failure` on failure. If the action is unsupported
by the driver, a value of `CE_Failure` is returned, but no error is issued.
"""
setcolortable(rasterband::RasterBand, colortable::Ptr{GDAL.GDALColorTableH}) =
    GDAL.setrastercolortable(rasterband.ptr, colortable)

clearcolortable(rasterband::RasterBand) =
    GDAL.setrastercolortable(rasterband.ptr, C_NULL)

"""
Generate downsampled overviews.

This function will generate one or more overview images from a base image using
the requested downsampling algorithm. Its primary use is for generating
overviews via BuildOverviews(), but it can also be used to generate downsampled
images in one file from another outside the overview architecture.

The output bands need to exist in advance.

This function will honour properly `NODATA_VALUES` tuples (special dataset
metadata) so that only a given RGB triplet (in case of a RGB image) will be
considered as the nodata value and not each value of the triplet independantly
per band.

### Parameters
* `hSrcBand`        the source (base level) band.
* `nOverviewCount`  the number of downsampled bands being generated.
* `pahOvrBands`     the list of downsampled bands to be generated.
* `pszResampling`   Resampling algorithm (eg. "AVERAGE").
* `pfnProgress`     progress report function.
* `pProgressData`   progress function callback data.

### Returns
`CE_None` on success or `CE_Failure` on failure.
"""
function regenerateoverviews(rasterband::RasterBand,
                             noverviews::Integer,
                             overviewbands::Vector{Ptr{GDAL.GDALRasterBandH}},
                             resampling::AbstractString = "NEAREST")
    result = GDAL.regenerateoverviews(rasterband.ptr, noverviews, overviewbands,
                                      resampling,
                                      Ptr{GDAL.GDALProgressFunc}(C_NULL),
                                      C_NULL)
    (result == GDAL.CE_Failure) && error("Failed to regenerate overviews")
end

# "Advise driver of upcoming read requests."
# _rasteradviseread(hRB::GDALRasterBandH,
#                   nDSXOff::Integer,
#                   nDSYOff::Integer,
#                   nDSXSize::Integer,
#                   nDSYSize::Integer,
#                   nBXSize::Integer,
#                   nBYSize::Integer,
#                   eBDataType::GDALDataType,
#                   papszOptions::Ptr{Ptr{UInt8}}) =
#     GDALRasterAdviseRead(hRB, nDSXOff, nDSYOff, nDSXSize, nDSYSize, nBXSize,
#                          nBYSize, eBDataType, papszOptions)::CPLErr

"""
Read a block of image data efficiently.

This method accesses a "natural" block from the raster band without resampling,
or data type conversion. For a more generalized, but potentially less efficient
access use RasterIO().

See the `GetLockedBlockRef()` method for a way of accessing internally cached
block oriented data without an extra copy into an application buffer.

### Parameters
* `nXBlockOff`  the horizontal block offset, with zero indicating the left most
block, 1 the next block and so forth.
* `nYBlockOff`  the vertical block offset, with zero indicating the left most
block, 1 the next block and so forth.
* `pImage`      the buffer into which the data will be read. The buffer must be
large enough to hold `GetBlockXSize()*GetBlockYSize()` words of type
`GetRasterDataType()`.

### Returns
`CE_None` on success or `CE_Failure` on an error.
"""
function readblock!(band::RasterBand, nxoff::Integer, nyoff::Integer,
                    buffer::Array)
    result = GDAL.readblock(band.ptr, nxoff, nyoff, pointer(buffer))
    (result != GDAL.CE_None) && error("Failed to read block")
    buffer
end

"""
Write a block of image data efficiently.

This method accesses a "natural" block from the raster band without resampling,
or data type conversion. For a more generalized, but potentially less efficient
access use `RasterIO()`.

See `ReadBlock()` for an example of block oriented data access.

### Parameters
* `nXBlockOff`  the horizontal block offset, with zero indicating the left most
block, 1 the next block and so forth.
* `nYBlockOff`  the vertical block offset, with zero indicating the left most
block, 1 the next block and so forth.
* `pImage`      the buffer from which the data will be written. The buffer must
be large enough to hold `GetBlockXSize()*GetBlockYSize()` words of type
`GetRasterDataType()`.

### Returns
`CE_None` on success or `CE_Failure` on an error.
"""
function writeblock!(band::RasterBand, nxoff::Integer, nyoff::Integer,
                     image::Array)
    result = GDAL.writeblock(band.ptr, nxoff, nyoff, pointer(image))
    (result != GDAL.CE_None) && error("Failed to write block")
    image
end

"""
Check for arbitrary overviews.

This returns `TRUE` if the underlying datastore can compute arbitrary overviews
efficiently, e.g. with OGDI over a network. Datastores with arbitrary overviews
don't generally have any fixed overviews, but the `RasterIO()` method can be
used in downsampling mode to get overview data efficiently.

### Returns
`TRUE` if arbitrary overviews available (efficiently), otherwise `FALSE`.
"""
hasarbitraryoverviews(band::RasterBand) =
    Bool(GDAL.hasarbitraryoverviews(band.ptr))

"""
Fetch the list of category names for this raster.

The return list is a "StringList" in the sense of the CPL functions. That is a
NULL terminated array of strings. Raster values without associated names will
have an empty string in the returned list. The first entry in the list is for
raster values of zero, and so on.

The returned stringlist should not be altered or freed by the application.
It may change on the next GDAL call, so please copy it if it is needed for any
period of time.

### Returns
list of names, or `NULL` if none.
"""
getcategorynames(band::RasterBand) =
    loadstringlist(GDAL.C.GDALGetRasterCategoryNames(band.ptr))

"Set the category names for this band."
function setrastercategorynames(band::RasterBand, names::Vector{ASCIIString})
    result = GDAL.setrastercategorynames(band.ptr, Ptr{Ptr{UInt8}}(pointer(names)))
    (result != GDAL.CE_None) && error("Failed to set category names for this band")
end

"""
Flush raster data cache.

This call will recover memory used to cache data blocks for this raster band,
and ensure that new requests are referred to the underlying driver.

### Returns
`CE_None` on success.
"""
function flushcache(band::RasterBand)
    result = GDAL.flushrastercache(band.ptr)
    (result != GDAL.CE_None) && error("Failed to flush raster data cache")
end

"""
Fill this band with a constant value.

GDAL makes no guarantees about what values pixels in newly created files are
set to, so this method can be used to clear a band to a specified "default"
value. The fill value is passed in as a double but this will be converted to
the underlying type before writing to the file. An optional second argument
allows the imaginary component of a complex constant value to be specified.

### Parameters
* `dfRealValue`         Real component of fill value
* `dfImaginaryValue`    Imaginary component of fill value, defaults to zero

### Returns
`CE_Failure` if the write fails, otherwise `CE_None`
"""
function fillraster(band::RasterBand,
                    realvalue::Cdouble,
                    imagvalue::Cdouble = 0)
    result = GDAL.fillraster(band.ptr, realvalue, imagvalue)
    (result != GDAL.CE_None) && error("Failed to fill raster band")
end

"""
Return the mask band associated with the band. (Since: GDAL 1.6.0)

The `GDALRasterBand` class includes a default implementation of `GetMaskBand()`
that returns one of four default implementations:

- If a corresponding .msk file exists it will be used for the mask band.
- If the dataset has a `NODATA_VALUES` metadata item, an instance of the new
GDALNoDataValuesMaskBand class will be returned. `GetMaskFlags()` will return
`GMF_NODATA | GMF_PER_DATASET`.
- If the band has a nodata value set, an instance of the new
`GDALNodataMaskRasterBand` class will be returned. `GetMaskFlags()` will
return `GMF_NODATA`.
- If there is no nodata value, but the dataset has an alpha band that seems to
apply to this band (specific rules yet to be determined) and that is of type
`GDT_Byte` then that alpha band will be returned, and the flags
`GMF_PER_DATASET` and `GMF_ALPHA` will be returned in the flags.
- If neither of the above apply, an instance of the new
`GDALAllValidRasterBand` class will be returned that has 255 values for all
pixels. The null flags will return `GMF_ALL_VALID`.

Note that the `GetMaskBand()` should always return a `GDALRasterBand` mask,
even if it is only an all 255 mask with the flags indicating `GMF_ALL_VALID`.

See also: http://trac.osgeo.org/gdal/wiki/rfc15_nodatabitmask

### Returns
a valid mask band.
"""
getmaskband(band::RasterBand) = RasterBand(GDAL.getmaskband(band.ptr))

"""
Return the status flags of the mask band associated with the band.

The GetMaskFlags() method returns an bitwise OR-ed set of status flags with the
following available definitions that may be extended in the future:

* `GMF_ALL_VALID` (`0x01`):    There are no invalid pixels, all mask values
will be 255. When used this will normally be the only flag set.
* `GMF_PER_DATASET` (`0x02`):  The mask band is shared between all bands on
the dataset.
- `GMF_ALPHA` (`0x04`):        The mask band is actually an alpha band and may
have values other than 0 and 255.
- `GMF_NODATA` (`0x08`):       Indicates the mask is actually being generated
from nodata values. (mutually exclusive of `GMF_ALPHA`)

The `GDALRasterBand` class includes a default implementation of `GetMaskBand()`
that returns one of four default implementations:

- If a corresponding .msk file exists it will be used for the mask band.
- If the dataset has a `NODATA_VALUES` metadata item, an instance of the new
`GDALNoDataValuesMaskBand` class will be returned. `GetMaskFlags()` will return
`GMF_NODATA | GMF_PER_DATASET`.
- If the band has a nodata value set, an instance of the new
`GDALNodataMaskRasterBand` class will be returned. `GetMaskFlags()` will return
`GMF_NODATA`.
- If there is no nodata value, but the dataset has an alpha band that seems to
apply to this band (specific rules yet to be determined) and that is of type
`GDT_Byte` then that alpha band will be returned, and the flags `GMF_PER_DATASET`
and `GMF_ALPHA` will be returned in the flags.
- If neither of the above apply, an instance of the new `GDALAllValidRasterBand`
class will be returned that has 255 values for all pixels. The null flags will
return `GMF_ALL_VALID`.

See also: http://trac.osgeo.org/gdal/wiki/rfc15_nodatabitmask

### Returns
a valid mask band.
"""
getmaskflags(band::RasterBand) = GDAL.getmaskflags(band.ptr)

"""
Adds a mask band to the current band.

The default implementation of the `CreateMaskBand()` method is implemented
based on similar rules to the `.ovr` handling implemented using the
`GDALDefaultOverviews` object. A `TIFF` file with the extension `.msk` will be
created with the same basename as the original file, and it will have as many
bands as the original image (or just one for `GMF_PER_DATASET`). The mask
images will be deflate compressed tiled images with the same block size as the
original image if possible.

If you got a mask band with a previous call to `GetMaskBand()`, it might be
invalidated by `CreateMaskBand()`. So you have to call `GetMaskBand()` again.

See also: http://trac.osgeo.org/gdal/wiki/rfc15_nodatabitmask

### Returns
`CE_None` on success or `CE_Failure` on an error.
"""
function createmaskband(band::RasterBand, nFlags::Integer)
    result = GDAL.createmaskband(band.ptr, nFlags)
    (result != GDAL.CE_None) && error("Failed to create mask band")
end
