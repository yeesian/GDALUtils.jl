typealias FeatureLayer Ptr{GDAL.OGRLayerH}
typealias Feature Ptr{GDAL.OGRFeatureH}
typealias FeatureDefn Ptr{GDAL.OGRFeatureDefnH}
typealias FieldDefn Ptr{GDAL.OGRFieldDefnH}
typealias Geometry Ptr{GDAL.OGRGeometryH}
typealias GeomFieldDefn GDAL.OGRGeomFieldDefnH
typealias SpatialRef Ptr{GDAL.OGRSpatialReferenceH}
typealias CoordTransform Ptr{GDAL.OGRCoordinateTransformationH}
typealias Driver Ptr{GDAL.GDALDriverH}
typealias RasterBand Ptr{GDAL.GDALRasterBandH}
typealias Dataset Ptr{GDAL.GDALDatasetH}
typealias ProgressFunc Ptr{GDAL.GDALProgressFunc}

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
    GDALGetDataTypeSize(GDALDataType) -> int
Get data type size in bits.
### Parameters
* **eDataType**: type, such as GDT_Byte.
### Returns
the number of bits or zero if it is not recognised.
"""
getdatatypesize(dt::Integer) =
    ccall((:GDALGetDataTypeSize,GDAL.libgdal),Cint,(GDAL.GDALDataType,),dt)

"""
    GDALGetDataTypeName(GDALDataType) -> const char *
Get name of data type.
### Parameters
* **eDataType**: type to get name of.
### Returns
string corresponding to existing data type or NULL pointer if invalid type given.
"""
getdatatypename(dt::Integer) =
    bytestring(ccall((:GDALGetDataTypeName,GDAL.libgdal),Cstring,(GDAL.GDALDataType,),dt))

"""
    GDALGetDataTypeByName(const char *) -> GDALDataType
Get data type by symbolic name.
### Parameters
* **pszName**: string containing the symbolic name of the type.
### Returns
GDAL data type.
"""
function getdatatypebyname(name::AbstractString)
    ccall((:GDALGetDataTypeByName,GDAL.libgdal),GDAL.GDALDataType,(Cstring,),name)
end

"""
    GDALDataTypeUnion(GDALDataType,
                      GDALDataType) -> GDALDataType
Return the smallest data type that can fully express both input data types.
### Parameters
* **eType1**: first data type.
* **eType2**: second data type.
### Returns
a data type able to express eType1 and eType2.
"""
function datatypeunion(dt1::Integer,dt2::Integer)
    ccall((:GDALDataTypeUnion,GDAL.libgdal),GDAL.GDALDataType,(GDAL.GDALDataType,GDAL.GDALDataType),dt1,dt2)
end

# """
#     GDALAdjustValueToDataType(GDALDataType eDT,
#                               double dfValue,
#                               int * pbClamped,
#                               int * pbRounded) -> double
# Adjust a value to the output data type.
# ### Parameters
# * **eDT**: target data type.
# * **dfValue**: value to adjust.
# * **pbClamped**: pointer to a integer(boolean) to indicate if clamping has been made, or NULL
# * **pbRounded**: pointer to a integer(boolean) to indicate if rounding has been made, or NULL
# ### Returns
# adjusted value
# """
# function adjustvaluetodatatype(eDT::GDALDataType,dfValue::Real,pbClamped,pbRounded)
#     ccall((:GDALAdjustValueToDataType,libgdal),Cdouble,(GDALDataType,Cdouble,Ptr{Cint},Ptr{Cint}),eDT,dfValue,pbClamped,pbRounded)
# end

"""
`TRUE` if the passed type is complex (one of `GDT_CInt16`, `GDT_CInt32`,
`GDT_CFloat32` or `GDT_CFloat64`)
"""
iscomplex(dtype::GDAL.GDALDataType) = Bool(GDAL.datatypeiscomplex(dtype))

# """
#     GDALGetAsyncStatusTypeName(GDALAsyncStatusType) -> const char *
# Get name of AsyncStatus data type.
# ### Parameters
# * **eAsyncStatusType**: type to get name of.
# ### Returns
# string corresponding to type.
# """
# function getasyncstatustypename(arg1::GDALAsyncStatusType)
#     bytestring(ccall((:GDALGetAsyncStatusTypeName,libgdal),Cstring,(GDALAsyncStatusType,),arg1))
# end


# """
#     GDALGetAsyncStatusTypeByName(const char *) -> GDALAsyncStatusType
# Get AsyncStatusType by symbolic name.
# ### Parameters
# * **pszName**: string containing the symbolic name of the type.
# ### Returns
# GDAL AsyncStatus type.
# """
# function getasyncstatustypebyname(arg1)
#     ccall((:GDALGetAsyncStatusTypeByName,libgdal),GDALAsyncStatusType,(Cstring,),arg1)
# end


"""
Returns a symbolic name for the color interpretation.

This is derived from the enumerated item name with the `GCI_` prefix removed,
but there are some variations. So `GCI_GrayIndex` returns "Gray" and
`GCI_RedBand` returns "Red". The returned strings are static strings and should
not be modified or freed by the application.

### Returns
string corresponding to color interpretation or NULL pointer if invalid enumerator given.
"""
getcolorinterpname(color::Integer) =
    bytestring(ccall((:GDALGetColorInterpretationName,GDAL.libgdal),Cstring,(GDAL.GDALPaletteInterp,),color))

# GDALGetColorInterpretationByName(const char * pszName) -> GDALColorInterp
"Get color interpretation corresponding to the given symbolic name."
getcolorinterp(name::AbstractString) = GDAL.getcolorinterpretationbyname(name)


"""
    GDALGetPaletteInterpretationName(GDALPaletteInterp) -> const char *
Get name of palette interpretation.
### Parameters
* **eInterp**: palette interpretation to get name of.
### Returns
string corresponding to palette interpretation.
"""
getpaletteinterpname(einterp::Integer) =
    bytestring(ccall((:GDALGetPaletteInterpretationName,GDAL.libgdal),Cstring,(GDAL.GDALPaletteInterp,),einterp))

# """
#     OGR_GetFieldTypeName(OGRFieldType eType) -> const char *
# Fetch human readable name for a field type.
# ### Parameters
# * **eType**: the field type to get name for.
# ### Returns
# the name.
# """
# function getfieldtypename(arg1::OGRFieldType)
#     bytestring(ccall((:OGR_GetFieldTypeName,libgdal),Cstring,(OGRFieldType,),arg1))
# end

# """
#     OGR_GetFieldSubTypeName(OGRFieldSubType eSubType) -> const char *
# Fetch human readable name for a field subtype.
# ### Parameters
# * **eSubType**: the field subtype to get name for.
# ### Returns
# the name.
# """
# function getfieldsubtypename(arg1::OGRFieldSubType)
#     bytestring(ccall((:OGR_GetFieldSubTypeName,libgdal),Cstring,(OGRFieldSubType,),arg1))
# end


# """
#     OGR_AreTypeSubTypeCompatible(OGRFieldType eType,
#                                  OGRFieldSubType eSubType) -> int
# Return if type and subtype are compatible.
# ### Parameters
# * **eType**: the field type.
# * **eSubType**: the field subtype.
# ### Returns
# TRUE if type and subtype are compatible
# """
# function aretypesubtypecompatible(eType::OGRFieldType,eSubType::OGRFieldSubType)
#     ccall((:OGR_AreTypeSubTypeCompatible,libgdal),Cint,(OGRFieldType,OGRFieldSubType),eType,eSubType)
# end