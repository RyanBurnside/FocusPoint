SuperStrict 

Type TRect
	Field x:Float = 0, y:Float = 0, x2:Float = 1, y2:Float = 1
	
	Method New(x:Float, y:Float, x2:Float, y2:Float)
		Self.Set(x, y, x2, y2)
	End Method
	
	Method Set(x:Float, y:Float, x2:Float, y2:Float)
		Self.x = x
		Self.y = y
		Self.x2 = x2
		Self.y2 = y2
	End Method
	
	Method GetWidth:Float()
		Return Abs(x - x2)
	End Method
	
	Method GetHeight:Float()
		Return Abs(y - y2)
	End Method
	
	Method PointInside:Int(ptx:Float, pty:Float)
		' We consider on the right or bottom edge outside to account for overlap
		If ptx < x Then Return False
		If pty < y Then Return False
		If ptx >= x2 Then Return False
		If pty >= y2 Then Return False
		Return True
	End Method
	
	Method Split:TRect[](horizontal:Int = True)
		Local midx:Float = GetWidth() * 0.5 + x
		Local midy:Float = GetHeight() * 0.5 + y
		If horizontal
			Return [New TRect(x, y, midx, y2), New TRect(midx, y, x2 , y2)]
		Else 
			Return [New TRect(x, y, x2, midy), New TRect(x, midy, x2 , y2)]
		End If 
	End Method
End Type