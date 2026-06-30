-- Fegolufra Script v9
-- Grab instantaneo en pasillo/conveyor

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

local Settings = {
    AutoGrab = false,
    ESP = false,
    GrabDist = 60,
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
ttl.Text = "FEGOLUFRA v9"
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
mkBtn("ESP", 63, "ESP")

-- ESP
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

-- ========== GRAB: TOCA TODO LO QUE ESTE CERCA ==========
local grabCooldown = {}

local function grabAll()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name ~= "Terrain" and obj.Name ~= "Baseplate" and obj.Name ~= "Base" then
            local dist = (obj.Position - hrp.Position).Magnitude
            if dist <= Settings.GrabDist then
                -- No spammar el mismo objeto cada 0.5s
                if not grabCooldown[obj] or (tick() - grabCooldown[obj]) > 0.5 then
                    grabCooldown[obj] = tick()

                    -- Touch interest agresivo
                    for i = 1, 10 do
                        pcall(function()
                            firetouchinterest(hrp, obj, 0)
                        end)
                        task.wait(0.01)
                        pcall(function()
                            firetouchinterest(hrp, obj, 1)
                        end)
                        task.wait(0.01)
                    end

                    -- ClickDetector
                    pcall(function()
                        local cd = obj:FindFirstChildOfClass("ClickDetector")
                        if cd then fireclickdetector(cd) end
                    end)

                    -- ProximityPrompt
                    pcall(function()
                        local pp = obj:FindFirstChildOfClass("ProximityPrompt")
                        if pp then fireproximityprompt(pp, 0) end
                    end)

                    -- Buscar en hijos
                    for _, child in pairs(obj:GetDescendants()) do
                        pcall(function()
                            if child:IsA("ClickDetector") then fireclickdetector(child) end
                            if child:IsA("ProximityPrompt") then fireproximityprompt(child, 0) end
                        end)
                    end
                end
            end
        end

        -- Tambien tools
        if obj:IsA("Tool") then
            local handle = obj:FindFirstChild("Handle")
            if handle then
                local dist = (handle.Position - hrp.Position).Magnitude
                if dist <= Settings.GrabDist then
                    for i = 1, 10 do
                        pcall(function() firetouchinterest(hrp, handle, 0) end)
                        task.wait(0.01)
                        pcall(function() firetouchinterest(hrp, handle, 1) end)
                        task.wait(0.01)
                    end
                end
            end
        end
    end
end

-- ========== ESP ==========
local function espScan()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        espL.Visible = false
        for _, f in pairs(lineFrames) do f.Visible = false end
        return
    end

    local cam = workspace.CurrentCamera
    local bestObj, bestVal, bestN, bestC = nil, 0, "NINGUNO", Color3.fromRGB(200,200,200)

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name ~= "Terrain" and obj.Name ~= "Baseplate" and obj.Name ~= "Base" then
            local dist = (obj.Position - hrp.Position).Magnitude
            if dist <= 500 then
                local name = string.lower(obj.Name)
                local val = 0
                local col = Color3.fromRGB(200,200,200)

                if string.find(name, "ultimate") then val = 100000 col = Color3.fromRGB(255,255,255)
                elseif string.find(name, "diamond") then val = 50000 col = Color3.fromRGB(0,255,255)
                elseif string.find(name, "golden") then val = 25000 col = Color3.fromRGB(255,215,0)
                elseif string.find(name, "brainrot") then val = 10000 col = Color3.fromRGB(255,0,255)
                elseif string.find(name, "mythic") then val = 5000 col = Color3.fromRGB(255,0,0)
                elseif string.find(name, "legendary") then val = 1500 col = Color3.fromRGB(255,150,0)
                elseif string.find(name, "epic") then val = 500 col = Color3.fromRGB(150,0,200)
                elseif string.find(name, "rare") then val = 150 col = Color3.fromRGB(0,100,255)
                elseif string.find(name, "uncommon") then val = 50 col = Color3.fromRGB(0,200,0)
                elseif string.find(name, "common") then val = 10 col = Color3.fromRGB(150,150,150)
                elseif string.find(name, "ignore") or string.find(name, "bigger") then val = 100000 col = Color3.fromRGB(255,215,0)
                -- Si tiene clickdetector o proximityprompt, es probablemente agarrable
                elseif obj:FindFirstChildOfClass("ClickDetector") or obj:FindFirstChildOfClass("ProximityPrompt") or obj:FindFirstChild("Handle") or obj:FindFirstChild("TouchTransmitter") then
                    val = 1 col = Color3.fromRGB(255, 255, 0)
                end

                if val > bestVal then
                    bestVal = val
                    bestObj = obj
                    bestN = obj.Name
                    bestC = col
                end
            end
        end
    end

    -- Text
    espL.Visible = true
    if bestObj then
        espL.Text = "VALIOSO: " .. bestN .. " $" .. tostring(bestVal)
        espL.TextColor3 = bestC
    else
        espL.Text = "BUSCANDO..."
        espL.TextColor3 = Color3.fromRGB(200,200,200)
    end

    -- Line
    if bestObj then
        local sp, on = cam:WorldToViewportPoint(bestObj.Position)
        if on then
            local sx = cam.ViewportSize.X / 2
            local sy = cam.ViewportSize.Y * 0.8
            for i, f in ipairs(lineFrames) do
                local t = (i - 1) / (#lineFrames - 1)
                f.Position = UDim2.new(0, sx + (sp.X - sx) * t, 0, sy + (sp.Y - sy) * t)
                f.BackgroundColor3 = bestC
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
        if Settings.AutoGrab then pcall(grabAll) end
        if Settings.ESP then pcall(espScan) else
            espL.Visible = false
            for _, f in pairs(lineFrames) do f.Visible = false end
        end
        task.wait(0.03)
    end
end)

print("Fegolufra v9 - GRABS EVERYTHING NEARBY")
