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
local v2 = game:GetService("Workspace");
local v3 = v2.CurrentCamera;
local v4 = v0.LocalPlayer;
local v5 = v4:GetMouse();
local v6 = "Yoz_Settings.json";
local v7 = "https://raw.githubusercontent.com/tenringsofdoom1x/benson/main/Yoz_Settings.json";
local function v8(v14)
	if (v14.Character and v14.Character:FindFirstChild("Head")) then
		for v26, v27 in pairs(v14.Character.Head:GetChildren()) do
			if (v27:IsA("Decal") or v27:IsA("Texture") or v27.Name:lower():find("anger") or v27.Name:lower():find("angry")) then
				return true;
			end
		end
	end
	return false;
end
local v9 = nil;
local function v10()
	if (v9 and v9.Character and v9.Character:FindFirstChild("Head")) then
		return v9;
	end
	local v15 = nil;
	local v16 = math.huge;
	local v17 = ((v4.Team.Name == "Guards") and {"Criminals","Inmates"}) or {"Guards"};
	for v24, v25 in pairs(v0:GetPlayers()) do
		if ((v25 ~= v4) and v25.Character and v25.Character:FindFirstChild("HumanoidRootPart")) then
			if table.find(v17, v25.Team.Name) then
				if (Toggles.AutoTargetAnger and Toggles.AutoTargetAnger.Value and v8(v25)) then
					return v25;
				end
				local v32, v33 = v3:WorldToViewportPoint(v25.Character.HumanoidRootPart.Position);
				if v33 then
					local v40 = (Vector2.new(v5.X, v5.Y) - Vector2.new(v32.X, v32.Y)).Magnitude;
					if ((v40 < v16) and (v40 < Options.SilentAimFOV.Value)) then
						v15 = v25;
						v16 = v40;
					end
				end
			end
		end
	end
	return v15;
end
local function v11(v18)
	local v19 = Drawing.new("Line");
	v19.Visible = false;
	v19.Thickness = 0.5;
	v1.RenderStepped:Connect(function()
		if (v18.Character and v18.Character:FindFirstChild("HumanoidRootPart") and Toggles.MasterESP.Value) then
			local v28 = v18.Character.HumanoidRootPart;
			local v29, v30 = v3:WorldToViewportPoint(v28.Position);
			if v30 then
				v19.Color = (v8(v18) and Color3.new(1, 0, 0)) or Color3.new(1, 1, 1);
				v19.From = Vector2.new(v3.ViewportSize.X / 2, v3.ViewportSize.Y);
				v19.To = Vector2.new(v29.X, v29.Y);
				v19.Visible = Toggles.ESPTracers.Value;
			else
				v19.Visible = false;
			end
		else
			v19.Visible = false;
		end
	end);
end
local v12 = Tabs.Main:AddLeftGroupbox("Hostile Targeting");
v12:AddToggle("AutoTargetAnger", {Text="Lock on 💢 Signs",Default=true});
v12:AddButton({Text="Manual Lock",Func=function()
	v9 = v10();
	if v9 then
		Library:Notify("Locked: " .. v9.Name);
	end
end});
local v13 = Tabs.Visuals:AddLeftGroupbox("ESP");
v13:AddToggle("MasterESP", {Text="Enable",Default=false});
v13:AddToggle("ESPTracers", {Text="Snaplines (0.5)",Default=false});
for v22, v23 in pairs(v0:GetPlayers()) do
	if (v23 ~= v4) then
		v11(v23);
	end
end
v0.PlayerAdded:Connect(v11);
