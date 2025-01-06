repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

local TP1 = Vector3.new(-12591.4512, 335.95639, -7556.75684)
local TP2 = Vector3.new(-12601.8281, 335.95639, -7556.75684)
local TP1_Tween = CFrame.new(-12591.4512, 335.95639, -7556.75684)
local TP2_Tween = CFrame.new(-12601.8281, 335.95639, -7556.75684)
local detectionRange = 7

local player = game.Players.LocalPlayer
repeat wait() until player:FindFirstChild("PlayerGui")
local gui = Instance.new("ScreenGui", player.PlayerGui)
local toggleButton = Instance.new("TextButton", gui)

toggleButton.Size = UDim2.new(0, 150, 0, 50)
toggleButton.Position = UDim2.new(0.5, -75, 0.1, 0)
toggleButton.Text = "Pause"
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)

local running = true

local function toggleRunning()
    running = not running
    toggleButton.Text = running and "Pause" or "Resume"
    toggleButton.BackgroundColor3 = running and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end

toggleButton.MouseButton1Click:Connect(toggleRunning)

local function checkPlayersNearPosition(targetPosition, range)
    local players = game:GetService("Players"):GetPlayers()
    for _, otherPlayer in ipairs(players) do
        if otherPlayer ~= player then
            local character = otherPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local playerPosition = character.HumanoidRootPart.Position
                local distance = (playerPosition - targetPosition).Magnitude
                if distance <= range then
                    return true
                end
            end
        end
    end
    return false
end

local function NewTween(P1)
    local humanoidRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end

    local Dis = (P1.Position - humanoidRootPart.Position).Magnitude
    local Speed = 300
    local tweenService = game:GetService("TweenService")
    local tween = tweenService:Create(humanoidRootPart, TweenInfo.new(Dis / Speed, Enum.EasingStyle.Linear), {CFrame = P1})
    tween:Play()

    local Noclip = Instance.new("BodyVelocity")
    Noclip.Name = "BC"
    Noclip.Parent = humanoidRootPart
    Noclip.MaxForce = Vector3.new(100000, 100000, 100000)
    Noclip.Velocity = Vector3.new(0, 0, 0)

    pcall(function()
        tween.Completed:Wait()
    end)
    Noclip:Destroy()
end

local gui = player.PlayerGui:FindFirstChild("Main (minimal)")
local chooseTeam = gui and gui:FindFirstChild("ChooseTeam")
local container = chooseTeam and chooseTeam:FindFirstChild("Container")
local pirates = container and container:FindFirstChild("Pirates")
local frame = pirates and pirates:FindFirstChild("Frame")
local button = frame and frame:FindFirstChild("TextButton")

if button then
    while not button.Visible do
        wait(0.1)
    end

    local buttonPosition = button.AbsolutePosition
    local buttonSize = button.AbsoluteSize

    game:GetService("VirtualInputManager"):SendMouseButtonEvent(
        buttonPosition.X + buttonSize.X / 2,
        buttonPosition.Y + buttonSize.Y / 2,
        0,
        true,
        button,
        0
    )
    game:GetService("VirtualInputManager"):SendMouseButtonEvent(
        buttonPosition.X + buttonSize.X / 2,
        buttonPosition.Y + buttonSize.Y / 2,
        0,
        false,
        button,
        0
    )

    wait(5)
end

local character = player.Character
local humanoid = character and character:WaitForChild("Humanoid")

spawn(function()
    while wait(0.5) do
        if running then
            local isSitting = humanoid and humanoid.SeatPart ~= nil
            if not isSitting then
                if not checkPlayersNearPosition(TP1, detectionRange) then
                    NewTween(TP1_Tween)
                else
                    NewTween(TP2_Tween)
                end
            end
        end
    end
end)
