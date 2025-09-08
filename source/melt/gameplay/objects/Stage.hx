package melt.gameplay.objects;

// looks so troll engine but i written from zero trust me pls
import flixel.group.FlxGroup;
import sys.FileSystem;
import melt.scripting.*;

class Stage extends FlxGroup
{
	public var name:String = "";
	public var foreground:FlxGroup = new FlxGroup();
	public var data:StageFile = {
		directory: "",
		defaultZoom: 0.9,
		isPixelStage: false,

		boyfriend: [770, 100],
		girlfriend: [400, 130],
		opponent: [100, 100],
		hide_girlfriend: false,

		camera_boyfriend: [0, 0],
		camera_opponent: [0, 0],
		camera_girlfriend: [0, 0],
		camera_speed: 1
	};

	override public function new(name:String)
	{
		super();

		this.name = name;

		var jsonPath = Paths.json(name, "stages");
		if (FileSystem.exists(jsonPath))
		{
			data = haxe.Json.parse(sys.io.File.getContent(jsonPath));
		}

		build(); // for hardcoders ig

		var script:IFunkinScript = null;

		if (Paths.hscript(name) != null)
			script = new FunkinHScript(path, PlayState.instance, true);
		else if (Paths.lua(name) != null)
			script = new FunkinLua(path, true);

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

	function addVariables(script:IFunkinScript)
	{
		script.setVar("foreground", this.foreground);

		script.setVar("insert", this.insert);
		script.setVar("remove", this.remove);
		script.setVar("add", this.add);
	}
}

typedef StageFile =
{
	var directory:String;
	var defaultZoom:Float;
	var isPixelStage:Bool;

	var boyfriend:Array<Dynamic>;
	var girlfriend:Array<Dynamic>;
	var opponent:Array<Dynamic>;
	var hide_girlfriend:Bool;

	var camera_boyfriend:Array<Float>;
	var camera_opponent:Array<Float>;
	var camera_girlfriend:Array<Float>;
	var camera_speed:Null<Float>;
}