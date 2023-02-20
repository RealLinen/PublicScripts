-- DOCUMENTATION: https://linenreal.gitbook.io/hookmetamethodapi/
-- V3rmillion Thread: https://v3rmillion.net/showthread.php?tid=1201899
-- Created by [ my discord ]: Linen#3485

Configuration = { -- DONT CHANGE THIS AT ALL [ if you change and use this in ur script, it _could_ get taken down ]
["Creator"] = "Linen#3485",
["Version"] = "0.3", 
["Details"] = "Changed it so you can capture real value even if .hook was used on it"
}
local isver = getfenv().isver or loadstring(game:HttpGet("https://raw.githubusercontent.com/RealLinen/PublicScripts/main/Community/isver.lua"))()
--========================================================--
--[[ Usage: 
    Instance: Basically anything [ table, humanoid, baseplate, part, etc ]
    Property: A value in the Instance, example, the players Humanoid has an property named "WalkSpeed" or "JumpPower" or "Health", thats what a property is. A value in the Instance to spoof/hook
]]
--========================================================--
local function resetHookMethod(v)
    local suc, msg = pcall(function() return restorefunction(getrawmetatable(game)[v]) end)
    if suc then return true end;return false, msg
end
local function InstallizeTable(tb) 
    if type(tb)~="table" then return; end
    function tb:new(func, custom)
        custom = (type(custom)=="string" or type(custom)=="number") and custom or #tb+1
        tb[custom] = func
        return custom
    end
    function tb:remove(int) 
        tb[(int or #tb)] = nil
    end
end

local Storage = { ["IndexHooks"] = {}, ["Locks"] = {}, ["NamecallHooks"] = {}, ["_Locks"] = {} }
local Hooking = { ["__index"] = {}, ["__namecall"] = {}, ["__newindex"] = {} }
for i,v in next, Hooking do
    resetHookMethod(i)
    InstallizeTable(v)
end
--========================================================--
local oldIndex;oldIndex=hookmetamethod(game, "__index", newcclosure(function(Self, Index, ...)
    local Args = {...};local function defaultValue()return oldIndex(Self, Index, unpack(Args)) end;if not isver() then return defaultValue() end 
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    if true~=false then Storage["IndexHooks"][Self] = type(Storage["IndexHooks"][Self])=="table" and Storage["IndexHooks"][Self] or {};Storage["Locks"][Self] = type(Storage["Locks"][Self])=="table" and Storage["Locks"][Self] or {} end
    if checkcaller() then
        if type(Index)=="string" then local lowered = Index:lower()
        --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        if lowered=="sethook" or lowered=="hook" then
            return function(...) local _Arg = {...}
                local arg1 = _Arg[1]
                local arg2 = _Arg[2];if not arg1 or not arg2 then return "Invalid Usage! example usage: workspace."..Index.."( "..string.format([[Name, 'hookedWorkspaceName']]).." )" end
                ---------------------
                if type(arg2)=="table" and arg2["Original"] then
                    Storage["IndexHooks"][Self][(type(arg1)=="function" and arg1() or arg1)] = function(...)Storage["_Locks"][Self] = type(Storage["_Locks"][Self])=="table" and Storage["_Locks"][Self] or {};return Storage["_Locks"][Self][Index] or defaultValue() end
                    return "Successfully hooked to normal value"
                end
                Storage["IndexHooks"][Self][(type(arg1)=="function" and arg1() or arg1)] = function(...) if type(arg2)=="function" then return arg2(...) end;return arg2 end
                return "Successfully attempted to set the hook!"
            end
        end
        if lowered=="removehook" or lowered=="deletehook" or lowered=="destroyhook" or lowered=="resethook" or lowered=="rmvhook" or lowered=="unhook" then
            return function(...) local _Arg = {...}
                local arg1 = _Arg[1];if not arg1 then return "Invalid Usage! example usage: workspace."..Index.."( "..string.format([[Name]]).." )" end
                Storage["IndexHooks"][Self][(type(arg1)=="function" and arg1() or arg1)] = nil
                return "Successfully attempted to remove the hook"
            end
        end
        if lowered=="removelock" or lowered=="deletelock" or lowered=="destroylock" or lowered=="resetlock" or lowered=="rmvlock" or lowered=="unlock" then
            return function(...) local _Arg = {...}
                local arg1 = _Arg[1];if not arg1 then return "Invalid Usage! example usage: workspace."..Index.."( "..string.format([[Name]]).." )" end
                Storage["Locks"][Self][(type(arg1)=="function" and arg1() or arg1)] = nil
                return "Successfully attempted to remove the hook"
            end
        end
        if lowered=="lock" or lowered=="lockvalue" then
            return function(...) local _Arg = {...}
                local arg1 = _Arg[1]
                local arg2 = _Arg[2];if not arg1 then return "Invalid Usage! example usage: workspace."..Index.."( "..string.format([[Name]]).." )" end
                Storage["Locks"][Self][(type(arg1)=="function" and arg1() or arg1)] = type(arg2)~="boolean" and arg2 or true
                if _Arg[3] then pcall(function() Self[arg2] = Self[arg2] end) end
                return "Successfully locked the object to the value its at currently [ it cant be changed and will remain at the value its at right now ]"
            end
        end
        --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        end
    end
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    if not checkcaller() then
        local indT = Storage["IndexHooks"][Self]
        if indT and rawget(indT, Index) then
            local indexFound = indT[Index]
            if type(indexFound)=="function" then return indexFound(Self, Index, Self[Index], ...) end
            return indexFound
        end
    end
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    return defaultValue()
end))
--========================================================--
local oldNamecall;oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(Self, ...)
    local Args = {...};local function defaultValue()return oldNamecall(Self, unpack(Args)) end;if not isver() then return defaultValue() end
    local Index = getnamecallmethod()
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    if true~=false then Storage["NamecallHooks"][Self] = type(Storage["NamecallHooks"][Self])=="table" and Storage["NamecallHooks"][Self] or {};Storage["Locks"][Self] = type(Storage["Locks"][Self])=="table" and Storage["Locks"][Self] or {} end
    if checkcaller() and tostring(Index) then local lowered = tostring(Index):lower();local _Arg = Args;
        if lowered=="sethook" or lowered=="hook" then
            local arg1 = _Arg[1]
            local arg2 = _Arg[2];if not arg1 or type(arg2)~="function" then return "Invalid Usage! example usage: workspace:"..Index.."( "..string.format([[EventName, 'function']]).." )" end
            ---------------------
            Storage["NamecallHooks"][Self][arg1] = arg2
            return "Successfully __namecall hooked!"
        end
        if lowered=="removehook" or lowered=="deletehook" or lowered=="destroyhook" or lowered=="resethook" or lowered=="rmvhook" or lowered=="unhook" then
            local arg1 = _Arg[1];if not arg1 then return "Invalid Usage! example usage: workspace:"..Index.."( "..string.format([[EventName]]).." )" end
            Storage["NamecallHooks"][Self][arg1] = nil
            return "Successfully removed __namecall hooked!"
        end
    end
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    if not checkcaller() then
        local indT = Storage["NamecallHooks"][Self]
        if indT and rawget(indT, Index) then
            local indexFound = indT[Index]
            if type(indexFound)=="function" then 
                local gotten = nil
                local endit = function(...) gotten = {...} end
                pcall(indexFound, endit, Self, ...)
                if type(gotten)=="table" then return unpack(gotten) end
            end
        end
    end
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    return defaultValue()
end))
--========================================================--
local oldNewIndex;oldNewIndex = hookmetamethod(game, "__newindex", newcclosure(function(Self, Index, NewIndex, ...)
    local Args = {...};local function defaultValue()return oldNewIndex(Self, Index, NewIndex, unpack(Args)) end;if not isver() then return defaultValue() end
    Storage["Locks"][Self] = type(Storage["Locks"][Self])=="table" and Storage["Locks"][Self] or {}
    Storage["_Locks"][Self] = type(Storage["_Locks"][Self])=="table" and Storage["_Locks"][Self] or {}
    Storage["_Locks"][Self][Index] = NewIndex
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    if true~=false and type(Storage["Locks"][Self])=="table" then
        local indexLockFound = Storage["Locks"][Self][Index]
        if indexLockFound then
            if type(indexLockFound)~="boolean" and indexLockFound then
                if type(indexLockFound)=="function" then
                    return oldNewIndex(Self, Index, indexLockFound(), unpack(Args))
                end
                return oldNewIndex(Self, Index, indexLockFound, unpack(Args))
            end
            return function()return nil, true end
        end
    end
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    return defaultValue()
end))
--========================================================--
getfenv().isver = isver;print("HookMetamethodAPI: Loaded\n===========================================")
