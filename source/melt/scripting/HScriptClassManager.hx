package melt.scripting;

import flixel.FlxG;

class HScriptClassManager
{
	public var instance:HScriptClassManager;

	public static function init():Void
	{
		if (instance != null)
		{
			"Error: HScriptClassManager is already initalized!";
			return;
		}

		instance = new HScriptClassManager();


		var directories:Array<String> = [];

		for (file in readDirectoryRecursive("source/"))
	}

	public function new(){}
}
