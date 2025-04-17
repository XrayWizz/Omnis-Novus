-- Omnis-Novus Interface Overhaul Script
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

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
    
    local components = createModernHUD()
    
    -- Example update (replace with actual game values)
    local function updateStats()
        -- Get the actual values from your game
        local health = 13750  -- Example value from the image
        local maxHealth = 13750
        local energy = 15595  -- Example value from the image
        local maxEnergy = 15595
        
        updateHUD(components, health, maxHealth, energy, maxEnergy)
    end
    
    -- Update stats periodically
    spawn(function()
        while wait(0.1) do
            updateStats()
        end
    end)
end

-- Initialize when the player is ready
Players.PlayerAdded:Connect(initModernInterface)
if Players.LocalPlayer then
    initModernInterface()
end

-- Create Material You 3 styled confirmation dialog
local function createMaterialDialog()
    local gui = Instance.new("ScreenGui")
    gui.Name = "OmnisNovusDialog"
    gui.ResetOnSpawn = false
    
    -- Background overlay
    local overlay = Instance.new("Frame")
    overlay.Name = "Overlay"
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.5
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.Parent = gui
    
    -- Dialog container
    local dialog = Instance.new("Frame")
    dialog.Name = "Dialog"
    dialog.Size = UDim2.new(0, 300, 0, 180)
    dialog.Position = UDim2.new(0.5, -150, 0.5, -90)
    dialog.BackgroundColor3 = COLORS.SURFACE_CONTAINER
    dialog.Parent = overlay
    
    -- Add rounded corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 16)
    corner.Parent = dialog
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -40, 0, 40)
    title.Position = UDim2.new(0, 20, 0, 20)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 24
    title.TextColor3 = COLORS.ON_SURFACE
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Text = "Omnis-Novus"
    title.Parent = dialog
    
    -- Message
    local message = Instance.new("TextLabel")
    message.Name = "Message"
    message.Size = UDim2.new(1, -40, 0, 40)
    message.Position = UDim2.new(0, 20, 0, 60)
    message.BackgroundTransparency = 1
    message.Font = Enum.Font.Gotham
    message.TextSize = 16
    message.TextColor3 = COLORS.ON_SURFACE
    message.TextXAlignment = Enum.TextXAlignment.Left
    message.Text = "Are you sure you want to run this script?"
    message.Parent = dialog
    
    -- Buttons container
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Name = "ButtonContainer"
    buttonContainer.Size = UDim2.new(1, -40, 0, 40)
    buttonContainer.Position = UDim2.new(0, 20, 1, -60)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Parent = dialog
    
    -- Create button function
    local function createButton(name, position, isPrimary)
        local button = Instance.new("TextButton")
        button.Name = name
        button.Size = UDim2.new(0, 100, 1, 0)
        button.Position = position
        button.BackgroundColor3 = isPrimary and COLORS.PRIMARY or COLORS.SURFACE
        button.TextColor3 = isPrimary and COLORS.ON_PRIMARY or COLORS.PRIMARY
        button.Font = Enum.Font.GothamBold
        button.TextSize = 14
        button.Text = name
        button.Parent = buttonContainer
        
        -- Add rounded corners to button
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 8)
        buttonCorner.Parent = button
        
        -- Add hover effect
        button.MouseEnter:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundTransparency = 0.1
            }):Play()
        end)
        
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundTransparency = 0
            }):Play()
        end)
        
        return button
    end
    
    -- Create Yes and No buttons
    local noButton = createButton("No", UDim2.new(1, -100, 0, 0), false)
    local yesButton = createButton("Yes", UDim2.new(1, -220, 0, 0), true)
    
    -- Add shadow
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.Size = UDim2.new(1, 40, 1, 40)
    shadow.ZIndex = -1
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.8
    shadow.Parent = dialog
    
    -- Add entrance animation
    dialog.Size = UDim2.new(0, 300, 0, 0)
    dialog.Position = UDim2.new(0.5, -150, 0.5, 0)
    overlay.BackgroundTransparency = 1
    
    TweenService:Create(overlay, TweenInfo.new(0.3), {
        BackgroundTransparency = 0.5
    }):Play()
    
    TweenService:Create(dialog, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 300, 0, 180),
        Position = UDim2.new(0.5, -150, 0.5, -90)
    }):Play()
    
    return gui, yesButton, noButton
end

-- Show the dialog and handle responses
local function showConfirmationDialog()
    local dialog, yesButton, noButton = createMaterialDialog()
    dialog.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    
    local function cleanup()
        local overlay = dialog.Overlay
        local dialogFrame = overlay.Dialog
        
        -- Exit animation
        TweenService:Create(overlay, TweenInfo.new(0.2), {
            BackgroundTransparency = 1
        }):Play()
        
        TweenService:Create(dialogFrame, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 300, 0, 0),
            Position = UDim2.new(0.5, -150, 0.5, 0)
        }).Completed:Connect(function()
            dialog:Destroy()
        end)
    end
    
    -- Handle button clicks
    yesButton.MouseButton1Click:Connect(function()
        cleanup()
        -- Place for the interface overhaul code
        print("Starting interface overhaul...") -- Placeholder
        -- TODO: Add your interface modification code here
    end)
    
    noButton.MouseButton1Click:Connect(function()
        cleanup()
        print("Script cancelled by user")
    end)
end

-- Function to initialize the script
local function init()
    local player = Players.LocalPlayer
    if player then
        showConfirmationDialog()
    end
end

-- Run the initialization
init()
