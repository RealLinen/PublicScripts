--------------------------------------------------------------------
getgenv().________________PU_LSEX = type(getgenv().________________PU_LSEX)=="number" and getgenv().________________PU_LSEX + 1 or 0;local ________________PU_LSEXS=tonumber((getgenv().________________PU_LSEX))local isver = function()return getgenv().________________PU_LSEX==________________PU_LSEXS end
--------------------------------------------------------------------
return isver
