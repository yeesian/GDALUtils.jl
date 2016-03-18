# Tests based on the Raster API tutorial found at http://gdal.org/gdal_tutorial.html

GU.read("data/utmsmall.tif") do dataset
    driver = GU.getdriver("GTiff")
    @fact GU.getshortname(driver) --> "GTiff"
    @fact GU.getlongname(driver) --> "GeoTIFF"
    @fact GU.width(dataset) --> 100
    @fact GU.height(dataset) --> 100
    @fact GU.nband(dataset) --> 1

    nad27_prefix = "PROJCS[\"NAD27 / UTM zone 11N\",GEOGCS[\"NAD27\",DATUM[\"North_American_Datum_1927\","
    @fact startswith(GU.projWKT(dataset), nad27_prefix) --> true
    @fact GU.getgeotransform(dataset) --> roughly([440720.0,60.0,0.0,3.75132e6,0.0,-60.0])

    band = GU.fetchband(dataset, 1)
    @fact GU.getblocksize(band) --> roughly([100, 81])
    @fact GU.getdatatype(band) --> UInt8
    @fact GU.getname(GU.getcolorinterp(band)) --> "Gray"

    gotmin, gotmax = Ref(Cint(-1)), Ref(Cint(-1))
    @test GDAL.getrasterminimum(band.ptr, gotmin) == 0.0
    @test GDAL.getrastermaximum(band.ptr, gotmax) == 255.0
    @test gotmin[] == gotmax[] == 0

    @fact GU.noverview(band) --> 0
    @test_throws GDAL.GDALError GDAL.getrastercolortable(band.ptr)


    # Reading Raster Data
    @fact GU.width(band) --> 100
    data = map(Float32, GU.fetch(dataset, 1))
    @fact data[:,1] --> roughly(Float32[107.0f0,123.0f0,132.0f0,115.0f0,132.0f0,132.0f0,140.0f0,132.0f0,132.0f0,132.0f0,107.0f0,132.0f0,107.0f0,132.0f0,132.0f0,107.0f0,123.0f0,115.0f0,156.0f0,148.0f0,107.0f0,132.0f0,107.0f0,115.0f0,99.0f0,123.0f0,99.0f0,74.0f0,115.0f0,82.0f0,115.0f0,115.0f0,107.0f0,123.0f0,123.0f0,99.0f0,123.0f0,123.0f0,115.0f0,115.0f0,107.0f0,90.0f0,99.0f0,107.0f0,107.0f0,99.0f0,123.0f0,107.0f0,140.0f0,123.0f0,123.0f0,115.0f0,99.0f0,132.0f0,123.0f0,115.0f0,115.0f0,123.0f0,132.0f0,115.0f0,123.0f0,132.0f0,214.0f0,156.0f0,165.0f0,148.0f0,115.0f0,148.0f0,156.0f0,148.0f0,140.0f0,165.0f0,156.0f0,197.0f0,156.0f0,197.0f0,140.0f0,173.0f0,156.0f0,165.0f0,148.0f0,156.0f0,206.0f0,214.0f0,181.0f0,206.0f0,173.0f0,222.0f0,206.0f0,255.0f0,214.0f0,173.0f0,214.0f0,255.0f0,214.0f0,247.0f0,255.0f0,230.0f0,206.0f0,197.0f0])
end


# Techniques for Creating Files
#@test GDAL.getmetadataitem(driver, "DCAP_CREATE", "") == "YES"
#@test GDAL.getmetadataitem(driver, "DCAP_CREATECOPY", "") == "YES"


# Using CreateCopy()
GU.read("data/utmsmall.tif") do ds_src
    GU.write("tmp/utmsmall.tif", ds_src)
end

rm("tmp/utmsmall.tif")