# Tests based on the Vector API tutorial found at http://gdal.org/ogr_apitut.html

GU.registerdrivers() do
    GU.read("data/point.geojson") do dataset
        @fact GU.nlayer(dataset) --> 1
        layer = GU.fetchlayer(dataset, 0)
        @fact GU.getname(layer) --> "OGRGeoJSON"
        layerbyname = GU.fetchlayer(dataset, "OGRGeoJSON")
        @fact layerbyname --> layer
        GU.resetreading(layer)

        featuredefn = GU.getlayerdefn(layer)
        @fact GU.nfield(featuredefn) --> 2
        fielddefn = GU.fetchfielddefn(featuredefn, 0)
        @fact GDAL.gettype(fielddefn) --> GDAL.OFTReal
        fielddefn = GU.fetchfielddefn(featuredefn, 1)
        @fact GDAL.gettype(fielddefn) --> GDAL.OFTString

        GU.fetchnextfeature(layer) do feature
            @fact GU.asdouble(feature, 0) --> roughly(2.0)
            @fact GU.asstring(feature, 1) --> "point-a"
        end
        GU.fetchnextfeature(layer) do feature # second feature
            @fact GU.asdouble(feature, 0) --> roughly(3.0)
            @fact GU.asstring(feature, 1) --> "point-b"

            geometry = GU.getgeom(feature)
            @fact GU.getgeomname(geometry) --> "POINT"
            @fact GU.getgeomtype(geometry) --> GDAL.wkbPoint
            @fact GU.nfield(featuredefn) --> 2
            @fact GU.getx(geometry, 0) --> roughly(100.2785)
            @fact GU.gety(geometry, 0) --> roughly(0.0893)
            @fact GU.getpoint(geometry, 0) --> (100.2785,0.0893,0.0)
        end
    end

    pointshapefile = "tmp/point_out"
    GU.create("$pointshapefile.shp", "ESRI Shapefile") do dataset
        layer = GU.createlayer(dataset, "point_out", GDAL.wkbPoint)
        fielddefn = GU.createfielddefn("Name", GDAL.OFTString)
        GU.setwidth(fielddefn, 32)
        GU.createfield(layer, fielddefn, true)
        GU.destroy(fielddefn)

        featuredefn = GU.getlayerdefn(layer)
        @fact GU.getname(featuredefn) --> "point_out"
        GU.createfeature(featuredefn) do feature
            GU.setfield(feature, GU.getfieldindex(feature, "Name"), "myname")
            GU.creategeom(GDAL.wkbPoint) do point
                GU.setpoint(point, 0, 100.123, 0.123)
                GU.setgeom(feature, point)
            end
        end
    end

    rm("$pointshapefile.dbf")
    rm("$pointshapefile.shp")
    rm("$pointshapefile.shx")
end
