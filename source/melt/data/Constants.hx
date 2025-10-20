package melt.data;

import openfl.Lib;
import lime.app.Application;

class Constants
{
    @:isVar public static var ENGINE_NAME_PREFIX(get, never):String;
    static inline function get_ENGINE_NAME_PREFIX():String
        return Content.getFlag("MOD_NAME", openfl.Lib.application.window.title);
    @:isVar public static var ENGINE_VERSION(get, never):String;
    static inline function get_ENGINE_VERSION():String
        return Content.getFlag("MOD_VERSION", Application.current.meta.get('version'));

    public static inline final ASSETS_ROOT_FOLDER:String =
    #if (REDIRECT_ASSETS_FOLDER && macos)
    "../../../../../../../assets/"
    #elseif REDIRECT_ASSETS_FOLDER
    "../../../../assets/"
    #else
    "assets/"
    #end;
    public static inline final CONTENT_ROOT_FOLDER:String =
    #if (REDIRECT_ASSETS_FOLDER && macos)
    "../../../../../../../example_content/"
    #elseif REDIRECT_ASSETS_FOLDER
    "../../../../content/"
    #else
    "content/"
    #end;

    public static inline final SONG_DEFAULT_ARTIST:String = "????";
    @:isVar public static var SONG_DEFAULT_HUD(get, never):String;
    static inline function get_SONG_DEFAULT_HUD():String
        return Content.getFlag("DEFAULT_HUD", "melt.gameplay.hud.MeltHUD");
}