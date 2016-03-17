module GDALUtils

    import GDAL

    include("types.jl")
    include("metadata.jl")
    include("driver.jl")
    include("gcp.jl")
    include("spatialref.jl")
    include("dataset.jl")
    include("rasterband.jl")
    include("rasterio.jl")
    include("ogr/geometry.jl")
    include("ogr/featurelayer.jl")
    include("ogr/featuredefn.jl")
    include("ogr/fielddefn.jl")

end # module
