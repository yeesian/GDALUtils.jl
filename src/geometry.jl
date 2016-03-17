"""
    OGR_G_CreateFromWkb(unsigned char * pabyData,
                        OGRSpatialReferenceH hSRS,
                        OGRGeometryH * phGeometry,
                        int nBytes) -> OGRErr
Create a geometry object of the appropriate type from it's well known binary representation.
### Parameters
* **pabyData**: pointer to the input BLOB data.
* **hSRS**: handle to the spatial reference to be assigned to the created geometry object. This may be NULL.
* **phGeometry**: the newly created geometry object will be assigned to the indicated handle on return. This will be NULL in case of failure. If not NULL, *phGeometry should be freed with OGR_G_DestroyGeometry() after use.
* **nBytes**: the number of bytes of data available in pabyData, or -1 if it is not known, but assumed to be sufficient.
### Returns
OGRERR_NONE if all goes well, otherwise any of OGRERR_NOT_ENOUGH_DATA, OGRERR_UNSUPPORTED_GEOMETRY_TYPE, or OGRERR_CORRUPT_DATA may be returned.
"""
function fromWKB(data, spatialref::SpatialRef)
    geom = Ptr{GDAL.OGRGeometryH}(0)
    GDAL.createfromwkb(data, spatialref.ptr, geom, -1)
    Geometry(geom)
end

"""
    OGR_G_CreateFromWkt(char ** ppszData,
                        OGRSpatialReferenceH hSRS,
                        OGRGeometryH * phGeometry) -> OGRErr
Create a geometry object of the appropriate type from it's well known text representation.
### Parameters
* **ppszData**: input zero terminated string containing well known text representation of the geometry to be created. The pointer is updated to point just beyond that last character consumed.
* **hSRS**: handle to the spatial reference to be assigned to the created geometry object. This may be NULL.
* **phGeometry**: the newly created geometry object will be assigned to the indicated handle on return. This will be NULL if the method fails. If not NULL, *phGeometry should be freed with OGR_G_DestroyGeometry() after use.
### Returns
OGRERR_NONE if all goes well, otherwise any of OGRERR_NOT_ENOUGH_DATA, OGRERR_UNSUPPORTED_GEOMETRY_TYPE, or OGRERR_CORRUPT_DATA may be returned.
"""
function fromWKT(data, spatialref::SpatialRef)
    geom = Ptr{GDAL.OGRGeometryH}(0)
    GDAL.createfromwkt(data, spatialref.ptr, geom)
    Geometry(geom)
end

#"""
#     OGR_G_CreateFromFgf(unsigned char * pabyData,
#                         OGRSpatialReferenceH hSRS,
#                         OGRGeometryH * phGeometry,
#                         int nBytes,
#                         int * pnBytesConsumed) -> OGRErr
# """
# function createfromfgf(arg1,arg2::Ptr{OGRSpatialReferenceH},arg3,arg4::Integer,arg5)
#     ccall((:OGR_G_CreateFromFgf,libgdal),OGRErr,(Ptr{Cuchar},Ptr{OGRSpatialReferenceH},Ptr{OGRGeometryH},Cint,Ptr{Cint}),arg1,arg2,arg3,arg4,arg5)
# end


"""
    OGR_G_DestroyGeometry(OGRGeometryH hGeom) -> void
Destroy geometry object.
### Parameters
* **hGeom**: handle to the geometry to delete.
"""
function destroy(geom::Geometry)
    GDAL.destroygeometry(geom.ptr)
    geom.ptr = C_NULL
end


"""
    OGR_G_CreateGeometry(OGRwkbGeometryType eGeometryType) -> OGRGeometryH
Create an empty geometry of desired type.
### Parameters
* **eGeometryType**: the type code of the geometry to be created.
### Returns
handle to the newly create geometry or NULL on failure. Should be freed with OGR_G_DestroyGeometry() after use.
"""
creategeometry(geomtype::GDAL.OGRwkbGeometryType) =
    Geometry(GDAL.creategeometry(geomtype))

# """
#     OGR_G_ApproximateArcAngles(double dfCenterX,
#                                double dfCenterY,
#                                double dfZ,
#                                double dfPrimaryRadius,
#                                double dfSecondaryRadius,
#                                double dfRotation,
#                                double dfStartAngle,
#                                double dfEndAngle,
#                                double dfMaxAngleStepSizeDegrees) -> OGRGeometryH
# Stroke arc to linestring.
# ### Parameters
# * **dfCenterX**: center X
# * **dfCenterY**: center Y
# * **dfZ**: center Z
# * **dfPrimaryRadius**: X radius of ellipse.
# * **dfSecondaryRadius**: Y radius of ellipse.
# * **dfRotation**: rotation of the ellipse clockwise.
# * **dfStartAngle**: angle to first point on arc (clockwise of X-positive)
# * **dfEndAngle**: angle to last point on arc (clockwise of X-positive)
# * **dfMaxAngleStepSizeDegrees**: the largest step in degrees along the arc, zero to use the default setting.
# ### Returns
# OGRLineString geometry representing an approximation of the arc.
# """
# function approximatearcangles(dfCenterX::Real,dfCenterY::Real,dfZ::Real,dfPrimaryRadius::Real,dfSecondaryAxis::Real,dfRotation::Real,dfStartAngle::Real,dfEndAngle::Real,dfMaxAngleStepSizeDegrees::Real)
#     checknull(ccall((:OGR_G_ApproximateArcAngles,libgdal),Ptr{OGRGeometryH},(Cdouble,Cdouble,Cdouble,Cdouble,Cdouble,Cdouble,Cdouble,Cdouble,Cdouble),dfCenterX,dfCenterY,dfZ,dfPrimaryRadius,dfSecondaryAxis,dfRotation,dfStartAngle,dfEndAngle,dfMaxAngleStepSizeDegrees))
# end


# """
#     OGR_G_ForceToPolygon(OGRGeometryH hGeom) -> OGRGeometryH
# Convert to polygon.
# ### Parameters
# * **hGeom**: handle to the geometry to convert (ownership surrendered).
# ### Returns
# the converted geometry (ownership to caller).
# """
# function forcetopolygon(arg1::Ptr{OGRGeometryH})
#     checknull(ccall((:OGR_G_ForceToPolygon,libgdal),Ptr{OGRGeometryH},(Ptr{OGRGeometryH},),arg1))
# end


# """
#     OGR_G_ForceToLineString(OGRGeometryH hGeom) -> OGRGeometryH
# Convert to line string.
# ### Parameters
# * **hGeom**: handle to the geometry to convert (ownership surrendered).
# ### Returns
# the converted geometry (ownership to caller).
# """
# function forcetolinestring(arg1::Ptr{OGRGeometryH})
#     checknull(ccall((:OGR_G_ForceToLineString,libgdal),Ptr{OGRGeometryH},(Ptr{OGRGeometryH},),arg1))
# end


# """
#     OGR_G_ForceToMultiPolygon(OGRGeometryH hGeom) -> OGRGeometryH
# Convert to multipolygon.
# ### Parameters
# * **hGeom**: handle to the geometry to convert (ownership surrendered).
# ### Returns
# the converted geometry (ownership to caller).
# """
# function forcetomultipolygon(arg1::Ptr{OGRGeometryH})
#     checknull(ccall((:OGR_G_ForceToMultiPolygon,libgdal),Ptr{OGRGeometryH},(Ptr{OGRGeometryH},),arg1))
# end


# """
#     OGR_G_ForceToMultiPoint(OGRGeometryH hGeom) -> OGRGeometryH
# Convert to multipoint.
# ### Parameters
# * **hGeom**: handle to the geometry to convert (ownership surrendered).
# ### Returns
# the converted geometry (ownership to caller).
# """
# function forcetomultipoint(arg1::Ptr{OGRGeometryH})
#     checknull(ccall((:OGR_G_ForceToMultiPoint,libgdal),Ptr{OGRGeometryH},(Ptr{OGRGeometryH},),arg1))
# end


# """
#     OGR_G_ForceToMultiLineString(OGRGeometryH hGeom) -> OGRGeometryH
# Convert to multilinestring.
# ### Parameters
# * **hGeom**: handle to the geometry to convert (ownership surrendered).
# ### Returns
# the converted geometry (ownership to caller).
# """
# function forcetomultilinestring(arg1::Ptr{OGRGeometryH})
#     checknull(ccall((:OGR_G_ForceToMultiLineString,libgdal),Ptr{OGRGeometryH},(Ptr{OGRGeometryH},),arg1))
# end


"""
    OGR_G_ForceTo(OGRGeometryH hGeom,
                  OGRwkbGeometryType eTargetType,
                  char ** papszOptions) -> OGRGeometryH
Convert to another geometry type.
### Parameters
* **hGeom**: the input geometry - ownership is passed to the method.
* **eTargetType**: target output geometry type.
* **papszOptions**: options as a null-terminated list of strings or NULL.
### Returns
new geometry.
"""
forceto(geom::Geometry, targettype::GDAL.OGRwkbGeometryType) =
    GDAL.forceto(geom.ptr, targettype, C_NULL)

"""
    OGR_G_GetDimension(OGRGeometryH hGeom) -> int
Get the dimension of this geometry.
### Parameters
* **hGeom**: handle on the geometry to get the dimension from.
### Returns
0 for points, 1 for lines and 2 for surfaces.
"""
dimension(geom::Geometry) = GDAL.getdimension(geom.ptr)

"""
    OGR_G_GetCoordinateDimension(OGRGeometryH hGeom) -> int
Get the dimension of the coordinates in this geometry.
### Parameters
* **hGeom**: handle on the geometry to get the dimension of the coordinates from.
### Returns
in practice this will return 2 or 3. It can also return 0 in the case of an empty point.
"""
getcoorddim(geom::Geometry) = GDAL.getcoordinatedimension(geom.ptr)

"""
    OGR_G_SetCoordinateDimension(OGRGeometryH hGeom,
                                 int nNewDimension) -> void
Set the coordinate dimension.
### Parameters
* **hGeom**: handle on the geometry to set the dimension of the coordinates.
* **nNewDimension**: New coordinate dimension value, either 2 or 3.
"""
setcoorddim(geom::Geometry, dim::Integer) =
    GDAL.setcoordinatedimension(geom.ptr, dim)

"""
    OGR_G_Clone(OGRGeometryH hGeom) -> OGRGeometryH
Make a copy of this object.
### Parameters
* **hGeom**: handle on the geometry to clone from.
### Returns
an handle on the copy of the geometry with the spatial reference system as the original.
"""
clone(geom::Geometry) = Geometry(GDAL.clone(geom.ptr))

# """
#     OGR_G_GetEnvelope(OGRGeometryH hGeom,
#                       OGREnvelope * psEnvelope) -> void
# Computes and returns the bounding envelope for this geometry in the passed psEnvelope structure.
# ### Parameters
# * **hGeom**: handle of the geometry to get envelope from.
# * **psEnvelope**: the structure in which to place the results.
# """
# function getenvelope(arg1::Ptr{OGRGeometryH},arg2)
#     ccall((:OGR_G_GetEnvelope,libgdal),Void,(Ptr{OGRGeometryH},Ptr{OGREnvelope}),arg1,arg2)
# end


# """
#     OGR_G_GetEnvelope3D(OGRGeometryH hGeom,
#                         OGREnvelope3D * psEnvelope) -> void
# Computes and returns the bounding envelope (3D) for this geometry in the passed psEnvelope structure.
# ### Parameters
# * **hGeom**: handle of the geometry to get envelope from.
# * **psEnvelope**: the structure in which to place the results.
# """
# function getenvelope3d(arg1::Ptr{OGRGeometryH},arg2)
#     ccall((:OGR_G_GetEnvelope3D,libgdal),Void,(Ptr{OGRGeometryH},Ptr{OGREnvelope3D}),arg1,arg2)
# end


"""
    OGR_G_ImportFromWkb(OGRGeometryH hGeom,
                        unsigned char * pabyData,
                        int nSize) -> OGRErr
Assign geometry from well known binary data.
### Parameters
* **hGeom**: handle on the geometry to assign the well know binary data to.
* **pabyData**: the binary input data.
* **nSize**: the size of pabyData in bytes, or zero if not known.
### Returns
OGRERR_NONE if all goes well, otherwise any of OGRERR_NOT_ENOUGH_DATA, OGRERR_UNSUPPORTED_GEOMETRY_TYPE, or OGRERR_CORRUPT_DATA may be returned.
"""
importWKB(geom::Geometry, data, nsize::Integer = 0) =
    Geometry(GDAL.importfromwkb(geom.ptr, data, nsize))


"""
    OGR_G_ExportToWkb(OGRGeometryH hGeom,
                      OGRwkbByteOrder eOrder,
                      unsigned char * pabyDstBuffer) -> OGRErr
Convert a geometry well known binary format.
### Parameters
* **hGeom**: handle on the geometry to convert to a well know binary data from.
* **eOrder**: One of wkbXDR or wkbNDR indicating MSB or LSB byte order respectively.
* **pabyDstBuffer**: a buffer into which the binary representation is written. This buffer must be at least OGR_G_WkbSize() byte in size.
### Returns
Currently OGRERR_NONE is always returned.
"""
function exportWKB(geom::Geometry, eorder::GDAL.OGRwkbByteOrder = GDAL.wkbNDR)
    buffer = Array(Cuchar, wkbsize(geom))
    GDAL.exporttowkb(geom.ptr, eorder, pointer(buffer))
    buffer
end


"""
    OGR_G_ExportToIsoWkb(OGRGeometryH hGeom,
                         OGRwkbByteOrder eOrder,
                         unsigned char * pabyDstBuffer) -> OGRErr
Convert a geometry into SFSQL 1.2 / ISO SQL/MM Part 3 well known binary format.
### Parameters
* **hGeom**: handle on the geometry to convert to a well know binary data from.
* **eOrder**: One of wkbXDR or wkbNDR indicating MSB or LSB byte order respectively.
* **pabyDstBuffer**: a buffer into which the binary representation is written. This buffer must be at least OGR_G_WkbSize() byte in size.
### Returns
Currently OGRERR_NONE is always returned.
"""
function exportISOWKB(geom::Geometry, eorder::GDAL.OGRwkbByteOrder = GDAL.wkbNDR)
    buffer = Array(Cuchar, wkbsize(geom))
    GDAL.exporttoisowkb(geom.ptr, eorder, pointer(buffer))
    buffer
end

"""
    OGR_G_WkbSize(OGRGeometryH hGeom) -> int
Returns size of related binary representation.
### Parameters
* **hGeom**: handle on the geometry to get the binary size from.
### Returns
size of binary representation in bytes.
"""
wkbsize(geom::Geometry) = GDAL.wkbsize(geom.ptr)

# """
#     OGR_G_ImportFromWkt(OGRGeometryH hGeom,
#                         char ** ppszSrcText) -> OGRErr
# Assign geometry from well known text data.
# ### Parameters
# * **hGeom**: handle on the geometry to assign well know text data to.
# * **ppszSrcText**: pointer to a pointer to the source text. The pointer is updated to pointer after the consumed text.
# ### Returns
# OGRERR_NONE if all goes well, otherwise any of OGRERR_NOT_ENOUGH_DATA, OGRERR_UNSUPPORTED_GEOMETRY_TYPE, or OGRERR_CORRUPT_DATA may be returned.
# """
# function importfromwkt(arg1::Ptr{OGRGeometryH},arg2)
#     ccall((:OGR_G_ImportFromWkt,libgdal),OGRErr,(Ptr{OGRGeometryH},Ptr{Cstring}),arg1,arg2)
# end


# """
#     OGR_G_ExportToWkt(OGRGeometryH hGeom,
#                       char ** ppszSrcText) -> OGRErr
# Convert a geometry into well known text format.
# ### Parameters
# * **hGeom**: handle on the geometry to convert to a text format from.
# * **ppszSrcText**: a text buffer is allocated by the program, and assigned to the passed pointer. After use, *ppszDstText should be freed with OGRFree().
# ### Returns
# Currently OGRERR_NONE is always returned.
# """
# function exporttowkt(arg1::Ptr{OGRGeometryH},arg2)
#     ccall((:OGR_G_ExportToWkt,libgdal),OGRErr,(Ptr{OGRGeometryH},Ptr{Cstring}),arg1,arg2)
# end


# """
#     OGR_G_ExportToIsoWkt(OGRGeometryH hGeom,
#                          char ** ppszSrcText) -> OGRErr
# Convert a geometry into SFSQL 1.2 / ISO SQL/MM Part 3 well known text format.
# ### Parameters
# * **hGeom**: handle on the geometry to convert to a text format from.
# * **ppszSrcText**: a text buffer is allocated by the program, and assigned to the passed pointer. After use, *ppszDstText should be freed with OGRFree().
# ### Returns
# Currently OGRERR_NONE is always returned.
# """
# function exporttoisowkt(arg1::Ptr{OGRGeometryH},arg2)
#     ccall((:OGR_G_ExportToIsoWkt,libgdal),OGRErr,(Ptr{OGRGeometryH},Ptr{Cstring}),arg1,arg2)
# end


"""
    OGR_G_GetGeometryType(OGRGeometryH hGeom) -> OGRwkbGeometryType
Fetch geometry type.
### Parameters
* **hGeom**: handle on the geometry to get type from.
### Returns
the geometry type code.
"""
geomtype(geom::Geometry) = GDAL.getgeometrytype(geom.ptr)

"""
    OGR_G_GetGeometryName(OGRGeometryH hGeom) -> const char *
Fetch WKT name for geometry type.
### Parameters
* **hGeom**: handle on the geometry to get name from.
### Returns
name used for this geometry type in well known text format.
"""
geomname(geom::Geometry) = GDAL.getgeometryname(geom.ptr)

# """
#     OGR_G_DumpReadable(OGRGeometryH hGeom,
#                        FILE * fp,
#                        const char * pszPrefix) -> void
# Dump geometry in well known text format to indicated output file.
# ### Parameters
# * **hGeom**: handle on the geometry to dump.
# * **fp**: the text file to write the geometry to.
# * **pszPrefix**: the prefix to put on each line of output.
# """
# function dumpreadable(arg1::Ptr{OGRGeometryH},arg2,arg3)
#     ccall((:OGR_G_DumpReadable,libgdal),Void,(Ptr{OGRGeometryH},Ptr{FILE},Cstring),arg1,arg2,arg3)
# end


"""
    OGR_G_FlattenTo2D(OGRGeometryH hGeom) -> void
Convert geometry to strictly 2D.
### Parameters
* **hGeom**: handle on the geometry to convert.
"""
flattento2d(geom::Geometry) = GDAL.flattento2d(geom.ptr)

"""
    OGR_G_CloseRings(OGRGeometryH hGeom) -> void
Force rings to be closed.
### Parameters
* **hGeom**: handle to the geometry.
"""
closerings(geom::Geometry) = GDAL.closerings(geom.ptr)

"""
    OGR_G_CreateFromGML(const char * pszGML) -> OGRGeometryH
Create geometry from GML.
### Parameters
* **pszGML**: The GML fragment for the geometry.
### Returns
a geometry on success, or NULL on error.
"""
fromGML(data) = Geometry(GDAL.createfromgml(data))

"""
    OGR_G_ExportToGML(OGRGeometryH hGeometry) -> char *
Convert a geometry into GML format.
### Parameters
* **hGeometry**: handle to the geometry.
### Returns
A GML fragment or NULL in case of error.
"""
exportGML(geom::Geometry) = GDAL.exporttogml(geom.ptr)

# """
#     OGR_G_ExportToGMLEx(OGRGeometryH hGeometry,
#                         char ** papszOptions) -> char *
# Convert a geometry into GML format.
# ### Parameters
# * **hGeometry**: handle to the geometry.
# * **papszOptions**: NULL-terminated list of options.
# ### Returns
# A GML fragment or NULL in case of error.
# """
# function exporttogmlex(arg1::Ptr{OGRGeometryH},papszOptions)
#     bytestring(ccall((:OGR_G_ExportToGMLEx,libgdal),Cstring,(Ptr{OGRGeometryH},Ptr{Cstring}),arg1,papszOptions))
# end


# """
#     OGR_G_CreateFromGMLTree(const CPLXMLNode * psTree) -> OGRGeometryH
# """
# function createfromgmltree(arg1)
#     checknull(ccall((:OGR_G_CreateFromGMLTree,libgdal),Ptr{OGRGeometryH},(Ptr{CPLXMLNode},),arg1))
# end


# """
#     OGR_G_ExportToGMLTree(OGRGeometryH hGeometry) -> CPLXMLNode *
# """
# function exporttogmltree(arg1::Ptr{OGRGeometryH})
#     ccall((:OGR_G_ExportToGMLTree,libgdal),Ptr{CPLXMLNode},(Ptr{OGRGeometryH},),arg1)
# end


# """
#     OGR_G_ExportEnvelopeToGMLTree(OGRGeometryH hGeometry) -> CPLXMLNode *
# """
# function exportenvelopetogmltree(arg1::Ptr{OGRGeometryH})
#     ccall((:OGR_G_ExportEnvelopeToGMLTree,libgdal),Ptr{CPLXMLNode},(Ptr{OGRGeometryH},),arg1)
# end


"""
    OGR_G_ExportToKML(OGRGeometryH hGeometry,
                      const char * pszAltitudeMode) -> char *
Convert a geometry into KML format.
### Parameters
* **hGeometry**: handle to the geometry.
* **pszAltitudeMode**: value to write in altitudeMode element, or NULL.
### Returns
A KML fragment or NULL in case of error.
"""
exportKML(geom::Geometry) = GDAL.exporttokml(geom.ptr, C_NULL)

"""
    OGR_G_ExportToJson(OGRGeometryH hGeometry) -> char *
Convert a geometry into GeoJSON format.
### Parameters
* **hGeometry**: handle to the geometry.
### Returns
A GeoJSON fragment or NULL in case of error.
"""
exportJSON(geom::Geometry) = GDAL.exporttojson(geom.ptr)

# """
#     OGR_G_ExportToJsonEx(OGRGeometryH hGeometry,
#                          char ** papszOptions) -> char *
# Convert a geometry into GeoJSON format.
# ### Parameters
# * **hGeometry**: handle to the geometry.
# * **papszOptions**: a null terminated list of options.
# ### Returns
# A GeoJSON fragment or NULL in case of error.
# """
# function exporttojsonex(arg1::Ptr{OGRGeometryH},papszOptions)
#     bytestring(ccall((:OGR_G_ExportToJsonEx,libgdal),Cstring,(Ptr{OGRGeometryH},Ptr{Cstring}),arg1,papszOptions))
# end


"""
    OGR_G_CreateGeometryFromJson(const char *) -> OGRGeometryH
"""
fromJSON(data) = Geometry(GDAL.creategeometryfromjson(data))

"""
    OGR_G_AssignSpatialReference(OGRGeometryH hGeom,
                                 OGRSpatialReferenceH hSRS) -> void
Assign spatial reference to this object.
### Parameters
* **hGeom**: handle on the geometry to apply the new spatial reference system.
* **hSRS**: handle on the new spatial reference system to apply.
"""
assignspatialref(geom::Geometry, spatialref::SpatialRef) = 
    GDAL.assignspatialreference(geom.ptr, spatialref.ptr)

"""
    OGR_G_GetSpatialReference(OGRGeometryH hGeom) -> OGRSpatialReferenceH
Returns spatial reference system for geometry.
### Parameters
* **hGeom**: handle on the geometry to get spatial reference from.
### Returns
a reference to the spatial reference geometry.
"""
getspatialref(geom::Geometry) = SpatialRef(GDAL.getspatialreference(geom.ptr))

# """
#     OGR_G_Transform(OGRGeometryH hGeom,
#                     OGRCoordinateTransformationH hTransform) -> OGRErr
# Apply arbitrary coordinate transformation to geometry.
# ### Parameters
# * **hGeom**: handle on the geometry to apply the transform to.
# * **hTransform**: handle on the transformation to apply.
# ### Returns
# OGRERR_NONE on success or an error code.
# """
# function transform(arg1::Ptr{OGRGeometryH},arg2::Ptr{OGRCoordinateTransformationH})
#     ccall((:OGR_G_Transform,libgdal),OGRErr,(Ptr{OGRGeometryH},Ptr{OGRCoordinateTransformationH}),arg1,arg2)
# end


"""
    OGR_G_TransformTo(OGRGeometryH hGeom,
                      OGRSpatialReferenceH hSRS) -> OGRErr
Transform geometry to new spatial reference system.
### Parameters
* **hGeom**: handle on the geometry to apply the transform to.
* **hSRS**: handle on the spatial reference system to apply.
### Returns
OGRERR_NONE on success, or an error code.
"""
transformto(geom::Geometry, spatialref::SpatialRef) =
    GDAL.transformto(geom.ptr, spatialref.ptr)

"""
    OGR_G_Simplify(OGRGeometryH hThis,
                   double dTolerance) -> OGRGeometryH
Compute a simplified geometry.
### Parameters
* **hThis**: the geometry.
* **dTolerance**: the distance tolerance for the simplification.
### Returns
the simplified geometry or NULL if an error occurs.
"""
simplify(geom::Geometry, tol::Real) = Geometry(GDAL.simplify(geom.ptr, tol))

"""
    OGR_G_SimplifyPreserveTopology(OGRGeometryH hThis,
                                   double dTolerance) -> OGRGeometryH
Simplify the geometry while preserving topology.
### Parameters
* **hThis**: the geometry.
* **dTolerance**: the distance tolerance for the simplification.
### Returns
the simplified geometry or NULL if an error occurs.
"""
simplifypreservetopology(geom::Geometry, tol::Real) =
    Geometry(GDAL.simplifypreservetopology(geom.ptr, tol))

"""
    OGR_G_DelaunayTriangulation(OGRGeometryH hThis,
                                double dfTolerance,
                                int bOnlyEdges) -> OGRGeometryH
Return a Delaunay triangulation of the vertices of the geometry.
### Parameters
* **hThis**: the geometry.
* **dfTolerance**: optional snapping tolerance to use for improved robustness
* **bOnlyEdges**: if TRUE, will return a MULTILINESTRING, otherwise it will return a GEOMETRYCOLLECTION containing triangular POLYGONs.
### Returns
the geometry resulting from the Delaunay triangulation or NULL if an error occurs.
"""
delaunaytriangulation(geom::Geometry, tol::Real, onlyedges::Bool) =
    Geometry(GDAL.delaunaytriangulation(geom.ptr, tol, onlyedges))

"""
    OGR_G_Segmentize(OGRGeometryH hGeom,
                     double dfMaxLength) -> void
Modify the geometry such it has no segment longer then the given distance.
### Parameters
* **hGeom**: handle on the geometry to segmentize
* **dfMaxLength**: the maximum distance between 2 points after segmentization
"""
segmentize(geom::Geometry, maxlength::Real) =
    GDAL.segmentize(geom.ptr, maxlength)

"""
    OGR_G_Intersects(OGRGeometryH hGeom,
                     OGRGeometryH hOtherGeom) -> int
Do these features intersect?
### Parameters
* **hGeom**: handle on the first geometry.
* **hOtherGeom**: handle on the other geometry to test against.
### Returns
TRUE if the geometries intersect, otherwise FALSE.
"""
intersects(geom1::Geometry, geom2::Geometry) =
    Bool(GDAL.intersects(geom1.ptr, geom2.ptr))

"""
    OGR_G_Equals(OGRGeometryH hGeom,
                 OGRGeometryH hOther) -> int
Returns TRUE if two geometries are equivalent.
### Parameters
* **hGeom**: handle on the first geometry.
* **hOther**: handle on the other geometry to test against.
### Returns
TRUE if equivalent or FALSE otherwise.
"""
equals(geom1::Geometry, geom2::Geometry) =
    Bool(GDAL.equals(geom1.ptr, geom2.ptr))

"""
    OGR_G_Disjoint(OGRGeometryH hThis,
                   OGRGeometryH hOther) -> int
Test for disjointness.
### Parameters
* **hThis**: the geometry to compare.
* **hOther**: the other geometry to compare.
### Returns
TRUE if they are disjoint, otherwise FALSE.
"""
disjoint(geom1::Geometry, geom2::Geometry) =
    Bool(GDAL.disjoint(geom1.ptr, geom2.ptr))

"""
    OGR_G_Touches(OGRGeometryH hThis,
                  OGRGeometryH hOther) -> int
Test for touching.
### Parameters
* **hThis**: the geometry to compare.
* **hOther**: the other geometry to compare.
### Returns
TRUE if they are touching, otherwise FALSE.
"""
touches(geom1::Geometry, geom2::Geometry) =
    Bool(GDAL.touches(geom1.ptr, geom2.ptr))

"""
    OGR_G_Crosses(OGRGeometryH hThis,
                  OGRGeometryH hOther) -> int
Test for crossing.
### Parameters
* **hThis**: the geometry to compare.
* **hOther**: the other geometry to compare.
### Returns
TRUE if they are crossing, otherwise FALSE.
"""
crosses(geom1::Geometry, geom2::Geometry) =
    Bool(GDAL.crosses(geom1.ptr, geom2.ptr))

"""
    OGR_G_Within(OGRGeometryH hThis,
                 OGRGeometryH hOther) -> int
Test for containment.
### Parameters
* **hThis**: the geometry to compare.
* **hOther**: the other geometry to compare.
### Returns
TRUE if hThis is within hOther, otherwise FALSE.
"""
within(geom1::Geometry, geom2::Geometry) =
    Bool(GDAL.within(geom1.ptr, geom2.ptr))

"""
    OGR_G_Contains(OGRGeometryH hThis,
                   OGRGeometryH hOther) -> int
Test for containment.
### Parameters
* **hThis**: the geometry to compare.
* **hOther**: the other geometry to compare.
### Returns
TRUE if hThis contains hOther geometry, otherwise FALSE.
"""
contains(geom1::Geometry, geom2::Geometry) =
    Bool(GDAL.contains(geom1.ptr, geom2.ptr))

"""
    OGR_G_Overlaps(OGRGeometryH hThis,
                   OGRGeometryH hOther) -> int
Test for overlap.
### Parameters
* **hThis**: the geometry to compare.
* **hOther**: the other geometry to compare.
### Returns
TRUE if they are overlapping, otherwise FALSE.
"""
overlaps(geom1::Geometry, geom2::Geometry) =
    Bool(GDAL.overlaps(geom1.ptr, geom2.ptr))

"""
    OGR_G_Boundary(OGRGeometryH hTarget) -> OGRGeometryH
Compute boundary.
### Parameters
* **hTarget**: The Geometry to calculate the boundary of.
### Returns
a handle to a newly allocated geometry now owned by the caller, or NULL on failure.
"""
boundary(geom1::Geometry, geom2::Geometry) =
    Bool(GDAL.boundary(geom1.ptr, geom2.ptr))

"""
    OGR_G_ConvexHull(OGRGeometryH hTarget) -> OGRGeometryH
Compute convex hull.
### Parameters
* **hTarget**: The Geometry to calculate the convex hull of.
### Returns
a handle to a newly allocated geometry now owned by the caller, or NULL on failure.
"""
convexhull(geom::Geometry) = Geometry(GDAL.convexhull(geom.ptr))

"""
    OGR_G_Buffer(OGRGeometryH hTarget,
                 double dfDist,
                 int nQuadSegs) -> OGRGeometryH
Compute buffer of geometry.
### Parameters
* **hTarget**: the geometry.
* **dfDist**: the buffer distance to be applied. Should be expressed into the same unit as the coordinates of the geometry.
* **nQuadSegs**: the number of segments used to approximate a 90 degree (quadrant) of curvature.
### Returns
the newly created geometry, or NULL if an error occurs.
"""
buffer(geom::Geometry, dist::Real, quadsegs::Integer) = Geometry(GDAL.buffer(geom, dist, quadsegs))

"""
    OGR_G_Intersection(OGRGeometryH hThis,
                       OGRGeometryH hOther) -> OGRGeometryH
Compute intersection.
### Parameters
* **hThis**: the geometry.
* **hOther**: the other geometry.
### Returns
a new geometry representing the intersection or NULL if there is no intersection or an error occurs.
"""
intersection(geom1::Geometry, geom2::Geometry) =
    Geometry(GDAL.intersection(geom1.ptr, geom2.ptr))

"""
    OGR_G_Union(OGRGeometryH hThis,
                OGRGeometryH hOther) -> OGRGeometryH
Compute union.
### Parameters
* **hThis**: the geometry.
* **hOther**: the other geometry.
### Returns
a new geometry representing the union or NULL if an error occurs.
"""
union(geom1::Geometry, geom2::Geometry) =
    Geometry(GDAL.union(geom1.ptr, geom2.ptr))

"""
    OGR_G_UnionCascaded(OGRGeometryH hThis) -> OGRGeometryH
Compute union using cascading.
### Parameters
* **hThis**: the geometry.
### Returns
a new geometry representing the union or NULL if an error occurs.
"""
unioncascaded(geom::Geometry) = Geometry(GDAL.unioncascaded(geom.ptr))

"""
    OGR_G_PointOnSurface(OGRGeometryH hGeom) -> OGRGeometryH
Returns a point guaranteed to lie on the surface.
### Parameters
* **hGeom**: the geometry to operate on.
### Returns
a point guaranteed to lie on the surface or NULL if an error occurred.
"""
pointonsurface(geom::Geometry) = Geometry(GDAL.pointonsurface(geom.ptr))

"""
    OGR_G_Difference(OGRGeometryH hThis,
                     OGRGeometryH hOther) -> OGRGeometryH
Compute difference.
### Parameters
* **hThis**: the geometry.
* **hOther**: the other geometry.
### Returns
a new geometry representing the difference or NULL if the difference is empty or an error occurs.
"""
difference(geom1::Geometry, geom2::Geometry) =
    Geometry(GDAL.difference(geom1.ptr, geom2.ptr))

"""
    OGR_G_SymDifference(OGRGeometryH hThis,
                        OGRGeometryH hOther) -> OGRGeometryH
Compute symmetric difference.
### Parameters
* **hThis**: the geometry.
* **hOther**: the other geometry.
### Returns
a new geometry representing the symmetric difference or NULL if the difference is empty or an error occurs.
"""
symdifference(geom1::Geometry, geom2::Geometry) =
    Geometry(GDAL.symdifference(geom1.ptr, geom2.ptr))

"""
    OGR_G_Distance(OGRGeometryH hFirst,
                   OGRGeometryH hOther) -> double
Compute distance between two geometries.
### Parameters
* **hFirst**: the first geometry to compare against.
* **hOther**: the other geometry to compare against.
### Returns
the distance between the geometries or -1 if an error occurs.
"""
distance(geom1::Geometry, geom2::Geometry) = GDAL.distance(geom1.ptr, geom2.ptr)

"""
    OGR_G_Length(OGRGeometryH hGeom) -> double
Compute length of a geometry.
### Parameters
* **hGeom**: the geometry to operate on.
### Returns
the length or 0.0 for unsupported geometry types.
"""
geomlength(geom::Geometry) = GDAL.length(geom.ptr)

"""
    OGR_G_Area(OGRGeometryH hGeom) -> double
Compute geometry area.
### Parameters
* **hGeom**: the geometry to operate on.
### Returns
the area or 0.0 for unsupported geometry types.
"""
geomarea(geom::Geometry) = GDAL.area(geom.ptr)

"""
    OGR_G_Centroid(OGRGeometryH hGeom,
                   OGRGeometryH hCentroidPoint) -> int
Compute the geometry centroid.
### Returns
OGRERR_NONE on success or OGRERR_FAILURE on error.
"""
centroid!(geom::Geometry, centroid::Geometry) =
    GDAL.centroid(geom.ptr, centroid.ptr)

"""
    OGR_G_Value(OGRGeometryH hGeom,
                double dfDistance) -> OGRGeometryH
Fetch point at given distance along curve.
### Parameters
* **hGeom**: curve geometry.
* **dfDistance**: distance along the curve at which to sample position. This distance should be between zero and get_Length() for this curve.
### Returns
a point or NULL.
"""
pointalongline(line::Geometry, distance::Real) = Geometry(GDAL.value(line.ptr, distance))

"""
    OGR_G_Empty(OGRGeometryH hGeom) -> void
Clear geometry information.
### Parameters
* **hGeom**: handle on the geometry to empty.
"""
empty!(geom::Geometry) = GDAL.empty(geom.ptr)

"""
    OGR_G_IsEmpty(OGRGeometryH hGeom) -> int
Test if the geometry is empty.
### Parameters
* **hGeom**: The Geometry to test.
### Returns
TRUE if the geometry has no points, otherwise FALSE.
"""
isempty(geom::Geometry) = Bool(GDAL.isempty(geom.ptr))

"""
    OGR_G_IsValid(OGRGeometryH hGeom) -> int
Test if the geometry is valid.
### Parameters
* **hGeom**: The Geometry to test.
### Returns
TRUE if the geometry has no points, otherwise FALSE.
"""
isvalid(geom::Geometry) = Bool(GDAL.isvalid(geom.ptr))

"""
    OGR_G_IsSimple(OGRGeometryH hGeom) -> int
Returns TRUE if the geometry is simple.
### Parameters
* **hGeom**: The Geometry to test.
### Returns
TRUE if object is simple, otherwise FALSE.
"""
issimple(geom::Geometry) = Bool(GDAL.issimple(geom.ptr))

"""
    OGR_G_IsRing(OGRGeometryH hGeom) -> int
Test if the geometry is a ring.
### Parameters
* **hGeom**: The Geometry to test.
### Returns
TRUE if the geometry has no points, otherwise FALSE.
"""
isring(geom::Geometry) = Bool(GDAL.isring(geom.ptr))

"""
    OGR_G_Polygonize(OGRGeometryH hTarget) -> OGRGeometryH
Polygonizes a set of sparse edges.
### Parameters
* **hTarget**: The Geometry to be polygonized.
### Returns
a handle to a newly allocated geometry now owned by the caller, or NULL on failure.
"""
polygonize(geom::Geometry) = Geometry(GDAL.polygonize(geom.ptr))

"""
    OGR_G_Equal(OGRGeometryH hGeom,
                OGRGeometryH hOther) -> int
"""
equal(geom1::Geometry, geom2::Geometry) =
    Bool(GDAL.equal(geom1.ptr, geom2.ptr))

"""
    OGR_G_GetPointCount(OGRGeometryH hGeom) -> int
Fetch number of points from a geometry.
### Parameters
* **hGeom**: handle to the geometry from which to get the number of points.
### Returns
the number of points.
"""
npoint(geom::Geometry) = GDAL.getpointcount(geom.ptr)

# """
#     OGR_G_GetPoints(OGRGeometryH hGeom,
#                     void * pabyX,
#                     int nXStride,
#                     void * pabyY,
#                     int nYStride,
#                     void * pabyZ,
#                     int nZStride) -> int
# Returns all points of line string.
# ### Parameters
# * **hGeom**: handle to the geometry from which to get the coordinates.
# * **pabyX**: a buffer of at least (sizeof(double) * nXStride * nPointCount) bytes, may be NULL.
# * **nXStride**: the number of bytes between 2 elements of pabyX.
# * **pabyY**: a buffer of at least (sizeof(double) * nYStride * nPointCount) bytes, may be NULL.
# * **nYStride**: the number of bytes between 2 elements of pabyY.
# * **pabyZ**: a buffer of at last size (sizeof(double) * nZStride * nPointCount) bytes, may be NULL.
# * **nZStride**: the number of bytes between 2 elements of pabyZ.
# ### Returns
# the number of points
# """
# function getpoints(hGeom::Ptr{OGRGeometryH},pabyX,nXStride::Integer,pabyY,nYStride::Integer,pabyZ,nZStride::Integer)
#     ccall((:OGR_G_GetPoints,libgdal),Cint,(Ptr{OGRGeometryH},Ptr{Void},Cint,Ptr{Void},Cint,Ptr{Void},Cint),hGeom,pabyX,nXStride,pabyY,nYStride,pabyZ,nZStride)
# end


"""
    OGR_G_GetX(OGRGeometryH hGeom,
               int i) -> double
Fetch the x coordinate of a point from a geometry.
### Parameters
* **hGeom**: handle to the geometry from which to get the x coordinate.
* **i**: point to get the x coordinate.
### Returns
the X coordinate of this point.
"""
getx(geom::Geometry, i::Integer) = GDAL.getx(geom.ptr, i)

"""
    OGR_G_GetY(OGRGeometryH hGeom,
               int i) -> double
Fetch the x coordinate of a point from a geometry.
### Parameters
* **hGeom**: handle to the geometry from which to get the y coordinate.
* **i**: point to get the Y coordinate.
### Returns
the Y coordinate of this point.
"""
gety(geom::Geometry, i::Integer) = GDAL.gety(geom.ptr, i)

"""
    OGR_G_GetZ(OGRGeometryH hGeom,
               int i) -> double
Fetch the z coordinate of a point from a geometry.
### Parameters
* **hGeom**: handle to the geometry from which to get the Z coordinate.
* **i**: point to get the Z coordinate.
### Returns
the Z coordinate of this point.
"""
getz(geom::Geometry, i::Integer) = GDAL.getz(geom.ptr, i)

"""
    OGR_G_GetPoint(OGRGeometryH hGeom,
                   int i,
                   double * pdfX,
                   double * pdfY,
                   double * pdfZ) -> void
Fetch a point in line string or a point geometry.
### Parameters
* **hGeom**: handle to the geometry from which to get the coordinates.
* **i**: the vertex to fetch, from 0 to getNumPoints()-1, zero for a point.
* **pdfX**: value of x coordinate.
* **pdfY**: value of y coordinate.
* **pdfZ**: value of z coordinate.
"""
getpoint!(geom::Geometry, i::Integer, x, y, z) = GDAL.getpoint(geom.ptr, i, x, y, z)

function getpoint(geom::Geometry, i::Integer)
    x = Ref{Cdouble}()
    y = Ref{Cdouble}()
    z = Ref{Cdouble}()
    getpoint!(geom, i, x, y, z)
    (x[], y[], z[])
end

"""
    OGR_G_SetPointCount(OGRGeometryH hGeom,
                        int nNewPointCount) -> void
Set number of points in a geometry.
### Parameters
* **hGeom**: handle to the geometry.
* **nNewPointCount**: the new number of points for geometry.
"""
setpointcount(geom::Geometry, n::Integer) = GDAL.setpointcount(geom.ptr, n)

"""
    OGR_G_SetPoint(OGRGeometryH hGeom,
                   int i,
                   double dfX,
                   double dfY,
                   double dfZ) -> void
Set the location of a vertex in a point or linestring geometry.
### Parameters
* **hGeom**: handle to the geometry to add a vertex to.
* **i**: the index of the vertex to assign (zero based) or zero for a point.
* **dfX**: input X coordinate to assign.
* **dfY**: input Y coordinate to assign.
* **dfZ**: input Z coordinate to assign (defaults to zero).
"""
setpoint(geom::Geometry, i::Integer, x, y, z) = GDAL.setpoint(geom.ptr, i, x, y, z)

"""
    OGR_G_SetPoint_2D(OGRGeometryH hGeom,
                      int i,
                      double dfX,
                      double dfY) -> void
Set the location of a vertex in a point or linestring geometry.
### Parameters
* **hGeom**: handle to the geometry to add a vertex to.
* **i**: the index of the vertex to assign (zero based) or zero for a point.
* **dfX**: input X coordinate to assign.
* **dfY**: input Y coordinate to assign.
"""
setpoint(geom::Geometry, i::Integer, x, y) = GDAL.setpoint_2d(geom.ptr, i, x, y)

"""
    OGR_G_AddPoint(OGRGeometryH hGeom,
                   double dfX,
                   double dfY,
                   double dfZ) -> void
Add a point to a geometry (line string or point).
### Parameters
* **hGeom**: handle to the geometry to add a point to.
* **dfX**: x coordinate of point to add.
* **dfY**: y coordinate of point to add.
* **dfZ**: z coordinate of point to add.
"""
addpoint(geom::Geometry, x, y, z) = GDAL.addpoint(geom.ptr, i, x, y, z)

"""
    OGR_G_AddPoint_2D(OGRGeometryH hGeom,
                      double dfX,
                      double dfY) -> void
Add a point to a geometry (line string or point).
### Parameters
* **hGeom**: handle to the geometry to add a point to.
* **dfX**: x coordinate of point to add.
* **dfY**: y coordinate of point to add.
"""
addpoint(geom::Geometry, x, y, z) = GDAL.addpoint_2d(geom.ptr, i, x, y)

# """
#     OGR_G_SetPoints(OGRGeometryH hGeom,
#                     int nPointsIn,
#                     void * pabyX,
#                     int nXStride,
#                     void * pabyY,
#                     int nYStride,
#                     void * pabyZ,
#                     int nZStride) -> void
# Assign all points in a point or a line string geometry.
# ### Parameters
# * **hGeom**: handle to the geometry to set the coordinates.
# * **nPointsIn**: number of points being passed in padfX and padfY.
# * **pabyX**: list of X coordinates (double values) of points being assigned.
# * **nXStride**: the number of bytes between 2 elements of pabyX.
# * **pabyY**: list of Y coordinates (double values) of points being assigned.
# * **nYStride**: the number of bytes between 2 elements of pabyY.
# * **pabyZ**: list of Z coordinates (double values) of points being assigned (defaults to NULL for 2D objects).
# * **nZStride**: the number of bytes between 2 elements of pabyZ.
# """
# function setpoints(hGeom::Ptr{OGRGeometryH},nPointsIn::Integer,pabyX,nXStride::Integer,pabyY,nYStride::Integer,pabyZ,nZStride::Integer)
#     ccall((:OGR_G_SetPoints,libgdal),Void,(Ptr{OGRGeometryH},Cint,Ptr{Void},Cint,Ptr{Void},Cint,Ptr{Void},Cint),hGeom,nPointsIn,pabyX,nXStride,pabyY,nYStride,pabyZ,nZStride)
# end


"""
    OGR_G_GetGeometryCount(OGRGeometryH hGeom) -> int
Fetch the number of elements in a geometry or number of geometries in container.
### Parameters
* **hGeom**: single geometry or geometry container from which to get the number of elements.
### Returns
the number of elements.
"""
ngeometry(geom::Geometry) = GDAL.getgeometrycount(geom.ptr)

"""
    OGR_G_GetGeometryRef(OGRGeometryH hGeom,
                         int iSubGeom) -> OGRGeometryH
Fetch geometry from a geometry container.
### Parameters
* **hGeom**: handle to the geometry container from which to get a geometry from.
* **iSubGeom**: the index of the geometry to fetch, between 0 and getNumGeometries() - 1.
### Returns
handle to the requested geometry.
"""
fetchgeom(geom::Geometry, i::Integer) = Geometry(GDAL.getgeometryref(geom.ptr, i))

"""
    OGR_G_AddGeometry(OGRGeometryH hGeom,
                      OGRGeometryH hNewSubGeom) -> OGRErr
Add a geometry to a geometry container.
### Parameters
* **hGeom**: existing geometry container.
* **hNewSubGeom**: geometry to add to the container.
### Returns
OGRERR_NONE if successful, or OGRERR_UNSUPPORTED_GEOMETRY_TYPE if the geometry type is illegal for the type of existing geometry.
"""
addgeom(geom::Geometry, subgeom::Geometry) = GDAL.addgeometry(geom.ptr, subgeom.ptr)

"""
    OGR_G_AddGeometryDirectly(OGRGeometryH hGeom,
                              OGRGeometryH hNewSubGeom) -> OGRErr
Add a geometry directly to an existing geometry container.
### Parameters
* **hGeom**: existing geometry.
* **hNewSubGeom**: geometry to add to the existing geometry.
### Returns
OGRERR_NONE if successful, or OGRERR_UNSUPPORTED_GEOMETRY_TYPE if the geometry type is illegal for the type of geometry container.
"""
addgeomdirectly(geom::Geometry, subgeom::Geometry) = GDAL.addgeometrydirectly(geom.ptr, subgeom.ptr)

"""
    OGR_G_RemoveGeometry(OGRGeometryH hGeom,
                         int iGeom,
                         int bDelete) -> OGRErr
Remove a geometry from an exiting geometry container.
### Parameters
* **hGeom**: the existing geometry to delete from.
* **iGeom**: the index of the geometry to delete. A value of -1 is a special flag meaning that all geometries should be removed.
* **bDelete**: if TRUE the geometry will be destroyed, otherwise it will not. The default is TRUE as the existing geometry is considered to own the geometries in it.
### Returns
OGRERR_NONE if successful, or OGRERR_FAILURE if the index is out of range.
"""
removegeom(geom::Geometry, i::Integer, delete::Bool) =
    GDAL.removegeometry(geom.ptr, i, delete)

"""
    OGR_G_HasCurveGeometry(OGRGeometryH hGeom,
                           int bLookForNonLinear) -> int
Returns if this geometry is or has curve geometry.
### Parameters
* **hGeom**: the geometry to operate on.
* **bLookForNonLinear**: set it to TRUE to check if the geometry is or contains a CIRCULARSTRING.
### Returns
TRUE if this geometry is or has curve geometry.
"""
hascurvegeom(geom::Geometry, nonlinear::Bool) = GDAL.hascurvegeometry(geom.ptr, nonlinear)

"""
    OGR_G_GetLinearGeometry(OGRGeometryH hGeom,
                            double dfMaxAngleStepSizeDegrees,
                            char ** papszOptions) -> OGRGeometryH
Return, possibly approximate, linear version of this geometry.
### Parameters
* **hGeom**: the geometry to operate on.
* **dfMaxAngleStepSizeDegrees**: the largest step in degrees along the arc, zero to use the default setting.
* **papszOptions**: options as a null-terminated list of strings or NULL. See OGRGeometryFactory::curveToLineString() for valid options.
### Returns
a new geometry.
"""
lineargeom(geom::Geometry, stepsize::Real=0.0) = 
    Geometry(GDAL.getlineargeometry(geom.ptr, stepsize, C_NULL))

"""
    OGR_G_GetCurveGeometry(OGRGeometryH hGeom,
                           char ** papszOptions) -> OGRGeometryH
Return curve version of this geometry.
### Parameters
* **hGeom**: the geometry to operate on.
* **papszOptions**: options as a null-terminated list of strings. Unused for now. Must be set to NULL.
### Returns
a new geometry.
"""
curvegeom(geom::Geometry) = Geometry(GDAL.getcurvegeometry(geom.ptr, C_NULL))

"""
    OGRBuildPolygonFromEdges(OGRGeometryH hLines,
                             int bBestEffort,
                             int bAutoClose,
                             double dfTolerance,
                             OGRErr * peErr) -> OGRGeometryH
Build a ring from a bunch of arcs.
### Parameters
* **hLines**: handle to an OGRGeometryCollection (or OGRMultiLineString) containing the line string geometries to be built into rings.
* **bBestEffort**: not yet implemented???.
* **bAutoClose**: indicates if the ring should be close when first and last points of the ring are the same.
* **dfTolerance**: tolerance into which two arcs are considered close enough to be joined.
* **peErr**: OGRERR_NONE on success, or OGRERR_FAILURE on failure.
### Returns
an handle to the new geometry, a polygon.
"""
polygonfromedges(lines::Geometry, besteffort::Bool, autoclose::Bool, tol::Real) =
    Geometry(GDAL.buildpolygonfromedges(lines.ptr, besteffort, autoclose, tol))
