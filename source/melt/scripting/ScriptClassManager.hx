package melt.scripting;

import flixel.FlxG;
import rulescript.*;
import rulescript.parsers.HxParser;
import rulescript.scriptedClass.*;
import hscript.Expr;
import hscript.Parser;
import sys.io.File;
import melt.scripting.base.*;
import melt.scripting.FunkinRule.RuleScriptInterpEx;
import melt.util.AssetUtil;

using StringTools;

class ScriptClassManager
{
	public static final SCRIPTABLE_CLASSES:Map<Dynamic, Dynamic> = [
		DummyClass => ScriptedDummyClass, 
		MusicBeatState => ScriptedMusicBeatState,
		MusicBeatSubstate => ScriptedMusicBeatSubstate,

		melt.gameplay.hud.BasicHUD => ScriptedHUD,
		melt.gameplay.hud.VanillaHUD => ScriptedHUD.ScriptedVanillaHUD,
		melt.gameplay.hud.PsychHUD => ScriptedHUD.ScriptedPsychHUD
	];


	public static var classes:Map<String, ScriptClassRef> = [];

	public static function init():Void
	{	
		RuleScript.resolveScript = __resolveScript;
		RuleScriptedClassUtil.buildBridge = __buildRuleScript;

		reloadScriptedClasses();
	}

	public static function reloadScriptedClasses():Void
	{
		classes.clear();

		var parser = new HxParser();
		parser.allowAll();
		parser.mode = MODULE;

		for (file in AssetUtil.readRecursive("source"))
		{
			if (file.endsWith(".hx"))
			{
				var expr = parser.parse(File.getContent(file));
				// using base parser for getting stuff
				var ogExpr = new Parser().parseModule(File.getContent(file));
				var parentCls:Class<Dynamic> = ScriptedDummyClass;
				var baseCls = null;
				var imports:Map<String, String> = [];
				for (e in ogExpr)
				{
					switch (e)
					{
						default:
						// case DPackage(path): package will auto generated so yeah
						case DImport(path, everything, alias, func):
							var name = path[path.length - 1];
							if (alias != null)
								name = alias;
							imports.set(name, path.join("."));
						case DClass(c):
							if (c.extend != null)
							{
								switch (c.extend)
								{
									default:
									case CTPath(path, params):
										var p = path.join(".");
										if (imports.get(p) != null)
											p = imports.get(p);
										baseCls = Type.resolveClass(p);
										if (!SCRIPTABLE_CLASSES.exists(baseCls))
										{
											trace("[ERROR] Class " + p + " is not scriptable!");
											continue;
										}
										parentCls = SCRIPTABLE_CLASSES.get(baseCls);
								}
							}

							var ref:ScriptClassRef = {
								path: file.split("/source/")[1].replace(".hx", "").replace("/", "."),
								scriptedClass: parentCls,
								extend: baseCls,
								expr: expr,

								staticFields: []
							}

							// doing this after generationg ref to do funnt shit
							var _staticFieldNames:Array<String> = [];

							for (field in c.fields)
							{
								if (field.access.contains(AStatic))
									_staticFieldNames.push(field.name);
							}

							// execute script once to transfer static fields to ref
							if ((_staticFieldNames.length > 0))
							{
								var rulescript = new RuleScript(new RuleScriptInterpEx(), new HxParser());
								cast(rulescript.interp, RuleScriptInterpEx).ref = ref;
								rulescript.execute(expr);

								for (key => data in rulescript.variables)
								{
									if (_staticFieldNames.contains(key))
									{
										ref.staticFields.set(key, data); // copy stuff
									}
								}
							}
							
							// cleanup static from expr
							switch(expr.e)
							{
								default:
								case EBlock(fields):
									for (field in fields)
									{
										switch(field.e)
										{
											default:
											case EFunction(a, e, n, r):
												if (_staticFieldNames.contains(n))
													fields.remove(field);
											case EVar(n, t, e):
												if (_staticFieldNames.contains(n))
													fields.remove(field);
										}
									}
							}

							classes.set(ref.path, ref);
					}
				}
			}
		}

		trace(classes);
	}

	static function __buildRuleScript(typeName:String, superInstance:Dynamic)
	{
		var interp = new FunkinRule.RuleScriptInterpEx();
		interp.ref = classes.get(typeName);
		var rulescript = new RuleScript(interp, new HxParser());
		rulescript.superInstance = superInstance;
		rulescript.interp.skipNextRestore = true;
		rulescript.execute(classes.get(typeName).expr);

		return rulescript;
	}

	static function __resolveScript(path:String):Dynamic
	{
		var state = RuleScriptInterpEx.resolveScriptState;
		var clsName = path.split(".")[path.split(".").length - 1];

		switch (state.mode)
		{
			case "resolve":
				// returns cool thing
				if (classes.exists(path))
					return classes.get(path);
			case "cnew":
				if (classes.exists(path))
					return createInstance(path, state.args);
				if (state.owner.variables.exists(clsName) && state.owner.variables.get(clsName).expr != null)
				{
					var ref = state.owner.variables.get(clsName);
					return createInstance(ref.path, state.args);
				}
		}

		return null;
	}

	public static function createInstance(path:String, ?args:Array<Dynamic>):Dynamic
	{
		if (!classes.exists(path))
			return null;
		var ref = classes.get(path);
		if (args == null)
			args = [];
		var instance = Type.createInstance(ref.scriptedClass, [path, args]);
		return instance;
	}

	public static function listScriptClassesExtends(cls:Class<Dynamic>):Array<String>
	{
		var result:Array<String> = [];
		for (key => scriptClass in classes)
			if (scriptClass.extend == cls)
				result.push(key);

		return result;
	}
}

@:structInit class ScriptClassRef
{
	public var path:String; // for datamining from imports
	public var extend:Null<Dynamic>;
	public var scriptedClass:Dynamic;
	public var expr:Expr;

	public var staticFields:Map<String, Dynamic>;
}

// for scripts that extends nothing
class DummyClass
{
	public function new()
	{
	}
}

class ScriptedDummyClass implements rulescript.scriptedClass.RuleScriptedClass extends DummyClass{}
