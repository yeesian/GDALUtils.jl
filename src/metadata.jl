
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

const _access = Dict{UInt32, Symbol}(0 => :ReadOnly, 1 => :Update)

"""
`TRUE` if the passed type is complex (one of `GDT_CInt16`, `GDT_CInt32`,
`GDT_CFloat32` or `GDT_CFloat64`)
"""
datatypeiscomplex(dtype::GDAL.GDALDataType) = Bool(GDAL.datatypeiscomplex(dtype))

nullify(obj) = (obj.ptr = C_NULL)
checknull(obj) = (obj.ptr == C_NULL)

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
