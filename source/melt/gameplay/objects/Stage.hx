package melt.gameplay.objects;

// looks so troll engine but i written from zero trust me pls
import flixel.group.FlxGroup;
import sys.FileSystem;
import melt.scripting.*;
import haxe.Json;

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
		camera_speed: 1,

		objects: []
	};

	public var jsonObjects:Map<String, BGSprite> = [];

	public var script:IFunkinScript;

	override public function new(name:String)
	{
		super();

		this.name = name;

		var jsonPath = Paths.json(name, "stages");
		if (FileSystem.exists(jsonPath))
		{
			data = Json.parse(sys.io.File.getContent(jsonPath));
		}
		trace(data);

		build();

		if (Paths.hscript(name, "stages") != null)
			script = new FunkinHScript(Paths.hscript(name, "stages"), PlayState.instance, true);
		else if (Paths.lua(name, "stages") != null)
			script = new FunkinLua(Paths.lua(name, "stages"), true);

		if (script != null)
		{
			addVariables(script);
			PlayState.instance.scriptArray.push(script);
		}
	}

	function build()
	{
		if (data.objects != null)
		{
			for (obj in data.objects)
			{
				var scroll:Array<Float> = obj.scrollFactor != null ? obj.scrollFactor : [1, 1];
				var anims:Array<BGSprite.AnimData> = obj.animations != null ? obj.animations : [];


				var sprite = new BGSprite(obj.image, obj.position[0], obj.position[1], scroll[0], scroll[1], anims);
				if (obj.id != null)
					jsonObjects.set(obj.id, sprite);

				if (obj.foreground != null && obj.foreground)
					foreground.add(sprite);
				else
					add(sprite);
			}
		}

		// hardcode ur stages here
		switch(name)
		{
			default:
		}
	}

	function addVariables(script:IFunkinScript)
	{
		script.setVar("foreground", this.foreground);

		script.setVar("insert", this.insert);
		script.setVar("remove", this.remove);
		script.setVar("add", this.add);

		for (id => sprite in jsonObjects)
			script.setVar(id, sprite);
	}
}

typedef StageFile = {
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

	var ?objects:Array<StageObject>;
}

typedef StageObject =
{
	var id:String;
	var image:String;

	var position:Array<Float>;
	var ?scrollFactor:Array<Float>;
	var ?foreground:Bool;

	var ?animations:Array<BGSprite.AnimData>;
}