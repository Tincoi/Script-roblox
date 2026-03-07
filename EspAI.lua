--// Lightweight ESP with GUI

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- SETTINGS
local Settings = {
ShowName = true,
ShowDistance = true,
ESPTeammates = false,
ShowNPC = true
}

local ESP = {}

-- GUI
local Gui = Instance.new("ScreenGui", game.CoreGui)
Gui.Name = "SimpleESP"

local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0,200,0,170)
Main.Position = UDim2.new(0.02,0,0.35,0)
Main.BackgroundColor3 = Color3.fromRGB(30,30,30)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner",Main)

local title = Instance.new("TextLabel",Main)
title.Size = UDim2.new(1,0,0,25)
title.BackgroundTransparency = 1
title.Text = "Simple ESP"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14

local function Toggle(text,pos,key)

local b = Instance.new("TextButton",Main)
b.Size = UDim2.new(0.9,0,0,25)
b.Position = UDim2.new(0.05,0,0,pos)
b.BackgroundColor3 = Color3.fromRGB(45,45,45)
b.TextColor3 = Color3.new(1,1,1)
b.Font = Enum.Font.Gotham
b.TextSize = 13
Instance.new("UICorner",b)

local function refresh()
b.Text = text..": "..(Settings[key] and "ON" or "OFF")
end

refresh()

b.MouseButton1Click:Connect(function()

Settings[key] = not Settings[key]
refresh()

end)

end

Toggle("Show Name",35,"ShowName")
Toggle("Show Distance",65,"ShowDistance")
Toggle("ESP Teammates",95,"ESPTeammates")
Toggle("ESP NPC",125,"ShowNPC")

-- team check
local function shouldShow(p)

if p == LocalPlayer then return false end

if not Settings.ESPTeammates then
if LocalPlayer.Team and p.Team and p.Team == LocalPlayer.Team then
return false
end
end

return true

end

-- create esp
local function createESP(id,name)

local bb = Instance.new("BillboardGui")
bb.Size = UDim2.new(0,200,0,30)
bb.AlwaysOnTop = true
bb.StudsOffset = Vector3.new(0,3,0)

local txt = Instance.new("TextLabel",bb)
txt.Size = UDim2.new(1,0,1,0)
txt.BackgroundTransparency = 1
txt.Font = Enum.Font.Gotham
txt.TextStrokeTransparency = 0
txt.TextSize = 13
txt.TextColor3 = Color3.new(1,1,1)

ESP[id] = {
BB = bb,
TXT = txt,
Name = name
}

end

-- setup player
local function setupPlayer(p)

if ESP[p] then return end

createESP(p,p.Name)

end

-- remove player
local function removePlayer(p)

if ESP[p] then
ESP[p].BB:Destroy()
ESP[p] = nil
end

end

-- setup existing players
for _,p in pairs(Players:GetPlayers()) do
setupPlayer(p)
end

Players.PlayerAdded:Connect(setupPlayer)
Players.PlayerRemoving:Connect(removePlayer)

-- scan NPC
local function scanNPC()

for _,v in pairs(workspace:GetDescendants()) do

if v:IsA("Humanoid") then

local char = v.Parent
local player = Players:GetPlayerFromCharacter(char)

if not player and not ESP[v] then

createESP(v,char.Name)

end

end

end

end

scanNPC()

-- update loop
RunService.RenderStepped:Connect(function()

for id,data in pairs(ESP) do

local char
local hrp

if typeof(id) == "Instance" and id:IsA("Player") then

char = id.Character
hrp = char and char:FindFirstChild("HumanoidRootPart")

if not shouldShow(id) then
data.BB.Enabled = false
continue
end

else

char = id.Parent
hrp = char and char:FindFirstChild("HumanoidRootPart")

if not Settings.ShowNPC then
data.BB.Enabled = false
continue
end

end

local hum = char and char:FindFirstChildOfClass("Humanoid")

if hum and hum.Health > 0 and hrp then

data.BB.Enabled = true
data.BB.Parent = hrp

local text = ""

if Settings.ShowName then
text = data.Name
end

if Settings.ShowDistance then

local dist = math.floor((Camera.CFrame.Position - hrp.Position).Magnitude)

if text ~= "" then
text = text.." ["..dist.."]"
else
text = dist
end

end

data.TXT.Text = text

else

data.BB.Enabled = false

end

end

end)
