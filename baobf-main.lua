--[[
 .____                  ________ ___.    _____                           __                
 |    |    __ _______   \_____  \\_ |___/ ____\_ __  ______ ____ _____ _/  |_  ___________ 
 |    |   |  |  \__  \   /   |   \| __ \   __\  |  \/  ___// ___\\__  \\   __\/  _ \_  __ \
 |    |___|  |  // __ \_/    |    \ \_\ \  | |  |  /\___ \\  \___ / __ \|  | (  <_> )  | \/
 |_______ \____/(____  /\_______  /___  /__| |____//____  >\___  >____  /__|  \____/|__|   
         \/          \/         \/    \/                \/     \/     \/                   
          \_Welcome to LuaObfuscator.com   (Alpha 0.10.9) ~  Much Love, Ferib 

]]--

local v0 = game:GetService("Players");
local v1 = game:GetService("RunService");
local v2 = game:GetService("HttpService");
local v3 = game:GetService("CoreGui");
local v4 = game:GetService("Workspace");
local v5 = v0.LocalPlayer;
local v6 = v5.Character or v5.CharacterAdded:Wait();
local v7 = "Yoz_Settings.json";
local v8 = "https://raw.githubusercontent.com/tenringsofdoom1x/benson/main/Yoz_Settings.json";
local function v9()
	local v29, v30 = pcall(function()
		return game:HttpGet(v8);
	end);
	if v29 then
		writefile(v7, v30);
		return v2:JSONDecode(v30);
	end
end
local v10 = (isfile(v7) and v2:JSONDecode(readfile(v7))) or v9();
local v11 = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/";
local v12 = loadstring(game:HttpGet(v11 .. "Library.lua"))();
local v13 = v12:CreateWindow({Title="Yoz ScriptService",Center=true,AutoShow=true,Resizable=true,MobileButtonsSide="Right"});
local v14 = {Main=v13:AddTab("Main", "user"),Combat=v13:AddTab("Combat", "crosshair"),Visuals=v13:AddTab("Visuals", "eye"),Settings=v13:AddTab("Settings", "settings")};
local v15 = Instance.new("ScreenGui", v3);
local v16 = Instance.new("TextButton", v15);
v16.Size = UDim2.new(0, 50, 0, 50);
v16.Position = UDim2.new(0, 20, 0.5, -25);
v16.BackgroundColor3 = Color3.fromRGB(30, 30, 30);
v16.Text = "YOZ";
v16.TextColor3 = Color3.new(1, 1, 1);
Instance.new("UICorner", v16).CornerRadius = UDim.new(1, 0);
v16.MouseButton1Click:Connect(function()
	v13:Toggle();
end);
local function v23(v31)
	local v32 = v4:FindFirstChild("Remote", true) and v4.Remote:FindFirstChild("arrest");
	if v32 then
		v32:InvokeServer(v31);
	end
end
v1.RenderStepped:Connect(function()
	for v35, v36 in ipairs(v0:GetPlayers()) do
		if ((v36 == v5) or not v36.Character) then
			continue;
		end
		local v37 = v36.Character;
		local v38 = v37:FindFirstChild("HumanoidRootPart");
		local v39 = v37:FindFirstChild("Humanoid");
		if (v38 and v39 and (v39.Health > 0)) then
			if (Toggles.HitboxExpander and Toggles.HitboxExpander.Value) then
				v38.Size = Vector3.new(Options.HitboxSize.Value, Options.HitboxSize.Value, Options.HitboxSize.Value);
				v38.Transparency = 0.8;
				v38.CanCollide = false;
			else
				v38.Size = Vector3.new(2, 2, 1);
			end
			if (Toggles.AutoArrest and Toggles.AutoArrest.Value) then
				if (v36.Team and (v36.Team.Name == "Criminals")) then
					if ((v5.Character.HumanoidRootPart.Position - v38.Position).Magnitude < 15) then
						v23(v38);
					end
				end
			end
			if (Toggles.ShowTargetESP and Toggles.ShowTargetESP.Value) then
				local v53 = v37:FindFirstChild("YozTarget") or Instance.new("BillboardGui", v37:FindFirstChild("Head") or v38);
				if (v53.Name ~= "YozTarget") then
					v53.Name = "YozTarget";
					v53.Size = UDim2.new(0, 140, 0, 60);
					v53.AlwaysOnTop = true;
					local v59 = Instance.new("Frame", v53);
					v59.Size = UDim2.new(1, 0, 1, 0);
					v59.BackgroundColor3 = Color3.new(0, 0, 0);
					v59.BackgroundTransparency = 0.4;
					Instance.new("UICorner", v59);
					local v63 = Instance.new("TextLabel", v59);
					v63.Name = "L";
					v63.Size = UDim2.new(1, -10, 1, -10);
					v63.Position = UDim2.new(0, 5, 0, 5);
					v63.BackgroundTransparency = 1;
					v63.TextColor3 = Color3.new(1, 1, 1);
					v63.RichText = true;
					v63.TextWrapped = true;
				end
				local v54 = math.floor((v5.Character.HumanoidRootPart.Position - v38.Position).Magnitude);
				v53.Frame.L.Text = "<b>" .. v36.DisplayName .. "</b>\n" .. v54 .. "m";
			elseif v37:FindFirstChild("YozTarget") then
				v37.YozTarget:Destroy();
			end
		end
	end
end);
local v24 = v14.Main:AddLeftGroupbox("Interface");
v24:AddSlider("UIScale", {Text="Resize",Min=0.5,Max=1.5,Default=(v10.UIScale or 1),Callback=function(v33)
	if v13.Main then
		v13.Main.UIScale.Scale = v33;
	end
end});
local v25 = v14.Combat:AddLeftGroupbox("Guard Tools");
v25:AddToggle("AutoArrest", {Text="Auto Arrest",Default=(v10.AutoArrest or false)});
v25:AddButton({Text="Join Guards",Func=function()
	v4.Remote.TeamEvent:FireServer("Bright blue");
end});
local v26 = v14.Combat:AddRightGroupbox("Targeting");
v26:AddToggle("HitboxExpander", {Text="Chaos Hitbox",Default=(v10.HitboxExpander or false)});
v26:AddSlider("HitboxSize", {Text="Radius",Min=2,Max=50,Default=(v10.HitboxSize or 15)});
local v27 = v14.Visuals:AddLeftGroupbox("ESP");
v27:AddToggle("ShowTargetESP", {Text="Target ESP",Default=(v10.ShowTargetESP or false)});
local v28 = v14.Settings:AddLeftGroupbox("Config");
v28:AddButton({Text="Save Settings",Func=function()
	local v34 = {};
	for v40, v41 in pairs(Toggles) do
		v34[v40] = v41.Value;
	end
	for v44, v45 in pairs(Options) do
		v34[v44] = v45.Value;
	end
	writefile(v7, v2:JSONEncode(v34));
	v12:Notify("Saved");
end});
v28:AddButton({Text="Sync GitHub",Func=function()
	v9();
	v12:Notify("GitHub Config Applied");
end});
v12:Notify("Yoz ScriptService Loaded");
