module GDALUtils

    import GDAL

    include("metadata.jl")
    include("driver.jl")
    include("gcp.jl")
    include("dataset.jl")
    include("rasterband.jl")
    include("rasterio.jl")

end # module
