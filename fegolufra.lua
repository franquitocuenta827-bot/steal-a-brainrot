-- Fegolufra Script v2 - Stealth Mode
-- ANTI BYFRON SAFE - NO TELEPORT

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
    ESPDistance = 500,
}

-- ========== RARITIES ==========
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

-- ========== SAFE GRAB (NO TELEPORT) ==========
local function grabItem(item)
    if not item then return end
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local dist = (hrp.Position - item.Position).Magnitude
    if dist > Settings.GrabDistance then return end

    -- ONLY: firetouchinterest (most stealth method)
    for i = 1, 3 do
        pcall(function()
            firetouchinterest(hrp, item, 0)
        end)
        task.wait(0.1 + math.random() * 0.2)
        pcall(function()
            firetouchinterest(hrp, item, 1)
        end)
        task.wait(0.2 + math.random() * 0.3)
    end

    -- ONLY: ClickDetector if exists
    pcall(function()
        local cd = item:FindFirstChildOfClass("ClickDetector")
        if cd then
            fireclickdetector(cd)
        end
    end)
    task.wait(0.3)

    -- ONLY: ProximityPrompt if exists
    pcall(function()
        local pp = item:FindFirstChildOfClass("ProximityPrompt")
        if pp then
            fireproximityprompt(pp, 0)
        end
    end)
end

-- ========== ESP ==========
local espCache = {}
local linesCache = {}
local highestLabel = nil

local function clearESP()
    for _, data in pairs(espCache) do
        pcall(function() if data.gui then data.gui:Destroy() end end)
        pcall(function() if data.hl then data.hl:Destroy() end end)
    end
    for _, data in pairs(linesCache) do
        pcall(function()
            if data.a0 then data.a0:Destroy() end
            if data.a1 then data.a1:Destroy() end
            if data.beam then data.beam:Destroy() end
        end)
    end
    espCache = {}
    linesCache = {}
end

local function makeESP(obj)
    if not obj or not obj:IsA("BasePart") then return end
    if espCache[obj] then return end
    local info = getInfo(obj.Name)
    if not info then return end

    local bb = Instance.new("BillboardGui")
    bb.Size = UDim2.new(0, 240, 0, 70)
    bb.StudsOffset = Vector3.new(0, 4, 0)
    bb.AlwaysOnTop = true
    bb.MaxDistance = Settings.ESPDistance
    bb.Parent = obj

    local bg = Instance.new("Frame", bb)
    bg.Size = UDim2.new(1,0,1,0)
    bg.BackgroundColor3 = Color3.fromRGB(10,10,20)
    bg.BackgroundTransparency = 0.2
    bg.BorderSizePixel = 0
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 8)

    local bar = Instance.new("Frame", bg)
    bar.Size = UDim2.new(1,0,0,4)
    bar.BackgroundColor3 = info.col
    bar.BorderSizePixel = 0

    local nl = Instance.new("TextLabel", bg)
    nl.Size = UDim2.new(1,-10,0,20)
    nl.Position = UDim2.new(0,5,0,6)
    nl.BackgroundTransparency = 1
    nl.Text = "NAME: " .. obj.Name
    nl.TextColor3 = info.col
    nl.TextSize = 13
    nl.Font = Enum.Font.GothamBold
    nl.TextStrokeTransparency = 0
    nl.TextXAlignment = Enum.TextXAlignment.Left

    local rl = Instance.new("TextLabel", bg)
    rl.Size = UDim2.new(1,-10,0,16)
    rl.Position = UDim2.new(0,5,0,26)
    rl.BackgroundTransparency = 1
    rl.Text = "RARITY: " .. string.upper(info.key)
    rl.TextColor3 = Color3.fromRGB(255,255,255)
    rl.TextSize = 11
    rl.Font = Enum.Font.GothamBold
    rl.TextStrokeTransparency = 0
    rl.TextXAlignment = Enum.TextXAlignment.Left

    local vl = Instance.new("TextLabel", bg)
    vl.Size = UDim2.new(1,-10,0,16)
    vl.Position = UDim2.new(0,5,0,44)
    vl.BackgroundTransparency = 1
    vl.Text = "VALUE: $" .. tostring(info.val)
    vl.TextColor3 = Color3.fromRGB(255,255,100)
    vl.TextSize = 11
    vl.Font = Enum.Font.GothamBold
    vl.TextStrokeTransparency = 0
    vl.TextXAlignment = Enum.TextXAlignment.Left

    local hl = Instance.new("Highlight", obj)
    hl.FillColor = info.col
    hl.FillTransparency = 0.6
    hl.OutlineColor = info.col
    hl.OutlineTransparency = 0

    espCache[obj] = {gui = bb, hl = hl}

    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local a0 = Instance.new("Attachment", hrp)
        local a1 = Instance.new("Attachment", obj)
        local beam = Instance.new("Beam")
        beam.Attachment0 = a0
        beam.Attachment1 = a1
        beam.Color = ColorSequence.new(info.col)
        beam.Width0 = 0.15
        beam.Width1 = 0.15
        beam.LightEmission = 1
        beam.FaceCamera = true
        beam.Parent = a0
        linesCache[obj] = {a0 = a0, a1 = a1, beam = beam}
    end
end

local function updateESP()
    clearESP()
    if not Settings.ESP then
        if highestLabel then highestLabel.Visible = false end
        return
    end

    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local bestObj, bestVal, bestInfo = nil, 0, nil

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local info = getInfo(obj.Name)
            if info and (obj.Position - hrp.Position).Magnitude <= Settings.ESPDistance then
                makeESP(obj)
                if info.val > bestVal then
                    bestObj = obj
                    bestVal = info.val
                    bestInfo = info
                end
            end
        end
    end

    if highestLabel then
        if bestObj and bestInfo then
            highestLabel.Visible = true
            highestLabel.Text = "HIGHEST: " .. bestObj.Name .. " | $" .. tostring(bestInfo.val) .. " | " .. string.upper(bestInfo.key)
            highestLabel.TextColor3 = bestInfo.col
        else
            highestLabel.Visible = true
            highestLabel.Text = "NO BRAINROT DETECTED"
            highestLabel.TextColor3 = Color3.fromRGB(200,200,200)
        end
    end
end

-- ========== GUI ==========
local gui = Instance.new("ScreenGui")
gui.Name = "FegolufraScript"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 240, 0, 440)
main.Position = UDim2.new(0.5, -120, 0.5, -220)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

local ttl = Instance.new("TextLabel", main)
ttl.Size = UDim2.new(1,0,0,35)
ttl.BackgroundColor3 = Color3.fromRGB(120, 0, 220)
ttl.Text = "FEGOLUFRA SCRIPT"
ttl.TextColor3 = Color3.fromRGB(255,255,255)
ttl.TextSize = 14
ttl.Font = Enum.Font.GothamBold
Instance.new("UICorner", ttl).CornerRadius = UDim.new(0, 10)

local function mkToggle(txt, y, key)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(0.9,0,0,30)
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
        if key == "ESP" then
            if Settings.ESP then
                spawn(function()
                    while Settings.ESP do updateESP() task.wait(2) end
                    clearESP()
                    if highestLabel then highestLabel.Visible = false end
                end)
            else
                clearESP()
                if highestLabel then highestLabel.Visible = false end
            end
        end
    end)
end

mkToggle("AUTOGRAB", 42, "AutoGrab")
mkToggle("AUTO COLLECT", 78, "AutoCollect")
mkToggle("INFINITE JUMP", 114, "InfJump")
mkToggle("SPEED BOOST", 150, "SpeedBoost")
mkToggle("NOCLIP", 186, "Noclip")
mkToggle("ESP + LINES", 222, "ESP")

local spdL = Instance.new("TextLabel", main)
spdL.Size = UDim2.new(0.9,0,0,24)
spdL.Position = UDim2.new(0.05,0,0,265)
spdL.BackgroundColor3 = Color3.fromRGB(40,40,55)
spdL.Text = "Speed: " .. Settings.Speed
spdL.TextColor3 = Color3.fromRGB(255,255,255)
spdL.TextSize = 12
spdL.Font = Enum.Font.GothamBold
Instance.new("UICorner", spdL).CornerRadius = UDim.new(0, 6)

local pb = Instance.new("TextButton", main)
pb.Size = UDim2.new(0.4,0,0,26)
pb.Position = UDim2.new(0.05,0,0,295)
pb.BackgroundColor3 = Color3.fromRGB(0,100,200)
pb.Text = "+"
pb.TextColor3 = Color3.fromRGB(255,255,255)
pb.TextSize = 18
pb.Font = Enum.Font.GothamBold
Instance.new("UICorner", pb).CornerRadius = UDim.new(0, 6)

local mb = Instance.new("TextButton", main)
mb.Size = UDim2.new(0.4,0,0,26)
mb.Position = UDim2.new(0.55,0,0,295)
mb.BackgroundColor3 = Color3.fromRGB(200,0,0)
mb.Text = "-"
mb.TextColor3 = Color3.fromRGB(255,255,255)
mb.TextSize = 18
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
xb.Size = UDim2.new(0, 30, 0, 30)
xb.Position = UDim2.new(1, -35, 0, 5)
xb.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
xb.Text = "X"
xb.TextColor3 = Color3.fromRGB(255,255,255)
xb.TextSize = 16
xb.Font = Enum.Font.GothamBold
Instance.new("UICorner", xb).CornerRadius = UDim.new(0, 6)

local vis = true
xb.MouseButton1Click:Connect(function()
    vis = not vis
    main.Visible = vis
end)

highestLabel = Instance.new("TextLabel", gui)
highestLabel.Size = UDim2.new(0.6, 0, 0, 35)
highestLabel.Position = UDim2.new(0.2, 0, 0, 10)
highestLabel.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
highestLabel.BackgroundTransparency = 0.3
highestLabel.Text = "NO BRAINROT DETECTED"
highestLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
highestLabel.TextSize = 14
highestLabel.Font = Enum.Font.GothamBold
highestLabel.TextStrokeTransparency = 0
highestLabel.Visible = false
Instance.new("UICorner", highestLabel).CornerRadius = UDim.new(0, 8)

-- ========== AUTOGRAB (STEALTH) ==========
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

-- ========== AUTO COLLECT (STEALTH) ==========
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
        if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.W or input.UserInputType == Enum.UserInputType.Touch then
            local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if hum then pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end) end
        end
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

print("Fegolufra Script v2 Stealth Loaded!")
