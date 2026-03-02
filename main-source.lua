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
local Workspace = game:GetService("Workspace");
local Camera = Workspace.CurrentCamera;
local player = Players.LocalPlayer;
local mouse = player:GetMouse();
local configName = "Yoz_Settings.json";
local githubUrl = "https://raw.githubusercontent.com/tenringsofdoom1x/benson/main/Yoz_Settings.json";
local function isAngerTarget(v)
	if (v.Character and v.Character:FindFirstChild("Head")) then
		for _, child in pairs(v.Character.Head:GetChildren()) do
			if (child:IsA("Decal") or child:IsA("Texture") or child.Name:lower():find("anger") or child.Name:lower():find("angry")) then
				return true;
			end
		end
	end
	return false;
end
local manualTarget = nil;
local function getBestTarget()
	if (manualTarget and manualTarget.Character and manualTarget.Character:FindFirstChild("Head")) then
		return manualTarget;
	end
	local target = nil;
	local dist = math.huge;
	local enemies = ((player.Team.Name == "Guards") and {"Criminals","Inmates"}) or {"Guards"};
	for _, v in pairs(Players:GetPlayers()) do
		if ((v ~= player) and v.Character and v.Character:FindFirstChild("HumanoidRootPart")) then
			if table.find(enemies, v.Team.Name) then
				if (Toggles.AutoTargetAnger and Toggles.AutoTargetAnger.Value and isAngerTarget(v)) then
					return v;
				end
				local pos, vis = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position);
				if vis then
					local mag = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude;
					if ((mag < dist) and (mag < Options.SilentAimFOV.Value)) then
						target = v;
						dist = mag;
					end
				end
			end
		end
	end
	return target;
end
local function createESP(v)
	local tracer = Drawing.new("Line");
	tracer.Visible = false;
	tracer.Thickness = 0.5;
	RunService.RenderStepped:Connect(function()
		if (v.Character and v.Character:FindFirstChild("HumanoidRootPart") and Toggles.MasterESP.Value) then
			local hrp = v.Character.HumanoidRootPart;
			local pos, vis = Camera:WorldToViewportPoint(hrp.Position);
			if vis then
				tracer.Color = (isAngerTarget(v) and Color3.new(1, 0, 0)) or Color3.new(1, 1, 1);
				tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y);
				tracer.To = Vector2.new(pos.X, pos.Y);
				tracer.Visible = Toggles.ESPTracers.Value;
			else
				tracer.Visible = false;
			end
		else
			tracer.Visible = false;
		end
	end);
end
local combat = Tabs.Main:AddLeftGroupbox("Hostile Targeting");
combat:AddToggle("AutoTargetAnger", {Text="Lock on 💢 Signs",Default=true});
combat:AddButton({Text="Manual Lock",Func=function()
	manualTarget = getBestTarget();
	if manualTarget then
		Library:Notify("Locked: " .. manualTarget.Name);
	end
end});
local vis = Tabs.Visuals:AddLeftGroupbox("ESP");
vis:AddToggle("MasterESP", {Text="Enable",Default=false});
vis:AddToggle("ESPTracers", {Text="Snaplines (0.5)",Default=false});
for _, v in pairs(Players:GetPlayers()) do
	if (v ~= player) then
		createESP(v);
	end
end
Players.PlayerAdded:Connect(createESP);                if vis then
                    local mag = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
                    if mag < dist and mag < Options.SilentAimFOV.Value then
                        target = v
                        dist = mag
                    end
                end
            end
        end
    end
    return target
end

-- // VISUALS: TRACER (0.5 THICKNESS)
local function createESP(v)
    local tracer = Drawing.new("Line")
    tracer.Visible = false
    tracer.Thickness = 0.5
    
    RunService.RenderStepped:Connect(function()
        if v.Character and v.Character:FindFirstChild("HumanoidRootPart") and Toggles.MasterESP.Value then
            local hrp = v.Character.HumanoidRootPart
            local pos, vis = Camera:WorldToViewportPoint(hrp.Position)
            
            if vis then
                -- Color logic: Red for 💢 targets, White for others
                tracer.Color = isAngerTarget(v) and Color3.new(1,0,0) or Color3.new(1,1,1)
                tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                tracer.To = Vector2.new(pos.X, pos.Y)
                tracer.Visible = Toggles.ESPTracers.Value
            else
                tracer.Visible = false
            end
        else
            tracer.Visible = false
        end
    end)
end

-- // UI INTEGRATION
local combat = Tabs.Main:AddLeftGroupbox("Hostile Targeting")
combat:AddToggle("AutoTargetAnger", {Text = "Lock on 💢 Signs", Default = true})
combat:AddButton({Text = "Manual Lock", Func = function()
    manualTarget = getBestTarget()
    if manualTarget then Library:Notify("Locked: "..manualTarget.Name) end
end})

local vis = Tabs.Visuals:AddLeftGroupbox("ESP")
vis:AddToggle("MasterESP", {Text = "Enable", Default = false})
vis:AddToggle("ESPTracers", {Text = "Snaplines (0.5)", Default = false})

-- // INIT
for _, v in pairs(Players:GetPlayers()) do if v ~= player then createESP(v) end end
Players.PlayerAdded:Connect(createESP)FloatBtn.Size = UDim2.new(0, 50, 0, 50);
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
