type FeatureLayer
    ptr::Ptr{GDAL.OGRLayerH}
end

type Feature
    ptr::Ptr{GDAL.OGRFeatureH}
end

type FeatureDefn
    ptr::Ptr{GDAL.OGRFeatureDefnH}
end

type FieldDefn
    ptr::Ptr{GDAL.OGRFieldDefnH}
end

type Geometry
    ptr::Ptr{GDAL.OGRGeometryH}
end

type GeomFieldDefn
    ptr::Ptr{GDAL.OGRGeomFieldDefnH}
end

type SpatialRef
    ptr::Ptr{GDAL.OGRSpatialReferenceH}
end