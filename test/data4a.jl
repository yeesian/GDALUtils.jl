# adapted from http://www.gis.usu.edu/~chrisg/python/2009/lectures/ospy_hw4a.py

import GDALUtils; const GU = GDALUtils

GU.registerdrivers() do
    GU.read("ospy/data4/sites.shp") do shp
        GU.read("ospy/data4/aster.img") do img
            shplayer = GU.fetchlayer(shp, 0)
            featuredefn = GU.getlayerdefn(shplayer)
            id_index = GU.getfieldindex(featuredefn, "ID")

            # get georeference info
            transform = GU.getgeotransform(img)
            xOrigin = transform[1]
            yOrigin = transform[4]
            pixelWidth = transform[2]
            pixelHeight = transform[6]

            # loop through the features in the shapefile
            for feature in shplayer
                geom = GU.getgeom(feature)
                x = GU.getx(geom, 0)
                y = GU.gety(geom, 0)
                # compute pixel offset
                xOffset = round(Int, (x - xOrigin) / pixelWidth)
                yOffset = round(Int, (y - yOrigin) / pixelHeight)
                # create a string to print out
                s = string(GU.fetchfield(feature, id_index)) * " "
                for j in 1:GU.nraster(img)
                    data = GU.fetch(img, j, 1, 1, xOffset, yOffset)
                    s = s * string(data[1,1]) * " "
                end
                # print out the data string
                println(s)
            end
        end
    end
end

# Expected Output:
# 1 46 30 47
# 2 85 77 76
# 3 64 51 66
# 4 71 60 73
# 5 59 40 68
# 6 97 95 80
# 7 51 33 52
# 8 79 69 62
# 9 78 74 63
# 10 90 81 67
# 11 82 81 67
# 12 100 88 68
# 13 90 80 65
# 14 76 65 81
# 15 83 75 61
# 16 73 61 63
# 17 81 71 68
# 18 69 57 60
# 19 98 90 75
# 20 91 79 76
# 21 86 77 64
# 22 78 73 63
# 23 82 66 71
# 24 64 46 82
# 25 69 55 68
# 26 98 88 78
# 27 62 43 79
# 28 68 57 62
# 29 66 51 74
# 30 60 39 83
# 31 80 62 80
# 32 86 73 86
# 33 97 86 84
# 34 47 29 49
# 35 91 74 90
# 36 67 53 63
# 37 71 59 63
# 38 54 23 16
# 39 53 22 17
# 40 76 66 61
# 41 0 0 0
# 42 0 0 0
