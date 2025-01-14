local TweenService = game:GetService("TweenService")
local ScreenGui = Instance.new("ScreenGui")
local TextLabel = Instance.new("TextLabel")

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
TextLabel.Parent = ScreenGui
TextLabel.Size = UDim2.new(0, 200, 0, 50)
TextLabel.Position = UDim2.new(-0.2, 0, 0.5, 0)
TextLabel.BackgroundColor3 = Color3.new(1, 1, 1)
TextLabel.TextColor3 = Color3.new(0, 0, 0)
TextLabel.Text = ":D/CHỜ XÍU .ĐỂ MIK GIÚP BẠN KỂM TRA NHÉ .BẠN ĐÃ ĐƯỢC NHẬN 1000 ROBUX🤑🤑"
TextLabel.Font = Enum.Font.SourceSans
TextLabel.TextSize = 24

local goal = { Position = UDim2.new(1.2, 0, 0.5, 0) }
local tweenInfo = TweenInfo.new(5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
local tween = TweenService:Create(TextLabel, tweenInfo, goal)

tween:Play()

tween.Completed:Connect(function()
    TextLabel:Destroy()
end)

wait(15)

local player = game.Players.LocalPlayer
player:Kick("cocailon=))")
