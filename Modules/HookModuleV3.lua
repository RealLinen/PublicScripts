loadstring(game:HttpGet("https://raw.githubusercontent.com/RealLinen/PublicScripts/main/Modules/SXV3Fixes.lua"))() -- For global fixes in getreg
repeat task.wait() until not getreg().HookModuleV3ByLinenLoading
getreg().HookModuleV3ByLinenLoading = true
--========================================================--
local __cachedTime: number, ENV: {} = tick(), nil;
getreg().cachedHookMethod = type(getreg().cachedHookMethod)=="table" and getreg().cachedHookMethod or {}
local ToHook = { "__index", "__namecall" }
local HookedTable = {}
setmetatable(ToHook, { ["__index"] = function(self, key) return rawget(self, key) end })
getreg().________________PU_LSEX = type(getreg().________________PU_LSEX)=="number" and getreg().________________PU_LSEX + 1 or 0;local ________________PU_LSEXS=tonumber((getreg().________________PU_LSEX))local isver = function()return getreg().________________PU_LSEX==________________PU_LSEXS end
--========================================================--
for i,v in pairs(ToHook) do
    if type(v)=="string" then
        if getreg().cachedHookMethod[v] and restorefunction then
            local suc, msg = pcall(function() return restorefunction(getrawmetatable(game)[v]) end)
            if suc then getreg().cachedHookMethod[v] = nil;print("Resetted '"..v.."' Hook: "..tostring(msg)) end
        end
        if type(getreg().cachedHookMethod[v.."_"])~="table" then
            getreg().cachedHookMethod[v.."_"] = {}
        end
        if not getreg().cachedHookMethod[v] then
            print("[ Hooked ] : "..v)
            getreg().cachedHookMethod[v] = hookmetamethod(game, v, newcclosure(function(...)
                 local Args = {...}
                 local result;
                 local DataTable = {
                    ["checkcaller"] = checkcaller, 
                    ["getcallingscript"] = getcallingscript, 
                    ["returning"] = function(...) return getreg().cachedHookMethod[v](...); end,
                    ["namecallmethod"] = type(getnamecallmethod)=="function" and getnamecallmethod() or nil
                 }
                 if type(getreg().cachedHookMethod[v.."_"])=="table" then
                     for i,v in pairs(getreg().cachedHookMethod[v.."_"]) do
                         if type(i)=="number" and type(v)=="function" then
                             local suc, tb = pcall(function(...)
                                 return { (newcclosure(v))((type(DataTable)=="table" and DataTable or {}), ...) }
                             end, ...)
                             if suc and type(tb)=="table" and tb[1]~=nil then result = tb end
                         end
                     end
                 end
                 return type(result)=="table" and unpack(result) or DataTable.returning(...)
            end))
        end
        HookedTable[v] = {
            new = function(self, func) if type(func)=="function" then local newint = (#getreg().cachedHookMethod[v.."_"]) + 1;getreg().cachedHookMethod[v.."_"][newint] = func end end,
            delete = function(self, int) int = (int~=nil) and int or #getreg().cachedHookMethod[v.."_"];(getreg().cachedHookMethod[v.."_"])[i][int] = nil; end
        }
    end
end
--========================================================-- DEBUGGING
__cachedTime = tick() - __cachedTime
if not getgenv().LinenHookModuleNodebug then
    print("Took "..__cachedTime.."s".." For HookModule V3 to Load | Creator: Linen#3485")
end
--========================================================-- Usage Example
--HookedTable["__index"]:new(function(Data, Self, Key) -- newcclosure is already called on it, don't worry about that.
     --[[
        Data is a table, the contents inside of it are:
            checkcaller: function [ If its fired by synapse or the game ] -- Usage Example:
                                                 local ischeckcaller = Data.checkcaller()
                                                 if ischeckcaller then
                                                    print("This hook was called by a script in Synapse X")
                                                 else
                                                    print("This hook was called by a script in the game/localscript in the game")
                                                 end
            getcallingscript: function [ Get script thats calling it's name ] -- Usage Example:
                                                 local scriptName = Data.getcallingscript() -- scriptName
                                                 local scriptPath = Self:GetFullName().. "." ..Data.getcallingscript()
                                                 print(scriptPath) -- The path of where the script came from
                                                 print(scriptName) -- The name of the script
            returning: function -- Usage Example:
                                                 local result = Data.returning(Self, Key, ...)
                                                 print(result) -- will print what the normal response of the hook is
           ( FOR __namecall ONLY ) namecallmethod: string -- The NameCallMethod, Example:
                                                 game:GGMZZZZ(), 'GGMZZZZ' would be the namecallmethod and Self would be game
                                                 
    ]]
--end)
--========================================================--
print("==============================================")
getreg().HookModuleV3ByLinenLoading = false
HookedTable.isver = isver;return HookedTable --[[
    ["__index"] = {
        new: function,
        delete: function
    },
    ["__namecall"] = {
        new: function( arg1: function )
    }
]]
