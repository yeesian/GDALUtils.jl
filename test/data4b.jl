# adapted from http://www.gis.usu.edu/~chrisg/python/2009/lectures/ospy_hw4b.py

import GDALUtils; const GU = GDALUtils

# version 1
@time GU.read("ospy/data4/aster.img") do ds
    # get image size
    rows = GU.height(ds)
    cols = GU.width(ds)
    bands = GU.nraster(ds)

    # get the band and block sizes
    band = GU.fetchband(ds, 1)
    (xbsize, ybsize) = GU.getblocksize(band)

    # initialize variables
    count = 0
    total = 0

    data = GU.fetch(ds, 1)
    for i in 1:ybsize:rows
        # loop through the columns
        for j in 1:xbsize:cols
            if i + ybsize < rows
                nrows = ybsize
            else
                nrows = rows - (i-1)
            end
            if j + xbsize < cols
                ncols = xbsize
            else
                ncols = cols - (j-1)
            end
            window = data[j:j+ncols-1, i:i+nrows-1]
            count = count + sum(window .> 0)
            total = total + sum(window)
        end
    end
    println("Ignoring 0:  $(total / count)")
    println("Including 0: $(total / (rows * cols))")
end

# Ignoring 0:  76.33891347095299
# Including 0: 47.55674749653172
#   0.250603 seconds (154.79 k allocations: 90.796 MB, 31.42% gc time)

# version 2
@time GU.read("ospy/data4/aster.img") do ds
    # get image size
    rows = GU.height(ds)
    cols = GU.width(ds)
    bands = GU.nraster(ds)

    # get the band and block sizes
    band = GU.fetchband(ds, 1)
    (xbsize, ybsize) = GU.getblocksize(band)

    # initialize variables
    count = 0
    total = 0

    buffer = Array(GU.getdatatype(band), ybsize, xbsize)
    # loop through the rows
    for i in 0:ybsize:(rows-1)
        # loop through the columns
        for j in 0:xbsize:(cols-1)
            if i + ybsize < rows
                nrows = ybsize
            else
                nrows = rows - i
            end
            if j + xbsize < cols
                ncols = xbsize
            else
                ncols = cols - j
            end
            GU.rasterio!(band, buffer, ncols, nrows, j, i)
            data = buffer[1:nrows,1:ncols]
            count += sum(data .> 0)
            total += sum(data)
        end
    end

    # print results
    println("Ignoring 0:  $(total / count)")
    println("Including 0: $(total / (rows * cols))")
end

# Ignoring 0:  76.33891347095299
# Including 0: 47.55674749653172
#   0.184718 seconds (150.16 k allocations: 63.625 MB, 9.85% gc time)