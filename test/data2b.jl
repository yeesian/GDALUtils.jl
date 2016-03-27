# adapted from http://www.gis.usu.edu/~chrisg/python/2009/lectures/ospy_hw2a.py

# import modules
import GDALUtils; const GU = GDALUtils

# create the input SpatialReference
inspatialref = GU.fromEPSG(4269)
# create the output SpatialReference
outspatialref = GU.fromEPSG(26912)
# create the CoordinateTransformation
coordtrans = GU.createcoordtrans(inspatialref, outspatialref)

GU.read("tmp/hw2a.shp") do input
    GU.create("tmp/hw2b.shp", "ESRI Shapefile") do output
        inlayer = GU.fetchlayer(input, 0)
        outlayer = GU.createlayer(output, "hw2b", GDAL.wkbPolygon)

        # get the FieldDefn for the county name field
        infeaturedefn = GU.getlayerdefn(inlayer)
        nameindex = GU.getfieldindex(infeaturedefn, "name")
        fielddefn = GU.fetchfielddefn(infeaturedefn, nameindex)

        # add the field to the output shapefile
        GU.createfield(outlayer, fielddefn)
        # get the FeatureDefn for the output shapefile
        outfeaturedefn = GU.getlayerdefn(outlayer)

        # loop through the input features
        for infeature in inlayer
            # get the input geometry
            geom = GU.getgeom(infeature)
            # reproject the geometry
            GU.transform(geom, coordtrans)
            # create a new feature
            GU.createfeature(outfeaturedefn) do outfeature
                # set the geometry and attribute
                GU.setgeom(outfeature, geom)
                inname = GU.fetchfield(infeature, nameindex)
                GU.setfield(outfeature, 0, inname)
                # add the feature to the shapefile
                GU.createfeature(outlayer, outfeature)
            end
        end
    end
end

# create the *.prj file
GU.morphtoesri(outspatialref)
open("tmp/hw2b.prj", "w") do file
    write(file, GU.toWKT(outspatialref))
end
