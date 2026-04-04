
if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    trace("Debugger ok")
    require("lldebugger").start()
end

require "inflate"
require "Helpers"
require "FileSystem"
require "Maths"
require "DrawCommon"
require "fxDisolve"
require "fxModel"
require "fxText"
require "fxBlower"
require "fxTerrain"
require "fxBalls"
require "fxPowerOff"
require "fxSprite"
require "fxDraw"
require "fxBorder"
require "fxColorRemplace"
require "fxFadePal"
require "fxPalette"
require "fxTunnel"
require "fxSplit"
require "fxImage"
require "fxCls"
require "fxRoll"
require "fxZoom"
require "fxMusic"
require "fxBdrGradient"

require "Demo"

