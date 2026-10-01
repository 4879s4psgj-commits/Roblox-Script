-- تفعيل الميزات تلقائياً
_G.AutoSteal = true
_G.ShowEggList = true

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

-- 1. كود إنشاء رادار كاشف البيض ومحتواه
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
    Title.Text = "🥚 رادار البيض المحيط بك 🥚"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    
    local Scroll = Instance.new("ScrollingFrame", Frame)
    Scroll.Size = UDim2.new(1, 0, 1, -35)
    Scroll.Position = UDim2.new(0, 0, 0, 35)
    Scroll.BackgroundTransparency = 1
    Scroll.CanvasSize = UDim2.new(0, 0, 3, 0)
    
    local UIList = Instance.new("UIListLayout", Scroll)
    UIList.SortOrder = Enum.SortOrder.LayoutOrder
    
    task.spawn(function()
        while task.wait(1.5) do
            for _, child in pairs(Scroll:GetChildren()) do
                if child:IsA("TextLabel") then child:Destroy() end
            end
            
            -- فحص شامل للمجلدات المحدثة في الماب
            local EggFolder = Workspace:FindFirstChild("Eggs") or Workspace:FindFirstChild("EggSpawns") or Workspace:FindFirstChild("ZoneEggs")
            if EggFolder then
                for _, egg in pairs(EggFolder:GetChildren()) do
                    local txt = Instance.new("TextLabel", Scroll)
                    txt.Size = UDim2.new(1, 0, 0, 25)
                    txt.TextColor3 = Color3.fromRGB(255, 200, 0)
                    txt.BackgroundTransparency = 1
                    local content = egg:GetAttribute("Contains") or egg.Name
                    txt.Text = "• " .. egg.Name .. " [" .. tostring(content) .. "]"
                end
            end
        end
    end)
end

-- 2. كود السرقة الآمنة والعودة الفورية للقاعدة
task.spawn(function()
    while _G.AutoSteal do
        task.wait(0.5) -- انتظار نصف ثانية لتفادي كشف الحماية (Anti-Cheat Bypass)
        
        local Char = LocalPlayer.Character
        local HRP = Char and Char:FindFirstChild("HumanoidRootPart")
        
        -- العثور الذكي على قاعدة اللاعب (Plot) الخاص بك
        local MyBase = nil
        local Bases = Workspace:FindFirstChild("Bases") or Workspace:FindFirstChild("PlayerBases") or Workspace:FindFirstChild("Plots")
        if Bases then
            MyBase = Bases:FindFirstChild(LocalPlayer.Name) or Bases:FindFirstChild(LocalPlayer.DisplayName)
        end
        
        local EggFolder = Workspace:FindFirstChild("Eggs") or Workspace:FindFirstChild("EggSpawns") or Workspace:FindFirstChild("ZoneEggs")
        
        if HRP and EggFolder and MyBase then
            for _, egg in pairs(EggFolder:GetChildren()) do
                local targetPart = egg:IsA("BasePart") and egg or egg:FindFirstChildWhichIsA("BasePart")
                
                if targetPart and targetPart.Parent then
                    -- طيران آمن فوق البيضة مباشرة
                    HRP.CFrame = targetPart.CFrame + Vector3.new(0, 1.5, 0)
                    task.wait(0.3) -- وقت كافٍ لتسجيل اللعبة لعملية اللمس (Touch)
                    
                    -- طيران فوري للمنزل لتفريغها
                    if MyBase:IsA("BasePart") then
                        HRP.CFrame = MyBase.CFrame + Vector3.new(0, 3, 0)
                    else
                        HRP.CFrame = MyBase:GetModelCFrame() + Vector3.new(0, 3, 0)
                    end
                    
                    task.wait(0.5) -- وقت إرجاع البيضة للمخزن قبل الذهاب للتالية
                    break
                end
            end
        end
    end
end)
