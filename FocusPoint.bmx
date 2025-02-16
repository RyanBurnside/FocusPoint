SuperStrict

' This is a simple desktop version of the Focus Point style Puzzles from 
' Microsoft's Pandora's Box. Credit goes to Alexey Pajitnov for the original
' concept. 

' This software is provided as-is for non-commercial use
' You will need BlitzMax NG installed

' This version has only been tested on Linux


Import "TRect.bmx"
Import "TLens.bmx"
Import "misc.bmx"

Function drawRectOutline(x:Float, y:Float, x2:Float, y2:Float)
	DrawLine x, y, x, y2 
	DrawLine x, y, x2, y 
	DrawLine x, y2, x2, y2 
	DrawLine x2, y, x2, y2 
End Function

Function drawLens(lens:TLens, source:TImage)
	Local color:Int[3] ' temporary overwrite for current color
	Local lineWidth:Int = GetLineWidth()
	GetColor color[0], color[1], color[2]
	
	If lens.selected
		SetColor 255, 127, 127 
	Else 
		SetColor 255, 255, 255
	EndIf
	DrawSubImageRect(source, lens.position.x, lens.position.y, lens.position.GetWidth(), lens.position.GetHeight(),
					lens.viewport.x, lens.viewport.y, lens.viewport.GetWidth(), lens.viewport.GetHeight())
	SetColor color[0], color[1], color[2]
	drawRectOutline(lens.position.x, lens.position.y, lens.position.x2, lens.position.y2)
	SetLineWidth lineWidth
End Function

Function renderLenses(lensList:TObjectList, background:TImage)
	For Local l:TLens = EachIn lensList
		drawLens l, background
	Next
End Function

Function checkSolved:Int(lensList:TObjectList)
	' Iterate through all lenses if any aren't on the right view return false
	For Local l:TLens = EachIn lensList
		If Not l.viewportIsPosition() Then Return False
	Next
	Return True
End Function

Function updateLenses(lensList:TObjectList)
	Local numSelected:Int = 0
	Local swapQueue:TObjectList = New TObjectList() ' take two swap em at the endif > 1
	Local clicked:Int = MouseDown(MOUSE_LEFT)
	FlushMouse()
	For Local l:TLens = EachIn lensList
		' We only allow marking 1
		Local inside:Int = l.position.PointInside(MouseX(), MouseY())

		Select True
		Case l.selected And Not inside
			swapQueue.AddLast(l)
		Case clicked And inside
			If Not l.selected 
				l.selected = True
				swapQueue.AddLast(l)
			Else
				l.selected = False
			End If 
		Case swapQueue.Count() > 1 
			Exit ' early return, no more than 2 get to be swapped
		End Select
	Next
	
	' handle swapping if swapQueue is populated by 2 
	If swapQueue.Count() > 1
		Local lens:TLens = TLens(swapQueue.RemoveFirst())
		Local lens2:TLens = TLens(swapQueue.RemoveFirst())
		lens.swapViewport(lens2)
		lens.selected  = False
		lens2.selected = False
	End If 
End Function 

Function shuffleList:TObjectList(list:TObjectList)
	' Mutates the sent list and returns it
	If list.IsEmpty() Then Return list
	
	Local array:Object[] = list.ToArray()
	Local size:Int = list.count()
	list.Clear()
	
	For Local i:Int = 0 Until size
		Local otherIndex:Int = Rand(0, size - 1)
		Local temp:Object = array[i]
		array[i] = array[otherIndex]
		array[otherIndex] = temp 
	Next
	
	For Local o:Object = EachIn array
		list.AddLast(o)
	Next
	Return list
End Function

Function subdivide:TObjectList(lenses:TObjectList, iterations:Int = 5, divisionsPerIteration:Int = 3)
	' This function takes a list of lenses (usually 1) and subdivides them randomly into new lenses
	For Local i:Int = 0 To iterations
		shufflelist(lenses)
		For Local subs:Int = 0 To divisionsPerIteration
			Local temp:Object = lenses.RemoveFirst()
			If TLens(temp).viewport.GetWidth() > TLens(temp).viewport.GetHeight()
				For Local l:TLens = EachIn TLens(temp).SplitHorizontal()
					lenses.AddLast(l)
				Next
			Else
				For Local l:TLens = EachIn TLens(temp).SplitVertical()
					lenses.AddLast(l)
				Next
			End If
		Next
	Next

	' The shuffling of owned images
	For Local i:Object = EachIn lenses
		TLens(i).SwapViewport(TLens(lenses.ValueAtIndex(Rand(0, lenses.count() - 1))))
	Next
End Function

Function pickRandImage:TImage(directory:String)
	Local imageList:TList = collectImages("./Images")
	If imageList.Count() < 1 Then RuntimeError "No images placed under Images directory."
	Return LoadImage(imageList.ValueAtIndex(Rand(0, imageList.count() - 1)), 0)
End Function

Function resetBackground:TImage(lenses:TObjectList)
	Local background:TImage = pickRandImage("./Images")
	lenses.Clear()
	
	Local t:TLens = New TLens
	t.position = New TRect(0, 0, background.width - 1, background.height - 1)
	t.viewport = New TRect(0, 0, background.width - 1, background.height - 1)
	lenses.AddLast(t)
	subdivide(lenses)
	Return background
End Function
	
Function Main()
	SeedRnd MilliSecs()	
	Local lenses:TObjectList = New TObjectList
	Local background:TImage = resetBackground(lenses)

	AppTitle = "Focus Point Puzzle - Original Concept Alexey Pajitnov"
	Graphics background.width, background.height

	' Driver loop 
	While Not (KeyDown(KEY_ESCAPE) Or KeyDown(KEY_Q))
		Cls
		If KeyHit(KEY_SPACE)
			background:TImage = resetBackground(lenses)
			EndGraphics()
			Graphics background.width, background.height
		EndIf
		SetColor 255, 0, 0	
		updateLenses(lenses)
		renderLenses(lenses, background)
		If checkSolved(lenses)
			DrawText("SOLVED", 32 ,32)
		EndIf
		Flip	
	Wend
End Function

' Entry point
Main()

