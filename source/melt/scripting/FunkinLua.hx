package melt.scripting;

import vm.lua.Lua;
import sys.io.File;

using StringTools;

class FunkinLua implements IFunkinScript
{
    public static var scriptType:String = "Lua Script";

    //
	public static var Function_Stop:Dynamic = 1;
	public static var Function_Continue:Dynamic = 0;
	public static var Function_StopLua:Dynamic = 2;
    //

    private var lua:Lua;

    public function new(path:String, skipCreate:Bool = false)
    {
        lua = new Lua();

        var scriptToRun:String = File.getContent(path);

        // ScriptingUtil.buildVariables(this);
        PsychCompatUtil.buildVariables(this);
        buildVariables();

        lua.run(scriptToRun);

        if (!skipCreate)
            callFunction("onCreate");
    }

    public function callFunction(func:String, ?args:Array<Dynamic>):Dynamic
	{
        if (args == null)
            args = [];
        if (existsVar(func))
		    return lua.call(func, args);
        return null;
	}

	public function existsVar(variable:String):Bool
	{
		return lua.getGlobalVar(variable) != null;
	}

	public function getVar(variable:String):Dynamic
	{
        return lua.getGlobalVar(variable);
	}

	public function setVar(variable:String, data:Dynamic):Void
	{
		lua.setGlobalVar(variable, data);
	}

    // pls wtf is that fucking that fucking shit
    public function stop():Void
    {
        lua.destroy();
    }

    function buildVariables()
    {
        setVar("print", function(thing:String){trace(thing);});
    }
}