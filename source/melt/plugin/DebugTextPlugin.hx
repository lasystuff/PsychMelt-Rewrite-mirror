package melt.plugin;

import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.text.FlxText;

class DebugTextPlugin extends FlxTypedGroup<DebugText>
{
	public static var instance:DebugTextPlugin;

	public static function init()
	{
		FlxG.plugins.drawOnTop = true;

		var plugin = new DebugTextPlugin();
		instance = plugin;
		FlxG.plugins.addPlugin(instance);
	}

	public static function addTextToDebug(text:String, color:FlxColor)
	{
		instance.forEachAlive(function(spr:DebugText)
		{
			spr.y += 20;
		});

		if (instance.members.length > 34)
		{
			var blah = instance.members[34];
			blah.destroy();
			instance.remove(blah, true);
		}
		instance.insert(0, new DebugText(text, instance, color));
	}
}


class DebugText extends FlxText
{
	private var disableTime:Float = 6;
	public var parentGroup:FlxTypedGroup<DebugText>;
	public function new(text:String, parentGroup:FlxTypedGroup<DebugText>, color:FlxColor) {
		this.parentGroup = parentGroup;
		super(10, 10, 0, text, 16);
		setFormat(Paths.font("vcr.ttf"), 20, color, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scrollFactor.set();
		borderSize = 1;
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		disableTime -= elapsed;
		if(disableTime < 0) disableTime = 0;
		if(disableTime < 1) alpha = disableTime;
	}
}