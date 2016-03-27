# """
#     GDALInitGCPs(int,
#                  GDAL_GCP *) -> void
# """
# function initgcps(arg1::Integer,arg2)
#     ccall((:GDALInitGCPs,libgdal),Void,(Cint,Ptr{GDAL_GCP}),arg1,arg2)
# end


# """
#     GDALDeinitGCPs(int,
#                    GDAL_GCP *) -> void
# """
# function deinitgcps(arg1::Integer,arg2)
#     ccall((:GDALDeinitGCPs,libgdal),Void,(Cint,Ptr{GDAL_GCP}),arg1,arg2)
# end


# """
#     GDALDuplicateGCPs(int,
#                       const GDAL_GCP *) -> GDAL_GCP *
# """
# function duplicategcps(arg1::Integer,arg2)
#     ccall((:GDALDuplicateGCPs,libgdal),Ptr{GDAL_GCP},(Cint,Ptr{GDAL_GCP}),arg1,arg2)
# end

# """
# Generate Geotransform from GCPs.

# Given a set of GCPs perform first order fit as a geotransform.

# Due to imprecision in the calculations the fit algorithm will often return
# non-zero rotational coefficients even if given perfectly non-rotated inputs.
# A special case has been implemented for corner corner coordinates given in
# TL, TR, BR, BL order. So when using this to get a geotransform from 4 corner
# coordinates, pass them in this order.

# ### Parameters
# * `nGCP`             the number of GCPs being passed in.
# * `pasGCPs`          the list of GCP structures.
# * `padfGeoTransform` the six double array in which the affine geotransformation
# will be returned.
# * `bApproxOK`        If `FALSE` the function will fail if the geotransform is
# not essentially an exact fit (within 0.25 pixel) for all GCPs.

# ### Returns
# `TRUE` on success or `FALSE` if there aren't enough points to prepare a
# geotransform, the pointers are ill-determined or if `bApproxOK` is `FALSE` and
# the fit is poor.
# """
# gcpstogeotransform(nGCP::Integer,
#                     pasGCPs::Ptr{GDAL.GDAL_GCP},
#                     padfGeoTransform::Ptr{Cdouble},
#                     bApproxOK::Integer) =
#     GDALGCPsToGeoTransform(nGCP, pasGCPs, padfGeoTransform, bApproxOK)::Cint

"""
Invert Geotransform.

This function will invert a standard 3x2 set of GeoTransform coefficients. This
converts the equation from being pixel to geo to being geo to pixel.

### Parameters
* `gt_in`       Input geotransform (six doubles - unaltered).
* `gt_out`      Output geotransform (six doubles - updated).

### Returns
`TRUE` on success or `FALSE` if the equation is uninvertable.
"""
function invgeotransform!(gt_in::Vector{Cdouble}, gt_out::Vector{Cdouble})
    result = Bool(GDAL.invgeotransform(pointer(gt_in), pointer(gt_out)))
    result || error("Geotransform coefficients is uninvertable")
    gt_out
end

invgeotransform(gt_in::Vector{Cdouble}) = invgeotransform!(gt_in, Array(Cdouble, 6))

"""
Apply GeoTransform to x/y coordinate.

Applies the following computation, converting a (pixel,line) coordinate into a
georeferenced `(geo_x,geo_y)` location.
```C
    *pdfGeoX =  padfGeoTransform[0] + 
                dfPixel * padfGeoTransform[1] +
                dfLine * padfGeoTransform[2];

    *pdfGeoY =  padfGeoTransform[3] +
                dfPixel * padfGeoTransform[4] +
                dfLine * padfGeoTransform[5];
```
### Parameters
* `padfGeoTransform`  Six coefficient GeoTransform to apply.
* `dfPixel`           input pixel position.
* `dfLine`            input line position.
* `pdfGeoX`           location for `geo_x` (easting/longitude)
* `pdfGeoY`           location for `geo_y` (northing/latitude)

"""
function applygeotransform(geotransform::Vector{Cdouble},
                           pixel::Cdouble,
                           line::Cdouble)
    geo_xy = Array(Cdouble, 2)
    geo_x = pointer(geo_xy);
    geo_y = geo_x + sizeof(Cdouble)
    GDAL.applygeotransform(pointer(geotransform), pixel, line, geo_x, geo_y)
    geo_xy
end 

"""
Compose two geotransforms.

The resulting geotransform is the equivelent to `padfGT1` and then `padfGT2`
being applied to a point.

### Parameters
* `gt1`     the first geotransform, six values.
* `gt2`     the second geotransform, six values.
* `gtout`   the output geotransform, six values, may safely be the same
array as `gt1` or `gt2`.

"""
function composegeotransform!(gt1::Vector{Cdouble},
                              gt2::Vector{Cdouble},
                              gtout::Vector{Cdouble})
    GDAL.composegeotransform(pointer(gt1), pointer(gt2), pointer(gtout))
    gtout
end

composegeotransform(gt1::Vector{Cdouble}, gt2::Vector{Cdouble}) =
    composegeotransform!(gt1, gt2, Array(Cdouble, 6))
