local Library = loadstring(Game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wizard"))()
local Window = Library:NewWindow("Aimbot GUI")

local Aimbot = loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Aimbot-V3/main/src/Aimbot.lua"))()

local AimbotSection = Window:NewSection("Aimbot Options")

AimbotSection:CreateToggle("Blatant Aimbot", function(Value)
   Aimbot.Load()
   getgenv().ExunysDeveloperAimbot.Settings.Enabled = Value
end)

AimbotSection:CreateToggle("Show FOV", function(Value)
   getgenv().ExunysDeveloperAimbot.FOVSettings.Enabled = Value
end)

AimbotSection:CreateSlider("FOV Size", 90, 500, 90, false, function(Value)
   getgenv().ExunysDeveloperAimbot.FOVSettings.Radius = Value
end)
