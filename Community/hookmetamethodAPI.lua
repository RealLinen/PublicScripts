--[[ Usage: 
    Instance: Basically anything [ table, humanoid, baseplate, part, etc ]
    ----------------------
    Instance.sethook or Instance.hook || Instance.sethook("Property", "Value") -- Hooks that instance to show "Value" as an discuise so the real value of that Property of the Instance is Hidden
    Instance.removehook or Instance.rmvhook || Instance.removehook("Property") -- Removes the hook so the real value of that Property can be shown
    Instance.lock || Instance.lock("Property", [ optinal] "Value") -- if you provide an second argument the property of that Instance will remain that Value, else it will remain the value it is and cannot be changed
    Instance.unlock, Instance.rmvlock || Instance.unlock("Property") -- self explanitory, makes it so you can change the Property of that Instance again
]]

-- Version 0.1
local isver = getfenv().isver or loadstring(game:HttpGet("https://raw.githubusercontent.com/RealLinen/PublicScripts/main/Community/isver.lua"))()
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

local Storage = { ["IndexHooks"] = {}, ["Locks"] = {} }
local Hooking = { ["__index"] = {}, ["__namecall"] = {} }
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
            if lowered=="lock" then
                return function(...) local _Arg = {...}
                    local arg1 = _Arg[1]
                    local arg2 = _Arg[2];if not arg1 then return "Invalid Usage! example usage: workspace."..Index.."( "..string.format([[Name]]).." )" end
                    Storage["Locks"][Self][(type(arg1)=="function" and arg1() or arg1)] = type(arg2)~="boolean" and (type(arg2)=="function" and arg2() or arg2) or true
                    return "Successfully locked the object to the value its at currently [ it cant be changed and will remain at the value its at right now ]"
                end
            end
        --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        end
    end
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    local indT = Storage["IndexHooks"][Self]
    if indT and rawget(indT, Index) then
        local indexFound = indT[Index]
        if type(indexFound)=="function" then return indexFound(Self, Index, ...) end
    end
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    return defaultValue()
end))
--========================================================--
local oldNewIndex;oldNewIndex = hookmetamethod(game, "__newindex", newcclosure(function(Self, Index, NewIndex, ...)
    local Args = {...};local function defaultValue()return oldNewIndex(Self, Index, NewIndex, unpack(Args)) end;if not isver() then return defaultValue() end 
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    if true~=false and type(Storage["Locks"][Self])=="table" then
        local indexLockFound = Storage["Locks"][Self][Index]
        if indexLockFound then
            if type(indexLockFound)~="boolean" and indexLockFound then
                return oldNewIndex(Self, Index, indexLockFound, unpack(Args))
            end
            return function()return nil, true end
        end
    end
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    return defaultValue()
end))
