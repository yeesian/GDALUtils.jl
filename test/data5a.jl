# adapted from http://www.gis.usu.edu/~chrisg/python/2009/lectures/ospy_hw5a.py

import GDALUtils; const GU = GDALUtils

GU.read("ospy/data5/aster.img") do inDS
    # get image size
    rows = GU.height(inDS)
    cols = GU.width(inDS)
    bands = GU.nraster(inDS)

    # get the band and block sizes
    inband2 = GU.fetchband(inDS, 2)
    inband3 = GU.fetchband(inDS, 3)
    (xbsize, ybsize) = GU.getblocksize(inband2)

    buffer2 = Array(Float32, ybsize, xbsize)
    buffer3 = Array(Float32, ybsize, xbsize)
    ndvi    = Array(Float32, ybsize, xbsize)
    # create the output image
    GU.create("tmp/ndvi.img",
              GU.getdriver(inDS),
              cols, rows, 1, Float32) do outDS
        for ((i,j),(nrows,ncols)) in GU.BlockIterator(inband2)
            GU.rasterio!(inband2, buffer2, ncols, nrows, j, i)
            GU.rasterio!(inband3, buffer3, ncols, nrows, j, i)
            data2 = buffer2[1:nrows,1:ncols]
            data3 = buffer3[1:nrows,1:ncols]
            for row in 1:nrows, col in 1:ncols
                denominator = data2[row, col] + data3[row, col]
                if denominator > 0
                    numerator = data3[row, col] - data2[row, col]
                    ndvi[row, col] = numerator / denominator
                else
                    ndvi[row, col] = -99
                end
            end
            # write the data
            GU.update!(outDS, ndvi, 1, ncols, nrows, j, i)
        end
        # flush data to disk, set the NoData value and calculate stats
        outband = GU.fetchband(outDS, 1)
        GU.flushcache(outband)
        GU.setnodatavalue(outband, -99)
        # stats = outBand.GetStatistics(0, 1)

        # georeference the image and set the projection
        GU.setgeotransform!(outDS, GU.getgeotransform(inDS))
        GU.setproj(outDS, GU.getproj(inDS))

        # build pyramids
        # gdal.SetConfigOption('HFA_USE_RRD', 'YES')
        GU.buildoverviews(outDS,
                          Cint[2,4,8,16,32,64,128], # overview list
                                                    # bandlist (omit to include all bands)
                          "NEAREST")                # resampling method (default: nearest)
    end
end
