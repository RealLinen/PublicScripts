local Misc = {
    ["getreg"] = "____________DHGJDIHBWNDJFUHEJIUFHBNJINXJHBXN!&*(#HUWBDNJIUHWBDstoredReg"
}

getgenv()[Misc.getreg] = getgenv()[Misc.getreg] or {}
--------
getgenv()["getreg"] = getgenv()[Misc.getreg] -- Makes getreg writeable
-------
getgenv()[Misc.getreg].__LinenHooked = true
--[[
    This just replaces the functions that used to be tables but are now 'userdata' [ getreg is the only one I know of now ]
]]
