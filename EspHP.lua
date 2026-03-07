--Health Esp

local function createESP(plr)
    local function applyESP(char)
        local head = char:WaitForChild("Head", 5)
        if not head then return end

        -- Clean old ESP
        if head:FindFirstChild("HealthESP") then
            head:FindFirstChild("HealthESP"):Destroy()
        end

        -- Create BillboardGui
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "HealthESP"
        billboard.Adornee = head
        billboard.Size = UDim2.new(0, 150, 0, 5)
        billboard.StudsOffset = Vector3.new(0, 25, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = head

        -- Background frame
        local bg = Instance.new("Frame")
        bg.Size = UDim2.new(1, 0, 1, 0)
        bg.BackgroundColor3 = Color3.new(0, 0, 0)
        bg.BackgroundTransparency = 0.5
        bg.BorderSizePixel = 1
        bg.Parent = billboard

        -- Health bar
        local bar = Instance.new("Frame")
        bar.Size = UDim2.new(1, 0, 1, 0)
        bar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        bar.BorderSizePixel = 0
        bar.Parent = bg

        -- Text label
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.new(1, 1, 1)
        label.TextStrokeTransparency = 0.5
        label.TextScaled = true
        label.Font = Enum.Font.GothamBold
        label.Text = "HP: 0 / 0"
        label.Parent = bg

        -- Update loop
        task.spawn(function()
            while char.Parent and plr.Parent do
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    local hp = humanoid.Health
                    local maxHp = humanoid.MaxHealth
                    local ratio = math.clamp(hp / maxHp, 0, 1)

                    bar.Size = UDim2.new(ratio, 0, 1, 0)

                    -- Gradient color
                    if ratio > 0.5 then
                        bar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                    elseif ratio > 0.25 then
                        bar.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
                    else
                        bar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                    end

                    label.Text = "HP: " .. math.floor(hp) .. " / " .. math.floor(maxHp)
                end
                task.wait(0.1)
            end
        end)
    end

    -- Apply to current character
    if plr.Character then
        applyESP(plr.Character)
    end

    -- Listen for respawn
    plr.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        applyESP(char)
    end)
end

-- Apply to all players
for _, plr in pairs(game.Players:GetPlayers()) do
    if plr ~= game.Players.LocalPlayer then
        createESP(plr)
    end
end

-- Handle players who join later
game.Players.PlayerAdded:Connect(function(plr)
    if plr ~= game.Players.LocalPlayer then
        plr.CharacterAdded:Connect(function(char)
            task.wait(0.5)
            createESP(plr)
        end)
    end
end)
