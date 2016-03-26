
"Return the layer name."
getname(layer::FeatureLayer) = GDAL.getname(layer.ptr)

"Return the layer geometry type."
getgeomtype(layer::FeatureLayer) = GDAL.getgeomtype(layer.ptr)

"Returns the current spatial filter for this layer."
getspatialfilter(layer::FeatureLayer) =
    Geometry(GDAL.getspatialfilter(layer.ptr))

"Set a new spatial filter for the layer, using the geom."
setspatialfilter(layer::FeatureLayer, geom::Geometry) = 
    GDAL.setspatialfilter(layer.ptr, geom.ptr)

"Set a new rectangular spatial filter for the layer."
setspatialfilter(layer::FeatureLayer,
                 xmin::Real, ymin::Real, xmax::Real, ymax::Real) = 
    GDAL.setspatialfilterrect(layer.ptr, xmin, ymin, xmax, ymax)

"""
Set a new spatial filter.

### Parameters
* **layer**: the layer on which to set the spatial filter.
* **index**: index of the geometry field on which the spatial filter operates.
* **geom**: the geometry to use as a filtering region. NULL may be passed
    indicating that the current spatial filter should be cleared, but
    no new one instituted.
"""
setspatialfilter(layer::FeatureLayer, index::Integer, geom::Geometry) = 
    GDAL.setspatialfilterex(layer.ptr, index, geom.ptr)

clearspatialfilter(layer::FeatureLayer, index::Integer) = 
    GDAL.setspatialfilterex(layer.ptr, index, C_NULL)

"""
Set a new rectangular spatial filter.
### Parameters
* **layer**: handle to the layer on which to set the spatial filter.
* **index**: index of the geometry field on which the spatial filter operates.
* **xmin**: the minimum X coordinate for the rectangular region.
* **ymin**: the minimum Y coordinate for the rectangular region.
* **xmax**: the maximum X coordinate for the rectangular region.
* **ymax**: the maximum Y coordinate for the rectangular region.
"""
setspatialfilter(layer::FeatureLayer, index::Integer,
                 xmin::Real, ymin::Real, xmax::Real, ymax::Real) = 
    GDAL.setspatialfilterrectex(layer.ptr, index, xmin, ymin, xmax, ymax)

"""
    OGR_L_SetAttributeFilter(OGRLayerH,
                             const char *) -> OGRErr
Set a new attribute query.
### Parameters
* **hLayer**: handle to the layer on which attribute query will be executed.
* **pszQuery**: query in restricted SQL WHERE format, or NULL to clear the current query.
### Returns
OGRERR_NONE if successfully installed, or an error code if the query expression is in error, or some other failure occurs.
"""
function setattributefilter(layer::FeatureLayer, query::AbstractString)
    result = GDAL.setattributefilter(layer.ptr, query)
    (result != GDAL.OGRERR_NONE) && error("Failed to set a new attribute query")
end

"Fetch a layer by index (between 0 and GetLayerCount()-1)"
fetchlayer(dataset::Dataset, i::Integer) =
    FeatureLayer(GDAL.datasetgetlayer(dataset.ptr, i))

"Fetch a feature layer for a dataset from its name"
fetchlayer(dataset::Dataset, name::AbstractString) =
    FeatureLayer(GDAL.datasetgetlayerbyname(dataset.ptr, name))

"""
Delete the indicated layer (at index i) from the datasource.

### Returns
OGRERR_NONE on success, or OGRERR_UNSUPPORTED_OPERATION if deleting layers
is not supported for this datasource.
"""
function deletelayer(dataset::Dataset, i::Integer)
    result = GDAL.datasetdeletelayer(dataset.ptr, i)
    if result != GDAL.OGRERR_NONE
        error("Failed to delete layer")
    end
end

"""
This function attempts to create a new layer on the dataset with the indicated
name, coordinate system, geometry type.

### Parameters
* **dataset**: the dataset
* **name**: the name for the new layer. This should ideally not match any
    existing layer on the datasource.
* **spatialref**: the coordinate system to use for the new layer, or NULL if
    no coordinate system is available.
* **geomtype**: the geometry type for the layer. Use wkbUnknown if there are no
    constraints on the types geometry to be written.
* **papszOptions**: a StringList of name=value (driver-specific) options.
"""
function createlayer(dataset::Dataset,
                     name::AbstractString,
                     geomtype::GDAL.OGRwkbGeometryType = GDAL.wkbUnknown)
    FeatureLayer(GDAL.datasetcreatelayer(dataset.ptr, name, Ptr{GDAL.OGRSpatialReferenceH}(C_NULL),
                                         geomtype, C_NULL))
end

function createlayer(dataset::Dataset,
                     name::AbstractString,
                     spatialref::SpatialRef,
                     geomtype::GDAL.OGRwkbGeometryType = GDAL.wkbUnknown)
    FeatureLayer(GDAL.datasetcreatelayer(dataset.ptr, name, spatialref.ptr,
                                         geomtype, C_NULL))
end

"""
Duplicate an existing layer.

### Parameters
* **dataset**: the dataset handle.
* **layer**: source layer.
* **name**: the name of the layer to create.
* **papszOptions**: a StringList of name=value (driver-specific) options.
"""
copylayer(dataset::Dataset,layer::FeatureLayer, name::AbstractString) =
    FeatureLayer(GDAL.datasetcopylayer(dataset.ptr, layer.ptr, name, C_NULL))

"""
Execute an SQL statement against the data store.

### Parameters
* **dataset**: the dataset handle.
* **query**: the SQL statement to execute.
* **spatialfilter**: geometry which represents a spatial filter. Can be NULL.
* **dialect**: allows control of the statement dialect. If set to NULL, the
    OGR SQL engine will be used, except for RDBMS drivers that will use their
    dedicated SQL engine, unless OGRSQL is explicitly passed as the dialect.
    Starting with OGR 1.10, the SQLITE dialect can also be used.

### Returns
an OGRLayer containing the results of the query.
Deallocate with ReleaseResultSet().
"""
executesql(dataset::Dataset, query::AbstractString) =
    FeatureLayer(GDAL.datasetexecutesql(dataset.ptr, query, C_NULL, C_NULL))

executesql(dataset::Dataset, query::AbstractString, dialect::AbstractString) =
    FeatureLayer(GDAL.datasetexecutesql(dataset.ptr, query, C_NULL, dialect))

function executesql(dataset::Dataset,
                  query::AbstractString,
                  spatialfilter::Geometry,
                  dialect::AbstractString)
    FeatureLayer(GDAL.datasetexecutesql(dataset.ptr, query, spatialfilter.ptr,
                                        dialect))
end

function executesql(f::Function, dataset::Dataset, args...)
    result = sqlquery(dataset, args...)
    try
        f(result)
    finally
        releaseresultset(dataset, result)
    end
end

"""
Release results of ExecuteSQL().

### Parameters
* **dataset**: the dataset handle.
* **layer**: the result of a previous ExecuteSQL() call.
"""
releaseresultset(dataset::Dataset, layer::FeatureLayer) =
    GDAL.datasetreleaseresultset(dataset.ptr, layer.ptr)

"Reset feature reading to start on the first feature."
resetreading(layer::FeatureLayer) = GDAL.resetreading(layer.ptr)

"Fetch the next available feature from this layer."
fetchnextfeature(layer::FeatureLayer) =
    Feature(GDAL.getnextfeature(layer.ptr))

function fetchnextfeature(f::Function, args...)
    feature = fetchnextfeature(args...)
    try
        f(feature)
    finally
        destroy(feature)
    end
end

"Move read cursor to the nIndex'th feature in the current resultset.
### Parameters
* **hLayer**: handle to the layer
* **nIndex**: the index indicating how many steps into the result set to seek.
### Returns
OGRERR_NONE on success or an error code.
"""
function setnextbyindex(layer::FeatureLayer, i::Integer)
    result = GDAL.setnextbyindex(layer.ptr, i)
    if result != GDAL.OGRERR_NONE
        error("Failed to move the cursor to index $i")
    end
end

"Fetch a feature (now owned by the caller) by its identifier."
fetchfeature(layer::FeatureLayer, i::Integer) =
    Feature(GDAL.getfeature(layer.ptr, i))

function fetchfeature(f::Function, args...)
    feature = fetchfeature(args...)
    try
        f(feature)
    finally
        destroy(feature)
    end
end

"""
Rewrite an existing feature.

### Returns
OGRERR_NONE if the operation works, otherwise an appropriate error code
(e.g OGRERR_NON_EXISTING_FEATURE if the feature does not exist).
"""
function setfeature(layer::FeatureLayer, feature::Feature)
    result = GDAL.setfeature(layer.ptr, feature.ptr)
    if result != GDAL.OGRERR_NONE
        error("Failed to set feature.")
    end
end

"""
Create and write a new feature within a layer.

### Returns
OGRERR_NONE on success.
"""
function createfeature(layer::FeatureLayer, feature::Feature)
    result = GDAL.createfeature(layer.ptr, feature.ptr)
    if result != GDAL.OGRERR_NONE
        error("Failed to create and write feature.")
    end
end

function createfeature(f::Function, args...)
    feature = createfeature(args...)
    try
        f(feature)
    finally
        destroy(feature)
    end
end

"""
Delete feature with fid i from layer.

### Returns
OGRERR_NONE if the operation works, otherwise an appropriate error code
(e.g OGRERR_NON_EXISTING_FEATURE if the feature does not exist).
"""
function deletefeature(layer::FeatureLayer, i::Integer)
    result = GDAL.deletefeature(layer.ptr, i)
    if result != GDAL.OGRERR_NONE
        error("Failed to delete feature $i.")
    end
end

"""
Set feature geometry.

### Returns
OGRERR_NONE if successful, or OGR_UNSUPPORTED_GEOMETRY_TYPE if the geometry
type is illegal for the OGRFeatureDefn (checking not yet implemented).
"""
function setgeomdirectly(feature::Feature, geom::Geometry)
    result = GDAL.setgeometrydirectly(feature.ptr, geom.ptr)
    if result != GDAL.OGRERR_NONE
        error("Failed to set feature geometry.")
    end
end

"""
Set feature geometry.

### Parameters
* **feature**: the feature on which new geometry is applied to.
* **geometry**: the new geometry to apply to feature.
### Returns
OGRERR_NONE if successful, or OGR_UNSUPPORTED_GEOMETRY_TYPE if the geometry
type is illegal for the OGRFeatureDefn (checking not yet implemented).
"""
function setgeom(feature::Feature, geom::Geometry)
    result = GDAL.setgeometry(feature.ptr, geom.ptr)
    if result != GDAL.OGRERR_NONE
        error("Failed to set feature geometry.")
    end
end

"""
Fetch an handle to feature geometry.

### Returns
an handle to internal feature geometry. This object should not be modified.
"""
getgeom(feature::Feature) = Geometry(GDAL.getgeometryref(feature.ptr))

"Take away ownership of geometry."
stealgeometry(feature::Feature) = Geometry(GDAL.stealgeometry(feature.ptr))

"Duplicate feature."
clone(feature::Feature) = Feature(GDAL.clone(feature.ptr))

"Test if two features are the same."
equal(feature1::Feature, feature2::Feature) =
    Bool(GDAL.equal(feature1.ptr, feature2.ptr))

"""
Fetch number of fields on this feature.

This will always be the same as the field count for the OGRFeatureDefn.
"""
nfield(feature::Feature) = GDAL.getfieldcount(feature.ptr)

"""
Fetch definition for this field.

### Parameters
* **feature**: the feature on which the field is found.
* **i**: the field to fetch, from 0 to GetFieldCount()-1.

### Returns
an handle to the field definition (from the OGRFeatureDefn). This is an
internal reference, and should not be deleted or modified.
"""
fetchfielddefn(feature::Feature, i::Integer) =
    FieldDefn(GDAL.getfielddefnref(feature.ptr, i))

fetchfields(feature::Feature) =
    Dict([getname(fetchfielddefn(feature, i-1)) => fetchfield(feature, i-1)
         for i in 1:nfield(feature)])

fetchfields{T <: Integer}(feature::Feature, indices::UnitRange{T}) =
    Dict([getname(fetchfielddefn(feature, i)) => fetchfield(feature, i)
         for i in indices])

fetchfields{T <: Integer}(feature::Feature, indices::Vector{T}) =
    Dict([getname(fetchfielddefn(feature, i)) => fetchfield(feature, i)
         for i in indices])

fetchfields(feature::Feature, names::Vector{ASCIIString}) =
    Dict([name => fetchfield(feature, getfieldindex(feature, name))
         for name in names])

fetchgeomfields(feature::Feature) =
    Dict([getname(fetchgeomfielddefn(feature, i)) =>
          toWKT(fetchgeomfield(feature, i))
          for i in 1:ngeomfield(feature)])

"""
Fetch the field index given field name.

### Parameters
* **feature**: the feature on which the field is found.
* **name**: the name of the field to search for.

### Returns
the field index, or -1 if no matching field is found.
"""
getfieldindex(feature::Feature, name::AbstractString) =
    GDAL.getfieldindex(feature.ptr, name)

"""Test if a field has ever been assigned a value or not.

### Parameters
* **feature**: the feature that owned the field.
* **i**: the field to fetch, from 0 to GetFieldCount()-1.
"""
isfieldset(feature::Feature, i::Integer) =
    Bool(GDAL.isfieldset(feature.ptr, i))

"""
Clear a field, marking it as unset.

### Parameters
* **feature**: the feature that owned the field.
* **i**: the field to fetch, from 0 to GetFieldCount()-1.
"""
unsetfield(feature::Feature, i::Integer) = GDAL.unsetfield(feature.ptr, i)

"""Fetch field value as integer.

### Parameters
* **feature**: the feature that owned the field.
* **i**: the field to fetch, from 0 to GetFieldCount()-1.
"""
asint(feature::Feature, i::Integer) = GDAL.getfieldasinteger(feature.ptr, i)

"""Fetch field value as integer 64 bit.

### Parameters
* **feature**: the feature that owned the field.
* **i**: the field to fetch, from 0 to GetFieldCount()-1.
"""
asint64(feature::Feature, i::Integer) = GDAL.getfieldasinteger64(feature.ptr, i)

"""Fetch field value as a double.

### Parameters
* **feature**: the feature that owned the field.
* **i**: the field to fetch, from 0 to GetFieldCount()-1.
"""
asdouble(feature::Feature, i::Integer) = GDAL.getfieldasdouble(feature.ptr, i)

"""
Fetch field value as a string.

### Parameters
* **feature**: the feature that owned the field.
* **i**: the field to fetch, from 0 to GetFieldCount()-1.
"""
asstring(feature::Feature, i::Integer) = GDAL.getfieldasstring(feature.ptr, i)

# """
#     OGR_F_GetFieldAsIntegerList(OGRFeatureH hFeat,
#                                 int iField,
#                                 int * pnCount) -> const int *
# Fetch field value as a list of integers.
# ### Parameters
# * **hFeat**: handle to the feature that owned the field.
# * **iField**: the field to fetch, from 0 to GetFieldCount()-1.
# * **pnCount**: an integer to put the list count (number of integers) into.
# ### Returns
# the field value. This list is internal, and should not be modified, or freed. Its lifetime may be very brief. If *pnCount is zero on return the returned pointer may be NULL or non-NULL.
# """
# function getfieldasintegerlist(arg1::Ptr{OGRFeatureH},arg2::Integer,arg3)
#     ccall((:OGR_F_GetFieldAsIntegerList,libgdal),Ptr{Cint},(Ptr{OGRFeatureH},Cint,Ptr{Cint}),arg1,arg2,arg3)
# end


# """
#     OGR_F_GetFieldAsInteger64List(OGRFeatureH hFeat,
#                                   int iField,
#                                   int * pnCount) -> const GIntBig *
# Fetch field value as a list of 64 bit integers.
# ### Parameters
# * **hFeat**: handle to the feature that owned the field.
# * **iField**: the field to fetch, from 0 to GetFieldCount()-1.
# * **pnCount**: an integer to put the list count (number of integers) into.
# ### Returns
# the field value. This list is internal, and should not be modified, or freed. Its lifetime may be very brief. If *pnCount is zero on return the returned pointer may be NULL or non-NULL.
# """
# function getfieldasinteger64list(arg1::Ptr{OGRFeatureH},arg2::Integer,arg3)
#     ccall((:OGR_F_GetFieldAsInteger64List,libgdal),Ptr{GIntBig},(Ptr{OGRFeatureH},Cint,Ptr{Cint}),arg1,arg2,arg3)
# end


# """
#     OGR_F_GetFieldAsDoubleList(OGRFeatureH hFeat,
#                                int iField,
#                                int * pnCount) -> const double *
# Fetch field value as a list of doubles.
# ### Parameters
# * **hFeat**: handle to the feature that owned the field.
# * **iField**: the field to fetch, from 0 to GetFieldCount()-1.
# * **pnCount**: an integer to put the list count (number of doubles) into.
# ### Returns
# the field value. This list is internal, and should not be modified, or freed. Its lifetime may be very brief. If *pnCount is zero on return the returned pointer may be NULL or non-NULL.
# """
# function getfieldasdoublelist(arg1::Ptr{OGRFeatureH},arg2::Integer,arg3)
#     ccall((:OGR_F_GetFieldAsDoubleList,libgdal),Ptr{Cdouble},(Ptr{OGRFeatureH},Cint,Ptr{Cint}),arg1,arg2,arg3)
# end


# """
#     OGR_F_GetFieldAsStringList(OGRFeatureH hFeat,
#                                int iField) -> char **
# Fetch field value as a list of strings.
# ### Parameters
# * **hFeat**: handle to the feature that owned the field.
# * **iField**: the field to fetch, from 0 to GetFieldCount()-1.
# ### Returns
# the field value. This list is internal, and should not be modified, or freed. Its lifetime may be very brief.
# """
# function getfieldasstringlist(arg1::Ptr{OGRFeatureH},arg2::Integer)
#     bytestring(unsafe_load(ccall((:OGR_F_GetFieldAsStringList,libgdal),Ptr{Cstring},(Ptr{OGRFeatureH},Cint),arg1,arg2)))
# end


# """
#     OGR_F_GetFieldAsBinary(OGRFeatureH hFeat,
#                            int iField,
#                            int * pnBytes) -> GByte *
# Fetch field value as binary.
# ### Parameters
# * **hFeat**: handle to the feature that owned the field.
# * **iField**: the field to fetch, from 0 to GetFieldCount()-1.
# * **pnBytes**: location to place count of bytes returned.
# ### Returns
# the field value. This list is internal, and should not be modified, or freed. Its lifetime may be very brief.
# """
# function getfieldasbinary(arg1::Ptr{OGRFeatureH},arg2::Integer,arg3)
#     ccall((:OGR_F_GetFieldAsBinary,libgdal),Ptr{GByte},(Ptr{OGRFeatureH},Cint,Ptr{Cint}),arg1,arg2,arg3)
# end


# """
#     OGR_F_GetFieldAsDateTime(OGRFeatureH hFeat,
#                              int iField,
#                              int * pnYear,
#                              int * pnMonth,
#                              int * pnDay,
#                              int * pnHour,
#                              int * pnMinute,
#                              int * pnSecond,
#                              int * pnTZFlag) -> int
# Fetch field value as date and time.
# ### Parameters
# * **hFeat**: handle to the feature that owned the field.
# * **iField**: the field to fetch, from 0 to GetFieldCount()-1.
# * **pnYear**: (including century)
# * **pnMonth**: (1-12)
# * **pnDay**: (1-31)
# * **pnHour**: (0-23)
# * **pnMinute**: (0-59)
# * **pnSecond**: (0-59)
# * **pnTZFlag**: (0=unknown, 1=localtime, 100=GMT, see data model for details)
# ### Returns
# TRUE on success or FALSE on failure.
# """
# function getfieldasdatetime(arg1::Ptr{OGRFeatureH},arg2::Integer,arg3,arg4,arg5,arg6,arg7,arg8,arg9)
#     ccall((:OGR_F_GetFieldAsDateTime,libgdal),Cint,(Ptr{OGRFeatureH},Cint,Ptr{Cint},Ptr{Cint},Ptr{Cint},Ptr{Cint},Ptr{Cint},Ptr{Cint},Ptr{Cint}),arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9)
# end


# """
#     OGR_F_GetFieldAsDateTimeEx(OGRFeatureH hFeat,
#                                int iField,
#                                int * pnYear,
#                                int * pnMonth,
#                                int * pnDay,
#                                int * pnHour,
#                                int * pnMinute,
#                                float * pfSecond,
#                                int * pnTZFlag) -> int
# Fetch field value as date and time.
# ### Parameters
# * **hFeat**: handle to the feature that owned the field.
# * **iField**: the field to fetch, from 0 to GetFieldCount()-1.
# * **pnYear**: (including century)
# * **pnMonth**: (1-12)
# * **pnDay**: (1-31)
# * **pnHour**: (0-23)
# * **pnMinute**: (0-59)
# * **pfSecond**: (0-59 with millisecond accuracy)
# * **pnTZFlag**: (0=unknown, 1=localtime, 100=GMT, see data model for details)
# ### Returns
# TRUE on success or FALSE on failure.
# """
# function getfieldasdatetimeex(hFeat::Ptr{OGRFeatureH},iField::Integer,pnYear,pnMonth,pnDay,pnHour,pnMinute,pfSecond,pnTZFlag)
#     ccall((:OGR_F_GetFieldAsDateTimeEx,libgdal),Cint,(Ptr{OGRFeatureH},Cint,Ptr{Cint},Ptr{Cint},Ptr{Cint},Ptr{Cint},Ptr{Cint},Ptr{Cfloat},Ptr{Cint}),hFeat,iField,pnYear,pnMonth,pnDay,pnHour,pnMinute,pfSecond,pnTZFlag)
# end

function fetchfield(feature::Feature, i::Integer)
    const FETCHFIELD = Dict{GDAL.OGRFieldType, Function}(
                        GDAL.OFTInteger => asint,
                        GDAL.OFTInteger64 => asint64,
                        GDAL.OFTReal => asdouble,
                        GDAL.OFTString => asstring)
    asnothing(feature::Feature, i::Integer) = nothing
    if isfieldset(feature, i)
        # _fielddefn = 
        # _fieldname = getname(feature, i)
        _fieldtype = gettype(fetchfielddefn(feature, i))
        _fetchfield = get(FETCHFIELD, _fieldtype, asnothing)
        return _fetchfield(feature, i)
    end
end

fetchfield(feature::Feature, name::AbstractString) =
    fetchfield(feature, getfieldindex(feature, name))

"""
Set field to integer value.

### Parameters
* **feature**: handle to the feature that owned the field.
* **i**: the field to fetch, from 0 to GetFieldCount()-1.
* **value**: the value to assign.
"""
setfield(feature::Feature, i::Integer, value::Integer) =
    GDAL.setfieldinteger(feature.ptr, i, value)

"""
Set field to 64 bit integer value.

### Parameters
* **feature**: handle to the feature that owned the field.
* **i**: the field to fetch, from 0 to GetFieldCount()-1.
* **value**: the value to assign.
"""
setfield(feature::Feature, i::Integer, value::Int64) =
    GDAL.setfieldinteger64(feature.ptr, i, value)

"""
Set field to double value.

### Parameters
* **feature**: handle to the feature that owned the field.
* **i**: the field to fetch, from 0 to GetFieldCount()-1.
* **value**: the value to assign.
"""
setfield(feature::Feature, i::Integer, value::Cdouble) =
    GDAL.setfielddouble(feature.ptr, i, value)

"""
Set field to string value.

### Parameters
* **feature**: handle to the feature that owned the field.
* **i**: the field to fetch, from 0 to GetFieldCount()-1.
* **value**: the value to assign.
"""
setfield(feature::Feature, i::Integer, value::AbstractString) =
    GDAL.setfieldstring(feature.ptr, i, value)

# """
#     OGR_F_SetFieldIntegerList(OGRFeatureH hFeat,
#                               int iField,
#                               int nCount,
#                               int * panValues) -> void
# Set field to list of integers value.
# ### Parameters
# * **hFeat**: handle to the feature that owned the field.
# * **iField**: the field to set, from 0 to GetFieldCount()-1.
# * **nCount**: the number of values in the list being assigned.
# * **panValues**: the values to assign.
# """
# function setfieldintegerlist(arg1::Ptr{OGRFeatureH},arg2::Integer,arg3::Integer,arg4)
#     ccall((:OGR_F_SetFieldIntegerList,libgdal),Void,(Ptr{OGRFeatureH},Cint,Cint,Ptr{Cint}),arg1,arg2,arg3,arg4)
# end


# """
#     OGR_F_SetFieldInteger64List(OGRFeatureH hFeat,
#                                 int iField,
#                                 int nCount,
#                                 const GIntBig * panValues) -> void
# Set field to list of 64 bit integers value.
# ### Parameters
# * **hFeat**: handle to the feature that owned the field.
# * **iField**: the field to set, from 0 to GetFieldCount()-1.
# * **nCount**: the number of values in the list being assigned.
# * **panValues**: the values to assign.
# """
# function setfieldinteger64list(arg1::Ptr{OGRFeatureH},arg2::Integer,arg3::Integer,arg4)
#     ccall((:OGR_F_SetFieldInteger64List,libgdal),Void,(Ptr{OGRFeatureH},Cint,Cint,Ptr{GIntBig}),arg1,arg2,arg3,arg4)
# end


# """
#     OGR_F_SetFieldDoubleList(OGRFeatureH hFeat,
#                              int iField,
#                              int nCount,
#                              double * padfValues) -> void
# Set field to list of doubles value.
# ### Parameters
# * **hFeat**: handle to the feature that owned the field.
# * **iField**: the field to set, from 0 to GetFieldCount()-1.
# * **nCount**: the number of values in the list being assigned.
# * **padfValues**: the values to assign.
# """
# function setfielddoublelist(arg1::Ptr{OGRFeatureH},arg2::Integer,arg3::Integer,arg4)
#     ccall((:OGR_F_SetFieldDoubleList,libgdal),Void,(Ptr{OGRFeatureH},Cint,Cint,Ptr{Cdouble}),arg1,arg2,arg3,arg4)
# end


# """
#     OGR_F_SetFieldStringList(OGRFeatureH hFeat,
#                              int iField,
#                              char ** papszValues) -> void
# Set field to list of strings value.
# ### Parameters
# * **hFeat**: handle to the feature that owned the field.
# * **iField**: the field to set, from 0 to GetFieldCount()-1.
# * **papszValues**: the values to assign.
# """
# function setfieldstringlist(arg1::Ptr{OGRFeatureH},arg2::Integer,arg3)
#     ccall((:OGR_F_SetFieldStringList,libgdal),Void,(Ptr{OGRFeatureH},Cint,Ptr{Cstring}),arg1,arg2,arg3)
# end


# """
#     OGR_F_SetFieldRaw(OGRFeatureH hFeat,
#                       int iField,
#                       OGRField * psValue) -> void
# Set field.
# ### Parameters
# * **hFeat**: handle to the feature that owned the field.
# * **iField**: the field to fetch, from 0 to GetFieldCount()-1.
# * **psValue**: handle on the value to assign.
# """
# function setfieldraw(arg1::Ptr{OGRFeatureH},arg2::Integer,arg3)
#     ccall((:OGR_F_SetFieldRaw,libgdal),Void,(Ptr{OGRFeatureH},Cint,Ptr{OGRField}),arg1,arg2,arg3)
# end


# """
#     OGR_F_SetFieldBinary(OGRFeatureH hFeat,
#                          int iField,
#                          int nBytes,
#                          GByte * pabyData) -> void
# Set field to binary data.
# ### Parameters
# * **hFeat**: handle to the feature that owned the field.
# * **iField**: the field to set, from 0 to GetFieldCount()-1.
# * **nBytes**: the number of bytes in pabyData array.
# * **pabyData**: the data to apply.
# """
# function setfieldbinary(arg1::Ptr{OGRFeatureH},arg2::Integer,arg3::Integer,arg4)
#     ccall((:OGR_F_SetFieldBinary,libgdal),Void,(Ptr{OGRFeatureH},Cint,Cint,Ptr{GByte}),arg1,arg2,arg3,arg4)
# end


# """
#     OGR_F_SetFieldDateTime(OGRFeatureH hFeat,
#                            int iField,
#                            int nYear,
#                            int nMonth,
#                            int nDay,
#                            int nHour,
#                            int nMinute,
#                            int nSecond,
#                            int nTZFlag) -> void
# Set field to datetime.
# ### Parameters
# * **hFeat**: handle to the feature that owned the field.
# * **iField**: the field to set, from 0 to GetFieldCount()-1.
# * **nYear**: (including century)
# * **nMonth**: (1-12)
# * **nDay**: (1-31)
# * **nHour**: (0-23)
# * **nMinute**: (0-59)
# * **nSecond**: (0-59)
# * **nTZFlag**: (0=unknown, 1=localtime, 100=GMT, see data model for details)
# """
# function setfielddatetime(arg1::Ptr{OGRFeatureH},arg2::Integer,arg3::Integer,arg4::Integer,arg5::Integer,arg6::Integer,arg7::Integer,arg8::Integer,arg9::Integer)
#     ccall((:OGR_F_SetFieldDateTime,libgdal),Void,(Ptr{OGRFeatureH},Cint,Cint,Cint,Cint,Cint,Cint,Cint,Cint),arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9)
# end


# """
#     OGR_F_SetFieldDateTimeEx(OGRFeatureH hFeat,
#                              int iField,
#                              int nYear,
#                              int nMonth,
#                              int nDay,
#                              int nHour,
#                              int nMinute,
#                              float fSecond,
#                              int nTZFlag) -> void
# Set field to datetime.
# ### Parameters
# * **hFeat**: handle to the feature that owned the field.
# * **iField**: the field to set, from 0 to GetFieldCount()-1.
# * **nYear**: (including century)
# * **nMonth**: (1-12)
# * **nDay**: (1-31)
# * **nHour**: (0-23)
# * **nMinute**: (0-59)
# * **fSecond**: (0-59, with millisecond accuracy)
# * **nTZFlag**: (0=unknown, 1=localtime, 100=GMT, see data model for details)
# """
# function setfielddatetimeex(arg1::Ptr{OGRFeatureH},arg2::Integer,arg3::Integer,arg4::Integer,arg5::Integer,arg6::Integer,arg7::Integer,arg8::Cfloat,arg9::Integer)
#     ccall((:OGR_F_SetFieldDateTimeEx,libgdal),Void,(Ptr{OGRFeatureH},Cint,Cint,Cint,Cint,Cint,Cint,Cfloat,Cint),arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9)
# end


"""
Fetch number of geometry fields on this feature.

This will always be the same as the geometry field count for OGRFeatureDefn.
"""
ngeomfield(feature::Feature) = GDAL.getgeomfieldcount(feature.ptr)

"""
Fetch definition for this geometry field.

### Parameters
* **feature**: the feature on which the field is found.
* **i**: the field to fetch, from 0 to GetGeomFieldCount()-1.

### Returns
The field definition (from the OGRFeatureDefn). This is an
internal reference, and should not be deleted or modified.
"""
fetchgeomfielddefn(feature::Feature, i::Integer) =
    GeomFieldDefn(GDAL.getgeomfielddefnref(feature.ptr, i))

"""
Fetch the geometry field index given geometry field name.

### Parameters
* **feature**: the feature on which the geometry field is found.
* **name**: the name of the geometry field to search for.

### Returns
the geometry field index, or -1 if no matching geometry field is found.
"""
getgeomfieldindex(feature::Feature, name::AbstractString) =
    GDAL.getgeomfieldindex(feature.ptr, i)

"""
Fetch the feature geometry.

### Parameters
* **feature**: handle to the feature to get geometry from.
* **i**: geometry field to get.

### Returns
an internal feature geometry. This object should not be modified.
"""
fetchgeomfield(feature::Feature, i::Integer) =
    Geometry(GDAL.getgeomfieldref(feature.ptr, i))

"""
Set feature geometry of a specified geometry field.

### Parameters
* **feature**: the feature on which to apply the geometry.
* **i**: geometry field to set.
* **geom**: the new geometry to apply to feature.

### Returns
OGRERR_NONE if successful, or OGRERR_FAILURE if the index is invalid,
or OGR_UNSUPPORTED_GEOMETRY_TYPE if the geometry type is illegal for
the OGRFeatureDefn (checking not yet implemented).
"""
function setgeomfielddirectly(feature::Feature, i::Integer, geom::Geometry)
    result = GDAL.setgeomfielddirectly(feature.ptr, i, geom.ptr)
    if result != GDAL.OGRERR_NONE
        error("Failed to set feature geometry")
    end
end

"""
Set feature geometry of a specified geometry field.

### Parameters
* **feature**: the feature on which to apply the geometry.
* **i**: geometry field to set.
* **geom**: the new geometry to apply to feature.

### Returns
OGRERR_NONE if successful, or OGRERR_FAILURE if the index is invalid,
or OGR_UNSUPPORTED_GEOMETRY_TYPE if the geometry type is illegal for
the OGRFeatureDefn (checking not yet implemented).
"""
function setgeomfield(feature::Feature, i::Integer, geom::Geometry)
    GDAL.setgeomfield(feature.ptr, i, geom.ptr)
end

"""
Get feature identifier.

### Returns
feature id or OGRNullFID if none has been assigned.
"""
getfid(feature::Feature) = GDAL.getfid(feature.ptr)

"""
Set the feature identifier.

### Parameters
* **feature**: handle to the feature to set the feature id to.
* **i**: the new feature identifier value to assign.

### Returns
On success OGRERR_NONE, or on failure some other value.
"""
function setfid(feature::Feature, i::Integer)
    result = GDAL.setfid(feature.ptr, i)
    if result != GDAL.OGRERR_NONE
        error("Failed to set FID")
    end
end

# """
#     OGR_F_DumpReadable(OGRFeatureH hFeat,
#                        FILE * fpOut) -> void
# Dump this feature in a human readable form.
# ### Parameters
# * **hFeat**: handle to the feature to dump.
# * **fpOut**: the stream to write to, such as strout.
# """
# function dumpreadable(arg1::Ptr{OGRFeatureH},arg2)
#     ccall((:OGR_F_DumpReadable,libgdal),Void,(Ptr{OGRFeatureH},Ptr{FILE}),arg1,arg2)
# end


"""
Set one feature from another.

### Parameters
* **feature1**: handle to the feature to set to.
* **feature2**: handle to the feature from which geometry, and field values
    will be copied.
* **forgiving**: TRUE if the operation should continue despite lacking output
    fields matching some of the source fields.

### Returns
OGRERR_NONE if the operation succeeds, even if some values are not transferred,
otherwise an error code.
"""
function setfrom(feature1::Feature, feature2::Feature, forgiving::Bool=false)
    result = GDAL.setfrom(feature1.ptr, feature2.ptr, forgiving)
    if result != GDAL.OGRERR_NONE
        error("Failed to set feature")
    end
end

"""
Set one feature from another.

### Parameters
* **feature1**: the feature to set to.
* **feature2**: the feature from which geometry and field values will be copied
* **indices**: indices of the destination feature's fields stored at the
    corresponding index of the source feature's fields. A value of -1 should be
    used to ignore the source's field. The array should not be NULL and be as
    long as the number of fields in the source feature.
* **bForgiving**: TRUE if the operation should continue despite lacking output
    fields matching some of the source fields.

### Returns
OGRERR_NONE if the operation succeeds, even if some values are not transferred,
otherwise an error code.
"""
function setfrom(feature1::Feature, feature2::Feature, indices::Vector{Cint},
                 forgiving::Bool=false)
    result = GDAL.setfromwithmap(feature1.ptr, feature2.ptr, forgiving, pointer(indices))
    if result != GDAL.OGRERR_NONE
        error("Failed to set feature with map")
    end
end


"Fetch style string for this feature."
getstylestring(feature::Feature) = GDAL.getstylestring(feature.ptr)

"Set feature style string."
setstylestring(feature::Feature, style::AbstractString) =
    GDAL.setstylestring(feature.ptr, style)

"Set feature style string."
setstylestringdirectly(feature::Feature, style::AbstractString) =
    GDAL.setstylestringdirectly(feature.ptr, style)

# """
#     OGR_F_GetStyleTable(OGRFeatureH hFeat) -> OGRStyleTableH
# """
# function getstyletable(arg1::Ptr{OGRFeatureH})
#     checknull(ccall((:OGR_F_GetStyleTable,libgdal),Ptr{OGRStyleTableH},(Ptr{OGRFeatureH},),arg1))
# end


# """
#     OGR_F_SetStyleTableDirectly(OGRFeatureH hFeat,
#                                 OGRStyleTableH hStyleTable) -> void
# """
# function setstyletabledirectly(arg1::Ptr{OGRFeatureH},arg2::Ptr{OGRStyleTableH})
#     ccall((:OGR_F_SetStyleTableDirectly,libgdal),Void,(Ptr{OGRFeatureH},Ptr{OGRStyleTableH}),arg1,arg2)
# end


# """
#     OGR_F_SetStyleTable(OGRFeatureH hFeat,
#                         OGRStyleTableH hStyleTable) -> void
# """
# function setstyletable(arg1::Ptr{OGRFeatureH},arg2::Ptr{OGRStyleTableH})
#     ccall((:OGR_F_SetStyleTable,libgdal),Void,(Ptr{OGRFeatureH},Ptr{OGRStyleTableH}),arg1,arg2)
# end


"Returns the native data for the feature."
getnativedata(feature::Feature) = GDAL.getnativedata(feature.ptr)

"Sets the native data for the feature."
setnativedata(feature::Feature, data::AbstractString) =
    GDAL.setnativedata(feature.ptr, data)

"Returns the native media type for the feature."
getmediatype(feature::Feature) = GDAL.getnativemediatype(feature.ptr)

"Sets the native media type for the feature."
setmediatype(feature::Feature, mediatype::AbstractString) =
    GDAL.setnativemediatype(feature.ptr, mediatype)

"""
Fill unset fields with default values that might be defined.

### Parameters
* **feature**: handle to the feature.
* **notnull**: if we should fill only unset fields with a not-null constraint.
* **papszOptions**: unused currently. Must be set to NULL.
"""
fillunset(feature::Feature, notnull::Bool=true) =
    GDAL.fillunsetwithdefault(feature.ptr, notnull)

"""
Validate that a feature meets constraints of its schema.

### Parameters
* **feature**: handle to the feature to validate.
* **flags**: OGR_F_VAL_ALL or combination of OGR_F_VAL_NULL,
    OGR_F_VAL_GEOM_TYPE, OGR_F_VAL_WIDTH and OGR_F_VAL_ALLOW_NULL_WHEN_DEFAULT
    with '|' operator
* **emiterror**: TRUE if a CPLError() must be emitted when a check fails

### Returns
TRUE if all enabled validation tests pass.
"""
validate(feature::Feature, flags::Integer, emiterror::Bool) =
    Bool(GDAL.validate(feature.ptr, flags, emiterror))

"Fetch the schema information for this layer."
getlayerdefn(layer::FeatureLayer) = FeatureDefn(GDAL.getlayerdefn(layer.ptr))

"""
Find the index of field in a layer.

### Returns
field index, or -1 if the field doesn't exist
"""
findfieldindex(layer::FeatureLayer, field::AbstractString, exactmatch::Bool) =
    GDAL.findfieldindex(layer.ptr, field, exactmatch)

"""
Fetch the feature count in this layer.

### Parameters
* **layer**: handle to the layer that owned the features.
* **force**: Flag indicating whether the count should be computed even if it
    is expensive.

### Returns
feature count, -1 if count not known.
"""
nfeature(layer::FeatureLayer, force::Bool=false) =
    GDAL.getfeaturecount(layer.ptr, force)

# """
#     OGR_L_GetExtent(OGRLayerH,
#                     OGREnvelope *,
#                     int) -> OGRErr
# Fetch the extent of this layer.
# ### Parameters
# * **hLayer**: handle to the layer from which to get extent.
# * **psExtent**: the structure in which the extent value will be returned.
# * **bForce**: Flag indicating whether the extent should be computed even if it is expensive.
# ### Returns
# OGRERR_NONE on success, OGRERR_FAILURE if extent not known.
# """
# function getextent{T <: OGRLayerH}(arg1::Ptr{T},arg2,arg3::Integer)
#     ccall((:OGR_L_GetExtent,libgdal),OGRErr,(Ptr{OGRLayerH},Ptr{OGREnvelope},Cint),arg1,arg2,arg3)
# end


# """
#     OGR_L_GetExtentEx(OGRLayerH,
#                       int iGeomField,
#                       OGREnvelope * psExtent,
#                       int bForce) -> OGRErr
# Fetch the extent of this layer, on the specified geometry field.
# ### Parameters
# * **hLayer**: handle to the layer from which to get extent.
# * **iGeomField**: the index of the geometry field on which to compute the extent.
# * **psExtent**: the structure in which the extent value will be returned.
# * **bForce**: Flag indicating whether the extent should be computed even if it is expensive.
# ### Returns
# OGRERR_NONE on success, OGRERR_FAILURE if extent not known.
# """
# function getextentex{T <: OGRLayerH}(arg1::Ptr{T},iGeomField::Integer,psExtent,bForce::Integer)
#     ccall((:OGR_L_GetExtentEx,libgdal),OGRErr,(Ptr{OGRLayerH},Cint,Ptr{OGREnvelope},Cint),arg1,iGeomField,psExtent,bForce)
# end

"""
Create a new field on a layer.

### Parameters
* **layer**: the layer to write the field definition.
* **field**: the field definition to write to disk.
* **approx**: If TRUE, the field may be created in a slightly different form
depending on the limitations of the format driver.

### Returns
OGRERR_NONE on success.
"""
function createfield(layer::FeatureLayer, field::FieldDefn,
                     approx::Bool = false)
    result = GDAL.createfield(layer.ptr, field.ptr, approx)
    if result != GDAL.OGRERR_NONE
        error("Failed to create new field")
    end
end

"""
Create a new geometry field on a layer.

### Parameters
* **layer**: the layer to write the field definition.
* **field**: the geometry field definition to write to disk.
* **approx**: If TRUE, the field may be created in a slightly different form
depending on the limitations of the format driver.

### Returns
OGRERR_NONE on success.
"""
function createfield(layer::FeatureLayer, field::GeomFieldDefn,
                     approx::Bool = false)
    result = GDAL.creategeomfield(layer.ptr, field.ptr, approx)
    if result != GDAL.OGRERR_NONE
        error("Failed to create new field")
    end
end


"""
Delete the field at index i on a layer.

### Parameters
* **layer**: handle to the layer.
* **i**: index of the field to delete.

### Returns
OGRERR_NONE on success.
"""
function deletefield(layer::FeatureLayer, i::Integer)
    result = GDAL.deletefield(layer, i)
    if result != GDAL.OGRERR_NONE
        error("Failed to delete field")
    end
end

# """
#     OGR_L_ReorderFields(OGRLayerH,
#                         int * panMap) -> OGRErr
# Reorder all the fields of a layer.
# ### Parameters
# * **hLayer**: handle to the layer.
# * **panMap**: an array of GetLayerDefn()->OGRFeatureDefn::GetFieldCount() elements which is a permutation of [0, GetLayerDefn()->OGRFeatureDefn::GetFieldCount()-1].
# ### Returns
# OGRERR_NONE on success.
# """
# function reorderfields{T <: OGRLayerH}(arg1::Ptr{T},panMap)
#     ccall((:OGR_L_ReorderFields,libgdal),OGRErr,(Ptr{OGRLayerH},Ptr{Cint}),arg1,panMap)
# end


# """
#     OGR_L_ReorderField(OGRLayerH,
#                        int iOldFieldPos,
#                        int iNewFieldPos) -> OGRErr
# Reorder an existing field on a layer.
# ### Parameters
# * **hLayer**: handle to the layer.
# * **iOldFieldPos**: previous position of the field to move. Must be in the range [0,GetFieldCount()-1].
# * **iNewFieldPos**: new position of the field to move. Must be in the range [0,GetFieldCount()-1].
# ### Returns
# OGRERR_NONE on success.
# """
# function reorderfield{T <: OGRLayerH}(arg1::Ptr{T},iOldFieldPos::Integer,iNewFieldPos::Integer)
#     ccall((:OGR_L_ReorderField,libgdal),OGRErr,(Ptr{OGRLayerH},Cint,Cint),arg1,iOldFieldPos,iNewFieldPos)
# end


# """
#     OGR_L_AlterFieldDefn(OGRLayerH,
#                          int iField,
#                          OGRFieldDefnH hNewFieldDefn,
#                          int nFlags) -> OGRErr
# Alter the definition of an existing field on a layer.
# ### Parameters
# * **hLayer**: handle to the layer.
# * **iField**: index of the field whose definition must be altered.
# * **hNewFieldDefn**: new field definition
# * **nFlags**: combination of ALTER_NAME_FLAG, ALTER_TYPE_FLAG, ALTER_WIDTH_PRECISION_FLAG, ALTER_NULLABLE_FLAG and ALTER_DEFAULT_FLAG to indicate which of the name and/or type and/or width and precision fields and/or nullability from the new field definition must be taken into account.
# ### Returns
# OGRERR_NONE on success.
# """
# function alterfielddefn{T <: OGRLayerH}(arg1::Ptr{T},iField::Integer,hNewFieldDefn::Ptr{OGRFieldDefnH},nFlags::Integer)
#     ccall((:OGR_L_AlterFieldDefn,libgdal),OGRErr,(Ptr{OGRLayerH},Cint,Ptr{OGRFieldDefnH},Cint),arg1,iField,hNewFieldDefn,nFlags)
# end

"""
This method returns the name of the underlying database column being used as
the geometry column, or "" if not supported.
"""
getgeomcolumn(layer::FeatureLayer) = GDAL.getgeometrycolumn(layer.ptr)

"""
Set which fields can be omitted when retrieving features from the layer.

### Parameters
* **fieldnames**: an array of field names terminated by NULL item. If NULL is
passed, the ignored list is cleared.

### Returns
OGRERR_NONE if all field names have been resolved (even if the driver does not
support this method)
"""
function ignorefields(layer::FeatureLayer, fieldnames)
    GDAL.setignoredfields(layer.ptr, Ptr{Ptr{UInt8}}(pointer(fieldnames)))
end


"""
Intersection of two layers.

### Parameters
* **input**: the input layer. Should not be NULL.
* **method**: the method layer. Should not be NULL.
* **result**: the layer where the features resulting from the operation
    are inserted. Should not be NULL. See above the note about the schema.
* **papszOptions**: NULL terminated list of options (may be NULL).
* **pfnProgress**: a GDALProgressFunc() compatible callback function for
    reporting progress or NULL.
* **pProgressArg**: argument to be passed to pfnProgress. May be NULL.

### Returns
an error code if there was an error or the execution was interrupted,
OGRERR_NONE otherwise.
"""
function intersection(input::FeatureLayer, method::FeatureLayer,
                      result::FeatureLayer)
    result = GDAL.intersection(input.ptr, method.ptr, result.ptr,
                               C_NULL, C_NULL, C_NULL)
    if result != GDAL.OGRERR_NONE
        error("Failed to compute the intersection of the two layers")
    end
end

"""
Union of two layers.

### Parameters
* **input**: the input layer. Should not be NULL.
* **method**: the method layer. Should not be NULL.
* **result**: the layer where the features resulting from the operation
    are inserted. Should not be NULL. See above the note about the schema.
* **papszOptions**: NULL terminated list of options (may be NULL).
* **pfnProgress**: a GDALProgressFunc() compatible callback function for
    reporting progress or NULL.
* **pProgressArg**: argument to be passed to pfnProgress. May be NULL.

### Returns
an error code if there was an error or the execution was interrupted,
OGRERR_NONE otherwise.
"""
function union(input::FeatureLayer, method::FeatureLayer, result::FeatureLayer)
    result = GDAL.union(input.ptr, method.ptr, result.ptr,
                        C_NULL, C_NULL, C_NULL)
    if result != GDAL.OGRERR_NONE
        error("Failed to compute the union of the two layers")
    end
end

"""
Symmetrical difference of two layers.

### Parameters
* **input**: the input layer. Should not be NULL.
* **method**: the method layer. Should not be NULL.
* **result**: the layer where the features resulting from the operation
    are inserted. Should not be NULL. See above the note about the schema.
* **papszOptions**: NULL terminated list of options (may be NULL).
* **pfnProgress**: a GDALProgressFunc() compatible callback function for
    reporting progress or NULL.
* **pProgressArg**: argument to be passed to pfnProgress. May be NULL.

### Returns
an error code if there was an error or the execution was interrupted,
OGRERR_NONE otherwise.
"""
function symdifference(input::FeatureLayer, method::FeatureLayer,
                       result::FeatureLayer)
    result = GDAL.symdifference(input.ptr, method.ptr, result.ptr,
                                C_NULL, C_NULL, C_NULL)
    if result != GDAL.OGRERR_NONE
        error("Failed to compute the sym difference of the two layers")
    end
end

"""
Identify the features of this layer with the ones from the identity layer.

### Parameters
* **input**: the input layer. Should not be NULL.
* **method**: the method layer. Should not be NULL.
* **result**: the layer where the features resulting from the operation
    are inserted. Should not be NULL. See above the note about the schema.
* **papszOptions**: NULL terminated list of options (may be NULL).
* **pfnProgress**: a GDALProgressFunc() compatible callback function for
    reporting progress or NULL.
* **pProgressArg**: argument to be passed to pfnProgress. May be NULL.

### Returns
an error code if there was an error or the execution was interrupted,
OGRERR_NONE otherwise.
"""
function identity(input::FeatureLayer, method::FeatureLayer,
                  result::FeatureLayer)
    result = GDAL.identity(input.ptr, method.ptr, result.ptr,
                           C_NULL, C_NULL, C_NULL)
    if result != GDAL.OGRERR_NONE
        error("Failed to compute the identity of the two layers")
    end
end

"""
Update this layer with features from the update layer.

### Parameters
* **input**: the input layer. Should not be NULL.
* **method**: the method layer. Should not be NULL.
* **result**: the layer where the features resulting from the operation
    are inserted. Should not be NULL. See above the note about the schema.
* **papszOptions**: NULL terminated list of options (may be NULL).
* **pfnProgress**: a GDALProgressFunc() compatible callback function for
    reporting progress or NULL.
* **pProgressArg**: argument to be passed to pfnProgress. May be NULL.

### Returns
an error code if there was an error or the execution was interrupted,
OGRERR_NONE otherwise.
"""
function update(input::FeatureLayer, method::FeatureLayer,
                result::FeatureLayer)
    result = GDAL.update(input.ptr, method.ptr, result.ptr,
                         C_NULL, C_NULL, C_NULL)
    if result != GDAL.OGRERR_NONE
        error("Failed to update the layer")
    end
end

"""
Clip off areas that are not covered by the method layer.

### Parameters
* **input**: the input layer. Should not be NULL.
* **method**: the method layer. Should not be NULL.
* **result**: the layer where the features resulting from the operation
    are inserted. Should not be NULL. See above the note about the schema.
* **papszOptions**: NULL terminated list of options (may be NULL).
* **pfnProgress**: a GDALProgressFunc() compatible callback function for
    reporting progress or NULL.
* **pProgressArg**: argument to be passed to pfnProgress. May be NULL.

### Returns
an error code if there was an error or the execution was interrupted,
OGRERR_NONE otherwise.
"""
function clip(input::FeatureLayer, method::FeatureLayer,
              result::FeatureLayer)
    result = GDAL.clip(input.ptr, method.ptr, result.ptr,
                       C_NULL, C_NULL, C_NULL)
    if result != GDAL.OGRERR_NONE
        error("Failed to clip the input layer")
    end
end

"""
Remove areas that are covered by the method layer.

### Parameters
* **input**: the input layer. Should not be NULL.
* **method**: the method layer. Should not be NULL.
* **result**: the layer where the features resulting from the operation
    are inserted. Should not be NULL. See above the note about the schema.
* **papszOptions**: NULL terminated list of options (may be NULL).
* **pfnProgress**: a GDALProgressFunc() compatible callback function for
    reporting progress or NULL.
* **pProgressArg**: argument to be passed to pfnProgress. May be NULL.

### Returns
an error code if there was an error or the execution was interrupted,
OGRERR_NONE otherwise.
"""
function erase(input::FeatureLayer, method::FeatureLayer,
               result::FeatureLayer)
    result = GDAL.erase(input.ptr, method.ptr, result.ptr,
                        C_NULL, C_NULL, C_NULL)
    if result != GDAL.OGRERR_NONE
        error("Failed to remove areas that are covered by the method layer.")
    end
end
