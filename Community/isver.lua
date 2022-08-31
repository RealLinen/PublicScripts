--------------------------------------------------------------------
getreg().________________PU_LSEX = type(getreg().________________PU_LSEX)=="number" and getreg().________________PU_LSEX + 1 or 0;local ________________PU_LSEXS=tonumber((getreg().________________PU_LSEX))local isver = function()return getreg().________________PU_LSEX==________________PU_LSEXS end
--------------------------------------------------------------------
return isver
