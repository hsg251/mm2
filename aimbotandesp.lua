local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local workspace = game:GetService("Workspace")

-- Tạo HUD (Thanhdan Hub)
local function createHUD()
    local screenGui = Instance.new("ScreenGui", LocalPlayer:FindFirstChild("PlayerGui"))
    screenGui.Name = "ThanhdanHub"

    local textLabel = Instance.new("TextLabel", screenGui)
    textLabel.Size = UDim2.new(0, 200, 0, 50)
    textLabel.Position = UDim2.new(0, 10, 0, 10)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "thanhdan Hub"
    textLabel.TextColor3 = Color3.new(1, 1, 1) -- Màu trắng mặc định
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextScaled = true

    -- Đổi màu liên tục
    local colors = {Color3.new(1, 0, 0), Color3.new(0, 1, 0), Color3.new(0, 0, 1)} -- Đỏ, Xanh lá, Xanh dương
    task.spawn(function()
        while true do
            for _, color in ipairs(colors) do
                textLabel.TextColor3 = color
                task.wait(1) -- 1 giây đổi màu
            end
        end
    end)
end

-- ESP cơ bản cho Murderer, Sheriff, và Gun
local function createESPLabel(obj, color, text)
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "ESP"
    billboardGui.Adornee = obj
    billboardGui.Size = UDim2.new(2, 0, 1, 0)
    billboardGui.StudsOffset = Vector3.new(0, 2, 0)
    billboardGui.AlwaysOnTop = true

    local textLabel = Instance.new("TextLabel", billboardGui)
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = color
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.SourceSansBold

    billboardGui.Parent = obj
end

-- Tìm vai trò và súng
local function findRoles()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local char = player.Character
            if char:FindFirstChild("Gun") then
                createESPLabel(char.HumanoidRootPart, Color3.new(0, 0, 1), "Sheriff")
            elseif char:FindFirstChild("Knife") then
                createESPLabel(char.HumanoidRootPart, Color3.new(1, 0, 0), "Murderer")
            end
        end
    end
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Tool") and obj.Name == "Gun" then
            createESPLabel(obj, Color3.new(0, 1, 0), "Gun")
        end
    end
end

-- Hàm tìm kẻ thù gần nhất (chỉ nhắm vào Murderer nếu bạn là Sheriff)
local function getClosestEnemy()
    local closestEnemy = nil
    local closestDistance = math.huge  -- Khoảng cách lớn nhất ban đầu
    local myPosition = LocalPlayer.Character.HumanoidRootPart.Position
    local camera = workspace.CurrentCamera
    local isSheriff = LocalPlayer.Character:FindFirstChild("Gun")  -- Kiểm tra nếu bạn là Sheriff
    
    -- Lặp qua tất cả người chơi để tìm kẻ thù gần nhất
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local character = player.Character
            local role = character:FindFirstChild("Role")  -- Xác định vai trò của người chơi
            local isMurderer = role and role.Value == "Murderer"  -- Vai trò Murderer
            
            -- Nếu bạn là Sheriff, chỉ nhắm vào Murderer
            if isSheriff and isMurderer then
                local enemyPosition = character.HumanoidRootPart.Position
                local distance = (myPosition - enemyPosition).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestEnemy = character
                end
            end
        end
    end
    return closestEnemy
end

-- Hàm Aimbot
local function aimbot()
    local closestEnemy = getClosestEnemy()
    if closestEnemy then
        local targetPosition = closestEnemy.HumanoidRootPart.Position
        local camera = workspace.CurrentCamera
        local cameraToTarget = (targetPosition - camera.CFrame.p).unit
        -- Tự động nhắm vào mục tiêu
        camera.CFrame = CFrame.new(camera.CFrame.p, camera.CFrame.p + cameraToTarget)
    end
end

-- Thực thi các chức năng mỗi giây
task.spawn(function()
    while true do
        findRoles()  -- Quét vai trò và súng
        aimbot()  -- Thực hiện aimbot
        task.wait(1)  -- Cập nhật mỗi 1 giây
    end
end)

-- Tạo HUD
createHUD()
