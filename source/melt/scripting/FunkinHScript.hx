package melt.scripting;

import rulescript.parsers.HxParser;
import sys.io.File;

using StringTools;

class FunkinHScript implements IFunkinScript
{
    public var scriptType:String = "HScript";
    private var rule:RuleScript;

    public function new(path:String, parentInstance:Dynamic = null, skipCreate:Bool = false){
        rule = new RuleScript(new RuleScriptInterpEx(), new HxParser());
        rule.scriptName = path;
        rule.errorHandler = onError;

        rule.getParser(HxParser).allowAll();

        if (parentInstance != null)
            rule.superInstance = parentInstance;

		var scriptToRun:String = File.getContent(path);

        ScriptingUtil.buildVariables(this);

        rule.tryExecute(code);
		if (!skipCreate)
            callFunc("onCreate");	
    }

    //call function in Interp
    public function callFunction(func:String, ?args:Array<Dynamic>)
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
				onError(e);
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
        var text = 'Error on HScript! - ' + e.details();
        trace(text);
        melt.plugin.DebugTextPlugin.addTextToDebug(text, FlxColor.RED);

		return e.details();
	}

    public function stop()
    {
        //idk how can i stop them please help me please
        rule.interp = null;
        rule.variables.clear();
    }
}