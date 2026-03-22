--[[ 
    GEMINI NPC ESP V3 - ULTRA SMOOTH (ANTI-LAG)
    - Loại bỏ hoàn toàn hiện tượng khựng (Lag Spike).
    - Tối ưu hóa bộ nhớ: Tự động dọn dẹp Tag khi NPC chết/tắt.
    - Màu Vàng (Yellow), Nút kéo thả tiện lợi.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer

-- Cấu hình
local ESP_Settings = {
    Enabled = true,
    Color = Color3.fromRGB(255, 255, 0),
}

-- 1. GIAO DIỆN NÚT (GIỮ NGUYÊN KHẢ NĂNG KÉO THẢ)
local screenGui = Instance.new("ScreenGui", CoreGui)
screenGui.Name = "Gemini_NPC_V3"
screenGui.ResetOnSpawn = false

local toggleBtn = Instance.new("TextButton", screenGui)
toggleBtn.Size = UDim2.new(0, 60, 0, 60)
toggleBtn.Position = UDim2.new(0, 15, 0.5, -30)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
toggleBtn.Text = "NPC\nON"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 12
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", toggleBtn).Thickness = 2

-- Logic kéo thả mượt mà
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
makeDraggable(toggleBtn)

-- 2. LOGIC ESP TỐI ƯU (DÙNG CACHE)
local activeTags = {}

local function applyESP(model)
    if Players:GetPlayerFromCharacter(model) or activeTags[model] then return end
    local root = model:FindFirstChild("HumanoidRootPart")
    local hum = model:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end

    local bgui = Instance.new("BillboardGui")
    bgui.Name = "NPC_Tag_V3"
    bgui.Parent = root
    bgui.AlwaysOnTop = true
    bgui.Size = UDim2.new(0, 150, 0, 30)
    bgui.ExtentsOffset = Vector3.new(0, 3, 0)

    local txt = Instance.new("TextLabel", bgui)
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.BackgroundTransparency = 1
    txt.Font = Enum.Font.GothamBold
    txt.TextSize = 13
    txt.TextColor3 = ESP_Settings.Color
    txt.TextStrokeTransparency = 0.5
    txt.RichText = true

    activeTags[model] = bgui

    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not ESP_Settings.Enabled or not model.Parent or hum.Health <= 0 then
            bgui:Destroy()
            activeTags[model] = nil
            connection:Disconnect()
            return
        end

        local char = localPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local dist = math.floor((root.Position - char.HumanoidRootPart.Position).Magnitude)
            txt.Text = model.Name .. "\n<font size='10'>[" .. dist .. "m]</font>"
        end
    end)
end

-- 3. CƠ CHẾ QUÉT KHÔNG LAG (EVENT-BASED)
local function checkObj(obj)
    if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") then
        applyESP(obj)
    end
end

-- Lắng nghe sự kiện cực nhẹ
workspace.DescendantAdded:Connect(function(obj)
    if ESP_Settings.Enabled then
        task.wait(0.5) -- Đợi NPC load xong tránh lag
        checkObj(obj)
    end
end)

-- Quét lần đầu (Chỉ thực hiện 1 lần duy nhất khi chạy script)
task.spawn(function()
    local all = workspace:GetDescendants()
    for i = 1, #all do
        checkObj(all[i])
        if i % 100 == 0 then task.wait() end -- Chia nhỏ tác vụ để không khựng FPS
    end
end)

-- Nút Bật/Tắt
toggleBtn.MouseButton1Click:Connect(function()
    ESP_Settings.Enabled = not ESP_Settings.Enabled
    if ESP_Settings.Enabled then
        toggleBtn.Text = "NPC\nON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
        -- Quét lại khi bật
        for _, v in pairs(workspace:GetDescendants()) do checkObj(v) end
    else
        toggleBtn.Text = "NPC\nOFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        -- Xóa sạch tag ngay lập tức
        for mod, tag in pairs(activeTags) do
            if tag then tag:Destroy() end
            activeTags[mod] = nil
        end
    end
end)

print("Gemini NPC ESP V3: Đã tối ưu chống lag thành công!")
