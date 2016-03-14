# GDALUtils

```julia
julia> import GDALUtils; const GU = GDALUtils
GDALUtils

julia> raster = GU.open("pyrasterio/RGB.byte.tif")
GDAL Dataset (Driver: GTiff/GeoTIFF)

File(s): pyrasterio/RGB.byte.tif
Dataset (width x height): 791 x 718 (pixels)
  [ReadOnly] Band 1 (Red): 791 x 718 (UInt8)
  [ReadOnly] Band 2 (Green): 791 x 718 (UInt8)
  [ReadOnly] Band 3 (Blue): 791 x 718 (UInt8)
Number of bands: 3

julia> band = GU.fetchband(raster, 1)
[ReadOnly] Band 1 (Red): 791 x 718 (UInt8)

julia> band.ptr
Ptr{GDAL.GDALRasterBandH} @0x00007f8d444eae90

julia> d = GU.driver(raster)
Driver: GTiff/GeoTIFF

julia> d.ptr
Ptr{GDAL.GDALDriverH} @0x00007f8d4453a7a0
```