# Tests based on the Vector API tutorial found at http://gdal.org/ogr_apitut.html

dataset = GU.read("data/point.geojson")

@fact GU.nlayer(dataset) --> 1
layer = GU.fetchlayer(dataset, 0)
@fact GU.nameof(layer) --> "OGRGeoJSON"
layerbyname = GU.fetchlayer(dataset, "OGRGeoJSON")
@fact layerbyname.ptr --> layer.ptr
GU.resetreading(layer)

featuredefn = GU.layerdefn(layer)
@fact GU.nfield(featuredefn) --> 2
fielddefn = GU.getfielddefn(featuredefn, 0)
@fact GDAL.gettype(fielddefn) --> GDAL.OFTReal
fielddefn = GU.getfielddefn(featuredefn, 1)
@fact GDAL.gettype(fielddefn) --> GDAL.OFTString

feature = GU.fetchnext(layer)
@fact GU.asdouble(feature, 0) --> roughly(2.0)
@fact GU.asstring(feature, 1) --> "point-a"
feature = GU.fetchnext(layer) # second feature
@fact GU.asdouble(feature, 0) --> roughly(3.0)
@fact GU.asstring(feature, 1) --> "point-b"

geometry = GU.getgeometry(feature)
@fact GU.geomname(geometry) --> "POINT"
@fact GU.geomtype(geometry) --> GDAL.wkbPoint
@fact GU.nfield(featuredefn) --> 2
@fact GU.getx(geometry, 0) --> roughly(100.2785)
@fact GU.gety(geometry, 0) --> roughly(0.0893)
@fact GU.getpoint(geometry, 0) --> (100.2785,0.0893,0.0)
GU.destroy(feature)
GU.close(dataset)

pointshapefile = "tmp/point_out"
dataset = GU.create("$pointshapefile.shp", "ESRI Shapefile")
layer = GU.createlayer(dataset, "point_out", GDAL.wkbPoint)
fielddefn = GU.fld_create("Name", GDAL.OFTString)
GU.setwidth(fielddefn, 32)
GU.createfield(layer, fielddefn, true)
GU.destroy(fielddefn)

featuredefn = GU.layerdefn(layer)
@fact GU.getname(featuredefn) --> "point_out"
feature = GU.f_create(featuredefn)
GU.setfield(feature, GU.fieldindex(feature, "Name"), "myname")
point = GU.creategeometry(GDAL.wkbPoint)
GU.setpoint(point, 0, 100.123, 0.123)
GU.setgeometry(feature, point)

GU.destroy(point)
GU.close(dataset)

rm("$pointshapefile.dbf")
rm("$pointshapefile.shp")
rm("$pointshapefile.shx")