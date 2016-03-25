Base.start(layer::FeatureLayer) = Feature(C_NULL)
Base.next(layer::FeatureLayer, state::Feature) = (state, state)
Base.eltype(layer::FeatureLayer) = Feature

function Base.done(layer::FeatureLayer, state::Feature)
    destroy(state)
    ptr = ccall((:OGR_L_GetNextFeature,GDAL.libgdal),
                Ptr{GDAL.OGRFeatureH},(Ptr{GDAL.OGRLayerH},),layer.ptr)
    state.ptr = ptr
    (ptr == C_NULL)
end