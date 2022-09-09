local genv = getgenv()
local __Modules = { }
Format = function(...)return string.format(...) end
Camera = workspace.CurrentCamera
--=========================================--
-- [[ Clearing Cache'Loading Modules ]] --
local __timeRecorder = tick()
__Modules.isver = loadstring(game:HttpGet("https://raw.githubusercontent.com/RealLinen/PublicScripts/main/Community/isver.lua"))()
__Modules.TeamChecker = loadstring(game:HttpGet("https://raw.githubusercontent.com/RealLinen/PublicScripts/main/Community/TeamChecker.lua"))()
local isver = __Modules.isver;local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/Revenant", true))();local Flags = Library.Flags;Flags.KeysDown = {};local Character, RootPart, Output = nil, nil, {}; local Player = game:GetService("Players").LocalPlayer ; local PlaceId = (game.PlaceId.."") ; local Settings = {"__UNIDSAVING", (game.PlaceId)..".linencool.txt", {}};local Functions = {}
__Modules.protect_instance, __Modules.unprotect_instance = loadstring(game:HttpGet("https://pastebin.com/raw/Ai9BnM07"))()
--=========================================--
-- [[ Loading Variables for Modules ]] --
Functions.press = function(key, waittime)local vim = game:GetService"VirtualInputManager";key = type(key) == "string" and key:upper() or "W";waittime = type(waittime) == "number" and waittime or 1;task.delay(0,function()vim:SendKeyEvent(true, key, false, game);task.wait(waittime);vim:SendKeyEvent(false, key, false, game)end)end
Functions.countTable = function(t) t = typeof(t)=="table" and t or {};local m = 0;for i,v in pairs(t) do m = m+1 end;return m;end
Functions.getInTable = function (t, n) t = typeof(t)=="table" and t or {};local m=0;if t[n] then return t[n] end;for i,v in pairs(t) do m=m+1;if m==n then return v end end;return nil; end
Functions.getNearestObject = function(b,c)if typeof(b)~="Instance"then return end;if type(c)~="table"then return end;local d;local e=math.huge;for f,g in next,c do if (pcall(function()for i,v in pairs(g) do end end))then for f,h in pairs(g)do if type(f)=="string"and f:lower():match("root")and typeof(h)=="Instance"and pcall(function()return h.CFrame end)then local i=(b.CFrame.Position-h.CFrame.Position).Magnitude;if e>i then e=i;d=g end end end end end;return d,e end
Functions.Find = function(inst, v)local suc,err = pcall(function()return inst[v];end);return suc and err or false end;
--==================================================--
genv.LinenData = genv.LinenData or { Loops = {} }
genv.LinenData.Loops = {} -- resetting loops table on execute
--=========================================--
-- [[ Loops ]] --
--=========================================--
if not genv.LinenData.Looped then
    genv.LinenData.Looped = true
    game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
        local passed, tb = pcall(function()return genv.LinenData.Loops;end)
        if passed and type(tb)=="table" then
            for i,v in pairs(tb) do
                if type(v)=="function" then
                    v(deltaTime)
                end
            end
        end
    end)
end;print("<< MZND >>")
return { ["addFunction"] = function(s)
    genv.LinenData.Loops[#genv.LinenData.Loops+1] = s
end, ["isver"] = isver, ["Camera"] = Camera, ["Format"] = Format, ["Functions"] = Functions, ["__Modules"] = __Modules }
