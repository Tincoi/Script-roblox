-- AUTO LOAD SERVER HOP
if queue_on_teleport then
queue_on_teleport([[loadstring(game:HttpGet("https://raw.githubusercontent.com/Tincoi/Script-roblox/refs/heads/main/GuiVipAI.lua"))()]])
end

-- ANTI DUPLICATE
if game.CoreGui:FindFirstChild("GuiVipTinkoj") then
game.CoreGui.GuiVipTinkoj:Destroy()
end

local UIS = game:GetService("UserInputService")

local gui = Instance.new("ScreenGui",game.CoreGui)
gui.Name = "GuiVipTinkoj"

-- OPEN BUTTON
local openBtn = Instance.new("TextButton",gui)
openBtn.Size = UDim2.new(0,100,0,40)
openBtn.Position = UDim2.new(0,50,0,200)
openBtn.Text = "Mở VIP"
openBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
openBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",openBtn)

-- MENU
local frame = Instance.new("Frame",gui)
frame.Size = UDim2.new(0,420,0,260)
frame.Position = UDim2.new(0.5,-210,0.5,-130)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Instance.new("UICorner",frame)

-- TITLE
local title = Instance.new("TextLabel",frame)
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.Text = "GuiVip by Tinkoj"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true

-- X BUTTON
local closeBtn = Instance.new("TextButton",frame)
closeBtn.Size = UDim2.new(0,25,0,25)
closeBtn.Position = UDim2.new(1,-30,0,5)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(170,0,0)
closeBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",closeBtn)

-- OUT BUTTON
local outBtn = Instance.new("TextButton",frame)
outBtn.Size = UDim2.new(0,50,0,25)
outBtn.Position = UDim2.new(1,-55,1,-30)
outBtn.Text = "OUT"
outBtn.BackgroundColor3 = Color3.fromRGB(120,0,0)
outBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",outBtn)

-- BUTTON CONTAINER
local container = Instance.new("Frame",frame)
container.Size = UDim2.new(1,-10,1,-60)
container.Position = UDim2.new(0,5,0,35)
container.BackgroundTransparency = 1

local grid = Instance.new("UIGridLayout",container)
grid.CellSize = UDim2.new(0,95,0,35)
grid.CellPadding = UDim2.new(0,5,0,5)

-- CREATE BUTTON
local function makeBtn(name)

local b = Instance.new("TextButton",container)
b.Text = name
b.BackgroundColor3 = Color3.fromRGB(45,45,45)
b.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",b)

return b
end

-- 20 BUTTONS
local b1 = makeBtn("PVPKing")
b1.MouseButton1Click:Connect(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Tincoi/Script-roblox/refs/heads/main/TphumanAI.lua"))()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Tincoi/Script-roblox/refs/heads/main/aimbotAI.lua"))()
        loadstring(game:HttpGet("https://gist.githubusercontent.com/Tincoi/890d6a2b0ea8a23906eb64bb0f9879e6/raw/f0cfbff52274e84a59fd23dca2a218e7c8a31b46/admin"))()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Tincoi/Script-roblox/refs/heads/main/EspKing.lua"))() 
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Tincoi/Script-roblox/refs/heads/main/FlyjumpAI.lua"))()
        loadstring(game:HttpGet(""))()
end)

local b2 = makeBtn("TphumanAI")
b2.MouseButton1Click:Connect(function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Tincoi/Script-roblox/refs/heads/main/TphumanAI.lua"))()
end)

local b3 = makeBtn("AimbotAI")
b3.MouseButton1Click:Connect(function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Tincoi/Script-roblox/refs/heads/main/aimbotAI.lua"))()
end)

local b4 = makeBtn("FlyGuiV3")
b4.MouseButton1Click:Connect(function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Tincoi/Script-roblox/refs/heads/main/FlyGuiV3.lua"))()
end)

local b5 = makeBtn("NTT HUB")
b5.MouseButton1Click:Connect(function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/NTT-HUB/Script/refs/heads/main/main"))()
end)

local b6 = makeBtn("Admin")
b6.MouseButton1Click:Connect(function()
loadstring(game:HttpGet("https://gist.githubusercontent.com/Tincoi/890d6a2b0ea8a23906eb64bb0f9879e6/raw/f0cfbff52274e84a59fd23dca2a218e7c8a31b46/admin"))()
end)

local b7 = makeBtn("FlyJumpAI")
b7.MouseButton1Click:Connect(function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Tincoi/Script-roblox/refs/heads/main/FlyjumpAI.lua"))()
end)

local b8 = makeBtn("EspNpcAI")
b8.MouseButton1Click:Connect(function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Tincoi/Script-roblox/refs/heads/main/EspNpcAI.lua"))()
end)

local b9 = makeBtn("EspAI")
b9.MouseButton1Click:Connect(function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Tincoi/Script-roblox/refs/heads/main/EspAI.lua"))()
end)

local b10 = makeBtn("SpawnTP")
b10.MouseButton1Click:Connect(function()
loadstring(game:HttpGet("https://gist.githubusercontent.com/Tincoi/811601b486f079a5740e7cf470a9b69f/raw/69e86166ac9e67b185decbc7cf09cb8430c873d1/spawm"))()
end)

local b11 = makeBtn("EspKing")
b11.MouseButton1Click:Connect(function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Tincoi/Script-roblox/refs/heads/main/EspKing.lua"))()
end)

local b12 = makeBtn("HeadHITBOX")
b12.MouseButton1Click:Connect(function()
loadstring(game:HttpGet("https://gist.githubusercontent.com/Tincoi/e8e12afeed7acd299cff081f9d75ea60/raw/931a4c88d0584fdbe68cd6629a8d4336aca45438/HEADHITBOXNGON"))()
end)

local b13 = makeBtn("Lucky")
b13.MouseButton1Click:Connect(function()
loadstring(game:HttpGet("https://gist.githubusercontent.com/Tincoi/71f0a8b0477fff31b03cf6517a7461a0/raw/9a877c50ffa44802ddbe471ea04f82894bf499c7/lucky"))()
end)

local b14 = makeBtn(".")
b14.MouseButton1Click:Connect(function()
loadstring(game:HttpGet(""))()
end)

local b15 = makeBtn(".")
b15.MouseButton1Click:Connect(function()
loadstring(game:HttpGet(""))()
end)

local b16 = makeBtn(".")
b16.MouseButton1Click:Connect(function()
loadstring(game:HttpGet(""))()
end)

local b17 = makeBtn("Chim")
b17.MouseButton1Click:Connect(function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Tincoi/Script-roblox/refs/heads/main/FlyChim"))()
end)

local b18 = makeBtn("Invisible")
b18.MouseButton1Click:Connect(function()
loadstring(game:HttpGet("https://gist.githubusercontent.com/Tincoi/40eb7bf351d0605738a9bb39fa404898/raw/80e25cda70aad2420ae06bff633cf3c47dca4aba/invisi%2520lucky"))()
end)

local b19 = makeBtn("Testscript")
b19.MouseButton1Click:Connect(function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Tincoi/Script-roblox/refs/heads/main/Testscript.lua"))()
end)

local b20 = makeBtn("REJOIN")
b20.MouseButton1Click:Connect(function()
game:GetService("TeleportService"):Teleport(game.PlaceId)
end)

-- TOGGLE FUNCTION
local function toggle()
frame.Visible = not frame.Visible
end

openBtn.MouseButton1Click:Connect(toggle)
closeBtn.MouseButton1Click:Connect(function()
frame.Visible=false
end)

outBtn.MouseButton1Click:Connect(function()
gui:Destroy()
end)

-- KEYBIND K
UIS.InputBegan:Connect(function(i,gp)
if gp then return end
if i.KeyCode == Enum.KeyCode.K then
toggle()
end
end)

-- DRAG FUNCTION
local function dragify(obj)

local drag=false
local dragInput,start,startPos

local function update(i)
local delta=i.Position-start
obj.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
end

obj.InputBegan:Connect(function(i)
if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
drag=true
start=i.Position
startPos=obj.Position
i.Changed:Connect(function()
if i.UserInputState==Enum.UserInputState.End then
drag=false
end
end)
end
end)

obj.InputChanged:Connect(function(i)
if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then
dragInput=i
end
end)

UIS.InputChanged:Connect(function(i)
if i==dragInput and drag then
update(i)
end
end)

end

dragify(frame)
dragify(openBtn)
local UIS = game:GetService("UserInputService")

UIS.InputBegan:Connect(function(input, gameProcessed)

if gameProcessed then return end

if input.KeyCode == Enum.KeyCode.K then

frame.Visible = not frame.Visible

end

end)
