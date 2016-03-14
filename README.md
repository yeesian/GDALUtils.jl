# GDALUtils

```julia
julia> import GDALUtils; const GU = GDALUtils
GDALUtils

julia> raster = GU.read("pyrasterio/RGB.byte.tif")
GDAL Dataset (Driver: GTiff/GeoTIFF)

File(s): pyrasterio/RGB.byte.tif
Dataset (width x height): 791 x 718 (pixels)
  [ReadOnly] Band 1 (Red): 791 x 718 (UInt8)
  [ReadOnly] Band 2 (Green): 791 x 718 (UInt8)
  [ReadOnly] Band 3 (Blue): 791 x 718 (UInt8)
Number of bands: 3

julia> band = GU.fetchband(raster, 1)
[ReadOnly] Band 1 (Red): 791 x 718 (UInt8)
    units: 1.0px + 0.0
    overviews: 0, blocksize: 791x3, nodata: 0.0

julia> band = GU.fetchband(raster, 3)
[ReadOnly] Band 3 (Blue): 791 x 718 (UInt8)
    units: 1.0px + 0.0
    overviews: 0, blocksize: 791x3, nodata: 0.0

julia> band.ptr
Ptr{GDAL.GDALRasterBandH} @0x00007fd54cdc4280

julia> d = GU.driver(raster)
Driver: GTiff/GeoTIFF

julia> d.ptr
Ptr{GDAL.GDALDriverH} @0x00007fd54cc1d7f0
```