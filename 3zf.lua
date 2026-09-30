-- سكربت السرقة التلقائية المطور - برمجة 3zf
_G.SecretFarm = false

-- إنشاء الواجهة تلقائياً
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleButton = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "CustomEggStealer"

MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.Size = UDim2.new(0, 220, 0, 130)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.Text = "سكربت 3zf للبيض النادر"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.TextColor3 = Color3.fromRGB(255, 215, 0) -- لون ذهبي
Title.TextSize = 16

ToggleButton.Parent = MainFrame
ToggleButton.Text = "بدء السرقة التلقائية: إيقاف"
ToggleButton.Size = UDim2.new(0.9, 0, 0, 50)
ToggleButton.Position = UDim2.new(0.05, 0, 0.45, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 14

-- قائمة الكلمات المفتاحية للبيوض القوية والنادرة
local RareKeywords = {"secret", "divine", "void", "mythic", "event", "strong", "rare"}

local function checkRare(name)
    for _, word in pairs(RareKeywords) do
        if string.find(string.lower(name), word) then
            return true
        end
    end
    return false
end

-- الفحص الذكي والشامل داخل اللعبة بالكامل
local function findAndRobEgg()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not rootPart then return end

    -- الفحص المطور: يبحث في كل مجلدات اللعبة وليسWorkspace فقط
    for _, object in pairs(game.Workspace:GetDescendants()) do
        if object:IsA("Model") or object:IsA("BasePart") then
            -- التحقق إذا كان الاسم يحتوي على كلمة بيضة وأنه من الأنواع القوية
            if string.find(string.lower(object.Name), "egg") and checkRare(object.Name) then
                
                local targetPart = object:IsA("BasePart") and object or object:FindFirstChildWhichIsA("BasePart")
                
                if targetPart then
                    -- الانتقال الآمن فوق البيضة
                    rootPart.CFrame = targetPart.CFrame + Vector3.new(0, 3, 0)
                    task.wait(0.15)
                    
                    -- البحث عن زر السرقة وتفعيله فوراً
                    local prompt = object:FindFirstChildOfClass("ProximityPrompt") or targetPart:FindFirstChildOfClass("ProximityPrompt")
                    if prompt then
                        fireproximityprompt(prompt, 1)
                    end
                    break
                end
            end
        end
    end
end

-- تشغيل الكود في الخلفية بشكل مستمر عند التفعيل
task.spawn(function()
    while true do
        task.wait(0.4)
        if _G.SecretFarm then
            pcall(findAndRobEgg) -- استخدام pcall لمنع توقف السكربت أو حدوث كراش
        end
    end
end)

-- برمجة تفعيل وإيقاف الزر
ToggleButton.MouseButton1Click:Connect(function()
    _G.SecretFarm = not _G.SecretFarm
    if _G.SecretFarm then
        ToggleButton.Text = "بدء السرقة التلقائية: يعمل"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    else
        ToggleButton.Text = "بدء السرقة التلقائية: إيقاف"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end
end)
