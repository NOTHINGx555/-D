warn ("start")
--delete  and set color stamina and power
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Referencje do GameGui
local gameGui = playerGui:FindFirstChild("GameGui")
if not gameGui then
    warn("GameGui not found")
    return
end

-- Funkcja do usuwania ekranów
local function deleteScreen(screen)
    if screen then
        screen:Destroy()
        print(screen.Name .. " deleted")
    else
        warn("-")
    end
end

-- Usuwanie Transition, KeyHints
deleteScreen(gameGui:FindFirstChild("Transition"))
deleteScreen(gameGui:FindFirstChild("KeyHints"))

-- Referencje do MatchHUD i EnergyBars
local matchHUD = gameGui:FindFirstChild("MatchHUD")
if not matchHUD then
    warn("MatchHUD not found")
    return
end

local energyBars = matchHUD:FindFirstChild("EngergyBars")
if not energyBars then
    warn("EnergyBars not found")
    return
end

-- Funkcja do ustawiania gradientu
local function setGradient(frame, startColor, endColor)
    if frame then
        local progressBar = frame:FindFirstChild("ProgressBar")
        if progressBar then
            local existingGradient = progressBar:FindFirstChild("UIGradient")
            if existingGradient then
                existingGradient:Destroy()
            end
            local newGradient = Instance.new("UIGradient")
            newGradient.Color = ColorSequence.new(startColor, endColor)
            newGradient.Rotation = 90
            newGradient.Parent = progressBar
            print("Set Color " .. frame.Name)
        else
            warn(frame.Name .. " ProgressBar not found")
        end
    else
        warn(frame.Name .. " not found")
    end
end

-- Ustawienie gradientu dla Power i Stamina
setGradient(energyBars:FindFirstChild("Power"), Color3.new(0, 0, 0), Color3.new(1, 0, 0)) -- Black to Red
setGradient(energyBars:FindFirstChild("Stamina"), Color3.new(0, 0, 0), Color3.new(1, 1, 1)) -- Black to White


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
local function teleportBall(targetPosition, scoringTeam)
    local ball = findBall()
    if ball then
        ball.Position = targetPosition

        if scoringTeam == "Home" then
            print("Home")
        elseif scoringTeam == "Away" then
            print("Away")
        end

        local remoteEvent = replicatedStorage:FindFirstChild(UNIQUE_EVENT_NAME)
        if remoteEvent then
            remoteEvent:FireServer(targetPosition)
        end
    else
        print("Ball not found")
    end
end

-- Function to get the target position based on the player's team
local function getTargetPosition()
    if player.Team and player.Team.Name == "Home" then
        return Vector3.new(2.010676682, 4.00001144, -186.170898), "Home" -- Home team's coordinates
    elseif player.Team and player.Team.Name == "Away" then
        return Vector3.new(-0.214612424, 4.00001144, 186.203613), "Away" -- Away team's coordinates
    else
        print("NONE")
    end
    return nil, nil
end

-- Update character reference when it changes (e.g., after reset)
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
end)

-- Event listener for key press
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.G and not gameProcessed then
        local targetPosition, scoringTeam = getTargetPosition()
        if targetPosition then
            teleportBall(targetPosition, scoringTeam)
        end
    end
end)


--ball track
local function checkAndSetTackleHitboxSize(hitbox)
    -- Sprawdzamy, czy rozmiar hitboxu nie jest już równy (10, 38, 6)
    if hitbox.Size ~= Vector3.new(10, 38, 6) then
        -- Jeśli rozmiar jest inny, ustawiamy go na (10, 38, 6)
        hitbox.Size = Vector3.new(10, 38, 6)
    end
end

-- Funkcja do obsługi postaci gracza
local function onCharacterAdded(character)
    -- Czekamy na obiekt TackleHitbox w postaci gracza
    local hitbox = character:WaitForChild("TackleHitbox", 5)  -- Timeout 5 sekund dla bezpieczeństwa
    
    if hitbox then
        -- Ustawiamy poprawny rozmiar hitboxu
        checkAndSetTackleHitboxSize(hitbox)
        
        -- Obserwujemy zmiany rozmiaru i automatycznie poprawiamy je, jeśli zajdzie potrzeba
        hitbox:GetPropertyChangedSignal("Size"):Connect(function()
            checkAndSetTackleHitboxSize(hitbox)
        end)
    end
end

-- Podpinamy obsługę zdarzenia do LocalPlayer
local player = game.Players.LocalPlayer
player.CharacterAdded:Connect(onCharacterAdded)

-- Jeśli postać już istnieje, obsługujemy ją od razu
if player.Character then
    onCharacterAdded(player.Character)
end






--tp ball and hig
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local movementAndSpeedEnabled = false
local hipHeightEnabled = false

local Player = Players.LocalPlayer

-- Function to toggle the hip height of the humanoid
local function toggleHipHeight()
    local character = Player.Character
    if character then
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
end

-- Function to toggle the movement and speed script
local function toggleMovementAndSpeed()
    movementAndSpeedEnabled = not movementAndSpeedEnabled
    toggleHipHeight()
end

-- Function to move specific parts to the player's position
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

-- Connect keybinds and events
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.H then
        toggleMovementAndSpeed()
    elseif input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
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

warn ("beta v2 speed load")
--beta speed 
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Prędkość bazowa
local defaultSpeed = humanoid.WalkSpeed

-- Boost prędkości
local boostSpeed = 250 -- Zmienna dla boosta
local boostDuration = 0.3 -- Czas trwania boosta w sekundach
local waitTime = 0.7 -- Czas oczekiwania przed aktywacją boosta

-- Zmienna do zapobiegania spamowi
local canActivateBoost = true

-- Funkcja do aktywowania boosta
local function activateBoost()
    if canActivateBoost then
        canActivateBoost = false -- Zablokuj kolejne aktywacje
        wait(waitTime) -- Czeka przed aktywacją boosta
        humanoid.WalkSpeed = boostSpeed
        wait(boostDuration)
        humanoid.WalkSpeed = defaultSpeed
        wait(waitTime) -- Czeka przed ponowną aktywacją
        canActivateBoost = true -- Pozwól na kolejną aktywację
    end
end

-- Przykład aktywacji boosta po kliknięciu
local userInputService = game:GetService("UserInputService")

userInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.F then
            activateBoost()
        end
    end
end)







--gui
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- Create window
local Window = Fluent:CreateWindow({
    Title = "FR",
    SubTitle = "",
    TabWidth = 150,
    Size = UDim2.fromOffset(550, 450),
    Acrylic = false,
    Theme = "Light",
    MinimizeKey = Enum.KeyCode.LeftAlt
})

-- Add tabs
local Tabs = {
    tab2 = Window:AddTab({ Title = "Custom Hitbox", Icon = "play" }),
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




InterfaceManager:SetLibrary(Fluent)
InterfaceManager:SetFolder("FluentScriptHub")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)

Window:SelectTab(1)

warn ("end")
