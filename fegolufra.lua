-- Fegolufra Script v6 - Debug + Universal Grab

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

local Settings = {
    AutoGrab = false,
    ESP = false,
    Debug = false,
    GrabDist = 30,
}

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "FG"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 200, 0, 200)
main.Position = UDim2.new(0.02, 0, 0.3, 0)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)

local ttl = Instance.new("TextLabel", main)
ttl.Size = UDim2.new(1,0,0,26)
ttl.BackgroundColor3 = Color3.fromRGB(100, 0, 180)
ttl.Text = "FEGOLUFRA v6"
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
mkBtn("DEBUG (print)", 94, "Debug")

-- ESP
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

-- Drawing line
local line = nil
pcall(function()
    line = Drawing.new("Line")
    line.Visible = false
    line.Thickness = 2
end)

-- ========== GRAB UNIVERSAL ==========
local function universalGrab()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name ~= "Terrain" and obj.Name ~= "Baseplate" then
            local dist = (obj.Position - hrp.Position).Magnitude
            if dist <= Settings.GrabDist then
                -- Buscar hijos que indiquen que es agarrable
                local hasHandle = obj:FindFirstChild("Handle")
                local hasCD = obj:FindFirstChildOfClass("ClickDetector")
                local hasPP = obj:FindFirstChildOfClass("ProximityPrompt")
                local hasTI = obj:FindFirstChildOfClass("TouchTransmitter")

                if hasHandle or hasCD or hasPP or hasTI then
                    -- Spam touch
                    for i = 1, 5 do
                        pcall(function()
                            firetouchinterest(hrp, obj, 0)
                        end)
                        task.wait(0.02)
                        pcall(function()
                            firetouchinterest(hrp, obj, 1)
                        end)
                        task.wait(0.02)
                    end

                    -- Fire CD
                    if hasCD then
                        pcall(function() fireclickdetector(hasCD) end)
                    end

                    -- Fire PP
                    if hasPP then
                        pcall(function() fireproximityprompt(hasPP, 0) end)
                    end
                end

                -- Tambien intentar con Tool en backpack
                if obj:IsA("Tool") or obj:IsA("BackpackItem") then
                    for i = 1, 5 do
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
end

-- ========== DEBUG ==========
local function debugScan()
    print("========== FEGOLUFRA DEBUG ==========")
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then print("No HRP") return end

    local count = 0
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local dist = (obj.Position - hrp.Position).Magnitude
            if dist <= 50 then
                count = count + 1
                local children = {}
                for _, c in pairs(obj:GetChildren()) do
                    table.insert(children, c.ClassName)
                end
                print("[" .. count .. "] " .. obj.Name .. " | Dist: " .. math.floor(dist) .. " | Children: " .. table.concat(children, ", "))
            end
        elseif obj:IsA("Tool") then
            count = count + 1
            print("[" .. count .. "] TOOL: " .. obj.Name)
        end
    end
    print("Total: " .. count .. " objects")
    print("====================================")
end

-- ========== ESP ==========
local function espScan()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then espL.Visible = false if line then line.Visible = false end return end

    local cam = workspace.CurrentCamera
    local bestObj, bestVal, bestN, bestC = nil, 0, "NINGUNO", Color3.fromRGB(200,200,200)

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local name = string.lower(obj.Name)
            local val = 0
            local col = Color3.fromRGB(200,200,200)

            -- Buscar cualquier valor por nombre
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
            -- Si tiene ClickDetector o ProximityPrompt, marcarlo
            elseif obj:FindFirstChildOfClass("ClickDetector") or obj:FindFirstChildOfClass("ProximityPrompt") or obj:FindFirstChild("Handle") then
                val = 1
                col = Color3.fromRGB(255, 255, 0)
            end

            if val > 0 and (obj.Position - hrp.Position).Magnitude <= 500 then
                if val > bestVal then
                    bestVal = val
                    bestObj = obj
                    bestN = obj.Name
                    bestC = col
                end
            end
        end
    end

    espL.Visible = true
    espL.Text = "VALIOSO: " .. bestN .. " $" .. tostring(bestVal)
    espL.TextColor3 = bestC

    -- Line
    if line and bestObj then
        local sp, on = cam:WorldToViewportPoint(bestObj.Position)
        if on then
            line.From = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y * 0.7)
            line.To = Vector2.new(sp.X, sp.Y)
            line.Color = bestC
            line.Visible = true
        else
            line.Visible = false
        end
    end
end

-- ========== MAIN ==========
spawn(function()
    while true do
        if Settings.AutoGrab then pcall(universalGrab) end
        if Settings.ESP then pcall(espScan) else
            espL.Visible = false
            if line then line.Visible = false end
        end
        if Settings.Debug then
            Settings.Debug = false
            pcall(debugScan)
        end
        task.wait(0.05)
    end
end)

print("Fegolufra v6 - USA BOTON DEBUG Y MANDAME EL LOG")
