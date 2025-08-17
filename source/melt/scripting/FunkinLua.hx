package melt.scripting;

import rulescript.parsers.LuaParser;
import sys.io.File;

import flixel.FlxG;
import flixel.FlxSprite;
import melt.gameplay.PlayState;

using StringTools;

class FunkinLua extends FunkinRule
{
	public static var Function_Stop:Dynamic = 1;
	public static var Function_Continue:Dynamic = 0;
	public static var Function_StopLua:Dynamic = 2;


    public function new(path:String, parentInstance:Dynamic = null, skipCreate:Bool = false){
        super(path, parentInstance, skipCreate);
        scriptType = "Lua script";

        rule.parser = new LuaParser();
        // rule.getParser(LuaParser).allowAll();

		var scriptToRun:String = File.getContent(path);
		execute(scriptToRun, skipCreate);
    }

    override public function presetVariables():Void
    {
        super.presetVariables();
        PsychCompatUtil.buildFunctions(this);
    }
}