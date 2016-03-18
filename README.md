# GDALUtils
Toying with experimental syntax for https://github.com/visr/GDAL.jl.

Use at your own risk!

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
    blocksize: 791x3, nodata: 0.0, units: 1.0px + 0.0
    overviews:

julia> band.ptr
Ptr{GDAL.GDALRasterBandH} @0x00007fa5dcd5e850

julia> d = GU.getdriver(raster)
Driver: GTiff/GeoTIFF

julia> d.ptr
Ptr{GDAL.GDALDriverH} @0x00007fa5dcab2ae0

julia> GU.close(raster)
Ptr{GDAL.GDALDatasetH} @0x0000000000000000

julia> raster
Closed Dataset

julia> raster = GU.read("gdalworkshop/world.tif")
GDAL Dataset (Driver: GTiff/GeoTIFF)

File(s): gdalworkshop/world.tif
Dataset (width x height): 2048 x 1024 (pixels)
  [ReadOnly] Band 1 (Red): 2048 x 1024 (UInt8)
  [ReadOnly] Band 2 (Green): 2048 x 1024 (UInt8)
  [ReadOnly] Band 3 (Blue): 2048 x 1024 (UInt8)
Number of bands: 3

julia> GU.fetchband(raster, 2)
[ReadOnly] Band 2 (Green): 2048 x 1024 (UInt8)
    blocksize: 256x256, nodata: -1.0e10, units: 1.0px + 0.0
    overviews: 1024x512, 512x256, 256x128, 128x64, 64x32,
               32x16, 16x8,

julia> GU.fetchband(raster, 3)
[ReadOnly] Band 3 (Blue): 2048 x 1024 (UInt8)
    blocksize: 256x256, nodata: -1.0e10, units: 1.0px + 0.0
    overviews: 1024x512, 512x256, 256x128, 128x64, 64x32,
               32x16, 16x8,

julia> GU.close(raster)
Ptr{GDAL.GDALDatasetH} @0x0000000000000000
```
