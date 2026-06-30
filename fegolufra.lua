-- FEGOLUFRA - SOLO ESP (sin grab)
-- Para testear si el anti-cheat detecta el executor

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "FG"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local espL = Instance.new("TextLabel", gui)
espL.Size = UDim2.new(0, 400, 0, 22)
espL.Position = UDim2.new(0.5, -200, 0, 5)
espL.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
espL.BackgroundTransparency = 0.3
espL.Text = "FEGOLUFRA ESP - TEST"
espL.TextColor3 = Color3.fromRGB(255,255,255)
espL.TextSize = 11
espL.Font = Enum.Font.GothamBold
espL.TextStrokeTransparency = 0
Instance.new("UICorner", espL).CornerRadius = UDim.new(0, 6)

print("FEGOLUFRA ESP TEST LOADED - If you see this, the executor works!")

spawn(function()
    while true do
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local bestN, bestV = "NINGUNO", 0
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") then
                    local dist = (obj.Position - hrp.Position).Magnitude
                    if dist <= 500 then
                        local name = string.lower(obj.Name)
                        if string.find(name,"brainrot") or string.find(name,"ignore") or string.find(name,"bigger") then
                            local val = 10000
                            if string.find(name,"ultimate") then val=100000
                            elseif string.find(name,"diamond") then val=50000
                            elseif string.find(name,"golden") then val=25000
                            elseif string.find(name,"mythic") then val=5000
                            end
                            if val > bestV then bestV=val bestN=obj.Name end
                        end
                    end
                end
            end
            espL.Text = "BRAINROT: " .. bestN .. " $" .. tostring(bestV)
        end
        task.wait(2)
    end
end)
