-- Omnis-Novus Interface Overhaul Script
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")

-- Script Version
local VERSION = "v1.0.0"

-- Material You 3 Colors (Dark Theme)
local COLORS = {
    SURFACE = Color3.fromRGB(28, 27, 31),
    SURFACE_CONTAINER = Color3.fromRGB(35, 34, 38),
    ON_SURFACE = Color3.fromRGB(230, 225, 229),
    PRIMARY = Color3.fromRGB(208, 188, 255),
    ON_PRIMARY = Color3.fromRGB(55, 30, 115),
    OUTLINE = Color3.fromRGB(147, 143, 153),
    -- Health and Energy specific colors (darker versions)
    HEALTH_BAR = Color3.fromRGB(39, 174, 96),      -- Darker emerald green
    HEALTH_CONTAINER = Color3.fromRGB(20, 83, 45), -- Very dark green container
    ENERGY_BAR = Color3.fromRGB(41, 128, 185),     -- Darker blue
    ENERGY_CONTAINER = Color3.fromRGB(19, 62, 89)  -- Very dark blue container
}

-- Function to create a modern status bar
local function createStatusBar(name, color, containerColor, parent)
    local barContainer = Instance.new("Frame")
    barContainer.Name = name .. "Container"
    barContainer.Size = UDim2.new(0, 300, 0, 12)
    barContainer.BackgroundColor3 = COLORS.SURFACE
    barContainer.BorderSizePixel = 0
    
    -- Add outer dark edge (new)
    local outerEdge = Instance.new("Frame")
    outerEdge.Name = "OuterEdge"
    outerEdge.Size = UDim2.new(1, 8, 1, 8)
    outerEdge.Position = UDim2.new(0, -4, 0, -4)
    outerEdge.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    outerEdge.BorderSizePixel = 0
    outerEdge.ZIndex = -2
    outerEdge.Parent = barContainer
    
    -- Add corner rounding to outer edge
    local outerEdgeCorner = Instance.new("UICorner")
    outerEdgeCorner.CornerRadius = UDim.new(0, 10)
    outerEdgeCorner.Parent = outerEdge
    
    -- Add dark edge container (inner)
    local darkEdge = Instance.new("Frame")
    darkEdge.Name = "DarkEdge"
    darkEdge.Size = UDim2.new(1, 4, 1, 4)
    darkEdge.Position = UDim2.new(0, -2, 0, -2)
    darkEdge.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    darkEdge.BorderSizePixel = 0
    darkEdge.ZIndex = -1
    darkEdge.Parent = barContainer
    
    -- Add corner rounding to dark edge
    local darkEdgeCorner = Instance.new("UICorner")
    darkEdgeCorner.CornerRadius = UDim.new(0, 8)
    darkEdgeCorner.Parent = darkEdge
    
    -- Add shadow effect (new)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://7668647110"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.7
    shadow.Size = UDim2.new(1, 12, 1, 12)
    shadow.Position = UDim2.new(0, -6, 0, -6)
    shadow.ZIndex = -3
    shadow.Parent = barContainer
    
    -- Add container corner rounding
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 6)
    containerCorner.Parent = barContainer
    
    -- Create the background container
    local backgroundContainer = Instance.new("Frame")
    backgroundContainer.Name = "Background"
    backgroundContainer.Size = UDim2.new(1, 0, 1, 0)
    backgroundContainer.BackgroundColor3 = containerColor
    backgroundContainer.BorderSizePixel = 0
    backgroundContainer.Parent = barContainer
    
    -- Add corner rounding to background
    local backgroundCorner = Instance.new("UICorner")
    backgroundCorner.CornerRadius = UDim.new(0, 6)
    backgroundCorner.Parent = backgroundContainer
    
    -- Create the actual bar
    local bar = Instance.new("Frame")
    bar.Name = name .. "Bar"
    bar.Size = UDim2.new(1, 0, 1, 0)
    bar.BackgroundColor3 = color
    bar.BorderSizePixel = 0
    bar.Parent = backgroundContainer
    
    -- Add bar corner rounding
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 6)
    barCorner.Parent = bar
    
    -- Add value label (percentage)
    local percentLabel = Instance.new("TextLabel")
    percentLabel.Name = name .. "Percent"
    percentLabel.Size = UDim2.new(0, 45, 1, 0)
    percentLabel.Position = UDim2.new(1, 10, 0, 0)
    percentLabel.BackgroundTransparency = 1
    percentLabel.Font = Enum.Font.GothamBold
    percentLabel.TextColor3 = color
    percentLabel.TextSize = 12
    percentLabel.Text = "100%"
    percentLabel.TextStrokeTransparency = 0.5
    percentLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    percentLabel.Parent = barContainer
    
    -- Add text label
    local label = Instance.new("TextLabel")
    label.Name = name .. "Text"
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextColor3 = COLORS.ON_SURFACE
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.TextStrokeTransparency = 0.5
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.Parent = barContainer

    -- Create a stroke effect for better visibility
    local textStroke = Instance.new("UIStroke")
    textStroke.Color = Color3.fromRGB(0, 0, 0)
    textStroke.Thickness = 1
    textStroke.Parent = label

    local percentStroke = textStroke:Clone()
    percentStroke.Parent = percentLabel
    
    -- Add subtle gradient
    local gradient = Instance.new("UIGradient")
    gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 0.1)
    })
    gradient.Rotation = 90
    gradient.Parent = bar
    
    return barContainer, bar, label, percentLabel
end

-- Function to update the status bars
local function updateHUD(components, health, maxHealth, energy, maxEnergy)
    local function updateBar(bar, label, percentLabel, current, max)
        local percentage = current / max
        TweenService:Create(bar, TweenInfo.new(0.3), {
            Size = UDim2.new(percentage, 0, 1, 0)
        }):Play()
        label.Text = string.format("%d/%d", current, max)
        percentLabel.Text = string.format("%d%%", math.floor(percentage * 100))
    end
    
    updateBar(components.healthBar, components.healthLabel, components.healthPercent, health, maxHealth)
    updateBar(components.energyBar, components.energyLabel, components.energyPercent, energy, maxEnergy)
end

-- Function to hide default health bar and Bloxfruit GUI elements
local function hideExistingGUI()
    -- Hide default Roblox health bar
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health, false)
    
    -- Get player GUI
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    
    -- Function to hide GUI element
    local function hideElement(element)
        if element and element.Name ~= "ModernHUD" then  -- Don't hide our UI
            if element:IsA("Frame") or element:IsA("ImageLabel") then
                element.Visible = false
            end
        end
    end
    
    -- Function to search and hide health/energy related GUI
    local function findAndHideGUI()
        -- Look through all ScreenGuis
        for _, gui in ipairs(playerGui:GetChildren()) do
            if gui:IsA("ScreenGui") and gui.Name ~= "ModernHUD" then  -- Don't process our UI
                -- Search for common health/energy bar names and patterns
                local elementsToHide = {
                    gui:FindFirstChild("Health", true),
                    gui:FindFirstChild("HealthBar", true),
                    gui:FindFirstChild("HPBar", true),
                    gui:FindFirstChild("Energy", true),
                    gui:FindFirstChild("EnergyBar", true),
                    gui:FindFirstChild("StaminaBar", true),
                    gui:FindFirstChild("HP", true),
                    gui:FindFirstChild("Stamina", true),
                    gui:FindFirstChild("Stats", true)
                }
                
                -- Hide each found element
                for _, element in ipairs(elementsToHide) do
                    hideElement(element)
                end
                
                -- Try to find bars by their properties
                for _, descendant in ipairs(gui:GetDescendants()) do
                    if descendant:IsA("Frame") or descendant:IsA("ImageLabel") then
                        local name = descendant.Name:lower()
                        if (name:match("health") or name:match("hp") or 
                            name:match("energy") or name:match("stamina")) and
                           descendant:IsDescendantOf(gui) then
                            hideElement(descendant)
                        end
                    end
                end
            end
        end
    end
    
    -- Initial hide
    findAndHideGUI()
    
    -- Watch for new GUI elements and keep our UI visible
    playerGui.ChildAdded:Connect(function(child)
        if child:IsA("ScreenGui") and child.Name ~= "ModernHUD" then
            wait(0.1) -- Short delay to ensure GUI is fully loaded
            findAndHideGUI()
        end
    end)
    
    -- Keep checking periodically to ensure game UI stays hidden
    spawn(function()
        while wait(1) do
            findAndHideGUI()
        end
    end)
end

-- Function to get player stats
local function getPlayerStats(player)
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    
    -- Get values from the game
    local health = humanoid.Health
    local maxHealth = humanoid.MaxHealth
    
    -- Try to get energy values from different possible sources
    local energy, maxEnergy = 15595, 15595 -- Default values
    
    -- Check for energy in different possible locations
    local possibleEnergyPaths = {
        character:FindFirstChild("Energy"),
        character:FindFirstChild("Stamina"),
        player:FindFirstChild("Energy"),
        player:FindFirstChild("Stamina")
    }
    
    for _, value in ipairs(possibleEnergyPaths) do
        if value and value:IsA("NumberValue") then
            energy = value.Value
            maxEnergy = value.MaxValue or energy
            break
        end
    end
    
    return health, maxHealth, energy, maxEnergy
end

-- Function to create the modern HUD
local function createModernHUD()
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    
    -- Remove existing ModernHUD if it exists
    local existingHUD = player.PlayerGui:FindFirstChild("ModernHUD")
    if existingHUD then
        existingHUD:Destroy()
    end
    
    -- Create main HUD container
    local hudGui = Instance.new("ScreenGui")
    hudGui.Name = "ModernHUD"
    hudGui.ResetOnSpawn = false
    hudGui.DisplayOrder = 999999  -- Ensure our UI stays on top
    hudGui.IgnoreGuiInset = true  -- Prevent GUI from being affected by safe areas
    
    -- Create status bars container
    local statusContainer = Instance.new("Frame")
    statusContainer.Name = "StatusContainer"
    statusContainer.Size = UDim2.new(0, 300, 0, 50)
    statusContainer.Position = UDim2.new(0.5, -150, 0.425, 0)  -- Adjusted to match original Bloxfruit UI position
    statusContainer.BackgroundTransparency = 1
    statusContainer.Parent = hudGui
    
    -- Create energy bar first (so it's behind health bar)
    local energyContainer, energyBar, energyLabel, energyPercent = createStatusBar(
        "Energy",
        COLORS.ENERGY_BAR,
        COLORS.ENERGY_CONTAINER,
        statusContainer
    )
    energyContainer.Position = UDim2.new(0, 0, 0, 32) -- Adjusted to be slightly lower (was 28)
    energyContainer.Parent = statusContainer
    
    -- Create health bar second (so it's in front)
    local healthContainer, healthBar, healthLabel, healthPercent = createStatusBar(
        "Health",
        COLORS.HEALTH_BAR,
        COLORS.HEALTH_CONTAINER,
        statusContainer
    )
    healthContainer.Position = UDim2.new(0, 0, 0, 20)
    healthContainer.Parent = statusContainer
    
    -- Adjust ZIndex to ensure proper layering
    healthContainer.ZIndex = 2
    for _, child in pairs(healthContainer:GetDescendants()) do
        if child:IsA("GuiObject") then
            child.ZIndex = child.ZIndex + 2
        end
    end
    
    hudGui.Parent = playerGui
    
    -- Return the components that need to be updated
    return {
        healthBar = healthBar,
        healthLabel = healthLabel,
        healthPercent = healthPercent,
        energyBar = energyBar,
        energyLabel = energyLabel,
        energyPercent = energyPercent
    }
end

-- Function to initialize the modern interface
local function initModernInterface()
    local player = Players.LocalPlayer
    if not player then return end
    
    -- Hide existing GUI elements first
    hideExistingGUI()
    
    -- Create our modern HUD
    local components = createModernHUD()
    
    -- Function to update stats using heartbeat
    local function updateStats()
        local health, maxHealth, energy, maxEnergy = getPlayerStats(player)
        updateHUD(components, health, maxHealth, energy, maxEnergy)
    end
    
    -- Connect to RunService.Heartbeat for live updates
    local heartbeatConnection
    heartbeatConnection = RunService.Heartbeat:Connect(function()
        if player.Character then
            updateStats()
        else
            heartbeatConnection:Disconnect()
            player.CharacterAdded:Wait()
            heartbeatConnection = RunService.Heartbeat:Connect(updateStats)
        end
    end)
    
    -- Handle character changes
    player.CharacterAdded:Connect(function()
        wait(0.1)
        updateStats()
        -- Ensure game UI is still hidden after character respawn
        hideExistingGUI()
    end)
end

-- Show the confirmation prompt (original style)
local function showConfirmationPrompt()
    local bindable = Instance.new("BindableFunction")
    
    function bindable.OnInvoke(response)
        if response == "Yes" then
            -- Initialize the modern interface
            initModernInterface()
            print("Starting interface overhaul...")
        else
            print("Script cancelled by user")
        end
    end

    StarterGui:SetCore("SendNotification", {
        Title = "Omnis-Novus",
        Text = "Are you sure you want to run this script?",
        Duration = 10,
        Callback = bindable,
        Button1 = "Yes",
        Button2 = "No"
    })
end

-- Function to initialize everything
local function init()
    local player = Players.LocalPlayer
    if player then
        showConfirmationPrompt()
    end
end

-- Run the initialization
init()
