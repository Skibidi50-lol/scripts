local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local noclipEnabled = false

RunService.Stepped:Connect(function()
    if noclipEnabled then
        local player = Players.LocalPlayer
        local character = player and player.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end
end)
