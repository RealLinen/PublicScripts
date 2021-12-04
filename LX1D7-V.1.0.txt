-- SINCE PEOPLE KEPT SAYING I SKIDDED OFF ENDIRU ON V3rmillion, I WAS FORCED TO RELEASE THE OPEN SOURCE.
-- IF YOU START SEEING PAID SCRIPT HUBS THAT HAVE INF NITRO, CHECK IF getreg().cnt OR getreg.DATA_DONTMODIFY EXIST!
local suc,err = pcall(function()
    warn("__________________________________ NEW CODE __________________________________")
---------------------------- Required Stuff
getreg().DATA_DONTMODIFY = {variableFreeze={}} -- basically the function|| Saves data
local _ ,__= pcall(function()
    return tonumber(getreg().cnt) or 0
end);if(not(_))then return;end;getreg().cnt=__;getreg().cnt=getreg().cnt+1;_=nil;__=nil;local __metaindexoml=(tonumber(getreg().cnt)) or 1;
local function IsCurrentVersion()
    return{getreg().cnt==__metaindexoml,__metaindexoml};
end
----------------------------
local m = "THIS SCRIPT IS USING A SEARCHGC FUNCTION MADE BY LINEN ON V3RMILLION: https://v3rmillion.net/member.php?action=profile&uid=2467334"
warn(m)
print(m)
if getfenv().searchGC then
    return{true}
end
local searchGC = function(name,newV,aE)
    aE = typeof(aE)=="table" and aE or {}
    aE.lock = aE.lock and typeof(aE.lock)=="boolean" and aE.lock or false;
    aE.table = aE.table and typeof(aE.table)=="boolean" and aE.table or false; -- arguments
    name = tostring(name) or "example";
    local tE = {};
    for a,b in next, getgc() do
        if type(b) == 'function' then
            for c,d in next, debug.getupvalues(b) do
               if type(d) == 'function' then
                  for e,f in next, debug.getupvalues(d) do
                      if type(f) == 'table' then
                          for g,h in next, f do -- something that took me 10 minutes to do
                            if(aE.table)then
                                if string.match(tostring(g):lower(),tostring(name):lower())then
                                    tE[tostring(g)]=h
                                end
                            end
                            if tostring(g):lower()==tostring(name):lower() and not aE.table then
                                if(newV) then
                                    if(getreg().DATA_DONTMODIFY.variableFreeze[g]) then
                                        getreg().DATA_DONTMODIFY.variableFreeze[g]=nil;
                                    end
                                    wait(.05)
                                    f[g]=newV
                                    getreg().DATA_DONTMODIFY.variableFreeze[g] = true
                                    coroutine.resume(coroutine.create(function()
                                        while wait() and IsCurrentVersion()[1] and getreg().DATA_DONTMODIFY.variableFreeze[g] and aE.lock==true do
                                            pcall(function()
                                                f[g]=newV -- keeps changing the variable for inf change
                                            end)
                                        end
                                    end))
                                   -- debug.setupvalue(d,e,newt)
                                    return{h,"newvalue"}
                                end 
                                return{h}
                           end
                        end
                    end
                end
            end
               if type(d)=="table" then
                local brooml = {debug.getupvalues(b),c}
                 for e,f in next, d do
                    if(aE.table)then
                        if string.match(tostring(e):lower(),tostring(name):lower())then
                            tE[tostring(e)]=f
                        end
                    end
                    if tostring(e):lower()==tostring(name):lower() and not aE.table then
                        if(newV) then
                            if(getreg().DATA_DONTMODIFY.variableFreeze[e]) then
                                getreg().DATA_DONTMODIFY.variableFreeze[e]=nil;
                            end
                            wait(.05)
                            d[e]=newV
                            getreg().DATA_DONTMODIFY.variableFreeze[e] = true
                            coroutine.resume(coroutine.create(function()
                                while wait() and IsCurrentVersion()[1] and getreg().DATA_DONTMODIFY.variableFreeze[e] and aE.lock==true do
                                    pcall(function() d[e]=newV end)
                                end
                            end))
                            --debug.setupvalue(b,c,newt) -- I thought this didn't change the value but it did, but it lags.
                            return{f,"newvalue2"}
                        end 
                        return{f}
                    end
                 end
               end          
            end
        end
     end
     if aE.table then
         return{tE,"table"}
     end
     return {nil};
end
getfenv().searchGC=searchGC;
return true
end)
if not suc then return{suc,err} end
return {err}
