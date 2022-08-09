-- Made by Linen#3485
if not getgenv().protect_instance then getgenv().protect_instance, getgenv().unprotect_instance = loadstring(game:HttpGet("https://pastebin.com/raw/Ai9BnM07"))() end
getreg().________________PU_LSEX = type(getreg().________________PU_LSEX)=="number" and getreg().________________PU_LSEX + 1 or 0;local ________________PU_LSEXS=tonumber((getreg().________________PU_LSEX));local function isver()return getreg().________________PU_LSEX==________________PU_LSEXS end
-- [[---------------- [[ Hooking ]] ----------------]] --
local Hooks = { stored = {} }
Hooks.old = nil;
Hooks.old = hookmetamethod(game, "__namecall", newcclosure(function(Self, ...)if not isver()then return Hooks.old(Self, ...); end;local z;
    local Args = {...};local NamecallMethod = getnamecallmethod();if true then for i,v in pairs(Hooks.stored) do if type(v)=="function" then local rs = v(checkcaller(), Self, NamecallMethod, ...);if rs then z = rs end end end end
    return z or Hooks.old(Self, ...);
end))
function Hooks:new(check, indname) check = type(check)=="function" and check or function() end if not indname then indname = #Hooks.stored+1 end;Hooks.stored[indname] = check;end
function Hooks:delete(ind) if not ind then return; end;Hooks.stored[ind] = nil;end
local Hooks2 = { stored = {} }
Hooks2.old = nil;
Hooks2.old = hookmetamethod(game, "__index", newcclosure(function(Self, Key, ...)if not isver()then return Hooks2.old(Self, Key, ...); end;local z;
    if true then for i,v in pairs(Hooks2.stored) do if type(v)=="function" then local rs = v(checkcaller(), Self, Key, ...);if rs then z = rs end end end end
    return z or Hooks2.old(Self, Key, ...);
end))
function Hooks2:new(check, indname) check = type(check)=="function" and check or function() end if not indname then indname = #Hooks2.stored+1 end;Hooks2.stored[indname] = check;end
function Hooks2:delete(ind) if not ind then return; end;Hooks2.stored[ind] = nil;end
local __indexHook = Hooks2
local __namecallHook = Hooks
------------------------------------
-- Anti kick Example
__namecallHook:new(newcclosure(function(checkcaller --[[ If it's synapses thread/called from synapse or not || THIS IS A BOOL! ]], Self, Callmethod, ...)
    local arg = {...}
    if not checkcaller then -- Not called by synapse
        if tostring(Callmethod):lower():match(tostring("Kick"):lower()) then -- If the Callmethod ( Self:<callmethod> ) is kick then the game is prob tryna kick you
            return nil -- nil to do nothing
        end
    end
    -- If you don't return anything, it'll just return the default: __namecallHook.old(Self, ...) so you don't need to return anything basically
end))
-------------------------------- To be used as a module
return Hooks
