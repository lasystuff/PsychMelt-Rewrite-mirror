package melt.scripting;

import sys.io.File;
import flixel.util.FlxColor;

import rulescript.*;
import rulescript.parsers.*;

using StringTools;

class FunkinRule
{
	public var scriptType:String = "Unknown Script"; // for trace
    private var rule:RuleScript;

	public static function fromFile(file:String, instance:Dynamic = null, skipCreate:Bool = false):Null<FunkinRule>
	{
		if (file.endsWith(".hx"))
			return new FunkinHScript(file, instance, skipCreate);
		if (file.endsWith(".lua"))
			return new FunkinLua(file, instance, skipCreate);

		return null;
	}

    public function new(path:String, parentInstance:Dynamic = null, skipCreate:Bool = false){
        rule = new RuleScript();
        rule.scriptName = path;
        rule.errorHandler = onError;

        if (parentInstance != null)
            rule.superInstance = parentInstance;

		var scriptToRun:String = File.getContent(path);
		execute(scriptToRun, skipCreate);
    }

	private function execute(code:String, skipCreate:Bool)
	{
		presetVariables();

        rule.tryExecute(code);
		if (!skipCreate)
            callFunc("onCreate");
	}

	function presetVariables()
	{
		rule.variables.set("Paths", Paths);
        rule.variables.set("Character", Character);
        rule.variables.set("CoolUtil", CoolUtil);
        rule.variables.set("MusicBeatState", MusicBeatState);
        rule.variables.set("Conductor", Conductor);
        rule.variables.set("PlayState", melt.gameplay.PlayState);
        rule.variables.set("BGSprite", melt.gameplay.objects.BGSprite);
		rule.variables.set("FunkinLua", melt.scripting.FunkinLua);
	}

    //call function in Interp
    public function callFunc(func:String, ?args:Array<Dynamic>):Dynamic
	{
		if (rule.variables.exists(func)) {
			if (args == null){ args = []; }

			try {
				return Reflect.callMethod(null, rule.variables.get(func), args);
			}
			catch(e){
				trace(e.message);
            }
		}
		return null;
	}

	public function setVar(variable:String, data:Dynamic)
	{
		rule.variables.set(variable, data);
	}

    function onError(e:haxe.Exception):Dynamic
	{
        var text = 'Error on $scriptType! - ' + e.details();
        trace(text);
        melt.plugin.DebugTextPlugin.addTextToDebug(text, FlxColor.RED);

		return e.details();
	}

    public function stop(){
        //idk how can i stop them please help me please
        rule.interp = null;
        rule.variables.clear();
    }
}