"Create a new field definition."
createfielddefn(name::AbstractString, etype::GDAL.OGRFieldType) =
    FieldDefn(GDAL.fld_create(name, etype))

"Destroy a field definition."
destroy(fielddefn::FieldDefn) = GDAL.destroy(fielddefn.ptr)

"Set the name of this field."
setname(fielddefn::FieldDefn, name::AbstractString) =
    GDAL.setname(fielddefn.ptr, name)

"Fetch name of this field."
getname(fielddefn::FieldDefn) = GDAL.getnameref(fielddefn.ptr)

"Fetch type of this field."
gettype(fielddefn::FieldDefn) = GDAL.gettype(fielddefn.ptr)

"Set the type of this field."
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


"Get the justification for this field."
getjustify(fielddefn::FieldDefn) = GDAL.getjustify(fielddefn.ptr)

"Set the justification for this field."
setjustify(fielddefn::FieldDefn, ejustify::GDAL.OGRJustification) =
    GDAL.setjustify(fielddefn.ptr, ejustify)

"""Get the formatting width for this field.

### Returns
the width, zero means no specified width.
"""
getwidth(fielddefn::FieldDefn) = GDAL.getwidth(fielddefn.ptr)

"Set the formatting width for this field in characters."
setwidth(fielddefn::FieldDefn, width::Integer) =
    GDAL.setwidth(fielddefn.ptr, width)

"Get the formatting precision for this field."
getprecision(fielddefn::FieldDefn) = GDAL.getprecision(fielddefn.ptr)

"Set the formatting precision for this field in characters."
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


"Return whether this field should be omitted when fetching features."
isignored(fielddefn::FieldDefn) = Bool(GDAL.isignored(fielddefn.ptr))

"Set whether this field should be omitted when fetching features."
setignored(fielddefn::FieldDefn, ignore::Bool) =
    GDAL.setignored(fielddefn.ptr, ignore)

"Return whether this field can receive null values."
isnullable(fielddefn::FieldDefn) = Bool(GDAL.isnullable(fielddefn.ptr))

"Set whether this field can receive null values."
setnullable(fielddefn::FieldDefn, nullable::Bool) =
    GDAL.setnullable(fielddefn.ptr, nullable)

"Get default field value."
getdefault(fielddefn::FieldDefn) = GDAL.getdefault(fielddefn.ptr)

"Set default field value."
setdefault(fielddefn::FieldDefn, default) =
    GDAL.setdefault(fielddefn.ptr, default)

"Returns whether the default value is driver specific."
isdefaultdriverspecific(fielddefn::FieldDefn) =
    Bool(GDAL.isdefaultdriverspecific(fielddefn.ptr))

"Create a new field geometry definition."
creategeomfielddefn(name::AbstractString, etype::GDAL.OGRwkbGeometryType) =
    GeomFieldDefn(GDAL.gfld_create(name, etype))

"Destroy a geometry field definition."
destroy(gfd::GeomFieldDefn) = GDAL.destroy(gfd.ptr)

"Set the name of this field."
setname(gfd::GeomFieldDefn, name::AbstractString) =
    GDAL.setname(gfd.ptr, name)

"Fetch name of this field."
getname(gfd::GeomFieldDefn) = GDAL.getnameref(gfd.ptr)

"Fetch geometry type of this field."
gettype(gfd::GeomFieldDefn) = GDAL.gettype(gfd.ptr)

"Set the geometry type of this field."
settype(gfd::GeomFieldDefn, etype::GDAL.OGRwkbGeometryType) =
    GDAL.settype(gfd.ptr, etype)

"Fetch spatial reference system of this field."
getspatialref(gfd::GeomFieldDefn) = SpatialRef(GDAL.getspatialref(gfd.ptr))

"Set the spatial reference of this field."
setspatialref(gfd::GeomFieldDefn, spatialref::SpatialRef) =
    GDAL.setspatialref(gfd.ptr, spatialref.ptr)

"Return whether this geometry field can receive null values."
isnullable(gfd::GeomFieldDefn) = Bool(GDAL.isnullable(gfd.ptr))

"Set whether this geometry field can receive null values."
setnullable(gfd::GeomFieldDefn, nullable::Bool) =
    GDAL.setnullable(gfd.ptr, nullable)

"Return whether this field should be omitted when fetching features."
isignored(gfd::GeomFieldDefn) = Bool(GDAL.isignored(gfd.ptr))

"Set whether this field should be omitted when fetching features."
setignored(gfd::GeomFieldDefn, ignore::Bool) =
    GDAL.setignored(gfd.ptr, ignore)