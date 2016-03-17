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
    include("geometry.jl")
    include("featurelayer.jl")
    include("misc.jl")

end # module
