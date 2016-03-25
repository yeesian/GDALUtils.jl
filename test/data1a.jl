# adapted from http://www.gis.usu.edu/~chrisg/python/2009/lectures/ospy_hw1a.py

import GDALUtils; const GU = GDALUtils
open("tmp/hw1a.txt", "w") do file
    GU.read("ospy/data1/sites.shp") do datasource
        layer = GU.fetchlayer(datasource, 0)
        for feature in layer
            id = GU.fetchfield(feature, 0)
            cover = GU.fetchfield(feature, 1)
            geom = GU.fetchgeomfield(feature, 0)
            (x,y) = GU.getpoint(geom, 0)
            write(file, "$id $x $y $cover\n")
        end
    end
end
