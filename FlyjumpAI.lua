--[[
    FAST INFINITE JUMP
    - Chức năng: Bay lên cực nhanh khi nhấn giữ nút nhảy.
    - Tùy chỉnh: Thay đổi giá trị FlySpeed để tăng/giảm tốc độ bay.
]]

local InfiniteJumpEnabled = true
local FlySpeed = 80 -- Tăng số này nếu muốn bay nhanh hơn nữa (Mặc định Roblox khoảng 50)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfiniteJumpEnabled then
        local character = game:GetService("Players").LocalPlayer.Character
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")

        if humanoid and rootPart then
            -- Ép trạng thái nhảy
            humanoid:ChangeState("Jumping")
            
            -- Cộng thêm lực đẩy thẳng đứng để bay nhanh hơn
            rootPart.Velocity = Vector3.new(rootPart.Velocity.X, FlySpeed, rootPart.Velocity.Z)
        end
    end
end)
