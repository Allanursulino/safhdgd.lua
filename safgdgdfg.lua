local groundDistance = 8
local Player = game:GetService("Players").LocalPlayer

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
ScreenGui.Name = "MultiHubZombie"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 340, 0, 220)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 12)
UICornerMain.Parent = MainFrame

local Icon = Instance.new("ImageLabel")
Icon.Size = UDim2.new(0, 28, 0, 28)
Icon.Position = UDim2.new(0.03, 0, 0.06, 0)
Icon.BackgroundTransparency = 1
Icon.Image = "rbxassetid://111597804247363"
Icon.Name = "Icon"
Icon.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.6, 0, 0.2, 0)
Title.Position = UDim2.new(0.18, 0, 0.06, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.Gotham
Title.Text = "MultiHub - Zombie"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.TextWrapped = true
Title.Name = "Title"
Title.Parent = MainFrame

local function createButton(name, text, position)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.8, 0, 0, 36)
    btn.Position = position
    btn.BackgroundColor3 = Color3.fromRGB(255, 0, 50)
    btn.Font = Enum.Font.Gotham
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.TextWrapped = true
    btn.Name = name
    btn.Parent = MainFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn

    return btn
end

local ToggleButton = createButton("ToggleButton", "✅ Enable Autofarm", UDim2.new(0.1, 0, 0.35, 0))
local SpeedButton = createButton("SpeedButton", "⚡ Speed Boost", UDim2.new(0.1, 0, 0.6, 0))

local MinimizeButton = createButton("MinimizeButton", "-", UDim2.new(0.78, 0, 0.06, 0))
MinimizeButton.Size = UDim2.new(0, 28, 0, 28)

local CloseButton = createButton("CloseButton", "X", UDim2.new(0.88, 0, 0.06, 0))
CloseButton.Size = UDim2.new(0, 28, 0, 28)

-- Minimizar funcional
local minimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized

    if minimized then
        MainFrame.Size = UDim2.new(0, 220, 0, 50)

        Icon.Position = UDim2.new(0.03, 0, 0.1, 0)
        Icon.Size = UDim2.new(0, 28, 0, 28)

        Title.Text = "MultiHub - Zombie"
        Title.Position = UDim2.new(0.25, 0, 0.1, 0)
        Title.Size = UDim2.new(0.5, 0, 0.8, 0)

        MinimizeButton.Position = UDim2.new(0.78, 0, 0.1, 0)
        MinimizeButton.Size = UDim2.new(0, 28, 0, 28)

        CloseButton.Position = UDim2.new(0.88, 0, 0.1, 0)
        CloseButton.Size = UDim2.new(0, 28, 0, 28)

        ToggleButton.Visible = false
        SpeedButton.Visible = false
    else
        MainFrame.Size = UDim2.new(0, 340, 0, 220)

        Icon.Position = UDim2.new(0.03, 0, 0.06, 0)
        Icon.Size = UDim2.new(0, 28, 0, 28)

        Title.Text = "MultiHub - Zombie"
        Title.Position = UDim2.new(0.18, 0, 0.06, 0)
        Title.Size = UDim2.new(0.6, 0, 0.2, 0)

        MinimizeButton.Position = UDim2.new(0.78, 0, 0.06, 0)
        MinimizeButton.Size = UDim2.new(0, 28, 0, 28)

        CloseButton.Position = UDim2.new(0.88, 0, 0.06, 0)
        CloseButton.Size = UDim2.new(0, 28, 0, 28)

        ToggleButton.Visible = true
        SpeedButton.Visible = true
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Autofarm
_G.farm2 = false
ToggleButton.MouseButton1Click:Connect(function()
    _G.farm2 = not _G.farm2
    ToggleButton.Text = _G.farm2 and "❌ Disable Autofarm" or "✅ Enable Autofarm"
end)

-- Speed Boost
local boosted = false
SpeedButton.MouseButton1Click:Connect(function()
    boosted = not boosted
    local humanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = boosted and 50 or 16
    end
    SpeedButton.Text = boosted and "🛑 Reset Speed" or "⚡ Speed Boost"
end)

-- Função para encontrar inimigo mais próximo
local function getNearest()
    local nearest, dist = nil, 99999
    for _,v in pairs(game.Workspace:WaitForChild("BossFolder"):GetChildren()) do
        if v:FindFirstChild("Head") then
            local m = (Player.Character.Head.Position - v.Head.Position).Magnitude
            if m < dist then
                dist = m
                nearest = v
            end
        end
    end
    for _,v in pairs(game.Workspace:WaitForChild("enemies"):GetChildren()) do
        if v:FindFirstChild("Head") then
            local m = (Player.Character.Head.Position - v.Head.Position).Magnitude
            if m < dist then
                dist = m
                nearest = v
            end
        end
    end
    return nearest
end

_G.globalTarget = nil

-- Loop de movimentação e mira
game:GetService("RunService").RenderStepped:Connect(function()
    if _G.farm2 then
        local target = getNearest()
        if target then
            game.Workspace.CurrentCamera.CFrame = CFrame.new(game.Workspace.CurrentCamera.CFrame.Position, target.Head.Position)
            Player.Character.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, groundDistance, 9)
            _G.globalTarget = target
        end
    end
end)

-- Loop para travar velocidade
spawn(function()
    while wait() do
        local char = Player.Character
        if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Torso") then
            char.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
            char.Torso.Velocity = Vector3.new(0,0,0)
        end
    end
end)

-- Loop de ataque automático
spawn(function()
    while wait() do
        if _G.farm2 and _G.globalTarget and _G.globalTarget:FindFirstChild("Head") and Player.Character:FindFirstChildOfClass("Tool") then
            local target = _G.globalTarget
            game.ReplicatedStorage.Gun:FireServer({
                ["Normal"] = Vector3.new(0, 0, 0),
                ["Direction"] = target.Head.Position,
                ["Name"] = Player.Character:FindFirstChildOfClass("Tool").Name,
                ["Hit"] = target.Head,
                ["Origin"] = target.Head.Position,
                ["Pos"] = target.Head.Position,
            })
        end
    end
end)
