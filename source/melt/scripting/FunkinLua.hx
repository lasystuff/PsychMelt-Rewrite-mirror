package melt.scripting;

import vm.lua.Lua;

using StringTools;

@:build(lumod.LuaScriptClass.build("")) // handle scripts on custom script so ok i think
class FunkinLua implements IFunkinScripts
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
        var lua = new Lua();

        var scriptToRun:String = File.getContent(path);

        ScriptingUtil.buildVariables(this);
        PsychCompatUtil.buildVariables(this);

        lua.run(scriptToRun);

        if (!skipCreate)
            callFunction("onCreate");
    }

    public function callFunction(func:String, ?args:Array<Dynamic>)
	{
        if (args == null)
            args = [];
		return lua.call(func, args);
	}

	public function existsVar(variable:String)
	{
		return lua.getGlobalVar(variable) != null;
	}

	public function getVar(variable:String)
	{
        return lua.getGlobalVar(variable);
	}

	public function setVar(variable:String, data:Dynamic)
	{
		return lua.setGlobalVar(variable, data);
	}

    // pls wtf is that fucking that fucking shit
    public function stop()
    {
        lua.destroy();
    }
}