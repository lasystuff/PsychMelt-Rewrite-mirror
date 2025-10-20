package melt.util;

import flixel.FlxBasic;
import flixel.math.FlxPoint;
import flixel.FlxG;
import openfl.utils.Assets;
import lime.utils.Assets as LimeAssets;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;
import flixel.sound.FlxSound;
#if sys
import sys.io.File;
import sys.FileSystem;
#else
import openfl.utils.Assets;
#end
import flixel.util.FlxColor;
import melt.gameplay.PlayState;
import melt.gameplay.song.Song;

using StringTools;

class CoolUtil
{

	inline public static function scale(x:Float, l1:Float, h1:Float, l2:Float, h2:Float):Float
		return ((x - l1) * (h2 - l2) / (h1 - l1) + l2);

	inline public static function clamp(n:Float, l:Float, h:Float)
	{
		if (n > h)
			n = h;
		if (n < l)
			n = l;

		return n;
	}

	public static function rotate(x:Float, y:Float, angle:Float, ?point:FlxPoint):FlxPoint
	{
		var p = point == null ? FlxPoint.weak() : point;
		p.set((x * Math.cos(angle)) - (y * Math.sin(angle)), (x * Math.sin(angle)) + (y * Math.cos(angle)));
		return p;
	}
	
	public static var defaultDifficulties:Array<String> = [
		'Easy',
		'Normal',
		'Hard'
	];
	public static var defaultDifficulty:String = 'Normal'; //The chart that has no suffix and starting difficulty on Freeplay/Story Mode

	public static var difficulties:Array<String> = [];

	inline public static function quantizeAlpha(f:Float, interval:Float)
	{
		return Std.int((f + interval / 2) / interval) * interval;
	}

	inline public static function quantize(f:Float, snap:Float)
	{
		// changed so this actually works lol
		final m:Float = Math.fround(f * snap);
		return (m / snap);
	}
	
	public static function getDifficultyFilePath(num:Null<Int> = null)
	{
		if(num == null) num = PlayState.storyDifficulty;

		var fileSuffix:String = difficulties[num];
		if(fileSuffix != defaultDifficulty)
		{
			fileSuffix = '-' + fileSuffix;
		}
		else
		{
			fileSuffix = '';
		}
		return Song.formatName(fileSuffix);
	}

	inline public static function difficultyString():String
	{
		return difficulties[PlayState.storyDifficulty].toUpperCase();
	}

	inline public static function boundTo(value:Float, min:Float, max:Float):Float {
		return Math.max(min, Math.min(max, value));
	}

	public static function coolTextFile(path:String):Array<String>
	{
		#if sys
		if(FileSystem.exists(path)) return [for (i in File.getContent(path).trim().split('\n')) i.trim()];
		#else
		if(Assets.exists(path)) return [for (i in Assets.getText(path).trim().split('\n')) i.trim()];
		#end

		return [];
	}
	inline public static function listFromString(string:String):Array<String>
	{
		return [for (i in string.trim().split('\n')) i.trim()];
	}

	inline public static function dominantColor(bitmap:openfl.display.BitmapData):Int
	{
		var countByColor:Map<Int, Int> = [];
		for(col in 0...bitmap.width)
		{
			for(row in 0...bitmap.height)
			{
				var colorOfThisPixel:FlxColor = bitmap.getPixel32(col, row);
				if(colorOfThisPixel.alphaFloat > 0.05)
				{
					colorOfThisPixel = FlxColor.fromRGB(colorOfThisPixel.red, colorOfThisPixel.green, colorOfThisPixel.blue, 255);
					var count:Int = countByColor.exists(colorOfThisPixel) ? countByColor[colorOfThisPixel] : 0;
					countByColor[colorOfThisPixel] = count + 1;
				}
			}
		}

		var maxCount = 0;
		var maxKey:Int = 0; //after the loop this will store the max color
		countByColor[FlxColor.BLACK] = 0;
		for(key => count in countByColor)
		{
			if(count >= maxCount)
			{
				maxCount = count;
				maxKey = key;
			}
		}
		countByColor = [];
		return maxKey;
	}

	inline public static function sortByID(i:Int, basic1:FlxBasic, basic2:FlxBasic):Int {
		return basic1.ID > basic2.ID ? -i : basic2.ID > basic1.ID ? i : 0;
	}

	inline public static function browserLoad(site:String) {
		#if linux
		Sys.command('/usr/bin/xdg-open', [site]);
		#else
		FlxG.openURL(site);
		#end
	}

	inline public static function colorFromString(color:String):FlxColor
	{
		var hideChars = ~/[\t\n\r]/;
		var color:String = hideChars.split(color).join('').trim();
		if(color.startsWith('0x')) color = color.substring(color.length - 6);

		var colorNum:Null<FlxColor> = FlxColor.fromString(color);
		if(colorNum == null) colorNum = FlxColor.fromString('#$color');
		return colorNum != null ? colorNum : FlxColor.WHITE;
	}

	public static function recursivelyReadFolders(path:String)
	{
		var ret:Array<String> = [];
		for (i in FileSystem.readDirectory(path))
			returnFileName(i, ret, path);

		
		path+='/';
		for (i in 0...ret.length)
			ret[i] = ret[i].replace(path, '');
		return ret;
	}

	static function returnFileName(path:String, toAdd:Array<String>, full:String) {
		if (FileSystem.isDirectory(full+'/'+path)) {
			for (i in FileSystem.readDirectory(full+'/'+path)) {
				returnFileName(i, toAdd, full+'/'+path);
			}
		} else {
			toAdd.push((full+'/'+path));
		}
	}

	inline public static function sortByList(list:String, a:String, b:String)
	{
		var listArray:Array<String> = list.split("\n");
		// remove coments
		for (thing in listArray)
			if(thing.startsWith("#") || thing.startsWith("--") || thing.startsWith("//"))
				listArray.remove(thing);
		if(listArray.indexOf(a) < listArray.indexOf(b)){ return -1; }
		return 1;
	}
}