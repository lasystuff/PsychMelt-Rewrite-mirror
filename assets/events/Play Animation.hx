import StringTools;

function onEvent(eventName, value1, value2)
{
	if (eventName == 'Play Animation')
	{
		var char:Character = dad;
		switch (StringTools.trim(value2.toLowerCase()))
		{
			case 'bf':
				char = boyfriend;
			case 'boyfriend':
				char = boyfriend;
			case 'gf':
				char = gf;
			case 'girlfriend':
				char = gf;
			default:
				var val2:Int = Std.parseInt(value2);
				if (Math.isNaN(val2))
					val2 = 0;

				switch (val2)
				{
					case 1: char = boyfriend;
					case 2: char = gf;
				}
		}

		if (char != null)
		{
			char.playAnim(value1, true);
			char.specialAnim = true;
		}
	}
}