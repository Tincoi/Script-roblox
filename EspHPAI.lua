local Players = game:GetService("Players")

local function createHealthBar(character)
    local humanoid = character:WaitForChild("Humanoid")
    local head = character:WaitForChild("Head")

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "HealthBar"
    billboard.Adornee = head
    billboard.Size = UDim2.new(4,0,0.5,0)
    billboard.StudsOffset = Vector3.new(0,3,0)
    billboard.AlwaysOnTop = true
    billboard.Parent = head

    local background = Instance.new("Frame")
    background.Size = UDim2.new(1,0,1,0)
    background.BackgroundColor3 = Color3.fromRGB(50,50,50)
    background.BorderSizePixel = 0
    background.Parent = billboard

    local health = Instance.new("Frame")
    health.Name = "Health"
    health.Size = UDim2.new(1,0,1,0)
    health.BackgroundColor3 = Color3.fromRGB(0,255,0)
    health.BorderSizePixel = 0
    health.Parent = background

    humanoid.HealthChanged:Connect(function()
        local percent = humanoid.Health / humanoid.MaxHealth
        health.Size = UDim2.new(percent,0,1,0)

        if percent < 0.3 then
            health.BackgroundColor3 = Color3.fromRGB(255,0,0)
        elseif percent < 0.6 then
            health.BackgroundColor3 = Color3.fromRGB(255,170,0)
        else
            health.BackgroundColor3 = Color3.fromRGB(0,255,0)
        end
    end)
end

local function playerAdded(player)
    player.CharacterAdded:Connect(function(character)
        createHealthBar(character)
    end)
end

for _,player in pairs(Players:GetPlayers()) do
    playerAdded(player)
end

Players.PlayerAdded:Connect(playerAdded)
