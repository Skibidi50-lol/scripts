local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Synix - Prison Life V2", "Sentinel")

local SelfRoot = game.Players.LocalPlayer.Character.HumanoidRootPart
local SelfName = game.Players.LocalPlayer.Name
local DamageRemote = game.ReplicatedStorage.meleeEvent
local LocalPlayer = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")

local KillAuraEnabled = false
local ArrestAllEnabled = false

local gun = "Remington 870";

local SP = {}
local PG = {
    ["AK-47"] = true,
    ["Remington 870"] = true,
    ["M9"] = true,
    ["M4A1"] = false,
    ["All"] = true
}

local SetCFrame = function(x : CFrame)
    LocalPlayer.Character['HumanoidRootPart'].CFrame = x;
end

local NotifyPlayer = function(title : string, text : string, dur : number)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title;
        Text = text;
        Duration = dur or 5;
    })
end

local GrabItem = function(itemorigin, item)
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart");
    local timeout = tick() + 5

    if hrp then 
        SP.GetGunOldPos = not SP.GetGunOldPos and hrp.CFrame or SP.GetGunOldPos;
    end

    local ItemToGrab = itemorigin:FindFirstChild(item)
    local IP = ItemToGrab['ITEMPICKUP']
    local IPPos= IP.Position

    if hrp then 
        SetCFrame(CFrame.new(IPPos));
    end; 

    repeat task.wait()

        pcall(function()
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit = false;
            SetCFrame(CFrame.new(IP))
        end); 
        task.spawn(function()
            game:GetService("Workspace").Remote.ItemHandler:InvokeServer(IP)
        end)

    until LocalPlayer.Backpack:FindFirstChild(item) or LocalPlayer.Character:FindFirstChild(item) or tick() - timeout >=0

    pcall(function() 
        SetCFrame(SP.GetGunOldPos);
    end) 


    SP.GetGunOldPos = nil
end

local GiveItem = function(gungiver, gun)
    if gungiver and gungiver == "old" then
        game:GetService("Workspace").Remote.ItemHandler:InvokeServer(gun)

        return
    end

    for _, givers in pairs(workspace.Prison_ITEMS:GetChildren()) do
        if givers:FindFirstChild(gun) then
            GrabItem(gungiver, gun)
            break
        end

        return
    end

    if gungiver then
        workspace.Remote.ItemHandler:InvokeServer({Position = LocalPlayer.Character.Head.Position, Parent = gungiver:FindFirstChild(gun)})
    else
        workspace.Remote.ItemHandler:InvokeServer({Position = LocalPlayer.Character.Head.Position, Parent = workspace.Prison_ITEMS.giver:FindFirstChild(gun) or workspace.Prison_ITEMS.single:FindFirstChild(gun)})
    end
end

local SpawnGun = function(guntogive : string)
    if guntogive ~= "All" then
        workspace.Remote.ItemHandler:InvokeServer({
            Position = LocalPlayer.Character.Head.Position,
            Parent = workspace.Prison_ITEMS.giver:FindFirstChild(guntogive)
                or workspace.Prison_ITEMS.single:FindFirstChild(guntogive)
        })
    else
        for gunName, _ in pairs(PG) do
            if gunName ~= "All" then
                workspace.Remote.ItemHandler:InvokeServer({
                    Position = LocalPlayer.Character.Head.Position,
                    Parent = workspace.Prison_ITEMS.giver:FindFirstChild(gunName)
                        or workspace.Prison_ITEMS.single:FindFirstChild(gunName)
                })
            end
        end
    end
end
--DESTROY DOORS
function DestroyDoors()
   Workspace.Doors:Destroy()
end
--KILL AURA
RunService.Stepped:Connect(function()
    if KillAuraEnabled then
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local distance = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if distance < 15 then
                    pcall(function()
                        DamageRemote:FireServer(player)
                    end)
                end
            end
        end
    end
end)
--ARREST ALL
function ArrestAll()
          local Player = game.Players.LocalPlayer
          local cpos = Player.Character.HumanoidRootPart.CFrame
          for i,v in pairs(game.Teams.Criminals:GetPlayers()) do
          if v.Name ~= Player.Name then
          local i = 10
          repeat
          wait()
          i = i-1
          game.Workspace.Remote.arrest:InvokeServer(v.Character.HumanoidRootPart)
          Player.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1)
          until i == 0
       end
    end
end

--INF JUMP
local InfiniteJumpEnabled = false

game:GetService("UserInputService").JumpRequest:connect(function()
	if InfiniteJumpEnabled then
		game:GetService"Players".LocalPlayer.Character:FindFirstChildOfClass'Humanoid':ChangeState("Jumping")
	end
end)

local Main = Window:NewTab("Main")
local PlayerTab = Window:NewTab("Player")
--MAIN
local MainSection = Main:NewSection("Main")

MainSection:NewButton("Delete Doors", "Destroy All the game doors", function()
    DestroyDoors()
end)

MainSection:NewToggle("Kill Aura", "Kill the player near around you", function(bool)
   KillAuraEnabled = bool
end)

MainSection:NewButton("Arrest All Criminal", "Arrest All the criminal in the server", function()
    ArrestAll()
end)


local GunSection = Main:NewSection("Get Gun")

GunSection:NewDropdown("Select Gun", "Select gun to get gun.", {"Remington 870", "M9", "AK-47", "All"}, function(v)
    gun = v
end)

GunSection:NewButton("Get Gun", "Get the gun that selected in the dropdown", function()
    if PG[gun] then
			if gun == "All" then
			SpawnGun("All")
			NotifyPlayer("FE Gun Spawner", "Successfully Gave You All Guns")
	    else
			SpawnGun(gun)
			NotifyPlayer("FE Gun Spawner", "Successfully Gave You " .. gun)
		end
	else
		NotifyPlayer("Error", "Invalid gun selected", 3)
	end
end)

local ToolsSection = Main:NewSection("Tools")

ToolsSection:NewButton("Btools", "Get some roblox building tools", function()
   loadstring(game:HttpGet("https://cdn.wearedevs.net/scripts/BTools.txt"))()
end)

ToolsSection:NewButton("Get Secret Mirror", "Get the game secret mirror", function()
   print("soon")
end)

local TeamsSection = Main:NewSection("Teams")

TeamsSection:NewDropdown("Change Team (Kinda Bug Idk)", "Change your player team", {"Criminal", "Prisoner", "Police"}, function(v)
    if v == "Criminal" then
       game.Players.LocalPlayer.TeamColor = BrickColor.new("Bright red")
     elseif v == "Police" then
        game.Players.LocalPlayer.TeamColor = BrickColor.new("Bright blue")
     elseif v == "Prisoner" then
        game.Players.LocalPlayer.TeamColor = BrickColor.new("Bright orange")
    end
end)

--PLAYER
local PlayerSection = PlayerTab:NewSection("Player Settings")

PlayerSection:NewSlider("WalkSpeed", "Modify the localplayer WalkSpeed", 250, 16, function(v)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
end)

PlayerSection:NewSlider("JumpPower", "Modify the localplayer JumpPower", 250, 50, function(v)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = v
end)

PlayerSection:NewToggle("Infinite Jump", "Make you can infinite jump instead of jump", function(bool)
   InfiniteJumpEnabled = bool
end)
