local pdfImageConverter = require("plugin.pdfImageConverter")
local widget = require("widget")
local bg = display.newRect( display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight )
bg:setFillColor( .5,0,0 )

local title = display.newText( "Pdf Image Converter", display.contentCenterX, 30, native.systemFontBold, 20 )

local function doesFileExist( fname, path )
 
    local results = false
 
    -- Path for the file
    local filePath = system.pathForFile( fname, path )
 
    if ( filePath ) then
        local file, errorString = io.open( filePath, "r" )
 
        if not file then
            -- Error occurred; output the cause
            print( "File error: " .. errorString )
        else
            -- File exists!
            print( "File found: " .. fname )
            results = true
            -- Close the file handle
            file:close()
        end
    end
 
    return results
end
function copyFile( srcName, srcPath, dstName, dstPath, overwrite )
 
    local results = false
 
    local fileExists = doesFileExist( srcName, srcPath )
    if ( fileExists == false ) then
        return nil  -- nil = Source file not found
    end
 
    -- Check to see if destination file already exists
    if not ( overwrite ) then
        if ( fileLib.doesFileExist( dstName, dstPath ) ) then
            return 1  -- 1 = File already exists (don't overwrite)
        end
    end
 
    -- Copy the source file to the destination file
    local rFilePath = system.pathForFile( srcName, srcPath )
    local wFilePath = system.pathForFile( dstName, dstPath )
 
    local rfh = io.open( rFilePath, "rb" )
    local wfh, errorString = io.open( wFilePath, "wb" )
 
    if not ( wfh ) then
        -- Error occurred; output the cause
        print( "File error: " .. errorString )
        return false
    else
        -- Read the file and write to the destination directory
        local data = rfh:read( "*a" )
        if not ( data ) then
            print( "Read error!" )
            return false
        else
            if not ( wfh:write( data ) ) then
                print( "Write error!" )
                return false
            end
        end
    end
 
    results = 2  -- 2 = File copied successfully!
 
    -- Close file handles
    rfh:close()
    wfh:close()
 
    return results
end
copyFile( "coronaImage.png.txt", nil, "coronaImage.png", system.DocumentsDirectory, true )

local pdfToImage= widget.newButton( {
    x = display.contentCenterX,
    y = display.contentCenterY-150,
    label = "Pdf to Image",
    onRelease = function (  )
       pdfImageConverter.toImage(system.pathForFile( "sample.pdf"), nil,system.pathForFile("pdfImage.jpeg", system.DocumentsDirectory))
     local pdfImage = display.newImage( "pdfImage.jpeg", system.DocumentsDirectory)
     pdfImage:scale( .2, .2 )
     pdfImage.x = display.contentCenterX
     pdfImage.y = display.contentCenterY-50
    end
} )

local imageToPdf= widget.newButton( {
   x = display.contentCenterX,
   y = display.contentCenterY+50,
   label = "Image to Pdf",
   onRelease = function (  )
      pdfImageConverter.toPdf(system.pathForFile("coronaImage.png", system.DocumentsDirectory), system.pathForFile("corona.pdf", system.DocumentsDirectory))
      if (system.getInfo("environment") == "device" and system.getInfo("platform") == "ios") then
        local quickLookOptions = 
        {
            files =
            {
                { filename="corona.pdf", baseDir=system.DocumentsDirectory },
            },
            startIndex = 1,
        }
         
        native.showPopup( "quickLook", quickLookOptions )
      elseif system.getInfo("environment") == "device" then
        pdfImageConverter.toImage(system.pathForFile( "corona.pdf", system.DocumentsDirectory), nil,system.pathForFile("pdfImage2.jpeg", system.DocumentsDirectory))
        local pdfImage = display.newImage( "pdfImage2.jpeg", system.DocumentsDirectory )
        pdfImage:scale( .2, .2 )
        pdfImage.x = display.contentCenterX
        pdfImage.y = display.contentCenterY+120
      end
   end
} )
