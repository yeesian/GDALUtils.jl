"""
    OGR_Fld_Create(const char * pszName,
                   OGRFieldType eType) -> OGRFieldDefnH
Create a new field definition.
### Parameters
* **pszName**: the name of the new field definition.
* **eType**: the type of the new field definition.
### Returns
handle to the new field definition.
"""
fld_create(name::AbstractString, etype::GDAL.OGRFieldType) =
    FieldDefn(GDAL.fld_create(name, etype))

"""
    OGR_Fld_Destroy(OGRFieldDefnH hDefn) -> void
Destroy a field definition.
### Parameters
* **hDefn**: handle to the field definition to destroy.
"""
destroy(fielddefn::FieldDefn) = GDAL.destroy(fielddefn.ptr)

"""
    OGR_Fld_SetName(OGRFieldDefnH hDefn,
                    const char * pszName) -> void
Reset the name of this field.
### Parameters
* **hDefn**: handle to the field definition to apply the new name to.
* **pszName**: the new name to apply.
"""
setname(fielddefn::FieldDefn, name::AbstractString) =
    GDAL.setname(fielddefn.ptr, name)

"""
    OGR_Fld_GetNameRef(OGRFieldDefnH hDefn) -> const char *
Fetch name of this field.
### Parameters
* **hDefn**: handle to the field definition.
### Returns
the name of the field definition.
"""
getname(fielddefn::FieldDefn) = GDAL.getname(fielddefn.ptr)

"""
    OGR_Fld_GetType(OGRFieldDefnH hDefn) -> OGRFieldType
Fetch type of this field.
### Parameters
* **hDefn**: handle to the field definition to get type from.
### Returns
field type.
"""
gettype(fielddefn::FieldDefn) = GDAL.gettype(fielddefn.ptr)

"""
    OGR_Fld_SetType(OGRFieldDefnH hDefn,
                    OGRFieldType eType) -> void
Set the type of this field.
### Parameters
* **hDefn**: handle to the field definition to set type to.
* **eType**: the new field type.
"""
settype(fielddefn::FieldDefn, etype::GDAL.OGRFieldType) =
    GDAL.settype(fielddefn.ptr, etype)

# """
#     OGR_Fld_GetSubType(OGRFieldDefnH hDefn) -> OGRFieldSubType
# Fetch subtype of this field.
# ### Parameters
# * **hDefn**: handle to the field definition to get subtype from.
# ### Returns
# field subtype.
# """
# function getsubtype(arg1::Ptr{OGRFieldDefnH})
#     ccall((:OGR_Fld_GetSubType,libgdal),OGRFieldSubType,(Ptr{OGRFieldDefnH},),arg1)
# end


# """
#     OGR_Fld_SetSubType(OGRFieldDefnH hDefn,
#                        OGRFieldSubType eSubType) -> void
# Set the subtype of this field.
# ### Parameters
# * **hDefn**: handle to the field definition to set type to.
# * **eSubType**: the new field subtype.
# """
# function setsubtype(arg1::Ptr{OGRFieldDefnH},arg2::OGRFieldSubType)
#     ccall((:OGR_Fld_SetSubType,libgdal),Void,(Ptr{OGRFieldDefnH},OGRFieldSubType),arg1,arg2)
# end


"""
    OGR_Fld_GetJustify(OGRFieldDefnH hDefn) -> OGRJustification
Get the justification for this field.
### Parameters
* **hDefn**: handle to the field definition to get justification from.
### Returns
the justification.
"""
getjustify(fielddefn::FieldDefn) = GDAL.getjustify(fielddefn.ptr)

"""
    OGR_Fld_SetJustify(OGRFieldDefnH hDefn,
                       OGRJustification eJustify) -> void
Set the justification for this field.
### Parameters
* **hDefn**: handle to the field definition to set justification to.
* **eJustify**: the new justification.
"""
setjustify(fielddefn::FieldDefn, ejustify::GDAL.OGRJustification) =
    GDAL.settype(fielddefn.ptr, ejustify)

"""
    OGR_Fld_GetWidth(OGRFieldDefnH hDefn) -> int
Get the formatting width for this field.
### Parameters
* **hDefn**: handle to the field definition to get width from.
### Returns
the width, zero means no specified width.
"""
getwidth(fielddefn::FieldDefn) = GDAL.getwidth(fielddefn.ptr)

"""
    OGR_Fld_SetWidth(OGRFieldDefnH hDefn,
                     int nNewWidth) -> void
Set the formatting width for this field in characters.
### Parameters
* **hDefn**: handle to the field definition to set width to.
* **nNewWidth**: the new width.
"""
setwidth(fielddefn::FieldDefn, width::Integer) =
    GDAL.setwidth(fielddefn.ptr, width)

"""
    OGR_Fld_GetPrecision(OGRFieldDefnH hDefn) -> int
Get the formatting precision for this field.
### Parameters
* **hDefn**: handle to the field definition to get precision from.
### Returns
the precision.
"""
getprecision(fielddefn::FieldDefn) = GDAL.getprecision(fielddefn.ptr)

"""
    OGR_Fld_SetPrecision(OGRFieldDefnH hDefn,
                         int nPrecision) -> void
Set the formatting precision for this field in characters.
### Parameters
* **hDefn**: handle to the field definition to set precision to.
* **nPrecision**: the new precision.
"""
setprecision(fielddefn::FieldDefn, precision::Integer) =
    GDAL.setprecision(fielddefn.ptr, precision)

# """
#     OGR_Fld_Set(OGRFieldDefnH hDefn,
#                 const char * pszNameIn,
#                 OGRFieldType eTypeIn,
#                 int nWidthIn,
#                 int nPrecisionIn,
#                 OGRJustification eJustifyIn) -> void
# Set defining parameters for a field in one call.
# ### Parameters
# * **hDefn**: handle to the field definition to set to.
# * **pszNameIn**: the new name to assign.
# * **eTypeIn**: the new type (one of the OFT values like OFTInteger).
# * **nWidthIn**: the preferred formatting width. Defaults to zero indicating undefined.
# * **nPrecisionIn**: number of decimals places for formatting, defaults to zero indicating undefined.
# * **eJustifyIn**: the formatting justification (OJLeft or OJRight), defaults to OJUndefined.
# """
# function set(arg1::Ptr{OGRFieldDefnH},arg2,arg3::OGRFieldType,arg4::Integer,arg5::Integer,arg6::OGRJustification)
#     ccall((:OGR_Fld_Set,libgdal),Void,(Ptr{OGRFieldDefnH},Cstring,OGRFieldType,Cint,Cint,OGRJustification),arg1,arg2,arg3,arg4,arg5,arg6)
# end


"""
    OGR_Fld_IsIgnored(OGRFieldDefnH hDefn) -> int
Return whether this field should be omitted when fetching features.
### Parameters
* **hDefn**: handle to the field definition
### Returns
ignore state
"""
isignored(fielddefn::FieldDefn) = Bool(GDAL.isignored(fielddefn.ptr))

"""
    OGR_Fld_SetIgnored(OGRFieldDefnH hDefn,
                       int ignore) -> void
Set whether this field should be omitted when fetching features.
### Parameters
* **hDefn**: handle to the field definition
* **ignore**: ignore state
"""
setignored(fielddefn::FieldDefn, ignore::Bool) =
    GDAL.setignored(fielddefn.ptr, ignore)

"""
    OGR_Fld_IsNullable(OGRFieldDefnH hDefn) -> int
Return whether this field can receive null values.
### Parameters
* **hDefn**: handle to the field definition
### Returns
TRUE if the field is authorized to be null.
"""
isnullable(fielddefn::FieldDefn) = Bool(GDAL.isnullable(fielddefn.ptr))

"""
    OGR_Fld_SetNullable(OGRFieldDefnH hDefn,
                        int bNullableIn) -> void
Set whether this field can receive null values.
### Parameters
* **hDefn**: handle to the field definition
* **bNullableIn**: FALSE if the field must have a not-null constraint.
"""
setnullable(fielddefn::FieldDefn, nullable::Bool) =
    GDAL.setnullable(fielddefn.ptr, nullable)

"""
    OGR_Fld_GetDefault(OGRFieldDefnH hDefn) -> const char *
Get default field value.
### Parameters
* **hDefn**: handle to the field definition.
### Returns
default field value or NULL.
"""
getdefault(fielddefn::FieldDefn) = GDAL.getdefault(fielddefn.ptr)

"""
    OGR_Fld_SetDefault(OGRFieldDefnH hDefn,
                       const char * pszDefault) -> void
Set default field value.
### Parameters
* **hDefn**: handle to the field definition.
* **pszDefault**: new default field value or NULL pointer.
"""
setdefault(fielddefn::FieldDefn, default) =
    GDAL.settype(fielddefn.ptr, default)

"""
    OGR_Fld_IsDefaultDriverSpecific(OGRFieldDefnH hDefn) -> int
Returns whether the default value is driver specific.
### Parameters
* **hDefn**: handle to the field definition
### Returns
TRUE if the default value is driver specific.
"""
isdefaultdriverspecific(fielddefn::FieldDefn) =
    Bool(GDAL.isdefaultdriverspecific(fielddefn.ptr))

"""
    OGR_GFld_Create(const char * pszName,
                    OGRwkbGeometryType eType) -> OGRGeomFieldDefnH
Create a new field geometry definition.
### Parameters
* **pszName**: the name of the new field definition.
* **eType**: the type of the new field definition.
### Returns
handle to the new field definition.
"""
gfld_create(name::AbstractString, etype::GDAL.OGRwkbGeometryType) =
    GeomFieldDefn(GDAL.gfld_create(name, etype))
"""
    OGR_GFld_Destroy(OGRGeomFieldDefnH hDefn) -> void
Destroy a geometry field definition.
### Parameters
* **hDefn**: handle to the geometry field definition to destroy.
"""
destroy(gfd::GeomFieldDefn) = GDAL.destroy(gfd.ptr)

"""
    OGR_GFld_SetName(OGRGeomFieldDefnH hDefn,
                     const char * pszName) -> void
Reset the name of this field.
### Parameters
* **hDefn**: handle to the geometry field definition to apply the new name to.
* **pszName**: the new name to apply.
"""
setname(gfd::GeomFieldDefn, name::AbstractString) =
    GDAL.setname(gfd.ptr, name)

"""
    OGR_GFld_GetNameRef(OGRGeomFieldDefnH hDefn) -> const char *
Fetch name of this field.
### Parameters
* **hDefn**: handle to the geometry field definition.
### Returns
the name of the geometry field definition.
"""
getname(gfd::GeomFieldDefn) = GDAL.getnameref(gfd.ptr)

"""
    OGR_GFld_GetType(OGRGeomFieldDefnH hDefn) -> OGRwkbGeometryType
Fetch geometry type of this field.
### Parameters
* **hDefn**: handle to the geometry field definition to get type from.
### Returns
field geometry type.
"""
gettype(gfd::GeomFieldDefn) = GDAL.gettype(gfd.ptr)

"""
    OGR_GFld_SetType(OGRGeomFieldDefnH hDefn,
                     OGRwkbGeometryType eType) -> void
Set the geometry type of this field.
### Parameters
* **hDefn**: handle to the geometry field definition to set type to.
* **eType**: the new field geometry type.
"""
settype(gfd::GeomFieldDefn, etype::GDAL.OGRwkbGeometryType) =
    GDAL.settype(gfd.ptr, etype)

"""
    OGR_GFld_GetSpatialRef(OGRGeomFieldDefnH hDefn) -> OGRSpatialReferenceH
Fetch spatial reference system of this field.
### Parameters
* **hDefn**: handle to the geometry field definition
### Returns
field spatial reference system.
"""
getspatialref(gfd::GeomFieldDefn) = SpatialRef(GDAL.getspatialref(gfd.ptr))

"""
    OGR_GFld_SetSpatialRef(OGRGeomFieldDefnH hDefn,
                           OGRSpatialReferenceH hSRS) -> void
Set the spatial reference of this field.
### Parameters
* **hDefn**: handle to the geometry field definition
* **hSRS**: the new SRS to apply.
"""
setspatialref(gfd::GeomFieldDefn, spatialref::SpatialRef) =
    GDAL.setspatialref(gfd.ptr, spatialref.ptr)

"""
    OGR_GFld_IsNullable(OGRGeomFieldDefnH hDefn) -> int
Return whether this geometry field can receive null values.
### Parameters
* **hDefn**: handle to the field definition
### Returns
TRUE if the field is authorized to be null.
"""
isnullable(gfd::GeomFieldDefn) = Bool(GDAL.isnullable(gfd.ptr))

"""
    OGR_GFld_SetNullable(OGRGeomFieldDefnH hDefn,
                         int bNullableIn) -> void
Set whether this geometry field can receive null values.
### Parameters
* **hDefn**: handle to the field definition
* **bNullableIn**: FALSE if the field must have a not-null constraint.
"""
setnullable(gfd::GeomFieldDefn, nullable::Bool) =
    GDAL.setnullable(gfd.ptr, nullable)

"""
    OGR_GFld_IsIgnored(OGRGeomFieldDefnH hDefn) -> int
Return whether this field should be omitted when fetching features.
### Parameters
* **hDefn**: handle to the geometry field definition
### Returns
ignore state
"""
isignored(gfd::GeomFieldDefn) = Bool(GDAL.isignored(gfd.ptr))

"""
    OGR_GFld_SetIgnored(OGRGeomFieldDefnH hDefn,
                        int ignore) -> void
Set whether this field should be omitted when fetching features.
### Parameters
* **hDefn**: handle to the geometry field definition
* **ignore**: ignore state
"""
setignored(gfd::GeomFieldDefn, ignore::Bool) =
    GDAL.setignored(gfd.ptr, ignore)

"""
    OGR_FD_Create(const char * pszName) -> OGRFeatureDefnH
Create a new feature definition object to hold the field definitions.
### Parameters
* **pszName**: the name to be assigned to this layer/class. It does not need to be unique.
### Returns
handle to the newly created feature definition.
"""
fd_create(name::AbstractString) = FeatureDefn(GDAL.fd_create(name))

"""
    OGR_FD_Destroy(OGRFeatureDefnH hDefn) -> void
Destroy a feature definition object and release all memory associated with it.
### Parameters
* **hDefn**: handle to the feature definition to be destroyed.
"""
destroy(featuredefn::FeatureDefn) = GDAL.destroy(featuredefn.ptr)

"""
    OGR_FD_Release(OGRFeatureDefnH hDefn) -> void
Drop a reference, and destroy if unreferenced.
### Parameters
* **hDefn**: handle to the feature definition to be released.
"""
release(featuredefn::FeatureDefn) = GDAL.release(featuredefn.ptr)

"""
    OGR_FD_GetName(OGRFeatureDefnH hDefn) -> const char *
Get name of the OGRFeatureDefn passed as an argument.
### Parameters
* **hDefn**: handle to the feature definition to get the name from.
### Returns
the name. This name is internal and should not be modified, or freed.
"""
getname(featuredefn::FeatureDefn) = GDAL.getname(featuredefn.ptr)

"""
    OGR_FD_GetFieldCount(OGRFeatureDefnH hDefn) -> int
Fetch number of fields on the passed feature definition.
### Parameters
* **hDefn**: handle to the feature definition to get the fields count from.
### Returns
count of fields.
"""
nfield(featuredefn::FeatureDefn) = GDAL.getfieldcount(featuredefn.ptr)

"""
    OGR_FD_GetFieldDefn(OGRFeatureDefnH hDefn,
                        int iField) -> OGRFieldDefnH
Fetch field definition of the passed feature definition.
### Parameters
* **hDefn**: handle to the feature definition to get the field definition from.
* **iField**: the field to fetch, between 0 and GetFieldCount()-1.
### Returns
an handle to an internal field definition object or NULL if invalid index. This object should not be modified or freed by the application.
"""
getfielddefn(featuredefn::FeatureDefn, i::Integer) =
    FieldDefn(GDAL.getfielddefn(featuredefn.ptr, i))

"""
    OGR_FD_GetFieldIndex(OGRFeatureDefnH hDefn,
                         const char * pszFieldName) -> int
Find field by name.
### Parameters
* **hDefn**: handle to the feature definition to get field index from.
* **pszFieldName**: the field name to search for.
### Returns
the field index, or -1 if no match found.
"""
getfieldindex(featuredefn::FeatureDefn, name::AbstractString) =
    GDAL.getfieldindex(featuredefn.ptr, name)

"""
    OGR_FD_AddFieldDefn(OGRFeatureDefnH hDefn,
                        OGRFieldDefnH hNewField) -> void
Add a new field definition to the passed feature definition.
### Parameters
* **hDefn**: handle to the feature definition to add the field definition to.
* **hNewField**: handle to the new field definition.
"""
addfielddefn(featuredefn::FeatureDefn, fielddefn::FieldDefn) =
    GDAL.addfielddefn(featuredefn.ptr, fielddefn.ptr)

"""
    OGR_FD_DeleteFieldDefn(OGRFeatureDefnH hDefn,
                           int iField) -> OGRErr
Delete an existing field definition.
### Parameters
* **hDefn**: handle to the feature definition.
* **iField**: the index of the field definition.
### Returns
OGRERR_NONE in case of success.
"""
deletefielddefn(featuredefn::FeatureDefn, i::Integer) =
    GDAL.deletefielddefn(featuredefn.ptr, i)

"""
    OGR_FD_ReorderFieldDefns(OGRFeatureDefnH hDefn,
                             int * panMap) -> OGRErr
Reorder the field definitions in the array of the feature definition.
### Parameters
* **hDefn**: handle to the feature definition.
* **panMap**: an array of GetFieldCount() elements which is a permutation of [0, GetFieldCount()-1]. panMap is such that, for each field definition at position i after reordering, its position before reordering was panMap[i].
### Returns
OGRERR_NONE in case of success.
"""
reorderfielddefns(featuredefn::FeatureDefn, name::Vector{Cint}) =
    GDAL.reorderfielddefns(featuredefn.ptr, name)

"""
    OGR_FD_GetGeomType(OGRFeatureDefnH hDefn) -> OGRwkbGeometryType
Fetch the geometry base type of the passed feature definition.
### Parameters
* **hDefn**: handle to the feature definition to get the geometry type from.
### Returns
the base type for all geometry related to this definition.
"""
getgeomtype(featuredefn::FeatureDefn) = GDAL.getgeomtype(featuredefn.ptr)

"""
    OGR_FD_SetGeomType(OGRFeatureDefnH hDefn,
                       OGRwkbGeometryType eType) -> void
Assign the base geometry type for the passed layer (the same as the feature definition).
### Parameters
* **hDefn**: handle to the layer or feature definition to set the geometry type to.
* **eType**: the new type to assign.
"""
setgeomtype(featuredefn::FeatureDefn, etype::GDAL.OGRwkbGeometryType) =
    GDAL.setgeomtype(featuredefn.ptr, etype)

"""
    OGR_FD_IsGeometryIgnored(OGRFeatureDefnH hDefn) -> int
Determine whether the geometry can be omitted when fetching features.
### Parameters
* **hDefn**: handle to the feature definition on witch OGRFeature are based on.
### Returns
ignore state
"""
isgeometryignored(featuredefn::FeatureDefn) =
    GDAL.isgeometryignored(featuredefn.ptr)

"""
    OGR_FD_SetGeometryIgnored(OGRFeatureDefnH hDefn,
                              int bIgnore) -> void
Set whether the geometry can be omitted when fetching features.
### Parameters
* **hDefn**: handle to the feature definition on witch OGRFeature are based on.
* **bIgnore**: ignore state
"""
setgeometryignored(featuredefn::FeatureDefn, ignore::Bool) =
    GDAL.setgeometryignored(featuredefn.ptr, ignore)

"""
    OGR_FD_IsStyleIgnored(OGRFeatureDefnH hDefn) -> int
Determine whether the style can be omitted when fetching features.
### Parameters
* **hDefn**: handle to the feature definition on which OGRFeature are based on.
### Returns
ignore state
"""
isstyleignored(featuredefn::FeatureDefn) = Bool(GDAL.isstyleignored(featuredefn.ptr))
