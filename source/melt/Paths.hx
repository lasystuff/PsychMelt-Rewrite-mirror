package melt;

import melt.cache.ImageCache;
import sys.FileSystem;
import melt.gameplay.song.Song;

using StringTools;

class Paths
{
	// well can't i just make these functions compiled on macro?? idk for now
	public static inline function inst(song:String, postfix:String = "")
		return AssetUtil.getSound('songs/${Song.formatName(song)}/Inst$postfix.ogg');

	public static inline function voices(song:String, postfix:String = "")
		return AssetUtil.getSound('songs/${Song.formatName(song)}/Voices$postfix.ogg');

	public static inline function sound(key:String, folder:String = "sounds")
		return AssetUtil.getSound('$folder/$key.ogg');

	public static inline function music(key:String, folder:String = "music")
		return AssetUtil.getSound('$folder/$key.ogg');

	public static inline function frag(key:String, folder:String = "shaders"):Null<String>
		return getPath('$folder/$key.frag');

	public static inline function vert(key:String, folder:String = "shaders"):Null<String>
		return getPath('$folder/$key.vert');

	public static inline function video(key:String, folder:String = "videos"):Null<String>
		return getPath('$folder/$key.mp4');

	public static inline function font(key:String, folder:String = "fonts"):Null<String>
		return getPath('$folder/$key');

	public static inline function lua(key:String, folder:String = "scripts"):Null<String>
		return getPath('$folder/$key.lua');

	public static inline function hscript(key:String, folder:String = "scripts"):Null<String>
		return getPath('$folder/$key.hx');

	public static inline function text(key:String, folder:String = "data"):Null<String>
		return getPath('$folder/$key.txt');

	public static inline function json(key:String, folder:String = "data"):Null<String>
		return getPath('$folder/$key.json');

	public static inline function image(key:String, folder:String = "images")
	{
		var path = getPath('$folder/$key.png');
		if (path == null) // die
			return null;

		if (ImageCache.exists(path))
			return ImageCache.get(path).graphic;
		return ImageCache.loadLocal(path).graphic;
	}

	public static inline function xml(key:String, folder:String = "images"):Null<String>
		return getPath('$folder/$key.xml');

	public static function getPath(path:String, noWarning:Bool = false, noContent:Bool = false):Null<String>
	{
		if (!noContent)
		{
			for (content in Content.packs)
			{
				if (content.getPath(path) != null)
					return content.getPath(path);
			}
		}

		if (!FileSystem.exists("assets/" + path))
		{
			if (noWarning)
				trace("Failed to fetch file path from " + path);
			return null;
		}

		return "assets/" + path;
	}

	// Similar to getPath or readDirectory, but returns a list of every object that has same path instead with full path
	public static inline function listPaths(path:String):Array<String>
	{
		var result:Array<String> = [];
		for (content in Content.packs)
		{
			if (content.getPath(path) != null)
				result.push(content.getPath(path));
		}
		if (FileSystem.exists("assets/" + path))
		{
			result.push("assets/" + path);
		}
		return result;
	}


	// deprecated stuff (remove later)

	public static inline function getSparrowAtlas(key:String, ?library:String)
	{
		melt.plugin.DebugTextPlugin.addTextToDebug("Paths.getSparrowAtlas is deprecated! use AssetUtil.getSparrow instead");
		return AssetUtil.getSparrow(key);
	}

	public static inline function getPackerAtlas(key:String, ?library:String)
	{
		melt.plugin.DebugTextPlugin.addTextToDebug("Paths.getPackerAtlas is deprecated! use AssetUtil.getPacker instead");
		return AssetUtil.getPacker(key);
	}
}
