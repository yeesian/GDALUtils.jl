
"""
Returns a symbolic name for the color interpretation.

This is derived from the enumerated item name with the `GCI_` prefix removed,
but there are some variations. So `GCI_GrayIndex` returns "Gray" and
`GCI_RedBand` returns "Red". The returned strings are static strings and should
not be modified or freed by the application.
"""
nameof(color::GDAL.GDALColorInterp) = GDAL.getcolorinterpretationname(color)

"Get color interpretation corresponding to the given symbolic name."
colorinterp(name::AbstractString) = GDAL.getcolorinterpretationbyname(name)

"Color Interpretation value for band"
getcolorinterp(rasterband::Ptr{GDAL.GDALRasterBandH}) =
    GDAL.getrastercolorinterpretation(rasterband)

"Set color interpretation of a band."
setcolorinterp(rasterband::Ptr{GDAL.GDALRasterBandH},
               color::GDAL.GDALColorInterp) =
    GDAL.setrastercolorinterpretation(rasterband, color)

"""
Fetch the color table associated with band.

If there is no associated color table, the return result is `NULL`. The
returned color table remains owned by the `GDALRasterBand`, and can't be
depended on for long, nor should it ever be modified by the caller.
"""
getcolortable(rasterband::Ptr{GDAL.GDALRasterBandH}) =
    GDAL.getrastercolortable(rasterband)

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
setcolortable(rasterband::Ptr{GDAL.GDALRasterBandH},
              color::GDAL.GDALColorInterp) =
    GDAL.setrastercolortable(rasterband, color)

clearcolortable(rasterband::Ptr{GDAL.GDALRasterBandH}) =
    GDAL.setrastercolortable(rasterband, C_NULL)
