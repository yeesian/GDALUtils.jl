# adapted from http://www.gis.usu.edu/~chrisg/python/2009/lectures/ospy_hw4b.py

import GDALUtils; const GU = GDALUtils

# version 1
@time GU.read("ospy/data4/aster.img") do ds
    count = 0
    total = 0
    data = GU.fetch(ds, 1)
    for (cols,rows) in GU.WindowIterator(GU.fetchband(ds, 1))
        window = data[cols, rows]
        count = count + sum(window .> 0)
        total = total + sum(window)
    end
    println("Ignoring 0:  $(total / count)")
    println("Including 0: $(total / (GU.height(ds) * GU.width(ds)))")
end
# Ignoring 0: 76.33891347095299
# Including 0: 47.55674749653172
#   0.367471 seconds (173.86 k allocations: 91.463 MB, 3.39% gc time)

# version 2
@time GU.read("ospy/data4/aster.img") do ds
    band = GU.fetchband(ds, 1)
    count = 0
    total = 0
    buffer = Array(GU.getdatatype(band), GU.getblocksize(band)...)
    for (cols,rows) in GU.WindowIterator(band)
        GU.rasterio!(band, buffer, rows, cols)
        data = buffer[1:length(cols),1:length(rows)]
        count += sum(data .> 0)
        total += sum(data)
    end
    println("Ignoring 0:  $(total / count)")
    println("Including 0: $(total / (GU.height(ds) * GU.width(ds)))")
end
# Ignoring 0:  76.33891347095299
# Including 0: 47.55674749653172
#   0.337447 seconds (208.89 k allocations: 65.353 MB, 7.78% gc time)

# version 3
@time GU.read("ospy/data4/aster.img") do ds
    count = 0
    total = 0
    # BufferIterator uses a single buffer, so this loop cannot be parallelized
    for data in GU.BufferIterator(GU.fetchband(ds, 1))
        count += sum(data .> 0)
        total += sum(data)
    end
    println("Ignoring 0:  $(total / count)")
    println("Including 0: $(total / (GU.height(ds) * GU.width(ds)))")
end
# Ignoring 0:  76.33891347095299
# Including 0: 47.55674749653172
#   0.312078 seconds (205.92 k allocations: 65.093 MB, 8.70% gc time)
