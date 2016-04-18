# adapted from http://www.gis.usu.edu/~chrisg/python/2009/lectures/ospy_hw3a.py

import GDALUtils; const GU = GDALUtils

GU.registerdrivers() do
    GU.read("ospy/data3/sites.shp") do sitesDS
        GU.read("ospy/data3/cache_towns.shp") do townsDS
            siteslayer = GU.fetchlayer(sitesDS, 0)
            townslayer = GU.fetchlayer(townsDS, 0)

            # use an attribute filter to restrict cache_towns.shp to "Nibley"
            GU.setattributefilter(townslayer, "NAME = 'Nibley'")

            GU.fetchfeature(townslayer, 0) do nibleyFeature
                # get the Nibley geometry and buffer it by 1500
                nibleyGeom = GU.getgeom(nibleyFeature)
                bufferGeom = GU.buffer(nibleyGeom, 1500)

                # use bufferGeom as a spatial filter on sites.shp to get all sites
                # within 1500 meters of Nibley
                GU.setspatialfilter(siteslayer, bufferGeom)

                # loop through the remaining features in sites.shp and print their
                # id values
                for sitefeature in siteslayer
                    id_index = GU.getfieldindex(sitefeature, "ID")
                    println(GU.fetchfield(sitefeature, id_index))
                end
            end
        end
    end
end
