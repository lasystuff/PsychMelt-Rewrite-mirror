package melt.util;

import sys.FileSystem;
import sys.io.File;
import haxe.io.Path;

using StringTools;

class AssetUtil
{
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

	public static inline function readRecursive(path:String)
	{
		// rework in progress sorry
		return [];
	}

	public static inline function getText(path:String, mode:GetTextType = OVERRIDE):String
	{
		switch(mode)
		{
			default:
				if (ContentPack.packs.length > 0)
				{
					var file = ContentPack.packs[0].getPath(path);
					if (file != "")
						return File.getContent(file);
				}
				if (Paths.getPath(path, false) != "")
					return File.getContent(Paths.getPath(path, false));

			case MERGE:
				var result = "";
				if (Paths.getPath(path, false) != "")
					result = File.getContent(Paths.getPath(path, false));

				for (content in ContentPack.packs)
				{
					var file = content.getPath(path);
					if (file != "")
						result = File.getContent(file) + "\n";
				}
				result.trim();
				return result;
		}

		return "";
	}
}

abstract GetTextType(String)
{
	var OVERRIDE = "override";
	var MERGE = "merge";
}