
"return the corresponding `DataType` in julia"
_jltype(dtype::GDAL.GDALDataType) = _jltype(Val{dtype})
_jltype(::Type{Val{GDAL.GDT_Unknown}}) = Any
_jltype(::Type{Val{GDAL.GDT_Byte}}) = UInt8
_jltype(::Type{Val{GDAL.GDT_UInt16}}) = UInt16
_jltype(::Type{Val{GDAL.GDT_Int16}}) = Int16
_jltype(::Type{Val{GDAL.GDT_UInt32}}) = UInt32
_jltype(::Type{Val{GDAL.GDT_Int32}}) = Int32
_jltype(::Type{Val{GDAL.GDT_Float32}}) = Float32
_jltype(::Type{Val{GDAL.GDT_Float64}}) = Float64

"return the corresponding `GDALDataType`"
_gdaltype(dtype::DataType) = _gdaltype(Val{dtype})
_gdaltype(::Type{Val{Any}}) = GDAL.GDT_Unknown
_gdaltype(::Type{Val{UInt8}}) = GDAL.GDT_Byte
_gdaltype(::Type{Val{UInt16}}) = GDAL.GDT_UInt16
_gdaltype(::Type{Val{Int16}}) = GDAL.GDT_Int16
_gdaltype(::Type{Val{UInt32}}) = GDAL.GDT_UInt32
_gdaltype(::Type{Val{Int32}}) = GDAL.GDT_Int32
_gdaltype(::Type{Val{Float32}}) = GDAL.GDT_Float32
_gdaltype(::Type{Val{Float64}}) = GDAL.GDT_Float64

"""
`TRUE` if the passed type is complex (one of `GDT_CInt16`, `GDT_CInt32`,
`GDT_CFloat32` or `GDT_CFloat64`)
"""
datatypeiscomplex(dtype::GDAL.GDALDataType) = Bool(GDAL.datatypeiscomplex(dtype))

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

"""
Fetch files forming dataset.

Returns a list of files believed to be part of this dataset. If it returns an
empty list of files it means there is believed to be no local file system files
associated with the dataset (for instance a virtual dataset). The returned file
list is owned by the caller and should be deallocated with `CSLDestroy()`.

The returned filenames will normally be relative or absolute paths depending on
the path used to originally open the dataset. The strings will be UTF-8 encoded
"""
filelist(dataset::Ptr{GDAL.GDALDatasetH}) =
    loadstringlist(GDAL.C.GDALGetFileList(Ptr{Void}(dataset)))

"""
Fetch list of (non-empty) metadata domains. (Since: GDAL 1.11)
"""
metadatadomainlist{T <: GDAL.GDALMajorObjectH}(obj::Ptr{T}) =
    loadstringlist(GDAL.getmetadatadomainlist(obj))

"""
Fetch metadata. Use `""` or `NULL` for the default domain.

The returned string list is owned by the object, and may change at any time.
It is formated as a "Name=value" list with the last pointer value being `NULL`.
Note that relatively few formats return any metadata at this time.
"""
getmetadata{T <: GDAL.GDALMajorObjectH}(obj::Ptr{T}, domain::AbstractString) =
    loadstringlist(GDAL.getmetadata(obj, pointer(domain)))

getmetadata{T <: GDAL.GDALMajorObjectH}(obj::Ptr{T}) =
    loadstringlist(GDAL.getmetadata(obj, C_NULL))
