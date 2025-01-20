-- Variables
local players = game:GetService("Players")
local runService = game:GetService("RunService")
local localPlayer = players.LocalPlayer
local mouse = localPlayer:GetMouse()

-- Settings
local circleSize = 100 -- Default circle size
local isAimLocked = false
local lockedPlayer = nil

-- Create circle
local circle = Drawing.new("Circle")
circle.Color = Color3.fromRGB(255, 0, 0)
circle.Thickness = 2
circle.Filled = false
circle.Transparency = 1

-- GUI for customization
local gui = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", gui)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.Size = UDim2.new(0, 200, 0, 120)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0

-- Add title label
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(0, 200, 0, 20)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "ThanhDan Hub"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.BorderSizePixel = 0
title.TextScaled = true

local slider = Instance.new("TextBox", frame)
slider.Size = UDim2.new(0, 180, 0, 30)
slider.Position = UDim2.new(0, 10, 0, 30)
slider.Text = tostring(circleSize)
slider.TextColor3 = Color3.fromRGB(255, 255, 255)
slider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
slider.BorderSizePixel = 0

local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(0, 180, 0, 30)
button.Position = UDim2.new(0, 10, 0, 70)
button.Text = "Apply"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
button.BorderSizePixel = 0

-- Update circle size
button.MouseButton1Click:Connect(function()
    local size = tonumber(slider.Text)
    if size and size > 0 then
        circleSize = size
    end
end)

-- Function to find closest player
local function getClosestPlayer()
    local closest = nil
    local shortestDistance = circleSize

    for _, player in ipairs(players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            -- Convert 3D position to 2D screen position
            local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if onScreen then
                local distance = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                if distance < shortestDistance then
                    closest = player
                    shortestDistance = distance
                end
            end
        end
    end
    return closest
end

-- Update loop
runService.RenderStepped:Connect(function()
    -- Update circle position (centered on mouse)
    circle.Position = Vector2.new(mouse.X, mouse.Y) - Vector2.new(circle.Radius, circle.Radius)
    circle.Radius = circleSize

    if isAimLocked and lockedPlayer and lockedPlayer.Character and lockedPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local lockPosition, onScreen = workspace.CurrentCamera:WorldToViewportPoint(lockedPlayer.Character.HumanoidRootPart.Position)
        if onScreen then
            mouse.Move = Vector2.new(lockPosition.X, lockPosition.Y)
        end
    end
end)

-- Mouse key listener
mouse.KeyDown:Connect(function(key)
    if key == "q" then -- Press Q to toggle aim lock
        isAimLocked = not isAimLocked
        if isAimLocked then
            lockedPlayer = getClosestPlayer()
        else
            lockedPlayer = nil
        end
    end
end)
