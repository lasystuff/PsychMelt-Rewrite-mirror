function onEvent(eventName, value1, value2)
{
	if (eventName == 'Set GF Speed')
	{
		var value:Int = Std.parseInt(value1);
		if (Math.isNaN(value) || value < 1)
			value = 1;
		gfSpeed = value;
	}
}