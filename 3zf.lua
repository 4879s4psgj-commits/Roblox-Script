-- إنشاء واجهة المستخدم (GUI) تلقائياً على الشاشة
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleButton = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "EggStealerGui"

MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.Size = UDim2.new(0, 200, 0, 120)
MainFrame.Active = true
MainFrame.Draggable = true -- يمكنك تحريك القائمة بإصبعك على الشاشة

Title.Parent = MainFrame
Title.Text = "مستكشف البيض النادر"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16

ToggleButton.Parent = MainFrame
ToggleButton.Text = "تشغيل السرقة التلقائية: إيقاف"
ToggleButton.Size = UDim2.new(0.9, 0, 0, 50)
ToggleButton.Position = UDim2.new(0.05, 0, 0.45, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 14

-- المتغيرات الأساسية للسكربت
_G.SecretFarm = false
local TargetEggs = {"secret", "divine", "void", "mythic", "event"}

local function isRareEgg(eggName)
    for _, rareName in pairs(TargetEggs) do
        if string.find(string.lower(eggName), rareName) then
            return true
        end
    end
    return false
end

-- تشغيل السكربت في الخلفية عند تفعيل الزر
task.spawn(function()
    while true do
        task.wait(0.3)
        if _G.SecretFarm then
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            local eggFolder = game.Workspace:FindFirstChild("Eggs") or game.Workspace
            
            if rootPart then
                for _, object in pairs(eggFolder:GetChildren()) do
                    if isRareEgg(object.Name) then
                        local targetPart = object:IsA("BasePart") and object or object:FindFirstChildWhichIsA("BasePart")
                        if targetPart then
                            -- الانتقال فوق البيضة النادرة مباشرة
                            rootPart.CFrame = targetPart.CFrame + Vector3.new(0, 3, 0)
                            task.wait(0.1)
                            
                            -- تفعيل زر السرقة
                            local prompt = object:FindFirstChildOfClass("ProximityPrompt") or object:GetComponentOfClass("ProximityPrompt")
                            if prompt then
                                fireproximityprompt(prompt, 1)
                            end
                            break 
                        end
                    end
                end
            end
        end
    end
end)

-- برمجة تفاعل الزر عند الضغط عليه
ToggleButton.MouseButton1Click:Connect(function()
    _G.SecretFarm = not _G.SecretFarm
    if _G.SecretFarm then
        ToggleButton.Text = "تشغيل السرقة التلقائية: يعمل"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    else
        ToggleButton.Text = "تشغيل السرقة التلقائية: إيقاف"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end
end)
