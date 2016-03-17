type FeatureLayer
    ptr::Ptr{GDAL.OGRLayerH}
end

type Feature
    ptr::Ptr{GDAL.OGRFeatureH}
end

type FeatureDefn
    ptr::Ptr{GDAL.OGRFeatureDefnH}
end

type FieldDefn
    ptr::Ptr{GDAL.OGRFieldDefnH}
end

type Geometry
    ptr::Ptr{GDAL.OGRGeometryH}
end

type GeomFieldDefn
    ptr::Ptr{GDAL.OGRGeomFieldDefnH}
end

type SpatialRef
    ptr::Ptr{GDAL.OGRSpatialReferenceH}
end

type Driver{T}
    ptr::Ptr{T}
end

type RasterBand
    ptr::Ptr{GDAL.GDALRasterBandH}

    function RasterBand(ptr::Ptr{GDAL.GDALRasterBandH})
        rasterband = new(ptr) # number of bands
        finalizer(rasterband, nullify)
        rasterband
    end
end

type Dataset
    ptr::Ptr{GDAL.GDALDatasetH}

    function Dataset(ptr::Ptr{GDAL.GDALDatasetH})
        dataset = new(ptr) # number of bands
        finalizer(dataset, nullify)
        dataset
    end
end

nullify(obj) = (obj.ptr = C_NULL)
checknull(obj) = (obj.ptr == C_NULL)

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
