
"""
Returns a symbolic name for the color interpretation.

This is derived from the enumerated item name with the `GCI_` prefix removed,
but there are some variations. So `GCI_GrayIndex` returns "Gray" and
`GCI_RedBand` returns "Red". The returned strings are static strings and should
not be modified or freed by the application.
"""
nameof(color::GDAL.GDALColorInterp) = GDAL.getcolorinterpretationname(color)

"Get color interpretation corresponding to the given symbolic name."
colorinterp(name::AbstractString) = GDAL.getcolorinterpretationbyname(name)

"Load a `NULL`-terminated list of strings"
function loadstringlist(pstringlist::Ptr{Cstring})
    stringlist = Vector{ASCIIString}()
    (pstringlist == C_NULL) && return stringlist
    i = 1
    item = unsafe_load(pstringlist, i)
    while Ptr{UInt8}(item) != C_NULL
        push!(stringlist, bytestring(item))
        i += 1
        item = unsafe_load(pstringlist, i)
    end
    stringlist
end

"Fetch list of (non-empty) metadata domains. (Since: GDAL 1.11)"
metadatadomainlist{T <: GDAL.GDALMajorObjectH}(obj::Ptr{T}) =
    loadstringlist(GDAL.C.GDALGetMetadataDomainList(obj))

"""
Fetch metadata. Use `""` or `NULL` for the default domain.

The returned string list is owned by the object, and may change at any time.
It is formated as a "Name=value" list with the last pointer value being `NULL`.
Note that relatively few formats return any metadata at this time.
"""
getmetadata{T <: GDAL.GDALMajorObjectH}(obj::Ptr{T}, domain::AbstractString = "") =
    loadstringlist(GDAL.C.GDALGetMetadata(obj, pointer(domain)))
