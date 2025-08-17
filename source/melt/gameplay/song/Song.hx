package melt.gameplay.song;

import haxe.Json;
import sys.io.File;
import sys.FileSystem;

using StringTools;

typedef SwagSong =
{
	var song:String;
	var notes:Array<SwagSection>;
	var events:Array<Dynamic>;
	var bpm:Float;
	var needsVoices:Bool;
	var speed:Float;

	var player1:String;
	var player2:String;
	var gfVersion:String;
	var stage:String;

	var arrowSkin:String;
	var splashSkin:String;
}

typedef SwagSection =
{
	var sectionNotes:Array<Dynamic>;
	var sectionBeats:Float;
	var typeOfSection:Int;
	var mustHitSection:Bool;
	var gfSection:Bool;
	var bpm:Float;
	var changeBPM:Bool;
	var altAnim:Bool;
}

class Song
{
	private static function onLoadJson(songJson:Dynamic) // Convert old charts to newest format
	{
		if(songJson.gfVersion == null)
		{
			songJson.gfVersion = songJson.player3;
			songJson.player3 = null;
		}

		if(songJson.events == null)
		{
			songJson.events = [];
			for (secNum in 0...songJson.notes.length)
			{
				var sec:SwagSection = songJson.notes[secNum];

				var i:Int = 0;
				var notes:Array<Dynamic> = sec.sectionNotes;
				var len:Int = notes.length;
				while(i < len)
				{
					var note:Array<Dynamic> = notes[i];
					if(note[1] < 0)
					{
						songJson.events.push([note[0], [[note[2], note[3], note[4]]]]);
						notes.remove(note);
						len = notes.length;
					}
					else i++;
				}
			}
		}
	}

	public static function loadFromJson(jsonInput:String, ?folder:String):SwagSong
	{
		var rawJson = null;
		
		var formattedFolder:String = formatName(folder);
		var formattedSong:String = formatName(jsonInput);

		var file = Paths.json(formattedFolder + '/' + formattedSong);
		if (file != null)
		{
			rawJson = File.getContent(file).trim();
		}

		while (!rawJson.endsWith("}"))
		{
			rawJson = rawJson.substr(0, rawJson.length - 1);
		}

		var songJson:Dynamic = parseJSONshit(rawJson);
		onLoadJson(songJson);
		return songJson;
	}

	public static function parseJSONshit(rawJson:String):SwagSong
	{
		var swagShit:SwagSong = cast Json.parse(rawJson).song;
		return swagShit;
	}

	public static function getSongMetadata(songName:String, difficulty:String = "normal"):SongMeta
	{
		var metadata:SongMeta = {
			displayName: songName,
			artists: Constants.SONG_DEFAULT_ARTIST,
			hud: Constants.SONG_DEFAULT_HUD
		};
		var thepath:String = Paths.json('${formatName(songName)}/metadata-$difficulty');

		if (difficulty.toLowerCase() == "normal" || thepath == null)
			thepath = Paths.json('${formatName(songName)}/metadata');

		if(thepath != null)
		{
			final shit = haxe.Json.parse(sys.io.File.getContent(thepath));

			if (shit.displayName != null) metadata.displayName = shit.displayName;
			if (shit.artists != null) metadata.artists = shit.artists;
			if (shit.hud != null) metadata.hud = shit.hud;
		}
		return metadata;
	}

	public static function formatName(key:String):String
	{
		return key.replace(' ', '-').toLowerCase();
	}
}

typedef SongMeta = {
	var displayName:String;
	var artists:String;
	var hud:String;
}