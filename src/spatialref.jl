"""
Return the string representation for the OGRAxisOrientation enumeration.
"""
axisenumtoname(orientation::Integer) =
    bytestring(ccall((:OSRAxisEnumToName,GDAL.libgdal),Cstring,(GDAL.OGRAxisOrientation,),orientation))

"""
    OSRNewSpatialReference(const char * pszWKT) -> OGRSpatialReferenceH
Constructor.
"""
SpatialRef(wkt::AbstractString="") = GDAL.newspatialreference(wkt)

# """
#     OSRCloneGeogCS(OGRSpatialReferenceH hSource) -> OGRSpatialReferenceH
# Make a duplicate of the GEOGCS node of this OGRSpatialReference object.
# """
# function clonegeogcs(arg1::Ptr{OGRSpatialReferenceH})
#     checknull(ccall((:OSRCloneGeogCS,libgdal),Ptr{OGRSpatialReferenceH},(Ptr{OGRSpatialReferenceH},),arg1))
# end

# """
#     OSRReference(OGRSpatialReferenceH hSRS) -> int
# Increments the reference count by one.
# """
# function reference(arg1::Ptr{OGRSpatialReferenceH})
#     ccall((:OSRReference,libgdal),Cint,(Ptr{OGRSpatialReferenceH},),arg1)
# end


# """
#     OSRDereference(OGRSpatialReferenceH hSRS) -> int
# Decrements the reference count by one.
# """
# function dereference(arg1::Ptr{OGRSpatialReferenceH})
#     ccall((:OSRDereference,libgdal),Cint,(Ptr{OGRSpatialReferenceH},),arg1)
# end


# """
#     OSRRelease(OGRSpatialReferenceH hSRS) -> void
# Decrements the reference count by one, and destroy if zero.
# """
# function release(arg1::Ptr{OGRSpatialReferenceH})
#     ccall((:OSRRelease,libgdal),Void,(Ptr{OGRSpatialReferenceH},),arg1)
# end


# """
#     OSRValidate(OGRSpatialReferenceH) -> OGRErr
# Validate SRS tokens.
# """
# function validate(arg1::Ptr{OGRSpatialReferenceH})
#     ccall((:OSRValidate,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},),arg1)
# end


# """
#     OSRFixupOrdering(OGRSpatialReferenceH hSRS) -> OGRErr
# Correct parameter ordering to match CT Specification.
# """
# function fixupordering(arg1::Ptr{OGRSpatialReferenceH})
#     ccall((:OSRFixupOrdering,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},),arg1)
# end


# """
#     OSRFixup(OGRSpatialReferenceH hSRS) -> OGRErr
# Fixup as needed.
# """
# function fixup(arg1::Ptr{OGRSpatialReferenceH})
#     ccall((:OSRFixup,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},),arg1)
# end


# """
#     OSRStripCTParms(OGRSpatialReferenceH hSRS) -> OGRErr
# Strip OGC CT Parameters.
# """
# function stripctparms(arg1::Ptr{OGRSpatialReferenceH})
#     ccall((:OSRStripCTParms,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},),arg1)
# end


"""
    OSRImportFromEPSG(OGRSpatialReferenceH hSRS,
                      int nCode) -> OGRErr
Initialize SRS based on EPSG GCS or PCS code.
"""
function fromEPSG!(spref::SpatialRef, code::Integer)
    result = GDAL.importfromepsg(spref, code)
    if result != GDAL.OGRERR_NONE
        error("Failed to initializ SRS based on EPSG $code")
    end
    spref
end

fromEPSG(code::Integer) = fromEPSG!(SpatialRef(), code)

"""
    OSRImportFromEPSGA(OGRSpatialReferenceH hSRS,
                       int nCode) -> OGRErr
Initialize SRS based on EPSG GCS or PCS code.
"""
function fromEPSGA!(spref::SpatialRef, code::Integer)
    result = GDAL.importfromepsga(spref, code)
    if result != GDAL.OGRERR_NONE
        error("Failed to initializ SRS based on EPSGA $code")
    end
    spref
end

fromEPSGA(code::Integer) = fromEPSGA!(SpatialRef(), code)


# """
#     OSRImportFromWkt(OGRSpatialReferenceH hSRS,
#                      char ** ppszInput) -> OGRErr
# Import from WKT string.
# """
# function importfromwkt(arg1::Ptr{OGRSpatialReferenceH},arg2)
#     ccall((:OSRImportFromWkt,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Ptr{Cstring}),arg1,arg2)
# end


"""
    OSRImportFromProj4(OGRSpatialReferenceH,
                       const char *) -> OGRErr
Import PROJ.4 coordinate string.
"""
function fromPROJ4!(spref::SpatialRef, projstr::AbstractString)
    result = GDAL.importfromproj4(spref, projstr)
    if result != GDAL.OGRERR_NONE
        error("Failed to initialize SRS based on PROJ4 string: $projstr")
    end
    spref
end

fromPROJ4(projstr::AbstractString) = fromPROJ4!(SpatialRef(), projstr)


# """
#     OSRImportFromESRI(OGRSpatialReferenceH,
#                       char **) -> OGRErr
# Import coordinate system from ESRI .prj format(s).
# """
# function importfromesri(arg1::Ptr{OGRSpatialReferenceH},arg2)
#     ccall((:OSRImportFromESRI,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Ptr{Cstring}),arg1,arg2)
# end


# """
#     OSRImportFromPCI(OGRSpatialReferenceH hSRS,
#                      const char *,
#                      const char *,
#                      double *) -> OGRErr
# Import coordinate system from PCI projection definition.
# """
# function importfrompci(hSRS::Ptr{OGRSpatialReferenceH},arg1,arg2,arg3)
#     ccall((:OSRImportFromPCI,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cstring,Cstring,Ptr{Cdouble}),hSRS,arg1,arg2,arg3)
# end


# """
#     OSRImportFromUSGS(OGRSpatialReferenceH,
#                       long,
#                       long,
#                       double *,
#                       long) -> OGRErr
# Import coordinate system from USGS projection definition.
# """
# function importfromusgs(arg1::Ptr{OGRSpatialReferenceH},arg2::Clong,arg3::Clong,arg4,arg5::Clong)
#     ccall((:OSRImportFromUSGS,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Clong,Clong,Ptr{Cdouble},Clong),arg1,arg2,arg3,arg4,arg5)
# end

"""
    OSRImportFromXML(OGRSpatialReferenceH,
                     const char *) -> OGRErr
Import coordinate system from XML format (GML only currently).
"""
function fromXML!(spref::SpatialRef, xmlstr::AbstractString)
    result = GDAL.importfromxml(spref, xmlstr)
    if result != GDAL.OGRERR_NONE
        error("Failed to initialize SRS based on XML string: $xmlstr")
    end
    spref
end

fromXML(xmlstr::AbstractString) = fromXML!(SpatialRef(), xmlstr)


# """
#     OSRImportFromDict(OGRSpatialReferenceH,
#                       const char *,
#                       const char *) -> OGRErr

# Read SRS from WKT dictionary.

# This method will attempt to find the indicated coordinate system identity in the indicated dictionary file. If found, the WKT representation is imported and used to initialize this OGRSpatialReference.

# More complete information on the format of the dictionary files can be found in the epsg.wkt file in the GDAL data tree. The dictionary files are searched for in the "GDAL" domain using CPLFindFile(). Normally this results in searching /usr/local/share/gdal or somewhere similar.

# Parameters
# pszDictFile the name of the dictionary file to load.
# pszCode the code to lookup in the dictionary.

# Returns
# OGRERR_NONE on success, or OGRERR_SRS_UNSUPPORTED if the code isn't found, and OGRERR_SRS_FAILURE if something more dramatic goes wrong.
# """
# function importfromdict(arg1::Ptr{OGRSpatialReferenceH},arg2,arg3)
#     ccall((:OSRImportFromDict,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cstring,Cstring),arg1,arg2,arg3)
# end


# """
#     OSRImportFromPanorama(OGRSpatialReferenceH,
#                           long,
#                           long,
#                           long,
#                           double *) -> OGRErr
# """
# function importfrompanorama(arg1::Ptr{OGRSpatialReferenceH},arg2::Clong,arg3::Clong,arg4::Clong,arg5)
#     ccall((:OSRImportFromPanorama,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Clong,Clong,Clong,Ptr{Cdouble}),arg1,arg2,arg3,arg4,arg5)
# end


# """
#     OSRImportFromOzi(OGRSpatialReferenceH,
#                      const char *const *) -> OGRErr
# Import coordinate system from OziExplorer projection definition.
# ### Parameters
# * **hSRS**: spatial reference object.
# * **papszLines**: Map file lines. This is an array of strings containing the whole OziExplorer .MAP file. The array is terminated by a NULL pointer.
# ### Returns
# OGRERR_NONE on success or an error code in case of failure.
# """
# function importfromozi(arg1::Ptr{OGRSpatialReferenceH},arg2)
#     ccall((:OSRImportFromOzi,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Ptr{Cstring}),arg1,arg2)
# end


# """
#     OSRImportFromMICoordSys(OGRSpatialReferenceH hSRS,
#                             const char * pszCoordSys) -> OGRErr
# Import Mapinfo style CoordSys definition.
# """
# function importfrommicoordsys(arg1::Ptr{OGRSpatialReferenceH},arg2)
#     ccall((:OSRImportFromMICoordSys,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cstring),arg1,arg2)
# end


# """
#     OSRImportFromERM(OGRSpatialReferenceH,
#                      const char *,
#                      const char *,
#                      const char *) -> OGRErr
# Create OGR WKT from ERMapper projection definitions.
# """
# function importfromerm(arg1::Ptr{OGRSpatialReferenceH},arg2,arg3,arg4)
#     ccall((:OSRImportFromERM,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cstring,Cstring,Cstring),arg1,arg2,arg3,arg4)
# end


"""
    OSRImportFromUrl(OGRSpatialReferenceH hSRS,
                     const char * pszUrl) -> OGRErr
Set spatial reference from a URL.
"""
function fromURL!(spref::SpatialRef, url::AbstractString)
    result = GDAL.importfromurl(spref, url)
    if result != GDAL.OGRERR_NONE
        error("Failed to initialize SRS from URL: $url")
    end
    spref
end

fromURL(url::AbstractString) = fromURL!(SpatialRef(), url)

"""
Convert this SRS into WKT format.

Note that the returned WKT string should be freed with OGRFree() or CPLFree() when no longer needed. It is the responsibility of the caller.

Parameters
ppszResult  the resulting string is returned in this pointer.
Returns
currently OGRERR_NONE is always returned, but the future it is possible error conditions will develop.
"""
function toWKT(spref::SpatialRef)
    wktptr = Ref{Cstring}()
    result = GDAL.exporttowkt(spref, wktptr)
    (result != GDAL.OGRERR_NONE) && error("Failed to convert this SRS into WKT format")
    bytestring(wktptr[])
    #wktstr = bytestring(wktptr[])
    #GDAL.C.OGRFree(wktptr)
    #wktstr
end

"""
Convert this SRS into a nicely formatted WKT string for display to a person.

Note that the returned WKT string should be freed with OGRFree() or CPLFree() when no longer needed. It is the responsibility of the caller.

Parameters
ppszResult  the resulting string is returned in this pointer.
bSimplify   TRUE if the AXIS, AUTHORITY and EXTENSION nodes should be stripped off.
Returns
currently OGRERR_NONE is always returned, but the future it is possible error conditions will develop.
"""
function toWKT(spref::SpatialRef, simplify::Bool)
    wktptr = Ref{Cstring}()
    result = GDAL.exporttoprettywkt(spref, wktptr, simplify)
    (result != GDAL.OGRERR_NONE) && error("Failed to convert this SRS into pretty WKT")
    bytestring(wktptr[])
    #wktstr = bytestring(wktptr[])
    #GDAL.C.OGRFree(wktptr)
    #wktstr
end


# """
#     OSRExportToProj4(OGRSpatialReferenceH,
#                      char **) -> OGRErr
# Export coordinate system in PROJ.4 format.
# """
# function exporttoproj4(arg1::Ptr{OGRSpatialReferenceH},arg2)
#     ccall((:OSRExportToProj4,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Ptr{Cstring}),arg1,arg2)
# end


# """
#     OSRExportToPCI(OGRSpatialReferenceH,
#                    char **,
#                    char **,
#                    double **) -> OGRErr
# Export coordinate system in PCI projection definition.
# """
# function exporttopci(arg1::Ptr{OGRSpatialReferenceH},arg2,arg3,arg4)
#     ccall((:OSRExportToPCI,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Ptr{Cstring},Ptr{Cstring},Ptr{Ptr{Cdouble}}),arg1,arg2,arg3,arg4)
# end


# """
#     OSRExportToUSGS(OGRSpatialReferenceH,
#                     long *,
#                     long *,
#                     double **,
#                     long *) -> OGRErr
# Export coordinate system in USGS GCTP projection definition.
# """
# function exporttousgs(arg1::Ptr{OGRSpatialReferenceH},arg2,arg3,arg4,arg5)
#     ccall((:OSRExportToUSGS,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Ptr{Clong},Ptr{Clong},Ptr{Ptr{Cdouble}},Ptr{Clong}),arg1,arg2,arg3,arg4,arg5)
# end


# """
#     OSRExportToXML(OGRSpatialReferenceH,
#                    char **,
#                    const char *) -> OGRErr
# Export coordinate system in XML format.
# """
# function exporttoxml(arg1::Ptr{OGRSpatialReferenceH},arg2,arg3)
#     ccall((:OSRExportToXML,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Ptr{Cstring},Cstring),arg1,arg2,arg3)
# end


# """
#     OSRExportToPanorama(OGRSpatialReferenceH,
#                         long *,
#                         long *,
#                         long *,
#                         long *,
#                         double *) -> OGRErr
# """
# function exporttopanorama(arg1::Ptr{OGRSpatialReferenceH},arg2,arg3,arg4,arg5,arg6)
#     ccall((:OSRExportToPanorama,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Ptr{Clong},Ptr{Clong},Ptr{Clong},Ptr{Clong},Ptr{Cdouble}),arg1,arg2,arg3,arg4,arg5,arg6)
# end


# """
#     OSRExportToMICoordSys(OGRSpatialReferenceH hSRS,
#                           char ** ppszReturn) -> OGRErr
# Export coordinate system in Mapinfo style CoordSys format.
# """
# function exporttomicoordsys(arg1::Ptr{OGRSpatialReferenceH},arg2)
#     ccall((:OSRExportToMICoordSys,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Ptr{Cstring}),arg1,arg2)
# end


# """
#     OSRExportToERM(OGRSpatialReferenceH,
#                    char *,
#                    char *,
#                    char *) -> OGRErr
# Convert coordinate system to ERMapper format.
# """
# function exporttoerm(arg1::Ptr{OGRSpatialReferenceH},arg2,arg3,arg4)
#     ccall((:OSRExportToERM,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cstring,Cstring,Cstring),arg1,arg2,arg3,arg4)
# end


"""
    OSRMorphToESRI(OGRSpatialReferenceH) -> OGRErr
Convert in place to ESRI WKT format.
"""
function morphtoesri(spref::SpatialRef)
    result = GDAL.morphtoesri(spref)
    if result != GDAL.OGRERR_NONE
        error("Failed to convert in place to ESRI WKT format")
    end
    spref
end

"""
    OSRMorphFromESRI(OGRSpatialReferenceH) -> OGRErr
Convert in place from ESRI WKT format.
"""
function morphfromesri(spref::SpatialRef)
    result = GDAL.morphfromesri(spref)
    if result != GDAL.OGRERR_NONE
        error("Failed to convert in place from ESRI WKT format")
    end
    spref
end

"""
    Set attribute value in spatial reference.

Missing intermediate nodes in the path will be created if not already in existence. If the attribute has no children one will be created and assigned the value otherwise the zeroth child will be assigned the value.

This method does the same as the C function OSRSetAttrValue().

Parameters
pszNodePath full path to attribute to be set. For instance "PROJCS|GEOGCS|UNIT".
pszNewNodeValue value to be assigned to node, such as "meter". This may be NULL if you just want to force creation of the intermediate path.

Returns
OGRERR_NONE on success.
"""
function setattrvalue(spref::SpatialRef, path::AbstractString, value::AbstractString)
    result = GDAL.setattrvalue(spref, path, value)
    (result != GDAL.OGRERR_NONE) && error("Failed to set attribute $path to value $value")
end

"""
Fetch indicated attribute of named node.

This method uses GetAttrNode() to find the named node, and then extracts the value of the indicated child. Thus a call to GetAttrValue("UNIT",1) would return the second child of the UNIT node, which is normally the length of the linear unit in meters.

This method does the same thing as the C function OSRGetAttrValue().

Parameters
pszNodeName the tree node to look for (case insensitive).
iAttr   the child of the node to fetch (zero based).

Returns
the requested value, or NULL if it fails for any reason.
"""
getattrvalue(spref::SpatialRef, name::AbstractString, iChild::Integer) =
    GDAL.getattrvalue(spref, name, iChild)


"""
Set the angular units for the geographic coordinate system.

This method creates a UNIT subnode with the specified values as a child of the GEOGCS node.

This method does the same as the C function OSRSetAngularUnits().

Parameters
pszUnitsName    the units name to be used. Some preferred units names can be found in ogr_srs_api.h such as SRS_UA_DEGREE.
dfInRadians the value to multiple by an angle in the indicated units to transform to radians. Some standard conversion factors can be found in ogr_srs_api.h.
Returns
OGRERR_NONE on success.
"""
function setangularunits(spref::SpatialRef, units::AbstractString, angle::Real)
    result = GDAL.setangularunits(spref, units, angle)
    (result != GDAL.OGRERR_NONE) && error("Failed to set angular units to $angle $units")
end

# """
#     OSRGetAngularUnits(OGRSpatialReferenceH hSRS,
#                        char ** ppszName) -> double
# Fetch angular geographic coordinate system units.
# """
# function getangularunits(arg1::Ptr{OGRSpatialReferenceH},arg2)
#     ccall((:OSRGetAngularUnits,libgdal),Cdouble,(Ptr{OGRSpatialReferenceH},Ptr{Cstring}),arg1,arg2)
# end


"""
Set the linear units for the projection.

This method creates a UNIT subnode with the specified values as a child of the PROJCS, GEOCCS or LOCAL_CS node.

This method does the same as the C function OSRSetLinearUnits().

Parameters
pszUnitsName    the units name to be used. Some preferred units names can be found in ogr_srs_api.h such as SRS_UL_METER, SRS_UL_FOOT and SRS_UL_US_FOOT.
dfInMeters  the value to multiple by a length in the indicated units to transform to meters. Some standard conversion factors can be found in ogr_srs_api.h.
Returns
OGRERR_NONE on success.
"""
function setlinearunits(spref::SpatialRef,name::AbstractString,tometers::Real)
    result = GDAL.setlinearunits(spref, name, tometers)
    (result != GDAL.OGRERR_NONE) && error("Failed to set linear units")
end

"""
Set the linear units for the projection.

This method creates a UNIT subnode with the specified values as a child of the target node.

This method does the same as the C function OSRSetTargetLinearUnits().

Parameters
pszTargetKey    the keyword to set the linear units for. i.e. "PROJCS" or "VERT_CS"
pszUnitsName    the units name to be used. Some preferred units names can be found in ogr_srs_api.h such as SRS_UL_METER, SRS_UL_FOOT and SRS_UL_US_FOOT.
dfInMeters  the value to multiple by a length in the indicated units to transform to meters. Some standard conversion factors can be found in ogr_srs_api.h.

Returns
OGRERR_NONE on success.

Since
OGR 1.9.0
"""
function settargetlinearunits(spref::SpatialRef, targetkey::AbstractString,
                              name::AbstractString, tometers::Real)
    result = GDAL.settargetlinearunits(spref, targetkey, name, tometers)
    (result != GDAL.OGRERR_NONE) && error("Failed to set target linear units")
end

# """
#     OSRSetLinearUnitsAndUpdateParameters(OGRSpatialReferenceH hSRS,
#                                          const char * pszUnits,
#                                          double dfInMeters) -> OGRErr
# Set the linear units for the projection.
# """
# function setlinearunitsandupdateparameters(arg1::Ptr{OGRSpatialReferenceH},arg2,arg3::Real)
#     ccall((:OSRSetLinearUnitsAndUpdateParameters,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cstring,Cdouble),arg1,arg2,arg3)
# end

# """
#     OSRGetLinearUnits(OGRSpatialReferenceH hSRS,
#                       char ** ppszName) -> double
# Fetch linear projection units.
# """
# function getlinearunits(arg1::Ptr{OGRSpatialReferenceH},arg2)
#     ccall((:OSRGetLinearUnits,libgdal),Cdouble,(Ptr{OGRSpatialReferenceH},Ptr{Cstring}),arg1,arg2)
# end


# """
#     OSRGetTargetLinearUnits(OGRSpatialReferenceH hSRS,
#                             const char * pszTargetKey,
#                             char ** ppszName) -> double
# Fetch linear projection units.
# """
# function gettargetlinearunits(arg1::Ptr{OGRSpatialReferenceH},arg2,arg3)
#     ccall((:OSRGetTargetLinearUnits,libgdal),Cdouble,(Ptr{OGRSpatialReferenceH},Cstring,Ptr{Cstring}),arg1,arg2,arg3)
# end


# """
#     OSRGetPrimeMeridian(OGRSpatialReferenceH hSRS,
#                         char ** ppszName) -> double
# Fetch prime meridian info.
# """
# function getprimemeridian(arg1::Ptr{OGRSpatialReferenceH},arg2)
#     ccall((:OSRGetPrimeMeridian,libgdal),Cdouble,(Ptr{OGRSpatialReferenceH},Ptr{Cstring}),arg1,arg2)
# end


"""
    OSRIsGeographic(OGRSpatialReferenceH hSRS) -> int
Check if geographic coordinate system.
"""
isgeographic(spref::SpatialRef) = Bool(GDAL.isgeographic(spref))

"""
    OSRIsLocal(OGRSpatialReferenceH hSRS) -> int
Check if local coordinate system.
"""
islocal(spref::SpatialRef) = Bool(GDAL.islocal(spref))

"""
    OSRIsProjected(OGRSpatialReferenceH hSRS) -> int
Check if projected coordinate system.
"""
isprojected(spref::SpatialRef) = Bool(GDAL.isprojected(spref))

"""
    OSRIsCompound(OGRSpatialReferenceH hSRS) -> int
Check if the coordinate system is compound.
"""
iscompound(spref::SpatialRef) = Bool(GDAL.iscompound(spref))

"""
    OSRIsGeocentric(OGRSpatialReferenceH hSRS) -> int
Check if geocentric coordinate system.
"""
isgeocentric(spref::SpatialRef) = Bool(GDAL.isgeocentric(spref))

"""
    OSRIsVertical(OGRSpatialReferenceH hSRS) -> int
Check if vertical coordinate system.
"""
isvertical(spref::SpatialRef) = Bool(GDAL.isvertical(spref))

"""
    OSRIsSameGeogCS(OGRSpatialReferenceH hSRS1,
                    OGRSpatialReferenceH hSRS2) -> int
Do the GeogCS'es match?
"""
issamegeogcs(spref1::SpatialRef, spref2::SpatialRef) =
    Bool(GDAL.issamegeogcs(spref1, spref2))

"""
    OSRIsSameVertCS(OGRSpatialReferenceH hSRS1,
                    OGRSpatialReferenceH hSRS2) -> int
Do the VertCS'es match?
"""
issamevertcs(spref1::SpatialRef, spref2::SpatialRef) =
    Bool(GDAL.issamevertcs(spref1, spref2))

"""
    OSRIsSame(OGRSpatialReferenceH hSRS1,
              OGRSpatialReferenceH hSRS2) -> int
Do these two spatial references describe the same system ?
"""
issame(spref1::SpatialRef, spref2::SpatialRef) =
    Bool(GDAL.issame(spref1, spref2))

"""
    OSRSetLocalCS(OGRSpatialReferenceH hSRS,
                  const char * pszName) -> OGRErr
Set the user visible LOCAL_CS name.
"""
function setlocalcs(spref::SpatialRef, name::AbstractString)
    result = GDAL.setlocalcs(spref, name)
    (result != GDAL.OGRERR_NONE) && error("Failed to set LOCAL_CS")
end

"""
    OSRSetProjCS(OGRSpatialReferenceH hSRS,
                 const char * pszName) -> OGRErr
Set the user visible PROJCS name.
"""
function setprojcs(spref::SpatialRef, name::AbstractString)
    result = GDAL.setprojcs(spref, name)
    (result != GDAL.OGRERR_NONE) && error("Failed to set PROJCS")
end

"""
Set the user visible GEOCCS name.

This method will ensure a GEOCCS node is created as the root, and set the provided name on it. If used on a GEOGCS coordinate system, the DATUM and PRIMEM nodes from the GEOGCS will be transferred over to the GEOGCS.

Parameters
pszName the user visible name to assign. Not used as a key.
Returns
OGRERR_NONE on success.
"""
function setgeoccs(spref::SpatialRef, name::AbstractString)
    result = GDAL.setgeoccs(spref, name)
    (result != GDAL.OGRERR_NONE) && error("Failed to set GEOGCS")
end

"""
    OSRSetWellKnownGeogCS(OGRSpatialReferenceH hSRS,
                          const char * pszName) -> OGRErr
Set a GeogCS based on well known name.
"""
function setwellknowngeogcs(spref::SpatialRef, name::AbstractString)
    result = GDAL.setwellknowngeogcs(spref, name)
    (result != GDAL.OGRERR_NONE) && error("Failed to set GeogCS based on well known name.")
end

# """
#     OSRSetFromUserInput(OGRSpatialReferenceH hSRS,
#                         const char * pszDef) -> OGRErr
# Set spatial reference from various text formats.
# """
# function setfromuserinput(hSRS::Ptr{OGRSpatialReferenceH},arg1)
#     ccall((:OSRSetFromUserInput,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cstring),hSRS,arg1)
# end


"""
    OSRCopyGeogCSFrom(OGRSpatialReferenceH hSRS,
                      OGRSpatialReferenceH hSrcSRS) -> OGRErr
Copy GEOGCS from another OGRSpatialReference.
"""
function copygeogcsfrom(target::SpatialRef, source::SpatialRef)
    result = GDAL.copygeogcsfrom(target, source)
    (result != GDAL.OGRERR_NONE) && error("Failed to copy GEOGCS from another OGRSpatialReference.")
end

"""
Set the Bursa-Wolf conversion to WGS84.

This will create the TOWGS84 node as a child of the DATUM. It will fail if there is no existing DATUM node. Unlike most OGRSpatialReference methods it will insert itself in the appropriate order, and will replace an existing TOWGS84 node if there is one.

The parameters have the same meaning as EPSG transformation 9606 (Position Vector 7-param. transformation).

This method is the same as the C function OSRSetTOWGS84().

Parameters
dfDX    X child in meters.
dfDY    Y child in meters.
dfDZ    Z child in meters.
dfEX    X rotation in arc seconds (optional, defaults to zero).
dfEY    Y rotation in arc seconds (optional, defaults to zero).
dfEZ    Z rotation in arc seconds (optional, defaults to zero).
dfPPM   scaling factor (parts per million).

Returns
OGRERR_NONE on success.
"""
function settowgs84(spref::SpatialRef,dx::Real,dy::Real,dz::Real,ex::Real,ey::Real,ez::Real,ppm::Real)
    result = GDAL.settowgs84(spref,dx,dy,dz,ex,ey,ez,ppm)
    (result != GDAL.OGRERR_NONE) && error("Failed to set the Bursa-Wolf conversion to WGS84.")
end

"""
Fetch TOWGS84 parameters, if available.

Parameters
padfCoeff   array into which up to 7 coefficients are placed.
nCoeffCount size of padfCoeff - defaults to 7.

Returns
OGRERR_NONE on success, or OGRERR_FAILURE if there is no TOWGS84 node available.
"""
function gettowgs84!(spref::SpatialRef,buffer::Vector{Cdouble})
    result = gettowgs84(spref, pointer(buffer), length(buffer))
    (result != GDAL.OGRERR_NONE) && error("Failed to fetch TOWGS84 parameters")
    buffer
end

gettowgs84(spref::SpatialRef) = gettowgs84!(spref, Array(Cdouble, 7))

# """
#     OSRSetCompoundCS(OGRSpatialReferenceH hSRS,
#                      const char * pszName,
#                      OGRSpatialReferenceH hHorizSRS,
#                      OGRSpatialReferenceH hVertSRS) -> OGRErr
# Setup a compound coordinate system.
# """
# function setcompoundcs(hSRS::Ptr{OGRSpatialReferenceH},pszName,hHorizSRS::Ptr{OGRSpatialReferenceH},hVertSRS::Ptr{OGRSpatialReferenceH})
#     ccall((:OSRSetCompoundCS,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cstring,Ptr{OGRSpatialReferenceH},Ptr{OGRSpatialReferenceH}),hSRS,pszName,hHorizSRS,hVertSRS)
# end


# """
#     OSRSetGeogCS(OGRSpatialReferenceH hSRS,
#                  const char * pszGeogName,
#                  const char * pszDatumName,
#                  const char * pszSpheroidName,
#                  double dfSemiMajor,
#                  double dfInvFlattening,
#                  const char * pszPMName,
#                  double dfPMOffset,
#                  const char * pszAngularUnits,
#                  double dfConvertToRadians) -> OGRErr
# Set geographic coordinate system.
# """
# function setgeogcs(hSRS::Ptr{OGRSpatialReferenceH},pszGeogName,pszDatumName,pszEllipsoidName,dfSemiMajor::Real,dfInvFlattening::Real,pszPMName,dfPMOffset::Real,pszUnits,dfConvertToRadians::Real)
#     ccall((:OSRSetGeogCS,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cstring,Cstring,Cstring,Cdouble,Cdouble,Cstring,Cdouble,Cstring,Cdouble),hSRS,pszGeogName,pszDatumName,pszEllipsoidName,dfSemiMajor,dfInvFlattening,pszPMName,dfPMOffset,pszUnits,dfConvertToRadians)
# end


# """
#     OSRSetVertCS(OGRSpatialReferenceH hSRS,
#                  const char * pszVertCSName,
#                  const char * pszVertDatumName,
#                  int nVertDatumType) -> OGRErr
# Setup the vertical coordinate system.
# """
# function setvertcs(hSRS::Ptr{OGRSpatialReferenceH},pszVertCSName,pszVertDatumName,nVertDatumType::Integer)
#     ccall((:OSRSetVertCS,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cstring,Cstring,Cint),hSRS,pszVertCSName,pszVertDatumName,nVertDatumType)
# end


# """
#     OSRGetSemiMajor(OGRSpatialReferenceH hSRS,
#                     OGRErr * pnErr) -> double
# Get spheroid semi major axis.
# """
# function getsemimajor(arg1::Ptr{OGRSpatialReferenceH},arg2)
#     ccall((:OSRGetSemiMajor,libgdal),Cdouble,(Ptr{OGRSpatialReferenceH},Ptr{OGRErr}),arg1,arg2)
# end


# """
#     OSRGetSemiMinor(OGRSpatialReferenceH hSRS,
#                     OGRErr * pnErr) -> double
# Get spheroid semi minor axis.
# """
# function getsemiminor(arg1::Ptr{OGRSpatialReferenceH},arg2)
#     ccall((:OSRGetSemiMinor,libgdal),Cdouble,(Ptr{OGRSpatialReferenceH},Ptr{OGRErr}),arg1,arg2)
# end


# """
#     OSRGetInvFlattening(OGRSpatialReferenceH hSRS,
#                         OGRErr * pnErr) -> double
# Get spheroid inverse flattening.
# """
# function getinvflattening(arg1::Ptr{OGRSpatialReferenceH},arg2)
#     ccall((:OSRGetInvFlattening,libgdal),Cdouble,(Ptr{OGRSpatialReferenceH},Ptr{OGRErr}),arg1,arg2)
# end


# """
#     OSRSetAuthority(OGRSpatialReferenceH hSRS,
#                     const char * pszTargetKey,
#                     const char * pszAuthority,
#                     int nCode) -> OGRErr
# Set the authority for a node.
# """
# function setauthority(hSRS::Ptr{OGRSpatialReferenceH},pszTargetKey,pszAuthority,nCode::Integer)
#     ccall((:OSRSetAuthority,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cstring,Cstring,Cint),hSRS,pszTargetKey,pszAuthority,nCode)
# end


# """
#     OSRGetAuthorityCode(OGRSpatialReferenceH hSRS,
#                         const char * pszTargetKey) -> const char *
# Get the authority code for a node.
# """
# function getauthoritycode(hSRS::Ptr{OGRSpatialReferenceH},pszTargetKey)
#     bytestring(ccall((:OSRGetAuthorityCode,libgdal),Cstring,(Ptr{OGRSpatialReferenceH},Cstring),hSRS,pszTargetKey))
# end


# """
#     OSRGetAuthorityName(OGRSpatialReferenceH hSRS,
#                         const char * pszTargetKey) -> const char *
# Get the authority name for a node.
# """
# function getauthorityname(hSRS::Ptr{OGRSpatialReferenceH},pszTargetKey)
#     bytestring(ccall((:OSRGetAuthorityName,libgdal),Cstring,(Ptr{OGRSpatialReferenceH},Cstring),hSRS,pszTargetKey))
# end


# """
#     OSRSetProjection(OGRSpatialReferenceH hSRS,
#                      const char * pszProjection) -> OGRErr
# Set a projection name.
# """
# function setprojection(arg1::Ptr{OGRSpatialReferenceH},arg2)
#     ccall((:OSRSetProjection,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cstring),arg1,arg2)
# end


# """
#     OSRSetProjParm(OGRSpatialReferenceH hSRS,
#                    const char * pszParmName,
#                    double dfValue) -> OGRErr
# Set a projection parameter value.
# """
# function setprojparm(arg1::Ptr{OGRSpatialReferenceH},arg2,arg3::Real)
#     ccall((:OSRSetProjParm,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cstring,Cdouble),arg1,arg2,arg3)
# end


# """
#     OSRGetProjParm(OGRSpatialReferenceH hSRS,
#                    const char * pszName,
#                    double dfDefaultValue,
#                    OGRErr * pnErr) -> double
# Fetch a projection parameter value.
# """
# function getprojparm(hSRS::Ptr{OGRSpatialReferenceH},pszParmName,dfDefault::Real,arg1)
#     ccall((:OSRGetProjParm,libgdal),Cdouble,(Ptr{OGRSpatialReferenceH},Cstring,Cdouble,Ptr{OGRErr}),hSRS,pszParmName,dfDefault,arg1)
# end


# """
#     OSRSetNormProjParm(OGRSpatialReferenceH hSRS,
#                        const char * pszParmName,
#                        double dfValue) -> OGRErr
# Set a projection parameter with a normalized value.
# """
# function setnormprojparm(arg1::Ptr{OGRSpatialReferenceH},arg2,arg3::Real)
#     ccall((:OSRSetNormProjParm,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cstring,Cdouble),arg1,arg2,arg3)
# end


# """
#     OSRGetNormProjParm(OGRSpatialReferenceH hSRS,
#                        const char * pszName,
#                        double dfDefaultValue,
#                        OGRErr * pnErr) -> double
# This function is the same as OGRSpatialReference::
# """
# function getnormprojparm(hSRS::Ptr{OGRSpatialReferenceH},pszParmName,dfDefault::Real,arg1)
#     ccall((:OSRGetNormProjParm,libgdal),Cdouble,(Ptr{OGRSpatialReferenceH},Cstring,Cdouble,Ptr{OGRErr}),hSRS,pszParmName,dfDefault,arg1)
# end


# """
#     OSRSetUTM(OGRSpatialReferenceH hSRS,
#               int nZone,
#               int bNorth) -> OGRErr
# Set UTM projection definition.
# """
# function setutm(hSRS::Ptr{OGRSpatialReferenceH},nZone::Integer,bNorth::Integer)
#     ccall((:OSRSetUTM,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cint,Cint),hSRS,nZone,bNorth)
# end


# """
#     OSRGetUTMZone(OGRSpatialReferenceH hSRS,
#                   int * pbNorth) -> int
# Get utm zone information.
# """
# function getutmzone(hSRS::Ptr{OGRSpatialReferenceH},pbNorth)
#     ccall((:OSRGetUTMZone,libgdal),Cint,(Ptr{OGRSpatialReferenceH},Ptr{Cint}),hSRS,pbNorth)
# end


# """
#     OSRSetStatePlane(OGRSpatialReferenceH hSRS,
#                      int nZone,
#                      int bNAD83) -> OGRErr
# Set State Plane projection definition.
# """
# function setstateplane(hSRS::Ptr{OGRSpatialReferenceH},nZone::Integer,bNAD83::Integer)
#     ccall((:OSRSetStatePlane,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cint,Cint),hSRS,nZone,bNAD83)
# end


# """
#     OSRSetStatePlaneWithUnits(OGRSpatialReferenceH hSRS,
#                               int nZone,
#                               int bNAD83,
#                               const char * pszOverrideUnitName,
#                               double dfOverrideUnit) -> OGRErr
# Set State Plane projection definition.
# """
# function setstateplanewithunits(hSRS::Ptr{OGRSpatialReferenceH},nZone::Integer,bNAD83::Integer,pszOverrideUnitName,dfOverrideUnit::Real)
#     ccall((:OSRSetStatePlaneWithUnits,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cint,Cint,Cstring,Cdouble),hSRS,nZone,bNAD83,pszOverrideUnitName,dfOverrideUnit)
# end


# """
#     OSRAutoIdentifyEPSG(OGRSpatialReferenceH hSRS) -> OGRErr
# Set EPSG authority info if possible.
# """
# function autoidentifyepsg(hSRS::Ptr{OGRSpatialReferenceH})
#     ccall((:OSRAutoIdentifyEPSG,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},),hSRS)
# end


# """
#     OSREPSGTreatsAsLatLong(OGRSpatialReferenceH hSRS) -> int
# This function returns TRUE if EPSG feels this geographic coordinate system should be treated as having lat/long coordinate ordering.
# """
# function epsgtreatsaslatlong(hSRS::Ptr{OGRSpatialReferenceH})
#     ccall((:OSREPSGTreatsAsLatLong,libgdal),Cint,(Ptr{OGRSpatialReferenceH},),hSRS)
# end


# """
#     OSREPSGTreatsAsNorthingEasting(OGRSpatialReferenceH hSRS) -> int
# This function returns TRUE if EPSG feels this geographic coordinate system should be treated as having northing/easting coordinate ordering.
# """
# function epsgtreatsasnorthingeasting(hSRS::Ptr{OGRSpatialReferenceH})
#     ccall((:OSREPSGTreatsAsNorthingEasting,libgdal),Cint,(Ptr{OGRSpatialReferenceH},),hSRS)
# end


# """
#     OSRGetAxis(OGRSpatialReferenceH hSRS,
#                const char * pszTargetKey,
#                int iAxis,
#                OGRAxisOrientation * peOrientation) -> const char *
# Fetch the orientation of one axis.
# """
# function getaxis(hSRS::Ptr{OGRSpatialReferenceH},pszTargetKey,iAxis::Integer,peOrientation)
#     bytestring(ccall((:OSRGetAxis,libgdal),Cstring,(Ptr{OGRSpatialReferenceH},Cstring,Cint,Ptr{OGRAxisOrientation}),hSRS,pszTargetKey,iAxis,peOrientation))
# end


# """
#     OSRSetAxes(OGRSpatialReferenceH hSRS,
#                const char * pszTargetKey,
#                const char * pszXAxisName,
#                OGRAxisOrientation eXAxisOrientation,
#                const char * pszYAxisName,
#                OGRAxisOrientation eYAxisOrientation) -> OGRErr
# Set the axes for a coordinate system.
# """
# function setaxes(hSRS::Ptr{OGRSpatialReferenceH},pszTargetKey,pszXAxisName,eXAxisOrientation::OGRAxisOrientation,pszYAxisName,eYAxisOrientation::OGRAxisOrientation)
#     ccall((:OSRSetAxes,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cstring,Cstring,OGRAxisOrientation,Cstring,OGRAxisOrientation),hSRS,pszTargetKey,pszXAxisName,eXAxisOrientation,pszYAxisName,eYAxisOrientation)
# end


# """
#     OSRSetACEA(OGRSpatialReferenceH hSRS,
#                double dfStdP1,
#                double dfStdP2,
#                double dfCenterLat,
#                double dfCenterLong,
#                double dfFalseEasting,
#                double dfFalseNorthing) -> OGRErr
# Albers Conic Equal Area.
# """
# function setacea(hSRS::Ptr{OGRSpatialReferenceH},dfStdP1::Real,dfStdP2::Real,dfCenterLat::Real,dfCenterLong::Real,dfFalseEasting::Real,dfFalseNorthing::Real)
#     ccall((:OSRSetACEA,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cdouble,Cdouble,Cdouble,Cdouble,Cdouble,Cdouble),hSRS,dfStdP1,dfStdP2,dfCenterLat,dfCenterLong,dfFalseEasting,dfFalseNorthing)
# end


# """
#     OSRSetAE(OGRSpatialReferenceH hSRS,
#              double dfCenterLat,
#              double dfCenterLong,
#              double dfFalseEasting,
#              double dfFalseNorthing) -> OGRErr
# Azimuthal Equidistant.
# """
# function setae(hSRS::Ptr{OGRSpatialReferenceH},dfCenterLat::Real,dfCenterLong::Real,dfFalseEasting::Real,dfFalseNorthing::Real)
#     ccall((:OSRSetAE,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cdouble,Cdouble,Cdouble,Cdouble),hSRS,dfCenterLat,dfCenterLong,dfFalseEasting,dfFalseNorthing)
# end


# """
#     OSRSetBonne(OGRSpatialReferenceH hSRS,
#                 double dfStdP1,
#                 double dfCentralMeridian,
#                 double dfFalseEasting,
#                 double dfFalseNorthing) -> OGRErr
# Bonne.
# """
# function setbonne(hSRS::Ptr{OGRSpatialReferenceH},dfStandardParallel::Real,dfCentralMeridian::Real,dfFalseEasting::Real,dfFalseNorthing::Real)
#     ccall((:OSRSetBonne,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cdouble,Cdouble,Cdouble,Cdouble),hSRS,dfStandardParallel,dfCentralMeridian,dfFalseEasting,dfFalseNorthing)
# end


# """
#     OSRSetCEA(OGRSpatialReferenceH hSRS,
#               double dfStdP1,
#               double dfCentralMeridian,
#               double dfFalseEasting,
#               double dfFalseNorthing) -> OGRErr
# Cylindrical Equal Area.
# """
# function setcea(hSRS::Ptr{OGRSpatialReferenceH},dfStdP1::Real,dfCentralMeridian::Real,dfFalseEasting::Real,dfFalseNorthing::Real)
#     ccall((:OSRSetCEA,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cdouble,Cdouble,Cdouble,Cdouble),hSRS,dfStdP1,dfCentralMeridian,dfFalseEasting,dfFalseNorthing)
# end


# """
#     OSRSetCS(OGRSpatialReferenceH hSRS,
#              double dfCenterLat,
#              double dfCenterLong,
#              double dfFalseEasting,
#              double dfFalseNorthing) -> OGRErr
# Cassini-Soldner.
# """
# function setcs(hSRS::Ptr{OGRSpatialReferenceH},dfCenterLat::Real,dfCenterLong::Real,dfFalseEasting::Real,dfFalseNorthing::Real)
#     ccall((:OSRSetCS,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cdouble,Cdouble,Cdouble,Cdouble),hSRS,dfCenterLat,dfCenterLong,dfFalseEasting,dfFalseNorthing)
# end


# """
#     OSRSetEC(OGRSpatialReferenceH hSRS,
#              double dfStdP1,
#              double dfStdP2,
#              double dfCenterLat,
#              double dfCenterLong,
#              double dfFalseEasting,
#              double dfFalseNorthing) -> OGRErr
# Equidistant Conic.
# """
# function setec(hSRS::Ptr{OGRSpatialReferenceH},dfStdP1::Real,dfStdP2::Real,dfCenterLat::Real,dfCenterLong::Real,dfFalseEasting::Real,dfFalseNorthing::Real)
#     ccall((:OSRSetEC,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cdouble,Cdouble,Cdouble,Cdouble,Cdouble,Cdouble),hSRS,dfStdP1,dfStdP2,dfCenterLat,dfCenterLong,dfFalseEasting,dfFalseNorthing)
# end


# """
#     OSRSetEckert(OGRSpatialReferenceH hSRS,
#                  int nVariation,
#                  double dfCentralMeridian,
#                  double dfFalseEasting,
#                  double dfFalseNorthing) -> OGRErr
# Eckert I-VI.
# """
# function seteckert(hSRS::Ptr{OGRSpatialReferenceH},nVariation::Integer,dfCentralMeridian::Real,dfFalseEasting::Real,dfFalseNorthing::Real)
#     ccall((:OSRSetEckert,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cint,Cdouble,Cdouble,Cdouble),hSRS,nVariation,dfCentralMeridian,dfFalseEasting,dfFalseNorthing)
# end


# """
#     OSRSetEckertIV(OGRSpatialReferenceH hSRS,
#                    double dfCentralMeridian,
#                    double dfFalseEasting,
#                    double dfFalseNorthing) -> OGRErr
# Eckert IV.
# """
# function seteckertiv(hSRS::Ptr{OGRSpatialReferenceH},dfCentralMeridian::Real,dfFalseEasting::Real,dfFalseNorthing::Real)
#     ccall((:OSRSetEckertIV,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cdouble,Cdouble,Cdouble),hSRS,dfCentralMeridian,dfFalseEasting,dfFalseNorthing)
# end


# """
#     OSRSetEckertVI(OGRSpatialReferenceH hSRS,
#                    double dfCentralMeridian,
#                    double dfFalseEasting,
#                    double dfFalseNorthing) -> OGRErr
# Eckert VI.
# """
# function seteckertvi(hSRS::Ptr{OGRSpatialReferenceH},dfCentralMeridian::Real,dfFalseEasting::Real,dfFalseNorthing::Real)
#     ccall((:OSRSetEckertVI,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cdouble,Cdouble,Cdouble),hSRS,dfCentralMeridian,dfFalseEasting,dfFalseNorthing)
# end


# """
#     OSRSetEquirectangular(OGRSpatialReferenceH hSRS,
#                           double dfCenterLat,
#                           double dfCenterLong,
#                           double dfFalseEasting,
#                           double dfFalseNorthing) -> OGRErr
# Equirectangular.
# """
# function setequirectangular(hSRS::Ptr{OGRSpatialReferenceH},dfCenterLat::Real,dfCenterLong::Real,dfFalseEasting::Real,dfFalseNorthing::Real)
#     ccall((:OSRSetEquirectangular,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cdouble,Cdouble,Cdouble,Cdouble),hSRS,dfCenterLat,dfCenterLong,dfFalseEasting,dfFalseNorthing)
# end


# """
#     OSRSetEquirectangular2(OGRSpatialReferenceH hSRS,
#                            double dfCenterLat,
#                            double dfCenterLong,
#                            double dfStdParallel1,
#                            double dfFalseEasting,
#                            double dfFalseNorthing) -> OGRErr
# Equirectangular generalized form.
# """
# function setequirectangular2(hSRS::Ptr{OGRSpatialReferenceH},dfCenterLat::Real,dfCenterLong::Real,dfPseudoStdParallel1::Real,dfFalseEasting::Real,dfFalseNorthing::Real)
#     ccall((:OSRSetEquirectangular2,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cdouble,Cdouble,Cdouble,Cdouble,Cdouble),hSRS,dfCenterLat,dfCenterLong,dfPseudoStdParallel1,dfFalseEasting,dfFalseNorthing)
# end


# """
#     OSRSetGS(OGRSpatialReferenceH hSRS,
#              double dfCentralMeridian,
#              double dfFalseEasting,
#              double dfFalseNorthing) -> OGRErr
# Gall Stereograpic.
# """
# function setgs(hSRS::Ptr{OGRSpatialReferenceH},dfCentralMeridian::Real,dfFalseEasting::Real,dfFalseNorthing::Real)
#     ccall((:OSRSetGS,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cdouble,Cdouble,Cdouble),hSRS,dfCentralMeridian,dfFalseEasting,dfFalseNorthing)
# end


# """
#     OSRSetGH(OGRSpatialReferenceH hSRS,
#              double dfCentralMeridian,
#              double dfFalseEasting,
#              double dfFalseNorthing) -> OGRErr
# Goode Homolosine.
# """
# function setgh(hSRS::Ptr{OGRSpatialReferenceH},dfCentralMeridian::Real,dfFalseEasting::Real,dfFalseNorthing::Real)
#     ccall((:OSRSetGH,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cdouble,Cdouble,Cdouble),hSRS,dfCentralMeridian,dfFalseEasting,dfFalseNorthing)
# end


# """
#     OSRSetIGH(OGRSpatialReferenceH hSRS) -> OGRErr
# Interrupted Goode Homolosine.
# """
# function setigh(hSRS::Ptr{OGRSpatialReferenceH})
#     ccall((:OSRSetIGH,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},),hSRS)
# end


# """
#     OSRSetGEOS(OGRSpatialReferenceH hSRS,
#                double dfCentralMeridian,
#                double dfSatelliteHeight,
#                double dfFalseEasting,
#                double dfFalseNorthing) -> OGRErr
# GEOS - Geostationary Satellite View.
# """
# function setgeos(hSRS::Ptr{OGRSpatialReferenceH},dfCentralMeridian::Real,dfSatelliteHeight::Real,dfFalseEasting::Real,dfFalseNorthing::Real)
#     ccall((:OSRSetGEOS,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cdouble,Cdouble,Cdouble,Cdouble),hSRS,dfCentralMeridian,dfSatelliteHeight,dfFalseEasting,dfFalseNorthing)
# end


# """
#     OSRSetGaussSchreiberTMercator(OGRSpatialReferenceH hSRS,
#                                   double dfCenterLat,
#                                   double dfCenterLong,
#                                   double dfScale,
#                                   double dfFalseEasting,
#                                   double dfFalseNorthing) -> OGRErr
# Gauss Schreiber Transverse Mercator.
# """
# function setgaussschreibertmercator(hSRS::Ptr{OGRSpatialReferenceH},dfCenterLat::Real,dfCenterLong::Real,dfScale::Real,dfFalseEasting::Real,dfFalseNorthing::Real)
#     ccall((:OSRSetGaussSchreiberTMercator,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cdouble,Cdouble,Cdouble,Cdouble,Cdouble),hSRS,dfCenterLat,dfCenterLong,dfScale,dfFalseEasting,dfFalseNorthing)
# end


# """
#     OSRSetGnomonic(OGRSpatialReferenceH hSRS,
#                    double dfCenterLat,
#                    double dfCenterLong,
#                    double dfFalseEasting,
#                    double dfFalseNorthing) -> OGRErr
# Gnomonic.
# """
# function setgnomonic(hSRS::Ptr{OGRSpatialReferenceH},dfCenterLat::Real,dfCenterLong::Real,dfFalseEasting::Real,dfFalseNorthing::Real)
#     ccall((:OSRSetGnomonic,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cdouble,Cdouble,Cdouble,Cdouble),hSRS,dfCenterLat,dfCenterLong,dfFalseEasting,dfFalseNorthing)
# end


# """
#     OSRSetOM(OGRSpatialReferenceH hSRS,
#              double dfCenterLat,
#              double dfCenterLong,
#              double dfAzimuth,
#              double dfRectToSkew,
#              double dfScale,
#              double dfFalseEasting,
#              double dfFalseNorthing) -> OGRErr
# Oblique Mercator (aka HOM (variant B)
# """
# function setom(hSRS::Ptr{OGRSpatialReferenceH},dfCenterLat::Real,dfCenterLong::Real,dfAzimuth::Real,dfRectToSkew::Real,dfScale::Real,dfFalseEasting::Real,dfFalseNorthing::Real)
#     ccall((:OSRSetOM,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cdouble,Cdouble,Cdouble,Cdouble,Cdouble,Cdouble,Cdouble),hSRS,dfCenterLat,dfCenterLong,dfAzimuth,dfRectToSkew,dfScale,dfFalseEasting,dfFalseNorthing)
# end


# """
#     OSRSetHOM(OGRSpatialReferenceH hSRS,
#               double dfCenterLat,
#               double dfCenterLong,
#               double dfAzimuth,
#               double dfRectToSkew,
#               double dfScale,
#               double dfFalseEasting,
#               double dfFalseNorthing) -> OGRErr
# Set a Hotine Oblique Mercator projection using azimuth angle.
# """
# function sethom(hSRS::Ptr{OGRSpatialReferenceH},dfCenterLat::Real,dfCenterLong::Real,dfAzimuth::Real,dfRectToSkew::Real,dfScale::Real,dfFalseEasting::Real,dfFalseNorthing::Real)
#     ccall((:OSRSetHOM,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cdouble,Cdouble,Cdouble,Cdouble,Cdouble,Cdouble,Cdouble),hSRS,dfCenterLat,dfCenterLong,dfAzimuth,dfRectToSkew,dfScale,dfFalseEasting,dfFalseNorthing)
# end


# """
#     OSRSetHOMAC(OGRSpatialReferenceH hSRS,
#                 double dfCenterLat,
#                 double dfCenterLong,
#                 double dfAzimuth,
#                 double dfRectToSkew,
#                 double dfScale,
#                 double dfFalseEasting,
#                 double dfFalseNorthing) -> OGRErr
# Set an Oblique Mercator projection using azimuth angle.
# """
# function sethomac(hSRS::Ptr{OGRSpatialReferenceH},dfCenterLat::Real,dfCenterLong::Real,dfAzimuth::Real,dfRectToSkew::Real,dfScale::Real,dfFalseEasting::Real,dfFalseNorthing::Real)
#     ccall((:OSRSetHOMAC,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cdouble,Cdouble,Cdouble,Cdouble,Cdouble,Cdouble,Cdouble),hSRS,dfCenterLat,dfCenterLong,dfAzimuth,dfRectToSkew,dfScale,dfFalseEasting,dfFalseNorthing)
# end


# """
#     OSRSetHOM2PNO(OGRSpatialReferenceH hSRS,
#                   double dfCenterLat,
#                   double dfLat1,
#                   double dfLong1,
#                   double dfLat2,
#                   double dfLong2,
#                   double dfScale,
#                   double dfFalseEasting,
#                   double dfFalseNorthing) -> OGRErr
# Set a Hotine Oblique Mercator projection using two points on projection centerline.
# """
# function sethom2pno(hSRS::Ptr{OGRSpatialReferenceH},dfCenterLat::Real,dfLat1::Real,dfLong1::Real,dfLat2::Real,dfLong2::Real,dfScale::Real,dfFalseEasting::Real,dfFalseNorthing::Real)
#     ccall((:OSRSetHOM2PNO,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cdouble,Cdouble,Cdouble,Cdouble,Cdouble,Cdouble,Cdouble,Cdouble),hSRS,dfCenterLat,dfLat1,dfLong1,dfLat2,dfLong2,dfScale,dfFalseEasting,dfFalseNorthing)
# end


# """
#     OSRSetIWMPolyconic(OGRSpatialReferenceH hSRS,
#                        double dfLat1,
#                        double dfLat2,
#                        double dfCenterLong,
#                        double dfFalseEasting,
#                        double dfFalseNorthing) -> OGRErr
# International Map of the World Polyconic.
# """
# function setiwmpolyconic(hSRS::Ptr{OGRSpatialReferenceH},dfLat1::Real,dfLat2::Real,dfCenterLong::Real,dfFalseEasting::Real,dfFalseNorthing::Real)
#     ccall((:OSRSetIWMPolyconic,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cdouble,Cdouble,Cdouble,Cdouble,Cdouble),hSRS,dfLat1,dfLat2,dfCenterLong,dfFalseEasting,dfFalseNorthing)
# end


# """
#     OSRSetKrovak(OGRSpatialReferenceH hSRS,
#                  double dfCenterLat,
#                  double dfCenterLong,
#                  double dfAzimuth,
#                  double dfPseudoStdParallel1,
#                  double dfScale,
#                  double dfFalseEasting,
#                  double dfFalseNorthing) -> OGRErr
# Krovak Oblique Conic Conformal.
# """
# function setkrovak(hSRS::Ptr{OGRSpatialReferenceH},dfCenterLat::Real,dfCenterLong::Real,dfAzimuth::Real,dfPseudoStdParallelLat::Real,dfScale::Real,dfFalseEasting::Real,dfFalseNorthing::Real)
#     ccall((:OSRSetKrovak,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cdouble,Cdouble,Cdouble,Cdouble,Cdouble,Cdouble,Cdouble),hSRS,dfCenterLat,dfCenterLong,dfAzimuth,dfPseudoStdParallelLat,dfScale,dfFalseEasting,dfFalseNorthing)
# end


# """
#     OSRSetLAEA(OGRSpatialReferenceH hSRS,
#                double dfCenterLat,
#                double dfCenterLong,
#                double dfFalseEasting,
#                double dfFalseNorthing) -> OGRErr
# Lambert Azimuthal Equal-Area.
# """
# function setlaea(hSRS::Ptr{OGRSpatialReferenceH},dfCenterLat::Real,dfCenterLong::Real,dfFalseEasting::Real,dfFalseNorthing::Real)
#     ccall((:OSRSetLAEA,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cdouble,Cdouble,Cdouble,Cdouble),hSRS,dfCenterLat,dfCenterLong,dfFalseEasting,dfFalseNorthing)
# end


# """
#     OSRSetLCC(OGRSpatialReferenceH hSRS,
#               double dfStdP1,
#               double dfStdP2,
#               double dfCenterLat,
#               double dfCenterLong,
#               double dfFalseEasting,
#               double dfFalseNorthing) -> OGRErr
# Lambert Conformal Conic.
# """
# function setlcc(hSRS::Ptr{OGRSpatialReferenceH},dfStdP1::Real,dfStdP2::Real,dfCenterLat::Real,dfCenterLong::Real,dfFalseEasting::Real,dfFalseNorthing::Real)
#     ccall((:OSRSetLCC,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cdouble,Cdouble,Cdouble,Cdouble,Cdouble,Cdouble),hSRS,dfStdP1,dfStdP2,dfCenterLat,dfCenterLong,dfFalseEasting,dfFalseNorthing)
# end


# """
#     OSRSetLCC1SP(OGRSpatialReferenceH hSRS,
#                  double dfCenterLat,
#                  double dfCenterLong,
#                  double dfScale,
#                  double dfFalseEasting,
#                  double dfFalseNorthing) -> OGRErr
# Lambert Conformal Conic 1SP.
# """
# function setlcc1sp(hSRS::Ptr{OGRSpatialReferenceH},dfCenterLat::Real,dfCenterLong::Real,dfScale::Real,dfFalseEasting::Real,dfFalseNorthing::Real)
#     ccall((:OSRSetLCC1SP,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cdouble,Cdouble,Cdouble,Cdouble,Cdouble),hSRS,dfCenterLat,dfCenterLong,dfScale,dfFalseEasting,dfFalseNorthing)
# end


# """
#     OSRSetLCCB(OGRSpatialReferenceH hSRS,
#                double dfStdP1,
#                double dfStdP2,
#                double dfCenterLat,
#                double dfCenterLong,
#                double dfFalseEasting,
#                double dfFalseNorthing) -> OGRErr
# Lambert Conformal Conic (Belgium)
# """
# function setlccb(hSRS::Ptr{OGRSpatialReferenceH},dfStdP1::Real,dfStdP2::Real,dfCenterLat::Real,dfCenterLong::Real,dfFalseEasting::Real,dfFalseNorthing::Real)
#     ccall((:OSRSetLCCB,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cdouble,Cdouble,Cdouble,Cdouble,Cdouble,Cdouble),hSRS,dfStdP1,dfStdP2,dfCenterLat,dfCenterLong,dfFalseEasting,dfFalseNorthing)
# end


# """
#     OSRSetMC(OGRSpatialReferenceH hSRS,
#              double dfCenterLat,
#              double dfCenterLong,
#              double dfFalseEasting,
#              double dfFalseNorthing) -> OGRErr
# Miller Cylindrical.
# """
# function setmc(hSRS::Ptr{OGRSpatialReferenceH},dfCenterLat::Real,dfCenterLong::Real,dfFalseEasting::Real,dfFalseNorthing::Real)
#     ccall((:OSRSetMC,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cdouble,Cdouble,Cdouble,Cdouble),hSRS,dfCenterLat,dfCenterLong,dfFalseEasting,dfFalseNorthing)
# end


# """
#     OSRSetMercator(OGRSpatialReferenceH hSRS,
#                    double dfCenterLat,
#                    double dfCenterLong,
#                    double dfScale,
#                    double dfFalseEasting,
#                    double dfFalseNorthing) -> OGRErr
# Mercator.
# """
# function setmercator(hSRS::Ptr{OGRSpatialReferenceH},dfCenterLat::Real,dfCenterLong::Real,dfScale::Real,dfFalseEasting::Real,dfFalseNorthing::Real)
#     ccall((:OSRSetMercator,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cdouble,Cdouble,Cdouble,Cdouble,Cdouble),hSRS,dfCenterLat,dfCenterLong,dfScale,dfFalseEasting,dfFalseNorthing)
# end


# """
#     OSRSetMercator2SP(OGRSpatialReferenceH hSRS,
#                       double dfStdP1,
#                       double dfCenterLat,
#                       double dfCenterLong,
#                       double dfFalseEasting,
#                       double dfFalseNorthing) -> OGRErr
# """
# function setmercator2sp(hSRS::Ptr{OGRSpatialReferenceH},dfStdP1::Real,dfCenterLat::Real,dfCenterLong::Real,dfFalseEasting::Real,dfFalseNorthing::Real)
#     ccall((:OSRSetMercator2SP,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cdouble,Cdouble,Cdouble,Cdouble,Cdouble),hSRS,dfStdP1,dfCenterLat,dfCenterLong,dfFalseEasting,dfFalseNorthing)
# end


# """
#     OSRSetMollweide(OGRSpatialReferenceH hSRS,
#                     double dfCentralMeridian,
#                     double dfFalseEasting,
#                     double dfFalseNorthing) -> OGRErr
# Mollweide.
# """
# function setmollweide(hSRS::Ptr{OGRSpatialReferenceH},dfCentralMeridian::Real,dfFalseEasting::Real,dfFalseNorthing::Real)
#     ccall((:OSRSetMollweide,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cdouble,Cdouble,Cdouble),hSRS,dfCentralMeridian,dfFalseEasting,dfFalseNorthing)
# end


# """
#     OSRSetNZMG(OGRSpatialReferenceH hSRS,
#                double dfCenterLat,
#                double dfCenterLong,
#                double dfFalseEasting,
#                double dfFalseNorthing) -> OGRErr
# New Zealand Map Grid.
# """
# function setnzmg(hSRS::Ptr{OGRSpatialReferenceH},dfCenterLat::Real,dfCenterLong::Real,dfFalseEasting::Real,dfFalseNorthing::Real)
#     ccall((:OSRSetNZMG,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cdouble,Cdouble,Cdouble,Cdouble),hSRS,dfCenterLat,dfCenterLong,dfFalseEasting,dfFalseNorthing)
# end


# """
#     OSRSetOS(OGRSpatialReferenceH hSRS,
#              double dfOriginLat,
#              double dfCMeridian,
#              double dfScale,
#              double dfFalseEasting,
#              double dfFalseNorthing) -> OGRErr
# Oblique Stereographic.
# """
# function setos(hSRS::Ptr{OGRSpatialReferenceH},dfOriginLat::Real,dfCMeridian::Real,dfScale::Real,dfFalseEasting::Real,dfFalseNorthing::Real)
#     ccall((:OSRSetOS,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cdouble,Cdouble,Cdouble,Cdouble,Cdouble),hSRS,dfOriginLat,dfCMeridian,dfScale,dfFalseEasting,dfFalseNorthing)
# end


# """
#     OSRSetOrthographic(OGRSpatialReferenceH hSRS,
#                        double dfCenterLat,
#                        double dfCenterLong,
#                        double dfFalseEasting,
#                        double dfFalseNorthing) -> OGRErr
# Orthographic.
# """
# function setorthographic(hSRS::Ptr{OGRSpatialReferenceH},dfCenterLat::Real,dfCenterLong::Real,dfFalseEasting::Real,dfFalseNorthing::Real)
#     ccall((:OSRSetOrthographic,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cdouble,Cdouble,Cdouble,Cdouble),hSRS,dfCenterLat,dfCenterLong,dfFalseEasting,dfFalseNorthing)
# end


# """
#     OSRSetPolyconic(OGRSpatialReferenceH hSRS,
#                     double dfCenterLat,
#                     double dfCenterLong,
#                     double dfFalseEasting,
#                     double dfFalseNorthing) -> OGRErr
# Polyconic.
# """
# function setpolyconic(hSRS::Ptr{OGRSpatialReferenceH},dfCenterLat::Real,dfCenterLong::Real,dfFalseEasting::Real,dfFalseNorthing::Real)
#     ccall((:OSRSetPolyconic,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cdouble,Cdouble,Cdouble,Cdouble),hSRS,dfCenterLat,dfCenterLong,dfFalseEasting,dfFalseNorthing)
# end


# """
#     OSRSetPS(OGRSpatialReferenceH hSRS,
#              double dfCenterLat,
#              double dfCenterLong,
#              double dfScale,
#              double dfFalseEasting,
#              double dfFalseNorthing) -> OGRErr
# Polar Stereographic.
# """
# function setps(hSRS::Ptr{OGRSpatialReferenceH},dfCenterLat::Real,dfCenterLong::Real,dfScale::Real,dfFalseEasting::Real,dfFalseNorthing::Real)
#     ccall((:OSRSetPS,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cdouble,Cdouble,Cdouble,Cdouble,Cdouble),hSRS,dfCenterLat,dfCenterLong,dfScale,dfFalseEasting,dfFalseNorthing)
# end


# """
#     OSRSetRobinson(OGRSpatialReferenceH hSRS,
#                    double dfCenterLong,
#                    double dfFalseEasting,
#                    double dfFalseNorthing) -> OGRErr
# Robinson.
# """
# function setrobinson(hSRS::Ptr{OGRSpatialReferenceH},dfCenterLong::Real,dfFalseEasting::Real,dfFalseNorthing::Real)
#     ccall((:OSRSetRobinson,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cdouble,Cdouble,Cdouble),hSRS,dfCenterLong,dfFalseEasting,dfFalseNorthing)
# end


# """
#     OSRSetSinusoidal(OGRSpatialReferenceH hSRS,
#                      double dfCenterLong,
#                      double dfFalseEasting,
#                      double dfFalseNorthing) -> OGRErr
# Sinusoidal.
# """
# function setsinusoidal(hSRS::Ptr{OGRSpatialReferenceH},dfCenterLong::Real,dfFalseEasting::Real,dfFalseNorthing::Real)
#     ccall((:OSRSetSinusoidal,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cdouble,Cdouble,Cdouble),hSRS,dfCenterLong,dfFalseEasting,dfFalseNorthing)
# end


# """
#     OSRSetStereographic(OGRSpatialReferenceH hSRS,
#                         double dfOriginLat,
#                         double dfCMeridian,
#                         double dfScale,
#                         double dfFalseEasting,
#                         double dfFalseNorthing) -> OGRErr
# Stereographic.
# """
# function setstereographic(hSRS::Ptr{OGRSpatialReferenceH},dfCenterLat::Real,dfCenterLong::Real,dfScale::Real,dfFalseEasting::Real,dfFalseNorthing::Real)
#     ccall((:OSRSetStereographic,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cdouble,Cdouble,Cdouble,Cdouble,Cdouble),hSRS,dfCenterLat,dfCenterLong,dfScale,dfFalseEasting,dfFalseNorthing)
# end


# """
#     OSRSetSOC(OGRSpatialReferenceH hSRS,
#               double dfLatitudeOfOrigin,
#               double dfCentralMeridian,
#               double dfFalseEasting,
#               double dfFalseNorthing) -> OGRErr
# Swiss Oblique Cylindrical.
# """
# function setsoc(hSRS::Ptr{OGRSpatialReferenceH},dfLatitudeOfOrigin::Real,dfCentralMeridian::Real,dfFalseEasting::Real,dfFalseNorthing::Real)
#     ccall((:OSRSetSOC,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cdouble,Cdouble,Cdouble,Cdouble),hSRS,dfLatitudeOfOrigin,dfCentralMeridian,dfFalseEasting,dfFalseNorthing)
# end


# """
#     OSRSetTM(OGRSpatialReferenceH hSRS,
#              double dfCenterLat,
#              double dfCenterLong,
#              double dfScale,
#              double dfFalseEasting,
#              double dfFalseNorthing) -> OGRErr
# Transverse Mercator.
# """
# function settm(hSRS::Ptr{OGRSpatialReferenceH},dfCenterLat::Real,dfCenterLong::Real,dfScale::Real,dfFalseEasting::Real,dfFalseNorthing::Real)
#     ccall((:OSRSetTM,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cdouble,Cdouble,Cdouble,Cdouble,Cdouble),hSRS,dfCenterLat,dfCenterLong,dfScale,dfFalseEasting,dfFalseNorthing)
# end


# """
#     OSRSetTMVariant(OGRSpatialReferenceH hSRS,
#                     const char * pszVariantName,
#                     double dfCenterLat,
#                     double dfCenterLong,
#                     double dfScale,
#                     double dfFalseEasting,
#                     double dfFalseNorthing) -> OGRErr
# Transverse Mercator variant.
# """
# function settmvariant(hSRS::Ptr{OGRSpatialReferenceH},pszVariantName,dfCenterLat::Real,dfCenterLong::Real,dfScale::Real,dfFalseEasting::Real,dfFalseNorthing::Real)
#     ccall((:OSRSetTMVariant,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cstring,Cdouble,Cdouble,Cdouble,Cdouble,Cdouble),hSRS,pszVariantName,dfCenterLat,dfCenterLong,dfScale,dfFalseEasting,dfFalseNorthing)
# end


# """
#     OSRSetTMG(OGRSpatialReferenceH hSRS,
#               double dfCenterLat,
#               double dfCenterLong,
#               double dfFalseEasting,
#               double dfFalseNorthing) -> OGRErr
# Tunesia Mining Grid.
# """
# function settmg(hSRS::Ptr{OGRSpatialReferenceH},dfCenterLat::Real,dfCenterLong::Real,dfFalseEasting::Real,dfFalseNorthing::Real)
#     ccall((:OSRSetTMG,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cdouble,Cdouble,Cdouble,Cdouble),hSRS,dfCenterLat,dfCenterLong,dfFalseEasting,dfFalseNorthing)
# end


# """
#     OSRSetTMSO(OGRSpatialReferenceH hSRS,
#                double dfCenterLat,
#                double dfCenterLong,
#                double dfScale,
#                double dfFalseEasting,
#                double dfFalseNorthing) -> OGRErr
# Transverse Mercator (South Oriented)
# """
# function settmso(hSRS::Ptr{OGRSpatialReferenceH},dfCenterLat::Real,dfCenterLong::Real,dfScale::Real,dfFalseEasting::Real,dfFalseNorthing::Real)
#     ccall((:OSRSetTMSO,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cdouble,Cdouble,Cdouble,Cdouble,Cdouble),hSRS,dfCenterLat,dfCenterLong,dfScale,dfFalseEasting,dfFalseNorthing)
# end


# """
#     OSRSetTPED(OGRSpatialReferenceH hSRS,
#                double dfLat1,
#                double dfLong1,
#                double dfLat2,
#                double dfLong2,
#                double dfFalseEasting,
#                double dfFalseNorthing) -> OGRErr
# """
# function settped(hSRS::Ptr{OGRSpatialReferenceH},dfLat1::Real,dfLong1::Real,dfLat2::Real,dfLong2::Real,dfFalseEasting::Real,dfFalseNorthing::Real)
#     ccall((:OSRSetTPED,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cdouble,Cdouble,Cdouble,Cdouble,Cdouble,Cdouble),hSRS,dfLat1,dfLong1,dfLat2,dfLong2,dfFalseEasting,dfFalseNorthing)
# end


# """
#     OSRSetVDG(OGRSpatialReferenceH hSRS,
#               double dfCentralMeridian,
#               double dfFalseEasting,
#               double dfFalseNorthing) -> OGRErr
# VanDerGrinten.
# """
# function setvdg(hSRS::Ptr{OGRSpatialReferenceH},dfCenterLong::Real,dfFalseEasting::Real,dfFalseNorthing::Real)
#     ccall((:OSRSetVDG,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cdouble,Cdouble,Cdouble),hSRS,dfCenterLong,dfFalseEasting,dfFalseNorthing)
# end


# """
#     OSRSetWagner(OGRSpatialReferenceH hSRS,
#                  int nVariation,
#                  double dfCenterLat,
#                  double dfFalseEasting,
#                  double dfFalseNorthing) -> OGRErr
# Wagner I  VII.
# """
# function setwagner(hSRS::Ptr{OGRSpatialReferenceH},nVariation::Integer,dfCenterLat::Real,dfFalseEasting::Real,dfFalseNorthing::Real)
#     ccall((:OSRSetWagner,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cint,Cdouble,Cdouble,Cdouble),hSRS,nVariation,dfCenterLat,dfFalseEasting,dfFalseNorthing)
# end


# """
#     OSRSetQSC(OGRSpatialReferenceH hSRS,
#               double dfCenterLat,
#               double dfCenterLong) -> OGRErr
# Quadrilateralized Spherical Cube.
# """
# function setqsc(hSRS::Ptr{OGRSpatialReferenceH},dfCenterLat::Real,dfCenterLong::Real)
#     ccall((:OSRSetQSC,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cdouble,Cdouble),hSRS,dfCenterLat,dfCenterLong)
# end


# """
#     OSRSetSCH(OGRSpatialReferenceH hSRS,
#               double dfPegLat,
#               double dfPegLong,
#               double dfPegHeading,
#               double dfPegHgt) -> OGRErr
# Spherical, Cross-track, Height.
# """
# function setsch(hSRS::Ptr{OGRSpatialReferenceH},dfPegLat::Real,dfPegLong::Real,dfPegHeading::Real,dfPegHgt::Real)
#     ccall((:OSRSetSCH,libgdal),OGRErr,(Ptr{OGRSpatialReferenceH},Cdouble,Cdouble,Cdouble,Cdouble),hSRS,dfPegLat,dfPegLong,dfPegHeading,dfPegHgt)
# end


# """
#     OSRCalcInvFlattening(double dfSemiMajor,
#                          double dfSemiMinor) -> double
# Compute inverse flattening from semi-major and semi-minor axis.
# ### Parameters
# * **dfSemiMajor**: Semi-major axis length.
# * **dfSemiMinor**: Semi-minor axis length.
# ### Returns
# inverse flattening, or 0 if both axis are equal.
# """
# function calcinvflattening(dfSemiMajor::Real,dfSemiMinor::Real)
#     ccall((:OSRCalcInvFlattening,libgdal),Cdouble,(Cdouble,Cdouble),dfSemiMajor,dfSemiMinor)
# end


# """
#     OSRCalcSemiMinorFromInvFlattening(double dfSemiMajor,
#                                       double dfInvFlattening) -> double
# Compute semi-minor axis from semi-major axis and inverse flattening.
# ### Parameters
# * **dfSemiMajor**: Semi-major axis length.
# * **dfInvFlattening**: Inverse flattening or 0 for sphere.
# ### Returns
# semi-minor axis
# """
# function calcsemiminorfrominvflattening(dfSemiMajor::Real,dfInvFlattening::Real)
#     ccall((:OSRCalcSemiMinorFromInvFlattening,libgdal),Cdouble,(Cdouble,Cdouble),dfSemiMajor,dfInvFlattening)
# end


# """
#     OSRCleanup(void) -> void
# Cleanup cached SRS related memory.
# """
# function cleanup()
#     ccall((:OSRCleanup,libgdal),Void,())
# end


"""
    OCTNewCoordinateTransformation(OGRSpatialReferenceH hSourceSRS,
                                   OGRSpatialReferenceH hTargetSRS) -> OGRCoordinateTransformationH
Create transformation object.
### Parameters
* **hSourceSRS**: source spatial reference system.
* **hTargetSRS**: target spatial reference system.
### Returns
NULL on failure or a ready to use transformation object.
"""
createcoordtrans(source::SpatialRef, target::SpatialRef) =
    CoordTransform(GDAL.octnewcoordinatetransformation(source, target))

"""
    OCTDestroyCoordinateTransformation(OGRCoordinateTransformationH hCT) -> void
OGRCoordinateTransformation destructor.
### Parameters
* **hCT**: the object to delete
"""
function destroy(obj::CoordTransform)
    GDAL.octdestroycoordinatetransformation(obj)
    obj = C_NULL
end

"""
Transform points from source to destination space.

This method is the same as the C function OCTTransform().

The method TransformEx() allows extended success information to be captured indicating which points failed to transform.

Parameters
nCount  number of points to transform.
x   array of nCount X vertices, modified in place.
y   array of nCount Y vertices, modified in place.
z   array of nCount Z vertices, modified in place.
Returns
TRUE on success, or FALSE if some or all points fail to transform.
"""
function transform!(obj::CoordTransform,
                    xvertices::Vector{Cdouble},
                    yvertices::Vector{Cdouble},
                    zvertices::Vector{Cdouble})
    n = length(xvertices)
    @assert length(yvertices) == n
    @assert length(zvertices) == n
    Bool(GDAL.octtransform(obj, n, pointer(xvertices),
                           pointer(yvertices), pointer(zvertices)))
end

# """
#     OCTTransformEx(OGRCoordinateTransformationH hTransform,
#                    int nCount,
#                    double * x,
#                    double * y,
#                    double * z,
#                    int * pabSuccess) -> int
# """
# function octtransformex(hCT::Ptr{OGRCoordinateTransformationH},nCount::Integer,x,y,z,pabSuccess)
#     ccall((:OCTTransformEx,libgdal),Cint,(Ptr{OGRCoordinateTransformationH},Cint,Ptr{Cdouble},Ptr{Cdouble},Ptr{Cdouble},Ptr{Cint}),hCT,nCount,x,y,z,pabSuccess)
# end


# """
#     OCTProj4Normalize(const char * pszProj4Src) -> char *
# """
# function octproj4normalize(pszProj4Src)
#     bytestring(ccall((:OCTProj4Normalize,libgdal),Cstring,(Cstring,),pszProj4Src))
# end


# """
#     OCTCleanupProjMutex() -> void
# """
# function octcleanupprojmutex()
#     ccall((:OCTCleanupProjMutex,libgdal),Void,())
# end


# """
#     OPTGetProjectionMethods() -> char **
# Fetch list of possible projection methods.
# ### Returns
# Returns NULL terminated list of projection methods. This should be freed with CSLDestroy() when no longer needed.
# """
# function optgetprojectionmethods()
#     bytestring(unsafe_load(ccall((:OPTGetProjectionMethods,libgdal),Ptr{Cstring},())))
# end


# """
#     OPTGetParameterList(const char * pszProjectionMethod,
#                         char ** ppszUserName) -> char **
# Fetch the parameters for a given projection method.
# ### Parameters
# * **pszProjectionMethod**: internal name of projection methods to fetch the parameters for, such as "Transverse_Mercator" (SRS_PT_TRANSVERSE_MERCATOR).
# * **ppszUserName**: pointer in which to return a user visible name for the projection name. The returned string should not be modified or freed by the caller. Legal to pass in NULL if user name not required.
# ### Returns
# returns a NULL terminated list of internal parameter names that should be freed by the caller when no longer needed. Returns NULL if projection method is unknown.
# """
# function optgetparameterlist(pszProjectionMethod,ppszUserName)
#     bytestring(unsafe_load(ccall((:OPTGetParameterList,libgdal),Ptr{Cstring},(Cstring,Ptr{Cstring}),pszProjectionMethod,ppszUserName)))
# end


# """
#     OPTGetParameterInfo(const char * pszProjectionMethod,
#                         const char * pszParameterName,
#                         char ** ppszUserName,
#                         char ** ppszType,
#                         double * pdfDefaultValue) -> int
# Fetch information about a single parameter of a projection method.
# ### Parameters
# * **pszProjectionMethod**: name of projection method for which the parameter applies. Not currently used, but in the future this could affect defaults. This is the internal projection method name, such as "Tranverse_Mercator".
# * **pszParameterName**: name of the parameter to fetch information about. This is the internal name such as "central_meridian" (SRS_PP_CENTRAL_MERIDIAN).
# * **ppszUserName**: location at which to return the user visible name for the parameter. This pointer may be NULL to skip the user name. The returned name should not be modified or freed.
# * **ppszType**: location at which to return the parameter type for the parameter. This pointer may be NULL to skip. The returned type should not be modified or freed. The type values are described above.
# * **pdfDefaultValue**: location at which to put the default value for this parameter. The pointer may be NULL.
# ### Returns
# TRUE if parameter found, or FALSE otherwise.
# """
# function optgetparameterinfo(pszProjectionMethod,pszParameterName,ppszUserName,ppszType,pdfDefaultValue)
#     ccall((:OPTGetParameterInfo,libgdal),Cint,(Cstring,Cstring,Ptr{Cstring},Ptr{Cstring},Ptr{Cdouble}),pszProjectionMethod,pszParameterName,ppszUserName,ppszType,pdfDefaultValue)
# end