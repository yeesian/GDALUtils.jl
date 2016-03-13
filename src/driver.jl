
"Fetch driver by index"
driver(i::Integer) = GDAL.getdriver(i-1)

"Fetch a driver based on the short name (such as `GTiff`)."
driver(name::AbstractString) = GDAL.getdriverbyname(name)

"Fetch the driver that the dataset was created with"
driver(dataset::Ptr{GDAL.GDALDatasetH}) = GDAL.getdatasetdriver(dataset)

"""
Destroy a `GDALDriver`.

This is roughly equivelent to deleting the driver, but is guaranteed to take
place in the GDAL heap. It is important this that function not be called on a
driver that is registered with the `GDALDriverManager`.
"""
destroy{T <: GDAL.GDALDriverH}(ptr::Ptr{T}) = GDAL.destroydriver(ptr)

"Register a driver for use."
register{T <: GDAL.GDALDriverH}(ptr::Ptr{T}) = GDAL.registerdriver(ptr)

"Deregister the passed driver."
deregister{T <: GDAL.GDALDriverH}(ptr::Ptr{T}) = GDAL.deregisterdriver(ptr)

"Return the list of creation options of the driver [an XML string]"
options{T <: GDAL.GDALDriverH}(ptr::Ptr{T}) = GDAL.getdrivercreationoptionlist(ptr)

"Return the short name of a driver (e.g. `GTiff`)"
shortname{T <: GDAL.GDALDriverH}(ptr::Ptr{T}) = GDAL.getdrivershortname(ptr)

"Return the long name of a driver (e.g. `GeoTIFF`), or empty string."
longname{T <: GDAL.GDALDriverH}(ptr::Ptr{T}) = GDAL.getdriverlongname(ptr)

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
identify(filename::AbstractString) = GDAL.identifydriver(filename, C_NULL)

# """
# Validate the list of creation options that are handled by a driver.

# This is a helper method primarily used by `Create()` and `CreateCopy()` to
# validate that the passed in list of creation options is compatible with the
# `GDAL_DMD_CREATIONOPTIONLIST` metadata item defined by some drivers.

# See also: `GDALGetDriverCreationOptionList()`

# If the `GDAL_DMD_CREATIONOPTIONLIST` metadata item is not defined, this
# function will return `TRUE`. Otherwise it will check that the keys and values
# in the list of creation options are compatible with the capabilities declared
# by the `GDAL_DMD_CREATIONOPTIONLIST` metadata item. In case of incompatibility
# a (non fatal) warning will be emited and `FALSE` will be returned.

# ### Parameters
# * `hDriver`     the handle of the driver with whom the lists of creation option
# must be validated
# * `options`     the list of creation options. An array of strings, whose last
# element is a `NULL` pointer

# ### Returns
# `TRUE` if the list of creation options is compatible with the `Create()` and
# `CreateCopy()` method of the driver, `FALSE` otherwise.
# """
# #validate(ptr::Ptr{GDALDriverH}) = GDAL.validatecreationoptions(hDriver, C_NULL)
# validate{T <: AbstractString}(ptr::Ptr{GDAL.GDALDriverH}, options::Vector{T}) =
#     Bool(GDAL.validatecreationoptions(ptr, Ptr{Ptr{UInt8}}(pointer(options))))
