package melt.util;

import melt.scripting.IFunkinScript;
import melt.gameplay.PlayState;

import openfl.display.BlendMode;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;

using StringTools;

class ScriptingUtil
{
	private static final _FLXCOLOR_SCRIPTABLE:Dynamic = {
		BLACK: FlxColor.BLACK,
		BLUE: FlxColor.BLUE,
		CYAN: FlxColor.CYAN,
		GRAY: FlxColor.GRAY,
		GREEN: FlxColor.GREEN,
		LIME: FlxColor.LIME,
		MAGENTA: FlxColor.MAGENTA,
		ORANGE: FlxColor.ORANGE,
		PINK: FlxColor.PINK,
		PURPLE: FlxColor.PURPLE,
		RED: FlxColor.RED,
		TRANSPARENT: FlxColor.TRANSPARENT,
		WHITE: FlxColor.WHITE,
		YELLOW: FlxColor.YELLOW,

		fromCMYK: FlxColor.fromCMYK,
		fromHSB: FlxColor.fromHSB,
		fromInt: FlxColor.fromInt,
		fromRGBFloat: FlxColor.fromRGBFloat,
		fromRGB: FlxColor.fromRGB,
		getHSBColorWheel: FlxColor.getHSBColorWheel,

		gradient: FlxColor.gradient,
		interpolate: FlxColor.interpolate,
		fromString: FlxColor.fromString,
	}

	private static final _BLENDMODE_SCRIPTABLE:Dynamic = {
		ADD: BlendMode.ADD,
		ALPHA: BlendMode.ALPHA,
		DARKEN: BlendMode.DARKEN,
		DIFFERENCE: BlendMode.DIFFERENCE,
		ERASE: BlendMode.ERASE,
		HARDLIGHT: BlendMode.HARDLIGHT,
		INVERT: BlendMode.INVERT,
		LAYER: BlendMode.LAYER,
		LIGHTEN: BlendMode.LIGHTEN,
		MULTIPLY: BlendMode.MULTIPLY,
		NORMAL: BlendMode.NORMAL,
		OVERLAY: BlendMode.OVERLAY,
		SCREEN: BlendMode.SCREEN,
		SHADER: BlendMode.SHADER,
		SUBTRACT: BlendMode.SUBTRACT
	}

	public static function buildVariables(script:IFunkinScript)
	{
		script.setVar("BlendMode", _BLENDMODE_SCRIPTABLE);
		script.setVar("ShaderFilter", openfl.filters.ShaderFilter);

		script.setVar("FlxG", FlxG);
		script.setVar("FlxSprite", FlxSprite);
		script.setVar("FlxColor", _FLXCOLOR_SCRIPTABLE);
		script.setVar("FlxRuntimeShader", flixel.addons.display.FlxRuntimeShader);

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