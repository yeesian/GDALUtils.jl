function Base.show(io::IO, drv::Driver)
    if checknull(drv)
        print(io, "Null Driver")
    else
        print(io, "Driver: $(getshortname(drv))/$(getlongname(drv))")
        # provide creation options too
    end
end

function Base.show(io::IO, dataset::Dataset)
    if checknull(dataset)
        print(io, "Closed Dataset")
    else
        nrasters = nraster(dataset)
        println(io, "GDAL Dataset ($(getdriver(dataset)))")
        print(io, "File(s): ")
        for (i,filename) in enumerate(filelist(dataset))
            print(io, "$filename ")
            if i % 4 == 0 println() end
        end
        # print(io, "\nDataset (width x height): ")
        # println(io, "$(width(dataset)) x $(height(dataset)) (pixels)\n")
        println(io, "\nNumber of raster bands: $(nrasters)")
        for i in 1:min(nrasters, 3)
            print(io, "  ")
            summarize(io, fetchband(dataset, i))
        end
        nrasters > 3 && println(io, "  ...")

        nlayers = nlayer(dataset)
        println(io, "Number of feature layers: $(nlayers)")
        for i in 1:min(nlayers, 3)
            layer = fetchlayer(dataset, i-1)
            layergeomtype = _geomname[getgeomtype(layer)]
            print(io, "  Layer $(i-1): $(getname(layer)) ")
            println(io, "($layergeomtype), nfeatures = $(nfeature(layer))")
        end
        nlayers > 3 && print(io, "  ...")
    end
end

function summarize(io::IO, rasterband::RasterBand)
    if checknull(rasterband)
        print(io, "Null RasterBand")
    else
        access = _access[getaccess(rasterband)]
        color = getcolorinterpname(getcolorinterp(rasterband))
        xsize = width(rasterband)
        ysize = height(rasterband)
        i = indexof(rasterband)
        pxtype = getdatatype(rasterband)
        println(io, "[$access] Band $i ($color): $xsize x $ysize ($pxtype)")
    end
end

function Base.show(io::IO, rasterband::RasterBand)
    summarize(io, rasterband)
    (x,y) = getblocksize(rasterband)
    sc = getscale(rasterband)
    ofs = getoffset(rasterband)
    norvw = noverview(rasterband)
    ut = getunittype(rasterband)
    nv = getnodatavalue(rasterband)
    println(io, "    blocksize: $(x)x$(y), nodata: $nv, units: $(sc)px + $(ofs)$ut")
    print(io, "    overviews: ")
    for i in 1:norvw
        ovr_band = fetchoverview(rasterband, i)
        print(io, "$(width(ovr_band))x$(height(ovr_band)), ")
        if i % 5 == 0
            println(io, "")
            print(io, "               ")
        end
    end
end

function Base.show(io::IO, layer::FeatureLayer)
    layergeomtype = _geomname[getgeomtype(layer)]
    print(io, "Layer: $(getname(layer)) ")
    println(io, "($layergeomtype), nfeatures = $(nfeature(layer))")
    println("Feature Definition:")
    featuredefn = getlayerdefn(layer)
    n = ngeomfield(featuredefn)
    for i in 1:min(n, 3)
        gfd = fetchgeomfielddefn(featuredefn, i-1)
        println(io, "  Geometry (index $(i-1)): $(getname(gfd)) ($(_geomname[gettype(gfd)]))")
    end
    n > 3 && println(io, "  ...\n  Number of Geometries: $n")
    n = nfield(featuredefn)
    for i in 1:min(n, 3)
        fd = fetchfielddefn(featuredefn, i-1)
        println(io, "  Field    (index $(i-1)): $(getname(fd)) ($(_fieldtype[gettype(fd)]))")
    end
    n > 3 && print(io, "...\n Number of Fields: $n")
end

function Base.show(io::IO, feature::Feature)
    println(io, "Feature")
    n = ngeomfield(feature)
    for i in 1:min(n, 3)
        println(io, "  (index $(i-1)) geom => $(getgeomname(fetchgeomfield(feature, i-1)))")
    end
    n > 3 && println(io, "...\n Number of geometries: $n")
    n = nfield(feature)
    for i in 1:n
        print(io, "  (index $(i-1)) $(getname(fetchfielddefn(feature, i-1))) => ")
        println("$(fetchfield(feature, i-1))")
    end
    n > 3 && print(io, "...\n Number of Fields: $n")
end

function Base.show(io::IO, spref::SpatialRef)
    println(io, "Spatial Reference System")
    print(io, "$(toWKT(spref, true))")
end