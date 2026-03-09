--[[ 
    TELEPORT GUI V9.1 (FIXED SPECTATE)
    - Chức năng: Tự động tắt View khi nhấn Teleport.
    - Cập nhật: Nút mở lại menu di chuyển được (Draggable).
    - Tối ưu: Sửa lỗi kẹt Camera khi dịch chuyển trên Mobile.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

if CoreGui:FindFirstChild("GeminiTP_V9_Fixed") then
    CoreGui:FindFirstChild("GeminiTP_V9_Fixed"):Destroy()
end

-- 1. GIAO DIỆN
local screenGui = Instance.new("ScreenGui", CoreGui)
screenGui.Name = "GeminiTP_V9_Fixed"

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 250, 0, 300)
mainFrame.Position = UDim2.new(0.5, -125, 0.4, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.Active = true
mainFrame.Draggable = true 
Instance.new("UICorner", mainFrame)
Instance.new("UIStroke", mainFrame).Color = Color3.fromRGB(0, 255, 150)

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "TELEPORT & VIEW V9.1"
title.TextColor3 = Color3.fromRGB(0, 255, 150)
title.Font = Enum.Font.GothamBold
title.BackgroundTransparency = 1

local scrollingFrame = Instance.new("ScrollingFrame", mainFrame)
scrollingFrame.Size = UDim2.new(1, -10, 1, -50)
scrollingFrame.Position = UDim2.new(0, 5, 0, 45)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 1000)
scrollingFrame.ScrollBarThickness = 2
local layout = Instance.new("UIListLayout", scrollingFrame)
layout.Padding = UDim.new(0, 5)

-- Nút mở menu di chuyển được
local openBtn = Instance.new("TextButton", screenGui)
openBtn.Size = UDim2.new(0, 50, 0, 50)
openBtn.Position = UDim2.new(0, 10, 0.5, 0)
openBtn.Text = "TP"
openBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
openBtn.Font = Enum.Font.GothamBold
openBtn.Visible = false
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1, 0)

-- Hàm kéo thả cho nút TP
local function makeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true dragStart = input.Position startPos = gui.Position
        end
    end)
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end
makeDraggable(openBtn)

-- 2. HÀM XỬ LÝ CHÍNH
local isViewing = false
local targetPlayer = nil

local function stopViewing()
    isViewing = false
    camera.CameraSubject = localPlayer.Character:FindFirstChildOfClass("Humanoid")
    targetPlayer = nil
end

local function updateList()
    for _, child in pairs(scrollingFrame:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= localPlayer then
            local pFrame = Instance.new("Frame", scrollingFrame)
            pFrame.Size = UDim2.new(0.95, 0, 0, 40)
            pFrame.BackgroundTransparency = 0.8
            pFrame.BackgroundColor3 = Color3.new(1, 1, 1)
            Instance.new("UICorner", pFrame)

            local pName = Instance.new("TextLabel", pFrame)
            pName.Size = UDim2.new(0.5, 0, 1, 0)
            pName.Text = p.Name
            pName.TextColor3 = Color3.new(1, 1, 1)
            pName.BackgroundTransparency = 1
            pName.Font = Enum.Font.GothamMedium
            pName.TextXAlignment = Enum.TextXAlignment.Left
            pName.Position = UDim2.new(0, 5, 0, 0)

            -- NÚT TELEPORT (CÓ TỰ ĐỘNG TẮT VIEW)
            local tpBtn = Instance.new("TextButton", pFrame)
            tpBtn.Size = UDim2.new(0, 40, 0, 30)
            tpBtn.Position = UDim2.new(1, -90, 0.5, -15)
            tpBtn.Text = "TP"
            tpBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
            Instance.new("UICorner", tpBtn)

            tpBtn.MouseButton1Click:Connect(function()
                -- Bước 1: Tắt View trước khi TP
                stopViewing()
                
                -- Bước 2: Thực hiện TP
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    localPlayer.Character:SetPrimaryPartCFrame(p.Character.HumanoidRootPart.CFrame)
                end
            end)

            -- NÚT VIEW
            local viewBtn = Instance.new("TextButton", pFrame)
            viewBtn.Size = UDim2.new(0, 40, 0, 30)
            viewBtn.Position = UDim2.new(1, -45, 0.5, -15)
            viewBtn.Text = "VIEW"
            viewBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
            Instance.new("UICorner", viewBtn)

            viewBtn.MouseButton1Click:Connect(function()
                if isViewing and targetPlayer == p then
                    stopViewing()
                    viewBtn.Text = "VIEW"
                    viewBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
                else
                    isViewing = true
                    targetPlayer = p
                    camera.CameraSubject = p.Character:FindFirstChildOfClass("Humanoid")
                    viewBtn.Text = "UNVIEW"
                    viewBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                end
            end)
        end
    end
end

-- Close/Open Logic
local closeBtn = Instance.new("TextButton", mainFrame)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
Instance.new("UICorner", closeBtn)

closeBtn.MouseButton1Click:Connect(function() mainFrame.Visible = false openBtn.Visible = true end)
openBtn.MouseButton1Click:Connect(function() mainFrame.Visible = true openBtn.Visible = false end)

-- Refresh danh sách tự động
spawn(function()
    while wait(3) do
        if mainFrame.Visible then updateList() end
    end
end)

updateList()
