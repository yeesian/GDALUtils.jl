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
    ptr::GDAL.OGRGeomFieldDefnH
end

type SpatialRef
    ptr::Ptr{GDAL.OGRSpatialReferenceH}
end

type CoordTransform
    ptr::Ptr{GDAL.OGRCoordinateTransformationH}
end

type Driver{T}
    ptr::Ptr{T}
end

type RasterBand
    ptr::Ptr{GDAL.GDALRasterBandH}
end

type Dataset
    ptr::Ptr{GDAL.GDALDatasetH}
end

nullify(obj) = (obj.ptr = C_NULL)
checknull(obj) = (obj.ptr == C_NULL)

"return the corresponding `DataType` in julia"
const _jltype = Dict{GDAL.GDALDataType, DataType}(
    GDAL.GDT_Unknown    => Any,
    GDAL.GDT_Byte       => UInt8,
    GDAL.GDT_UInt16     => UInt16,
    GDAL.GDT_Int16      => Int16,
    GDAL.GDT_UInt32     => UInt32,
    GDAL.GDT_Int32      => Int32,
    GDAL.GDT_Float32    => Float32,
    GDAL.GDT_Float64    => Float64
)

"return the corresponding `GDALDataType`"
const _gdaltype = Dict{DataType,GDAL.GDALDataType}(
    Any         => GDAL.GDT_Unknown,
    UInt8       => GDAL.GDT_Byte,
    UInt16      => GDAL.GDT_UInt16,
    Int16       => GDAL.GDT_Int16,
    UInt32      => GDAL.GDT_UInt32,
    Int32       => GDAL.GDT_Int32,
    Float32     => GDAL.GDT_Float32,
    Float64     => GDAL.GDT_Float64
)

const _fieldtype = Dict{GDAL.OGRFieldType, DataType}(
    GDAL.OFTInteger         => Int32,
    GDAL.OFTIntegerList     => Void,
    GDAL.OFTReal            => Float64,
    GDAL.OFTRealList        => Void,
    GDAL.OFTString          => Cstring,
    GDAL.OFTStringList      => Void,
    GDAL.OFTWideString      => Void, # deprecated
    GDAL.OFTWideStringList  => Void, # deprecated
    GDAL.OFTBinary          => Void,
    GDAL.OFTDate            => Date,
    GDAL.OFTTime            => Void,
    GDAL.OFTDateTime        => DateTime,
    GDAL.OFTInteger64       => Int64,
    GDAL.OFTInteger64List   => Void,
    GDAL.OFTMaxType         => Void
)

const _geomname = Dict{GDAL.OGRwkbGeometryType, Symbol}(
    GDAL.wkbUnknown                 => :Unknown,
    GDAL.wkbPoint                   => :Point,
    GDAL.wkbLineString              => :LineString,
    GDAL.wkbPolygon                 => :Polygon,
    GDAL.wkbMultiPoint              => :MultiPoint,
    GDAL.wkbMultiLineString         => :MultiLineString,
    GDAL.wkbMultiPolygon            => :MultiPolygon,
    GDAL.wkbGeometryCollection      => :GeometryCollection,
    GDAL.wkbCircularString          => :CircularString,
    GDAL.wkbCompoundCurve           => :CompoundCurve,
    GDAL.wkbCurvePolygon            => :CurvePolygon,
    GDAL.wkbMultiCurve              => :MultiCurve,
    GDAL.wkbMultiSurface            => :MultiSurface,
    GDAL.wkbNone                    => :None,
    GDAL.wkbLinearRing              => :LinearRing,
    GDAL.wkbCircularStringZ         => :CircularStringZ,
    GDAL.wkbCompoundCurveZ          => :CompoundCurveZ,
    GDAL.wkbCurvePolygonZ           => :CurvePolygonZ,
    GDAL.wkbMultiCurveZ             => :MultiCurveZ,
    GDAL.wkbMultiSurfaceZ           => :MultiSurfaceZ,
    GDAL.wkbPoint25D                => :Point25D,
    GDAL.wkbLineString25D           => :LineString25D,
    GDAL.wkbPolygon25D              => :Polygon25D,
    GDAL.wkbMultiPoint25D           => :MultiPoint25D,
    GDAL.wkbMultiLineString25D      => :MultiLineString25D,
    GDAL.wkbMultiPolygon25D         => :MultiPolygon25D,
    GDAL.wkbGeometryCollection25D   => :GeometryCollection25D
)

const _access = Dict{UInt32, Symbol}(0 => :ReadOnly, 1 => :Update)

"""
`TRUE` if the passed type is complex (one of `GDT_CInt16`, `GDT_CInt32`,
`GDT_CFloat32` or `GDT_CFloat64`)
"""
iscomplex(dtype::GDAL.GDALDataType) = Bool(GDAL.datatypeiscomplex(dtype))
