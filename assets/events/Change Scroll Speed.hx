function onEvent(eventName, value1, value2)
{
	if (eventName == 'Change Scroll Speed')
	{
		if (songSpeedType == "constant")
			return;
		var val1:Float = Std.parseFloat(value1);
		var val2:Float = Std.parseFloat(value2);
		if (Math.isNaN(val1))
			val1 = 1;
		if (Math.isNaN(val2))
			val2 = 0;

		final newValue:Float = SONG.speed * ClientPrefs.getGameplaySetting('scrollspeed', 1) * val1;

		if (val2 <= 0)
		{
			songSpeed = newValue;
		}
		else
		{
			songSpeedTween = FlxTween.tween(this, {songSpeed: newValue}, val2 / playbackRate, {
				ease: FlxEase.linear,
				onComplete: function(twn:FlxTween)
				{
					songSpeedTween = null;
				}
			});
		}
	}
}