package melt.gameplay.objects;

// looks so troll engine but i written from zero trust me pls
import flixel.group.FlxGroup;
import sys.FileSystem;
import melt.scripting.*;

class Stage extends FlxGroup
{
	public var name:String = "";
	public var foreground:FlxGroup = new FlxGroup();

	override public function new(name:String)
	{
		super();

		this.name = name;

		build(); // for hardcoders ig
		
		#if (MODS_ALLOWED && LUA_ALLOWED)
		var luaFile:String = 'stages/' + this.name + '.lua';
		var hscriptFile:String = 'stages/' + this.name + '.hx';
		if (FileSystem.exists(Paths.modFolders(luaFile)))
		{
			luaFile = Paths.modFolders(luaFile);
			createScript(luaFile);
		}
		else
		{
			luaFile = Paths.getSharedPath(luaFile);
			createScript(luaFile);
		}
		if (FileSystem.exists(Paths.modFolders(hscriptFile)))
		{
			hscriptFile = Paths.modFolders(hscriptFile);
			createScript(hscriptFile);
		}
		else
		{
			hscriptFile = Paths.getSharedPath(hscriptFile);
			if (FileSystem.exists(hscriptFile))
			{
				createScript(hscriptFile);
			}
		}
		#end
	}

	function createScript(path)
	{
		if (!FileSystem.exists(path))
			return;
		var script = FunkinRule.fromFile(path, PlayState.instance, true);
		if (script != null)
		{
			@:privateAccess
			addVariables(script.rule);
			PlayState.instance.scriptArray.push(script);
			script.callFunc("onCreate");
		}
	}

	function build()
	{
		switch(name)
		{
			default:
				// nothin
		}
	}

	function addVariables(rule:rulescript.RuleScript)
	{
		rule.variables.set("foreground", this.foreground);

		rule.variables.set("insert", this.insert);
		rule.variables.set("remove", this.remove);
		rule.variables.set("add", this.add);
	}
}