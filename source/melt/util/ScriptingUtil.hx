package melt.util;

import melt.scripting.FunkinRule;
import melt.gameplay.PlayState;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;

using StringTools;

class ScriptingUtil
{
	public static function buildVariables(script:IFunkinScript)
	{
		script.setVar("Paths", Paths);
        script.setVar("Character", Character);
        script.setVar("CoolUtil", CoolUtil);
        script.setVar("MusicBeatState", MusicBeatState);
        script.setVar("Conductor", Conductor);
		script.setVar("ClientPrefs", melt.ClientPrefs);
        script.setVar("PlayState", melt.gameplay.PlayState);
        script.setVar("BGSprite", melt.gameplay.objects.BGSprite);

		script.setVar("FunkinHScript", melt.scripting.FunkinHScript);
		script.setVar("FunkinLua", melt.scripting.FunkinLua);

		script.setVar("AssetUtil", melt.util.AssetUtil);


		script.setVar("game", FlxG.state);
	}
}