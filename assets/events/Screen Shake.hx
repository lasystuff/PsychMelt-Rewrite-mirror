function onEvent(eventName, value1, value2)
{
	if (eventName == 'Screen Shake')
	{
		var valuesArray:Array<String> = [value1, value2];
		var targetsArray:Array<FlxCamera> = [camGame, camHUD];
		for (i in 0...targetsArray.length)
		{
			var split:Array<String> = valuesArray[i].split(',');
			var duration:Float = 0;
			var intensity:Float = 0;
			if (split[0] != null)
				duration = Std.parseFloat(StringTools.trim(split[0]));
			if (split[1] != null)
			intensity = Std.parseFloat(StringTools.trim(split[1]));
			if (Math.isNaN(duration))
				duration = 0;
			if (Math.isNaN(intensity))
				intensity = 0;

			if (duration > 0 && intensity != 0)
			{
				targetsArray[i].shake(intensity, duration);
			}
		}
	}
}