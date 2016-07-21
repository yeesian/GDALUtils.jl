# GDALUtils
Toying with experimental syntax for https://github.com/visr/GDAL.jl.

# NOTICE
**Warning**: This package is succeeded by the [ArchGDAL.jl](https://github.com/yeesian/ArchGDAL.jl) package, and is now *abandoned*.

```julia
  | | |_| | | | (_| |  |  Version 0.4.2 (2015-12-06 21:47 UTC)
 _/ |\__'_|_|_|\__'_|  |  Official http://julialang.org/ release
|__/                   |  x86_64-apple-darwin13.4.0

julia> import GDALUtils; const GU = GDALUtils
GDALUtils

julia> dataset = GU.read("data/point.geojson")
GDAL Dataset (Driver: GeoJSON/GeoJSON)
File(s): data/point.geojson
Number of raster bands: 0
Number of feature layers: 1
  Layer 1: OGRGeoJSON (Point), nfeatures = 4


julia> layer = GU.fetchlayer(dataset, 0)
Layer: OGRGeoJSON (Point), nfeatures = 4
Feature Definition:
  Geometry (index 0):  (Point)
  Field    (index 0): FID (Float64)
  Field    (index 1): pointname (Cstring)


julia> feature = GU.fetchfeature(layer, 2)
Feature
FID => 0.0
pointname => a
geom => POINT


julia> GU.close(dataset)
Ptr{GDAL.GDALDatasetH} @0x0000000000000000

julia> dataset = GU.read("gdalworkshop/world.tif")
GDAL Dataset (Driver: GTiff/GeoTIFF)
File(s): gdalworkshop/world.tif
Number of raster bands: 3
  [ReadOnly] Band 1 (Red): 2048 x 1024 (UInt8)
  [ReadOnly] Band 2 (Green): 2048 x 1024 (UInt8)
  [ReadOnly] Band 3 (Blue): 2048 x 1024 (UInt8)
Number of feature layers: 0


julia> band = GU.fetchband(dataset, 1)
[ReadOnly] Band 1 (Red): 2048 x 1024 (UInt8)
    blocksize: 256x256, nodata: -1.0e10, units: 1.0px + 0.0
    overviews: 1024x512, 512x256, 256x128, 128x64, 64x32,
               32x16, 16x8,

julia> GU.close(dataset)
Ptr{GDAL.GDALDatasetH} @0x0000000000000000
```
