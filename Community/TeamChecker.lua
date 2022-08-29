
local UserInputService	= game:GetService'UserInputService';
local HttpService	= game:GetService'HttpService';
local GUIService	= game:GetService'GuiService';
local TweenService	= game:GetService'TweenService';
local RunService	= game:GetService'RunService';
local Players		= game:GetService'Players';
local LocalPlayer	= Players.LocalPlayer;
local Camera		= workspace.CurrentCamera;
local Mouse		= LocalPlayer:GetMouse();
local V2New		= Vector2.new;
local V3New		= Vector3.new;
local WTVP		= Camera.WorldToViewportPoint;
local WorldToViewport	= function(...) return WTVP(Camera, ...) end;
local Menu		= {};
local MouseHeld		= false;
local LastRefresh	= 0;
local OptionsFile	= 'IC3_ESP_SETTINGS.dat';
local Binding		= false;
local BindedKey		= nil;
local OIndex		= 0;
local LineBox		= {};
local UIButtons		= {};
local Sliders		= {};
local ColorPicker	= { Loading = false; LastGenerated = 0 };
local Dragging		= false;
local DraggingUI	= false;
local Rainbow		= false;
local DragOffset	= V2New();
local DraggingWhat	= nil;
local OldData		= {};
local IgnoreList	= {};
local EnemyColor	= Color3.new(1, 0, 0);
local TeamColor		= Color3.new(0, 1, 0);
local MenuLoaded	= false;
local ErrorLogging	= false;
local TracerPosition	= V2New(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y - 135);
local DragTracerPosition= false;
local SubMenu 		= {};
local IsSynapse 	= syn and not PROTOSMASHER_LOADED;
local Connections 	= { Active = {} };
local Signal 		= {}; Signal.__index = Signal;
local GetCharacter;
local CurrentColorPicker;
local Spectating;

local Executor = (identifyexecutor or (function() return '' end))()
local SupportedExploits = { 'Synapse X', 'ScriptWare', 'Krnl', 'OxygenU', 'Temple' }
local QUAD_SUPPORTED_EXPLOIT = table.find(SupportedExploits, Executor) ~= nil

-- if not PROTOSMASHER_LOADED then Drawing.UseCompatTransparency = true; end -- For Elysian

shared.MenuDrawingData	= shared.MenuDrawingData or { Instances = {} };
shared.InstanceData	= shared.InstanceData or {};
shared.RSName		= shared.RSName or ('UnnamedESP_by_ic3-' .. HttpService:GenerateGUID(false));

local GetDataName	= shared.RSName .. '-GetData';
local UpdateName	= shared.RSName .. '-Update';

local Debounce		= setmetatable({}, {
	__index = function(t, i)
		return rawget(t, i) or false
	end;
});

if shared.UESP_InputChangedCon then shared.UESP_InputChangedCon:Disconnect() end
if shared.UESP_InputBeganCon then shared.UESP_InputBeganCon:Disconnect() end
if shared.UESP_InputEndedCon then shared.UESP_InputEndedCon:Disconnect() end
if shared.CurrentColorPicker then shared.CurrentColorPicker:Dispose() end

local RealPrint, LastPrintTick = print, 0;
local LatestPrints = setmetatable({}, { __index = function(t, i) return rawget(t, i) or 0 end });

local function print(...)
	local Content = unpack{...};
	local print = RealPrint;

	if tick() - LatestPrints[Content] > 5 then
		LatestPrints[Content] = tick();
		print(Content);
	end
end

local function FromHex(HEX)
	HEX = HEX:gsub('#', '');
	
	return Color3.fromRGB(tonumber('0x' .. HEX:sub(1, 2)), tonumber('0x' .. HEX:sub(3, 4)), tonumber('0x' .. HEX:sub(5, 6)));
end

local function IsStringEmpty(String)
	if type(String) == 'string' then
		return String:match'^%s+$' ~= nil or #String == 0 or String == '' or false;
	end
	
	return false;
end

local function Set(t, i, v)
	t[i] = v;
end

local Teams = {};
local CustomTeams = { -- Games that don't use roblox's team system
	[2563455047] = {
		Initialize = function()
			Teams.Sheriffs = {}; -- prevent big error
			Teams.Bandits = {}; -- prevent big error
			local Func = game:GetService'ReplicatedStorage':WaitForChild('RogueFunc', 1);
			local Event = game:GetService'ReplicatedStorage':WaitForChild('RogueEvent', 1);
			local S, B = Func:InvokeServer'AllTeamData';

			Teams.Sheriffs = S;
			Teams.Bandits = B;

			Event.OnClientEvent:Connect(function(id, PlayerName, Team, Remove) -- stolen straight from decompiled src lul
				if id == 'UpdateTeam' then
					local TeamTable, NotTeamTable
					if Team == 'Bandits' then
						TeamTable = TDM.Bandits
						NotTeamTable = TDM.Sheriffs
					else
						TeamTable = TDM.Sheriffs
						NotTeamTable = TDM.Bandits
					end
					if Remove then
						TeamTable[PlayerName] = nil
					else
						TeamTable[PlayerName] = true
						NotTeamTable[PlayerName] = nil
					end
					if PlayerName == LocalPlayer.Name then
						TDM.Friendlys = TeamTable
						TDM.Enemies = NotTeamTable
					end
				end
			end)
		end;
		CheckTeam = function(Player)
			local LocalTeam = Teams.Sheriffs[LocalPlayer.Name] and Teams.Sheriffs or Teams.Bandits;
			
			return LocalTeam[Player.Name] and true or false;
		end;
	};
	[5208655184] = {
		CheckTeam = function(Player)
			local LocalLastName = LocalPlayer:GetAttribute'LastName' if not LocalLastName or IsStringEmpty(LocalLastName) then return true end
			local PlayerLastName = Player:GetAttribute'LastName' if not PlayerLastName then return false end

			return PlayerLastName == LocalLastName
		end
	};
	[3541987450] = {
		CheckTeam = function(Player)
			local LocalStats = LocalPlayer:FindFirstChild'leaderstats';
			local LocalLastName = LocalStats and LocalStats:FindFirstChild'LastName'; if not LocalLastName or IsStringEmpty(LocalLastName.Value) then return true; end
			local PlayerStats = Player:FindFirstChild'leaderstats';
			local PlayerLastName = PlayerStats and PlayerStats:FindFirstChild'LastName'; if not PlayerLastName then return false; end

			return PlayerLastName.Value == LocalLastName.Value;
		end;
	};
    [6032399813] = {
		CheckTeam = function(Player)
			local LocalStats = LocalPlayer:FindFirstChild'leaderstats';
			local LocalGuildName = LocalStats and LocalStats:FindFirstChild'Guild'; if not LocalGuildName or IsStringEmpty(LocalGuildName.Value) then return true; end
			local PlayerStats = Player:FindFirstChild'leaderstats';
			local PlayerGuildName = PlayerStats and PlayerStats:FindFirstChild'Guild'; if not PlayerGuildName then return false; end

			return PlayerGuildName.Value == LocalGuildName.Value;
		end;
	};
    [5735553160] = {
		CheckTeam = function(Player)
			local LocalStats = LocalPlayer:FindFirstChild'leaderstats';
			local LocalGuildName = LocalStats and LocalStats:FindFirstChild'Guild'; if not LocalGuildName or IsStringEmpty(LocalGuildName.Value) then return true; end
			local PlayerStats = Player:FindFirstChild'leaderstats';
			local PlayerGuildName = PlayerStats and PlayerStats:FindFirstChild'Guild'; if not PlayerGuildName then return false; end

			return PlayerGuildName.Value == LocalGuildName.Value;
		end;
	};
};

local RenderList = {Instances = {}};

function RenderList:AddOrUpdateInstance(Instance, Obj2Draw, Text, Color)
	RenderList.Instances[Instance] = { ParentInstance = Instance; Instance = Obj2Draw; Text = Text; Color = Color };
	return RenderList.Instances[Instance];
end

local CustomPlayerTag;
local CustomESP;
local CustomCharacter;
local GetHealth;
local GetAliveState;
local CustomRootPartName;

local Modules = {
	[292439477] = {
		CustomESP = function()
			if type(shared.PF_Replication) ~= 'table' then
				local lastScan = shared.pfReplicationScan

				if (tick() - (lastScan or 0)) > 0.01 then
					shared.pfReplicationScan = tick()

					local gc = getgc(true)
					for i = 1, #gc do
						local gcObject = gc[i];
						if type(gcObject) == 'table' and type(rawget(gcObject, 'getbodyparts')) == 'function' then
							shared.PF_Replication = gcObject;
							break
						end
					end
				end

				return
			end

			for Index, Player in pairs(Players:GetPlayers()) do
				--if Player == LocalPlayer then continue end

				local Body = shared.PF_Replication.getbodyparts(Player);

				if type(Body) == 'table' and typeof(rawget(Body, 'torso')) == 'Instance' then
					Player.Character = Body.torso.Parent
					continue
				end

				--Player.Character = nil;
			end
		end,

		GetHealth = function(Player)
			if type(shared.pfHud) ~= 'table' then
				return false
			end

			return shared.pfHud:getplayerhealth(Player)
		end,

		GetAliveState = function(Player)
			if type(shared.pfHud) ~= 'table' then
				local lastScan = shared.pfHudScan

				if (tick() - (lastScan or 0)) > 0.1 then
					shared.pfHudScan = tick()

					local gc = getgc(true)
					for i = 1, #gc do
						local gcObject = gc[i];
						if type(gcObject) == 'table' and type(rawget(gcObject, 'getplayerhealth')) == 'function' then
							shared.pfHud = gcObject;
							break
						end
					end
				end

				return
			end

			return shared.pfHud:isplayeralive(Player)
		end,

		CustomRootPartName = 'Torso',
	};
	[2950983942] = {
		CustomCharacter = function(Player)
			if workspace:FindFirstChild'Players' then
				return workspace.Players:FindFirstChild(Player.Name);
			end
		end
	};
	[2262441883] = {
		CustomPlayerTag = function(Player)
			return Player:FindFirstChild'Job' and (' [' .. Player.Job.Value .. ']') or '';
		end;
		CustomESP = function()
			if workspace:FindFirstChild'MoneyPrinters' then
				for i, v in pairs(workspace.MoneyPrinters:GetChildren()) do
					local Main	= v:FindFirstChild'Main';
					local Owner	= v:FindFirstChild'TrueOwner';
					local Money	= v:FindFirstChild'Int' and v.Int:FindFirstChild'Money' or nil;
					if Main and Owner and Money then
						local O = tostring(Owner.Value);
						local M = tostring(Money.Value);

						pcall(RenderList.AddOrUpdateInstance, RenderList, v, Main, string.format('Money Printer\nOwned by %s\n[%s]', O, M), Color3.fromRGB(13, 255, 227));
					end
				end
			end
		end;
	};
	-- [4581966615] = {
	-- 	CustomESP = function()
	-- 		if workspace:FindFirstChild'Entities' then
	-- 			for i, v in pairs(workspace.Entities:GetChildren()) do
	-- 				if not v.Name:match'Printer' then continue end

	-- 				local Properties = v:FindFirstChild'Properties' if not Properties then continue end
	-- 				local Main	= v:FindFirstChild'hitbox';
	-- 				local Owner	= Properties:FindFirstChild'Owner';
	-- 				local Money	= Properties:FindFirstChild'CurrentPrinted'
					
	-- 				if Main and Owner and Money then
	-- 					local O = Owner.Value and tostring(Owner.Value) or 'no one';
	-- 					local M = tostring(Money.Value);

	-- 					pcall(RenderList.AddOrUpdateInstance, RenderList, v, Main, string.format('Money Printer\nOwned by %s\n[%s]', O, M), Color3.fromRGB(13, 255, 227));
	-- 				end
	-- 			end
	-- 		end
	-- 	end;
	-- };
	[4801598506] = {
		CustomESP = function()
			if workspace:FindFirstChild'Mobs' and workspace.Mobs:FindFirstChild'Forest1' then
				for i, v in pairs(workspace.Mobs.Forest1:GetChildren()) do
					local Main	= v:FindFirstChild'Head';
					local Hum	= v:FindFirstChild'Mob';

					if Main and Hum then
						pcall(RenderList.AddOrUpdateInstance, RenderList, v, Main, string.format('[%s] [%s/%s]', v.Name, Hum.Health, Hum.MaxHealth), Color3.fromRGB(13, 255, 227));
					end
				end
			end
		end;
	};
	[2555873122] = {
		CustomESP = function()
			if workspace:FindFirstChild'WoodPlanks' then
				for i, v in pairs(workspace:GetChildren()) do
					if v.Name == 'WoodPlanks' then
						local Main = v:FindFirstChild'Wood';

						if Main then
							pcall(RenderList.AddOrUpdateInstance, RenderList, v, Main, 'Wood Planks', Color3.fromRGB(13, 255, 227));
						end
					end
				end
			end
		end;
	};
	[5208655184] = {
		CustomESP = function()
			-- if workspace:FindFirstChild'Live' then
			-- 	for i, v in pairs(workspace.Live:GetChildren()) do
			-- 		if v.Name:sub(1, 1) == '.' then
			-- 			local Main = v:FindFirstChild'Head';

			-- 			if Main then
			-- 				pcall(RenderList.AddOrUpdateInstance, RenderList, v, Main, v.Name:sub(2), Color3.fromRGB(250, 50, 40));
			-- 			end
			-- 		end
			-- 	end
			-- end
		end;
		CustomPlayerTag = function(Player)
			if game.PlaceVersion < 457 then return '' end

			local Name = '';
			local FirstName = Player:GetAttribute'FirstName'

			if typeof(FirstName) == 'string' and #FirstName > 0 then
				local Prefix = '';
				local Extra = {};
				Name = Name .. '\n[';

				if Player:GetAttribute'Prestige' > 0 then
					Name = Name .. '#' .. tostring(Player:GetAttribute'Prestige') .. ' ';
				end
				if not IsStringEmpty(Player:GetAttribute'HouseRank') then
					Prefix = Player:GetAttribute'HouseRank' == 'Owner' and (Player:GetAttribute'Gender' == 'Female' and 'Lady ' or 'Lord ') or '';
				end
				if not IsStringEmpty(FirstName) then
					Name = Name .. '' .. Prefix .. FirstName;
				end
				if not IsStringEmpty(Player:GetAttribute'LastName') then
					Name = Name .. ' ' .. Player:GetAttribute'LastName';
				end

				if not IsStringEmpty(Name) then Name = Name .. ']'; end

				local Character = GetCharacter(Player);

				if Character then
					if Character and Character:FindFirstChild'Danger' then table.insert(Extra, 'D'); end
					if Character:FindFirstChild'ManaAbilities' and Character.ManaAbilities:FindFirstChild'ManaSprint' then table.insert(Extra, 'D1'); end

					if Character:FindFirstChild'Mana'	 		then table.insert(Extra, 'M' .. math.floor(Character.Mana.Value)); end
					if Character:FindFirstChild'Vampirism' 		then table.insert(Extra, 'V'); end
					if Character:FindFirstChild'Observe'		then table.insert(Extra, 'ILL'); end
					if Character:FindFirstChild'Inferi'			then table.insert(Extra, 'NEC'); end
					if Character:FindFirstChild'World\'s Pulse' then table.insert(Extra, 'DZIN'); end
					if Character:FindFirstChild'Shift'		 	then table.insert(Extra, 'MAD'); end
					if Character:FindFirstChild'Head' and Character.Head:FindFirstChild'FacialMarking' then
						local FM = Character.Head:FindFirstChild'FacialMarking';
						if FM.Texture == 'http://www.roblox.com/asset/?id=4072968006' then
							table.insert(Extra, 'HEALER');
						elseif FM.Texture == 'http://www.roblox.com/asset/?id=4072914434' then
							table.insert(Extra, 'SEER');
						elseif FM.Texture == 'http://www.roblox.com/asset/?id=4094417635' then
							table.insert(Extra, 'JESTER');
						elseif FM.Texture == 'http://www.roblox.com/asset/?id=4072968656' then
							table.insert(Extra, 'BLADE');
						end
					end
				end
				if Player:FindFirstChild'Backpack' then
					if Player.Backpack:FindFirstChild'Observe' 			then table.insert(Extra, 'ILL');  end
					if Player.Backpack:FindFirstChild'Inferi'			then table.insert(Extra, 'NEC');  end
					if Player.Backpack:FindFirstChild'World\'s Pulse' 	then table.insert(Extra, 'DZIN'); end
					if Player.Backpack:FindFirstChild'Shift'		 	then table.insert(Extra, 'MAD'); end
				end

				if #Extra > 0 then Name = Name .. ' [' .. table.concat(Extra, '-') .. ']'; end
			end

			return Name;
		end;
	};
	[3541987450] = {
		CustomPlayerTag = function(Player)
			local Name = '';

			if Player:FindFirstChild'leaderstats' then
				Name = Name .. '\n[';
				local Prefix = '';
				local Extra = {};
				if Player.leaderstats:FindFirstChild'Prestige' and Player.leaderstats.Prestige.ClassName == 'IntValue' and Player.leaderstats.Prestige.Value > 0 then
					Name = Name .. '#' .. tostring(Player.leaderstats.Prestige.Value) .. ' ';
				end
				if Player.leaderstats:FindFirstChild'HouseRank' and Player.leaderstats:FindFirstChild'Gender' and Player.leaderstats.HouseRank.ClassName == 'StringValue' and not IsStringEmpty(Player.leaderstats.HouseRank.Value) then
					Prefix = Player.leaderstats.HouseRank.Value == 'Owner' and (Player.leaderstats.Gender.Value == 'Female' and 'Lady ' or 'Lord ') or '';
				end
				if Player.leaderstats:FindFirstChild'FirstName' and Player.leaderstats.FirstName.ClassName == 'StringValue' and not IsStringEmpty(Player.leaderstats.FirstName.Value) then
					Name = Name .. '' .. Prefix .. Player.leaderstats.FirstName.Value;
				end
				if Player.leaderstats:FindFirstChild'LastName' and Player.leaderstats.LastName.ClassName == 'StringValue' and not IsStringEmpty(Player.leaderstats.LastName.Value) then
					Name = Name .. ' ' .. Player.leaderstats.LastName.Value;
				end
				if Player.leaderstats:FindFirstChild'UberTitle' and Player.leaderstats.UberTitle.ClassName == 'StringValue' and not IsStringEmpty(Player.leaderstats.UberTitle.Value) then
					Name = Name .. ', ' .. Player.leaderstats.UberTitle.Value;
				end

				if not IsStringEmpty(Name) then Name = Name .. ']'; end

				local Character = GetCharacter(Player);

				if Character then
					if Character and Character:FindFirstChild'Danger' then table.insert(Extra, 'D'); end
					if Character:FindFirstChild'ManaAbilities' and Character.ManaAbilities:FindFirstChild'ManaSprint' then table.insert(Extra, 'D1'); end

					if Character:FindFirstChild'Mana'	 		then table.insert(Extra, 'M' .. math.floor(Character.Mana.Value)); end
					if Character:FindFirstChild'Vampirism' 		then table.insert(Extra, 'V');    end
					if Character:FindFirstChild'Observe'			then table.insert(Extra, 'ILL');  end
					if Character:FindFirstChild'Inferi'			then table.insert(Extra, 'NEC');  end
					
					if Character:FindFirstChild'World\'s Pulse' 	then table.insert(Extra, 'DZIN'); end
					if Character:FindFirstChild'Head' and Character.Head:FindFirstChild'FacialMarking' then
						local FM = Character.Head:FindFirstChild'FacialMarking';
						if FM.Texture == 'http://www.roblox.com/asset/?id=4072968006' then
							table.insert(Extra, 'HEALER');
						elseif FM.Texture == 'http://www.roblox.com/asset/?id=4072914434' then
							table.insert(Extra, 'SEER');
						elseif FM.Texture == 'http://www.roblox.com/asset/?id=4094417635' then
							table.insert(Extra, 'JESTER');
						end
					end
				end
				if Player:FindFirstChild'Backpack' then
					if Player.Backpack:FindFirstChild'Observe' 			then table.insert(Extra, 'ILL');  end
					if Player.Backpack:FindFirstChild'Inferi'			then table.insert(Extra, 'NEC');  end
					if Player.Backpack:FindFirstChild'World\'s Pulse' 	then table.insert(Extra, 'DZIN'); end
				end

				if #Extra > 0 then Name = Name .. ' [' .. table.concat(Extra, '-') .. ']'; end
			end

			return Name;
		end;
	};

	[4691401390] = { -- Vast Realm
		CustomCharacter = function(Player)
			if workspace:FindFirstChild'Players' then
				return workspace.Players:FindFirstChild(Player.Name);
			end
		end
	};

    [6032399813] = { -- Deepwoken [Etrean]
		CustomPlayerTag = function(Player)
			local Name = '';
            CharacterName = Player:GetAttribute'CharacterName'; -- could use leaderstats but lazy

            if not IsStringEmpty(CharacterName) then
                Name = ('\n[%s]'):format(CharacterName);
                local Character = GetCharacter(Player);
                local Extra = {};

                if Character then
                    local Blood, Armor = Character:FindFirstChild('Blood'), Character:FindFirstChild('Armor');

                    if Blood and Blood.ClassName == 'DoubleConstrainedValue' then
                        table.insert(Extra, ('B%d'):format(Blood.Value));
                    end

                    if Armor and Armor.ClassName == 'DoubleConstrainedValue' then
                        table.insert(Extra, ('A%d'):format(math.floor(Armor.Value / 10)));
                    end
                end

                local BackpackChildren = Player.Backpack:GetChildren()

                for index = 1, #BackpackChildren do
                    local Oath = BackpackChildren[index]
                    if Oath.ClassName == 'Folder' and Oath.Name:find('Talent:Oath') then
                        local OathName = Oath.Name:gsub('Talent:Oath: ', '')
                        table.insert(Extra, OathName);
                    end
                end

                if #Extra > 0 then Name = Name .. ' [' .. table.concat(Extra, '-') .. ']'; end
            end

			return Name;
		end;
	};

    [5735553160] = { -- Deepwoken [Depths]
    CustomPlayerTag = function(Player)
        local Name = '';
        CharacterName = Player:GetAttribute'CharacterName'; -- could use leaderstats but lazy

        if not IsStringEmpty(CharacterName) then
            Name = ('\n[%s]'):format(CharacterName);
            local Character = GetCharacter(Player);
            local Extra = {};

            if Character then
                local Blood, Armor = Character:FindFirstChild('Blood'), Character:FindFirstChild('Armor');

                if Blood and Blood.ClassName == 'DoubleConstrainedValue' then
                    table.insert(Extra, ('B%d'):format(Blood.Value));
                end

                if Armor and Armor.ClassName == 'DoubleConstrainedValue' then
                    table.insert(Extra, ('A%d'):format(math.floor(Armor.Value / 10)));
                end
            end

            local BackpackChildren = Player.Backpack:GetChildren()

            for index = 1, #BackpackChildren do
                local Oath = BackpackChildren[index]
                if Oath.ClassName == 'Folder' and Oath.Name:find('Talent:Oath') then
                    local OathName = Oath.Name:gsub('Talent:Oath: ', '')
                    table.insert(Extra, OathName);
                end
            end

            if #Extra > 0 then Name = Name .. ' [' .. table.concat(Extra, '-') .. ']'; end
        end

        return Name;
    end;
};
};

local Module = Modules[game.PlaceId];
if Modules[game.PlaceId] ~= nil then
	CustomPlayerTag = Module.CustomPlayerTag or nil;
	CustomESP = Module.CustomESP or nil;
	CustomCharacter = Module.CustomCharacter or nil;
	GetHealth = Module.GetHealth or nil;
	GetAliveState = Module.GetAliveState or nil;
	CustomRootPartName = Module.CustomRootPartName or nil;
end
if CustomTeams[game.PlaceId] then Teams = CustomTeams[game.PlaceId] else 
Teams = {
    CheckTeam = function(Player)
	 if Player.Team and LocalPlayer.Team then return Player.Team.Name==LocalPlayer.Team.Name end;return nil
    end	
}
end
return {
    Character = CustomCharacter or function() return LocalPlayer.Character end,
    Teams = Teams,
    Module = Module
}

