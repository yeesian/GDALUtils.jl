# adapted from http://www.gis.usu.edu/~chrisg/python/2009/lectures/ospy_hw5b.py

import GDALUtils; const GU = GDALUtils

GU.read("ospy/data5/doq1.img") do ds1
    GU.read("ospy/data5/doq2.img") do ds2
        # read in doq1 and get info about it
        band1 = GU.fetchband(ds1, 1)
        rows1 = GU.height(ds1)
        cols1 = GU.width(ds1)
        
        # get the corner coordinates for doq1
        transform1 = GU.getgeotransform(ds1)
        minX1 = transform1[1]
        maxY1 = transform1[4]
        pixelWidth1 = transform1[2]
        pixelHeight1 = transform1[6]
        maxX1 = minX1 + (cols1 * pixelWidth1)
        minY1 = maxY1 + (rows1 * pixelHeight1)

        # read in doq2 and get info about it
        band2 = GU.fetchband(ds2, 1)
        rows2 = GU.height(ds2)
        cols2 = GU.width(ds2)
        
        # get the corner coordinates for doq1
        transform2 = GU.getgeotransform(ds2)
        minX2 = transform1[1]
        maxY2 = transform1[4]
        pixelWidth2 = transform1[2]
        pixelHeight2 = transform1[6]
        maxX2 = minX2 + (cols2 * pixelWidth2)
        minY2 = maxY2 + (rows2 * pixelHeight2)

        # get the corner coordinates for the output
        minX = min(minX1, minX2)
        maxX = max(maxX1, maxX2)
        minY = min(minY1, minY2)
        maxY = max(maxY1, maxY2)

        # get the number of rows and columns for the output
        cols = round(Int, (maxX - minX) / pixelWidth1)
        rows = round(Int, (maxY - minY) / abs(pixelHeight1))

        # compute the origin (upper left) offset for doq1
        xOffset1 = round(Int, (minX1 - minX) / pixelWidth1)
        yOffset1 = round(Int, (maxY1 - maxY) / pixelHeight1)

        # compute the origin (upper left) offset for doq2
        xOffset2 = round(Int, (minX2 - minX) / pixelWidth1)
        yOffset2 = round(Int, (maxY2 - maxY) / pixelHeight1)

        dtype = GU.getdatatype(band1)
        data1 = Array(dtype, rows, cols)
        data2 = Array(dtype, rows, cols)
        # create the output image
        GU.create("tmp/mosiac.img", GU.getdriver(ds1), cols, rows,
                  1, GU.getdatatype(band1)) do dsout
            
            # read in doq1 and write it to the output
            GU.rasterio!(band1, data1, cols1, rows1, 0, 0)
            GU.update!(dsout, data1, 1, cols, rows, xOffset1, yOffset1)

            # read in doq2 and write it to the output
            GU.rasterio!(band2, data2, cols2, rows2, 0, 0)
            GU.update!(dsout, data2, 1, cols, rows, xOffset2, yOffset2)

            # compute statistics for the output
            bandout = GU.fetchband(dsout, 1)
            GU.flushcache(bandout)
            # stats = bandOut.GetStatistics(0, 1)

            # set the geotransform and projection on the output
            geotransform = [minX, pixelWidth1, 0, maxY, 0, pixelHeight1]
            GU.setgeotransform!(dsout, geotransform)
            GU.setproj(dsout, GU.getproj(ds1))

            # build pyramids for the output
            # gdal.SetConfigOption('HFA_USE_RRD', 'YES')
            GU.buildoverviews(dsout,
                              Cint[2,4,8,16], # overview list
                                              # bandlist (omit to include all bands)
                              "NEAREST")      # resampling method (default: nearest)
        end
    end
end
