SuperStrict

Import "TRect.bmx"

' The TLens is a square lens that has position on the screen and a viewport of the source image
Type TLens
	Field position:TRect, viewport:TRect
	Field selected:Int = False
	
	' These Split methods assume you've not swapped views yet as they also return a split view
	Method SplitHorizontal:TLens[]()
		Local a:TLens = New TLens
		Local b:TLens = New Tlens
		Local splitPositions:TRect[] = position.SplitHorizontal()
		Local splitViewports:TRect[] = viewport.SplitHorizontal()
		a.position = splitPositions[0]
		a.viewport = splitViewports[0]
		b.position = splitPositions[1]
		b.viewport = splitViewports[1]
		Return [a, b]
	End Method
	
	Method SplitVertical:TLens[]()
		Local a:TLens = New TLens
		Local b:TLens = New Tlens
		Local splitPositions:TRect[] = position.SplitVertical()
		Local splitViewports:TRect[] = viewport.SplitVertical()
		a.position = splitPositions[0]
		a.viewport = splitViewports[0]
		b.position = splitPositions[1]
		b.viewport = splitViewports[1]
		Return [a, b]
	End Method
	
	Method SwapViewport(Other:TLens)
		Local temp:TRect = viewport
		viewport = Other.viewport
		other.viewport = temp
	End Method
	
	Method viewportIsPosition:Int()
		' This is a check to see the the viewport rectangle matches the position
		' this lens is "solved" if so
		Return viewport.equal(position)
	End Method
End Type
