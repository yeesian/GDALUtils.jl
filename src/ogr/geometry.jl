"""
Create a geometry object of the appropriate type from it's well known
binary (WKB) representation.

### Parameters
* **pabyData**: pointer to the input BLOB data.
* **hSRS**: handle to the spatial reference to be assigned to the created
    geometry object. This may be `NULL`.
* **phGeometry**: the newly created geometry object will be assigned to 
    the indicated handle on return. This will be NULL in case of failure.
    If not NULL, *phGeometry should be freed with OGR_G_DestroyGeometry()
    after use.
* **nBytes**: the number of bytes of data available in pabyData, or -1 if
    it is not known, but assumed to be sufficient.
### Returns
OGRERR_NONE if all goes well, otherwise any of OGRERR_NOT_ENOUGH_DATA,
OGRERR_UNSUPPORTED_GEOMETRY_TYPE, or OGRERR_CORRUPT_DATA may be returned.
"""
function fromWKB(data)
    geom = Ptr{GDAL.OGRGeometryH}(0)
    result = GDAL.createfromwkb(data, C_NULL, geom, -1)
    if result != GDAL.OGRERR_NONE
        error("Failed to create geometry from WKB")
    end
    Geometry(geom)
end

function fromWKB(data, spatialref::SpatialRef)
    geom = Ptr{GDAL.OGRGeometryH}(0)
    result = GDAL.createfromwkb(data, spatialref.ptr, geom, -1)
    if result != GDAL.OGRERR_NONE
        error("Failed to create geometry from WKB")
    end
    Geometry(geom)
end

"""
Create a geometry object of the appropriate type from it's well known text
(WKT) representation.

### Parameters
* **ppszData**: input zero terminated string containing WKT representation
    of the geometry to be created. The pointer is updated to point just beyond
    that last character consumed.
* **hSRS**: handle to the spatial reference to be assigned to the created
    geometry object. This may be `NULL`.
* **phGeometry**: the newly created geometry object will be assigned to the
    indicated handle on return. This will be NULL if the method fails. If not
    `NULL`, *phGeometry should be freed with OGR_G_DestroyGeometry() after use.

### Returns
OGRERR_NONE if all goes well, otherwise any of OGRERR_NOT_ENOUGH_DATA,
OGRERR_UNSUPPORTED_GEOMETRY_TYPE, or OGRERR_CORRUPT_DATA may be returned.
"""
function fromWKT(data)
    geom = Ptr{GDAL.OGRGeometryH}(0)
    result = GDAL.createfromwkt(data, C_NULL, geom)
    if result != GDAL.OGRERR_NONE
        error("Failed to create geometry from WKT")
    end
    Geometry(geom)
end

function fromWKT(data, spatialref::SpatialRef)
    geom = Ptr{GDAL.OGRGeometryH}(0)
    result = GDAL.createfromwkt(data, spatialref.ptr, geom)
    if result != GDAL.OGRERR_NONE
        error("Failed to create geometry from WKT")
    end
    Geometry(geom)
end

#"""
#     OGR_G_CreateFromFgf(unsigned char * pabyData,
#                         OGRSpatialReferenceH hSRS,
#                         OGRGeometryH * phGeometry,
#                         int nBytes,
#                         int * pnBytesConsumed) -> OGRErr
# """
# function createfromfgf(arg1,arg2::Ptr{OGRSpatialReferenceH},
#     arg3,arg4::Integer,arg5)
#     ccall((:OGR_G_CreateFromFgf,libgdal),OGRErr,(Ptr{Cuchar},
# Ptr{OGRSpatialReferenceH},Ptr{OGRGeometryH},Cint,Ptr{Cint}),
# arg1,arg2,arg3,arg4,arg5)
# end


"Destroy geometry object."
function destroy(geom::Geometry)
    GDAL.destroygeometry(geom.ptr)
    nullify(geom)
end


"Create an empty geometry of desired type."
creategeom(geomtype::GDAL.OGRwkbGeometryType) =
    Geometry(GDAL.creategeometry(geomtype))

function creategeom(f::Function, args...)
    geom = creategeom(args...)
    try
        f(geom)
    finally
        destroy(geom)
    end
end

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
Convert to another geometry type.

### Parameters
* **hGeom**: the input geometry - ownership is passed to the method.
* **eTargetType**: target output geometry type.
* **papszOptions**: options as a null-terminated list of strings or NULL.
"""
forceto(geom::Geometry, targettype::GDAL.OGRwkbGeometryType) =
    GDAL.forceto(geom.ptr, targettype, C_NULL)

"""
Get the dimension of this geometry.

### Returns
0 for points, 1 for lines and 2 for surfaces.
"""
getdimension(geom::Geometry) = GDAL.getdimension(geom.ptr)

"""
Get the dimension of the coordinates in this geometry.

### Returns
in practice this will return 2 or 3. It can also return 0 in the case of
an empty point.
"""
getcoorddim(geom::Geometry) = GDAL.getcoordinatedimension(geom.ptr)

"Set the coordinate dimension."
setcoorddim(geom::Geometry, dim::Integer) =
    GDAL.setcoordinatedimension(geom.ptr, dim)

"Make a copy of this object, with the spatial reference of the original."
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
Assign geometry from well known binary data.

### Parameters
* **hGeom**: handle on the geometry to assign the well know binary data to.
* **pabyData**: the binary input data.
* **nSize**: the size of pabyData in bytes, or zero if not known.

### Returns
OGRERR_NONE if all goes well, otherwise any of OGRERR_NOT_ENOUGH_DATA,
OGRERR_UNSUPPORTED_GEOMETRY_TYPE, or OGRERR_CORRUPT_DATA may be returned.
"""
function fromWKB(data, nsize::Integer = 0)
    geom_ptr = Ptr{GDAL.OGRGeometryH}()
    result = GDAL.importfromwkb(geom_ptr, data, nsize)
    if result != OGRERR_NONE
        error("Failed to import geometry from WKB")
    end
    Geometry(geom_ptr)
end


"""
Convert a geometry well known binary format.

### Parameters
* **hGeom**: handle on the geometry to convert to a well know binary data from.
* **eOrder**: One of wkbXDR or [wkbNDR] indicating MSB or LSB byte order resp.
* **pabyDstBuffer**: a buffer into which the binary representation is written.
    This buffer must be at least OGR_G_WkbSize() byte in size.
### Returns
Currently OGRERR_NONE is always returned.
"""
function toWKB(geom::Geometry, eorder::GDAL.OGRwkbByteOrder = GDAL.wkbNDR)
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
* **eOrder**: One of wkbXDR or [wkbNDR] indicating MSB or LSB byte order resp.
* **pabyDstBuffer**: a buffer into which the binary representation is written.
    This buffer must be at least OGR_G_WkbSize() byte in size.
### Returns
Currently OGRERR_NONE is always returned.
"""
function toISOWKB(geom::Geometry, eorder::GDAL.OGRwkbByteOrder = GDAL.wkbNDR)
    buffer = Array(Cuchar, wkbsize(geom))
    GDAL.exporttoisowkb(geom.ptr, eorder, pointer(buffer))
    buffer
end

"Returns size (in bytes) of related binary representation."
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


"Fetch geometry type code"
getgeomtype(geom::Geometry) = GDAL.getgeometrytype(geom.ptr)

"Fetch WKT name for geometry type."
getgeomname(geom::Geometry) = GDAL.getgeometryname(geom.ptr)

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


"Convert geometry to strictly 2D."
flattento2d(geom::Geometry) = GDAL.flattento2d(geom.ptr)

"Force rings to be closed."
closerings(geom::Geometry) = GDAL.closerings(geom.ptr)

"Create geometry from GML."
fromGML(data) = Geometry(GDAL.createfromgml(data))

"Convert a geometry into GML format."
toGML(geom::Geometry) = GDAL.exporttogml(geom.ptr)

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
Convert a geometry into KML format.

### Parameters
* **geom**: the geometry to be converted.
* **altitudemode**: value to write in altitudeMode element, or NULL.
"""
toKML(geom::Geometry) = GDAL.exporttokml(geom.ptr, C_NULL)
toKML(geom::Geometry, altitudemode) = GDAL.exporttokml(geom.ptr, altitude)

"Convert a geometry into GeoJSON format."
toJSON(geom::Geometry) = GDAL.exporttojson(geom.ptr)

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


"""Create a geometry object of the appropriate type from its
GeoJSON representation"""
fromJSON(data) = Geometry(GDAL.creategeometryfromjson(data))

"Assign spatial reference to this object."
setspatialref(geom::Geometry, spatialref::SpatialRef) = 
    GDAL.assignspatialreference(geom.ptr, spatialref.ptr)

"Returns spatial reference system for geometry."
getspatialref(geom::Geometry) = SpatialRef(GDAL.getspatialreference(geom.ptr))

"""
    OGR_G_Transform(OGRGeometryH hGeom,
                    OGRCoordinateTransformationH hTransform) -> OGRErr
Apply arbitrary coordinate transformation to geometry.

### Parameters
* **hGeom**: handle on the geometry to apply the transform to.
* **hTransform**: handle on the transformation to apply.

### Returns
OGRERR_NONE on success or an error code.
"""
function transform(geom::Geometry, coordtransform::CoordTransform)
    result = GDAL.transform(geom.ptr, coordtransform.ptr)
    if result != GDAL.OGRERR_NONE
        error("Failed to transform geometry")
    end
    geom
end


"Transform geometry to new spatial reference system."
function transformto(geom::Geometry, spatialref::SpatialRef)
    result = GDAL.transformto(geom.ptr, spatialref.ptr)
    if result != GDAL.OGRERR_NONE
        error("Failed to transform geometry to the new SRS")
    end
end

"""
Compute a simplified geometry.

### Parameters
* **geom**: the geometry.
* **tol**: the distance tolerance for the simplification.
"""
simplify(geom::Geometry, tol::Real) = Geometry(GDAL.simplify(geom.ptr, tol))

"""
Simplify the geometry while preserving topology.

### Parameters
* **geom**: the geometry.
* **tol**: the distance tolerance for the simplification.
"""
simplifypreservetopology(geom::Geometry, tol::Real) =
    Geometry(GDAL.simplifypreservetopology(geom.ptr, tol))

"""
Return a Delaunay triangulation of the vertices of the geometry.

### Parameters
* **geom**: the geometry.
* **tol**: optional snapping tolerance to use for improved robustness
* **onlyedges**: if TRUE, will return a MULTILINESTRING, otherwise it
    will return a GEOMETRYCOLLECTION containing triangular POLYGONs.
"""
delaunaytriangulation(geom::Geometry, tol::Real, onlyedges::Bool) =
    Geometry(GDAL.delaunaytriangulation(geom.ptr, tol, onlyedges))

"""
Modify the geometry such it has no segment longer than the given distance.

### Parameters
* **geom**: the geometry to segmentize
* **maxLength**: the maximum distance between 2 points after segmentization
"""
segmentize(geom::Geometry, maxlength::Real) =
    GDAL.segmentize(geom.ptr, maxlength)

"Returns whether the features intersect"
intersects(geom1::Geometry, geom2::Geometry) =
    Bool(GDAL.intersects(geom1.ptr, geom2.ptr))

"Returns TRUE if the geometries are equivalent."
equals(geom1::Geometry, geom2::Geometry) =
    Bool(GDAL.equals(geom1.ptr, geom2.ptr))

"Returns TRUE if the geometries are disjoint."
disjoint(geom1::Geometry, geom2::Geometry) =
    Bool(GDAL.disjoint(geom1.ptr, geom2.ptr))

"Returns TRUE if the geometries are touching."
touches(geom1::Geometry, geom2::Geometry) =
    Bool(GDAL.touches(geom1.ptr, geom2.ptr))

"Returns TRUE if the geometries are crossing."
crosses(geom1::Geometry, geom2::Geometry) =
    Bool(GDAL.crosses(geom1.ptr, geom2.ptr))

"Returns TRUE if geom1 is contained within geom2."
within(geom1::Geometry, geom2::Geometry) =
    Bool(GDAL.within(geom1.ptr, geom2.ptr))

"Returns TRUE if geom1 contains geom2."
contains(geom1::Geometry, geom2::Geometry) =
    Bool(GDAL.contains(geom1.ptr, geom2.ptr))

"Returns TRUE if the geometries overlap."
overlaps(geom1::Geometry, geom2::Geometry) =
    Bool(GDAL.overlaps(geom1.ptr, geom2.ptr))

"Returns the boundary of the geometry."
boundary(geom1::Geometry, geom2::Geometry) =
    Geometry(GDAL.boundary(geom1.ptr, geom2.ptr))

"Returns the convex hull of the geometry."
convexhull(geom::Geometry) = Geometry(GDAL.convexhull(geom.ptr))

"""
Compute buffer of geometry.

### Parameters
* **geom**: the geometry.
* **dist**: the buffer distance to be applied. Should be expressed into the
    same unit as the coordinates of the geometry.
* **quadsegs**: the number of segments used to approximate a 90 degree
    (quadrant) of curvature.
"""
buffer(geom::Geometry, dist::Real, quadsegs::Integer=8) =
    Geometry(GDAL.buffer(geom.ptr, dist, quadsegs))

"""
Compute the intersection of the geometries.

### Returns
a new geometry representing the union or NULL if an error occurs.
"""
intersection(geom1::Geometry, geom2::Geometry) =
    Geometry(GDAL.intersection(geom1.ptr, geom2.ptr))

"""
Compute the union of the geometries.

### Returns
a new geometry representing the union or NULL if an error occurs.
"""
union(geom1::Geometry, geom2::Geometry) =
    Geometry(GDAL.union(geom1.ptr, geom2.ptr))

"""
Compute the union of the geometry using cascading.

### Returns
a new geometry representing the union or NULL if an error occurs.
"""
unioncascaded(geom::Geometry) = Geometry(GDAL.unioncascaded(geom.ptr))

"""
Returns a point guaranteed to lie on the surface or NULL if an error occurred.
"""
pointonsurface(geom::Geometry) = Geometry(GDAL.pointonsurface(geom.ptr))

"""
Compute the difference of the geometries.

### Returns
a new geometry representing the difference or NULL if the difference is empty
or an error occurs.
"""
difference(geom1::Geometry, geom2::Geometry) =
    Geometry(GDAL.difference(geom1.ptr, geom2.ptr))

"""
Compute the symmetric difference of the geometries.

### Returns
a new geometry representing the symmetric difference or NULL if the difference
is empty or an error occurs.
"""
symdifference(geom1::Geometry, geom2::Geometry) =
    Geometry(GDAL.symdifference(geom1.ptr, geom2.ptr))

"""
Compute distance between two geometries.

### Returns
the distance between the geometries or -1 if an error occurs.
"""
distance(geom1::Geometry, geom2::Geometry) =
    GDAL.distance(geom1.ptr, geom2.ptr)

"""
Compute length of a geometry.

### Returns
the length or 0.0 for unsupported geometry types.
"""
geomlength(geom::Geometry) = GDAL.length(geom.ptr)

"""
Compute geometry area.

### Returns
the area or 0.0 for unsupported geometry types.
"""
geomarea(geom::Geometry) = GDAL.area(geom.ptr)

"Compute the geometry centroid."
function centroid!(geom::Geometry, centroid::Geometry)
    result = GDAL.centroid(geom.ptr, centroid.ptr)
    if result != GDAL.OGRERR_NONE
        error("Failed to compute the geometry centroid")
    end
end

"""
Fetch point at given distance along curve.

### Parameters
* **geom**: curve geometry.
* **distance**: distance along the curve at which to sample position.
    This distance should be between zero and geomlength() for this curve.
"""
pointalongline(geom::Geometry, distance::Real) =
    Geometry(GDAL.value(geom.ptr, distance))

"Clear geometry information."
empty!(geom::Geometry) = GDAL.empty(geom.ptr)

"Returns TRUE if the geometry has no points, otherwise FALSE."
isempty(geom::Geometry) = Bool(GDAL.isempty(geom.ptr))

"Returns TRUE if the geometry is valid, otherwise FALSE."
isvalid(geom::Geometry) = Bool(GDAL.isvalid(geom.ptr))

"Returns TRUE if the geometry is simple, otherwise FALSE."
issimple(geom::Geometry) = Bool(GDAL.issimple(geom.ptr))

"Returns TRUE if the geometry is a ring, otherwise FALSE."
isring(geom::Geometry) = Bool(GDAL.isring(geom.ptr))

"""
Polygonizes a set of sparse edges.

### Returns
a handle to a newly allocated geometry now owned by the caller.
"""
polygonize(geom::Geometry) = Geometry(GDAL.polygonize(geom.ptr))

equal(geom1::Geometry, geom2::Geometry) =
    Bool(GDAL.equal(geom1.ptr, geom2.ptr))

"Fetch number of points from a geometry."
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


"Fetch the x coordinate of a point from a geometry, at index i."
getx(geom::Geometry, i::Integer) = GDAL.getx(geom.ptr, i)

"Fetch the y coordinate of a point from a geometry, at index i."
gety(geom::Geometry, i::Integer) = GDAL.gety(geom.ptr, i)

"Fetch the z coordinate of a point from a geometry, at index i."
getz(geom::Geometry, i::Integer) = GDAL.getz(geom.ptr, i)

"""
Fetch a point in line string or a point geometry, at index i.

### Parameters
* **i**: the vertex to fetch, from 0 to getNumPoints()-1, zero for a point.
"""
getpoint!(geom::Geometry, i::Integer, x, y, z) =
    GDAL.getpoint(geom.ptr, i, x, y, z)

function getpoint(geom::Geometry, i::Integer)
    x = Ref{Cdouble}()
    y = Ref{Cdouble}()
    z = Ref{Cdouble}()
    getpoint!(geom, i, x, y, z)
    (x[], y[], z[])
end

"""
Set number of points in a geometry.

### Parameters
* **geom**: the geometry.
* **n**: the new number of points for geometry.
"""
setpointcount(geom::Geometry, n::Integer) = GDAL.setpointcount(geom.ptr, n)

"""
Set the location of a vertex in a point or linestring geometry.

### Parameters
* **geom**: handle to the geometry to add a vertex to.
* **i**: the index of the vertex to assign (zero based) or zero for a point.
* **x**: input X coordinate to assign.
* **y**: input Y coordinate to assign.
* **z**: input Z coordinate to assign (defaults to zero).
"""
setpoint(geom::Geometry, i::Integer, x, y, z) =
    GDAL.setpoint(geom.ptr, i, x, y, z)

"""
Set the location of a vertex in a point or linestring geometry.

### Parameters
* **geom**: handle to the geometry to add a vertex to.
* **i**: the index of the vertex to assign (zero based) or zero for a point.
* **x**: input X coordinate to assign.
* **y**: input Y coordinate to assign.
"""
setpoint(geom::Geometry, i::Integer, x, y) =
    GDAL.setpoint_2d(geom.ptr, i, x, y)

"""
Add a point to a geometry (line string or point).

### Parameters
* **geom**: the geometry to add a point to.
* **x**: x coordinate of point to add.
* **y**: y coordinate of point to add.
* **z**: z coordinate of point to add.
"""
addpoint(geom::Geometry, x, y, z) = GDAL.addpoint(geom.ptr, x, y, z)

"""
Add a point to a geometry (line string or point).

### Parameters
* **geom**: the geometry to add a point to.
* **x**: x coordinate of point to add.
* **y**: y coordinate of point to add.
"""
addpoint(geom::Geometry, x, y) = GDAL.addpoint_2d(geom.ptr, x, y)

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


"The number of elements in a geometry or number of geometries in container."
ngeometry(geom::Geometry) = GDAL.getgeometrycount(geom.ptr)

"""
Fetch geometry from a geometry container.

### Parameters
* **geom**: the geometry container from which to get a geometry from.
* **i**: index of the geometry to fetch, between 0 and getNumGeometries() - 1.
"""
fetchgeom(geom::Geometry, i::Integer) =
    Geometry(GDAL.getgeometryref(geom.ptr, i))

"""
Add a geometry to a geometry container.

### Returns
OGRERR_NONE if successful, or OGRERR_UNSUPPORTED_GEOMETRY_TYPE if the geometry
type is illegal for the type of existing geometry.
"""
function addgeom(geom::Geometry, subgeom::Geometry)
    result = GDAL.addgeometry(geom.ptr, subgeom.ptr)
    if result != GDAL.OGRERR_NONE
        error("Failed to add geometry. The geometry type could be illegal")
    end
end

"""
Add a geometry directly to an existing geometry container.

### Parameters
* **geom**: existing geometry.
* **subgeom**: geometry to add to the existing geometry.
"""
function addgeomdirectly(geom::Geometry, subgeom::Geometry)
    result = GDAL.addgeometrydirectly(geom.ptr, subgeom.ptr)
    if result != GDAL.OGRERR_NONE
        error("Failed to add geometry. The geometry type could be illegal")
    end
end

"""
Remove a geometry from an exiting geometry container.

### Parameters
* **geom**: the existing geometry to delete from.
* **i**: the index of the geometry to delete. A value of -1 is a special flag
    meaning that all geometries should be removed.
* **todelete**: if TRUE the geometry will be destroyed, otherwise it will not.
    The default is TRUE as the existing geometry is considered to own the
    geometries in it.
"""
function removegeom(geom::Geometry, i::Integer, todelete::Bool = true)
    result = GDAL.removegeometry(geom.ptr, i, todelete)
    if result != GDAL.OGRERR_NONE
        error("Failed to remove geometry. The index could be out of range")
    end
end

function removeallgeoms(geom::Geometry, todelete::Bool = true)
    result = GDAL.removegeometry(geom.ptr, -1, todelete)
    if result != GDAL.OGRERR_NONE
        error("Failed to remove geometries. The index could be out of range")
    end
end

"""
Returns if this geometry is or has curve geometry.

### Parameters
* **geom**: the geometry to operate on.
* **nonlinear**: set it to TRUE to check if the geometry is or contains a
    CIRCULARSTRING.
"""
hascurvegeom(geom::Geometry, nonlinear::Bool) =
    Bool(GDAL.hascurvegeometry(geom.ptr, nonlinear))

"""
Return, possibly approximate, linear version of this geometry.

### Parameters
* **geom**: the geometry to operate on.
* **stepsize**: the largest step in degrees along the arc, zero to use the
    default setting.
* **options**: options as a null-terminated list of strings or NULL.
    See OGRGeometryFactory::curveToLineString() for valid options.
"""
lineargeom(geom::Geometry, stepsize::Real=0.0) = 
    Geometry(GDAL.getlineargeometry(geom.ptr, stepsize, C_NULL))

"Return curve version of this geometry."
curvegeom(geom::Geometry) = Geometry(GDAL.getcurvegeometry(geom.ptr, C_NULL))

"""
Build a ring from a bunch of arcs.

### Parameters
* **lines**: handle to an OGRGeometryCollection (or OGRMultiLineString)
    containing the line string geometries to be built into rings.
* **besteffort**: not yet implemented???.
* **autoclose**: indicates if the ring should be close when first and last
    points of the ring are the same.
* **tol**: whether two arcs are considered close enough to be joined.
"""
function polygonfromedges(lines::Geometry, besteffort::Bool, autoclose::Bool,
                          tol::Real)
    peErr = Ref{GDAL.OGRErr}()
    result = Geometry(GDAL.buildpolygonfromedges(lines.ptr, besteffort,
                                                 autoclose, tol, peErr))
    if peErr[] != OGRERR_NONE
        error("Failed to build polygon from edges.")
    end
    Geometry(result)
end
