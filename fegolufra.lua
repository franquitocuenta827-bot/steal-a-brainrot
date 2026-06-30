-- Fegolufra Script v8
-- Targets actual brainrot names

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

local Settings = {
    AutoGrab = false,
    ESP = false,
    GrabDist = 50,
}

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "FG"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 180, 0, 120)
main.Position = UDim2.new(0.02, 0, 0.35, 0)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)

local ttl = Instance.new("TextLabel", main)
ttl.Size = UDim2.new(1,0,0,26)
ttl.BackgroundColor3 = Color3.fromRGB(100, 0, 180)
ttl.Text = "FEGOLUFRA v8"
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
mkBtn("ESP + LINEA", 63, "ESP")

-- ESP text
local espL = Instance.new("TextLabel", gui)
espL.Size = UDim2.new(0, 400, 0, 22)
espL.Position = UDim2.new(0.5, -200, 0, 5)
espL.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
espL.BackgroundTransparency = 0.3
espL.Text = ""
espL.TextColor3 = Color3.fromRGB(255,255,255)
espL.TextSize = 11
espL.Font = Enum.Font.GothamBold
espL.TextStrokeTransparency = 0
espL.Visible = false
Instance.new("UICorner", espL).CornerRadius = UDim.new(0, 6)

-- Line dots
local lineFrames = {}
for i = 1, 25 do
    local f = Instance.new("Frame", gui)
    f.Size = UDim2.new(0, 6, 0, 6)
    f.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    f.BorderSizePixel = 0
    f.Visible = false
    f.AnchorPoint = Vector2.new(0.5, 0.5)
    f.ZIndex = 999
    Instance.new("UICorner", f).CornerRadius = UDim.new(1, 0)
    lineFrames[i] = f
end

-- ========== FIND BRAINROTS ==========
local ValueNames = {
    "ultimate", "diamond", "golden", "brainrot", "mythic",
    "legendary", "epic", "rare", "uncommon", "common",
    "Ignore", "bigger", "Bigger", "BIGGER"
}

local function getVal(name)
    local l = string.lower(name)
    if string.find(l, "ultimate") then return 100000, Color3.fromRGB(255,255,255) end
    if string.find(l, "diamond") then return 50000, Color3.fromRGB(0,255,255) end
    if string.find(l, "golden") then return 25000, Color3.fromRGB(255,215,0) end
    if string.find(l, "brainrot") then return 10000, Color3.fromRGB(255,0,255) end
    if string.find(l, "mythic") then return 5000, Color3.fromRGB(255,0,0) end
    if string.find(l, "legendary") then return 1500, Color3.fromRGB(255,150,0) end
    if string.find(l, "epic") then return 500, Color3.fromRGB(150,0,200) end
    if string.find(l, "rare") then return 150, Color3.fromRGB(0,100,255) end
    if string.find(l, "uncommon") then return 50, Color3.fromRGB(0,200,0) end
    if string.find(l, "common") then return 10, Color3.fromRGB(150,150,150) end
    if string.find(l, "ignore") or string.find(l, "bigger") then return 100000, Color3.fromRGB(255,215,0) end
    return 0, Color3.fromRGB(200,200,200)
end

-- Buscar brainrots: Model, Part, o cualquier cosa con "Brainrot" o "Ignore" en el nombre
local function findBrainrots()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return {} end

    local results = {}

    -- Buscar en todo workspace
    for _, obj in pairs(workspace:GetDescendants()) do
        local name = obj.Name
        local lname = string.lower(name)

        -- Si el nombre contiene "brainrot", "ignore", "bigger"
        if string.find(lname, "brainrot") or string.find(lname, "ignore") or string.find(lname, "bigger") then
            local pos = nil

            -- Es un Model
            if obj:IsA("Model") then
                local primary = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                if primary then
                    pos = primary.Position
                end
            -- Es una BasePart
            elseif obj:IsA("BasePart") then
                pos = obj.Position
            end

            if pos and (pos - hrp.Position).Magnitude <= 500 then
                local val, col = getVal(name)
                table.insert(results, {obj = obj, pos = pos, val = val, col = col, name = name})
            end
        end
    end

    -- Ordenar por valor
    table.sort(results, function(a, b) return a.val > b.val end)

    return results
end

-- ========== GRAB ==========
local lastGrab = 0
local function grabBrainrot()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if tick() - lastGrab < 0.2 then return end

    local brainrots = findBrainrots()
    for _, b in ipairs(brainrots) do
        if b.pos and (b.pos - hrp.Position).Magnitude <= Settings.GrabDist then
            lastGrab = tick()

            -- Touch el objeto principal
            if b.obj:IsA("BasePart") then
                for i = 1, 8 do
                    pcall(function() firetouchinterest(hrp, b.obj, 0) end)
                    task.wait(0.02)
                    pcall(function() firetouchinterest(hrp, b.obj, 1) end)
                    task.wait(0.02)
                end
            end

            -- Touch todas las partes del model
            if b.obj:IsA("Model") then
                for _, part in pairs(b.obj:GetDescendants()) do
                    if part:IsA("BasePart") then
                        for i = 1, 5 do
                            pcall(function() firetouchinterest(hrp, part, 0) end)
                            task.wait(0.02)
                            pcall(function() firetouchinterest(hrp, part, 1) end)
                            task.wait(0.02)
                        end
                    end
                end
            end

            -- ClickDetector
            local cd = b.obj:FindFirstChildOfClass("ClickDetector")
            if cd then pcall(function() fireclickdetector(cd) end) end

            -- ProximityPrompt
            local pp = b.obj:FindFirstChildOfClass("ProximityPrompt")
            if pp then pcall(function() fireproximityprompt(pp, 0) end) end

            -- Buscar CD y PP en hijos
            for _, child in pairs(b.obj:GetDescendants()) do
                if child:IsA("ClickDetector") then pcall(function() fireclickdetector(child) end) end
                if child:IsA("ProximityPrompt") then pcall(function() fireproximityprompt(child, 0) end) end
            end

            break
        end
    end
end

-- ========== ESP + LINE ==========
local function espScan()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        espL.Visible = false
        for _, f in pairs(lineFrames) do f.Visible = false end
        return
    end

    local brainrots = findBrainrots()
    local best = brainrots[1]

    -- Text
    if best then
        espL.Visible = true
        espL.Text = "VALIOSO: " .. best.name .. " $" .. tostring(best.val)
        espL.TextColor3 = best.col
    else
        espL.Visible = true
        espL.Text = "NINGUNO CERCA"
        espL.TextColor3 = Color3.fromRGB(200,200,200)
    end

    -- Line
    if best and best.pos then
        local cam = workspace.CurrentCamera
        local sp, on = cam:WorldToViewportPoint(best.pos)
        if on then
            local sx = cam.ViewportSize.X / 2
            local sy = cam.ViewportSize.Y * 0.8
            for i, f in ipairs(lineFrames) do
                local t = (i - 1) / (#lineFrames - 1)
                f.Position = UDim2.new(0, sx + (sp.X - sx) * t, 0, sy + (sp.Y - sy) * t)
                f.BackgroundColor3 = best.col
                f.Visible = true
            end
        else
            for _, f in pairs(lineFrames) do f.Visible = false end
        end
    else
        for _, f in pairs(lineFrames) do f.Visible = false end
    end
end

-- ========== MAIN ==========
spawn(function()
    while true do
        if Settings.AutoGrab then pcall(grabBrainrot) end
        if Settings.ESP then pcall(espScan) else
            espL.Visible = false
            for _, f in pairs(lineFrames) do f.Visible = false end
        end
        task.wait(0.05)
    end
end)

print("Fegolufra v8 Loaded - Targets: Brainrot, Ignore, Bigger")
