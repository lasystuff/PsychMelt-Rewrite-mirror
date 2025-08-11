import StringTools;

function onEvent(eventName, value1, value2)
{
	if (eventName == 'Hey!')
	{
		var value:Int = 2;
		switch (StringTools.trim(value1.toLowerCase()))
		{
			case 'bf':
				value = 0;
			case 'boyfriend':
				value = 0;
			case '0':
				value = 0;
			case 'gf':
				value = 1;
			case 'girlfriend':
				value = 1;
			case '1':
				value = 1;

			var time:Float = Std.parseFloat(value2);
			if (Math.isNaN(time) || time <= 0)
				time = 0.6;

			if (value != 0)
			{
				if (StringTools.startsWith(dad.curCharacter, 'gf'))
				{ // Tutorial GF is actually Dad! The GF is an imposter!! ding ding ding ding ding ding ding, dindinding, end my suffering
					dad.playAnim('cheer', true);
					dad.specialAnim = true;
					dad.heyTimer = time;
				}
				else if (gf != null)
				{
					gf.playAnim('cheer', true);
					gf.specialAnim = true;
					gf.heyTimer = time;
				}
			}
			if (value != 1)
			{
				boyfriend.playAnim('hey', true);
				boyfriend.specialAnim = true;
				boyfriend.heyTimer = time;
			}
		}
	}
}
