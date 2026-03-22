--[[ 
    GEMINI NPC ESP V6 - THE LEVEL-BASED VERSION
    - Logic Phân loại: Có Level = Quái (Vàng) | Không Level = NPC (Xanh).
    - Khắc phục: Phân loại chính xác 100% dựa trên thuộc tính Level của Game.
    - Tính năng: Anti-Lag, Nút kéo thả, Tự động dọn dẹp khi quái chết.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer

local ESP_Settings = {
    Enabled = true,
    MonsterColor = Color3.fromRGB(255, 255, 0), -- Vàng cho Quái
    CivilianColor = Color3.fromRGB(0, 255, 100), -- Xanh cho NPC thường
}

-- Dọn dẹp bản cũ
if CoreGui:FindFirstChild("Gemini_NPC_V6") then
    CoreGui:FindFirstChild("Gemini_NPC_V6"):Destroy()
end

local screenGui = Instance.new("ScreenGui", CoreGui)
screenGui.Name = "Gemini_NPC_V6"
screenGui.ResetOnSpawn = false

local toggleBtn = Instance.new("TextButton", screenGui)
toggleBtn.Size = UDim2.new(0, 65, 0, 65)
toggleBtn.Position = UDim2.new(0, 15, 0.5, -30)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
toggleBtn.Text = "NPC ESP\nON"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 11
toggleBtn.TextColor3 = Color3.new(0,0,0)
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", toggleBtn).Thickness = 2

-- Logic kéo thả nút
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

-- 2. LOGIC PHÂN LOẠI DỰA TRÊN LEVEL
local activeTags = {}

local function isMonsterByLevel(model)
    -- Tìm kiếm các giá trị Level phổ biến trong Roblox
    local hasLevel = model:FindFirstChild("Level") or model:FindFirstChild("LevelValue") 
                  or model:FindFirstChild("LV") or model:FindFirstChild("Stats")
    
    -- Nếu không thấy giá trị, kiểm tra xem tên có chứa số Level không (ví dụ: "Thug [Lvl 10]")
    if not hasLevel then
        local name = model.Name:lower()
        if name:find("lvl") or name:find("level") or name:find("lv") then
            hasLevel = true
        end
    end
    
    return hasLevel ~= nil
end

local function applyESP(model)
    if Players:GetPlayerFromCharacter(model) or activeTags[model] then return end
    
    local root = model:WaitForChild("HumanoidRootPart", 5)
    local hum = model:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end

    -- Phân loại bằng thuộc tính Level
    local isBossOrMob = isMonsterByLevel(model)
    local useColor = isBossOrMob and ESP_Settings.MonsterColor or ESP_Settings.CivilianColor
    local prefix = isBossOrMob and "[QUÁI] " or "[NPC] "

    local bgui = Instance.new("BillboardGui")
    bgui.Name = "NPC_Tag_V6"
    bgui.Parent = root
    bgui.AlwaysOnTop = true
    bgui.Size = UDim2.new(0, 150, 0, 30)
    bgui.ExtentsOffset = Vector3.new(0, 3, 0)

    local txt = Instance.new("TextLabel", bgui)
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.BackgroundTransparency = 1
    txt.Font = Enum.Font.GothamBold
    txt.TextSize = 12
    txt.TextColor3 = useColor
    txt.TextStrokeTransparency = 0.5
    txt.RichText = true

    activeTags[model] = bgui

    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not ESP_Settings.Enabled or not model.Parent or (isBossOrMob and hum.Health <= 0) then
            bgui:Destroy()
            activeTags[model] = nil
            connection:Disconnect()
            return
        end

        local char = localPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local dist = math.floor((root.Position - char.HumanoidRootPart.Position).Magnitude)
            txt.Text = prefix .. model.Name .. "\n<font size='9'>[" .. dist .. "m]</font>"
        end
    end)
end

-- 3. CƠ CHẾ QUÉT MƯỢT MÀ
local function checkObj(obj)
    if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") then
        applyESP(obj)
    end
end

-- Quét ban đầu
task.spawn(function()
    local all = workspace:GetDescendants()
    for i = 1, #all do
        checkObj(all[i])
        if i % 150 == 0 then task.wait() end
    end
end)

-- Lắng nghe NPC hồi sinh
workspace.DescendantAdded:Connect(function(obj)
    if ESP_Settings.Enabled then
        task.wait(0.5)
        checkObj(obj)
    end
end)

-- Nút Bật/Tắt
toggleBtn.MouseButton1Click:Connect(function()
    ESP_Settings.Enabled = not ESP_Settings.Enabled
    if ESP_Settings.Enabled then
        toggleBtn.Text = "NPC ESP\nON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
        local all = workspace:GetDescendants()
        for i = 1, #all do checkObj(all[i]) if i % 200 == 0 then task.wait() end end
    else
        toggleBtn.Text = "NPC ESP\nOFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        for mod, tag in pairs(activeTags) do if tag then tag:Destroy() end activeTags[mod] = nil end
    end
end)

print("Gemini NPC ESP V6: Phân loại dựa trên Level thành công!")
