-- Thread: 
-----------------------------------
-- Please dont steal credits, this is made by Linen#3485
--=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-==-=--=-=-=-=-=-=-=-=-=--
getgenv().CopyToClipboard = typeof(getgenv().CopyToClipboard)=="function" or false -- Copies the path to your clipboard
    -- If you want to disable, set to false, or else, get your exploits clipboard function
    local function GetAll(pp,inc)
        local result;
        pcall(function()
           result = ""
           inc = typeof(inc)=="string" and tostirng(inc) or "."
           for i,v in pairs(pp) do
               if v~=nil then
                   if #pp~=i then result = result..v..inc else result = result..v end
               end
           end
        end)
        return result
    end
    local GetPath = function(v)
        local suc,body = pcall(function()
            local d = tostring(v:GetFullName()) -- Gets the full parent
            local a = string.split(d,".") -- Splits the parents '.'
            local b = string.split(d,".")[1] -- Gets the Service the Parent is in
            a[1]=nil;a=GetAll(a); -- Im not gonna explain this, just learn more
            -- about lua
            local path = "game:GetSerivce('"..tostring(b).."')."..tostring(a) -- this was easy to make
            return path
        end)
        return{suc,body}
    end
    local Get = function(Check,service,d) 
        local suc,body = pcall(function()
            Check = typeof(Check)=="function" and Check or function() return true end;
            service = (typeof(service)=="string" and game:GetService(service)) or game:GetService("Workspace");
            if typeof(d)=="boolean" and d==true then
                local __ = {}
                for i,v in pairs(service:GetDescendants()) do
                    wait()
                    if pcall(Check,v) and Check(v) then
                        __[#__+1] = GetPath(v)[2].." | Text or Value: "..(pcall(function()
                            return v.Text
                        end) and v.Text) or (pcall(function()
                            return v.Value
                        end) and v.Value) or (nil)
                    end
                end
                return __
            else
                for i,v in pairs(service:GetDescendants()) do
                    wait()
                    if pcall(Check,v) and Check(v) then
                        if typeof(getgenv().CopyToClipboard)=="function" then getgenv().CopyToClipboard(GetPath(v)[2]) end
                        return GetPath(v)[2]
                    end
                end 
            end
        end)
        if not suc then
            return{false,body}
        else
            return{true,body}
        end
    end
return Get;
