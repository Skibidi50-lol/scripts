local Mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/deeeity/mercury-lib/master/src.lua"))()
local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/linemaster2/esp-library/main/library.lua"))();

local silentAimEnabled = true
local fovEnabled = false
local fovRadius = 100
local fovCircleColor = Color3.fromRGB(173, 216, 230)
local targetPartName = "Head" 

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local fovCircle = Drawing.new("Circle")
fovCircle.Color = fovCircleColor
fovCircle.Thickness = 2
fovCircle.Filled = false
fovCircle.NumSides = 100
fovCircle.Radius = fovRadius
fovCircle.Visible = true
fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

RunService.RenderStepped:Connect(function()
	fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
	fovCircle.Radius = fovRadius
end)

local function getNearestTargetPart()
	local closestPlayer = nil
	local shortestDistance = math.huge
	local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(targetPartName) then
			local part = player.Character[targetPartName]
			local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)

			if onScreen then
				local screenDist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
				if screenDist < fovRadius and screenDist < shortestDistance then
					shortestDistance = screenDist
					closestPlayer = player
				end
			end
		end
	end

	if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild(targetPartName) then
		return closestPlayer.Character[targetPartName]
	end

	return nil
end

UserInputService.InputBegan:Connect(function(input)
	if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.KeyCode == Enum.KeyCode.ButtonR2) and silentAimEnabled then
		local targetPart = getNearestTargetPart()
		if targetPart then
			local aimPosition = targetPart.Position
			Camera.CFrame = CFrame.new(Camera.CFrame.Position, aimPosition)
			ReplicatedStorage.Remotes.Attack:FireServer(targetPart)
		end
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		spamming = false
	end
end)

local GUI = Mercury:Create{
	Name = "Mercury",
	Size = UDim2.fromOffset(600, 400),
	Theme = Mercury.Themes.Dark,
	Link = "https://github.com/deeeity/mercury-lib"
}

local aimTab = GUI:Tab{
	Name = "Aimbot",
	Icon = "rbxassetid://4384396714"
}

aimTab:Toggle{
	Name = "Silent Aim",
	StartingState = true,
	Description = nil,
	Callback = function(v)
		silentAimEnabled = v
	end
}

aimTab:Toggle{
	Name = "Silent Aim FOV",
	StartingState = true,
	Description = nil,
	Callback = function(v)
		fovEnabled = v
		fovCircle.Visible = v
	end
}

aimTab:Slider{
	Name = "Silent Aim Size",
	Default = 100,
	Min = 0,
	Max = 300,
	Callback = function(v)
		fovRadius = v
	end
}

local espTab = GUI:Tab{
	Name = "Visuals",
	Icon = "rbxassetid://4370344717"
}

espTab:Toggle{
	Name = "Active ESP",
	StartingState = false,
	Description = nil,
	Callback = function(v) 
        ESP.Enabled = v
    end
}

espTab:Toggle{
	Name = "Boxes",
	StartingState = false,
	Description = nil,
	Callback = function(v) 
        ESP.ShowBox = v
    end
}

espTab:Toggle{
	Name = "Names",
	StartingState = false,
	Description = nil,
	Callback = function(v) 
        ESP.ShowName = v
    end
}

espTab:Toggle{
	Name = "Health",
	StartingState = false,
	Description = nil,
	Callback = function(v) 
        ESP.ShowHealth = v
    end
}

espTab:Toggle{
	Name = "Tracer",
	StartingState = false,
	Description = nil,
	Callback = function(v) 
        ESP.ShowTracer = v
    end
}

espTab:Toggle{
	Name = "Distance",
	StartingState = false,
	Description = nil,
	Callback = function(v) 
        ESP.ShowDistance = v
    end
}

local gunTab = GUI:tab{
    Icon = "rbxassetid://124971614145316",
    Name = "Gun Mod"
}

gunTab:Button{
	Name = "No Spread",
	Description = "Level 8 Executor Needed",
	Callback = function() 
       local function toggleTableAttribute(attribute, value)
        for _, gcVal in pairs(getgc(true)) do
                  if type(gcVal) == "table" and rawget(gcVal, attribute) then
                  gcVal[attribute] = value
              end
          end
       end
       toggleTableAttribute("ShootSpread", 0)
    end
}

gunTab:Button{
	Name = "Rapid Fire",
	Description = "Level 8 Executor Needed",
	Callback = function() 
       local function toggleTableAttribute(attribute, value)
        for _, gcVal in pairs(getgc(true)) do
                  if type(gcVal) == "table" and rawget(gcVal, attribute) then
                  gcVal[attribute] = value
              end
          end
       end
       toggleTableAttribute("ShootCooldown", 0)
    end
}

gunTab:Button{
	Name = "No Recoil",
	Description = "Level 8 Executor Needed",
	Callback = function() 
       local function toggleTableAttribute(attribute, value)
        for _, gcVal in pairs(getgc(true)) do
                  if type(gcVal) == "table" and rawget(gcVal, attribute) then
                  gcVal[attribute] = value
              end
          end
       end
       toggleTableAttribute("ShootRecoil", 0)
    end
}

GUI:Notification{
	Title = "Alert",
	Text = "Script Loaded!",
	Duration = 3,
	Callback = function() 
    
    end
}
