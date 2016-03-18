function Base.show(io::IO, drv::Driver)
    if checknull(drv)
        print(io, "Null Driver")
    else
        print(io, "Driver: $(getshortname(drv))/$(getlongname(drv))")
    end
end

function Base.show(io::IO, dataset::Dataset)
    if checknull(dataset)
        print(io, "Closed Dataset")
    else
        nrasters = nraster(dataset)
        println(io, "GDAL Dataset ($(getdriver(dataset)))")
        print(io, "\nFile(s): ")
        for (i,filename) in enumerate(filelist(dataset))
            print(io, "$filename ")
            if i % 4 == 0 println() end
        end
        print(io, "\nDataset (width x height): ")
        println(io, "$(width(dataset)) x $(height(dataset)) (pixels)")
        for i in 1:min(nrasters, 3)
            print(io, "  ")
            summarize(io, fetchband(dataset, i))
        end
        nrasters > 3 && println(io, "  ...")
        print(io, "Number of bands: $(nrasters)")
    end
end

function summarize(io::IO, rasterband::RasterBand)
    if checknull(rasterband)
        println(io, "Null RasterBand")
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