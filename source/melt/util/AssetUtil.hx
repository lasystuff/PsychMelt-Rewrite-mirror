package melt.util;

import sys.FileSystem;
import sys.io.File;
import haxe.io.Path;
import flixel.graphics.frames.FlxAtlasFrames;

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
		// rework in progress sorry
		return [];
	}

	public static function getText(path:String, mode:GetTextType = OVERRIDE):String
	{
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

	public static inline function getSparrow(key:String):FlxAtlasFrames
	{
		return FlxAtlasFrames.fromSparrow(Paths.image(key), Paths.xml(key));
	}

	public static inline function getPacker(key:String):FlxAtlasFrames
		return FlxAtlasFrames.fromSpriteSheetPacker(Paths.image(key), Paths.text(key, "images"));
}

enum abstract GetTextType(String)
{
	var OVERRIDE = "override";
	var MERGE = "merge";
}