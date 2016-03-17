
"Return the layer name."
nameof(layer::FeatureLayer) = GDAL.getname(layer.ptr)

"Return the layer geometry type."
geomtype(layer::FeatureLayer) = GDAL.getgeomtype(layer.ptr)::GDAL.OGRwkbGeometryType

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
    OGR_L_SetSpatialFilterEx(OGRLayerH,
                             int iGeomField,
                             OGRGeometryH hGeom) -> void
Set a new spatial filter.
### Parameters
* **hLayer**: handle to the layer on which to set the spatial filter.
* **iGeomField**: index of the geometry field on which the spatial filter operates.
* **hGeom**: handle to the geometry to use as a filtering region. NULL may be passed indicating that the current spatial filter should be cleared, but no new one instituted.
"""
setspatialfilter(layer::FeatureLayer, index::Integer, geom::Geometry) = 
    GDAL.setspatialfilterex(layer.ptr, index, geom.ptr)

"""
    OGR_L_SetSpatialFilterRectEx(OGRLayerH,
                                 int iGeomField,
                                 double dfMinX,
                                 double dfMinY,
                                 double dfMaxX,
                                 double dfMaxY) -> void
Set a new rectangular spatial filter.
### Parameters
* **hLayer**: handle to the layer on which to set the spatial filter.
* **iGeomField**: index of the geometry field on which the spatial filter operates.
* **dfMinX**: the minimum X coordinate for the rectangular region.
* **dfMinY**: the minimum Y coordinate for the rectangular region.
* **dfMaxX**: the maximum X coordinate for the rectangular region.
* **dfMaxY**: the maximum Y coordinate for the rectangular region.
"""
setspatialfilter(layer::FeatureLayer, index::Integer,
                 xmin::Real, ymin::Real, xmax::Real, ymax::Real) = 
    GDAL.setspatialfilterrectex(layer.ptr, index, xmin, ymin, xmax, ymax)



"Fetch a feature layer for a dataset from its index (1 to nlayer)"
fetchlayer(dataset::Dataset, i::Integer) =
    FeatureLayer(GDAL.datasetgetlayer(dataset.ptr, i))

"Fetch a feature layer for a dataset from its name"
fetchlayer(dataset::Dataset, name::AbstractString) =
    FeatureLayer(GDAL.datasetgetlayerbyname(dataset.ptr, name))

"""
    GDALDatasetDeleteLayer(GDALDatasetH hDS,
                           int iLayer) -> OGRErr
Delete the indicated layer from the datasource.
### Parameters
* **hDS**: the dataset handle.
* **iLayer**: the index of the layer to delete.
### Returns
OGRERR_NONE on success, or OGRERR_UNSUPPORTED_OPERATION if deleting layers
is not supported for this datasource.
"""
deletelayer(dataset::Dataset, i::Integer) =
    GDAL.datasetdeletelayer(dataset.ptr, i)

"""
    GDALDatasetCreateLayer(GDALDatasetH hDS,
                           const char * pszName,
                           OGRSpatialReferenceH hSpatialRef,
                           OGRwkbGeometryType eGType,
                           char ** papszOptions) -> OGRLayerH
This function attempts to create a new layer on the dataset with the indicated name, coordinate system, geometry type.
### Parameters
* **hDS**: the dataset handle
* **pszName**: the name for the new layer. This should ideally not match any existing layer on the datasource.
* **hSpatialRef**: the coordinate system to use for the new layer, or NULL if no coordinate system is available.
* **eGType**: the geometry type for the layer. Use wkbUnknown if there are no constraints on the types geometry to be written.
* **papszOptions**: a StringList of name=value options. Options are driver specific.
### Returns
NULL is returned on failure, or a new OGRLayer handle on success.
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
    GDALDatasetCopyLayer(GDALDatasetH hDS,
                         OGRLayerH hSrcLayer,
                         const char * pszNewName,
                         char ** papszOptions) -> OGRLayerH
Duplicate an existing layer.
### Parameters
* **hDS**: the dataset handle.
* **hSrcLayer**: source layer.
* **pszNewName**: the name of the layer to create.
* **papszOptions**: a StringList of name=value options. Options are driver specific.
### Returns
an handle to the layer, or NULL if an error occurs.
"""
copylayer(dataset::Dataset,layer::FeatureLayer, name::AbstractString) =
    FeatureLayer(GDAL.datasetcopylayer(dataset.ptr, layer.ptr, name, C_NULL))

"""
    GDALDatasetExecuteSQL(GDALDatasetH hDS,
                          const char * pszStatement,
                          OGRGeometryH hSpatialFilter,
                          const char * pszDialect) -> OGRLayerH
Execute an SQL statement against the data store.
### Parameters
* **hDS**: the dataset handle.
* **pszStatement**: the SQL statement to execute.
* **hSpatialFilter**: geometry which represents a spatial filter. Can be NULL.
* **pszDialect**: allows control of the statement dialect. If set to NULL, the OGR SQL engine will be used, except for RDBMS drivers that will use their dedicated SQL engine, unless OGRSQL is explicitly passed as the dialect. Starting with OGR 1.10, the SQLITE dialect can also be used.
### Returns
an OGRLayer containing the results of the query. Deallocate with ReleaseResultSet().
"""
sqlquery(dataset::Dataset, query::AbstractString) =
    FeatureLayer(GDAL.datasetexecutesql(dataset.ptr, query, C_NULL, C_NULL))

sqlquery(dataset::Dataset, query::AbstractString, dialect::AbstractString) =
    FeatureLayer(GDAL.datasetexecutesql(dataset.ptr, query, C_NULL, dialect))

function sqlquery(dataset::Dataset,
                  query::AbstractString,
                  spatialfilter::Geometry,
                  dialect::AbstractString)
    FeatureLayer(GDAL.datasetexecutesql(dataset.ptr, query, spatialfilter.ptr,
                                        dialect))
end

function sqlquery(f::Function, dataset::Dataset, args...)
    result = sqlquery(dataset, args...)
    try
        f(result)
    finally
        releaseresult(dataset, result)
    end
end

"""
    GDALDatasetReleaseResultSet(GDALDatasetH hDS,
                                OGRLayerH hLayer) -> void
Release results of ExecuteSQL().
### Parameters
* **hDS**: the dataset handle.
* **hLayer**: the result of a previous ExecuteSQL() call.
"""
releaseresult(dataset::Dataset, layer::FeatureLayer) =
    GDAL.datasetreleaseresultset(dataset.ptr, layer.ptr)

"""
    OGR_L_ResetReading(OGRLayerH) -> void
Reset feature reading to start on the first feature.
### Parameters
* **hLayer**: handle to the layer on which features are read.
"""
resetreading(layer::FeatureLayer) = GDAL.resetreading(layer.ptr)

"""
    OGR_L_GetNextFeature(OGRLayerH) -> OGRFeatureH
Fetch the next available feature from this layer.
### Parameters
* **hLayer**: handle to the layer from which feature are read.
### Returns
an handle to a feature, or NULL if no more features are available.
"""
fetchnext(layer::FeatureLayer) =
    Feature(GDAL.getnextfeature(layer.ptr))

"""
    OGR_L_SetNextByIndex(OGRLayerH,
                         GIntBig) -> OGRErr
Move read cursor to the nIndex'th feature in the current resultset.
### Parameters
* **hLayer**: handle to the layer
* **nIndex**: the index indicating how many steps into the result set to seek.
### Returns
OGRERR_NONE on success or an error code.
"""
function setnext(layer::FeatureLayer, i::Integer)
    GDAL.setnextbyindex(layer.ptr, i)
end

"""
    OGR_L_GetFeature(OGRLayerH,
                     GIntBig) -> OGRFeatureH
Fetch a feature by its identifier.
### Parameters
* **hLayer**: handle to the layer that owned the feature.
* **nFeatureId**: the feature id of the feature to read.
### Returns
an handle to a feature now owned by the caller, or NULL on failure.
"""
fetchfeature(layer::FeatureLayer, i::Integer) =
    GDAL.getfeature(layer.ptr, i)

"""
    OGR_L_SetFeature(OGRLayerH,
                     OGRFeatureH) -> OGRErr
Rewrite an existing feature.
### Parameters
* **hLayer**: handle to the layer to write the feature.
* **hFeat**: the feature to write.
### Returns
OGRERR_NONE if the operation works, otherwise an appropriate error code (e.g OGRERR_NON_EXISTING_FEATURE if the feature does not exist).
"""
function setfeature(layer::FeatureLayer, feature::Feature)
    GDAL.setfeature(layer.ptr, feature.ptr)
end

"""
    OGR_L_CreateFeature(OGRLayerH,
                        OGRFeatureH) -> OGRErr
Create and write a new feature within a layer.
### Parameters
* **hLayer**: handle to the layer to write the feature to.
* **hFeat**: the handle of the feature to write to disk.
### Returns
OGRERR_NONE on success.
"""
function createfeature(layer::FeatureLayer, feature::Feature)
    GDAL.createfeature(layer.ptr, feature.ptr)
end

"""
    OGR_L_DeleteFeature(OGRLayerH,
                        GIntBig) -> OGRErr
Delete feature from layer.
### Parameters
* **hLayer**: handle to the layer
* **nFID**: the feature id to be deleted from the layer
### Returns
OGRERR_NONE if the operation works, otherwise an appropriate error code (e.g OGRERR_NON_EXISTING_FEATURE if the feature does not exist).
"""
function deletefeature(layer::FeatureLayer, i::Integer)
    GDAL.deletefeature(layer.ptr, i)
end

"""
    OGR_FD_GetGeomFieldCount(OGRFeatureDefnH hDefn) -> int
Fetch number of geometry fields on the passed feature definition.
### Parameters
* **hDefn**: handle to the feature definition to get the fields count from.
### Returns
count of geometry fields.
"""
ngeomfield(featuredefn::FeatureDefn) = GDAL.getgeomfieldcount(featuredefn.ptr)

"""
    OGR_FD_GetGeomFieldDefn(OGRFeatureDefnH hDefn,
                            int iGeomField) -> OGRGeomFieldDefnH
Fetch geometry field definition of the passed feature definition.
### Parameters
* **hDefn**: handle to the feature definition to get the field definition from.
* **iGeomField**: the geometry field to fetch, between 0 and GetGeomFieldCount()-1.
### Returns
an handle to an internal field definition object or NULL if invalid index. This object should not be modified or freed by the application.
"""
geomfielddefn(featuredefn::FeatureDefn, i::Integer) = GeomFieldDefn(GDAL.getgeomfielddefn(featuredefn.ptr, i))


"""
    OGR_FD_GetGeomFieldIndex(OGRFeatureDefnH hDefn,
                             const char * pszGeomFieldName) -> int
Find geometry field by name.
### Parameters
* **hDefn**: handle to the feature definition to get field index from.
* **pszGeomFieldName**: the geometry field name to search for.
### Returns
the geometry field index, or -1 if no match found.
"""
geomfieldindex(featuredefn::FeatureDefn, name::AbstractString) = GDAL.getgeomfieldindex(featuredefn.ptr, name)

"""
    OGR_FD_AddGeomFieldDefn(OGRFeatureDefnH hDefn,
                            OGRGeomFieldDefnH hNewGeomField) -> void
Add a new field definition to the passed feature definition.
### Parameters
* **hDefn**: handle to the feature definition to add the geometry field definition to.
* **hNewGeomField**: handle to the new field definition.
"""
add(featuredefn::FeatureDefn, geomfielddefn::GeomFieldDefn) =
    GDAL.addgeomfielddefn(featuredefn.ptr, geomfielddefn.ptr)


"""
    OGR_FD_DeleteGeomFieldDefn(OGRFeatureDefnH hDefn,
                               int iGeomField) -> OGRErr
Delete an existing geometry field definition.
### Parameters
* **hDefn**: handle to the feature definition.
* **iGeomField**: the index of the geometry field definition.
### Returns
OGRERR_NONE in case of success.
"""
function delete(featuredefn::FeatureDefn, i::Integer)
    GDAL.deletegeomfielddefn(featuredefn.ptr, i)
end


"""
    OGR_FD_IsSame(OGRFeatureDefnH hFDefn,
                  OGRFeatureDefnH hOtherFDefn) -> int
Test if the feature definition is identical to the other one.
### Parameters
* **hFDefn**: handle to the feature definition on witch OGRFeature are based on.
* **hOtherFDefn**: handle to the other feature definition to compare to.
### Returns
TRUE if the feature definition is identical to the other one.
"""
issame(featuredefn1::FeatureDefn, featuredefn2::FeatureDefn) =
    Bool(GDAL.issame(featuredefn1.ptr, featuredefn2.ptr))

"""
    OGR_F_Create(OGRFeatureDefnH hDefn) -> OGRFeatureH
Feature factory.
### Parameters
* **hDefn**: handle to the feature class (layer) definition to which the feature will adhere.
### Returns
an handle to the new feature object with null fields and no geometry, or, starting with GDAL 2.1, NULL in case out of memory situation.
"""
f_create(featuredefn::FeatureDefn) = Feature(GDAL.f_create(featuredefn.ptr))

"""
    OGR_F_Destroy(OGRFeatureH hFeat) -> void
Destroy feature.
### Parameters
* **hFeat**: handle to the feature to destroy.
"""
destroy(feature::Feature) = GDAL.destroy(feature.ptr)

"""
    OGR_F_GetDefnRef(OGRFeatureH hFeat) -> OGRFeatureDefnH
Fetch feature definition.
### Parameters
* **hFeat**: handle to the feature to get the feature definition from.
### Returns
an handle to the feature definition object on which feature depends.
"""
featuredefn(feature::Feature) = FeatureDefn(GDAL.getdefnref(feature.ptr))

"""
    OGR_F_SetGeometryDirectly(OGRFeatureH hFeat,
                              OGRGeometryH hGeom) -> OGRErr
Set feature geometry.
### Parameters
* **hFeat**: handle to the feature on which to apply the geometry.
* **hGeom**: handle to the new geometry to apply to feature.
### Returns
OGRERR_NONE if successful, or OGR_UNSUPPORTED_GEOMETRY_TYPE if the geometry type is illegal for the OGRFeatureDefn (checking not yet implemented).
"""
function setgeometrydirectly(feature::Feature, geom::Geometry)
    GDAL.setgeometrydirectly(feature.ptr, geom.ptr)
end

"""
    OGR_F_SetGeometry(OGRFeatureH hFeat,
                      OGRGeometryH hGeom) -> OGRErr
Set feature geometry.
### Parameters
* **hFeat**: handle to the feature on which new geometry is applied to.
* **hGeom**: handle to the new geometry to apply to feature.
### Returns
OGRERR_NONE if successful, or OGR_UNSUPPORTED_GEOMETRY_TYPE if the geometry type is illegal for the OGRFeatureDefn (checking not yet implemented).
"""
function setgeometry(feature::Feature, geom::Geometry)
    GDAL.setgeometry(feature.ptr, geom.ptr)
end

"""
    OGR_F_GetGeometryRef(OGRFeatureH hFeat) -> OGRGeometryH
Fetch an handle to feature geometry.
### Parameters
* **hFeat**: handle to the feature to get geometry from.
### Returns
an handle to internal feature geometry. This object should not be modified.
"""
function getgeometry(feature::Feature)
    Geometry(GDAL.getgeometryref(feature.ptr))
end

"""
    OGR_F_StealGeometry(OGRFeatureH hFeat) -> OGRGeometryH
Take away ownership of geometry.
### Returns
the pointer to the geometry.
"""
function stealgeometry(feature::Feature)
    Geometry(GDAL.stealgeometry(feature.ptr))
end

"""
    OGR_F_Clone(OGRFeatureH hFeat) -> OGRFeatureH
Duplicate feature.
### Parameters
* **hFeat**: handle to the feature to clone.
### Returns
an handle to the new feature, exactly matching this feature.
"""
clone(feature::Feature) = Feature(GDAL.clone(feature.ptr))

"""
    OGR_F_Equal(OGRFeatureH hFeat,
                OGRFeatureH hOtherFeat) -> int
Test if two features are the same.
### Parameters
* **hFeat**: handle to one of the feature.
* **hOtherFeat**: handle to the other feature to test this one against.
### Returns
TRUE if they are equal, otherwise FALSE.
"""
equal(feature1::Feature, feature2::Feature) = Bool(GDAL.equal(feature1.ptr, feature2.ptr))

"""
    OGR_F_GetFieldCount(OGRFeatureH hFeat) -> int
Fetch number of fields on this feature This will always be the same as the field count for the OGRFeatureDefn.
### Parameters
* **hFeat**: handle to the feature to get the fields count from.
### Returns
count of fields.
"""
nfield(feature::Feature) = GDAL.getfieldcount(feature.ptr)

"""
    OGR_F_GetFieldDefnRef(OGRFeatureH hFeat,
                          int i) -> OGRFieldDefnH
Fetch definition for this field.
### Parameters
* **hFeat**: handle to the feature on which the field is found.
* **i**: the field to fetch, from 0 to GetFieldCount()-1.
### Returns
an handle to the field definition (from the OGRFeatureDefn). This is an internal reference, and should not be deleted or modified.
"""
fielddefn(feature::Feature, i::Integer) = FieldDefn(GDAL.getfielddefnref(feature.ptr, i))

"""
    OGR_F_GetFieldIndex(OGRFeatureH hFeat,
                        const char * pszName) -> int
Fetch the field index given field name.
### Parameters
* **hFeat**: handle to the feature on which the field is found.
* **pszName**: the name of the field to search for.
### Returns
the field index, or -1 if no matching field is found.
"""
fieldindex(feature::Feature, name::AbstractString) = GDAL.getfieldindex(feature.ptr, name)

"""
    OGR_F_IsFieldSet(OGRFeatureH hFeat,
                     int iField) -> int
Test if a field has ever been assigned a value or not.
### Parameters
* **hFeat**: handle to the feature on which the field is.
* **iField**: the field to test.
### Returns
TRUE if the field has been set, otherwise false.
"""
fieldisset(feature::Feature, i::Integer) = Bool(GDAL.isfieldset(feature.ptr, i))

"""
    OGR_F_UnsetField(OGRFeatureH hFeat,
                     int iField) -> void
Clear a field, marking it as unset.
### Parameters
* **hFeat**: handle to the feature on which the field is.
* **iField**: the field to unset.
"""
unsetfield(feature::Feature, i::Integer) = GDAL.unsetfield(feature.ptr, i)

"""
    OGR_F_GetFieldAsInteger(OGRFeatureH hFeat,
                            int iField) -> int
Fetch field value as integer.
### Parameters
* **hFeat**: handle to the feature that owned the field.
* **iField**: the field to fetch, from 0 to GetFieldCount()-1.
### Returns
the field value.
"""
asint(feature::Feature, i::Integer) = GDAL.getfieldasinteger(feature.ptr, i)

"""
    OGR_F_GetFieldAsInteger64(OGRFeatureH hFeat,
                              int iField) -> GIntBig
Fetch field value as integer 64 bit.
### Parameters
* **hFeat**: handle to the feature that owned the field.
* **iField**: the field to fetch, from 0 to GetFieldCount()-1.
### Returns
the field value.
"""
asint64(feature::Feature, i::Integer) = GDAL.getfieldasinteger64(feature.ptr, i)

"""
    OGR_F_GetFieldAsDouble(OGRFeatureH hFeat,
                           int iField) -> double
Fetch field value as a double.
### Parameters
* **hFeat**: handle to the feature that owned the field.
* **iField**: the field to fetch, from 0 to GetFieldCount()-1.
### Returns
the field value.
"""
asdouble(feature::Feature, i::Integer) = GDAL.getfieldasdouble(feature.ptr, i)

"""
    OGR_F_GetFieldAsString(OGRFeatureH hFeat,
                           int iField) -> const char *
Fetch field value as a string.
### Parameters
* **hFeat**: handle to the feature that owned the field.
* **iField**: the field to fetch, from 0 to GetFieldCount()-1.
### Returns
the field value. This string is internal, and should not be modified, or freed. Its lifetime may be very brief.
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


"""
    OGR_F_SetFieldInteger(OGRFeatureH hFeat,
                          int iField,
                          int nValue) -> void
Set field to integer value.
### Parameters
* **hFeat**: handle to the feature that owned the field.
* **iField**: the field to fetch, from 0 to GetFieldCount()-1.
* **nValue**: the value to assign.
"""
setfield(feature::Feature, i::Integer, value::Integer) =
    GDAL.setfieldinteger(feature.ptr, i, value)

"""
    OGR_F_SetFieldInteger64(OGRFeatureH hFeat,
                            int iField,
                            GIntBig nValue) -> void
Set field to 64 bit integer value.
### Parameters
* **hFeat**: handle to the feature that owned the field.
* **iField**: the field to fetch, from 0 to GetFieldCount()-1.
* **nValue**: the value to assign.
"""
setfield(feature::Feature, i::Integer, value::Int64) =
    GDAL.setfieldinteger64(feature.ptr, i, value)

"""
    OGR_F_SetFieldDouble(OGRFeatureH hFeat,
                         int iField,
                         double dfValue) -> void
Set field to double value.
### Parameters
* **hFeat**: handle to the feature that owned the field.
* **iField**: the field to fetch, from 0 to GetFieldCount()-1.
* **dfValue**: the value to assign.
"""
setfield(feature::Feature, i::Integer, value::Cdouble) =
    GDAL.setfielddouble(feature.ptr, i, value)

"""
    OGR_F_SetFieldString(OGRFeatureH hFeat,
                         int iField,
                         const char * pszValue) -> void
Set field to string value.
### Parameters
* **hFeat**: handle to the feature that owned the field.
* **iField**: the field to fetch, from 0 to GetFieldCount()-1.
* **pszValue**: the value to assign.
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
    OGR_F_GetGeomFieldCount(OGRFeatureH hFeat) -> int
Fetch number of geometry fields on this feature This will always be the same as the geometry field count for the OGRFeatureDefn.
### Parameters
* **hFeat**: handle to the feature to get the geometry fields count from.
### Returns
count of geometry fields.
"""
ngeomfield(feature::Feature) = GDAL.getgeomfieldcount(feature.ptr)

"""
    OGR_F_GetGeomFieldDefnRef(OGRFeatureH hFeat,
                              int i) -> OGRGeomFieldDefnH
Fetch definition for this geometry field.
### Parameters
* **hFeat**: handle to the feature on which the field is found.
* **i**: the field to fetch, from 0 to GetGeomFieldCount()-1.
### Returns
an handle to the field definition (from the OGRFeatureDefn). This is an internal reference, and should not be deleted or modified.
"""
geomfielddefn(feature::Feature, i::Integer) =
    GeomFieldDefn(GDAL.getgeomfielddefnref(feature.ptr, i))

"""
    OGR_F_GetGeomFieldIndex(OGRFeatureH hFeat,
                            const char * pszName) -> int
Fetch the geometry field index given geometry field name.
### Parameters
* **hFeat**: handle to the feature on which the geometry field is found.
* **pszName**: the name of the geometry field to search for.
### Returns
the geometry field index, or -1 if no matching geometry field is found.
"""
geomfielddefn(feature::Feature, name::AbstractString) =
    GDAL.getgeomfieldindex(feature.ptr, i)

"""
    OGR_F_GetGeomFieldRef(OGRFeatureH hFeat,
                          int iField) -> OGRGeometryH
Fetch an handle to feature geometry.
### Parameters
* **hFeat**: handle to the feature to get geometry from.
* **iField**: geometry field to get.
### Returns
an handle to internal feature geometry. This object should not be modified.
"""
geomfield(feature::Feature, i::Integer) =
    Geometry(GDAL.getgeomfieldref(feature.ptr, i))

"""
    OGR_F_SetGeomFieldDirectly(OGRFeatureH hFeat,
                               int iField,
                               OGRGeometryH hGeom) -> OGRErr
Set feature geometry of a specified geometry field.
### Parameters
* **hFeat**: handle to the feature on which to apply the geometry.
* **iField**: geometry field to set.
* **hGeom**: handle to the new geometry to apply to feature.
### Returns
OGRERR_NONE if successful, or OGRERR_FAILURE if the index is invalid, or OGR_UNSUPPORTED_GEOMETRY_TYPE if the geometry type is illegal for the OGRFeatureDefn (checking not yet implemented).
"""
function setgeomfielddirectly(feature::Feature, i::Integer, geom::Geometry)
    GDAL.setgeomfielddirectly(feature.ptr, i, geom.ptr)
end

"""
    OGR_F_SetGeomField(OGRFeatureH hFeat,
                       int iField,
                       OGRGeometryH hGeom) -> OGRErr
Set feature geometry of a specified geometry field.
### Parameters
* **hFeat**: handle to the feature on which new geometry is applied to.
* **iField**: geometry field to set.
* **hGeom**: handle to the new geometry to apply to feature.
### Returns
OGRERR_NONE if successful, or OGR_UNSUPPORTED_GEOMETRY_TYPE if the geometry type is illegal for the OGRFeatureDefn (checking not yet implemented).
"""
function setgeomfield(feature::Feature, i::Integer, geom::Geometry)
    GDAL.setgeomfield(feature.ptr, i, geom.ptr)
end

"""
    OGR_F_GetFID(OGRFeatureH hFeat) -> GIntBig
Get feature identifier.
### Parameters
* **hFeat**: handle to the feature from which to get the feature identifier.
### Returns
feature id or OGRNullFID if none has been assigned.
"""
getfid(feature::Feature) = GDAL.getfid(feature.ptr)

"""
    OGR_F_SetFID(OGRFeatureH hFeat,
                 GIntBig nFID) -> OGRErr
Set the feature identifier.
### Parameters
* **hFeat**: handle to the feature to set the feature id to.
* **nFID**: the new feature identifier value to assign.
### Returns
On success OGRERR_NONE, or on failure some other value.
"""
function setfid(feature::Feature, i::Integer)
    GDAL.setfid(feature.ptr, i)
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
    OGR_F_SetFrom(OGRFeatureH hFeat,
                  OGRFeatureH hOtherFeat,
                  int bForgiving) -> OGRErr
Set one feature from another.
### Parameters
* **hFeat**: handle to the feature to set to.
* **hOtherFeat**: handle to the feature from which geometry, and field values will be copied.
* **bForgiving**: TRUE if the operation should continue despite lacking output fields matching some of the source fields.
### Returns
OGRERR_NONE if the operation succeeds, even if some values are not transferred, otherwise an error code.
"""
function setfrom(feature1::Feature, feature2::Feature, forgiving::Bool=true)
    GDAL.setfrom(feature1.ptr, feature2.ptr, forgiving)
end

"""
    OGR_F_SetFromWithMap(OGRFeatureH hFeat,
                         OGRFeatureH hOtherFeat,
                         int bForgiving,
                         int * panMap) -> OGRErr
Set one feature from another.
### Parameters
* **hFeat**: handle to the feature to set to.
* **hOtherFeat**: handle to the feature from which geometry, and field values will be copied.
* **panMap**: Array of the indices of the destination feature's fields stored at the corresponding index of the source feature's fields. A value of -1 should be used to ignore the source's field. The array should not be NULL and be as long as the number of fields in the source feature.
* **bForgiving**: TRUE if the operation should continue despite lacking output fields matching some of the source fields.
### Returns
OGRERR_NONE if the operation succeeds, even if some values are not transferred, otherwise an error code.
"""
function setfrom(feature1::Feature, feature2::Feature, indices::Vector{Cint}, forgiving::Bool=true)
    GDAL.setfromwithmap(feature1.ptr, feature2.ptr, forgiving, pointer(indices))
end


"""
    OGR_F_GetStyleString(OGRFeatureH hFeat) -> const char *
Fetch style string for this feature.
### Parameters
* **hFeat**: handle to the feature to get the style from.
### Returns
a reference to a representation in string format, or NULL if there isn't one.
"""
getstylestring(feature::Feature) = GDAL.getstylestring(feature.ptr)

"""
    OGR_F_SetStyleString(OGRFeatureH hFeat,
                         const char * pszStyle) -> void
Set feature style string.
### Parameters
* **hFeat**: handle to the feature to set style to.
* **pszStyle**: the style string to apply to this feature, cannot be NULL.
"""
setstylestring(feature::Feature, style::AbstractString) =
    GDAL.setstylestring(feature.ptr, style)

"""
    OGR_F_SetStyleStringDirectly(OGRFeatureH hFeat,
                                 char * pszStyle) -> void
Set feature style string.
### Parameters
* **hFeat**: handle to the feature to set style to.
* **pszStyle**: the style string to apply to this feature, cannot be NULL.
"""
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


"""
    OGR_F_GetNativeData(OGRFeatureH hFeat) -> const char *
Returns the native data for the feature.
### Parameters
* **hFeat**: handle to the feature.
### Returns
a string with the native data, or NULL if there is none.
"""
getnativedata(feature::Feature) = GDAL.getnativedata(feature.ptr)

"""
    OGR_F_SetNativeData(OGRFeatureH hFeat,
                        const char * pszNativeData) -> void
Sets the native data for the feature.
### Parameters
* **hFeat**: handle to the feature.
* **pszNativeData**: a string with the native data, or NULL if there is none.
"""
setnativedata(feature::Feature, data::AbstractString) =
    GDAL.setnativedata(feature.ptr, data)

"""
    OGR_F_GetNativeMediaType(OGRFeatureH hFeat) -> const char *
Returns the native media type for the feature.
### Parameters
* **hFeat**: handle to the feature.
### Returns
a string with the native media type, or NULL if there is none.
"""
getmediatype(feature::Feature) = GDAL.getnativemediatype(feature.ptr)

"""
    OGR_F_SetNativeMediaType(OGRFeatureH hFeat,
                             const char * pszNativeMediaType) -> void
Sets the native media type for the feature.
### Parameters
* **hFeat**: handle to the feature.
* **pszNativeMediaType**: a string with the native media type, or NULL if there is none.
"""
setmediatype(feature::Feature, mediatype::AbstractString) =
    GDAL.setnativemediatype(feature.ptr, mediatype)

"""
    OGR_F_FillUnsetWithDefault(OGRFeatureH hFeat,
                               int bNotNullableOnly,
                               char ** papszOptions) -> void
Fill unset fields with default values that might be defined.
### Parameters
* **hFeat**: handle to the feature.
* **bNotNullableOnly**: if we should fill only unset fields with a not-null constraint.
* **papszOptions**: unused currently. Must be set to NULL.
"""
fillunset(feature::Feature, notnull::Bool=true) =
    GDAL.fillunsetwithdefault(feature.ptr, notnull)

"""
    OGR_F_Validate(OGRFeatureH hFeat,
                   int nValidateFlags,
                   int bEmitError) -> int
Validate that a feature meets constraints of its schema.
### Parameters
* **hFeat**: handle to the feature to validate.
* **nValidateFlags**: OGR_F_VAL_ALL or combination of OGR_F_VAL_NULL, OGR_F_VAL_GEOM_TYPE, OGR_F_VAL_WIDTH and OGR_F_VAL_ALLOW_NULL_WHEN_DEFAULT with '|' operator
* **bEmitError**: TRUE if a CPLError() must be emitted when a check fails
### Returns
TRUE if all enabled validation tests pass.
"""
validate(feature::Feature, flags::Integer, emiterror::Bool) =
    Bool(GDAL.validate(feature.ptr, flags, emiterror))

"""
    OGR_L_GetLayerDefn(OGRLayerH) -> OGRFeatureDefnH
Fetch the schema information for this layer.
### Parameters
* **hLayer**: handle to the layer to get the schema information.
### Returns
an handle to the feature definition.
"""
layerdefn(layer::FeatureLayer) = FeatureDefn(GDAL.getlayerdefn(layer.ptr))

nfield(featuredefn::FeatureDefn) = GDAL.getfieldcount(featuredefn.ptr)

fielddefn(featuredefn::FeatureDefn, i::Integer) =
    GDAL.getfielddefn(featuredefn.ptr, i)

"""
    OGR_L_FindFieldIndex(OGRLayerH,
                         const char *,
                         int bExactMatch) -> int
Find the index of field in a layer.
### Returns
field index, or -1 if the field doesn't exist
"""
function indexof(layer::FeatureLayer, field::AbstractString, exactmatch::Bool)
    GDAL.findfieldindex(layer.ptr, field, exactmatch)
end

"""
    OGR_L_GetFeatureCount(OGRLayerH,
                          int) -> GIntBig
Fetch the feature count in this layer.
### Parameters
* **hLayer**: handle to the layer that owned the features.
* **bForce**: Flag indicating whether the count should be computed even if it is expensive.
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
    OGR_L_CreateField(OGRLayerH,
                      OGRFieldDefnH,
                      int) -> OGRErr
Create a new field on a layer.
### Parameters
* **hLayer**: handle to the layer to write the field definition.
* **hField**: handle of the field definition to write to disk.
* **bApproxOK**: If TRUE, the field may be created in a slightly different form depending on the limitations of the format driver.
### Returns
OGRERR_NONE on success.
"""
createfield(layer::FeatureLayer, field::FieldDefn, approx::Bool = false) =
    GDAL.createfield(layer.ptr, field.ptr, approx)

"""
    OGR_L_CreateGeomField(OGRLayerH hLayer,
                          OGRGeomFieldDefnH hFieldDefn,
                          int bForce) -> OGRErr
Create a new geometry field on a layer.
### Parameters
* **hLayer**: handle to the layer to write the field definition.
* **hField**: handle of the geometry field definition to write to disk.
* **bApproxOK**: If TRUE, the field may be created in a slightly different form depending on the limitations of the format driver.
### Returns
OGRERR_NONE on success.
"""
createfield(layer::FeatureLayer, field::GeomFieldDefn, approx::Bool = false) =
    GDAL.creategeomfield(layer.ptr, field.ptr, approx)


"""
    OGR_L_DeleteField(OGRLayerH,
                      int iField) -> OGRErr
Create a new field on a layer.
### Parameters
* **hLayer**: handle to the layer.
* **iField**: index of the field to delete.
### Returns
OGRERR_NONE on success.
"""
deletefield(layer::FeatureLayer, i::Integer) = GDAL.deletefield(layer, i)


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
    OGR_L_GetGeometryColumn(OGRLayerH) -> const char *
This method returns the name of the underlying database column being used as the geometry column, or "" if not supported.
### Parameters
* **hLayer**: handle to the layer
### Returns
geometry column name.
"""
geomcolumn(layer::FeatureLayer) = GDAL.getgeometrycolumn(layer.ptr)

"""
    OGR_L_SetIgnoredFields(OGRLayerH,
                           const char **) -> OGRErr
Set which fields can be omitted when retrieving features from the layer.
### Parameters
* **papszFields**: an array of field names terminated by NULL item. If NULL is passed, the ignored list is cleared.
### Returns
OGRERR_NONE if all field names have been resolved (even if the driver does not support this method)
"""
function ignorefields(layer::FeatureLayer, fieldnames)
    GDAL.setignoredfields(layer.ptr, Ptr{Ptr{UInt8}}(pointer(fieldnames)))
end


"""
    OGR_L_Intersection(OGRLayerH pLayerInput,
                       OGRLayerH pLayerMethod,
                       OGRLayerH pLayerResult,
                       char ** papszOptions,
                       GDALProgressFunc pfnProgress,
                       void * pProgressArg) -> OGRErr
Intersection of two layers.
### Parameters
* **pLayerInput**: the input layer. Should not be NULL.
* **pLayerMethod**: the method layer. Should not be NULL.
* **pLayerResult**: the layer where the features resulting from the operation are inserted. Should not be NULL. See above the note about the schema.
* **papszOptions**: NULL terminated list of options (may be NULL).
* **pfnProgress**: a GDALProgressFunc() compatible callback function for reporting progress or NULL.
* **pProgressArg**: argument to be passed to pfnProgress. May be NULL.
### Returns
an error code if there was an error or the execution was interrupted, OGRERR_NONE otherwise.
"""
intersection(input::FeatureLayer, method::FeatureLayer, result::FeatureLayer) =
    GDAL.intersection(input.ptr, method.ptr, result.ptr, C_NULL, C_NULL, C_NULL)

"""
    OGR_L_Union(OGRLayerH pLayerInput,
                OGRLayerH pLayerMethod,
                OGRLayerH pLayerResult,
                char ** papszOptions,
                GDALProgressFunc pfnProgress,
                void * pProgressArg) -> OGRErr
Union of two layers.
### Parameters
* **pLayerInput**: the input layer. Should not be NULL.
* **pLayerMethod**: the method layer. Should not be NULL.
* **pLayerResult**: the layer where the features resulting from the operation are inserted. Should not be NULL. See above the note about the schema.
* **papszOptions**: NULL terminated list of options (may be NULL).
* **pfnProgress**: a GDALProgressFunc() compatible callback function for reporting progress or NULL.
* **pProgressArg**: argument to be passed to pfnProgress. May be NULL.
### Returns
an error code if there was an error or the execution was interrupted, OGRERR_NONE otherwise.
"""
union(input::FeatureLayer, method::FeatureLayer, result::FeatureLayer) =
    GDAL.union(input.ptr, method.ptr, result.ptr, C_NULL, C_NULL, C_NULL)

"""
    OGR_L_SymDifference(OGRLayerH pLayerInput,
                        OGRLayerH pLayerMethod,
                        OGRLayerH pLayerResult,
                        char ** papszOptions,
                        GDALProgressFunc pfnProgress,
                        void * pProgressArg) -> OGRErr
Symmetrical difference of two layers.
### Parameters
* **pLayerInput**: the input layer. Should not be NULL.
* **pLayerMethod**: the method layer. Should not be NULL.
* **pLayerResult**: the layer where the features resulting from the operation are inserted. Should not be NULL. See above the note about the schema.
* **papszOptions**: NULL terminated list of options (may be NULL).
* **pfnProgress**: a GDALProgressFunc() compatible callback function for reporting progress or NULL.
* **pProgressArg**: argument to be passed to pfnProgress. May be NULL.
### Returns
an error code if there was an error or the execution was interrupted, OGRERR_NONE otherwise.
"""
symdifference(input::FeatureLayer, method::FeatureLayer, result::FeatureLayer) =
    GDAL.symdifference(input.ptr, method.ptr, result.ptr, C_NULL, C_NULL, C_NULL)


"""
    OGR_L_Identity(OGRLayerH pLayerInput,
                   OGRLayerH pLayerMethod,
                   OGRLayerH pLayerResult,
                   char ** papszOptions,
                   GDALProgressFunc pfnProgress,
                   void * pProgressArg) -> OGRErr
Identify the features of this layer with the ones from the identity layer.
### Parameters
* **pLayerInput**: the input layer. Should not be NULL.
* **pLayerMethod**: the method layer. Should not be NULL.
* **pLayerResult**: the layer where the features resulting from the operation are inserted. Should not be NULL. See above the note about the schema.
* **papszOptions**: NULL terminated list of options (may be NULL).
* **pfnProgress**: a GDALProgressFunc() compatible callback function for reporting progress or NULL.
* **pProgressArg**: argument to be passed to pfnProgress. May be NULL.
### Returns
an error code if there was an error or the execution was interrupted, OGRERR_NONE otherwise.
"""
function symdifference(input::FeatureLayer,
                       method::FeatureLayer,
                       result::FeatureLayer)
    GDAL.symdifference(input.ptr, method.ptr, result.ptr,
                       C_NULL, C_NULL, C_NULL)
end

"""
    OGR_L_Update(OGRLayerH pLayerInput,
                 OGRLayerH pLayerMethod,
                 OGRLayerH pLayerResult,
                 char ** papszOptions,
                 GDALProgressFunc pfnProgress,
                 void * pProgressArg) -> OGRErr
Update this layer with features from the update layer.
### Parameters
* **pLayerInput**: the input layer. Should not be NULL.
* **pLayerMethod**: the method layer. Should not be NULL.
* **pLayerResult**: the layer where the features resulting from the operation are inserted. Should not be NULL. See above the note about the schema.
* **papszOptions**: NULL terminated list of options (may be NULL).
* **pfnProgress**: a GDALProgressFunc() compatible callback function for reporting progress or NULL.
* **pProgressArg**: argument to be passed to pfnProgress. May be NULL.
### Returns
an error code if there was an error or the execution was interrupted, OGRERR_NONE otherwise.
"""
function update(input::FeatureLayer,
                method::FeatureLayer,
                result::FeatureLayer)
    GDAL.update(input.ptr, method.ptr, result.ptr, C_NULL, C_NULL, C_NULL)
end


"""
    OGR_L_Clip(OGRLayerH pLayerInput,
               OGRLayerH pLayerMethod,
               OGRLayerH pLayerResult,
               char ** papszOptions,
               GDALProgressFunc pfnProgress,
               void * pProgressArg) -> OGRErr
Clip off areas that are not covered by the method layer.
### Parameters
* **pLayerInput**: the input layer. Should not be NULL.
* **pLayerMethod**: the method layer. Should not be NULL.
* **pLayerResult**: the layer where the features resulting from the operation are inserted. Should not be NULL. See above the note about the schema.
* **papszOptions**: NULL terminated list of options (may be NULL).
* **pfnProgress**: a GDALProgressFunc() compatible callback function for reporting progress or NULL.
* **pProgressArg**: argument to be passed to pfnProgress. May be NULL.
### Returns
an error code if there was an error or the execution was interrupted, OGRERR_NONE otherwise.
"""
function clip(input::FeatureLayer,
              method::FeatureLayer,
              result::FeatureLayer)
    GDAL.clip(input.ptr, method.ptr, result.ptr, C_NULL, C_NULL, C_NULL)
end

"""
    OGR_L_Erase(OGRLayerH pLayerInput,
                OGRLayerH pLayerMethod,
                OGRLayerH pLayerResult,
                char ** papszOptions,
                GDALProgressFunc pfnProgress,
                void * pProgressArg) -> OGRErr
Remove areas that are covered by the method layer.
### Parameters
* **pLayerInput**: the input layer. Should not be NULL.
* **pLayerMethod**: the method layer. Should not be NULL.
* **pLayerResult**: the layer where the features resulting from the operation are inserted. Should not be NULL. See above the note about the schema.
* **papszOptions**: NULL terminated list of options (may be NULL).
* **pfnProgress**: a GDALProgressFunc() compatible callback function for reporting progress or NULL.
* **pProgressArg**: argument to be passed to pfnProgress. May be NULL.
### Returns
an error code if there was an error or the execution was interrupted, OGRERR_NONE otherwise.
"""
function erase(input::FeatureLayer,
               method::FeatureLayer,
               result::FeatureLayer)
    GDAL.erase(input.ptr, method.ptr, result.ptr, C_NULL, C_NULL, C_NULL)
end
