using FactCheck, Base.Test
import GDALUtils; const GU = GDALUtils

GU.registerdrivers() do
    GU.read("pyrasterio/RGB.byte.tif") do raster
        @fact GU.getproj(raster) --> "PROJCS[\"UTM Zone 18, Northern Hemisphere\",GEOGCS[\"Unknown datum based upon the WGS 84 ellipsoid\",DATUM[\"Not_specified_based_on_WGS_84_spheroid\",SPHEROID[\"WGS 84\",6378137,298.257223563,AUTHORITY[\"EPSG\",\"7030\"]]],PRIMEM[\"Greenwich\",0],UNIT[\"degree\",0.0174532925199433]],PROJECTION[\"Transverse_Mercator\"],PARAMETER[\"latitude_of_origin\",0],PARAMETER[\"central_meridian\",-75],PARAMETER[\"scale_factor\",0.9996],PARAMETER[\"false_easting\",500000],PARAMETER[\"false_northing\",0],UNIT[\"metre\",1,AUTHORITY[\"EPSG\",\"9001\"]]]"
        @fact GU.getgeotransform(raster) --> roughly([101985.0,300.0379266750948,0.0,2.826915e6,0.0,-300.041782729805])
        @fact size(GU.fetch(raster, 1)) --> (791,718)
        @fact size(GU.fetch(raster, Cint[1,3])) --> (791,718,2)
        @fact size(GU.fetch(raster)) --> (791,718,3)

        band = GU.fetchband(raster, 1)
        @fact GU.getdatatype(band) --> UInt8
        @fact GU.width(band) --> 791
        @fact GU.height(band) --> 718
        band_color = GU.getcolorinterp(band)
        @fact GU.getname(band_color) --> "Red"
    end

    GU.read("pyrasterio/RGB.byte.tif") do raster
        w = GU.fetch(raster, 1, 1:100, 1:100)
        @fact size(w) --> (791, 718)
    end

    GU.create("pyrasterio/example.tif",
                       "GTiff", # drivername
                       500, # width
                       300, # height
                       1, # number of bands
                       UInt8 # DataType
              ) do raster
        image = fill(UInt8(127), (150, 250))
        GU.update!( raster,
                    image, # image to "burn" into the raster
                    1, # update band 1
                    30:180, # along (window) xcoords 30 to 180
                    50:300) # along (window) ycoords 30 to 180
    end

    GU.read("pyrasterio/RGB.byte.tif") do src
    GU.create("pyrasterio/example2.tif", "GTiff", 500, 300, 3, UInt8) do dst
        rgb = GU.fetch(src, Cint[1,2,3]) # fetch bands 1 - 3
        # You can update all 3 bands simultaneously
        GU.update!(dst, rgb, # image to "burn" into destination dataset
                   Cint[1,2,3], # indices of the bands to be updated
                   30:269, # along (window) xcoords 30 to 269
                   50:313) # along (window) ycoords 50 to 313
    end
    end

    GU.read("pyrasterio/RGB.byte.tif") do src
        rgb = GU.fetch(src, Cint[1,2,3], 350:410, 350:450)
        GU.create("pyrasterio/example3.tif", "GTiff", 500, 300, 3, eltype(rgb)) do dst
            GU.update!(dst, rgb, Cint[1,2,3], 1:240, 1:400)
        end
    end
end

for filename in ["data1a.jl",
                 "data1b.jl",
                 "data2a.jl",
                 "data2b.jl",
                 "data3a.jl",
                 "data3b.jl",
                 "data4a.jl",
                 "data4b.jl",
                 "data5a.jl",
                 "data5b.jl",
                 "tutorial_raster.jl",
                 "tutorial_vector.jl"]
    include(filename)
end
