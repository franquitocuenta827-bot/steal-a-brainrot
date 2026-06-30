-- Fegolufra Script v4 - Volt Compatible
-- MAXIMO STEALTH - Byfron Safe

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled

local Settings = {
    AutoGrab = false,
    AutoCollect = false,
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
    return nil
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "FG"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 200, 0, 280)
main.Position = UDim2.new(0.02, 0, 0.3, 0)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)

local ttl = Instance.new("TextLabel", main)
ttl.Size = UDim2.new(1,0,0,28)
ttl.BackgroundColor3 = Color3.fromRGB(100, 0, 180)
ttl.Text = "FEGOLUFRA"
ttl.TextColor3 = Color3.fromRGB(255,255,255)
ttl.TextSize = 13
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

mkBtn("AUTOGRAB", 35, "AutoGrab")
mkBtn("AUTO COLLECT", 66, "AutoCollect")
mkBtn("ESP", 97, "ESP")

-- ESP label
local espL = Instance.new("TextLabel", gui)
espL.Size = UDim2.new(0, 350, 0, 30)
espL.Position = UDim2.new(0.5, -175, 0, 5)
espL.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
espL.BackgroundTransparency = 0.3
espL.Text = ""
espL.TextColor3 = Color3.fromRGB(255,255,255)
espL.TextSize = 12
espL.Font = Enum.Font.GothamBold
espL.TextStrokeTransparency = 0
espL.Visible = false
Instance.new("UICorner", espL).CornerRadius = UDim.new(0, 6)

-- ========== GRAB (SOLO FIRETOUCH) ==========
local function doGrab()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local pos = hrp.Position

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local info = getInfo(obj.Name)
            if info and (obj.Position - pos).Magnitude <= 15 then
                pcall(function()
                    firetouchinterest(hrp, obj, 0)
                    task.wait(0.05)
                    firetouchinterest(hrp, obj, 1)
                end)
                task.wait(0.5)
            end
        end
    end
end

-- ========== COLLECT ==========
local function doCollect()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local pos = hrp.Position

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local n = string.lower(obj.Name)
            if string.find(n,"coin") or string.find(n,"cash") or string.find(n,"gem") or obj:FindFirstChild("Pickup") then
                if (obj.Position - pos).Magnitude <= 30 then
                    pcall(function()
                        firetouchinterest(hrp, obj, 0)
                        task.wait(0.05)
                        firetouchinterest(hrp, obj, 1)
                    end)
                    task.wait(0.3)
                end
            end
        end
    end
end

-- ========== ESP SCAN ==========
local function doESP()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then espL.Visible = false return end

    local bestN, bestV, bestC = "NINGUNO", 0, Color3.fromRGB(200,200,200)
    local pos = hrp.Position

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local info = getInfo(obj.Name)
            if info and (obj.Position - pos).Magnitude <= 400 then
                if info.val > bestV then
                    bestV = info.val
                    bestN = obj.Name
                    bestC = info.col
                end
            end
        end
    end

    espL.Visible = true
    espL.Text = "VALIOSO: " .. bestN .. " $" .. tostring(bestV)
    espL.TextColor3 = bestC
end

-- ========== MAIN LOOPS ==========
spawn(function()
    while true do
        if Settings.AutoGrab then pcall(doGrab) end
        if Settings.AutoCollect then pcall(doCollect) end
        if Settings.ESP then pcall(doESP) end
        task.wait(1)
    end
end)

print("Fegolufra v4 Loaded - Volt")
