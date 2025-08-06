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
			PlayState.instance.luaArray.push(new FunkinLua(luaFile));
		}
		else
		{
			luaFile = Paths.getSharedPath(luaFile);
			if (FileSystem.exists(luaFile))
			{
				PlayState.instance.luaArray.push(new FunkinLua(luaFile));
			}
		}
		if (FileSystem.exists(Paths.modFolders(hscriptFile)))
		{
			hscriptFile = Paths.modFolders(hscriptFile);
			var scr = new FunkinHScript(hscriptFile, PlayState.instance, true);
			@:privateAccess
			addVariables(scr.rule);
			scr.callFunc("create");
			PlayState.instance.hscriptArray.push(scr);
		}
		else
		{
			hscriptFile = Paths.getSharedPath(hscriptFile);
			if (FileSystem.exists(hscriptFile))
			{
				var scr = new FunkinHScript(hscriptFile, PlayState.instance, true);
				@:privateAccess
				addVariables(scr.rule);
				scr.callFunc("create");
				PlayState.instance.hscriptArray.push(scr);
			}
		}
		#end
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