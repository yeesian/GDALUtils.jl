type Driver{T}
    ptr::Ptr{T}
end

"Fetch driver by index"
driver(i::Integer) = Driver(GDAL.getdriver(i-1))

"Fetch a driver based on the short name (such as `GTiff`)."
driver(name::AbstractString) = Driver(GDAL.gdalgetdriverbyname(name))

"""
Destroy a `GDALDriver`.

This is roughly equivelent to deleting the driver, but is guaranteed to take
place in the GDAL heap. It is important this that function not be called on a
driver that is registered with the `GDALDriverManager`.
"""
destroy(drv::Driver) = GDAL.destroydriver(drv.ptr)

"Register a driver for use."
register(drv::Driver) = GDAL.registerdriver(drv.ptr)

"Deregister the passed drv."
deregister(drv::Driver) = GDAL.deregisterdriver(drv.ptr)

"Return the list of creation options of the driver [an XML string]"
options(drv::Driver) = GDAL.getdrivercreationoptionlist(drv.ptr)

"Return the short name of a driver (e.g. `GTiff`)"
shortname(drv::Driver) = GDAL.getdrivershortname(drv.ptr)

"Return the long name of a driver (e.g. `GeoTIFF`), or empty string."
longname(drv::Driver) = GDAL.getdriverlongname(drv.ptr)

"Fetch the number of registered drivers."
ndriver() = GDAL.getdrivercount()

"Returns a listing of all registered drivers"
function drivers()
    dlist = Dict{ASCIIString,ASCIIString}()
    for i in 1:ndriver()
        dlist[shortname(driver(i))] = longname(driver(i))
    end
    dlist
end

"""
Identify the driver that can open a raster file.

This function will try to identify the driver that can open the passed filename
by invoking the Identify method of each registered `GDALDriver` in turn. The
first driver that successful identifies the file name will be returned. If all
drivers fail then `NULL` is returned.
"""
identify(filename::AbstractString) =
    Driver(GDAL.identifydriver(filename, C_NULL))

"""
Validate the list of creation options that are handled by a drv.

This is a helper method primarily used by `Create()` and `CreateCopy()` to
validate that the passed in list of creation options is compatible with the
`GDAL_DMD_CREATIONOPTIONLIST` metadata item defined by some drivers.

See also: `GDALGetDriverCreationOptionList()`

If the `GDAL_DMD_CREATIONOPTIONLIST` metadata item is not defined, this
function will return `TRUE`. Otherwise it will check that the keys and values
in the list of creation options are compatible with the capabilities declared
by the `GDAL_DMD_CREATIONOPTIONLIST` metadata item. In case of incompatibility
a (non fatal) warning will be emited and `FALSE` will be returned.

### Parameters
* `hDriver`     the handle of the driver with whom the lists of creation option
must be validated
* `options`     the list of creation options. An array of strings, whose last
element is a `NULL` pointer

### Returns
`TRUE` if the list of creation options is compatible with the `Create()` and
`CreateCopy()` method of the driver, `FALSE` otherwise.
"""
function validate{T <: AbstractString}(drv::Driver, options::Vector{T})
    Bool(GDAL.validatecreationoptions(drv.ptr,
                                      Ptr{Ptr{UInt8}}(pointer(options))))
end

function Base.show(io::IO, drv::Driver)
    if checknull(drv)
        print(io, "Null Driver")
    else
        print(io, "Driver: $(shortname(drv))/$(longname(drv))")
    end
end