--[[ 
    GEMINI ESP V6 (USERNAME EDITION)
    - Tên hiển thị: Chuyển sang định dạng @Username.
    - Hiệu suất: Thanh máu chỉ dành cho Player, tối ưu cực nhẹ.
    - Mặc định: Bật tất cả trừ NPC.
    - Màu sắc: Địch (Trắng), Đồng đội (Xanh Cyan), NPC (Vàng).
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local localPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("GeminiESP_V6") then
    CoreGui:FindFirstChild("GeminiESP_V6"):Destroy()
end

local ESP_Settings = {
    Enabled = true,
    Names = true,
    Distance = true,
    Health = true,
    Teammates = true, 
    NPCs = false 
}

-- 1. GIAO DIỆN
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GeminiESP_V6"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 320)
mainFrame.Position = UDim2.new(0.5, 140, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.Active = true
mainFrame.Draggable = true 
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", mainFrame).Color = Color3.fromRGB(0, 255, 150)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.Text = "GEMINI ESP V6"
title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
title.TextColor3 = Color3.fromRGB(0, 255, 150)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = mainFrame
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 10)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 7)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Parent = mainFrame
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 55, 0, 55)
openBtn.Position = UDim2.new(0, 15, 0.5, 110)
openBtn.Text = "ESP"
openBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
openBtn.Font = Enum.Font.GothamBold
openBtn.Visible = false
openBtn.Parent = screenGui
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1, 0)

local container = Instance.new("ScrollingFrame")
container.Size = UDim2.new(1, -10, 1, -55)
container.Position = UDim2.new(0, 5, 0, 50)
container.BackgroundTransparency = 1
container.CanvasSize = UDim2.new(0,0,0,300)
container.ScrollBarThickness = 0
container.Parent = mainFrame
Instance.new("UIListLayout", container).Padding = UDim.new(0, 5)

closeBtn.MouseButton1Click:Connect(function() mainFrame.Visible = false openBtn.Visible = true end)
openBtn.MouseButton1Click:Connect(function() mainFrame.Visible = true openBtn.Visible = false end)

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
createToggle("HIỆN TÊN (@)", "Names")
createToggle("HIỆN KHOẢNG CÁCH", "Distance")
createToggle("HIỆN MÁU PLAYER", "Health")
createToggle("HIỆN ĐỒNG ĐỘI", "Teammates")
createToggle("HIỆN NPC", "NPCs")

-- 2. LOGIC ESP CORE (USERNAME)
local function applyESP(model, isNPC)
    if model == localPlayer.Character then return end

    local root = model:WaitForChild("HumanoidRootPart", 10)
    if not root then return end

    local bgui = Instance.new("BillboardGui", root)
    bgui.Name = "GeminiTag"
    bgui.AlwaysOnTop = true
    bgui.Size = UDim2.new(0, 200, 0, 50)
    bgui.ExtentsOffset = Vector3.new(0, 3, 0)

    local txt = Instance.new("TextLabel", bgui)
    txt.Size = UDim2.new(1, 0, 0.7, 0)
    txt.BackgroundTransparency = 1
    txt.Font = Enum.Font.GothamBold
    txt.TextSize = 14
    txt.TextStrokeTransparency = 0

    local hpBG, hpFill
    if not isNPC then
        hpBG = Instance.new("Frame", bgui)
        hpBG.Size = UDim2.new(0.4, 0, 0, 3)
        hpBG.Position = UDim2.new(0.3, 0, 0.75, 0)
        hpBG.BackgroundColor3 = Color3.new(0, 0, 0)
        hpBG.BorderSizePixel = 0
        
        hpFill = Instance.new("Frame", hpBG)
        hpFill.Size = UDim2.new(1, 0, 1, 0)
        hpFill.BorderSizePixel = 0
    end

    RunService.RenderStepped:Connect(function()
        if not model or not model.Parent or not ESP_Settings.Enabled then
            bgui.Enabled = false
            return
        end

        local hum = model:FindFirstChildOfClass("Humanoid")
        local p = Players:GetPlayerFromCharacter(model)
        
        local isTeam = false
        if p and p.Team == localPlayer.Team and p.Team ~= nil then
            isTeam = true
        end

        local color = Color3.new(1, 1, 1) -- Địch: Trắng
        if isNPC then
            color = Color3.new(1, 1, 0) -- NPC: Vàng
        elseif isTeam then
            color = Color3.new(0, 1, 1) -- Đồng đội: Xanh Cyan
        end

        local show = true
        if isTeam and not ESP_Settings.Teammates then show = false end
        if isNPC and not ESP_Settings.NPCs then show = false end
        if hum and hum.Health <= 0 then show = false end

        bgui.Enabled = show

        if show then
            local dist = math.floor((root.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude)
            
            -- ĐỔI SANG @USERNAME CHO PLAYER
            local nameToDisplay = ""
            if p then
                nameToDisplay = "@" .. p.Name -- Sử dụng Username
            else
                nameToDisplay = model.Name -- Giữ nguyên tên gốc nếu là NPC
            end

            local nStr = ESP_Settings.Names and nameToDisplay or ""
            local dStr = ESP_Settings.Distance and " ["..dist.."m]" or ""
            
            txt.Text = nStr .. dStr
            txt.TextColor3 = color

            if not isNPC and hum and ESP_Settings.Health then
                hpBG.Visible = true
                hpFill.Size = UDim2.new(math.clamp(hum.Health/hum.MaxHealth, 0, 1), 0, 1, 0)
                hpFill.BackgroundColor3 = Color3.fromHSV((math.clamp(hum.Health/hum.MaxHealth, 0, 1))*0.3, 1, 1)
            elseif hpBG then
                hpBG.Visible = false
            end
        end
    end)
end

-- Theo dõi Player
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function(c) applyESP(c, false) end)
end)
for _, p in pairs(Players:GetPlayers()) do
    if p.Character then applyESP(p.Character, false) end
end

-- Quét NPC định kỳ
task.spawn(function()
    while task.wait(5) do
        for _, m in pairs(workspace:GetDescendants()) do
            if m:IsA("Model") and m:FindFirstChildOfClass("Humanoid") and m:FindFirstChild("HumanoidRootPart") then
                if not Players:GetPlayerFromCharacter(m) and not m.HumanoidRootPart:FindFirstChild("GeminiTag") then
                    applyESP(m, true)
                end
            end
        end
    end
end)
