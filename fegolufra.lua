-- FEGOLUFRA - Walk to brainrot approach
-- Sin funciones detectadas, solo movimiento

local Players = game:GetService("Players")
local player = Players.LocalPlayer

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
ttl.Text = "FEGOLUFRA"
ttl.TextColor3 = Color3.fromRGB(255,255,255)
ttl.TextSize = 12
ttl.Font = Enum.Font.GothamBold
Instance.new("UICorner", ttl).CornerRadius = UDim.new(0, 8)

local function mkBtn(txt, y, key, default)
    local val = default or false
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(0.9,0,0,26)
    b.Position = UDim2.new(0.05,0,0,y)
    b.BackgroundColor3 = val and Color3.fromRGB(0,140,0) or Color3.fromRGB(140,0,0)
    b.Text = txt .. ": OFF"
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.TextSize = 10
    b.Font = Enum.Font.GothamBold
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    local ref = {Value = val}
    b.MouseButton1Click:Connect(function()
        ref.Value = not ref.Value
        b.BackgroundColor3 = ref.Value and Color3.fromRGB(0,140,0) or Color3.fromRGB(140,0,0)
        b.Text = txt .. ": " .. (ref.Value and "ON" or "OFF")
    end)
    return ref
end

local autoGrab = mkBtn("AUTOGRAB", 32, "AutoGrab")
local espBtn = mkBtn("ESP", 63, "ESP")

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

-- Line
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

-- ========== AUTOGRAB: Walk to brainrot ==========
local function getBestBrainrot()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil, 0, "" end

    local bestObj, bestVal, bestName = nil, 0, ""
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local dist = (obj.Position - hrp.Position).Magnitude
            if dist <= 100 then
                local name = string.lower(obj.Name)
                local val = 0
                if string.find(name,"ultimate") then val=100000
                elseif string.find(name,"diamond") then val=50000
                elseif string.find(name,"golden") then val=25000
                elseif string.find(name,"brainrot") then val=10000
                elseif string.find(name,"mythic") then val=5000
                elseif string.find(name,"legendary") then val=1500
                elseif string.find(name,"epic") then val=500
                elseif string.find(name,"rare") then val=150
                elseif string.find(name,"ignore") or string.find(name,"bigger") then val=100000
                elseif string.find(name,"noobini") or string.find(name,"tralalero") or string.find(name,"trippi") or string.find(name,"tung") or string.find(name,"cappuccino") or string.find(name,"gangster") then val=5000
                end
                if val > bestVal then
                    bestVal = val
                    bestObj = obj
                    bestName = obj.Name
                end
            end
        end
    end
    return bestObj, bestVal, bestName
end

spawn(function()
    while true do
        if autoGrab.Value then
            local obj, val, name = getBestBrainrot()
            if obj then
                local char = player.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hrp and hum then
                    local dist = (hrp.Position - obj.Position).Magnitude
                    if dist > 5 then
                        hum:MoveTo(obj.Position)
                    end
                end
            end
        end
        task.wait(0.1)
    end
end)

-- ========== ESP ==========
spawn(function()
    while true do
        if espBtn.Value then
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local obj, val, name = getBestBrainrot()
                espL.Visible = true
                if obj then
                    espL.Text = "VALIOSO: " .. name .. " $" .. tostring(val)
                    -- Line
                    local cam = workspace.CurrentCamera
                    local sp, on = cam:WorldToViewportPoint(obj.Position)
                    if on then
                        local sx = cam.ViewportSize.X / 2
                        local sy = cam.ViewportSize.Y * 0.8
                        for i, f in ipairs(lineFrames) do
                            local t = (i - 1) / (#lineFrames - 1)
                            f.Position = UDim2.new(0, sx + (sp.X - sx) * t, 0, sy + (sp.Y - sy) * t)
                            f.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                            f.Visible = true
                        end
                    else
                        for _, f in pairs(lineFrames) do f.Visible = false end
                    end
                else
                    espL.Text = "BUSCANDO..."
                    for _, f in pairs(lineFrames) do f.Visible = false end
                end
            end
        else
            espL.Visible = false
            for _, f in pairs(lineFrames) do f.Visible = false end
        end
        task.wait(1)
    end
end)

print("FEGOLUFRA Loaded!")
