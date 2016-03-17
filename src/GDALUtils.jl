module GDALUtils

    import GDAL

    include("types.jl")
    include("metadata.jl")
    include("driver.jl")
    include("gcp.jl")
    include("spatialref.jl")
    include("dataset.jl") # depends: types.jl, driver.jl
    include("rasterband.jl") # depends: dataset.jl
    include("rasterio.jl")
    include("ogr/geometry.jl")
    include("ogr/featurelayer.jl")
    include("ogr/featuredefn.jl")
    include("ogr/fielddefn.jl")
    include("display.jl")

end # module
