# PsychMelt (Rewrite)

"Troll Engine but Evil or something idk" (ts just an inside joke soo don't take it seriously btw!!!!)

This is a small fork of Psych 0.6.3 that I made for a mod I work on etc!

## Download Engine
### Compile
TBA

### Get Pre-Compiled Engine
You can download latest build of this engine at [Nightly.link](https://nightly.link/lasystuff/PsychMelt-Rewrite-mirror/workflows/main/main/windowsBuild.zip)!

#### Features

- Fairly advanced HScript support
```haxe
//Template of Hscript Script

function onCreatePost()
{
    //You don't need "FlxG.state"(or game or something) to change current Instance
    boyfriend.color = FlxColor.RED;
    boyfriend.alpha = 0.5;
    return FunkinLua.Function_Stop; //also you can return "Function_" thing like doing in lua!
}
```
- Fully rewritten lua

- Scripted Classes! (Supports many features such as direct instantiation with new() function, static fields and etc!!!!)

- little Chart editor reworks (Organizing the time display, blue(coolest color) ui, Shift + Enter for instant preview, Ctrl + S shortcut)

- Mod folder loading has been slightly overhauled (it now uses the content folder instead of the mods folder like Hit Single does)

- Song Metadata (You can set the display name of the song and the artist that will be displayed on the pause screen)

- Modchart Manager from Andromeda Engine