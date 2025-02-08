SuperStrict

Import BRL.Filesystem ' Ensure filesystem functions are available

Function collectImages:TList(path:String)
    Local images:TList = New TList()
    recursiveCollect(path, images)
    Return images
End Function

Function recursiveCollect(path:String, images:TList)
    Local dir:Byte Ptr = ReadDir(path) ' Open the directory
    If Not dir RuntimeError "Failed to read directory: " + path

    Local entry:String = NextFile(dir)
    While entry <> "" ' Process directory entries
        If entry = "." Or entry = ".." 
            entry = NextFile(dir)
            Continue ' Skip special directories	
        EndIf

        Local fullPath:String = StripSlash(path) + "/" + entry 'TODO dix for Windows.
        If FileType(fullPath) = FILETYPE_FILE
            Local ext:String = Lower(ExtractExt(fullPath))
            If ext = "png" Or ext = "jpg" Or ext = "jpeg"
                images.AddLast(fullPath)
            EndIf
        ElseIf FileType(fullPath) = FILETYPE_DIR
            RecursiveCollect(fullPath, images)
        EndIf
        
        entry = NextFile(dir) ' Move to the next file
    Wend

    CloseDir(dir) ' Close the directory stream
End Function

	