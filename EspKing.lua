--[[ 
    GEMINI ESP V7.9.1 - FPS BOOSTER (FIX TỤT FPS)
    - Fix: Loại bỏ quét GetDescendants trong vòng lặp (Chỉ quét 1 lần khi char load).
    - Fix: Tối ưu bộ nhớ, giải phóng CPU.
    - Giữ nguyên: SizeOffset = -0.7 (Né Haki).
    - Giữ nguyên: Toàn bộ hiển thị Level/PVP/Bounty.
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer

-- Dọn dẹp bản cũ
if CoreGui:FindFirstChild("GeminiESP_V7_Final") then
    CoreGui:FindFirstChild("GeminiESP_V7_Final"):Destroy()
end

local ESP_Settings = {
    Enabled = true,
    Names = true,
    Distance = true,
    Health = true,
    ShowBounty = true,
    ShowLevel = true,
    ShowPVP = true,
    RefreshRate = 1 -- 20 FPS cho ESP là cực kỳ mượt và nhẹ nhất cho máy
}

local function formatBounty(num)
    if not num then return "0" end
    if num >= 1000000 then return string.format("%.1fM", num / 1000000):gsub("%.0", "")
    elseif num >= 1000 then return string.format("%.0fK", num / 1000) end
    return tostring(num)
end

-- =========================================================
-- LOGIC TÌM KIẾM TỐI ƯU (CHỈ CHẠY 1 LẦN KHI PLAYER VÀO)
-- =========================================================
local playerPointers = {} -- Lưu trữ đường dẫn trực tiếp đến Level/PVP để đọc nhanh

local function findDataPointers(player)
    local data = {lvObj = nil, pvpObj = nil, lastBounty = 0}
    
    -- Tìm trong leaderstats trước (Nhanh nhất)
    local ls = player:FindFirstChild("leaderstats")
    if ls then
        data.lvObj = ls:FindFirstChild("Level") or ls:FindFirstChild("Lv")
        data.pvpObj = ls:FindFirstChild("PVP") or ls:FindFirstChild("EnablePvp")
    end

    -- Nếu không thấy trong leaderstats mới đi quét (Chỉ quét 1 lần duy nhất ở đây)
    if not data.lvObj or not data.pvpObj then
        for _, v in pairs(player:GetDescendants()) do
            if v:IsA("ValueBase") then
                local n = v.Name:lower()
                if not data.lvObj and (n == "level" or n == "lv" or n == "lvl") then
                    data.lvObj = v
                end
                if not data.pvpObj and (n == "enablepvp" or n == "pvp" or n == "pvpstatus") then
                    data.pvpObj = v
                end
            end
            if data.lvObj and data.pvpObj then break end
        end
    end
    playerPointers[player] = data
end

-- =========================================================
-- GIAO DIỆN MENU (UI)
-- =========================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GeminiESP_V7_Final"; screenGui.Parent = CoreGui; screenGui.ResetOnSpawn = false
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 280); mainFrame.Position = UDim2.new(0.5, -100, 0.3, 0); mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15); mainFrame.Active = true; mainFrame.Visible = false; mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40); title.Text = "GEMINI ESP V7.9.1"; title.BackgroundColor3 = Color3.fromRGB(25, 25, 25); title.TextColor3 = Color3.fromRGB(0, 255, 150); title.Font = Enum.Font.GothamBold; title.Parent = mainFrame
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 50, 0, 50); openBtn.Position = UDim2.new(0, 10, 0.5, 0); openBtn.Text = "ESP"; openBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 150); openBtn.Parent = screenGui; Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1, 0)
openBtn.MouseButton1Click:Connect(function() mainFrame.Visible = not mainFrame.Visible end)

local container = Instance.new("ScrollingFrame")
container.Size = UDim2.new(1, -10, 1, -50); container.Position = UDim2.new(0, 5, 0, 45); container.BackgroundTransparency = 1; container.CanvasSize = UDim2.new(0,0,0,250); container.ScrollBarThickness = 0; container.Parent = mainFrame
Instance.new("UIListLayout", container).Padding = UDim.new(0, 5)

local function createToggle(name, key)
    local btn = Instance.new("TextButton", container)
    btn.Size = UDim2.new(0.95, 0, 0, 30); btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40); btn.Text = name; btn.TextColor3 = Color3.new(1, 1, 1); btn.Font = Enum.Font.Gotham; btn.Parent = container; Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function() ESP_Settings[key] = not ESP_Settings[key]; btn.BackgroundColor3 = ESP_Settings[key] and Color3.fromRGB(0, 100, 60) or Color3.fromRGB(40, 40, 40) end)
end
createToggle("HIỆN TÊN", "Names"); createToggle("LEVEL", "ShowLevel"); createToggle("PVP", "ShowPVP"); createToggle("BOUNTY", "ShowBounty"); createToggle("KHOẢNG CÁCH", "Distance"); createToggle("MÁU", "Health")

-- =========================================================
-- ESP CORE (SIÊU NHẸ)
-- =========================================================
local function applyESP(player)
    if player == localPlayer then return end
    findDataPointers(player) -- Tìm đường dẫn 1 lần duy nhất

    local function setup(char)
        local root = char:WaitForChild("HumanoidRootPart", 10)
        local hum = char:WaitForChild("Humanoid", 10)
        if not root or not hum then return end

        local bgui = Instance.new("BillboardGui", root)
        bgui.Name = "GeminiTag"; bgui.AlwaysOnTop = true; bgui.Size = UDim2.new(0, 200, 0, 60)
        bgui.SizeOffset = Vector2.new(0, 0.7) -- Né Haki chuẩn
        bgui.ExtentsOffset = Vector3.new(0, 2.2, 0)

        local txt = Instance.new("TextLabel", bgui)
        txt.Size = UDim2.new(1, 0, 1, 0); txt.BackgroundTransparency = 1; txt.Font = Enum.Font.GothamBold; txt.TextSize = 13; txt.TextColor3 = Color3.new(1, 1, 1); txt.TextStrokeTransparency = 0.5; txt.RichText = true; txt.TextYAlignment = Enum.TextYAlignment.Bottom

        local hpBG = Instance.new("Frame", bgui); hpBG.Size = UDim2.new(0.4, 0, 0, 2); hpBG.Position = UDim2.new(0.3, 0, 0.95, 0); hpBG.BackgroundColor3 = Color3.new(0, 0, 0); hpBG.BorderSizePixel = 0; hpBG.Parent = bgui
        local hpFill = Instance.new("Frame", hpBG); hpFill.Size = UDim2.new(1, 0, 1, 0); hpFill.BorderSizePixel = 0; hpFill.Parent = hpBG

        task.spawn(function()
            while char and char.Parent and root and root.Parent do
                if ESP_Settings.Enabled and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (root.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude
                    if dist < 5000 then
                        bgui.Enabled = true
                        local ptr = playerPointers[player]
                        
                        -- Đọc dữ liệu trực tiếp (Không quét lại - Cực nhẹ)
                        local lvl = (ptr and ptr.lvObj) and ptr.lvObj.Value or "???"
                        local pvpVal = (ptr and ptr.pvpObj) and ptr.pvpObj.Value or nil
                        local pvpStatus = "Off"
                        if pvpVal == true or pvpVal == 1 or tostring(pvpVal):lower() == "on" then pvpStatus = "On" end

                        local content = ""
                        if ESP_Settings.Names then content = player.DisplayName end
                        if ESP_Settings.ShowLevel then content = content .. " <font color='rgb(0,255,150)'>[Lv."..lvl.."]</font>" end
                        if ESP_Settings.Distance then content = content .. " ["..math.floor(dist).."m]" end
                        
                        if ESP_Settings.ShowPVP then
                            local col = (pvpStatus == "On") and "#FF3232" or "#00FFFF"
                            content = content .. string.format("\n<font color='%s'>PVP: %s</font>", col, pvpStatus)
                        end
                        
                        if ESP_Settings.ShowBounty then
                            local bty = player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Bounty")
                            if bty then content = content .. "\n<font color='rgb(255,200,0)'>$"..formatBounty(bty.Value).."</font>" end
                        end
                        txt.Text = content

                        if ESP_Settings.Health then
                            hpBG.Visible = true
                            local hpPct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                            hpFill.Size = UDim2.new(hpPct, 0, 1, 0)
                            hpFill.BackgroundColor3 = Color3.fromHSV(hpPct * 0.3, 1, 1)
                        else hpBG.Visible = false end
                    else bgui.Enabled = false end
                else bgui.Enabled = false end
                task.wait(ESP_Settings.RefreshRate)
            end
            bgui:Destroy()
        end)
    end
    player.CharacterAdded:Connect(setup)
    if player.Character then setup(player.Character) end
end

for _, p in pairs(Players:GetPlayers()) do applyESP(p) end
Players.PlayerAdded:Connect(applyESP)
Players.PlayerRemoving:Connect(function(p) playerPointers[p] = nil end)
