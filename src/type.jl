

type Dataset
    ptr::Ptr{GDAL.GDALDatasetH}

    function Dataset(ptr::Ptr{GDAL.GDALDatasetH})
        dataset = new(ptr) # number of bands
        finalizer(dataset, closedataset)
        dataset
    end
end

function closedataset(dataset::Dataset)
    if dataset.ptr != C_NULL
        closedataset(dataset.ptr)
        dataset.ptr = C_NULL
    end
end

checknull(dataset::Dataset) = (dataset.ptr == C_NULL)

function Base.show(io::IO, dataset::Dataset)
    if checknull(dataset)
        print(io, "Closed Dataset")
    else
        dptr = driver(dataset.ptr)
        _nband = nband(dataset.ptr)
        driverstring = "$(shortname(dptr))/$(longname(dptr))"
        println(io, "GDAL Dataset (Driver: $driverstring)")
        print(io, "\nFile(s): ")
        for filename in filelist(dataset.ptr)
            print(io, "$filename ")
        end
        print(io, "\nDataset (width x height): ")
        println(io, "$(width(dataset.ptr)) x $(height(dataset.ptr)) (pixels)")
        for i = 1:min(_nband, 5)
            band = fetchband(dataset.ptr, i)
            color = nameof(getcolorinterp(band))
            xsize = width(band)
            ysize = height(band)
            bandtype = datatypeof(band)
            println(io, "  Band $i ($color): $xsize x $ysize ($bandtype)")
        end
        _nband > 5 && println(io, "  ...")
        print(io, "Number of bands: $(nband(dataset.ptr))")
    end
end
