---@diagnostic disable: undefined-global
loadstring(game:HttpGet("https://api.irisapp.ca/Scripts/IrisInstanceProtect.lua"))();
--==========================================================================--
local Format = string.format;
local TS, UIS, HttpService, Players = game:GetService("TeleportService"), game:GetService("UserInputService"), game:GetService("HttpService"), game:GetService("Players")
local JSON = { Encode = function(arg1: table, ...)return HttpService:JSONEncode(arg1, ...)end;Decode = function(arg1: string, ...)return HttpService:JSONDecode(arg1, ...);end}
--==========================================================================--
getconnections = getconnections or function() end;setclipboard=setclipboard or copytoclipboard or copytoboard or copytoclip or setclip or setboard;rconsoleprint=rconsoleprint or consoleprint or rrconsoleprint or rconsolepprint or function(...)return warn(...)end;firetouchinterest=firetouchinterest or fireinterest or firetouch or fireparttouch or firetouchevent or firetouched or firetouchedevent or function(...)return...end;firesignal=firesignal or firesig or firepropertysignal or firepropertyclass;request=request or syn and syn.request or http_request or httprequest or send_request or sendrequest or secretrequestfunc;readfile=readfile or getfile or getfileinput or inputfile or inputoffile;readfolder=readfolder or getfolder or getfolderfiles or getfiles or getfolderfile or getfolderinput or getfolderfileinput;isfile=isfile or checkfile;isfolder=isfolder or checkfolder;makefolder=makefolder or newfolder or createfolder or writefolder;makefile=makefile or newfile or createfile or writefile;mouse1press=mouse1press or mouse1hold or mouse1activate or mouse1click;mouse1release=mouse1release or mouserelease1 or mouse1unhold or mouse1deactivate or mouse1unactivate
if not LPH_OBFUSCATED then LPH_JIT_MAX = function(...) return(...) end;LPH_NO_VIRTUALIZE = function(...) return(...) end; end;
local function getBodyParts(name, func) name = type(name)=="string" and name or nil;if not name then return {}; end;local cached = {};func = type(func)=="function" and func or function()return true end
    if not Character then return cached end;for i,v in next, Character:GetChildren() do
        if name:lower():match(v.Name:lower()) and func(v) then cached[v.Name] = v end;
    end;return cached
end
local function get(v, a, c) 
    if (type(v)=="table" or typeof(v)=="Instance") and type(a)~="nil" then
        local passed, result = pcall(function() return v[a] end);if not passed or type(result)=="nil" then return c end;return result
    else return (c or a) end
end
local function set(v, a, c) 
    if (type(v)=="table" or typeof(v)=="Instance") and type(a)~="nil" then 
        pcall(function()v[a] = c;end)
    else v = (a or c) end
end
local function checkDirectory(dir , createDIR, data)
    local required = (isfile and isfolder and makefile and makefolder and type(dir)=="string");if not required then return "no"; end
    local stored = ""
    local splitted = string.split(dir, "/")
    -----------------------
    local passed = true
    for i=1, #splitted do local v = splitted[i];local lastone = #splitted==i
        if type(v)=="string" then
            if v:match("txt") or v:match("lua") then
                stored = stored..v;if not isfile(stored) then passed = false end; if createDIR and not isfile(stored) then makefile(stored, type(data)=="string" and data or "") end break;
            else -- folder
                if not isfolder(stored..v) then passed = false end
                if createDIR and not isfolder(stored..v) then makefolder(stored..v) end
                if lastone then
                    stored = stored..v
                else
                    stored = stored..v.."/"
                end
            end
        end
    end
    local suc, err = pcall(readfile, stored)
    if passed and suc then return passed, err end
    return passed, (suc and err or nil)
end
local function getPlayerWithBall(Football)
    if typeof(Football)~="Instance" then return; end
    if Football.Name:lower():match("handle") or Football.Name:lower():match("football") then
        for i,v in next, game:GetService("Players"):GetChildren() do
            local char = v.Character; if not char then continue; end
            if Football:IsDescendantOf(char) and char:FindFirstChild("HumanoidRootPart") then
                return v, char, char:FindFirstChild("HumanoidRootPart")
            end
        end
    end
end
local function getNearestObject(obj, env, check)
    if typeof(obj)~="Instance" then return; end
    local posExist, posE = pcall(function()return obj.Position end)
    if not posExist or not posE then return; end
    check = type(check)=="function" and check or function()return true;end
    local ouput = {}
    if typeof(env)=="Instance" then
        for i,v in pairs(env:GetChildren()) do ouput[#ouput+1] = v end
    end
    if typeof(env)=="table" then ouput = env end
    local max, newobj = math.huge, nil;
    for i,v in pairs(ouput) do
        if typeof(v)=="Instance" then
            local posExist, pos = pcall(function()return v.Position end)
            if posExist and pos then
                local mag = (pos-posE).Magnitude
                if mag and max > mag and check(v) then
                    max = mag
                    newobj = v
                end
            end
        end
    end
    return newobj, max
end
local function _firesignal(obj, signals)
    signals = type(signals)=="table" and signals or signals
    if type(signals)=="table" then
        for i,v in pairs(signals) do
            if type(v)=="string" then
                pcall(firesignal, obj[v])
            end
        end
    elseif type(signals)=="string" then
        pcall(firesignal, obj[signals])
    end
end
local function cardinalConvert(dir)
	local angle = math.atan2(dir.X, -dir.Z)
	local quarterTurn = math.pi / 2
	angle = -math.round(angle / quarterTurn) * quarterTurn

	local newX = -math.sin(angle)
	local newZ = -math.cos(angle)
	if math.abs(newX) <= 1e-10 then newX = 0 end
	if math.abs(newZ) <= 1e-10 then newZ = 0 end
	return Vector3.new(newX, 0, newZ)
end
local function isPartOfPlayers(object)
    local passed = true;for i,v in pairs(game:GetService("Players"):GetChildren()) do
        local Character = v.Character;if not Character or typeof(Character)~="Instance" then continue; end
        if object:IsDescendantOf(Character) then passed = false end
    end;return passed
end
local function check_instance(a,b,c)
    if typeof(a)=="Instance" then
        if (a.ClassName or ""):lower()==(type(b)=="string" and b or typeof(b)=="Instance" and b.ClassName or ""):lower() then return a end
    end;return c
end
local function getPredictedPosition(targetPosition, targetVelocity, projectileSpeed, shooterPosition, shooterVelocity, gravity)
    local distance = (targetPosition - shooterPosition).Magnitude

    local p = targetPosition - shooterPosition
    local v = targetVelocity - shooterVelocity
    local a = Vector3.new() -- Placeholder

    local timeTaken = (distance / projectileSpeed)

    if gravity > 0 then
        local timeTaken = projectileSpeed/gravity+math.sqrt(2*distance/gravity+projectileSpeed^2/gravity^2)
    end

    local goalX = targetPosition.X + v.X*timeTaken + 0.5 * a.X * timeTaken^2
    local goalY = targetPosition.Y + v.Y*timeTaken + 0.5 * a.Y * timeTaken^2
    local goalZ = targetPosition.Z + v.Z*timeTaken + 0.5 * a.Z * timeTaken^2

    return Vector3.new(goalX, goalY, goalZ)
end
local function movingDirectionCheck(Pos, t) t = type(t)=="string" and t or "backwards"
  local list = {
    ["fowards"] = function(pos: Vector3) if pos.Z > 0 then return true end;return false end,
    ["backwards"] = function(pos: Vector3) if pos.Z < 0 then return true end;return false end,
    ["lefts"] = function(pos: Vector3) if pos.X < 0 then return true end;return false end,
    ["rights"] = function(pos: Vector3) if pos.X > 0 then return true end;return false end
  };
  for i,v in pairs(list)do if type(i)=="string" and type(v)=="function" and t:match(i) and (pcall(v, Pos) and type(v(Pos))~=nil and v(Pos)) then return true end end;return false
end
local function playerhasball(_char)
    if not _char then return; end
    for i,v in next, _char:GetChildren() do
        if v.Name:lower():match("handle") or v.Name:lower():match("football") then
            return v
        end
    end;return nil
end
local function sameTeam(plr1, plr2)
    if not plr1 or not plr2 then return; end
    local suc,err = pcall(function()return plr1.Team.Name==plr2.Team.Name end)
    if not suc then return true, err end;return err;
end
--==========================================================================--
local function const(a, b) getgenv()[(a or "")] = b end -- js in lua???
local function combineTable(...) local result = {};local Arg = {...};for i,v in next, Arg do if type(v)=="table" then for a,b in pairs(v) do if result[a] then result[# result+1] = b else result[a] = b end  end end end;return result end
local function searchTable(a,b)b=b or"test"a=type(a)=="table"and a or{}local c,d=nil;for e,f in pairs(a)do if c then break end;if type(f)=="table"then local g=searchTable(f,b)local h,i=pcall(function()return tostring(g)end)if g and(g==b or h and i and i==b)or type(b)=="string"and type(g)=="string"and g:lower():match(b:lower())then c=g;d=e end else local g=f;local h,i=pcall(function()return tostring(g)end)if g and(g==b or h and i and i==b)or type(b)=="string"and type(g)=="string"and g:lower():match(b:lower())then c=g;d=e end end end;return c,d end
local function press(key, waittime)local vim = game:GetService"VirtualInputManager";key = type(key) == "string" and key:upper() or "W";waittime = type(waittime) == "number" and waittime or 1;task.delay(0,function()vim:SendKeyEvent(true, key, false, game);task.wait(waittime);vim:SendKeyEvent(false, key, false, game)end)end
local function _getNearestRootObject(b,c)if typeof(b)~="Instance"then return end;if type(c)~="table"then return end;local d;local e=math.huge;for f,g in next,c do if (pcall(function()for i,v in pairs(g) do end end))then for f,h in pairs(g)do if type(f)=="string"and f:lower():match("root")and typeof(h)=="Instance"and pcall(function()return h.CFrame end)then local i=(b.CFrame.Position-h.CFrame.Position).Magnitude;if e>i then e=i;d=g end end end end end;return d,e end
local function check_type(a, b, c)if typeof(a):lower()==(type(b)=="string" and b or ""):lower() then return a end;return c end
local function _assert(a, b) if not a then error(b) end;return a end
--==========================================================================--
local Player, Camera, Character, Torso, Humanoid = game:GetService("Players").LocalPlayer, workspace.CurrentCamera;
local LocalData, Flags, Mouse = { Version = "L.0.5", DiscordLink = "https://discord.gg/uJeEHcjc3A", KeysDown = { } , KeysCooldown = { } }, { }, Player:GetMouse()
local LoopModule, Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/RealLinen/PublicScripts/main/Community/LoopModule.lua"))(), loadstring(game:HttpGet('https://raw.githubusercontent.com/RealLinen/PublicScripts/main/UILibrarys_Modified/RayfieldModified'))()
local isver = LoopModule["isver"];
UIS.InputBegan:Connect(function(input, gameProcessedEvent) if gameProcessedEvent then return; end;
    local Keycode = input and input["KeyCode"] and (type(input["KeyCode"]["Name"])=="string" and input["KeyCode"]["Name"]:lower()) or "unknown";
    if input.UserInputType == Enum.UserInputType.MouseButton1 then LocalData.KeysDown["mouse1"] = true;return end;if input.UserInputType == Enum.UserInputType.MouseButton2 then LocalData.KeysDown["mouse2"] = true;return end;if input.UserInputType == Enum.UserInputType.MouseButton3 then LocalData.KeysDown["mouse3"] = true;return end;if Keycode=="unknown" then return; end
    if LocalData.KeysCooldown[Keycode] then return; end; LocalData.KeysCooldown[Keycode] = true;LocalData.KeysDown[Keycode] = true;task.wait(.1);LocalData.KeysCooldown[Keycode] = nil
end)
UIS.InputEnded:Connect(function(input, gameProcessedEvent) if gameProcessedEvent then return; end;
    local Keycode = input and input["KeyCode"] and (type(input["KeyCode"]["Name"])=="string" and input["KeyCode"]["Name"]:lower()) or "unknown";
    if input.UserInputType == Enum.UserInputType.MouseButton1 then LocalData.KeysDown["mouse1"] = nil;return end;if input.UserInputType == Enum.UserInputType.MouseButton2 then LocalData.KeysDown["mouse2"] = nil;return end;if input.UserInputType == Enum.UserInputType.MouseButton3 then LocalData.KeysDown["mouse3"] = nil;return end;if Keycode=="unknown" then return; end
    LocalData.KeysDown[Keycode] = nil;
end);local function getcooldown(name) end
--==========================================================================--
local _gameDIR, _versionDIR = Format("Linen Utilities/Games/%s.txt", game.PlaceId), Format("Linen Utilities/version.txt")
_______________________________, ________________________________= pcall(LPH_JIT_MAX(function()
    local _, gameData = checkDirectory(_gameDIR, true, JSON.Encode({ ["Loaded"] = 'Dont remove this' }));gameData = JSON.Decode(gameData);writefile(_versionDIR, (LocalData["Version"] or "L.0.5"));Flags = gameData
    --==========================================================================--
    local blockPart, Balls;
    local MainHand = Character and Character:FindFirstChild("CatchRight")
    --==========================================================================--
    LoopModule(function() Character = Player.Character or Player.CharacterAdded:Wait() or workspace:FindFirstChild(Player.Name);if Character then      const("Character", Character);Torso = Character:FindFirstChild("Torso") or Character:FindFirstChild("UpperTorso") or Character:FindFirstChild("LowerTorso");const("Torso", Torso)     Humanoid = Character:FindFirstChild("Humanoid") or Character:FindFirstChildOfClass("Humanoid") or Character:WaitForChild("Humanoid", 100); const("Humanoid", Humanoid) 
        --[[ Replacing Main hand ]] MainHand = Character and Character:FindFirstChild("CatchRight")
        --[[ Removing destroyed balls for lag reduction ]]for i,v in next, Balls do if not get(v, "Position") then Balls[i] = nil end end
        --[[ Caching Balls from Workspace ]]for i,v in next, workspace:GetChildren() do if v.Name:lower():match("handle") or v.Name:lower():match("football") then Balls[v] = v end end
        --[[ Caching Balls from Players ]]for i,v in next, Players:GetChildren() do local char = v and v["Character"];if not char or v==Player then continue; end;local _ballexist = playerhasball(char);if _ballexist then Balls[_ballexist] = _ballexist end end
        for i,v in next, Character:GetChildren() do if v.Name:lower():match("block") then blockPart = v end end
    end end)
    --==========================================================================--
    --[[ SpoofJump, BlockReach, Auto Catch, Auto ]]LoopModule(function() 
-- [[ ============================================================== ]] --
        if get(Flags, "SpoofJump") and LocalData.KeysDown["space"] then Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
        for i,v in next, Balls do local ballPassRQ = get(v, "Name") and get(v, "Size") and get(v, "Position");if not ballPassRQ then continue; end;
            local magnitude = (Torso.Position - v.Position).Magnitude
            if get(Flags, "AutoCatch") and magnitude < (Flags["AutoCatchDistance"] or 20) then press("c") end
            if get(Flags, "AutoSwat") and magnitude < (Flags["AutoSwatDistance"] or 20) then press("r") end
            for a,b in pairs(Character:GetChildren()) do 
                if (b.Name:match("Arm") or b.Name:match("Hand")) then
                    if get(Flags, "HandsReach") then set(LocalData, "IncreasingHandSize", true)
                        LocalData["StoredHandSize"] = LocalData["StoredHandSize"] or b.Size
                        local dist = get(Flags, "HandReachDistance") or 10
                        local newsize = Vector3.new(dist, dist, dist)
                        if b.Size~=newsize then
                            b.Parent = nil;
                            b.Size = newsize
                            b.CanCollide = false
                            b.Parent = Character
                        end
                        set(LocalData, "IncreasingHandSize", false)
                    else
                        if LocalData["StoredHandSize"] then b.Size = LocalData["StoredHandSize"];b.CanCollide = true end
                    end
                end
            end
        end
        if get(Flags, "BlockReach") then
            if blockPart and not LocalData["StoredBlockSize"] then LocalData["StoredBlockSize"] = LocalData["StoredBlockSize"] or blockPart.Size end
            local dist = get(Flags, "BlockReachDistance") or 10
            local newSize = Vector3.new(dist, dist, dist)
            if blockPart and blockPart.Size~=newSize and not LocalData["SizeIncreasing"] then
                LocalData['SizeIncreasing'] = true
                blockPart.Parent = nil
                blockPart.Size = newSize
                blockPart.Parent = Character
                LocalData['SizeIncreasing'] = false
            end
        else
            local storedSize = LocalData["StoredBlockSize"]
            if typeof(storedSize)=="Vector3" and get(blockPart, "Size") then
                set(blockPart, "Size", storedSize)
            end
        end
    end)
    --[[ Follow Ball Holder, Kick Aimbot, Mags, OP Mags, Auto Guard ]]LoopModule(function()
        for i,v in next, Balls do if not get(v, "Position") then Balls[i] = nil end end
        for i,v in next, Balls do if not MainHand then continue; end
            local magnitude = (MainHand.Position - v.Position).Magnitude;
            if get(Flags, "OPMags") and LocalData.KeysDown["mouse1"] and magnitude < (Flags["MagsDistance"] or 20) and MainHand then LocalData.Magging = true
                MainHand.Parent = nil;
                MainHand.Position = v.Position;
                MainHand.Parent = Character;LocalData.Magging = false
            end
            if get(Flags, "Mags") and LocalData.KeysDown["mouse1"] and magnitude < (Flags["MagsDistance"] or 20) then LocalData.Magging = true
                firetouchinterest(MainHand, v, 0);
                task.wait()
                firetouchinterest(MainHand, v, 1);LocalData.Magging = false
            end
        end
        --===========================================================--
        --===========================================================--
        --===========================================================--
        --===========================================================--
        --===========================================================--
        --===========================================================--
        if get(Flags, "QBAimbot") then local check1 = true
            if LocalData.KeysDown["Q"] and LocalData.QBAimbotLockedSelection then check1 = false;LocalData.QBAimbotLockedSelection = false end
            if check1 then
                
            end
        end
        --===========================================================--
        --===========================================================--
        --===========================================================--
        --===========================================================--
        --===========================================================--
        --===========================================================--
        if get(Flags, "AutoKick") then
            task.spawn(function()
                local KickerGui = Player:WaitForChild"PlayerGui":FindFirstChild("KickerGui")
                local Meter = typeof(KickerGui)=="Instance" and KickerGui:IsA("ScreenGui") and KickerGui.Enabled and typeof(KickerGui:FindFirstChild("Meter"))=="Instance" and KickerGui:FindFirstChild("Meter").ClassName:match("Frame") and KickerGui:FindFirstChild("Meter").Visible and KickerGui:FindFirstChild("Meter")
                if not KickerGui or not Meter then LocalData.KickingAimbot = false;return end;LocalData.KickingAimbot = true
                local Checkpoint1 = Meter:FindFirstChild("Arrow1")
                local Checkpoint2 = Meter:FindFirstChild("Arrow4")
                local Line = Meter:FindFirstChild("Cursor")
                firesignal(UIS.WindowFocused)
                local tempL = { ["CP1P"] = 1, ["CP2P"] = 1 }
                if Checkpoint1 and Checkpoint2 and Line then
                    while task.wait() and (Player:WaitForChild"PlayerGui":FindFirstChild("KickerGui") and typeof(KickerGui)=="Instance" and KickerGui:IsA("ScreenGui") and KickerGui.Enabled and typeof(KickerGui:FindFirstChild("Meter"))=="Instance" and KickerGui:FindFirstChild("Meter").ClassName:match("Frame") and KickerGui:FindFirstChild("Meter").Visible and KickerGui:FindFirstChild("Meter")) and isver() do
                        KickerGui = Player:WaitForChild"PlayerGui":FindFirstChild("KickerGui")
                        --------------------
                        if Checkpoint1.Visible then
                            if Line.AbsolutePosition.Y > (492/1) and not (tempL["CP1P"]>=3) then
                                mouse1click()
                                tempL["CP1P"] = tempL["CP1P"] + 1 or 1;mouse1click()
                            end
                        end
                        if Checkpoint2.Visible then
                            if Line.AbsolutePosition.Y < (220.01/1) and not (tempL["CP2P"]>=3) then
                                mouse1click()
                                tempL["CP2P"] = tempL["CP2P"] + 1 or 1;mouse1click()
                            end
                        end
                    end
                end
                LocalData.KickingAimbot = false
            end)
        end
        --===========================================================--
        --===========================================================--
        --===========================================================--
        --===========================================================--
        --===========================================================--
        --===========================================================--
        if get(Flags, "FBH") then
            local minDistance = (get(Flags, "FBHDistance") or 60)
            for i,v in next, Balls do
                local BallHolder, BallHolderCharacter, BallHolderHumanoidRootPart = getPlayerWithBall(v)
                local suc,err = pcall(function()
                    if not (BallHolder or BallHolderCharacter or BallHolderHumanoidRootPart)then return; end
                    local magnitude = (Torso.CFrame.Position-BallHolderHumanoidRootPart.CFrame.Position).Magnitude
                    if BallHolder and magnitude<=(minDistance or 60) and BallHolder["Team"] and Player["Team"] then
                        if BallHolder.Team.Name~=Player.Team.Name then
                            local n = math.random(1, 10);
                            if Humanoid then Humanoid:MoveTo(BallHolderHumanoidRootPart.Position) end
                            FollowingBC = { BallHolder, BallHolderCharacter, BallHolderHumanoidRootPart };
                        end;return;
                    end;FollowingBC = nil;
                end)
                if not suc then warn("Follow BC Error:", err) end
            end
        end
        --===========================================================--
        --===========================================================--
        --===========================================================--
    end)
end))
--[[ ========================================================================== ]] if not _______________________________ then return warn(string.format("Error Loading [ %s ]:\n%s", "Linen Utilities", ________________________________)) end;repeat task.wait() until Flags["Loaded"]
--==========================================================================--
print("Linen Utilities [ "..(LocalData.Version or "L.0.5").." ] -> Loaded!")
local Window = Rayfield:CreateWindow({
    Name = "Linen Utilities [ "..(LocalData.Version or "L.0.5").." ]",
    LoadingTitle = "Linen Utilities [ "..(LocalData.Version or "L.0.5").." ]",
    LoadingSubtitle = "Scripted by: Linen#3485",
    ConfigurationSaving = { Enabled = false },
})

local MainTab = Window:CreateTab("Main", 4483362458)
local TrollingTab = Window:CreateTab("Trolling", 4483362458)
local ModificationsTab = Window:CreateTab("Modifications", 4483362458)
local SettingsTab = Window:CreateTab("Settings", 4483362458)

MainTab:CreateSection("Catching")
MainTab:CreateToggle({ Name = "Mags", CurrentValue = get(Flags, "Mags", false), Callback = function(B_) set(Flags, "Mags", B_) end })
MainTab:CreateToggle({ Name = "Auto Catch", CurrentValue = get(Flags, "AutoCatch", false), Callback = function(B_) set(Flags, "AutoCatch", B_) end })
MainTab:CreateToggle({ Name = "OP Mags", CurrentValue = get(Flags, "OPMags", false), Callback = function(B_) set(Flags, "OPMags", B_) end })

MainTab:CreateSection("Intersting")
MainTab:CreateToggle({ Name = "QB Aimbot", CurrentValue = get(Flags, "QBAimbot", false), Callback = function(B_) set(Flags, "QBAimbot", B_) end })
MainTab:CreateToggle({ Name = "Auto Guard", CurrentValue = get(Flags, "AutoGard", false), Callback = function(B_) set(Flags, "AutoGard", B_) end })

MainTab:CreateSection("Misc")
MainTab:CreateToggle({ Name = "Auto Kick Perfectly", CurrentValue = get(Flags, "AutoKick", false), Callback = function(B_) set(Flags, "AutoKick", B_) end })
MainTab:CreateToggle({ Name = "Follow Ball Holder [ FBH ]", CurrentValue = get(Flags, "FBH", false), Callback = function(_B) set(Flags, "FBH", _B) end })

TrollingTab:CreateToggle({ Name = "Auto Swat", CurrentValue = get(Flags, "AutoSwat", false), Callback = function(_B) set(Flags, "AutoSwat", _B) end })
TrollingTab:CreateToggle({ Name = "Spoof Jump", CurrentValue = get(Flags, "SpoofJump", false), Callback = function(_B) set(Flags, "SpoofJump", _B) end })


ModificationsTab:CreateSection("Reaching")
ModificationsTab:CreateToggle({ Name = "Hands Reach", CurrentValue = get(Flags, "HandsReach", false), Callback = function(_B) set(Flags, "HandsReach", _B) end  })
ModificationsTab:CreateSlider({ Name = "Hand Reach Distance", CurrentValue = get(Flags, "HandReachDistance", 10), Range = {0, 40}, Increment = 2, Callback = function(_B) set(Flags, "HandReachDistance", _B) end})
ModificationsTab:CreateToggle({ Name = "Block Reach", CurrentValue = get(Flags, "BlockReach", false), Callback = function(_B) set(Flags, "BlockReach", _B) end  })
ModificationsTab:CreateSlider({ Name = "Block Reach Distance", CurrentValue = get(Flags, "BlockReachDistance", 10), Range = {0, 40}, Increment = 2, Callback = function(_B) set(Flags, "BlockReachDistance", _B) end})


ModificationsTab:CreateSection("Distance")
ModificationsTab:CreateSlider({ Name = "Auto Catch Distance", CurrentValue = get(Flags, "ACDistance", 20), Range = {0, 130}, Increment = 2, Callback = function(_B) set(Flags, "ACDistance", _B) end })
ModificationsTab:CreateSlider({ Name = "Mags Distance", CurrentValue = get(Flags, "MagsDistance", 20), Range = {0, 130}, Increment = 2, Callback = function(_B) set(Flags, "MagsDistance", _B) end })
ModificationsTab:CreateSlider({ Name = "FBH Distance", CurrentValue = get(Flags, "FBHDistance", 50), Range = {0, 350}, Increment = 2, Callback = function(_B) set(Flags, "FBHDistance", _B) end })


SettingsTab:CreateButton({ Name = "Server Hop", Callback = function() TS:Teleport(game.PlaceId, Player) end})
SettingsTab:CreateButton({ Name = "Copy Discord", Callback = function() if type(setclipboard)=="function" then setclipboard((LocalData["DiscordLink"] or "_")) end end})
SettingsTab:CreateButton({ Name = "Rejoin", Callback = function() TS:Teleport(game.PlaceId, Player, game.JobId) end})

--[[ Saving Data ]]LoopModule(function() pcall(writefile, _gameDIR, JSON.Encode(Flags)) end)

--[[ DONE:
  * Kick Aimbot, Follow Ball Carrier
  * Mags, Jump Spoof, OP Mags, Auto Catch, Auto Swat
  * Rejoin Button
  * Block Reach
  * Hands reach/Swat Reach
]]

--[[ LEFT TO DO:
  * QB Aimbot, Auto Guard
]]
