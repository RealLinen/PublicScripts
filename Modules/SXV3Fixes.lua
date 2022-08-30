local Misc = {
    ["getreg"] = "____________DHGJDIHBWNDJFUHEJIUFHBNJINXJHBXN!&*(#HUWBDNJIUHWBDstoredReg"
}

getgenv()[Misc.getreg] = getgenv()[Misc.getreg] or {}
--------
getgenv()["getreg"] = function()return (getgenv()[Misc.getreg] or {}) end -- Makes getreg writeable
-------
getgenv()[Misc.getreg].__LinenHooked = true
--[[
    This just replaces the functions that used to be tables but are now 'userdata' [ getreg is the only one I know of now ]
]]
