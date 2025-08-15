package melt.data;

class Constants
{
    public static inline final ENGINE_WINDOW_PREFIX:String = "PsychMelt";
    public static inline final ENGINE_VERSION:String = "0.0.1";

    public static inline final CONTENT_ROOT_FOLDER:String = "content";

    public static inline final SONG_DEFAULT_ARTIST:String = "????";
    public static inline var SONG_DEFAULT_HUD(get, never):String = "melt.gameplay.hud.PsychHUD";
    static inline function get_SONG_DEFAULT_HUD():String
        return Content.getFlag("DEFAULT_HUD", SONG_DEFAULT_HUD);
}