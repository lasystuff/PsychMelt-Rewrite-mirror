package melt.scripting;

import sys.io.File;
import flixel.util.FlxColor;

import rulescript.*;
import rulescript.parsers.*;

import melt.scripting.ScriptClassManager.ScriptClassRef;

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
        rule = new RuleScript(new RuleScriptInterpEx());
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
		setVar("Paths", Paths);
        setVar("Character", Character);
        setVar("CoolUtil", CoolUtil);
        setVar("MusicBeatState", MusicBeatState);
        setVar("Conductor", Conductor);
		setVar("ClientPrefs", melt.ClientPrefs);
        setVar("PlayState", melt.gameplay.PlayState);
        setVar("BGSprite", melt.gameplay.objects.BGSprite);

		setVar("FunkinRule", melt.scripting.FunkinRule);
		setVar("FunkinHScript", melt.scripting.FunkinHScript);
		setVar("FunkinLua", melt.scripting.FunkinLua);

		setVar("AssetUtil", melt.util.AssetUtil);

		setVar("Paths", Paths);
	}

    //call function in Interp
    public function callFunc(func:String, ?args:Array<Dynamic>):Dynamic
	{
		if (existsVar(func)) 
		{
			if (args == null)
				args = [];

			try
			{
				return Reflect.callMethod(null, rule.variables.get(func), args);
			}
			catch(e)
			{
				trace(e.message);
			}
		}
		return null;
	}

	public function existsVar(variable:String)
	{
		return rule.variables.exists(variable);
	}

	public function getVar(variable:String)
	{
		if (rule.variables.exists(variable))
			rule.variables.get(variable);
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
 
// RuleScript with some extra variables for better custom classes handling
class RuleScriptInterpEx extends RuleScriptInterp
{
	public static var resolveScriptState:ResolveScriptState;
	public var ref:ScriptClassRef;
	
	override function cnew(cl:String, args:Array<Dynamic>):Dynamic
	{
		resolveScriptState = {owner: this, mode: "cnew", args: args};
		return super.cnew(cl, args);
	}

	override function resolveType(path:String):Dynamic
	{
		resolveScriptState = {owner: this, mode: "resolve"};
		return super.resolveType(path);
	}

	override function get(o:Dynamic, f:String):Dynamic
	{
		if (o == this)
		{
			if (this.ref.staticFields.exists(f))
				return this.ref.staticFields.get(f);
		}

		if (o is ScriptClassRef)
		{
			var cls = cast(o, ScriptClassRef);
			if (cls.staticFields.exists(f))
				return cls.staticFields.get(f);
		}

		return super.get(o, f);
	}

	override function set(o:Dynamic, f:String, v:Dynamic):Dynamic
	{
		if (o == this)
		{
			if (this.ref.staticFields.exists(f))
			{
				this.ref.staticFields.set(f, v);
				return this.ref.staticFields.get(f);
			}
		}

		if (o is ScriptClassRef)
		{
			var cls = cast(o, ScriptClassRef);
			if (cls.staticFields.exists(f))
			{
				cls.staticFields.set(f, v);
				return cls.staticFields.get(f);
			}
		}

		return super.set(o, f, v);
	}
}

typedef ResolveScriptState = {
	var owner:RuleScriptInterpEx;
	var mode:String; // resolve or cnew
	var ?args:Array<Dynamic>; // only 4 cnew ig
}