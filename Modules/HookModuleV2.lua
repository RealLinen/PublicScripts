-- Linen#3485 Scripting Session Below --
--[[ version: J.0.5
    HookModule V2 =>>
        * Faster than HookModule V1 [ by 3 seconds ]
        * More customization
        * Better Handling
        * Easily add more hook methods
        * Easy to understand [ well, requires some good knowlege about metatables and game hooking on roblox, not hard to learn tho ]
]]
local __cachedTime: number, ENV: {} = tick(), nil;
getgenv().__LinenData = type(getgenv().__LinenData)=="table" and getgenv().__LinenData or {}
getreg = getloadedmodules and function()return getgenv().__LinenData;end or getreg;ENV = getreg() -- For synapse V3
----------------------------
local isver = getfenv().isver or loadstring(game:HttpGet("https://raw.githubusercontent.com/RealLinen/PublicScripts/main/Community/isver.lua"))()
--========================================================--
local function resetHookMethod(v)
    local suc, msg = pcall(function() return restorefunction(getrawmetatable(game)[v]) end)
    if suc then return true end;return false, msg
end
----------------------------
task.spawn(function()
    if not getgenv().protect_instance then getgenv().protect_instance, getgenv().unprotect_instance = loadstring(game:HttpGet("https://pastebin.com/raw/Ai9BnM07"))() end
end)
--|| ++++============================++++ ||--
local Hooks = {}
local Methods = { "__namecall", "__index" } -- can keep on adding
--|| ++++============================++++ ||--
for i,v in next, Methods do
    if type(Hooks[v])~="table" or not(Hooks[v].new or Hooks[v].delete) then
        resetHookMethod(v)
        Hooks[v] = { 
            new = function(self, func)
                if typeof(func)~="function" then return false; end
                local int = #Hooks[v]
                Hooks[v][ tonumber(int + 1) ] = func
            end,
            delete = function(self, int)
                int = type(int)=="number" and int or #Hooks[v]
                Hooks[v][ tonumber(int) ] = nil
            end
        };Hooks[ v ].destroy=Hooks[v].delete;
    end
    -- [[|===>|;:>._.<:; | HOOKS | ;:>._.<:;|<===|]] --
    task.spawn(function(Hooks, v)
        Hooks[ v ].old = nil;
        Hooks[ v ].old = hookmetamethod(game, v, newcclosure(function(...)if not isver() then return Hooks[v].old(...) end;local result;
            for i,z in pairs(Hooks[v]) do
                if type(i)=="number" and type(z)=="function" then
                local resultX, output = pcall(function(z, ...)
                    return { z({ 
                        ["checkcaller"] = checkcaller, 
                        ["getcallingscript"] = getcallingscript, 
                        ["returning"] = function(...) return Hooks[v].old(...); end,
                        ["namecallmethod"] = type(getnamecallmethod)=="function" and getnamecallmethod() or nil
                        }, ...) 
                    } -- This code is ugly, thats how i roll!
                end, z, checkcaller, getcallingscript, ...)
                if resultX then result = output end
            end
        end
        return result and unpack(result)  or Hooks[v].old(...);
    end))    
    end, Hooks, v)
end
--|| ++++============================++++ ||-- End
__cachedTime = tick() - __cachedTime
if not getgenv().LinenHookModuleNodebug then
    print("Took "..__cachedTime.."s".." For HookModule V2 to Load ( 3 seconds faster than HookModuleV1 ) | Creator: Linen#3485")
end
--|| ++++============================++++ ||-- Documentation:

local __indexHook = Hooks["__index"]
local __namecallHook = Hooks["__namecall"]
__indexHook:new(function(Data, Self, Key, ...) -- Already uses newcclousure
    --[[
        Data: table 0x......
            checkcaller: function [ If its fired by synapse/ur exploit or the game ] -- Usage Example:

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
    -- If you don't return anything, it return the normal call/what it would normally return
    -- Fun fact: If you want to break the game, put: return "break"
end)
-- [[|===>|;:>._.<:; | Returning Module | ;:>._.<:;|<===|]] --
Hooks.isver = isver;
return Hooks --[[
    {
        ["__index"] = {
            ["new"]: function,
            ["destroy"]: function,
            ["delete"]: function
        }
        ["__namecall"] = {
            ["new"]: function,
            ["destroy"]: function,
            ["delete"]: function
        }
    }
]]
