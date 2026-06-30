-- Fegolufra Script v3 - Ultra Stealth
-- NO ESP 3D - Solo texto en pantalla

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled

local Settings = {
    AutoGrab = false,
    GrabSpeed = 0.5,
    GrabDistance = 15,
    AutoCollect = false,
    InfJump = false,
    SpeedBoost = false,
    Speed = 20,
    Noclip = false,
    ESP = false,
}

local Rarities = {
    {key = "ultimate", val = 100000, col = Color3.fromRGB(255,255,255)},
    {key = "diamond", val = 50000, col = Color3.fromRGB(0,255,255)},
    {key = "golden", val = 25000, col = Color3.fromRGB(255,215,0)},
    {key = "brainrot", val = 10000, col = Color3.fromRGB(255,0,255)},
    {key = "mythic", val = 5000, col = Color3.fromRGB(255,0,0)},
    {key = "legendary", val = 1500, col = Color3.fromRGB(255,150,0)},
    {key = "epic", val = 500, col = Color3.fromRGB(150,0,200)},
    {key = "rare", val = 150, col = Color3.fromRGB(0,100,255)},
    {key = "uncommon", val = 50, col = Color3.fromRGB(0,200,0)},
    {key = "common", val = 10, col = Color3.fromRGB(150,150,150)},
}

local function getInfo(name)
    local l = string.lower(name)
    for _, r in ipairs(Rarities) do
        if string.find(l, r.key) then return r end
    end
    if string.find(l, "brainrot") then return Rarities[4] end
    return nil
end

-- ========== SAFE GRAB ==========
local function grabItem(item)
    if not item then return end
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if (hrp.Position - item.Position).Magnitude > Settings.GrabDistance then return end

    for i = 1, 3 do
        pcall(function() firetouchinterest(hrp, item, 0) end)
        task.wait(0.1 + math.random() * 0.2)
        pcall(function() firetouchinterest(hrp, item, 1) end)
        task.wait(0.2 + math.random() * 0.3)
    end

    pcall(function()
        local cd = item:FindFirstChildOfClass("ClickDetector")
        if cd then fireclickdetector(cd) end
    end)
    task.wait(0.3)
    pcall(function()
        local pp = item:FindFirstChildOfClass("ProximityPrompt")
        if pp then fireproximityprompt(pp, 0) end
    end)
end

-- ========== GUI ==========
local gui = Instance.new("ScreenGui")
gui.Name = "FegolufraScript"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 220, 0, 400)
main.Position = UDim2.new(0.5, -110, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

local ttl = Instance.new("TextLabel", main)
ttl.Size = UDim2.new(1,0,0,32)
ttl.BackgroundColor3 = Color3.fromRGB(120, 0, 220)
ttl.Text = "FEGOLUFRA SCRIPT"
ttl.TextColor3 = Color3.fromRGB(255,255,255)
ttl.TextSize = 13
ttl.Font = Enum.Font.GothamBold
Instance.new("UICorner", ttl).CornerRadius = UDim.new(0, 10)

local function mkToggle(txt, y, key)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(0.9,0,0,28)
    b.Position = UDim2.new(0.05,0,0,y)
    b.BackgroundColor3 = Settings[key] and Color3.fromRGB(0,150,0) or Color3.fromRGB(150,0,0)
    b.Text = txt .. ": " .. (Settings[key] and "ON" or "OFF")
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.TextSize = 11
    b.Font = Enum.Font.GothamBold
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(function()
        Settings[key] = not Settings[key]
        b.BackgroundColor3 = Settings[key] and Color3.fromRGB(0,150,0) or Color3.fromRGB(150,0,0)
        b.Text = txt .. ": " .. (Settings[key] and "ON" or "OFF")
        if key == "SpeedBoost" then
            local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if h then h.WalkSpeed = Settings[key] and Settings.Speed or 16 end
        end
    end)
end

mkToggle("AUTOGRAB", 40, "AutoGrab")
mkToggle("AUTO COLLECT", 73, "AutoCollect")
mkToggle("INFINITE JUMP", 106, "InfJump")
mkToggle("SPEED BOOST", 139, "SpeedBoost")
mkToggle("NOCLIP", 172, "Noclip")
mkToggle("ESP", 205, "ESP")

local spdL = Instance.new("TextLabel", main)
spdL.Size = UDim2.new(0.9,0,0,22)
spdL.Position = UDim2.new(0.05,0,0,245)
spdL.BackgroundColor3 = Color3.fromRGB(40,40,55)
spdL.Text = "Speed: " .. Settings.Speed
spdL.TextColor3 = Color3.fromRGB(255,255,255)
spdL.TextSize = 11
spdL.Font = Enum.Font.GothamBold
Instance.new("UICorner", spdL).CornerRadius = UDim.new(0, 6)

local pb = Instance.new("TextButton", main)
pb.Size = UDim2.new(0.4,0,0,24)
pb.Position = UDim2.new(0.05,0,0,272)
pb.BackgroundColor3 = Color3.fromRGB(0,100,200)
pb.Text = "+"
pb.TextColor3 = Color3.fromRGB(255,255,255)
pb.TextSize = 16
pb.Font = Enum.Font.GothamBold
Instance.new("UICorner", pb).CornerRadius = UDim.new(0, 6)

local mb = Instance.new("TextButton", main)
mb.Size = UDim2.new(0.4,0,0,24)
mb.Position = UDim2.new(0.55,0,0,272)
mb.BackgroundColor3 = Color3.fromRGB(200,0,0)
mb.Text = "-"
mb.TextColor3 = Color3.fromRGB(255,255,255)
mb.TextSize = 16
mb.Font = Enum.Font.GothamBold
Instance.new("UICorner", mb).CornerRadius = UDim.new(0, 6)

pb.MouseButton1Click:Connect(function()
    Settings.Speed = math.min(Settings.Speed + 2, 60)
    spdL.Text = "Speed: " .. Settings.Speed
    if Settings.SpeedBoost then
        local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = Settings.Speed end
    end
end)

mb.MouseButton1Click:Connect(function()
    Settings.Speed = math.max(Settings.Speed - 2, 16)
    spdL.Text = "Speed: " .. Settings.Speed
    if Settings.SpeedBoost then
        local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = Settings.Speed end
    end
end)

local xb = Instance.new("TextButton", main)
xb.Size = UDim2.new(0, 28, 0, 28)
xb.Position = UDim2.new(1, -33, 0, 4)
xb.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
xb.Text = "X"
xb.TextColor3 = Color3.fromRGB(255,255,255)
xb.TextSize = 14
xb.Font = Enum.Font.GothamBold
Instance.new("UICorner", xb).CornerRadius = UDim.new(0, 6)

local vis = true
xb.MouseButton1Click:Connect(function()
    vis = not vis
    main.Visible = vis
end)

-- ESP: SOLO UN TEXTO EN PANTALLA (NO toca nada del juego)
local espLabel = Instance.new("TextLabel", gui)
espLabel.Size = UDim2.new(0, 400, 0, 50)
espLabel.Position = UDim2.new(0.5, -200, 0, 8)
espLabel.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
espLabel.BackgroundTransparency = 0.2
espLabel.Text = ""
espLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
espLabel.TextSize = 14
espLabel.Font = Enum.Font.GothamBold
espLabel.TextStrokeTransparency = 0
espLabel.Visible = false
Instance.new("UICorner", espLabel).CornerRadius = UDim.new(0, 8)

-- ========== ESP LOOP (SOLO LEE, NO CREA INSTANCIAS) ==========
spawn(function()
    while true do
        if Settings.ESP then
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local bestName = "NINGUNO"
                local bestVal = 0
                local bestCol = Color3.fromRGB(200,200,200)

                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        local info = getInfo(obj.Name)
                        if info and (obj.Position - hrp.Position).Magnitude <= 400 then
                            if info.val > bestVal then
                                bestVal = info.val
                                bestName = obj.Name
                                bestCol = info.col
                            end
                        end
                    end
                end

                espLabel.Visible = true
                espLabel.Text = "BRAINROT MAS VALIOSO: " .. bestName .. " | $" .. tostring(bestVal)
                espLabel.TextColor3 = bestCol
            end
        else
            espLabel.Visible = false
        end
        task.wait(1)
    end
end)

-- ========== AUTOGRAB ==========
spawn(function()
    while true do
        if Settings.AutoGrab then
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, obj in pairs(workspace:GetDescendants()) do
                    if not Settings.AutoGrab then break end
                    if obj:IsA("BasePart") then
                        local info = getInfo(obj.Name)
                        if info and (obj.Position - hrp.Position).Magnitude <= Settings.GrabDistance then
                            grabItem(obj)
                        end
                    end
                end
            end
        end
        task.wait(Settings.GrabSpeed + math.random() * 0.3)
    end
end)

-- ========== AUTO COLLECT ==========
spawn(function()
    while true do
        if Settings.AutoCollect then
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        local n = string.lower(obj.Name)
                        if string.find(n,"coin") or string.find(n,"cash") or string.find(n,"gem") or string.find(n,"star") or obj:FindFirstChild("Pickup") then
                            if (obj.Position - hrp.Position).Magnitude <= 30 then
                                pcall(function()
                                    firetouchinterest(hrp, obj, 0)
                                    task.wait(0.1)
                                    firetouchinterest(hrp, obj, 1)
                                end)
                                task.wait(0.3 + math.random() * 0.3)
                            end
                        end
                    end
                end
            end
        end
        task.wait(0.3)
    end
end)

-- ========== INFINITE JUMP ==========
UIS.InputBegan:Connect(function(input, gp)
    if gp or not Settings.InfJump then return end
    if input.UserInputType == Enum.UserInputType.Keyboard or input.UserInputType == Enum.UserInputType.Touch then
        local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if hum then pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end) end
    end
end)

-- ========== NOCLIP ==========
RunService.Stepped:Connect(function()
    if Settings.Noclip then
        local c = player.Character
        if c then
            for _, v in pairs(c:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end
end)

-- ========== ANTI AFK ==========
spawn(function()
    while true do
        pcall(function()
            game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end)
        wait(60)
    end
end)

player.CharacterAdded:Connect(function(char)
    task.wait(1)
    if Settings.SpeedBoost then
        local h = char:WaitForChild("Humanoid", 5)
        if h then h.WalkSpeed = Settings.Speed end
    end
end)

print("Fegolufra Script v3 Loaded!")
