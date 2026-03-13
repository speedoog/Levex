del release.lua
del release.tic
type Helpers.lua FileSystem.lua DrawCommon.lua Maths.lua Fx*.lua Demo.lua Levex.lua > release.lua

tic80_Pro_official.exe --skip --fs . --cmd "load release.lua & save release.tic"
del release.lua
