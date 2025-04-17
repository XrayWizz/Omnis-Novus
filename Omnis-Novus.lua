-- Omnis-Novus Interface Overhaul Script
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

-- Create the confirmation prompt
local function showConfirmationPrompt()
    local bindable = Instance.new("BindableFunction")
    
    function bindable.OnInvoke(response)
        if response == "Yes" then
            -- Place for the interface overhaul code
            print("Starting interface overhaul...") -- Placeholder
            -- TODO: Add your interface modification code here
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

-- Function to initialize the script
local function init()
    local player = Players.LocalPlayer
    if player then
        showConfirmationPrompt()
    end
end

-- Run the initialization
init()

