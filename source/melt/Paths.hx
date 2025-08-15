package melt;

import melt.cache.ImageCache;

using StringTools;

class Paths
{
	// well can't i just make these functions compiled on macro?? idk for now
	public static inline function inst(song:String, postfix:String = ""):String
		return getPath('songs/$song/Inst$postfix.ogg');

	public static inline function voice(song:String, postfix:String = ""):String
		return getPath('songs/$song/Voices$postfix.ogg');

	public static inline function sound(key:String, folder:String = "sounds"):String
		return getPath('$folder/$key.ogg');

	public static inline function music(key:String, folder:String = "music"):String
		return getPath('$folder/$key.ogg');

	public static inline function frag(key:String, folder:String = "shaders"):String
		return getPath('$folder/$key.frag');

	public static inline function vert(key:String, folder:String = "shaders"):String
		return getPath('$folder/$key.vert');

	public static inline function video(key:String, folder:String = "videos"):String
		return getPath('$folder/$key.mp4');

	public static inline function font(key:String, folder:String = "font"):String
		return getPath('$folder/$key.ttf') != "" : getPath('$folder/$key.ttf') : getPath('$folder/$key.otf');

	public static inline function lua(key:String, folder:String = "scripts"):String
		return getPath('$folder/$key.lua');

	public static inline function hscript(key:String, folder:String = "scripts"):String
		return getPath('$folder/$key.hx');

	public static inline function image(key:String, folder:String = "images"):Dynamic
	{
		var path = getPath('$folder/$key.png');
		if (path == "") // die
			return null;

		if (ImageCache.exists(path))
			return ImageCache.get(path);
		return ImageCache.loadLocal(path);
	}

	public static inline function getPath(path:String, noContent:Bool = false):String
	{
		if (!noContent)
		{
			for (content in ContentPack.packs)
			{
				if (FileSystem.exists(content.getPath(path)))
					return content.getPath(path);
			}
		}

		if (!FileSystem.exists("assets/" + path))
		{
			trace("Failed to fetch file path from " + path);
			return ""; // can't be null fuck you
		}

		return "assets/" + path;
	}

	// Similar to getPath, but returns a list of every object that has same path instead
	public static inline function listPaths(path:String):String
	{
		var result:Array<String> = [];
		for (content in ContentPack.packs)
		{
			if (FileSystem.exists(content.getPath(path)))
				return result.push(content.getPath(path));
		}
		if (FileSystem.exists("assets/" + path))
		{
			result.push("assets/" + path);
		}
		return result;
	}
}
