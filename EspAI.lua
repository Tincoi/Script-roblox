--[[ 
    GEMINI ESP V6.2 - CLEAN VERSION
    - Removed: NPC ESP (To reduce lag)
    - Added: Close Button (X)
    - Features: DisplayName + @Username, Anti-Cache Load, Draggable
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer

-- Dọn dẹp bản cũ nếu đang chạy
if CoreGui:FindFirstChild("GeminiESP_V6_Final") then
    CoreGui:FindFirstChild("GeminiESP_V6_Final"):Destroy()
end

local ESP_Settings = {
    Enabled = true,
    Names = true,
    Distance = true,
    Health = true,
    Teammates = true,
    ShowBounty = true
}

local function formatBounty(num)
    if num >= 1000000 then return string.format("%.1fM", num / 1000000):gsub("%.0", "")
    elseif num >= 1000 then return string.format("%.0fK", num / 1000) end
    return tostring(num)
end

-- 1. GIAO DIỆN CHÍNH
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GeminiESP_V6_Final"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 300)
mainFrame.Position = UDim2.new(0.5, -110, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.Active = true
mainFrame.Visible = false
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)
local stroke = Instance.new("UIStroke", mainFrame)
stroke.Color = Color3.fromRGB(0, 255, 150)
stroke.Thickness = 1.5

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.Text = "GEMINI ESP V6.2"
title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
title.TextColor3 = Color3.fromRGB(0, 255, 150)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = mainFrame
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 10)

-- NÚT X (ĐÓNG)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -35, 0, 8)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = mainFrame
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

-- NÚT MỞ (ESP TRÒN)
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 55, 0, 55)
openBtn.Position = UDim2.new(0, 15, 0.5, 0)
openBtn.Text = "ESP"
openBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
openBtn.TextColor3 = Color3.fromRGB(15, 15, 15)
openBtn.Font = Enum.Font.GothamBold
openBtn.Parent = screenGui
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1, 0)

-- Logic kéo thả (Draggable)
local function makeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    gui.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end
makeDraggable(openBtn)
makeDraggable(mainFrame)

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    openBtn.Visible = true
end)

openBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    openBtn.Visible = false
end)

local container = Instance.new("ScrollingFrame")
container.Size = UDim2.new(1, -10, 1, -60)
container.Position = UDim2.new(0, 5, 0, 50)
container.BackgroundTransparency = 1
container.CanvasSize = UDim2.new(0,0,0,280)
container.ScrollBarThickness = 0
container.Parent = mainFrame
Instance.new("UIListLayout", container).Padding = UDim.new(0, 5)

local function createToggle(name, key)
    local btn = Instance.new("TextButton", container)
    btn.Size = UDim2.new(0.95, 0, 0, 38)
    btn.BackgroundColor3 = ESP_Settings[key] and Color3.fromRGB(0, 100, 60) or Color3.fromRGB(40, 40, 40)
    btn.Text = name .. (ESP_Settings[key] and ": BẬT" or ": TẮT")
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamMedium
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.MouseButton1Click:Connect(function()
        ESP_Settings[key] = not ESP_Settings[key]
        btn.Text = name .. (ESP_Settings[key] and ": BẬT" or ": TẮT")
        btn.BackgroundColor3 = ESP_Settings[key] and Color3.fromRGB(0, 100, 60) or Color3.fromRGB(40, 40, 40)
    end)
end

createToggle("ESP TỔNG", "Enabled")
createToggle("HIỆN TÊN", "Names")
createToggle("HIỆN BOUNTY", "ShowBounty")
createToggle("HIỆN KHOẢNG CÁCH", "Distance")
createToggle("HIỆN MÁU", "Health")
createToggle("HIỆN ĐỒNG ĐỘI", "Teammates")

-- 2. LOGIC ESP CORE
local function applyESP(model)
    if model == localPlayer.Character then return end
    local root = model:WaitForChild("HumanoidRootPart", 10)
    local hum = model:WaitForChild("Humanoid", 10)
    if not root or not hum then return end

    local bgui = Instance.new("BillboardGui", root)
    bgui.Name = "GeminiTag"
    bgui.AlwaysOnTop = true
    bgui.Size = UDim2.new(0, 200, 0, 70)
    bgui.ExtentsOffset = Vector3.new(0, 3, 0)

    local txt = Instance.new("TextLabel", bgui)
    txt.Size = UDim2.new(1, 0, 0.7, 0)
    txt.BackgroundTransparency = 1
    txt.Font = Enum.Font.GothamBold
    txt.TextSize = 13
    txt.TextColor3 = Color3.new(1, 1, 1)
    txt.TextStrokeTransparency = 0.5
    txt.RichText = true

    local hpBG = Instance.new("Frame", bgui)
    hpBG.Size = UDim2.new(0.4, 0, 0, 2)
    hpBG.Position = UDim2.new(0.3, 0, 0.8, 0)
    hpBG.BackgroundColor3 = Color3.new(0, 0, 0)
    hpBG.BorderSizePixel = 0
    local hpFill = Instance.new("Frame", hpBG)
    hpFill.Size = UDim2.new(1, 0, 1, 0)
    hpFill.BorderSizePixel = 0

    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not model.Parent or not root.Parent or not ESP_Settings.Enabled then
            bgui.Enabled = false
            if not model.Parent then connection:Disconnect() end
            return
        end

        local p = Players:GetPlayerFromCharacter(model)
        if not p then return end
        
        local isTeam = (p.Team == localPlayer.Team and p.Team ~= nil)
        local show = true
        if isTeam and not ESP_Settings.Teammates then show = false end
        if hum.Health <= 0 then show = false end

        bgui.Enabled = show
        
        if show then
            local dist = math.floor((root.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude)
            local color = isTeam and Color3.new(0, 1, 1) or Color3.new(1, 1, 1)
            
            local nameStr = ""
            if ESP_Settings.Names then
                nameStr = string.format("%s\n<font size='10' color='#BBBBBB'>@%s</font>", p.DisplayName, p.Name)
            end

            local distStr = ESP_Settings.Distance and " ["..dist.."m]" or ""
            
            local bountyStr = ""
            if ESP_Settings.ShowBounty then
                local bty = p:FindFirstChild("leaderstats") and p.leaderstats:FindFirstChild("Bounty")
                if bty then bountyStr = "\n<font color='rgb(255,200,0)'>$"..formatBounty(bty.Value).."</font>" end
            end

            txt.Text = nameStr .. distStr .. bountyStr
            txt.TextColor3 = color
            
            if ESP_Settings.Health then
                hpBG.Visible = true
                local hpPct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                hpFill.Size = UDim2.new(hpPct, 0, 1, 0)
                hpFill.BackgroundColor3 = Color3.fromHSV(hpPct * 0.3, 1, 1)
            else
                hpBG.Visible = false
            end
        end
    end)
end

-- Khởi tạo
for _, p in pairs(Players:GetPlayers()) do
    if p.Character then applyESP(p.Character) end
    p.CharacterAdded:Connect(function(c) applyESP(c) end)
end
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function(c) applyESP(c) end)
end)
