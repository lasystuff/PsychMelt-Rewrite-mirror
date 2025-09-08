package melt.scripting.extension;

import melt.scripting.ScriptClassManager.ScriptClassRef;
import rulescript.RuleScriptInterp;

typedef ResolveScriptState = {
	var owner:RuleScriptInterpEx;
	var mode:String; // resolve or cnew
	var ?args:Array<Dynamic>; // only 4 cnew ig
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