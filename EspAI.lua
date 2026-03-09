--[[ 
    GEMINI ESP V6 (BOUNTY + DRAGGABLE BUTTON)
    - Giữ nguyên toàn bộ logic V6 và Bounty rút gọn.
    - Cập nhật: Nút "ESP" tròn bây giờ có thể cầm và kéo đi bất cứ đâu trên màn hình.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("GeminiESP_V6_Final") then
    CoreGui:FindFirstChild("GeminiESP_V6_Final"):Destroy()
end

local ESP_Settings = {
    Enabled = true,
    Names = true,
    Distance = true,
    Health = true,
    Teammates = true, 
    NPCs = false,
    ShowBounty = true
}

-- Hàm rút gọn số Bounty
local function formatBounty(num)
    if num >= 1000000 then
        return string.format("%.1fM", num / 1000000):gsub("%.0", "")
    elseif num >= 1000 then
        return string.format("%.0fK", num / 1000)
    end
    return tostring(num)
end

-- 1. GIAO DIỆN CHÍNH
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GeminiESP_V6_Final"
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

-- NÚT ESP (CẬP NHẬT KHẢ NĂNG DI CHUYỂN)
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 55, 0, 55)
openBtn.Position = UDim2.new(0, 15, 0.5, 0)
openBtn.Text = "ESP"
openBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
openBtn.Font = Enum.Font.GothamBold
openBtn.Visible = false
openBtn.Parent = screenGui
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1, 0)

-- Hàm xử lý kéo thả cho nút ESP (Dành cho Mobile)
local function makeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end
makeDraggable(openBtn)

local container = Instance.new("ScrollingFrame")
container.Size = UDim2.new(1, -10, 1, -55)
container.Position = UDim2.new(0, 5, 0, 50)
container.BackgroundTransparency = 1
container.CanvasSize = UDim2.new(0,0,0,320)
container.ScrollBarThickness = 0
container.Parent = mainFrame
Instance.new("UIListLayout", container).Padding = UDim.new(0, 5)

closeBtn.MouseButton1Click:Connect(function() mainFrame.Visible = false openBtn.Visible = true end)
openBtn.MouseButton1Click:Connect(function() 
    if mainFrame.Visible == false then
        mainFrame.Visible = true 
        openBtn.Visible = false 
    end
end)

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
createToggle("HIỆN BOUNTY", "ShowBounty")
createToggle("HIỆN KHOẢNG CÁCH", "Distance")
createToggle("HIỆN MÁU PLAYER", "Health")
createToggle("HIỆN ĐỒNG ĐỘI", "Teammates")
createToggle("HIỆN NPC", "NPCs")

-- 2. LOGIC ESP CORE
local function applyESP(model, isNPC)
    if model == localPlayer.Character then return end
    local root = model:WaitForChild("HumanoidRootPart", 10)
    if not root then return end

    local bgui = Instance.new("BillboardGui", root)
    bgui.Name = "GeminiTag"
    bgui.AlwaysOnTop = true
    bgui.Size = UDim2.new(0, 200, 0, 60)
    bgui.ExtentsOffset = Vector3.new(0, 3.5, 0)

    local txt = Instance.new("TextLabel", bgui)
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.BackgroundTransparency = 1
    txt.Font = Enum.Font.GothamBold
    txt.TextSize = 14
    txt.TextStrokeTransparency = 0
    txt.RichText = true

    local hpBG, hpFill
    if not isNPC then
        hpBG = Instance.new("Frame", bgui)
        hpBG.Size = UDim2.new(0.4, 0, 0, 3)
        hpBG.Position = UDim2.new(0.3, 0, 0.85, 0)
        hpBG.BackgroundColor3 = Color3.new(0, 0, 0)
        hpBG.BorderSizePixel = 0
        hpFill = Instance.new("Frame", hpBG)
        hpFill.Size = UDim2.new(1, 0, 1, 0)
        hpFill.BorderSizePixel = 0
    end

    RunService.RenderStepped:Connect(function()
        if not model or not model.Parent or not ESP_Settings.Enabled then
            bgui.Enabled = false return
        end

        local hum = model:FindFirstChildOfClass("Humanoid")
        local p = Players:GetPlayerFromCharacter(model)
        
        local isTeam = (p and p.Team == localPlayer.Team and p.Team ~= nil)
        local color = isNPC and Color3.new(1, 1, 0) or (isTeam and Color3.new(0, 1, 1) or Color3.new(1, 1, 1))

        local show = true
        if isTeam and not ESP_Settings.Teammates then show = false end
        if isNPC and not ESP_Settings.NPCs then show = false end
        if hum and hum.Health <= 0 then show = false end

        bgui.Enabled = show

        if show then
            local dist = math.floor((root.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude)
            
            local bountyStr = ""
            if p and ESP_Settings.ShowBounty then
                local bty = p:FindFirstChild("leaderstats") and p.leaderstats:FindFirstChild("Bounty")
                if bty then
                    bountyStr = "\n<font color=\"rgb(255,200,0)\">$"..formatBounty(bty.Value).."</font>"
                end
            end

            local nStr = ESP_Settings.Names and (p and "@"..p.Name or model.Name) or ""
            local dStr = ESP_Settings.Distance and " ["..dist.."m]" or ""
            
            txt.Text = nStr .. dStr .. bountyStr
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

-- Khởi tạo
for _, p in pairs(Players:GetPlayers()) do if p.Character then applyESP(p.Character, false) end p.CharacterAdded:Connect(function(c) applyESP(c, false) end) end
Players.PlayerAdded:Connect(function(p) p.CharacterAdded:Connect(function(c) applyESP(c, false) end) end)
task.spawn(function() while task.wait(5) do for _, m in pairs(workspace:GetDescendants()) do if m:IsA("Model") and m:FindFirstChildOfClass("Humanoid") and m:FindFirstChild("HumanoidRootPart") and not Players:GetPlayerFromCharacter(m) and not m.HumanoidRootPart:FindFirstChild("GeminiTag") then applyESP(m, true) end end end end)
