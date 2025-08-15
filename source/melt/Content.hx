package melt;

import sys.io.File;
import sys.FileSystem;
import haxe.Json;
import flixel.graphics.FlxGraphic;
import melt.cache.ImageCache;

using StringTools;

class Content
{
	public static var packs:Array<Content> = [];
	private static var initalizedFirst:Bool = false;

	public var config:ContentConfig;
	public var folder:String;

	public static inline function load():Void
	{
		packs.resize(0);

		for (folder in FileSystem.readDirectory(Constants.CONTENT_ROOT_FOLDER))
			new Content(folder);

		// TODO: do dependencies check


		// do not preload stuff when hot-reload
		if (!initalizedFirst)
		{
			initalizedFirst = true;
			for (content in packs)
			{
				for (graphic in content.config.preload)
				{
					var path = content.getPath("images/" + graphic + ".png");
					ImageCache.preload(path);
				}
			}
		}
	}

	public static inline function getFlag(flag:String, ?defaultValue:Dynamic):Dynamic
	{
		var value:Null<Dynamic> = defaultValue;
		for (content in packs)
		{
			value = Reflect.getProperty(content.config.flags, flag);
		}

		return value;
	}

	public function new(folder:String)
	{
		this.folder = folder;

		if (FileSystem.exists(this.getPath("config.json")))
		{
			this.config = cast Json.parse(File.getContent(this.getPath("config.json")));

			if (this.config.dependencies == null)
				this.config.dependencies = [];
			if (this.config.preload == null)
				this.config.preload = [];
			if (this.config.flags == null)
				this.config.flags = {};

			packs.push(this);
			trace("loaded content from " + folder);
		}
	}

	public function getPath(path:String):Null<String>
	{
		var thing = '${Constants.CONTENT_ROOT_FOLDER}/$folder/$path';
		if (FileSystem.exists(thing))
			return thing;

		return null;
	}
}


typedef ContentConfig = {
	var id:String; // used for logging and dependencies
	var global:Bool; // if this is true, the mod name and id will be applied to the mainmenu
	var ?dependencies:Array<String>;
	var ?preload:Array<String>; // list of graphics to preload
	var ?flags:ContentFlags; // cool flag thing!!! that onverride some constant
}

@:structInit class ContentFlags
{
	public var DEFAULT_HUD:String = Constants.SONG_DEFAULT_HUD;
}