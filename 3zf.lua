-- تفعيل الميزات تلقائياً
_G.AutoSteal = true
_G.ShowEggList = true

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

-- 1. واجهة الرادار المحدثة (تبحث في كل مكان)
if _G.ShowEggList and not CoreGui:FindFirstChild("EggRadarUI") then
    local ScreenGui = Instance.new("ScreenGui", CoreGui)
    ScreenGui.Name = "EggRadarUI"
    
    local Frame = Instance.new("Frame", ScreenGui)
    Frame.Size = UDim2.new(0, 260, 0, 250)
    Frame.Position = UDim2.new(0.02, 0, 0.25, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Frame.Active = true
    Frame.Draggable = true
    
    local Title = Instance.new("TextLabel", Frame)
    Title.Size = UDim2.new(1, 0, 0, 35)
    Title.Text = "🥚 رادار البيض الذكي 🥚"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    
    local Scroll = Instance.new("ScrollingFrame", Frame)
    Scroll.Size = UDim2.new(1, 0, 1, -35)
    Scroll.Position = UDim2.new(0, 0, 0, 35)
    Scroll.BackgroundTransparency = 1
    Scroll.CanvasSize = UDim2.new(0, 0, 4, 0)
    
    local UIList = Instance.new("UIListLayout", Scroll)
    UIList.SortOrder = Enum.SortOrder.LayoutOrder
    
    task.spawn(function()
        while task.wait(2) do
            for _, child in pairs(Scroll:GetChildren()) do
                if child:IsA("TextLabel") then child:Destroy() end
            end
            
            -- فحص ذكي لكل مجسم يحتوي اسمه على كلمة بيضة
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("BasePart") and (string.find(string.lower(v.Name), "egg") or v.Parent.Name == "Eggs") then
                    local txt = Instance.new("TextLabel", Scroll)
                    txt.Size = UDim2.new(1, 0, 0, 25)
                    txt.TextColor3 = Color3.fromRGB(0, 255, 150)
                    txt.BackgroundTransparency = 1
                    txt.Text = "• Found: " .. v.Name
                end
            end
        end
    end)
end

-- 2. كود السرقة الشامل والطيران الفوري للمنزل
task.spawn(function()
    while _G.AutoSteal do
        task.wait(0.5)
        
        local Char = LocalPlayer.Character
        local HRP = Char and Char:FindFirstChild("HumanoidRootPart")
        
        -- العثور التلقائي على قاعدة اللاعب (بيتك)
        local MyBase = nil
        for _, v in pairs(Workspace:GetDescendants()) do
            if string.find(string.lower(v.Name), "base") or string.find(string.lower(v.Name), "plot") then
                if v:GetAttribute("Owner") == LocalPlayer.Name or string.find(v.Name, LocalPlayer.Name) then
                    MyBase = v
                    break
                end
            end
        end
        -- خيار احتياطي إذا لم يجد الاسم المباشر
        if not MyBase then
            MyBase = Workspace:FindFirstChild("Bases") or Workspace:FindFirstChild("Plots")
            if MyBase then MyBase = MyBase:FindFirstChild(LocalPlayer.Name) end
        end
        
        if HRP and MyBase then
            -- البحث عن البيض في الخريطة بالكامل بالاسم والملمس
            for _, egg in pairs(Workspace:GetDescendants()) do
                if egg:IsA("BasePart") and (string.find(string.lower(egg.Name), "egg") and egg.Name ~= "EggRadarUI") then
                    -- تجنب كود الرادار نفسه أو أجزاء اللاعب
                    if not egg:IsDescendantOf(Char) and not egg:IsDescendantOf(CoreGui) then
                        
                        -- طيران فوري فوق البيضة
                        HRP.CFrame = egg.CFrame + Vector3.new(0, 1.5, 0)
                        task.wait(0.1)
                        
                        -- تشغيل اللمس الإجباري
                        if firetouchinterest then
                            firetouchinterest(HRP, egg, 0)
                            task.wait(0.05)
                            firetouchinterest(HRP, egg, 1)
                        end
                        
                        task.wait(0.2)
                        
                        -- طيران فوري إلى البيت (قاعدتك) لتفريغها
                        if MyBase:IsA("BasePart") then
                            HRP.CFrame = MyBase.CFrame + Vector3.new(0, 4, 0)
                        else
                            HRP.CFrame = MyBase:GetModelCFrame() + Vector3.new(0, 4, 0)
                        end
                        
                        task.wait(0.5) -- انتظار تفريغ البيضة
                        break
                    end
                end
            end
        end
    end
end)
