# adapted from http://www.gis.usu.edu/~chrisg/python/2009/lectures/ospy_hw3b_mod.py
# and          http://www.gis.usu.edu/~chrisg/python/2009/lectures/ospy_hw3b.py

import GDALUtils; const GU = GDALUtils

"""
function to copy fields (not the data) from one layer to another
parameters:
  fromLayer: layer object that contains the fields to copy
  toLayer: layer object to copy the fields into
"""
function copyfields(fromlayer, tolayer)
    featuredefn = GU.getlayerdefn(fromlayer)
    for i in 0:(GU.nfield(featuredefn)-1)
        fd = GU.fetchfielddefn(featuredefn, i)
        if GU.gettype(fd) == GDAL.OFTReal
            # to deal with errors like
            # ERROR: GDALError (Warning, code 1):
            # Value 18740682.1600000001 of field SHAPE_AREA of
            # feature 1 not successfully written. Possibly due
            # to too larger number with respect to field width
            if GU.getwidth(fd) != 0
                GU.setwidth(fd, GU.getwidth(fd)+1)
            end
        end
        GU.createfield(tolayer, fd)
    end
end

"""
function to copy attributes from one feature to another
(this assumes the features have the same attribute fields!)
parameters:
  fromFeature: feature object that contains the data to copy
  toFeature: feature object that the data is to be copied into
"""
function copyattributes(fromfeature, tofeature)
    for i in 0:(GU.nfield(fromfeature)-1)
        if GU.isfieldset(fromfeature, i)
            try
                GU.setfield(tofeature, i, GU.fetchfield(fromfeature, i))
            catch
                println(fromfeature)
                println(tofeature)
                println("$i: $(GU.fetchfield(fromfeature, i))")
            end
        end
    end
end

# define the function
function reproject(inFN, inEPSG, outFN, outEPSG)
    inspatialref = GU.fromEPSG(inEPSG)
    outspatialref = GU.fromEPSG(outEPSG)
    coordtrans = GU.createcoordtrans(inspatialref, outspatialref)
    GU.read(inFN) do inDS
        GU.create(outFN, "ESRI Shapefile") do outDS
            inlayer = GU.fetchlayer(inDS, 0)
            outlayer = GU.createlayer(outDS,
                                      split(split(outFN, "/")[end], ".")[1],
                                      GU.getgeomtype(GU.getlayerdefn(inlayer)))
            copyfields(inlayer, outlayer)
            featuredefn = GU.getlayerdefn(outlayer)
            for infeature in inlayer
                geom = GU.getgeom(infeature)
                GU.transform(geom, coordtrans)
                GU.createfeature(featuredefn) do outfeature
                    GU.setgeom(outfeature, geom)
                    copyattributes(infeature, outfeature)
                    GU.createfeature(outlayer, outfeature)
                end
            end
        end
    end

    # create the *.prj file
    GU.morphtoesri(outspatialref)
    open(replace(outFN, ".shp", ".prj"), "w") do file
        write(file, GU.toWKT(outspatialref))
    end
end

GU.registerdrivers() do
    for inFN in readdir("./ospy/data3/")
        if endswith(inFN, ".shp")
            outFN = replace(inFN, ".shp", "_proj.shp")
            reproject("./ospy/data3/$(inFN)", 26912, "tmp/$(outFN)", 4269)
        end
    end
end
