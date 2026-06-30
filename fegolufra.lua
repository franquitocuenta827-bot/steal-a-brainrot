local p=game.Players.LocalPlayer
while true do
local c=p.Character
if c then
local h=c:FindFirstChild("HumanoidRootPart")
local m=c:FindFirstChildOfClass("Humanoid")
if h and m then
for _,v in pairs(workspace:GetDescendants()) do
if v:IsA("BasePart") and (v.Position-h.Position).Magnitude<20 then
local n=string.lower(v.Name)
if string.find(n,"brainrot") or string.find(n,"ignore") or string.find(n,"bigger") or string.find(n,"noobini") or string.find(n,"tralalero") or string.find(n,"cappuccino") then
m:MoveTo(v.Position)
end
end
end
end
end
task.wait(1)
end
