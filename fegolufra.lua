-- Fegolufra Script v5
-- Line ESP + Instant Grab

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Drawing = Drawing or nil
local player = Players.LocalPlayer

local Settings = {
    AutoGrab = false,
    ESP = false,
    GrabDist = 25,
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
    return nil
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "FG"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 180, 0, 180)
main.Position = UDim2.new(0.02, 0, 0.3, 0)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)

local ttl = Instance.new("TextLabel", main)
ttl.Size = UDim2.new(1,0,0,26)
ttl.BackgroundColor3 = Color3.fromRGB(100, 0, 180)
ttl.Text = "FEGOLUFRA v5"
ttl.TextColor3 = Color3.fromRGB(255,255,255)
ttl.TextSize = 12
ttl.Font = Enum.Font.GothamBold
Instance.new("UICorner", ttl).CornerRadius = UDim.new(0, 8)

local function mkBtn(txt, y, key)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(0.9,0,0,26)
    b.Position = UDim2.new(0.05,0,0,y)
    b.BackgroundColor3 = Settings[key] and Color3.fromRGB(0,140,0) or Color3.fromRGB(140,0,0)
    b.Text = txt .. ": OFF"
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.TextSize = 10
    b.Font = Enum.Font.GothamBold
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    b.MouseButton1Click:Connect(function()
        Settings[key] = not Settings[key]
        b.BackgroundColor3 = Settings[key] and Color3.fromRGB(0,140,0) or Color3.fromRGB(140,0,0)
        b.Text = txt .. ": " .. (Settings[key] and "ON" or "OFF")
    end)
end

mkBtn("AUTOGRAB", 32, "AutoGrab")
mkBtn("ESP + LINE", 63, "ESP")

-- ESP Text
local espL = Instance.new("TextLabel", gui)
espL.Size = UDim2.new(0, 300, 0, 25)
espL.Position = UDim2.new(0.5, -150, 0, 5)
espL.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
espL.BackgroundTransparency = 0.3
espL.Text = ""
espL.TextColor3 = Color3.fromRGB(255,255,255)
espL.TextSize = 11
espL.Font = Enum.Font.GothamBold
espL.TextStrokeTransparency = 0
espL.Visible = false
Instance.new("UICorner", espL).CornerRadius = UDim.new(0, 6)

-- Drawing Line (no instances in workspace)
local line = nil
pcall(function()
    line = Drawing.new("Line")
    line.Visible = false
    line.Color = Color3.fromRGB(255, 0, 0)
    line.Thickness = 2
    line.Transparency = 1
end)

-- ========== INSTANT GRAB ==========
local lastGrab = 0
local function instantGrab()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if tick() - lastGrab < 0.1 then return end

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local info = getInfo(obj.Name)
            if info and (obj.Position - hrp.Position).Magnitude <= Settings.GrabDist then
                lastGrab = tick()
                for i = 1, 8 do
                    pcall(function()
                        firetouchinterest(hrp, obj, 0)
                    end)
                    task.wait(0.02)
                    pcall(function()
                        firetouchinterest(hrp, obj, 1)
                    end)
                    task.wait(0.02)
                end
            end
        end
    end
end

-- ========== ESP + LINE ==========
local function espScan()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        espL.Visible = false
        if line then line.Visible = false end
        return
    end

    local cam = workspace.CurrentCamera
    local bestN, bestV, bestC, bestObj = "NINGUNO", 0, Color3.fromRGB(200,200,200), nil

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local info = getInfo(obj.Name)
            if info and (obj.Position - hrp.Position).Magnitude <= 500 then
                if info.val > bestV then
                    bestV = info.val
                    bestN = obj.Name
                    bestC = info.col
                    bestObj = obj
                end
            end
        end
    end

    -- Text
    espL.Visible = true
    espL.Text = "VALIOSO: " .. bestN .. " $" .. tostring(bestV)
    espL.TextColor3 = bestC

    -- Line
    if line and bestObj then
        local screenPos, onScreen = cam:WorldToViewportPoint(bestObj.Position)
        local midX = cam.ViewportSize.X / 2
        local midY = cam.ViewportSize.Y * 0.7
        if onScreen then
            line.From = Vector2.new(midX, midY)
            line.To = Vector2.new(screenPos.X, screenPos.Y)
            line.Color = bestC
            line.Visible = true
        else
            line.Visible = false
        end
    elseif line then
        line.Visible = false
    end
end

-- ========== MAIN LOOP ==========
spawn(function()
    while true do
        if Settings.AutoGrab then pcall(instantGrab) end
        if Settings.ESP then pcall(espScan) else
            espL.Visible = false
            if line then line.Visible = false end
        end
        task.wait(0.05)
    end
end)

print("Fegolufra v5 Loaded")
