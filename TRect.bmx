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
	
	Method SplitHorizontal:TRect[]()
		Local midx:Float = GetWidth() * 0.5 + x
		Local a:TRect  = New TRect(x, y, midx, y2)
		Local b:Trect  = New TRect(midx, y, x2 , y2)
		Return [a, b]
	End Method
	
	Method SplitVertical:TRect[]()
		Local midy:Float = GetHeight() * 0.5 + y
		Local a:TRect  = New TRect(x, y, x2, midy)
		Local b:Trect  = New TRect(x, midy, x2 , y2)
		Return [a, b]
	End Method
	
		
	Method equal:Int(other:TRect)
	' Check to see that two rects are the same values (not identity)
		If x <> other.x Return False
		If y <> other.y Return False
		If x2 <> other.x2 Return False
		If y2 <> other.y2 Return False
		Return True
	End Method
End Type