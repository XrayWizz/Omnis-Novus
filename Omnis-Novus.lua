-- Omnis-Novus Interface Overhaul Script
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")

-- Material You 3 Colors (Dark Theme)
local COLORS = {
    SURFACE = Color3.fromRGB(28, 27, 31),
    SURFACE_CONTAINER = Color3.fromRGB(35, 34, 38),
    ON_SURFACE = Color3.fromRGB(230, 225, 229),
    PRIMARY = Color3.fromRGB(208, 188, 255),
    ON_PRIMARY = Color3.fromRGB(55, 30, 115),
    OUTLINE = Color3.fromRGB(147, 143, 153),
    -- Health and Energy specific colors
    HEALTH_BAR = Color3.fromRGB(141, 255, 141),    -- Soft green
    HEALTH_CONTAINER = Color3.fromRGB(24, 39, 24), -- Dark green container
    ENERGY_BAR = Color3.fromRGB(79, 195, 247),     -- Soft blue
    ENERGY_CONTAINER = Color3.fromRGB(19, 29, 39)  -- Dark blue container
}

-- Function to create a modern status bar
local function createStatusBar(name, color, containerColor, parent)
    local barContainer = Instance.new("Frame")
    barContainer.Name = name .. "Container"
    barContainer.Size = UDim2.new(0, 300, 0, 12)
    barContainer.BackgroundColor3 = containerColor
    barContainer.BorderSizePixel = 0
    
    -- Add container corner rounding
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 6)
    containerCorner.Parent = barContainer
    
    -- Create the actual bar
    local bar = Instance.new("Frame")
    bar.Name = name .. "Bar"
    bar.Size = UDim2.new(1, 0, 1, 0)
    bar.BackgroundColor3 = color
    bar.BorderSizePixel = 0
    bar.Parent = barContainer
    
    -- Add bar corner rounding
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 6)
    barCorner.Parent = bar
    
    -- Add text label
    local label = Instance.new("TextLabel")
    label.Name = name .. "Text"
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextColor3 = COLORS.ON_SURFACE
    label.TextSize = 12
    label.Parent = barContainer
    
    -- Add subtle gradient
    local gradient = Instance.new("UIGradient")
    gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 0.1)
    })
    gradient.Rotation = 90
    gradient.Parent = bar
    
    -- Add glow effect
    local glow = Instance.new("ImageLabel")
    glow.Name = "Glow"
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://7668647110"
    glow.ImageColor3 = color
    glow.ImageTransparency = 0.85
    glow.Size = UDim2.new(1, 20, 1, 20)
    glow.Position = UDim2.new(0, -10, 0, -10)
    glow.ZIndex = 0
    glow.Parent = barContainer
    
    return barContainer, bar, label
end

-- Function to update the status bars
local function updateStatusBar(bar, label, current, max)
    local percentage = current / max
    TweenService:Create(bar, TweenInfo.new(0.3), {
        Size = UDim2.new(percentage, 0, 1, 0)
    }):Play()
    label.Text = string.format("%d/%d", current, max)
end

-- Function to hide default health bar
local function hideDefaultHealthBar()
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health, false)
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
    
    -- Create main HUD container
    local hudGui = Instance.new("ScreenGui")
    hudGui.Name = "ModernHUD"
    hudGui.ResetOnSpawn = false
    
    -- Create status bars container
    local statusContainer = Instance.new("Frame")
    statusContainer.Name = "StatusContainer"
    statusContainer.Size = UDim2.new(0, 300, 0, 50)
    statusContainer.Position = UDim2.new(0.5, -150, 1, -80)
    statusContainer.BackgroundTransparency = 1
    statusContainer.Parent = hudGui
    
    -- Create health and energy bars
    local healthContainer, healthBar, healthLabel = createStatusBar(
        "Health",
        COLORS.HEALTH_BAR,
        COLORS.HEALTH_CONTAINER,
        statusContainer
    )
    healthContainer.Position = UDim2.new(0, 0, 0, 0)
    healthContainer.Parent = statusContainer
    
    local energyContainer, energyBar, energyLabel = createStatusBar(
        "Energy",
        COLORS.ENERGY_BAR,
        COLORS.ENERGY_CONTAINER,
        statusContainer
    )
    energyContainer.Position = UDim2.new(0, 0, 0, 20)
    energyContainer.Parent = statusContainer
    
    -- Add container for status effects/buffs above the bars
    local buffContainer = Instance.new("Frame")
    buffContainer.Name = "BuffContainer"
    buffContainer.Size = UDim2.new(1, 0, 0, 30)
    buffContainer.Position = UDim2.new(0, 0, 0, -40)
    buffContainer.BackgroundTransparency = 1
    buffContainer.Parent = statusContainer
    
    -- Add list layout for buff icons
    local listLayout = Instance.new("UIListLayout")
    listLayout.FillDirection = Enum.FillDirection.Horizontal
    listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    listLayout.Padding = UDim.new(0, 5)
    listLayout.Parent = buffContainer
    
    hudGui.Parent = playerGui
    
    -- Return the components that need to be updated
    return {
        healthBar = healthBar,
        healthLabel = healthLabel,
        energyBar = energyBar,
        energyLabel = energyLabel,
        buffContainer = buffContainer
    }
end

-- Function to update HUD with player stats
local function updateHUD(components, health, maxHealth, energy, maxEnergy)
    updateStatusBar(components.healthBar, components.healthLabel, health, maxHealth)
    updateStatusBar(components.energyBar, components.energyLabel, energy, maxEnergy)
end

-- Function to initialize the modern interface
local function initModernInterface()
    local player = Players.LocalPlayer
    if not player then return end
    
    -- Hide default health bar
    hideDefaultHealthBar()
    
    -- Remove existing HUD elements if they exist
    local existingHUD = player.PlayerGui:FindFirstChild("ModernHUD")
    if existingHUD then
        existingHUD:Destroy()
    end
    
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
            -- Disconnect if character is not available
            heartbeatConnection:Disconnect()
            -- Reconnect when character is available
            player.CharacterAdded:Wait()
            heartbeatConnection = RunService.Heartbeat:Connect(updateStats)
        end
    end)
    
    -- Handle character changes
    player.CharacterAdded:Connect(function()
        wait(0.1) -- Short delay to ensure character is fully loaded
        updateStats()
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
