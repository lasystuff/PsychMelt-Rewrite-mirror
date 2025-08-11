import StringTools;

function onEvent(eventName, value1, value2)
{
	if (eventName == 'Alt Idle Animation')
	{
		var char:Character = dad;
		switch (StringTools.trim(value1.toLowerCase()))
		{
			case 'gf':
				char = gf;
			case 'girlfriend':
				char = gf;
			case 'bf':
				char = boyfriend;
			case 'boyfriend':
				char = boyfriend;
			default:
				var val:Int = Std.parseInt(value1);
				if (Math.isNaN(val))
					val = 0;

				switch (val)
				{
					case 1: char = boyfriend;
					case 2: char = gf;
				}
		}

		if (char != null)
		{
			char.idleSuffix = value2;
			char.recalculateDanceIdle();
		}
	}
}