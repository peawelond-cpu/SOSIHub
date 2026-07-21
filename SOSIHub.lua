-- ============================================
-- 1. ЗАГРУЗКА БИБЛИОТЕКИ И ИНИЦИАЛИЗАЦИЯ
-- ============================================
local success, Luna = pcall(function()
    local rawCode = game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Luna-Interface-Suite/refs/heads/main/source.lua", true)
    local loadedFunc, err = loadstring(rawCode)
    if not loadedFunc then
        error("Ошибка синтаксиса библиотеки: " .. tostring(err))
    end
    return loadedFunc()
end)
 
if not success or type(Luna) ~= "table" then
    warn("[SOSI Hub]: Не удалось загрузить Luna Library! Ошибка: " .. tostring(Luna))
    return
end
 
-- ============================================
-- 2. СЕРВИСЫ И ОЧИСТКА BLUR
-- ============================================
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
 
local function ClearUIBlur()
    for _, child in ipairs(Lighting:GetChildren()) do
        if child:IsA("BlurEffect") then
            child:Destroy()
        end
    end
end
 
Lighting.ChildAdded:Connect(function(child)
    if child:IsA("BlurEffect") then
        task.wait(0.1)
        child:Destroy()
    end
end)
 
ClearUIBlur()
 
-- ============================================
-- 3. СОЗДАНИЕ ИНТЕРФЕЙСА
-- ============================================
local Window = Luna:CreateWindow({
    Name = "SOSI Hub", 
    Subtitle = "Visuals & Utilities",
    LogoID = "82795327169782",
    LoadingEnabled = true,
    LoadingTitle = "Luna Interface Suite",
    LoadingSubtitle = "by Hland",
    ConfigSettings = {
        RootFolder = nil,
        ConfigFolder = "SOSI Hub"
    },
    KeySystem = false
})
 
-- Вкладки
local Tab = Window:CreateTab({
    Name = "Fake Items",
    Icon = "view_in_ar",
    ImageSource = "Material",
    ShowTitle = true
})
 
local VisualTab = Window:CreateTab({
    Name = "Visuals",
    Icon = "wb_sunny",
    ImageSource = "Material",
    ShowTitle = true
})
 
local CommandTab = Window:CreateTab({
    Name = "Commands",
    Icon = "build",
    ImageSource = "Material",
    ShowTitle = true
})
 
Window:CreateHomeTab({
    SupportedExecutors = {"Synapse X", "Krnl", "ScriptWare"},
    DiscordInvite = "DKMp8Sqv7",
    Icon = 2,
})
 
-- Описание вкладок
Tab:CreateParagraph({
    Title = "ℹ️ Info",
    Text = "Enable fake accessories"
})
 
VisualTab:CreateParagraph({
    Title = "ℹ️ Visual Settings",
    Text = "Lighting, shadow and resolution settings"
})
 
CommandTab:CreateParagraph({
    Title = "ℹ️ Player Utilities",
    Text = "Movement, character and spawn controls"
})
 
-- Model IDs
local vu4 = "101851696" -- Korblox Leg Mesh
local vu5 = "101851254" -- Korblox Leg Texture
local vu6 = "134082579" -- Headless Head Mesh
local vu7 = "134082627" -- Headless Head Texture
 
-- Переменные состояния
local FakeEnabled = false
local AlwaysFakeEnabled = false
local PingSpoofEnabled = false
local FullBrightEnabled = false
local NoShadowsEnabled = false
 
-- Разрешение
local ResolutionEnabled = false
local ResolutionScale = 1.0
local Camera = workspace.CurrentCamera
local ResolutionConnection = nil
 
local function SendNotification(Title, Text, Duration, Icon)
    pcall(function()
        Luna:Notification({
            Title = Title or "SOSI Hub",
            Content = Text or "",
            Duration = Duration or 4,
            Icon = Icon or "info"
        })
    end)
end
 
-- ============ СИСТЕМА РАЗРЕШЕНИЯ ============
local function UpdateResolutionConnection()
    if ResolutionEnabled then
        if not ResolutionConnection then
            ResolutionConnection = RunService.RenderStepped:Connect(function()
                if Camera then
                    Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, ResolutionScale, 0, 0, 0, 1)
                end
            end)
        end
    else
        if ResolutionConnection then
            ResolutionConnection:Disconnect()
            ResolutionConnection = nil
        end
    end
end
 
-- ============ СИСТЕМА FULLBRIGHT ============
if not _G.FullBrightExecuted then
    _G.FullBrightEnabled = false
 
    _G.NormalLightingSettings = {
        Brightness = Lighting.Brightness,
        ClockTime = Lighting.ClockTime,
        FogEnd = Lighting.FogEnd,
        GlobalShadows = Lighting.GlobalShadows,
        Ambient = Lighting.Ambient
    }
 
    Lighting:GetPropertyChangedSignal("Brightness"):Connect(function()
        if Lighting.Brightness ~= 1 and Lighting.Brightness ~= _G.NormalLightingSettings.Brightness then
            _G.NormalLightingSettings.Brightness = Lighting.Brightness
            if not _G.FullBrightEnabled then
                repeat task.wait() until _G.FullBrightEnabled
            end
            Lighting.Brightness = 1
        end
    end)
 
    Lighting:GetPropertyChangedSignal("ClockTime"):Connect(function()
        if Lighting.ClockTime ~= 12 and Lighting.ClockTime ~= _G.NormalLightingSettings.ClockTime then
            _G.NormalLightingSettings.ClockTime = Lighting.ClockTime
            if not _G.FullBrightEnabled then
                repeat task.wait() until _G.FullBrightEnabled
            end
            Lighting.ClockTime = 12
        end
    end)
 
    Lighting:GetPropertyChangedSignal("FogEnd"):Connect(function()
        if Lighting.FogEnd ~= 786543 and Lighting.FogEnd ~= _G.NormalLightingSettings.FogEnd then
            _G.NormalLightingSettings.FogEnd = Lighting.FogEnd
            if not _G.FullBrightEnabled then
                repeat task.wait() until _G.FullBrightEnabled
            end
            Lighting.FogEnd = 786543
        end
    end)
 
    Lighting:GetPropertyChangedSignal("GlobalShadows"):Connect(function()
        if Lighting.GlobalShadows ~= false and Lighting.GlobalShadows ~= _G.NormalLightingSettings.GlobalShadows then
            _G.NormalLightingSettings.GlobalShadows = Lighting.GlobalShadows
            if not _G.FullBrightEnabled then
                repeat task.wait() until _G.FullBrightEnabled
            end
            Lighting.GlobalShadows = false
        end
    end)
 
    Lighting:GetPropertyChangedSignal("Ambient"):Connect(function()
        if Lighting.Ambient ~= Color3.fromRGB(178, 178, 178) and Lighting.Ambient ~= _G.NormalLightingSettings.Ambient then
            _G.NormalLightingSettings.Ambient = Lighting.Ambient
            if not _G.FullBrightEnabled then
                repeat task.wait() until _G.FullBrightEnabled
            end
            Lighting.Ambient = Color3.fromRGB(178, 178, 178)
        end
    end)
 
    local function ApplyFullBright()
        Lighting.Brightness = 1
        Lighting.ClockTime = 12
        Lighting.FogEnd = 786543
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.fromRGB(178, 178, 178)
    end
 
    local function RestoreLighting()
        Lighting.Brightness = _G.NormalLightingSettings.Brightness
        Lighting.ClockTime = _G.NormalLightingSettings.ClockTime
        Lighting.FogEnd = _G.NormalLightingSettings.FogEnd
        Lighting.GlobalShadows = _G.NormalLightingSettings.GlobalShadows
        Lighting.Ambient = _G.NormalLightingSettings.Ambient
    end
 
    local LatestValue = true
    task.spawn(function()
        repeat task.wait() until _G.FullBrightEnabled
        while task.wait() do
            if _G.FullBrightEnabled ~= LatestValue then
                if not _G.FullBrightEnabled then
                    RestoreLighting()
                else
                    ApplyFullBright()
                end
                LatestValue = not LatestValue
            end
        end
    end)
end
 
_G.FullBrightExecuted = true
 
local function ToggleFullBrightFunc(Enabled)
    FullBrightEnabled = Enabled
    _G.FullBrightEnabled = Enabled
    if Enabled then
        Lighting.Brightness = 1
        Lighting.ClockTime = 12
        Lighting.FogEnd = 786543
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.fromRGB(178, 178, 178)
        SendNotification("FullBright", "Full brightness mode enabled", 3, "wb_sunny")
    else
        _G.FullBrightEnabled = false
        if _G.NormalLightingSettings then
            Lighting.Brightness = _G.NormalLightingSettings.Brightness
            Lighting.ClockTime = _G.NormalLightingSettings.ClockTime
            Lighting.FogEnd = _G.NormalLightingSettings.FogEnd
            Lighting.GlobalShadows = _G.NormalLightingSettings.GlobalShadows
            Lighting.Ambient = _G.NormalLightingSettings.Ambient
        end
        SendNotification("FullBright", "Full brightness mode disabled", 3, "brightness_auto")
    end
end
 
-- ============ СИСТЕМА NO SHADOWS ============
local function ToggleNoShadowsFunc(Enabled)
    NoShadowsEnabled = Enabled
    if Enabled then
        Lighting.GlobalShadows = false
        for _, descendant in pairs(game:GetDescendants()) do
            if descendant:IsA("BasePart") and descendant:FindFirstChild("Shadow") then
                descendant.Shadow:Destroy()
            end
            if descendant:IsA("SpotLight") or descendant:IsA("PointLight") or descendant:IsA("SurfaceLight") then
                descendant.Shadows = false
            end
        end
        SendNotification("No Shadows", "Shadows disabled", 3, "dark_mode")
    else
        if _G.NormalLightingSettings then
            Lighting.GlobalShadows = _G.NormalLightingSettings.GlobalShadows
        else
            Lighting.GlobalShadows = true
        end
        SendNotification("No Shadows", "Shadows enabled", 3, "light_mode")
    end
end
 
-- ============ ADVANCED ESP SYSTEM ============
local ESPBoxEnabled = false
local ESPNameEnabled = false
local ESPHighlightEnabled = false
local HideOriginalNamesEnabled = false

local ESPConnections = {}
local ESPBoxes = {}
local ESPHighlights = {}

local function RemoveESP(player)
    if ESPBoxes[player] then
        for _, drawing in pairs(ESPBoxes[player]) do
            pcall(function() drawing:Remove() end)
        end
        ESPBoxes[player] = nil
    end
    if ESPHighlights[player] then
        pcall(function() ESPHighlights[player]:Destroy() end)
        ESPHighlights[player] = nil
    end
end

local function ApplyNametagHiding(player)
    local char = player.Character
    if char then
        local head = char:FindFirstChild("Head")
        if head then
            for _, child in ipairs(head:GetChildren()) do
                if child:IsA("BillboardGui") then
                    child.Enabled = not HideOriginalNamesEnabled
                end
            end
        end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            pcall(function()
                if HideOriginalNamesEnabled then
                    humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                else
                    humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
                end
            end)
        end
    end
end

local function SetupPlayerESP(player)
    if player == LocalPlayer then return end

    local function updateDrawings()
        RemoveESP(player)

        local box = Drawing.new("Square")
        box.Visible = false
        box.Color = Color3.fromRGB(255, 0, 0)
        box.Thickness = 1.5
        box.Filled = false
        box.Transparency = 1

        local nameTag = Drawing.new("Text")
        nameTag.Visible = false
        nameTag.Color = Color3.fromRGB(255, 255, 255)
        nameTag.Size = 14
        nameTag.Center = true
        nameTag.Outline = true

        ESPBoxes[player] = {Box = box, Name = nameTag}

        local highlight = Instance.new("Highlight")
        highlight.Name = "SOSIHub_Highlight"
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Enabled = false
        
        if player.Character then
            highlight.Parent = player.Character
            ApplyNametagHiding(player)
        end
        ESPHighlights[player] = highlight

        local connection
        connection = RunService.RenderStepped:Connect(function()
            local char = player.Character
            local alive = char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") and char.Humanoid.Health > 0

            if HideOriginalNamesEnabled then
                ApplyNametagHiding(player)
            end

            if ESPHighlightEnabled and alive then
                highlight.Enabled = true
                if highlight.Parent ~= char then
                    highlight.Parent = char
                end
            else
                highlight.Enabled = false
            end

            if (ESPBoxEnabled or ESPNameEnabled) and alive then
                local rootPart = char.HumanoidRootPart
                local head = char:FindFirstChild("Head")
                local vector, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                
                if onScreen then
                    local headVector = head and Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0)) or vector
                    local legVector = Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0))
                    
                    local height = math.abs(headVector.Y - legVector.Y)
                    local width = height / 2
                    
                    if ESPBoxEnabled then
                        box.Size = Vector2.new(width, height)
                        box.Position = Vector2.new(vector.X - width / 2, headVector.Y)
                        box.Visible = true
                    else
                        box.Visible = false
                    end

                    if ESPNameEnabled then
                        nameTag.Text = player.Name
                        nameTag.Position = Vector2.new(vector.X, headVector.Y - 18)
                        nameTag.Visible = true
                    else
                        nameTag.Visible = false
                    end
                else
                    box.Visible = false
                    nameTag.Visible = false
                end
            else
                box.Visible = false
                nameTag.Visible = false
            end
        end)
        
        table.insert(ESPConnections, connection)
    end

    player.CharacterAdded:Connect(function(newChar)
        task.wait(1)
        updateDrawings()
    end)

    if player.Character then
        updateDrawings()
    end
end

local function RefreshESPState()
    for _, player in ipairs(Players:GetPlayers()) do
        RemoveESP(player)
        if ESPBoxEnabled or ESPNameEnabled or ESPHighlightEnabled or HideOriginalNamesEnabled then
            SetupPlayerESP(player)
        else
            ApplyNametagHiding(player)
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    if ESPBoxEnabled or ESPNameEnabled or ESPHighlightEnabled or HideOriginalNamesEnabled then
        SetupPlayerESP(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    RemoveESP(player)
end)

-- ============ TSB DEATH COUNTER ESP SYSTEM (ТОЛЬКО СИНИЙ ХАЙЛАЙТ 10 СЕК) ============
local strongSkills = {
    ["Omni Directional Punch"] = true,
    ["Death Counter"] = true,
    ["Serious Punch"] = true,
    ["Table Flip"] = true
}
local weakSkills = {
    ["Consecutive Punches"] = true,
    ["Normal Punch"] = true,
    ["Shove"] = true,
    ["Uppercut"] = true
}

local TSB_EspEnabled = true
local tsbState = {}

local function applyDeathCounterHighlight(target)
    if not target then return end
    local existingHL = target:FindFirstChild("DeathCounterHighlight")
    if not existingHL then
        local hl = Instance.new("Highlight")
        hl.Name = "DeathCounterHighlight"
        hl.FillColor = Color3.fromRGB(0, 150, 255) -- Синий цвет
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.FillTransparency = 0.4
        hl.OutlineTransparency = 0
        hl.Parent = target
        
        -- Окно дез каунтера длится ровно 10 секунд
        task.delay(10, function()
            if hl and hl.Parent then
                hl:Destroy()
            end
        end)
    end
end

local function getSkillType(backpack)
    for _, tool in ipairs(backpack:GetChildren()) do
        if strongSkills[tool.Name] then return "strong" end
        if weakSkills[tool.Name] then return "weak" end
    end
end

RunService.Heartbeat:Connect(function()
    if not TSB_EspEnabled then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local char = plr.Character
            local backpack = plr:FindFirstChildOfClass("Backpack")
            if char and backpack then
                local skillType = getSkillType(backpack)
                local lastState = tsbState[plr]

                if not lastState then
                    tsbState[plr] = skillType
                else
                    if skillType == "strong" then
                        tsbState[plr] = "strong"
                    elseif skillType == "weak" and lastState == "strong" then
                        applyDeathCounterHighlight(char) -- Включаем синий хайлайт ровно на 10 секунд без смайликов над головой
                        tsbState[plr] = "weak"
                    end
                end
            end
        end
    end
end)
 
-- ============ FAKE ITEMS FUNCTIONS ============
local function CreateFakeKorblox()
    local char = LocalPlayer.Character
    if char then
        local leg = char:FindFirstChild("Right Leg") or char:FindFirstChild("RightLowerLeg")
        if leg then
            for _, mesh in pairs(leg:GetChildren()) do
                if mesh:IsA("SpecialMesh") then
                    mesh:Destroy()
                end
            end
 
            local v14 = Instance.new("SpecialMesh")
            v14.MeshType = Enum.MeshType.FileMesh
            v14.MeshId = "rbxassetid://" .. vu4
            v14.TextureId = "rbxassetid://" .. vu5
            v14.Scale = Vector3.new(1, 1, 1)
            v14.Offset = Vector3.new(0, 0, 0)
            v14.Parent = leg
            leg.Transparency = 0.1
            leg.BrickColor = BrickColor.new("Really black")
            leg.Material = Enum.Material.Plastic
        end
    end
end
 
local function CreateFakeHeadless()
    local char = LocalPlayer.Character
    if char then
        local head = char:FindFirstChild("Head")
        if head then
            for _, child in pairs(head:GetChildren()) do
                if child:IsA("Decal") or child:IsA("SpecialMesh") then
                    child:Destroy()
                end
            end
 
            local v22 = Instance.new("SpecialMesh")
            v22.MeshType = Enum.MeshType.FileMesh
            v22.MeshId = "rbxassetid://" .. vu6
            v22.TextureId = "rbxassetid://" .. vu7
            v22.Scale = Vector3.new(1.25, 1.25, 1.25)
            v22.Offset = Vector3.new(0, 0, 0)
            v22.Parent = head
            head.Transparency = 0.1
            head.BrickColor = BrickColor.new("Really black")
            head.Material = Enum.Material.Plastic
 
            for _, acc in pairs(char:GetChildren()) do
                if acc:IsA("Accessory") then
                    local handle = acc:FindFirstChild("Handle")
                    if handle then
                        local attach = handle:FindFirstChildOfClass("Attachment")
                        if attach and (attach.Name:lower():find("hair") or attach.Name:lower():find("hat") or attach.Name:lower():find("face")) then
                            acc:Destroy()
                        end
                    end
                end
            end
        end
    end
end
 
local function CreateFakeKorbloxWithWrap()
    local char = LocalPlayer.Character
    if char then
        local leg = char:FindFirstChild("Right Leg") or char:FindFirstChild("RightLowerLeg")
        if leg then
            local old = char:FindFirstChild("FakeKorbloxLeg")
            if old then old:Destroy() end
 
            local fakePart = Instance.new("Part")
            fakePart.Name = "FakeKorbloxLeg"
            fakePart.Size = leg.Size
            fakePart.CFrame = leg.CFrame
            fakePart.Anchored = false
            fakePart.CanCollide = false
            fakePart.Transparency = 0
            fakePart.BrickColor = BrickColor.new("Really black")
            fakePart.Material = Enum.Material.Plastic
 
            local mesh = Instance.new("SpecialMesh")
            mesh.MeshType = Enum.MeshType.FileMesh
            mesh.MeshId = "rbxassetid://" .. vu4
            mesh.TextureId = "rbxassetid://" .. vu5
            mesh.Scale = Vector3.new(1, 1, 1)
            mesh.Offset = Vector3.new(0, 0, 0)
            mesh.Parent = fakePart
 
            fakePart.Parent = char
 
            local weld = Instance.new("WeldConstraint")
            weld.Part0 = leg
            weld.Part1 = fakePart
            weld.Parent = leg
 
            leg.Transparency = 1
            fakePart.CFrame = leg.CFrame
        end
    end
end
 
local function ApplyFakeItems()
    if not LocalPlayer.Character then
        LocalPlayer.CharacterAdded:Wait()
    end
    CreateFakeHeadless()
    CreateFakeKorblox()
    CreateFakeKorbloxWithWrap()
    task.wait(0.5)
    SendNotification("Fake Items", "Fake Headless & Korblox Applied!", 4, "check_circle")
end
 
LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    if AlwaysFakeEnabled then
        newCharacter:WaitForChild("Humanoid")
        task.wait(0.5)
        ApplyFakeItems()
    end
end)
 
-- ============ SPOOF PING ============
local function EnablePingSpoof()
    pcall(function()
        local PerformanceStats = game:GetService("CoreGui"):WaitForChild("RobloxGui"):WaitForChild("PerformanceStats")
        local PingLabel
 
        for _, Child in next, PerformanceStats:GetChildren() do
            if Child:FindFirstChild("StatsMiniTextPanelClass") and Child.StatsMiniTextPanelClass.TitleLabel.Text == "Ping" then
                PingLabel = Child.StatsMiniTextPanelClass.ValueLabel
                break
            end
        end
 
        if PingLabel then
            PingLabel:GetPropertyChangedSignal("Text"):Connect(function()
                PingLabel.Text = "1 ms"
            end)
            PingLabel.Text = "1 ms"
            SendNotification("Ping Spoof", "Ping now always shows 1 ms", 4, "speed")
        end
    end)
end
 
-- ============ СИСТЕМА ANTI-VOID ============
local AntiVoidEnabled = false
local AntiVoidConnection = nil
 
local function ToggleAntiVoid(Enabled)
    AntiVoidEnabled = Enabled
    if AntiVoidConnection then
        AntiVoidConnection:Disconnect()
        AntiVoidConnection = nil
    end
 
    if AntiVoidEnabled then
        AntiVoidConnection = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if char then
                local root = char:FindFirstChild("HumanoidRootPart")
                if root and root.Position.Y <= 0 then
                    root.CFrame = CFrame.new(-31, 460, -115)
                    SendNotification("Anti-Void", "Телепортирован на X: -31, Y: 460, Z: -115", 2, "arrow_upward")
                end
            end
        end)
        SendNotification("Anti-Void", "Защита от падения включена", 3, "check")
    else
        SendNotification("Anti-Void", "Защита от падения выключена", 3, "close")
    end
end
 
-- ============ COMMANDS & UTILITIES ============
local NoclipEnabled = false
local NoclipConnection = nil
 
local function ToggleNoclip(State)
    NoclipEnabled = State
    if NoclipConnection then 
        NoclipConnection:Disconnect() 
        NoclipConnection = nil
    end
 
    if NoclipEnabled then
        NoclipConnection = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
        SendNotification("Noclip", "Noclip enabled", 3, "check")
    else
        SendNotification("Noclip", "Noclip disabled", 3, "close")
    end
end
 
local TPWalkEnabled = false
local TPWalkSpeed = 16
local TPWalkConnection = nil
 
local function UpdateTPWalk(Speed)
    TPWalkSpeed = Speed
    if Speed > 16 then
        TPWalkEnabled = true
        if not TPWalkConnection then
            TPWalkConnection = RunService.Heartbeat:Connect(function(delta)
                if TPWalkEnabled and LocalPlayer.Character then
                    local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if hum and hum.MoveDirection.Magnitude > 0 then
                        LocalPlayer.Character:TranslateBy(hum.MoveDirection * (TPWalkSpeed / 16) * delta * 16)
                    end
                end
            end)
        end
    else
        TPWalkEnabled = false
        if TPWalkConnection then
            TPWalkConnection:Disconnect()
            TPWalkConnection = nil
        end
    end
end
 
local CustomSpawnCFrame = nil
 
local function SetSpawnPoint()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        CustomSpawnCFrame = char.HumanoidRootPart.CFrame
        SendNotification("Spawnpoint", "Spawnpoint saved", 3, "place")
    end
end
 
local function ClearSpawnPoint()
    CustomSpawnCFrame = nil
    SendNotification("Spawnpoint", "Spawnpoint cleared", 3, "delete")
end
 
LocalPlayer.CharacterAdded:Connect(function(char)
    if CustomSpawnCFrame then
        local root = char:WaitForChild("HumanoidRootPart", 10)
        if root then
            task.wait(0.3)
            root.CFrame = CustomSpawnCFrame
        end
    end
end)
 
local function ResetCharacter()
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Health = 0
            SendNotification("Reset", "Character reset", 3, "refresh")
        end
    end
end
 
-- ============ ЭЛЕМЕНТЫ UI ============
 
-- Fake Items Tab
Tab:CreateButton({
    Name = "👑 Enable Fake Headless & Korblox",
    Description = "Adds fake accessories to your character once",
    Callback = function()
        if not FakeEnabled then
            ApplyFakeItems()
            FakeEnabled = true
        else
            SendNotification("Fake Items", "Already enabled!", 2, "warning")
        end
    end
})
 
Tab:CreateToggle({
    Name = "👑 Always Fake Headless & Korblox",
    Description = "Automatically reapplies fake accessories upon death/respawn",
    CurrentValue = false,
    Callback = function(Value)
        AlwaysFakeEnabled = Value
        if Value then
            ApplyFakeItems()
            FakeEnabled = true
        else
            SendNotification("Auto Fake Items", "Always fake items disabled!", 3, "cancel")
        end
    end
}, "AlwaysFakeItems")
 
Tab:CreateToggle({
    Name = "📶 Spoof Ping (1 ms)",
    Description = "Always displays ping as 1 ms",
    CurrentValue = false,
    Callback = function(Value)
        PingSpoofEnabled = Value
        if Value then
            EnablePingSpoof()
        else
            SendNotification("Ping Spoof", "Ping spoofing disabled", 3, "cancel")
        end
    end
}, "PingSpoof")
 
-- Visuals Tab
VisualTab:CreateToggle({
    Name = "☀️ FullBright",
    Description = "Maximum brightness, daytime, no fog",
    CurrentValue = false,
    Callback = function(Value)
        ToggleFullBrightFunc(Value)
    end
}, "FullBrightToggle")
 
VisualTab:CreateToggle({
    Name = "🌑 No Shadows",
    Description = "Disables all shadows in the game",
    CurrentValue = false,
    Callback = function(Value)
        ToggleNoShadowsFunc(Value)
    end
}, "NoShadowsToggle")

-- Раздел ESP с раздельными переключателями
VisualTab:CreateParagraph({
    Title = "👁️ ESP Settings",
    Text = "Настройка элементов визуального отображения"
})

VisualTab:CreateToggle({
    Name = "📦 ESP Boxes",
    Description = "Отображение рамок вокруг игроков",
    CurrentValue = false,
    Callback = function(Value)
        ESPBoxEnabled = Value
        RefreshESPState()
    end
}, "ESPBoxToggle")

VisualTab:CreateToggle({
    Name = "📝 ESP Names",
    Description = "Отображение кастомных имен игроков",
    CurrentValue = false,
    Callback = function(Value)
        ESPNameEnabled = Value
        RefreshESPState()
    end
}, "ESPNameToggle")

VisualTab:CreateToggle({
    Name = "✨ ESP Highlight",
    Description = "Подсветка моделей игроков сквозь стены",
    CurrentValue = false,
    Callback = function(Value)
        ESPHighlightEnabled = Value
        RefreshESPState()
    end
}, "ESPHighlightToggle")

VisualTab:CreateToggle({
    Name = "🫥 Hide Original Names",
    Description = "Скрыть стандартные ники над головами игроков",
    CurrentValue = false,
    Callback = function(Value)
        HideOriginalNamesEnabled = Value
        for _, player in ipairs(Players:GetPlayers()) do
            if ESPBoxEnabled or ESPNameEnabled or ESPHighlightEnabled or HideOriginalNamesEnabled then
                SetupPlayerESP(player)
            else
                ApplyNametagHiding(player)
            end
        end
    end
}, "HideOriginalNamesToggle")

VisualTab:CreateToggle({
    Name = "☠ TSB Death Counter ESP",
    Description = "Синий хайлайт при активации дез каунтера на 10 сек (без смайликов)",
    CurrentValue = true,
    Callback = function(Value)
        TSB_EspEnabled = Value
        if not Value then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr.Character and plr.Character:FindFirstChild("DeathCounterHighlight") then
                    plr.Character.DeathCounterHighlight:Destroy()
                end
            end
        end
    end
}, "TSBDeathCounterToggle")
 
VisualTab:CreateToggle({
    Name = "🖥️ Custom Resolution Mod",
    Description = "Включить изменение разрешения камеры",
    CurrentValue = false,
    Callback = function(Value)
        ResolutionEnabled = Value
        UpdateResolutionConnection()
        if Value then
            SendNotification("Resolution Mod", "Кастомное разрешение включено", 3, "aspect_ratio")
        else
            SendNotification("Resolution Mod", "Разрешение сброшено", 3, "aspect_ratio")
        end
    end
}, "CustomResolutionToggle")
 
VisualTab:CreateSlider({
    Name = "🎯 Resolution Scale (%)",
    Description = "100 = 1.0 (Обычное), 80 = 0.80, 50 = 0.50 и т.д.",
    Range = {10, 100},
    Increment = 5,
    CurrentValue = 80,
    Callback = function(Value)
        ResolutionScale = Value / 100
    end
}, "ResolutionScaleSlider")
 
VisualTab:CreateButton({
    Name = "🔄 Reset Lighting",
    Description = "Restores default lighting settings",
    Callback = function()
        if _G.NormalLightingSettings then
            Lighting.Brightness = _G.NormalLightingSettings.Brightness
            Lighting.ClockTime = _G.NormalLightingSettings.ClockTime
            Lighting.FogEnd = _G.NormalLightingSettings.FogEnd
            Lighting.GlobalShadows = _G.NormalLightingSettings.GlobalShadows
            Lighting.Ambient = _G.NormalLightingSettings.Ambient
            FullBrightEnabled = false
            NoShadowsEnabled = false
            _G.FullBrightEnabled = false
            ClearUIBlur()
            SendNotification("Lighting Reset", "Lighting settings have been reset", 3, "restart_alt")
        end
    end
})
 
-- Commands Tab
CommandTab:CreateToggle({
    Name = "🛡️ Anti-Void (TP to -31, 460, -115)",
    Description = "Автоматически телепортирует на X: -31, Y: 460, Z: -115 при Y <= 0",
    CurrentValue = false,
    Callback = function(Value)
        ToggleAntiVoid(Value)
    end
}, "AntiVoidToggle")
 
CommandTab:CreateToggle({
    Name = "👻 Noclip",
    Description = "Проход сквозь любые стены",
    CurrentValue = false,
    Callback = function(Value)
        ToggleNoclip(Value)
    end
}, "NoclipToggle")
 
CommandTab:CreateSlider({
    Name = "🚶 TP Walk Speed",
    Description = "Скорость перемещения (16 — стандартная)",
    Range = {16, 200},
    Increment = 2,
    CurrentValue = 16,
    Callback = function(Value)
        UpdateTPWalk(Value)
    end
}, "TPWalkSlider")
 
CommandTab:CreateButton({
    Name = "🚩 Set Custom Spawnpoint",
    Description = "Запомнить текущие координаты при возрождении",
    Callback = function()
        SetSpawnPoint()
    end
})
 
CommandTab:CreateButton({
    Name = "🗑️ Clear Spawnpoint",
    Description = "Сбросить сохраненную точку спавна",
    Callback = function()
        ClearSpawnPoint()
    end
})
 
CommandTab:CreateButton({
    Name = "💀 Reset Character",
    Description = "Быстро убить персонажа для респавна",
    Callback = function()
        ResetCharacter()
    end
})
 
-- ============================================
-- 4. TARGET LOCK (CAMERA LOCK)
-- ============================================
local targetLock = false
local lockedPlayer = nil
 
local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
 
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local character = player.Character
            local torso = character:FindFirstChild("HumanoidRootPart")
            local screenPos = workspace.CurrentCamera:WorldToScreenPoint(torso.Position)
            local mousePos = Vector2.new(Mouse.X, Mouse.Y)
            local distance = (mousePos - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
 
            if distance < shortestDistance then
                shortestDistance = distance
                closestPlayer = player
            end
        end
    end
 
    return closestPlayer
end
 
local function lockOntoPlayer()
    local closestPlayer = getClosestPlayer()
 
    if closestPlayer and closestPlayer.Character then
        local torso = closestPlayer.Character:FindFirstChild("HumanoidRootPart")
        if torso then
            Mouse.TargetFilter = torso
            lockedPlayer = closestPlayer
            targetLock = true
        end
    end
end
 
local function updateLock()
    if lockedPlayer and lockedPlayer.Character then
        local torso = lockedPlayer.Character:FindFirstChild("HumanoidRootPart")
        if torso then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, torso.Position)
        end
    end
end
 
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.C then
        if not targetLock then
            lockOntoPlayer()
        else
            Mouse.TargetFilter = nil
            lockedPlayer = nil
            targetLock = false
        end
    end
end)
 
RunService.RenderStepped:Connect(function()
    if targetLock then
        updateLock()
    end
end)
