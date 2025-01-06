local TP1 = Vector3.new(-12591.4512, 335.95639, -7556.75684)
local TP2 = Vector3.new(-12601.8281, 335.95639, -7556.75684)
local TP1_Tween = CFrame.new(-12591.4512, 335.95639, -7556.75684)
local TP2_Tween = CFrame.new(-12601.8281, 335.95639, -7556.75684)
local detectionRange = 7

-- Function to check if players are near the target position
local function checkPlayersNearPosition(targetPosition, range)
    local players = game:GetService("Players"):GetPlayers()
    for _, player in ipairs(players) do
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local playerPosition = character.HumanoidRootPart.Position
            local distance = (playerPosition - targetPosition).Magnitude
            if distance <= range then
                return true
            end
        end
    end
    return false
end

-- Function to move the player to a new position via Tween
local function NewTween(P1)
    local player = game.Players.LocalPlayer
    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end

    local Dis = (P1.Position - humanoidRootPart.Position).Magnitude
    local Speed = 300
    local tween = game:GetService("TweenService"):Create(humanoidRootPart, TweenInfo.new(Dis / Speed, Enum.EasingStyle.Linear), {CFrame = P1})
    tween:Play()

    local Noclip = Instance.new("BodyVelocity")
    Noclip.Name = "BC"
    Noclip.Parent = humanoidRootPart
    Noclip.MaxForce = Vector3.new(100000, 100000, 100000)
    Noclip.Velocity = Vector3.new(0, 0, 0)

    tween.Completed:Wait()
    Noclip:Destroy()
end

-- Function to perform the run logic
local function run()
    while wait(0.1) do
        if not checkPlayersNearPosition(TP1, detectionRange) then
            NewTween(TP1_Tween)
        else
            NewTween(TP2_Tween)
        end
    end
end

-- Find the button
local button = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Main (minimal)") and game:GetService("Players").LocalPlayer.PlayerGui["Main (minimal)"]:FindFirstChild("ChooseTeam") and game:GetService("Players").LocalPlayer.PlayerGui["Main (minimal)"].ChooseTeam:FindFirstChild("Container") and game:GetService("Players").LocalPlayer.PlayerGui["Main (minimal)"].ChooseTeam.Container:FindFirstChild("Pirates") and game:GetService("Players").LocalPlayer.PlayerGui["Main (minimal)"].ChooseTeam.Container.Pirates:FindFirstChild("Frame") and game:GetService("Players").LocalPlayer.PlayerGui["Main (minimal)"].ChooseTeam.Container.Pirates.Frame:FindFirstChild("TextButton")

if button then
    -- Wait until button is visible
    while not button.Visible do
        wait(0.1)
    end

    -- Get button position and size
    local buttonPosition = button.AbsolutePosition
    local buttonSize = button.AbsoluteSize

    -- Send mouse click event (click the button)
    game:GetService("VirtualInputManager"):SendMouseButtonEvent(buttonPosition.X + buttonSize.X / 2, buttonPosition.Y + buttonSize.Y / 2, 0, true, button, 0)
    game:GetService("VirtualInputManager"):SendMouseButtonEvent(buttonPosition.X + buttonSize.X / 2, buttonPosition.Y + buttonSize.Y / 2, 0, false, button, 0)

    -- Wait a bit to make sure the button has been clicked
    wait(5)

    -- Create a toggle button
    local gui = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
    local toggleButton = Instance.new("TextButton", gui)
    toggleButton.Size = UDim2.new(0, 150, 0, 50)
    toggleButton.Position = UDim2.new(0.5, -75, 0.1, 0)
    toggleButton.Text = "Pause"
    toggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)

    -- Toggle running state
    local running = true
    toggleButton.MouseButton1Click:Connect(function()
        running = not running
        toggleButton.Text = running and "Pause" or "Resume"
        toggleButton.BackgroundColor3 = running and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    end)

    -- Run the loop
    spawn(function()
        while true do
            if running then
                run()
            end
            wait(0.1)
        end
    end)
else
-- Create a toggle button
    local gui = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
    local toggleButton = Instance.new("TextButton", gui)
    toggleButton.Size = UDim2.new(0, 150, 0, 50)
    toggleButton.Position = UDim2.new(0.5, -75, 0.1, 0)
    toggleButton.Text = "Pause"
    toggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)

    -- Toggle running state
    local running = true
    toggleButton.MouseButton1Click:Connect(function()
        running = not running
        toggleButton.Text = running and "Pause" or "Resume"
        toggleButton.BackgroundColor3 = running and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    end)
	spawn(function()
        while true do
            if running then
                run()
            end
        	wait(0.1)
        end
    end)
end
