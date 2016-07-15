"Create a new feature definition object to hold the field definitions."
createfeaturedefn(name::AbstractString) = GDAL.fd_create(name)

"Destroy a feature definition object and release all memory associated with it"
destroy(featuredefn::FeatureDefn) = GDAL.destroy(featuredefn)

"Drop a reference, and destroy if unreferenced."
release(featuredefn::FeatureDefn) = GDAL.release(featuredefn)

"Get name of the OGRFeatureDefn passed as an argument."
getname(featuredefn::FeatureDefn) = GDAL.getname(featuredefn)

"Fetch number of fields on the passed feature definition."
nfield(featuredefn::FeatureDefn) = GDAL.getfieldcount(featuredefn)

"Fetch field definition of the passed feature definition."
fetchfielddefn(featuredefn::FeatureDefn, i::Integer) =
    GDAL.getfielddefn(featuredefn, i)

"""
Find field by name.

### Returns
the field index, or -1 if no match found.
"""
getfieldindex(featuredefn::FeatureDefn, name::AbstractString) =
    GDAL.getfieldindex(featuredefn, name)

"Add a new field definition to the passed feature definition."
addfielddefn(featuredefn::FeatureDefn, fielddefn::FieldDefn) =
    GDAL.addfielddefn(featuredefn, fielddefn)

"Delete an existing field definition."
function deletefielddefn(featuredefn::FeatureDefn, i::Integer)
    result = GDAL.deletefielddefn(featuredefn, i)
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
    result = GDAL.reorderfielddefns(featuredefn, indices)
    if result != GDAL.OGRERR_NONE
        error("Failed to delete field $i in the feature definition")
    end
end
    

"Fetch the geometry base type of the passed feature definition."
getgeomtype(featuredefn::FeatureDefn) = GDAL.getgeomtype(featuredefn)

"""Assign the base geometry type for the passed layer (the same as the
feature definition)."""
setgeomtype(featuredefn::FeatureDefn, etype::GDAL.OGRwkbGeometryType) =
    GDAL.setgeomtype(featuredefn, etype)

"Determine whether the geometry can be omitted when fetching features."
isgeomignored(featuredefn::FeatureDefn) =
    GDAL.isgeometryignored(featuredefn)

"Set whether the geometry can be omitted when fetching features."
setgeomignored(featuredefn::FeatureDefn, ignore::Bool) =
    GDAL.setgeometryignored(featuredefn, ignore)

"Determine whether the style can be omitted when fetching features."
isstyleignored(featuredefn::FeatureDefn) =
    Bool(GDAL.isstyleignored(featuredefn))

# """
#     OGR_FD_SetStyleIgnored(OGRFeatureDefnH hDefn,
#                            int bIgnore) -> void
# Set whether the style can be omitted when fetching features.
# ### Parameters
# * **hDefn**: handle to the feature definition on witch OGRFeature are based on.
# * **bIgnore**: ignore state
# """
# function setstyleignored(arg1::Ptr{OGRFeatureDefnH},arg2::Integer)
#     ccall((:OGR_FD_SetStyleIgnored,libgdal),Void,(Ptr{OGRFeatureDefnH},Cint),arg1,arg2)
# end

# """
#     OGR_FD_Reference(OGRFeatureDefnH hDefn) -> int
# Increments the reference count by one.
# ### Parameters
# * **hDefn**: handle to the feature definition on witch OGRFeature are based on.
# ### Returns
# the updated reference count.
# """
# function reference(arg1::Ptr{OGRFeatureDefnH})
#     ccall((:OGR_FD_Reference,libgdal),Cint,(Ptr{OGRFeatureDefnH},),arg1)
# end

# """
#     OGR_FD_Dereference(OGRFeatureDefnH hDefn) -> int
# Decrements the reference count by one.
# ### Parameters
# * **hDefn**: handle to the feature definition on witch OGRFeature are based on.
# ### Returns
# the updated reference count.
# """
# function dereference(arg1::Ptr{OGRFeatureDefnH})
#     ccall((:OGR_FD_Dereference,libgdal),Cint,(Ptr{OGRFeatureDefnH},),arg1)
# end

# """
#     OGR_FD_GetReferenceCount(OGRFeatureDefnH hDefn) -> int
# Fetch current reference count.
# ### Parameters
# * **hDefn**: handle to the feature definition on witch OGRFeature are based on.
# ### Returns
# the current reference count.
# """
# function getreferencecount(arg1::Ptr{OGRFeatureDefnH})
#     ccall((:OGR_FD_GetReferenceCount,libgdal),Cint,(Ptr{OGRFeatureDefnH},),arg1)
# end

"Fetch number of geometry fields on the passed feature definition."
ngeomfield(featuredefn::FeatureDefn) = GDAL.getgeomfieldcount(featuredefn)

"Fetch geometry field definition of the passed feature definition."
fetchgeomfielddefn(featuredefn::FeatureDefn, i::Integer) =
    GDAL.getgeomfielddefn(featuredefn, i)

"""
Find geometry field by name.

### Returns
the geometry field index, or -1 if no match found.
"""
getgeomfieldindex(featuredefn::FeatureDefn, name::AbstractString) =
    GDAL.getgeomfieldindex(featuredefn, name)

"Add a new field definition to the passed feature definition."
add(featuredefn::FeatureDefn, geomfielddefn::GeomFieldDefn) =
    GDAL.addgeomfielddefn(featuredefn, geomfielddefn)

"Delete an existing geometry field definition."
function deletegeomfielddefn(featuredefn::FeatureDefn, i::Integer)
    result = GDAL.deletegeomfielddefn(featuredefn, i)
    if result != GDAL.OGRERR_NONE
        error("Failed to delete geometry field $i in the feature definition")
    end
end

"Test if the feature definition is identical to the other one."
issame(featuredefn1::FeatureDefn, featuredefn2::FeatureDefn) =
    Bool(GDAL.issame(featuredefn1, featuredefn2))

"""Returns the new feature object with null fields and no geometry

Starting with GDAL 2.1, returns NULL in case out of memory situation.
"""
function createfeature(featuredefn::FeatureDefn)
    result = GDAL.f_create(featuredefn)
    (result == C_NULL) && error("out of memory when creating feature")
    result
end

"Destroy the feature passed in."
destroy(feature::Feature) = GDAL.destroy(feature)

"Fetch feature definition."
getfeaturedefn(feature::Feature) = GDAL.getdefnref(feature)
