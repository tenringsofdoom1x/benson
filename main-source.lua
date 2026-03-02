--[[
 .____                  ________ ___.    _____                           __                
 |    |    __ _______   \_____  \\_ |___/ ____\_ __  ______ ____ _____ _/  |_  ___________ 
 |    |   |  |  \__  \   /   |   \| __ \   __\  |  \/  ___// ___\\__  \\   __\/  _ \_  __ \
 |    |___|  |  // __ \_/    |    \ \_\ \  | |  |  /\___ \\  \___ / __ \|  | (  <_> )  | \/
 |_______ \____/(____  /\_______  /___  /__| |____//____  >\___  >____  /__|  \____/|__|   
         \/          \/         \/    \/                \/     \/     \/                   
          \_Welcome to LuaObfuscator.com   (Alpha 0.10.9) ~  Much Love, Ferib 

]]--

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local HttpService = game:GetService("HttpService");
local CoreGui = game:GetService("CoreGui");
local Workspace = game:GetService("Workspace");
local player = Players.LocalPlayer;
local char = player.Character or player.CharacterAdded:Wait();
local configName = "Yoz_Settings.json";
local githubUrl = "https://raw.githubusercontent.com/tenringsofdoom1x/benson/main/Yoz_Settings.json";
local function fetchConfig()
	local s, c = pcall(function()
		return game:HttpGet(githubUrl);
	end);
	if s then
		writefile(configName, c);
		return HttpService:JSONDecode(c);
	end
end
local currentSettings = (isfile(configName) and HttpService:JSONDecode(readfile(configName))) or fetchConfig();
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/";
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))();
local Window = Library:CreateWindow({Title="Yoz ScriptService",Center=true,AutoShow=true,Resizable=true,MobileButtonsSide="Right"});
local Tabs = {Main=Window:AddTab("Main", "user"),Combat=Window:AddTab("Combat", "crosshair"),Visuals=Window:AddTab("Visuals", "eye"),Settings=Window:AddTab("Settings", "settings")};
local FloatGui = Instance.new("ScreenGui", CoreGui);
local FloatBtn = Instance.new("TextButton", FloatGui);
FloatBtn.Size = UDim2.new(0, 50, 0, 50);
FloatBtn.Position = UDim2.new(0, 20, 0.5, -25);
FloatBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30);
FloatBtn.Text = "YOZ";
FloatBtn.TextColor3 = Color3.new(1, 1, 1);
Instance.new("UICorner", FloatBtn).CornerRadius = UDim.new(1, 0);
FloatBtn.MouseButton1Click:Connect(function()
	Window:Toggle();
end);
local function doArrest(target)
	local r = Workspace:FindFirstChild("Remote", true) and Workspace.Remote:FindFirstChild("arrest");
	if r then
		r:InvokeServer(target);
	end
end
RunService.RenderStepped:Connect(function()
	for _, v in ipairs(Players:GetPlayers()) do
		if ((v == player) or not v.Character) then
			continue;
		end
		local t = v.Character;
		local hrp = t:FindFirstChild("HumanoidRootPart");
		local hum = t:FindFirstChild("Humanoid");
		if (hrp and hum and (hum.Health > 0)) then
			if (Toggles.HitboxExpander and Toggles.HitboxExpander.Value) then
				hrp.Size = Vector3.new(Options.HitboxSize.Value, Options.HitboxSize.Value, Options.HitboxSize.Value);
				hrp.Transparency = 0.8;
				hrp.CanCollide = false;
			else
				hrp.Size = Vector3.new(2, 2, 1);
			end
			if (Toggles.AutoArrest and Toggles.AutoArrest.Value) then
				if (v.Team and (v.Team.Name == "Criminals")) then
					if ((player.Character.HumanoidRootPart.Position - hrp.Position).Magnitude < 15) then
						doArrest(hrp);
					end
				end
			end
			if (Toggles.ShowTargetESP and Toggles.ShowTargetESP.Value) then
				local g = t:FindFirstChild("YozTarget") or Instance.new("BillboardGui", t:FindFirstChild("Head") or hrp);
				if (g.Name ~= "YozTarget") then
					g.Name = "YozTarget";
					g.Size = UDim2.new(0, 140, 0, 60);
					g.AlwaysOnTop = true;
					local f = Instance.new("Frame", g);
					f.Size = UDim2.new(1, 0, 1, 0);
					f.BackgroundColor3 = Color3.new(0, 0, 0);
					f.BackgroundTransparency = 0.4;
					Instance.new("UICorner", f);
					local tl = Instance.new("TextLabel", f);
					tl.Name = "L";
					tl.Size = UDim2.new(1, -10, 1, -10);
					tl.Position = UDim2.new(0, 5, 0, 5);
					tl.BackgroundTransparency = 1;
					tl.TextColor3 = Color3.new(1, 1, 1);
					tl.RichText = true;
					tl.TextWrapped = true;
				end
				local d = math.floor((player.Character.HumanoidRootPart.Position - hrp.Position).Magnitude);
				g.Frame.L.Text = "<b>" .. v.DisplayName .. "</b>\n" .. d .. "m";
			elseif t:FindFirstChild("YozTarget") then
				t.YozTarget:Destroy();
			end
		end
	end
end);
local m = Tabs.Main:AddLeftGroupbox("Interface");
m:AddSlider("UIScale", {Text="Resize",Min=0.5,Max=1.5,Default=(currentSettings.UIScale or 1),Callback=function(v)
	if Window.Main then
		Window.Main.UIScale.Scale = v;
	end
end});
local c = Tabs.Combat:AddLeftGroupbox("Guard Tools");
c:AddToggle("AutoArrest", {Text="Auto Arrest",Default=(currentSettings.AutoArrest or false)});
c:AddButton({Text="Join Guards",Func=function()
	Workspace.Remote.TeamEvent:FireServer("Bright blue");
end});
local t = Tabs.Combat:AddRightGroupbox("Targeting");
t:AddToggle("HitboxExpander", {Text="Chaos Hitbox",Default=(currentSettings.HitboxExpander or false)});
t:AddSlider("HitboxSize", {Text="Radius",Min=2,Max=50,Default=(currentSettings.HitboxSize or 15)});
local vi = Tabs.Visuals:AddLeftGroupbox("ESP");
vi:AddToggle("ShowTargetESP", {Text="Target ESP",Default=(currentSettings.ShowTargetESP or false)});
local s = Tabs.Settings:AddLeftGroupbox("Config");
s:AddButton({Text="Save Settings",Func=function()
	local d = {};
	for i, v in pairs(Toggles) do
		d[i] = v.Value;
	end
	for i, v in pairs(Options) do
		d[i] = v.Value;
	end
	writefile(configName, HttpService:JSONEncode(d));
	Library:Notify("Saved");
end});
s:AddButton({Text="Sync GitHub",Func=function()
	fetchConfig();
	Library:Notify("GitHub Config Applied");
end});
Library:Notify("Yoz ScriptService Loaded");
