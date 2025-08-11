function onEvent(eventName, value1, value2)
{
	if (eventName == 'Camera Follow Pos')
	{
		if (camFollowPos != null)
		{
			var val1:Float = Std.parseFloat(value1);
			var val2:Float = Std.parseFloat(value2);
			if (Math.isNaN(val1))
				val1 = 0;
			if (Math.isNaN(val2))
				val2 = 0;

			isCameraOnForcedPos = false;
			if (!Math.isNaN(Std.parseFloat(value1)) || !Math.isNaN(Std.parseFloat(value2)))
			{
				camFollowPos.x = val1;
				camFollowPos.y = val2;
				isCameraOnForcedPos = true;
			}
		}
	}
}