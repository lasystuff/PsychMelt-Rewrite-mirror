package melt.util;

import sys.FileSystem;
import sys.io.File;
import haxe.io.Path;
import flixel.graphics.frames.FlxAtlasFrames;
import haxe.Json;
import openfl.media.Sound;

using StringTools;

class AssetUtil
{
	public static inline function exists(path:String)
		return Paths.getPath(path, false) != null;

	// basic shallow readDirectory thing!!!
	public static inline function readDirectory(path:String):Array<String>
	{
		var result:Array<String> = [];
		for (directory in Paths.listPaths(path))
		{
			for (file in FileSystem.readDirectory(directory))
				result.push(file);
		}

		return result;
	}

	public static inline function readRecursive(path:String):Array<String>
	{
		var result:Array<String> = [];
		for (directory in Paths.listPaths(path))
		{
			for (file in CoolUtil.recursivelyReadFolders(directory))
			{
				if (!result.contains(file))
					result.push(file);
			}
		}

		return result;
	}

	public static function getText(key:String, folder:String = "data", extension:String = ".txt", mode:GetTextType = OVERRIDE):String
	{
		var path:String = '$folder/$key$extension';
		switch(mode)
		{
			default:
				if (Content.packs.length > 0)
				{
					var file = Content.packs[0].getPath(path);
					if (file != null)
						return File.getContent(file);
				}
				if (Paths.getPath(path) != null)
					return File.getContent(Paths.getPath(path));

			case MERGE:
				var result = "";
				if (Paths.getPath(path, true, false) != null)
					result = File.getContent(Paths.getPath(path, true, false));

				for (content in Content.packs)
				{
					var file = content.getPath(path);
					if (file != null)
						result = File.getContent(file) + "\n";
				}
				result.trim();
				return result;
		}

		return "";
	}

	public static function parseJson(key:String, ?folder:String):Dynamic
	{
		var path = Paths.json(key, folder);
		if (path == null)
			return null;

		return Json.parse(getText(key + ".json"));
	}

	private static var __audioCache:Map<String, Sound> = [];
	public static function getSound(key:String, folder:String = "music"):Sound
	{
		var path = Paths.getPath('$folder/$key.ogg');
		if (path == null)
			return null;

		if (!__audioCache.exists(key))
			__audioCache.set(key, Sound.fromFile(path));
		return __audioCache.get(key);
	}

	public static inline function getSparrow(key:String):FlxAtlasFrames
	{
		var xmlText = getText("images/" + key + ".xml");
		return FlxAtlasFrames.fromSparrow(Paths.image(key), xmlText);
	}

	public static inline function getPacker(key:String):FlxAtlasFrames
	{
		var packText = getText("images/" + key + ".txt");
		return FlxAtlasFrames.fromSpriteSheetPacker(Paths.image(key), packText);
	}
}

enum GetTextType
{
	OVERRIDE;
	MERGE;
}