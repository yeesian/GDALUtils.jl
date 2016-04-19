# adapted from http://www.gis.usu.edu/~chrisg/python/2009/lectures/ospy_hw1b.py

import GDALUtils; const GU = GDALUtils

GU.registerdrivers() do
    GU.read("ospy/data1/sites.shp") do input
        GU.create("tmp/hw1b.shp", "ESRI Shapefile") do output
            # get the layer for the input data source
            inlayer = GU.fetchlayer(input, 0)
            # create the layer for the output data source
            outlayer = GU.createlayer(output, "hw1b", GDAL.wkbPoint)

            # get FieldDefn's for the id and cover fields in the input shapefile
            inlayerdefn = GU.getlayerdefn(inlayer)
            idfielddefn = GU.fetchfielddefn(inlayerdefn, 0)
            coverfielddefn = GU.fetchfielddefn(inlayerdefn, 1)

            # create new id and cover fields in the output shapefile
            GU.createfield(outlayer, idfielddefn)
            GU.createfield(outlayer, coverfielddefn)

            # get the FeatureDefn for the output layer
            outlayerdefn = GU.getlayerdefn(outlayer)

            # loop through the input features
            for infeature in inlayer
                # get the input feature attributes
                id = GU.fetchfield(infeature, 0)
                cover = GU.fetchfield(infeature, 1)
                if cover == "trees"
                    GU.createfeature(outlayerdefn) do outfeature
                        # set the geometry
                        geom = GU.getgeom(infeature)
                        GU.setgeom(outfeature, geom)

                        # set the attributes
                        GU.setfield(outfeature, 0, id)
                        GU.setfield(outfeature, 1, cover)

                        # add the feature to the output layer
                        GU.createfeature(outlayer, outfeature)
                    end
                end
            end
        end
    end
end

# version 2
GU.registerdrivers() do
    GU.read("ospy/data1/sites.shp") do input
        GU.create("tmp/hw1b.shp", "ESRI Shapefile") do output
            # get the layer for the input data source
            inlayer = GU.fetchlayer(input, 0)
            # create the layer for the output data source
            outlayer = GU.createlayer(output, "hw1b", GDAL.wkbPoint)

            inlayerdefn = GU.getlayerdefn(inlayer)
            GU.createfield(outlayer, GU.fetchfielddefn(inlayerdefn, 0))
            GU.createfield(outlayer, GU.fetchfielddefn(inlayerdefn, 1))

            # loop through the input features
            for infeature in inlayer
                id = GU.fetchfield(infeature, 0)
                cover = GU.fetchfield(infeature, 1)
                if cover == "trees"
                    GU.createfeature(outlayer) do outfeature
                        GU.setgeom(outfeature, GU.getgeom(infeature))
                        GU.setfield(outfeature, 0, id)
                        GU.setfield(outfeature, 1, cover)
                    end
                end
            end
        end
    end
end

# version 3
GU.registerdrivers() do
    GU.read("ospy/data1/sites.shp") do input
        GU.create("tmp/hw1b.shp", "ESRI Shapefile") do output
            GU.executesql(input, """SELECT * FROM sites
                                    WHERE cover = 'trees' """) do results
                GU.copylayer(output, results, "hw1b")
            end
        end
    end
end;
