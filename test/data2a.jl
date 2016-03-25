# adapted from http://www.gis.usu.edu/~chrisg/python/2009/lectures/ospy_hw2a.py

import GDALUtils; const GU = GDALUtils

open("ospy/data2/ut_counties.txt", "r") do file
    GU.create("tmp/hw2a.shp", "ESRI Shapefile") do output
        # create the layer for the output data source
        layer = GU.createlayer(output, "hw2a", GDAL.wkbPolygon)

        # create a field for the county name
        fielddefn = GU.createfielddefn("name", GDAL.OFTString)
        GU.setwidth(fielddefn, 30)

        # add the field to the shapefile
        GU.createfield(layer, fielddefn)

        # get the FeatureDefn for the shapefile
        featuredefn = GU.getlayerdefn(layer)

        # loop through the lines in the text file
        for line in readlines(file)
            # create an empty ring geometry
            ring = GU.creategeom(GDAL.wkbLinearRing)
            # split the line on colons to get county name and
            # a string with coordinates
            (name, coords) = split(line, ":")
            # split the coords on commas to get a list of x,y pairs
            coordlist = split(coords, ",")
            # loop through the list of coordinates
            for coord in coordlist
                # split the x,y pair on spaces to get the individual x and y values
                xy = split(coord)
                # add the vertex to the ring
                GU.addpoint(ring, parse(Float64, xy[1]), 
                                  parse(Float64, xy[2]))
            end
            # now that we've looped through all of the coordinates, create a polygon
            poly = GU.creategeom(GDAL.wkbPolygon)
            GU.addgeom(poly, ring)

            # create a new feature and set its geometry and attribute
            GU.createfeature(featuredefn) do feature
                GU.setgeom(feature, poly)
                GU.setfield(feature, 0, name)

                # add the feature to the shapefile
                GU.createfeature(layer, feature)
            end
        end
    end
end
