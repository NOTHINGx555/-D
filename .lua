


--delete 
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Referencje do GameGui
local gameGui = playerGui:FindFirstChild("GameGui") -- We are specifically targeting GameGui here
local transitionFrame = gameGui:FindFirstChild("Transition")
local keyHintsFrame = gameGui:FindFirstChild("KeyHints")
local challengesWidget = gameGui:FindFirstChild("ChallengesWidget")

-- Funkcja do usuwania ekranów
local function deleteScreen(screen)
    if screen then
        screen:Destroy()
        print(screen.Name .. " delete")
    else
        print("Not found " .. screen.Name)
    end
end

-- Usuwanie Transition, KeyHints i ChallengesWidget z GameGui
deleteScreen(transitionFrame)
deleteScreen(keyHintsFrame)
deleteScreen(challengesWidget)







--color change stamina and power 
--color change stamina and power 
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 10)

if playerGui then
    -- PlayerGui found
else
    warn("PlayerGui not found")
    return
end

-- Reference GameGui in PlayerGui
local gameGui = playerGui:WaitForChild("GameGui", 10)
if gameGui then
    -- GameGui found
else
    warn("GameGui not found")
    return
end

-- Reference MatchHUD in GameGui
local matchHUD = gameGui:WaitForChild("MatchHUD", 10)
if matchHUD then
    -- MatchHUD found
else
    warn("MatchHUD not found")
    return
end

-- Reference EnergyBars in MatchHUD
local energyBars = matchHUD:WaitForChild("EngergyBars", 10)
if energyBars then
    -- EnergyBars found
else
    warn("EnergyBars not found")
    return
end

-- Reference Power and Stamina frames in EnergyBars
local power = energyBars:WaitForChild("Power", 10)
local stamina = energyBars:WaitForChild("Stamina", 10)

-- Check if each element is found and handle it accordingly
if power then
    -- Delete existing UIGradient in Power, if it exists
    local powerProgressBar = power:FindFirstChild("ProgressBar")
    if powerProgressBar then
        local existingUIGradient = powerProgressBar:FindFirstChild("UIGradient")
        if existingUIGradient then
            existingUIGradient:Destroy()
        end
        -- Create a new UIGradient with red to white, transitioning from left to right
        local newPowerGradient = Instance.new("UIGradient")
        newPowerGradient.Color = ColorSequence.new(Color3.new(0, 0, 0), Color3.new(255, 0, 0))  -- Red to White
        newPowerGradient.Rotation = 90  -- Left-to-right gradient
        newPowerGradient.Parent = powerProgressBar
        print("set color power")
    else
        warn("Power ProgressBar not found")
    end
else
    warn("Power not found")
end

if stamina then
    -- Delete existing UIGradient in Stamina, if it exists
    local staminaProgressBar = stamina:FindFirstChild("ProgressBar")
    if staminaProgressBar then
        local existingUIGradient = staminaProgressBar:FindFirstChild("UIGradient")
        if existingUIGradient then
            existingUIGradient:Destroy()
        end
        -- Create a new UIGradient with white to black, transitioning from left to right
        local newStaminaGradient = Instance.new("UIGradient")
        newStaminaGradient.Color = ColorSequence.new(Color3.new(0, 0, 0), Color3.new(255,255,255))  -- White to Black
        newStaminaGradient.Rotation = 90  -- Left-to-right gradient
        newStaminaGradient.Parent = staminaProgressBar
        print("set color stamina")
    else
        warn("Stamina ProgressBar not found")
    end
else
    warn("Stamina not found")
end



--camera 3 ball

local fcRunning = false  -- Tryb kamery jest początkowo wyłączony
local Camera = workspace.CurrentCamera
local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local footballPart = nil -- Aktualna piłka
local cameraDistance = 20  -- Odległość kamery od piłki
local cameraHeight = 10    -- Wysokość kamery nad piłką
local cameraRotation = Vector2.new()  -- Kąt kamery (X, Y)
local minDistance = 5      -- Minimalna odległość kamery
local maxDistance = 50     -- Maksymalna odległość kamery

local originalCameraCFrame = Camera.CFrame
local originalCameraSubject = Camera.CameraSubject

local isSearchingForFootball = false -- Flaga do jednorazowego wyświetlenia komunikatu

-- Funkcja do znalezienia nowego obiektu Football
function FindFootball()
    isSearchingForFootball = true -- Ustaw flagę, że rozpoczęto szukanie
    print("Football was removed, searching for a new one...")
    
    while true do
        footballPart = workspace:FindFirstChild("Junk") and workspace.Junk:FindFirstChild("Football")
        if footballPart then
            print("Found new Football")
            isSearchingForFootball = false -- Reset flagi po znalezieniu piłki
            break
        end
        task.wait(0.5)
    end
end

-- Wywołanie funkcji, aby znaleźć piłkę na początku
FindFootball()

-- Funkcja do przełączania widoku kamery
function ToggleCameraView()
    fcRunning = not fcRunning

    if fcRunning then
        originalCameraCFrame = Camera.CFrame
        originalCameraSubject = Camera.CameraSubject
        Camera.CameraType = Enum.CameraType.Scriptable
        print("Freecam On")
    else
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            Camera.CameraType = Enum.CameraType.Custom
            Camera.CameraSubject = character:FindFirstChild("Humanoid")
            Camera.CFrame = originalCameraCFrame
            print("Freecam Off")
        elseif footballPart then
            Camera.CameraSubject = footballPart
        end
    end
end

-- Przełączanie widoku kamery po naciśnięciu klawisza "3"
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Two then
        ToggleCameraView()
    end
end)

-- Obsługa ruchu myszką i kółka myszy do sterowania kamerą
UserInputService.InputChanged:Connect(function(input)
    if fcRunning then
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            cameraRotation = cameraRotation + Vector2.new(-input.Delta.X, -input.Delta.Y) * 0.3
            cameraRotation = Vector2.new(cameraRotation.X, math.clamp(cameraRotation.Y, -80, 80))
        elseif input.UserInputType == Enum.UserInputType.MouseWheel then
            cameraDistance = math.clamp(cameraDistance - input.Position.Z * 2, minDistance, maxDistance)
        end
    end
end)

-- Aktualizacja pozycji kamery w trybie freecam
RunService.RenderStepped:Connect(function()
    if fcRunning and footballPart then
        local yaw = math.rad(cameraRotation.X)
        local pitch = math.rad(cameraRotation.Y)

        local offset = Vector3.new(
            math.sin(yaw) * math.cos(pitch) * cameraDistance,
            math.sin(pitch) * cameraDistance,
            math.cos(yaw) * math.cos(pitch) * cameraDistance
        )

        local cameraPos = footballPart.Position + offset + Vector3.new(0, cameraHeight, 0)
        Camera.CFrame = CFrame.new(cameraPos, footballPart.Position)
    end

    -- Sprawdza, czy obecny `Football` nadal istnieje
    if not footballPart or not footballPart:IsDescendantOf(workspace) then
        if not isSearchingForFootball then
            FindFootball() -- Rozpocznij wyszukiwanie nowej piłki
        end
    end
end)


--- gol G away and home auto 
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local userInputService = game:GetService("UserInputService")
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Unique identifier for this specific functionality
local UNIQUE_EVENT_NAME = "UpdateBallPosition_Specific"

-- Function to find the ball in the Junk folder
local function findBall()
    local junkFolder = game.Workspace:FindFirstChild("Junk")
    if junkFolder then
        local football = junkFolder:FindFirstChild("Football")
        if football and football:IsA("Part") then
            return football
        end
    end
    return nil
end

-- Function to teleport the ball to the specific coordinates
local function teleportBall(targetPosition)
    local ball = findBall()
    if ball then
        ball.Position = targetPosition

        local remoteEvent = replicatedStorage:FindFirstChild(UNIQUE_EVENT_NAME)
        if remoteEvent then
            remoteEvent:FireServer(targetPosition)
        end
    end
end

-- Function to get the target position based on the player's team
local function getTargetPosition()
    if player.Team and player.Team.Name == "Home" then
        return Vector3.new(2.010676682, 4.00001144, -186.170898) -- Home team's coordinates
    elseif player.Team and player.Team.Name == "Away" then
        return Vector3.new(-0.214612424, 4.00001144, 186.203613) -- Away team's coordinates
    end
    return nil
end

-- Event listener for key press
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.G and not gameProcessed then
        local targetPosition = getTargetPosition()
        if targetPosition then
            teleportBall(targetPosition)
        end
    end
end)




--hig 
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local movementAndSpeedEnabled = false
local hipHeightEnabled = false

-- Function to toggle the hip height of the humanoid
local function toggleHipHeight()
    local character = Players.LocalPlayer.Character
    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        if hipHeightEnabled then
            humanoid.HipHeight = humanoid.HipHeight - 16
        else
            humanoid.HipHeight = humanoid.HipHeight + 16
        end
        hipHeightEnabled = not hipHeightEnabled
    end
end

-- Function to toggle the movement and speed script
local function toggleMovementAndSpeed()
    movementAndSpeedEnabled = not movementAndSpeedEnabled
    toggleHipHeight()
end

-- Connect keybinds and events
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.H then
        toggleMovementAndSpeed()
    end
end)



---tp ball leftctrl



local Player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

-- Function to move the parts to the player's position
local function movePartsToPlayer()
    local junkFolder = Workspace:FindFirstChild("Junk")
    
    if junkFolder and junkFolder:IsA("Folder") then
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local playerPosition = Player.Character.HumanoidRootPart.Position
            
            for _, obj in pairs(junkFolder:GetDescendants()) do
                if obj:IsA("BasePart") and (obj.Name == "kick1" or obj.Name == "kick2" or obj.Name == "kick3" or obj.Name == "Football") then
                    obj.Position = playerPosition
                end
            end
        else
            print("Player character or HumanoidRootPart not found")
        end
    else
        print("Junk folder not found in Workspace")
    end
end

-- Connect input event
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
        movePartsToPlayer()
    end
end)


---one good farming xp 2 players use same
local clickInterval = 0 -- Interwał czasowy pomiędzy kliknięciami (w sekundach)
local toggleKey = Enum.KeyCode.One -- Klawisz do włączania/wyłączania auto-clickera

local autoClicking = false -- Zmienna przechowująca stan auto-clickera
local teleporting = false -- Zmienna kontrolująca stan teleportacji

local Player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

-- Funkcja symulująca kliknięcie myszą
local function autoClick()
    local VirtualInputManager = game:GetService("VirtualInputManager")

    while autoClicking do
        wait(clickInterval)
        
        -- Sprawdź czy gracz jest obecny
        if game.Players.LocalPlayer then
            -- Symulowanie kliknięcia myszą
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0) -- Użycie domyślnych współrzędnych
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0) -- Użycie domyślnych współrzędnych
        end
    end
end

-- Funkcja do teleportowania obiektów do pozycji gracza
local function movePartsToPlayer()
    local junkFolder = Workspace:FindFirstChild("Junk")

    if junkFolder and junkFolder:IsA("Folder") then
        local playerChar = Player.Character
        local playerHumanoidRootPart = playerChar and playerChar:FindFirstChild("HumanoidRootPart")
        
        if playerHumanoidRootPart then
            local playerPosition = playerHumanoidRootPart.Position

            for _, obj in ipairs(junkFolder:GetDescendants()) do
                if obj:IsA("BasePart") and (obj.Name == "kick1" or obj.Name == "kick2" or obj.Name == "kick3" or obj.Name == "Football") then
                    obj.CFrame = CFrame.new(playerPosition)  -- Ustawienie obiektów w pozycji gracza
                end
            end
        end
    end
end

-- Funkcja obsługująca wciśnięcie klawisza dla auto-clickera
local function onKeyPress(input, gameProcessedEvent)
    if input.KeyCode == toggleKey and not gameProcessedEvent then
        autoClicking = not autoClicking
        if autoClicking then
            spawn(autoClick) -- Uruchomienie auto-clickera w nowym wątku
        end
    end
end

-- Funkcja do przełączania teleportacji po wciśnięciu klawisza numer 1
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.One then
        teleporting = not teleporting
    end
end)

-- Ciągłe teleportowanie obiektów do pozycji gracza, jeśli flaga jest ustawiona
RunService.RenderStepped:Connect(function()
    if teleporting then
        movePartsToPlayer()
    end
end)

-- Podłączenie funkcji do zdarzenia wciśnięcia klawisza dla auto-clickera
game:GetService("UserInputService").InputBegan:Connect(onKeyPress)

--auto clicker
local clickInterval = 0 -- Interwał czasowy pomiędzy kliknięciami (w sekundach)
local toggleKey = Enum.KeyCode.V -- Klawisz do włączania/wyłączania auto-clickera

local autoClicking = false -- Zmienna przechowująca stan auto-clickera

-- Funkcja symulująca kliknięcie myszą
local function autoClick()
    local VirtualInputManager = game:GetService("VirtualInputManager")

    while autoClicking do
        wait(clickInterval)
        
        -- Sprawdź czy gracz jest obecny
        if game.Players.LocalPlayer then
            -- Symulowanie kliknięcia myszą
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0) -- Użycie domyślnych współrzędnych
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0) -- Użycie domyślnych współrzędnych
        end
    end
end

-- Funkcja obsługująca wciśnięcie klawisza
local function onKeyPress(input, gameProcessedEvent)
    if input.KeyCode == toggleKey and not gameProcessedEvent then
        autoClicking = not autoClicking
        if autoClicking then
            spawn(autoClick) -- Uruchomienie auto-clickera w nowym wątku
        end
    end
end

-- Podłączenie funkcji do zdarzenia wciśnięcia klawisza
game:GetService("UserInputService").InputBegan:Connect(onKeyPress)






























-- Load Fluent UI
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- Create window
local Window = Fluent:CreateWindow({
    Title = "NOTHING",
    SubTitle = "💀☠️",
    TabWidth = 150,
    Size = UDim2.fromOffset(550, 450),
    Acrylic = false,
    Theme = "Light",
    MinimizeKey = Enum.KeyCode.LeftAlt
})

-- Add tabs
local Tabs = {
    tab2 = Window:AddTab({ Title = "Custom Hitbox", Icon = "play" }),
    Main = Window:AddTab({ Title = "Football Controls", Icon = "unlock" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}



-- Default hitbox settings
local defaultSizeX, defaultSizeY, defaultSizeZ = 4.521276473999023, 5.7297587394714355, 2.397878408432007
local defaultTransparency = 1
local defaultColor = Color3.fromRGB(255, 255, 255)





-- Current hitbox settings (active)
local hitboxSizeX, hitboxSizeY, hitboxSizeZ = defaultSizeX, defaultSizeY, defaultSizeZ
local hitboxTransparency = defaultTransparency
local hitboxColor = defaultColor
local isHitboxActive = false


local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hitbox = character:FindFirstChild("Hitbox") -- Assuming the hitbox is part of the character

-- Store the last position of the hitbox part before respawn
local lastHitboxPosition

-- Function to update the real hitbox part (size, transparency, color)
local function updateRealHitbox()
    if hitbox then
        -- Apply size, transparency, and color changes if toggle is ON
        hitbox.Size = Vector3.new(hitboxSizeX, hitboxSizeY, hitboxSizeZ)
        hitbox.Transparency = hitboxTransparency
        hitbox.Color = hitboxColor
    end
end

-- Function to reset the hitbox to default settings (size, transparency, color)
local function resetHitboxToDefault()
    if hitbox then
        -- Reset to default values when the toggle is OFF
        hitbox.Size = Vector3.new(defaultSizeX, defaultSizeY, defaultSizeZ)
        hitbox.Transparency = defaultTransparency
        hitbox.Color = defaultColor
    end
end

-- Function to move old hitbox to the new hitbox after respawn
local function moveOldHitboxToNewHitbox()
    -- Find the new hitbox part for repositioning
    local newHitboxPart = character:FindFirstChild("Hitbox") -- Adjust this based on your character setup

    if newHitboxPart and hitbox then
        -- Move the existing hitbox to the new part's position
        hitbox.CFrame = newHitboxPart.CFrame

        -- Only update size, transparency, and color if toggle is ON
        if isHitboxActive then
            updateRealHitbox()
        else
            -- Reset hitbox if toggle is OFF
            resetHitboxToDefault()
        end
    else
        warn("Hitbox not found!")
    end
end

-- Function to handle respawn and hitbox reset
player.CharacterAdded:Connect(function(character)
    -- Wait for the hitbox to be created
    hitbox = character:WaitForChild("Hitbox", 10)

end)

-- Add the toggle for custom hitbox to Tab 2
local Toggle = Tabs.tab2:AddToggle("MyToggle", { Title = "Custom Hitbox", Default = false })

Toggle:OnChanged(function()
    isHitboxActive = Toggle.Value

    -- If toggle is ON, update hitbox in loop
    if isHitboxActive then
        while isHitboxActive do
            updateRealHitbox()  -- Continuously update the real hitbox part size
            wait(0.1)  -- Small delay to avoid locking up the game
        end
    else
        resetHitboxToDefault()  -- Reset only once when toggle is OFF
    end
end)

-- Initialize the toggle value to false at start (off state)
Toggle:SetValue(false)

-- Input for size (X, Y, Z) of the hitbox
local InputX = Tabs.tab2:AddInput("InputX", { 
    Title = "Hitbox (X)", 
    Description = "1-2048",
    Default = 1,
    Numeric = true,  -- Ensures only numbers can be entered
    Callback = function(Value)
        hitboxSizeX = tonumber(Value)  -- Convert input string to a number
        if isHitboxActive then
            updateRealHitbox()  -- Update the real hitbox size if the toggle is ON
        end
    end
})

local InputY = Tabs.tab2:AddInput("InputY", { 
    Title = "Hitbox (Y)", 
    Description = "1-2048",
    Default = 1,
    Numeric = true,  -- Ensures only numbers can be entered
    Callback = function(Value)
        hitboxSizeY = tonumber(Value)  -- Convert input string to a number
        if isHitboxActive then
            updateRealHitbox()  -- Update the real hitbox size if the toggle is ON
        end
    end
})

local InputZ = Tabs.tab2:AddInput("InputZ", { 
    Title = "Hitbox  (Z)", 
    Description = "1-2048",
    Default = 1,
    Numeric = true,  -- Ensures only numbers can be entered
    Callback = function(Value)
        hitboxSizeZ = tonumber(Value)  -- Convert input string to a number
        if isHitboxActive then
            updateRealHitbox()  -- Update the real hitbox size if the toggle is ON
        end
    end
})


-- Transparency Slider
local TransparencySlider = Tabs.tab2:AddSlider("TransparencySlider", { 
    Title = "Transparency", 
    Description = "",
    Default = 10,  -- Default slider value is 1, which maps to 0.1
    Min = 1,      -- Minimum value of 1 (which maps to 0.1 transparency)
    Max = 10,     -- Maximum value of 10 (which maps to 1 transparency)
    Rounding = 1, 
    Callback = function(Value)
        -- Scale the value from 1-10 to 0.1-1
        hitboxTransparency = Value * 0.1
        if isHitboxActive then
            updateRealHitbox()  -- Update transparency of the real hitbox part only if toggle is ON
        end
    end
})

TransparencySlider:SetValue(1)  -- Set default transparency value to 1 (which maps to 0.1)

-- Color picker for hitbox color
local Colorpicker = Tabs.tab2:AddColorpicker("Colorpicker", {
    Title = "Hitbox Color",
    Default = Color3.fromRGB(255, 255, 255)
})

Colorpicker:OnChanged(function()
    hitboxColor = Colorpicker.Value
    if isHitboxActive then
        updateRealHitbox()  -- Update color of the real hitbox part only if toggle is ON
    end
end)

-- Initialize variables
local kickSpeed = 50  -- Default value for kick speed
local verticalMoveAmount = 50  -- Default vertical move amount for the football
local controlEnabled = false  -- Default value for control toggle (off)
local player = game.Players.LocalPlayer
local humanoid
local humanoidRootPart
local junkFolder = game.Workspace:WaitForChild("Junk")  -- Folder where all footballs are stored
local UserInputService = game:GetService("UserInputService")  -- Correct service reference

-- Function to set up the humanoid and character variables
local function setupCharacter(character)
    humanoid = character:WaitForChild("Humanoid")
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    if controlEnabled then
        humanoid.WalkSpeed = 0
    else
        humanoid.WalkSpeed = 16
    end
end

-- Event listener for when the player's character is added (or respawns)
player.CharacterAdded:Connect(function(character)
    setupCharacter(character)
end)

-- Initialize the character on the first load (in case the player is already loaded in)
if player.Character then
    setupCharacter(player.Character)
end

-- Add a slider to control the kick speed
local Slider = Tabs.Main:AddInput("Slider", {
    Title = "Speed",
    Description = "20-1000",
    Default = 50,
    Min = 20,
    Max = 1000,
    Rounding = 1,
    Callback = function(Value)
        kickSpeed = Value  -- Update kickSpeed based on slider value
    end
})

-- Add a slider to control the vertical move amount for the ball
local VerticalSlider = Tabs.Main:AddInput("VerticalSlider", {
    Title = "up|down",
    Description = "20-600",
    Default = 50,  -- Default vertical move amount
    Min = 20,  -- Minimum move amount
    Max = 600,  -- Maximum move amount
    Rounding = 1,
    Callback = function(Value)
        verticalMoveAmount = Value  -- Update verticalMoveAmount based on slider value
    end
})

local function startControlLoop()
    controlCoroutine = coroutine.create(function()
        while controlEnabled do
            if humanoid then
                humanoid.WalkSpeed = 0
            end
            wait(0.01)  -- Short wait to prevent freezing
        end
    end)
    coroutine.resume(controlCoroutine)  -- Start the coroutine
end

-- Function to toggle controls
local function toggleControls()
    controlEnabled = not controlEnabled  -- Toggle controlEnabled state
    
    if controlEnabled then
        -- When controls are ON: Set WalkSpeed to 0 and start the control loop
        if humanoid then
            humanoid.WalkSpeed = 0
        end
        startControlLoop()
    else
        -- When controls are OFF: Restore normal movement by setting WalkSpeed to 16
        if humanoid then
            humanoid.WalkSpeed = 16
        end
        -- Stop the control loop by ending the coroutine
        controlCoroutine = nil
    end
end

-- Function to move the football up or down
local function moveFootballVertical(direction)
    if humanoidRootPart then
        -- Iterate through all "Football" parts in the Junk folder
        for _, football in pairs(junkFolder:GetChildren()) do
            if football.Name == "Football" then
                football.Anchored = false
                local bodyVelocity = Instance.new("BodyVelocity")
                -- Apply vertical movement force based on the slider value
                local moveAmount = direction == "up" and verticalMoveAmount or -verticalMoveAmount
                bodyVelocity.Velocity = Vector3.new(0, moveAmount, 0)  -- Only apply vertical force
                bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
                bodyVelocity.Parent = football
                game.Debris:AddItem(bodyVelocity, 0.1)
            end
        end
    else
        warn("HumanoidRootPart not found!")
    end
end

-- Function to kick the football in a specific direction
local function kickFootballInDirection(direction)
    if humanoidRootPart then
        local lookDirection
        if direction == "forward" then
            lookDirection = humanoidRootPart.CFrame.LookVector
        elseif direction == "backward" then
            lookDirection = -humanoidRootPart.CFrame.LookVector
        elseif direction == "left" then
            lookDirection = -humanoidRootPart.CFrame.RightVector
        elseif direction == "right" then
            lookDirection = humanoidRootPart.CFrame.RightVector
        end
        
        -- Iterate through all "Football" parts in the Junk folder
        for _, football in pairs(junkFolder:GetChildren()) do
            if football.Name == "Football" then
                football.Anchored = false
                local bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.Velocity = lookDirection * kickSpeed  -- Use kickSpeed from the slider
                bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
                bodyVelocity.Parent = football
                game.Debris:AddItem(bodyVelocity, 0.1)
            end
        end
    else
        warn("HumanoidRootPart not found!")
    end
end

-- Key bindings to kick the football in different directions using W, A, S, D
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if controlEnabled then  -- Only allow kicking if controls are enabled
        if input.KeyCode == Enum.KeyCode.W and not gameProcessed then
            kickFootballInDirection("forward")  -- Kick forward when "W" is pressed
        elseif input.KeyCode == Enum.KeyCode.S and not gameProcessed then
            kickFootballInDirection("backward")  -- Kick backward when "S" is pressed
        elseif input.KeyCode == Enum.KeyCode.A and not gameProcessed then
            kickFootballInDirection("left")  -- Kick left when "A" is pressed
        elseif input.KeyCode == Enum.KeyCode.D and not gameProcessed then
            kickFootballInDirection("right")  -- Kick right when "D" is pressed
        end
        
        -- Move the football up or down with X and Z keys
        if input.KeyCode == Enum.KeyCode.X and not gameProcessed then
            moveFootballVertical("up")  -- Move ball up when "X" is pressed
        elseif input.KeyCode == Enum.KeyCode.Z and not gameProcessed then
            moveFootballVertical("down")  -- Move ball down when "Z" is pressed
        end
    end
    
    -- Toggle controls when the "F" key is pressed
    if input.KeyCode == Enum.KeyCode.F and not gameProcessed then
        toggleControls()
    end
end)


InterfaceManager:SetLibrary(Fluent)
InterfaceManager:SetFolder("FluentScriptHub")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)

Window:SelectTab(3)








--TackleHitbox size 10, 38, 6
local function checkAndSetTackleHitboxSize(character)
    -- Czekamy na TackleHitbox w postaci gracza
    local hitbox = character:FindFirstChild("TackleHitbox")
    
    -- Sprawdzamy, czy hitbox istnieje
    if hitbox then
        -- Sprawdzamy, czy rozmiar hitboxu nie jest już równy (10, 38, 6)
        if hitbox.Size ~= Vector3.new(10, 38, 6) then
            -- Jeśli rozmiar jest inny, ustawiamy go na (10, 38, 6)
            hitbox.Size = Vector3.new(10, 38, 6)
        end
    end
end

-- Funkcja do ustawiania rozmiaru hitboxu przy każdym respawnie gracza
game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
    -- Czekamy na w pełni załadowaną postać, zanim zaczniemy manipulować
    local hitbox = character:WaitForChild("TackleHitbox")  -- Czekamy aż TackleHitbox będzie dostępny
    -- Po respawnie sprawdzamy i ustawiamy rozmiar TackleHitbox
    checkAndSetTackleHitboxSize(character)
end)

-- Pętla, która regularnie sprawdza i ustawia rozmiar TackleHitbox
local function loopCheckAndSetTackleHitboxSize()
    -- Pobieramy postać gracza
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()  -- Czekamy na postać, jeśli jeszcze nie istnieje

    -- Sprawdzamy rozmiar TackleHitbox w pętli
    while true do
        -- Sprawdzamy i ustawiamy rozmiar TackleHitbox na (10, 38, 6) jeśli jest potrzebne
        checkAndSetTackleHitboxSize(character)
        
        -- Czekamy 1 sekundę przed kolejną iteracją
        wait(0.5)
        
        -- Jeśli postać została zmieniona (np. po respawnie), zaktualizuj postać
        if not character.Parent then
            character = game.Players.LocalPlayer.CharacterAdded:Wait()
        end
    end
end

-- Rozpoczynamy pętlę sprawdzania i ustawiania rozmiaru hitboxu
loopCheckAndSetTackleHitboxSize()
