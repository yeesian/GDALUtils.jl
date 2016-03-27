"""
    GDALCreateColorTable(GDALPaletteInterp eInterp) -> GDALColorTableH
Construct a new color table.
"""
function createcolortable(arg1::GDALPaletteInterp)
    checknull(ccall((:GDALCreateColorTable,libgdal),Ptr{GDALColorTableH},(GDALPaletteInterp,),arg1))
end


"""
    GDALDestroyColorTable(GDALColorTableH hTable) -> void
Destroys a color table.
"""
function destroycolortable(arg1::Ptr{GDALColorTableH})
    ccall((:GDALDestroyColorTable,libgdal),Void,(Ptr{GDALColorTableH},),arg1)
end


"""
    GDALCloneColorTable(GDALColorTableH hTable) -> GDALColorTableH
Make a copy of a color table.
"""
function clonecolortable(arg1::Ptr{GDALColorTableH})
    checknull(ccall((:GDALCloneColorTable,libgdal),Ptr{GDALColorTableH},(Ptr{GDALColorTableH},),arg1))
end


"""
    GDALGetPaletteInterpretation(GDALColorTableH hTable) -> GDALPaletteInterp
Fetch palette interpretation.
"""
function getpaletteinterpretation(arg1::Ptr{GDALColorTableH})
    ccall((:GDALGetPaletteInterpretation,libgdal),GDALPaletteInterp,(Ptr{GDALColorTableH},),arg1)
end


"""
    GDALGetColorEntryCount(GDALColorTableH hTable) -> int
Get number of color entries in table.
"""
function getcolorentrycount(arg1::Ptr{GDALColorTableH})
    ccall((:GDALGetColorEntryCount,libgdal),Cint,(Ptr{GDALColorTableH},),arg1)
end


"""
    GDALGetColorEntry(GDALColorTableH hTable,
                      int i) -> const GDALColorEntry *
Fetch a color entry from table.
"""
function getcolorentry(arg1::Ptr{GDALColorTableH},arg2::Integer)
    ccall((:GDALGetColorEntry,libgdal),Ptr{GDALColorEntry},(Ptr{GDALColorTableH},Cint),arg1,arg2)
end


"""
    GDALGetColorEntryAsRGB(GDALColorTableH hTable,
                           int i,
                           GDALColorEntry * poEntry) -> int
Fetch a table entry in RGB format.
"""
function getcolorentryasrgb(arg1::Ptr{GDALColorTableH},arg2::Integer,arg3)
    ccall((:GDALGetColorEntryAsRGB,libgdal),Cint,(Ptr{GDALColorTableH},Cint,Ptr{GDALColorEntry}),arg1,arg2,arg3)
end


"""
    GDALSetColorEntry(GDALColorTableH hTable,
                      int i,
                      const GDALColorEntry * poEntry) -> void
Set entry in color table.
"""
function setcolorentry(arg1::Ptr{GDALColorTableH},arg2::Integer,arg3)
    ccall((:GDALSetColorEntry,libgdal),Void,(Ptr{GDALColorTableH},Cint,Ptr{GDALColorEntry}),arg1,arg2,arg3)
end


"""
    GDALCreateColorRamp(GDALColorTableH hTable,
                        int nStartIndex,
                        const GDALColorEntry * psStartColor,
                        int nEndIndex,
                        const GDALColorEntry * psEndColor) -> void
Create color ramp.
"""
function createcolorramp(hTable::Ptr{GDALColorTableH},nStartIndex::Integer,psStartColor,nEndIndex::Integer,psEndColor)
    ccall((:GDALCreateColorRamp,libgdal),Void,(Ptr{GDALColorTableH},Cint,Ptr{GDALColorEntry},Cint,Ptr{GDALColorEntry}),hTable,nStartIndex,psStartColor,nEndIndex,psEndColor)
end


"""
    GDALCreateRasterAttributeTable(void) -> GDALRasterAttributeTableH
Construct empty table.
"""
function createrasterattributetable()
    checknull(ccall((:GDALCreateRasterAttributeTable,libgdal),Ptr{GDALRasterAttributeTableH},()))
end


"""
    GDALDestroyRasterAttributeTable(GDALRasterAttributeTableH) -> void
Destroys a RAT.
"""
function destroyrasterattributetable(arg1::Ptr{GDALRasterAttributeTableH})
    ccall((:GDALDestroyRasterAttributeTable,libgdal),Void,(Ptr{GDALRasterAttributeTableH},),arg1)
end


"""
    GDALRATGetColumnCount(GDALRasterAttributeTableH) -> int
Fetch table column count.
"""
function ratgetcolumncount(arg1::Ptr{GDALRasterAttributeTableH})
    ccall((:GDALRATGetColumnCount,libgdal),Cint,(Ptr{GDALRasterAttributeTableH},),arg1)
end


"""
    GDALRATGetNameOfCol(GDALRasterAttributeTableH,
                        int) -> const char *
Fetch name of indicated column.
"""
function ratgetnameofcol(arg1::Ptr{GDALRasterAttributeTableH},arg2::Integer)
    bytestring(ccall((:GDALRATGetNameOfCol,libgdal),Cstring,(Ptr{GDALRasterAttributeTableH},Cint),arg1,arg2))
end


"""
    GDALRATGetUsageOfCol(GDALRasterAttributeTableH,
                         int) -> GDALRATFieldUsage
Fetch column usage value.
"""
function ratgetusageofcol(arg1::Ptr{GDALRasterAttributeTableH},arg2::Integer)
    ccall((:GDALRATGetUsageOfCol,libgdal),GDALRATFieldUsage,(Ptr{GDALRasterAttributeTableH},Cint),arg1,arg2)
end


"""
    GDALRATGetTypeOfCol(GDALRasterAttributeTableH,
                        int) -> GDALRATFieldType
Fetch column type.
"""
function ratgettypeofcol(arg1::Ptr{GDALRasterAttributeTableH},arg2::Integer)
    ccall((:GDALRATGetTypeOfCol,libgdal),GDALRATFieldType,(Ptr{GDALRasterAttributeTableH},Cint),arg1,arg2)
end


"""
    GDALRATGetColOfUsage(GDALRasterAttributeTableH,
                         GDALRATFieldUsage) -> int
Fetch column index for given usage.
"""
function ratgetcolofusage(arg1::Ptr{GDALRasterAttributeTableH},arg2::GDALRATFieldUsage)
    ccall((:GDALRATGetColOfUsage,libgdal),Cint,(Ptr{GDALRasterAttributeTableH},GDALRATFieldUsage),arg1,arg2)
end


"""
    GDALRATGetRowCount(GDALRasterAttributeTableH) -> int
Fetch row count.
"""
function ratgetrowcount(arg1::Ptr{GDALRasterAttributeTableH})
    ccall((:GDALRATGetRowCount,libgdal),Cint,(Ptr{GDALRasterAttributeTableH},),arg1)
end


"""
    GDALRATGetValueAsString(GDALRasterAttributeTableH,
                            int,
                            int) -> const char *
Fetch field value as a string.
"""
function ratgetvalueasstring(arg1::Ptr{GDALRasterAttributeTableH},arg2::Integer,arg3::Integer)
    bytestring(ccall((:GDALRATGetValueAsString,libgdal),Cstring,(Ptr{GDALRasterAttributeTableH},Cint,Cint),arg1,arg2,arg3))
end


"""
    GDALRATGetValueAsInt(GDALRasterAttributeTableH,
                         int,
                         int) -> int
Fetch field value as a integer.
"""
function ratgetvalueasint(arg1::Ptr{GDALRasterAttributeTableH},arg2::Integer,arg3::Integer)
    ccall((:GDALRATGetValueAsInt,libgdal),Cint,(Ptr{GDALRasterAttributeTableH},Cint,Cint),arg1,arg2,arg3)
end


"""
    GDALRATGetValueAsDouble(GDALRasterAttributeTableH,
                            int,
                            int) -> double
Fetch field value as a double.
"""
function ratgetvalueasdouble(arg1::Ptr{GDALRasterAttributeTableH},arg2::Integer,arg3::Integer)
    ccall((:GDALRATGetValueAsDouble,libgdal),Cdouble,(Ptr{GDALRasterAttributeTableH},Cint,Cint),arg1,arg2,arg3)
end


"""
    GDALRATSetValueAsString(GDALRasterAttributeTableH,
                            int,
                            int,
                            const char *) -> void
Set field value from string.
"""
function ratsetvalueasstring(arg1::Ptr{GDALRasterAttributeTableH},arg2::Integer,arg3::Integer,arg4)
    ccall((:GDALRATSetValueAsString,libgdal),Void,(Ptr{GDALRasterAttributeTableH},Cint,Cint,Cstring),arg1,arg2,arg3,arg4)
end


"""
    GDALRATSetValueAsInt(GDALRasterAttributeTableH,
                         int,
                         int,
                         int) -> void
Set field value from integer.
"""
function ratsetvalueasint(arg1::Ptr{GDALRasterAttributeTableH},arg2::Integer,arg3::Integer,arg4::Integer)
    ccall((:GDALRATSetValueAsInt,libgdal),Void,(Ptr{GDALRasterAttributeTableH},Cint,Cint,Cint),arg1,arg2,arg3,arg4)
end


"""
    GDALRATSetValueAsDouble(GDALRasterAttributeTableH,
                            int,
                            int,
                            double) -> void
Set field value from double.
"""
function ratsetvalueasdouble(arg1::Ptr{GDALRasterAttributeTableH},arg2::Integer,arg3::Integer,arg4::Real)
    ccall((:GDALRATSetValueAsDouble,libgdal),Void,(Ptr{GDALRasterAttributeTableH},Cint,Cint,Cdouble),arg1,arg2,arg3,arg4)
end


"""
    GDALRATChangesAreWrittenToFile(GDALRasterAttributeTableH hRAT) -> int
Determine whether changes made to this RAT are reflected directly in the dataset.
"""
function ratchangesarewrittentofile(hRAT::Ptr{GDALRasterAttributeTableH})
    ccall((:GDALRATChangesAreWrittenToFile,libgdal),Cint,(Ptr{GDALRasterAttributeTableH},),hRAT)
end


"""
    GDALRATValuesIOAsDouble(GDALRasterAttributeTableH hRAT,
                            GDALRWFlag eRWFlag,
                            int iField,
                            int iStartRow,
                            int iLength,
                            double * pdfData) -> CPLErr
Read or Write a block of doubles to/from the Attribute Table.
"""
function ratvaluesioasdouble(hRAT::Ptr{GDALRasterAttributeTableH},eRWFlag::GDALRWFlag,iField::Integer,iStartRow::Integer,iLength::Integer,pdfData)
    ccall((:GDALRATValuesIOAsDouble,libgdal),CPLErr,(Ptr{GDALRasterAttributeTableH},GDALRWFlag,Cint,Cint,Cint,Ptr{Cdouble}),hRAT,eRWFlag,iField,iStartRow,iLength,pdfData)
end


"""
    GDALRATValuesIOAsInteger(GDALRasterAttributeTableH hRAT,
                             GDALRWFlag eRWFlag,
                             int iField,
                             int iStartRow,
                             int iLength,
                             int * pnData) -> CPLErr
Read or Write a block of ints to/from the Attribute Table.
"""
function ratvaluesioasinteger(hRAT::Ptr{GDALRasterAttributeTableH},eRWFlag::GDALRWFlag,iField::Integer,iStartRow::Integer,iLength::Integer,pnData)
    ccall((:GDALRATValuesIOAsInteger,libgdal),CPLErr,(Ptr{GDALRasterAttributeTableH},GDALRWFlag,Cint,Cint,Cint,Ptr{Cint}),hRAT,eRWFlag,iField,iStartRow,iLength,pnData)
end


"""
    GDALRATValuesIOAsString(GDALRasterAttributeTableH hRAT,
                            GDALRWFlag eRWFlag,
                            int iField,
                            int iStartRow,
                            int iLength,
                            char ** papszStrList) -> CPLErr
Read or Write a block of strings to/from the Attribute Table.
"""
function ratvaluesioasstring(hRAT::Ptr{GDALRasterAttributeTableH},eRWFlag::GDALRWFlag,iField::Integer,iStartRow::Integer,iLength::Integer,papszStrList)
    ccall((:GDALRATValuesIOAsString,libgdal),CPLErr,(Ptr{GDALRasterAttributeTableH},GDALRWFlag,Cint,Cint,Cint,Ptr{Cstring}),hRAT,eRWFlag,iField,iStartRow,iLength,papszStrList)
end


"""
    GDALRATSetRowCount(GDALRasterAttributeTableH,
                       int) -> void
Set row count.
"""
function ratsetrowcount(arg1::Ptr{GDALRasterAttributeTableH},arg2::Integer)
    ccall((:GDALRATSetRowCount,libgdal),Void,(Ptr{GDALRasterAttributeTableH},Cint),arg1,arg2)
end


"""
    GDALRATCreateColumn(GDALRasterAttributeTableH,
                        const char *,
                        GDALRATFieldType,
                        GDALRATFieldUsage) -> CPLErr
Create new column.
"""
function ratcreatecolumn(arg1::Ptr{GDALRasterAttributeTableH},arg2,arg3::GDALRATFieldType,arg4::GDALRATFieldUsage)
    ccall((:GDALRATCreateColumn,libgdal),CPLErr,(Ptr{GDALRasterAttributeTableH},Cstring,GDALRATFieldType,GDALRATFieldUsage),arg1,arg2,arg3,arg4)
end


"""
    GDALRATSetLinearBinning(GDALRasterAttributeTableH,
                            double,
                            double) -> CPLErr
Set linear binning information.
"""
function ratsetlinearbinning(arg1::Ptr{GDALRasterAttributeTableH},arg2::Real,arg3::Real)
    ccall((:GDALRATSetLinearBinning,libgdal),CPLErr,(Ptr{GDALRasterAttributeTableH},Cdouble,Cdouble),arg1,arg2,arg3)
end


"""
    GDALRATGetLinearBinning(GDALRasterAttributeTableH,
                            double *,
                            double *) -> int
Get linear binning information.
"""
function ratgetlinearbinning(arg1::Ptr{GDALRasterAttributeTableH},arg2,arg3)
    ccall((:GDALRATGetLinearBinning,libgdal),Cint,(Ptr{GDALRasterAttributeTableH},Ptr{Cdouble},Ptr{Cdouble}),arg1,arg2,arg3)
end


"""
    GDALRATInitializeFromColorTable(GDALRasterAttributeTableH,
                                    GDALColorTableH) -> CPLErr
Initialize from color table.
"""
function ratinitializefromcolortable(arg1::Ptr{GDALRasterAttributeTableH},arg2::Ptr{GDALColorTableH})
    ccall((:GDALRATInitializeFromColorTable,libgdal),CPLErr,(Ptr{GDALRasterAttributeTableH},Ptr{GDALColorTableH}),arg1,arg2)
end


"""
    GDALRATTranslateToColorTable(GDALRasterAttributeTableH,
                                 int nEntryCount) -> GDALColorTableH
Translate to a color table.
"""
function rattranslatetocolortable(arg1::Ptr{GDALRasterAttributeTableH},nEntryCount::Integer)
    checknull(ccall((:GDALRATTranslateToColorTable,libgdal),Ptr{GDALColorTableH},(Ptr{GDALRasterAttributeTableH},Cint),arg1,nEntryCount))
end


"""
    GDALRATDumpReadable(GDALRasterAttributeTableH,
                        FILE *) -> void
Dump RAT in readable form.
"""
function ratdumpreadable(arg1::Ptr{GDALRasterAttributeTableH},arg2)
    ccall((:GDALRATDumpReadable,libgdal),Void,(Ptr{GDALRasterAttributeTableH},Ptr{FILE}),arg1,arg2)
end


"""
    GDALRATClone(GDALRasterAttributeTableH) -> GDALRasterAttributeTableH
Copy Raster Attribute Table.
"""
function ratclone(arg1::Ptr{GDALRasterAttributeTableH})
    checknull(ccall((:GDALRATClone,libgdal),Ptr{GDALRasterAttributeTableH},(Ptr{GDALRasterAttributeTableH},),arg1))
end


"""
    GDALRATSerializeJSON(GDALRasterAttributeTableH) -> void *
Serialize Raster Attribute Table in Json format.
"""
function ratserializejson(arg1::Ptr{GDALRasterAttributeTableH})
    ccall((:GDALRATSerializeJSON,libgdal),Ptr{Void},(Ptr{GDALRasterAttributeTableH},),arg1)
end


"""
    GDALRATGetRowOfValue(GDALRasterAttributeTableH,
                         double) -> int
Get row for pixel value.
"""
function ratgetrowofvalue(arg1::Ptr{GDALRasterAttributeTableH},arg2::Real)
    ccall((:GDALRATGetRowOfValue,libgdal),Cint,(Ptr{GDALRasterAttributeTableH},Cdouble),arg1,arg2)
end


"""
    GDALSetCacheMax(int nNewSizeInBytes) -> void
Set maximum cache memory.
### Parameters
* **nNewSizeInBytes**: the maximum number of bytes for caching.
"""
function setcachemax(nBytes::Integer)
    ccall((:GDALSetCacheMax,libgdal),Void,(Cint,),nBytes)
end


"""
    GDALGetCacheMax() -> int
Get maximum cache memory.
### Returns
maximum in bytes.
"""
function getcachemax()
    ccall((:GDALGetCacheMax,libgdal),Cint,())
end


"""
    GDALGetCacheUsed() -> int
Get cache memory used.
### Returns
the number of bytes of memory currently in use by the GDALRasterBlock memory caching.
"""
function getcacheused()
    ccall((:GDALGetCacheUsed,libgdal),Cint,())
end


"""
    GDALSetCacheMax64(GIntBig nNewSizeInBytes) -> void
Set maximum cache memory.
### Parameters
* **nNewSizeInBytes**: the maximum number of bytes for caching.
"""
function setcachemax64(nBytes::GIntBig)
    ccall((:GDALSetCacheMax64,libgdal),Void,(GIntBig,),nBytes)
end


"""
    GDALGetCacheMax64() -> GIntBig
Get maximum cache memory.
### Returns
maximum in bytes.
"""
function getcachemax64()
    ccall((:GDALGetCacheMax64,libgdal),GIntBig,())
end


"""
    GDALGetCacheUsed64() -> GIntBig
Get cache memory used.
### Returns
the number of bytes of memory currently in use by the GDALRasterBlock memory caching.
"""
function getcacheused64()
    ccall((:GDALGetCacheUsed64,libgdal),GIntBig,())
end


"""
    GDALFlushCacheBlock() -> int
Try to flush one cached raster block.
### Returns
TRUE if one block was flushed, FALSE if there are no cached blocks or if they are currently locked.
"""
function flushcacheblock()
    ccall((:GDALFlushCacheBlock,libgdal),Cint,())
end


"""
    GDALDatasetGetVirtualMem(GDALDatasetH hDS,
                             GDALRWFlag eRWFlag,
                             int nXOff,
                             int nYOff,
                             int nXSize,
                             int nYSize,
                             int nBufXSize,
                             int nBufYSize,
                             GDALDataType eBufType,
                             int nBandCount,
                             int * panBandMap,
                             int nPixelSpace,
                             GIntBig nLineSpace,
                             GIntBig nBandSpace,
                             size_t nCacheSize,
                             size_t nPageSizeHint,
                             int bSingleThreadUsage,
                             char ** papszOptions) -> CPLVirtualMem *
Create a CPLVirtualMem object from a GDAL dataset object.
### Parameters
* **hDS**: Dataset object
* **eRWFlag**: Either GF_Read to read a region of data, or GF_Write to write a region of data.
* **nXOff**: The pixel offset to the top left corner of the region of the band to be accessed. This would be zero to start from the left side.
* **nYOff**: The line offset to the top left corner of the region of the band to be accessed. This would be zero to start from the top.
* **nXSize**: The width of the region of the band to be accessed in pixels.
* **nYSize**: The height of the region of the band to be accessed in lines.
* **nBufXSize**: the width of the buffer image into which the desired region is to be read, or from which it is to be written.
* **nBufYSize**: the height of the buffer image into which the desired region is to be read, or from which it is to be written.
* **eBufType**: the type of the pixel values in the data buffer. The pixel values will automatically be translated to/from the GDALRasterBand data type as needed.
* **nBandCount**: the number of bands being read or written.
* **panBandMap**: the list of nBandCount band numbers being read/written. Note band numbers are 1 based. This may be NULL to select the first nBandCount bands.
* **nPixelSpace**: The byte offset from the start of one pixel value in the buffer to the start of the next pixel value within a scanline. If defaulted (0) the size of the datatype eBufType is used.
* **nLineSpace**: The byte offset from the start of one scanline in the buffer to the start of the next. If defaulted (0) the size of the datatype eBufType * nBufXSize is used.
* **nBandSpace**: the byte offset from the start of one bands data to the start of the next. If defaulted (0) the value will be nLineSpace * nBufYSize implying band sequential organization of the data buffer.
* **nCacheSize**: size in bytes of the maximum memory that will be really allocated (must ideally fit into RAM)
* **nPageSizeHint**: hint for the page size. Must be a multiple of the system page size, returned by CPLGetPageSize(). Minimum value is generally 4096. Might be set to 0 to let the function determine a default page size.
* **bSingleThreadUsage**: set to TRUE if there will be no concurrent threads that will access the virtual memory mapping. This can optimize performance a bit. If set to FALSE, CPLVirtualMemDeclareThread() must be called.
* **papszOptions**: NULL terminated list of options. Unused for now.
### Returns
a virtual memory object that must be freed by CPLVirtualMemFree(), or NULL in case of failure.
"""
function datasetgetvirtualmem{T <: GDALDatasetH}(hDS::Ptr{T},eRWFlag::GDALRWFlag,nXOff::Integer,nYOff::Integer,nXSize::Integer,nYSize::Integer,nBufXSize::Integer,nBufYSize::Integer,eBufType::GDALDataType,nBandCount::Integer,panBandMap,nPixelSpace::Integer,nLineSpace::GIntBig,nBandSpace::GIntBig,nCacheSize::Csize_t,nPageSizeHint::Csize_t,bSingleThreadUsage::Integer,papszOptions)
    ccall((:GDALDatasetGetVirtualMem,libgdal),Ptr{CPLVirtualMem},(Ptr{GDALDatasetH},GDALRWFlag,Cint,Cint,Cint,Cint,Cint,Cint,GDALDataType,Cint,Ptr{Cint},Cint,GIntBig,GIntBig,Csize_t,Csize_t,Cint,Ptr{Cstring}),hDS,eRWFlag,nXOff,nYOff,nXSize,nYSize,nBufXSize,nBufYSize,eBufType,nBandCount,panBandMap,nPixelSpace,nLineSpace,nBandSpace,nCacheSize,nPageSizeHint,bSingleThreadUsage,papszOptions)
end


"""
    GDALRasterBandGetVirtualMem(GDALRasterBandH hBand,
                                GDALRWFlag eRWFlag,
                                int nXOff,
                                int nYOff,
                                int nXSize,
                                int nYSize,
                                int nBufXSize,
                                int nBufYSize,
                                GDALDataType eBufType,
                                int nPixelSpace,
                                GIntBig nLineSpace,
                                size_t nCacheSize,
                                size_t nPageSizeHint,
                                int bSingleThreadUsage,
                                char ** papszOptions) -> CPLVirtualMem *
Create a CPLVirtualMem object from a GDAL raster band object.
### Parameters
* **hBand**: Rasterband object
* **eRWFlag**: Either GF_Read to read a region of data, or GF_Write to write a region of data.
* **nXOff**: The pixel offset to the top left corner of the region of the band to be accessed. This would be zero to start from the left side.
* **nYOff**: The line offset to the top left corner of the region of the band to be accessed. This would be zero to start from the top.
* **nXSize**: The width of the region of the band to be accessed in pixels.
* **nYSize**: The height of the region of the band to be accessed in lines.
* **nBufXSize**: the width of the buffer image into which the desired region is to be read, or from which it is to be written.
* **nBufYSize**: the height of the buffer image into which the desired region is to be read, or from which it is to be written.
* **eBufType**: the type of the pixel values in the data buffer. The pixel values will automatically be translated to/from the GDALRasterBand data type as needed.
* **nPixelSpace**: The byte offset from the start of one pixel value in the buffer to the start of the next pixel value within a scanline. If defaulted (0) the size of the datatype eBufType is used.
* **nLineSpace**: The byte offset from the start of one scanline in the buffer to the start of the next. If defaulted (0) the size of the datatype eBufType * nBufXSize is used.
* **nCacheSize**: size in bytes of the maximum memory that will be really allocated (must ideally fit into RAM)
* **nPageSizeHint**: hint for the page size. Must be a multiple of the system page size, returned by CPLGetPageSize(). Minimum value is generally 4096. Might be set to 0 to let the function determine a default page size.
* **bSingleThreadUsage**: set to TRUE if there will be no concurrent threads that will access the virtual memory mapping. This can optimize performance a bit. If set to FALSE, CPLVirtualMemDeclareThread() must be called.
* **papszOptions**: NULL terminated list of options. Unused for now.
### Returns
a virtual memory object that must be freed by CPLVirtualMemFree(), or NULL in case of failure.
"""
function rasterbandgetvirtualmem{T <: GDALRasterBandH}(hBand::Ptr{T},eRWFlag::GDALRWFlag,nXOff::Integer,nYOff::Integer,nXSize::Integer,nYSize::Integer,nBufXSize::Integer,nBufYSize::Integer,eBufType::GDALDataType,nPixelSpace::Integer,nLineSpace::GIntBig,nCacheSize::Csize_t,nPageSizeHint::Csize_t,bSingleThreadUsage::Integer,papszOptions)
    ccall((:GDALRasterBandGetVirtualMem,libgdal),Ptr{CPLVirtualMem},(Ptr{GDALRasterBandH},GDALRWFlag,Cint,Cint,Cint,Cint,Cint,Cint,GDALDataType,Cint,GIntBig,Csize_t,Csize_t,Cint,Ptr{Cstring}),hBand,eRWFlag,nXOff,nYOff,nXSize,nYSize,nBufXSize,nBufYSize,eBufType,nPixelSpace,nLineSpace,nCacheSize,nPageSizeHint,bSingleThreadUsage,papszOptions)
end


"""
    GDALGetVirtualMemAuto(GDALRasterBandH hBand,
                          GDALRWFlag eRWFlag,
                          int * pnPixelSpace,
                          GIntBig * pnLineSpace,
                          char ** papszOptions) -> CPLVirtualMem *
Create a CPLVirtualMem object from a GDAL raster band object.
"""
function getvirtualmemauto{T <: GDALRasterBandH}(hBand::Ptr{T},eRWFlag::GDALRWFlag,pnPixelSpace,pnLineSpace,papszOptions)
    ccall((:GDALGetVirtualMemAuto,libgdal),Ptr{CPLVirtualMem},(Ptr{GDALRasterBandH},GDALRWFlag,Ptr{Cint},Ptr{GIntBig},Ptr{Cstring}),hBand,eRWFlag,pnPixelSpace,pnLineSpace,papszOptions)
end


"""
    GDALDatasetGetTiledVirtualMem(GDALDatasetH hDS,
                                  GDALRWFlag eRWFlag,
                                  int nXOff,
                                  int nYOff,
                                  int nXSize,
                                  int nYSize,
                                  int nTileXSize,
                                  int nTileYSize,
                                  GDALDataType eBufType,
                                  int nBandCount,
                                  int * panBandMap,
                                  GDALTileOrganization eTileOrganization,
                                  size_t nCacheSize,
                                  int bSingleThreadUsage,
                                  char ** papszOptions) -> CPLVirtualMem *
Create a CPLVirtualMem object from a GDAL dataset object, with tiling organization.
### Parameters
* **hDS**: Dataset object
* **eRWFlag**: Either GF_Read to read a region of data, or GF_Write to write a region of data.
* **nXOff**: The pixel offset to the top left corner of the region of the band to be accessed. This would be zero to start from the left side.
* **nYOff**: The line offset to the top left corner of the region of the band to be accessed. This would be zero to start from the top.
* **nXSize**: The width of the region of the band to be accessed in pixels.
* **nYSize**: The height of the region of the band to be accessed in lines.
* **nTileXSize**: the width of the tiles.
* **nTileYSize**: the height of the tiles.
* **eBufType**: the type of the pixel values in the data buffer. The pixel values will automatically be translated to/from the GDALRasterBand data type as needed.
* **nBandCount**: the number of bands being read or written.
* **panBandMap**: the list of nBandCount band numbers being read/written. Note band numbers are 1 based. This may be NULL to select the first nBandCount bands.
* **eTileOrganization**: tile organization.
* **nCacheSize**: size in bytes of the maximum memory that will be really allocated (must ideally fit into RAM)
* **bSingleThreadUsage**: set to TRUE if there will be no concurrent threads that will access the virtual memory mapping. This can optimize performance a bit. If set to FALSE, CPLVirtualMemDeclareThread() must be called.
* **papszOptions**: NULL terminated list of options. Unused for now.
### Returns
a virtual memory object that must be freed by CPLVirtualMemFree(), or NULL in case of failure.
"""
function datasetgettiledvirtualmem{T <: GDALDatasetH}(hDS::Ptr{T},eRWFlag::GDALRWFlag,nXOff::Integer,nYOff::Integer,nXSize::Integer,nYSize::Integer,nTileXSize::Integer,nTileYSize::Integer,eBufType::GDALDataType,nBandCount::Integer,panBandMap,eTileOrganization::GDALTileOrganization,nCacheSize::Csize_t,bSingleThreadUsage::Integer,papszOptions)
    ccall((:GDALDatasetGetTiledVirtualMem,libgdal),Ptr{CPLVirtualMem},(Ptr{GDALDatasetH},GDALRWFlag,Cint,Cint,Cint,Cint,Cint,Cint,GDALDataType,Cint,Ptr{Cint},GDALTileOrganization,Csize_t,Cint,Ptr{Cstring}),hDS,eRWFlag,nXOff,nYOff,nXSize,nYSize,nTileXSize,nTileYSize,eBufType,nBandCount,panBandMap,eTileOrganization,nCacheSize,bSingleThreadUsage,papszOptions)
end


"""
    GDALRasterBandGetTiledVirtualMem(GDALRasterBandH hBand,
                                     GDALRWFlag eRWFlag,
                                     int nXOff,
                                     int nYOff,
                                     int nXSize,
                                     int nYSize,
                                     int nTileXSize,
                                     int nTileYSize,
                                     GDALDataType eBufType,
                                     size_t nCacheSize,
                                     int bSingleThreadUsage,
                                     char ** papszOptions) -> CPLVirtualMem *
Create a CPLVirtualMem object from a GDAL rasterband object, with tiling organization.
### Parameters
* **hBand**: Rasterband object
* **eRWFlag**: Either GF_Read to read a region of data, or GF_Write to write a region of data.
* **nXOff**: The pixel offset to the top left corner of the region of the band to be accessed. This would be zero to start from the left side.
* **nYOff**: The line offset to the top left corner of the region of the band to be accessed. This would be zero to start from the top.
* **nXSize**: The width of the region of the band to be accessed in pixels.
* **nYSize**: The height of the region of the band to be accessed in lines.
* **nTileXSize**: the width of the tiles.
* **nTileYSize**: the height of the tiles.
* **eBufType**: the type of the pixel values in the data buffer. The pixel values will automatically be translated to/from the GDALRasterBand data type as needed.
* **nCacheSize**: size in bytes of the maximum memory that will be really allocated (must ideally fit into RAM)
* **bSingleThreadUsage**: set to TRUE if there will be no concurrent threads that will access the virtual memory mapping. This can optimize performance a bit. If set to FALSE, CPLVirtualMemDeclareThread() must be called.
* **papszOptions**: NULL terminated list of options. Unused for now.
### Returns
a virtual memory object that must be freed by CPLVirtualMemFree(), or NULL in case of failure.
"""
function rasterbandgettiledvirtualmem{T <: GDALRasterBandH}(hBand::Ptr{T},eRWFlag::GDALRWFlag,nXOff::Integer,nYOff::Integer,nXSize::Integer,nYSize::Integer,nTileXSize::Integer,nTileYSize::Integer,eBufType::GDALDataType,nCacheSize::Csize_t,bSingleThreadUsage::Integer,papszOptions)
    ccall((:GDALRasterBandGetTiledVirtualMem,libgdal),Ptr{CPLVirtualMem},(Ptr{GDALRasterBandH},GDALRWFlag,Cint,Cint,Cint,Cint,Cint,Cint,GDALDataType,Csize_t,Cint,Ptr{Cstring}),hBand,eRWFlag,nXOff,nYOff,nXSize,nYSize,nTileXSize,nTileYSize,eBufType,nCacheSize,bSingleThreadUsage,papszOptions)
end


"""
    GDALCreatePansharpenedVRT(const char * pszXML,
                              GDALRasterBandH hPanchroBand,
                              int nInputSpectralBands,
                              GDALRasterBandH * pahInputSpectralBands) -> GDALDatasetH
Create a virtual pansharpened dataset.
### Parameters
* **pszXML**: Pansharpened VRT XML where <SpectralBand> elements have no explicit SourceFilename and SourceBand. The spectral bands in the XML will be assigned the successive values of the pahInputSpectralBands array. Must not be NULL.
* **hPanchroBand**: Panchromatic band. Must not be NULL.
* **nInputSpectralBands**: Number of input spectral bands. Must be greater than zero.
* **pahInputSpectralBands**: Array of nInputSpectralBands spectral bands.
### Returns
NULL on failure, or a new virtual dataset handle on success to be closed with GDALClose().
"""
function createpansharpenedvrt{T <: GDALRasterBandH}(pszXML,hPanchroBand::Ptr{T},nInputSpectralBands::Integer,pahInputSpectralBands)
    checknull(ccall((:GDALCreatePansharpenedVRT,libgdal),Ptr{GDALDatasetH},(Cstring,Ptr{GDALRasterBandH},Cint,Ptr{GDALRasterBandH}),pszXML,hPanchroBand,nInputSpectralBands,pahInputSpectralBands))
end
