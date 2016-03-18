"Create a new feature definition object to hold the field definitions."
createfeaturedefn(name::AbstractString) = FeatureDefn(GDAL.fd_create(name))

"Destroy a feature definition object and release all memory associated with it"
destroy(featuredefn::FeatureDefn) = GDAL.destroy(featuredefn.ptr)

"Drop a reference, and destroy if unreferenced."
release(featuredefn::FeatureDefn) = GDAL.release(featuredefn.ptr)

"Get name of the OGRFeatureDefn passed as an argument."
getname(featuredefn::FeatureDefn) = GDAL.getname(featuredefn.ptr)

"Fetch number of fields on the passed feature definition."
nfield(featuredefn::FeatureDefn) = GDAL.getfieldcount(featuredefn.ptr)

"Fetch field definition of the passed feature definition."
fetchfielddefn(featuredefn::FeatureDefn, i::Integer) =
    FieldDefn(GDAL.getfielddefn(featuredefn.ptr, i))

"""
Find field by name.

### Returns
the field index, or -1 if no match found.
"""
getfieldindex(featuredefn::FeatureDefn, name::AbstractString) =
    GDAL.getfieldindex(featuredefn.ptr, name)

"Add a new field definition to the passed feature definition."
adddefn(featuredefn::FeatureDefn, fielddefn::FieldDefn) =
    GDAL.addfielddefn(featuredefn.ptr, fielddefn.ptr)

"Delete an existing field definition."
function deletefielddefn(featuredefn::FeatureDefn, i::Integer)
    result = GDAL.deletefielddefn(featuredefn.ptr, i)
    if result != GDAL.OGRERR_NONE
        error("Failed to delete field $i in the feature definition")
    end
end

"""
Reorder the field definitions in the array of the feature definition.

### Parameters
* **featuredefn**: handle to the feature definition.
* **indices**: an array of GetFieldCount() elements which is a permutation of
    [0, GetFieldCount()-1]. panMap is such that, for each field definition at
    position i after reordering, its position before reordering was panMap[i].
"""
function reorderfielddefns(featuredefn::FeatureDefn, indices::Vector{Cint})
    result = GDAL.reorderfielddefns(featuredefn.ptr, indices)
    if result != GDAL.OGRERR_NONE
        error("Failed to delete field $i in the feature definition")
    end
end
    

"Fetch the geometry base type of the passed feature definition."
getgeomtype(featuredefn::FeatureDefn) = GDAL.getgeomtype(featuredefn.ptr)

"""Assign the base geometry type for the passed layer (the same as the
feature definition)."""
setgeomtype(featuredefn::FeatureDefn, etype::GDAL.OGRwkbGeometryType) =
    GDAL.setgeomtype(featuredefn.ptr, etype)

"Determine whether the geometry can be omitted when fetching features."
isgeomignored(featuredefn::FeatureDefn) =
    GDAL.isgeometryignored(featuredefn.ptr)

"Set whether the geometry can be omitted when fetching features."
setgeomignored(featuredefn::FeatureDefn, ignore::Bool) =
    GDAL.setgeometryignored(featuredefn.ptr, ignore)

"Determine whether the style can be omitted when fetching features."
isstyleignored(featuredefn::FeatureDefn) =
    Bool(GDAL.isstyleignored(featuredefn.ptr))

"Fetch number of geometry fields on the passed feature definition."
ngeomfield(featuredefn::FeatureDefn) = GDAL.getgeomfieldcount(featuredefn.ptr)

"Fetch geometry field definition of the passed feature definition."
fetchgeomfielddefn(featuredefn::FeatureDefn, i::Integer) =
    GeomFieldDefn(GDAL.getgeomfielddefn(featuredefn.ptr, i))

"""
Find geometry field by name.

### Returns
the geometry field index, or -1 if no match found.
"""
getgeomfieldindex(featuredefn::FeatureDefn, name::AbstractString) =
    GDAL.getgeomfieldindex(featuredefn.ptr, name)

"Add a new field definition to the passed feature definition."
add(featuredefn::FeatureDefn, geomfielddefn::GeomFieldDefn) =
    GDAL.addgeomfielddefn(featuredefn.ptr, geomfielddefn.ptr)

"Delete an existing geometry field definition."
function deletegeomfielddefn(featuredefn::FeatureDefn, i::Integer)
    result = GDAL.deletegeomfielddefn(featuredefn.ptr, i)
    if result != GDAL.OGRERR_NONE
        error("Failed to delete geometry field $i in the feature definition")
    end
end

"Test if the feature definition is identical to the other one."
issame(featuredefn1::FeatureDefn, featuredefn2::FeatureDefn) =
    Bool(GDAL.issame(featuredefn1.ptr, featuredefn2.ptr))

"""Returns the new feature object with null fields and no geometry

Starting with GDAL 2.1, returns NULL in case out of memory situation.
"""
function createfeature(featuredefn::FeatureDefn)
    result = GDAL.f_create(featuredefn.ptr)
    (result == C_NULL) && error("out of memory when creating feature")
    Feature(result)
end

"Destroy the feature passed in."
destroy(feature::Feature) = GDAL.destroy(feature.ptr)

"Fetch feature definition."
getfeaturedefn(feature::Feature) = FeatureDefn(GDAL.getdefnref(feature.ptr))
