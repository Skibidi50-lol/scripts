local Mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/deeeity/mercury-lib/master/src.lua"))()
local dhlock = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stratxgy/DH-Lua-Lock/refs/heads/main/Main.lua"))()
local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/linemaster2/esp-library/main/library.lua"))();


getgenv().GO = false
getgenv().HitboxSize = 10
getgenv().HitboxVisible = false

game:GetService("RunService").Stepped:Connect(function()
    for i,v in pairs(game:GetService("Players"):GetPlayers()) do
        if v:IsA("Player") and v ~= game:GetService("Players").LocalPlayer and v.Character and GO then
            local size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
            local transparency = HitboxVisible and 0.6 or 1

            v.Character.RightUpperLeg.CanCollide = false
            v.Character.RightUpperLeg.Transparency = transparency
            v.Character.RightUpperLeg.Size = size

            v.Character.LeftUpperLeg.CanCollide = false
            v.Character.LeftUpperLeg.Transparency = transparency
            v.Character.LeftUpperLeg.Size = size

            v.Character.HeadHB.CanCollide = false
            v.Character.HeadHB.Transparency = transparency
            v.Character.HeadHB.Size = size

            v.Character.HumanoidRootPart.CanCollide = false
            v.Character.HumanoidRootPart.Transparency = transparency
            v.Character.HumanoidRootPart.Size = size
        end
    end
end)


local GUI = Mercury:Create{
    Name = "Mercury",
    Size = UDim2.fromOffset(600, 400),
    Theme = Mercury.Themes.Dark,
    Link = "https://github.com/deeeity/mercury-lib"
}

local aimTab = GUI:tab{
    Icon = "rbxassetid://4384396714",
    Name = "Aimbot"
}

aimTab:Toggle{
	Name = "Aimbot",
	StartingState = false,
	Description = nil,
	Callback = function(v) 
        getgenv().dhlock.enabled = v
    end
}

aimTab:Toggle{
	Name = "Show FOV",
	StartingState = false,
	Description = nil,
	Callback = function(v) 
        getgenv().dhlock.showfov = v
    end
}

aimTab:Slider{
	Name = "FOV Size",
	Default = 50,
	Min = 50,
	Max = 500,
	Callback = function(v) 
        getgenv().dhlock.fov = v
    end
}

aimTab:color_picker({
    Name = "FOV Color",
    Style = Mercury.ColorPickerStyles.Legacy,
    Description = "Adjust the aimbot fov color",
    Callback = function(color)
        getgenv().dhlock.fovcolorunlocked = color
    end,
})

aimTab:Toggle{
	Name = "Team Check",
	StartingState = false,
	Description = nil,
	Callback = function(v) 
        getgenv().dhlock.teamcheck = v
    end
}

aimTab:Toggle{
	Name = "Wall Check",
	StartingState = false,
	Description = nil,
	Callback = function(v) 
        getgenv().dhlock.wallcheck = v
    end
}

aimTab:Toggle{
	Name = "Alive Check",
	StartingState = false,
	Description = nil,
	Callback = function(v) 
        getgenv().dhlock.alivecheck = v
    end
}

aimTab:Toggle{
	Name = "Hitbox Expander",
	StartingState = false,
	Description = nil,
	Callback = function(v) 
        getgenv().GO = v
    end
}

aimTab:Toggle{
	Name = "Show Hitbox",
	StartingState = false,
	Description = nil,
	Callback = function(v) 
		getgenv().HitboxVisible = v
    end
}

aimTab:Slider{
	Name = "Hitbox Size",
	Default = 10,
	Min = 1,
	Max = 25,
	Callback = function(v) 
        getgenv().HitboxSize = v
    end
}

local gunTab = GUI:tab{
    Icon = "rbxassetid://124971614145316",
    Name = "Gun Mod"
}

gunTab:Button{
	Name = "Infinite Ammo",
	Description = nil,
	Callback = function() 
		while wait() do
        game:GetService("Players").LocalPlayer.PlayerGui.GUI.Client.Variables.ammocount.Value = 999
	    game:GetService("Players").LocalPlayer.PlayerGui.GUI.Client.Variables.ammocount2.Value = 999
		end
    end
}

local espTab = GUI:tab{
    Icon = "rbxassetid://4370344717",
    Name = "ESP"
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

GUI:Notification{
	Title = "Alert",
	Text = "Script Loaded!",
	Duration = 3,
	Callback = function() 
    
    end
}
