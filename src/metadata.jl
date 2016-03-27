
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
getmetadatadomainlist{T <: GDAL.GDALMajorObjectH}(obj::Ptr{T}) =
    loadstringlist(GDAL.C.GDALGetMetadataDomainList(obj))

"""
Fetch metadata. Use `""` or `NULL` for the default domain.

The returned string list is owned by the object, and may change at any time.
It is formated as a "Name=value" list with the last pointer value being `NULL`.
Note that relatively few formats return any metadata at this time.
"""
getmetadata{T <: GDAL.GDALMajorObjectH}(obj::Ptr{T}, domain::AbstractString = "") =
    loadstringlist(GDAL.C.GDALGetMetadata(obj, pointer(domain)))

# """
#     GDALSetMetadata(GDALMajorObjectH hObject,
#                     char ** papszMD,
#                     const char * pszDomain) -> CPLErr
# Set metadata.
# """
# function setmetadata{T <: GDALMajorObjectH}(arg1::Ptr{T},arg2,arg3)
#     ccall((:GDALSetMetadata,libgdal),CPLErr,(Ptr{GDALMajorObjectH},Ptr{Cstring},Cstring),arg1,arg2,arg3)
# end


# """
#     GDALGetMetadataItem(GDALMajorObjectH hObject,
#                         const char * pszName,
#                         const char * pszDomain) -> const char *
# Fetch single metadata item.
# """
# function getmetadataitem{T <: GDALMajorObjectH}(arg1::Ptr{T},arg2,arg3)
#     bytestring(ccall((:GDALGetMetadataItem,libgdal),Cstring,(Ptr{GDALMajorObjectH},Cstring,Cstring),arg1,arg2,arg3))
# end


# """
#     GDALSetMetadataItem(GDALMajorObjectH hObject,
#                         const char * pszName,
#                         const char * pszValue,
#                         const char * pszDomain) -> CPLErr
# Set single metadata item.
# """
# function setmetadataitem{T <: GDALMajorObjectH}(arg1::Ptr{T},arg2,arg3,arg4)
#     ccall((:GDALSetMetadataItem,libgdal),CPLErr,(Ptr{GDALMajorObjectH},Cstring,Cstring,Cstring),arg1,arg2,arg3,arg4)
# end


# """
#     GDALGetDescription(GDALMajorObjectH hObject) -> const char *
# Fetch object description.
# """
# function getdescription{T <: GDALMajorObjectH}(arg1::Ptr{T})
#     bytestring(ccall((:GDALGetDescription,libgdal),Cstring,(Ptr{GDALMajorObjectH},),arg1))
# end


# """
#     GDALSetDescription(GDALMajorObjectH hObject,
#                        const char * pszNewDesc) -> void
# Set object description.
# """
# function setdescription{T <: GDALMajorObjectH}(arg1::Ptr{T},arg2)
#     ccall((:GDALSetDescription,libgdal),Void,(Ptr{GDALMajorObjectH},Cstring),arg1,arg2)
# end
