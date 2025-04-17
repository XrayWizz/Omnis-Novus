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
}

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
