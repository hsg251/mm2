local TweenService = game:GetService("TweenService")
local ScreenGui = Instance.new("ScreenGui")
local TextLabel = Instance.new("TextLabel")

-- Tạo GUI
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
TextLabel.Parent = ScreenGui
TextLabel.Size = UDim2.new(0, 200, 0, 50) -- Kích thước thông báo
TextLabel.Position = UDim2.new(-0.2, 0, 0.5, 0) -- Bắt đầu bên ngoài màn hình (bên trái)
TextLabel.BackgroundColor3 = Color3.new(1, 1, 1)
TextLabel.TextColor3 = Color3.new(0, 0, 0)
TextLabel.Text = "con cặc đụ má=))"
TextLabel.Font = Enum.Font.SourceSans
TextLabel.TextSize = 24

-- Tạo Tween để di chuyển
local goal = { Position = UDim2.new(1.2, 0, 0.5, 0) } -- Điểm kết thúc ngoài màn hình bên phải
local tweenInfo = TweenInfo.new(5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut) -- 5 giây
local tween = TweenService:Create(TextLabel, tweenInfo, goal)

-- Chạy Tween
tween:Play()

-- Xóa TextLabel sau khi chạy xong
tween.Completed:Connect(function()
    TextLabel:Destroy()
end)
