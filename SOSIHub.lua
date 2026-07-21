-- ============================================

-- 1. ЗАГРУЗКА БИБЛИОТЕКИ (ORION LIBRARY)

-- ============================================

local success, OrionLib = pcall(function()

    return loadstring(game:HttpGet('https://raw.githubusercontent.com/jensonhirst/Orion/main/source'))()

end)



if not success or type(OrionLib) ~= "table" then

    warn("[SOSI Hub]: Не удалось загрузить Orion Library!")

    return

end



-- ============================================

-- 2. СЕРВИСЫ И ОЧИСТКА BLUR

-- ============================================

local Players = game:GetService("Players")

local Lighting = game:GetService("Lighting")

local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local Camera = workspace.CurrentCamera



local ActiveConnections = {}



local function TrackConnection(connection)

    table.insert(ActiveConnections, connection)

    return connection

end



local function ClearUIBlur()

    for _, child in ipairs(Lighting:GetChildren()) do

        if child:IsA("BlurEffect") then

            child:Destroy()

        end

    end

end



TrackConnection(Lighting.ChildAdded:Connect(function(child)

    if child:IsA("BlurEffect") then

        task.wait(0.1)

        child:Destroy()

    end

end))



ClearUIBlur()



-- ============================================

-- 3. СОЗДАНИЕ ОКНА И ВКЛАДОК

-- ============================================

local Window = OrionLib:MakeWindow({

    Name = "SOSI Hub",

    HidePremium = true,

    SaveConfig = false,

    IntroTitle = "SOSI Hub",

    IntroText = "Visuals & Utilities",

    IntroIcon = "rbxassetid://4483362458"

})



local TabFake = Window:MakeTab({Name = "Fake Items", Icon = "rbxassetid://4483362458", PremiumOnly = false})

local TabVisuals = Window:MakeTab({Name = "Visuals", Icon = "rbxassetid://4483362458", PremiumOnly = false})

local TabESP = Window:MakeTab({Name = "ESP & TSB", Icon = "rbxassetid://4483362458", PremiumOnly = false})

local TabCommands = Window:MakeTab({Name = "Commands", Icon = "rbxassetid://4483362458", PremiumOnly = false})

local TabSettings = Window:MakeTab({Name = "Settings", Icon = "rbxassetid://4483362458", PremiumOnly = false})



local function SendNotification(Title, Text)

    OrionLib:MakeNotification({

        Name = Title or "SOSI Hub",

        Content = Text or "",

        Time = 4

    })

end



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

local ResolutionConnection = nil



-- ============ СИСТЕМА РАЗРЕШЕНИЯ ============

local function UpdateResolutionConnection()

    if ResolutionEnabled then

        if not ResolutionConnection then

            ResolutionConnection = TrackConnection(RunService.RenderStepped:Connect(function()

                if Camera then

                    Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, ResolutionScale, 0, 0, 0, 1)

                end

            end))

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

        SendNotification("FullBright", "Full brightness mode enabled")

    else

        _G.FullBrightEnabled = false

        if _G.NormalLightingSettings then

            Lighting.Brightness = _G.NormalLightingSettings.Brightness

            Lighting.ClockTime = _G.NormalLightingSettings.ClockTime

            Lighting.FogEnd = _G.NormalLightingSettings.FogEnd

            Lighting.GlobalShadows = _G.NormalLightingSettings.GlobalShadows

            Lighting.Ambient = _G.NormalLightingSettings.Ambient

        end

        SendNotification("FullBright", "Full brightness mode disabled")

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

        SendNotification("No Shadows", "Shadows disabled")

    else

        if _G.NormalLightingSettings then

            Lighting.GlobalShadows = _G.NormalLightingSettings.GlobalShadows

        else

            Lighting.GlobalShadows = true

        end

        SendNotification("No Shadows", "Shadows enabled")

    end

end

 

-- ============ ADVANCED ESP SYSTEM ============

local ESPBoxEnabled = false

local ESPNameEnabled = false

local ESPHighlightEnabled = false

local HideOriginalNamesEnabled = false



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

        connection = TrackConnection(RunService.RenderStepped:Connect(function()

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

        end))

    end



    TrackConnection(player.CharacterAdded:Connect(function(newChar)

        task.wait(1)

        updateDrawings()

    end))



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



TrackConnection(Players.PlayerAdded:Connect(function(player)

    if ESPBoxEnabled or ESPNameEnabled or ESPHighlightEnabled or HideOriginalNamesEnabled then

        SetupPlayerESP(player)

    end

end))



TrackConnection(Players.PlayerRemoving:Connect(function(player)

    RemoveESP(player)

end))



-- ============ TSB DEATH COUNTER ESP SYSTEM ============

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

        hl.FillColor = Color3.fromRGB(0, 150, 255)

        hl.OutlineColor = Color3.fromRGB(255, 255, 255)

        hl.FillTransparency = 0.4

        hl.OutlineTransparency = 0

        hl.Parent = target

        

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



TrackConnection(RunService.Heartbeat:Connect(function()

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

                        applyDeathCounterHighlight(char)

                        tsbState[plr] = "weak"

                    end

                end

            end

        end

    end

end))

 

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

    SendNotification("Fake Items", "Fake Headless & Korblox Applied!")

end

 

TrackConnection(LocalPlayer.CharacterAdded:Connect(function(newCharacter)

    if AlwaysFakeEnabled then

        newCharacter:WaitForChild("Humanoid")

        task.wait(0.5)

        ApplyFakeItems()

    end

end))

 

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

            TrackConnection(PingLabel:GetPropertyChangedSignal("Text"):Connect(function()

                PingLabel.Text = "1 ms"

            end))

            PingLabel.Text = "1 ms"

            SendNotification("Ping Spoof", "Ping now always shows 1 ms")

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

        AntiVoidConnection = TrackConnection(RunService.Heartbeat:Connect(function()

            local char = LocalPlayer.Character

            if char then

                local root = char:FindFirstChild("HumanoidRootPart")

                if root and root.Position.Y <= 0 then

                    root.CFrame = CFrame.new(-31, 460, -115)

                    SendNotification("Anti-Void", "Телепортирован на X: -31, Y: 460, Z: -115")

                end

            end

        end))

        SendNotification("Anti-Void", "Защита от падения включена")

    else

        SendNotification("Anti-Void", "Защита от падения выключена")

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

        NoclipConnection = TrackConnection(RunService.Stepped:Connect(function()

            local char = LocalPlayer.Character

            if char then

                for _, part in ipairs(char:GetDescendants()) do

                    if part:IsA("BasePart") and part.CanCollide then

                        part.CanCollide = false

                    end

                end

            end

        end))

        SendNotification("Noclip", "Noclip enabled")

    else

        SendNotification("Noclip", "Noclip disabled")

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

            TPWalkConnection = TrackConnection(RunService.Heartbeat:Connect(function(delta)

                if TPWalkEnabled and LocalPlayer.Character then

                    local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

                    if hum and hum.MoveDirection.Magnitude > 0 then

                        LocalPlayer.Character:TranslateBy(hum.MoveDirection * (TPWalkSpeed / 16) * delta * 16)

                    end

                end

            end))

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

        SendNotification("Spawnpoint", "Spawnpoint saved")

    end

end

 

local function ClearSpawnPoint()

    CustomSpawnCFrame = nil

    SendNotification("Spawnpoint", "Spawnpoint cleared")

end

 

TrackConnection(LocalPlayer.CharacterAdded:Connect(function(char)

    if CustomSpawnCFrame then

        local root = char:WaitForChild("HumanoidRootPart", 10)

        if root then

            task.wait(0.3)

            root.CFrame = CustomSpawnCFrame

        end

    end

end))

 

local function ResetCharacter()

    local char = LocalPlayer.Character

    if char then

        local hum = char:FindFirstChildOfClass("Humanoid")

        if hum then

            hum.Health = 0

            SendNotification("Reset", "Character reset")

        end

    end

end



-- ============ ФУНКЦИЯ UNLOAD SCRIPT ============

local function UnloadScript()

    for _, conn in ipairs(ActiveConnections) do

        if typeof(conn) == "RBXScriptConnection" then

            pcall(function() conn:Disconnect() end)

        end

    end

    ActiveConnections = {}



    for _, player in ipairs(Players:GetPlayers()) do

        RemoveESP(player)

        if player.Character and player.Character:FindFirstChild("DeathCounterHighlight") then

            player.Character.DeathCounterHighlight:Destroy()

        end

    end



    if _G.NormalLightingSettings then

        pcall(function()

            Lighting.Brightness = _G.NormalLightingSettings.Brightness

            Lighting.ClockTime = _G.NormalLightingSettings.ClockTime

            Lighting.FogEnd = _G.NormalLightingSettings.FogEnd

            Lighting.GlobalShadows = _G.NormalLightingSettings.GlobalShadows

            Lighting.Ambient = _G.NormalLightingSettings.Ambient

        end)

    end

    _G.FullBrightEnabled = false

    _G.FullBrightExecuted = nil



    OrionLib:Destroy()

    print("[SOSI Hub]: Скрипт полностью выгружен!")

end



-- ============================================

-- 6. ЭЛЕМЕНТЫ ИНТЕРФЕЙСА (ORION UI)

-- ============================================



-- Fake Items Tab

TabFake:AddButton({

    Name = "👑 Enable Fake Headless & Korblox",

    Callback = function()

        if not FakeEnabled then

            ApplyFakeItems()

            FakeEnabled = true

        else

            SendNotification("Fake Items", "Already enabled!")

        end

    end

})

 

TabFake:AddToggle({

    Name = "👑 Always Fake Headless & Korblox",

    Default = false,

    Callback = function(Value)

        AlwaysFakeEnabled = Value

        if Value then

            ApplyFakeItems()

            FakeEnabled = true

        else

            SendNotification("Auto Fake Items", "Always fake items disabled!")

        end

    end

})

 

TabFake:AddToggle({

    Name = "📶 Spoof Ping (1 ms)",

    Default = false,

    Callback = function(Value)

        PingSpoofEnabled = Value

        if Value then

            EnablePingSpoof()

        else

            SendNotification("Ping Spoof", "Ping spoofing disabled")

        end

    end

})

 

-- Visuals Tab

TabVisuals:AddToggle({

    Name = "☀️ FullBright",

    Default = false,

    Callback = function(Value)

        ToggleFullBrightFunc(Value)

    end

})

 

TabVisuals:AddToggle({

    Name = "🌑 No Shadows",

    Default = false,

    Callback = function(Value)

        ToggleNoShadowsFunc(Value)

    end

})



TabVisuals:AddToggle({

    Name = "🖥️ Custom Resolution Mod",

    Default = false,

    Callback = function(Value)

        ResolutionEnabled = Value

        UpdateResolutionConnection()

        if Value then

            SendNotification("Resolution Mod", "Кастомное разрешение включено")

        else

            SendNotification("Resolution Mod", "Разрешение сброшено")

        end

    end

})

 

TabVisuals:AddSlider({

    Name = "🎯 Resolution Scale (%)",

    Min = 10,

    Max = 100,

    Default = 80,

    Color = Color3.fromRGB(255,255,255),

    Increment = 5,

    ValueName = "%",

    Callback = function(Value)

        ResolutionScale = Value / 100

    end

})

 

TabVisuals:AddButton({

    Name = "🔄 Reset Lighting",

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

            SendNotification("Lighting Reset", "Lighting settings have been reset")

        end

    end

})



-- ESP & TSB Tab

TabESP:AddToggle({

    Name = "📦 ESP Boxes",

    Default = false,

    Callback = function(Value)

        ESPBoxEnabled = Value

        RefreshESPState()

    end

})



TabESP:AddToggle({

    Name = "📝 ESP Names",

    Default = false,

    Callback = function(Value)

        ESPNameEnabled = Value

        RefreshESPState()

    end

})



TabESP:AddToggle({

    Name = "✨ ESP Highlight",

    Default = false,

    Callback = function(Value)

        ESPHighlightEnabled = Value

        RefreshESPState()

    end

})



TabESP:AddToggle({

    Name = "🫥 Hide Original Names",

    Default = false,

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

})



TabESP:AddToggle({

    Name = "☠ TSB Death Counter ESP",

    Default = true,

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

})

 

-- Commands Tab

TabCommands:AddToggle({

    Name = "🛡️ Anti-Void (TP to -31, 460, -115)",

    Default = false,

    Callback = function(Value)

        ToggleAntiVoid(Value)

    end

})



TabCommands:AddToggle({

    Name = "👻 Noclip",

    Default = false,

    Callback = function(Value)

        ToggleNoclip(Value)

    end

})



TabCommands:AddSlider({

    Name = "🏃 TPWalk Speed",

    Min = 16,

    Max = 100,

    Default = 16,

    Color = Color3.fromRGB(255,255,255),

    Increment = 1,

    ValueName = "Speed",

    Callback = function(Value)

        UpdateTPWalk(Value)

    end

})



TabCommands:AddButton({

    Name = "📍 Set Custom Spawnpoint",

    Callback = function()

        SetSpawnPoint()

    end

})



TabCommands:AddButton({

    Name = "❌ Clear Custom Spawnpoint",

    Callback = function()

        ClearSpawnPoint()

    end

})



TabCommands:AddButton({

    Name = "💀 Reset Character",

    Callback = function()

        ResetCharacter()

    end

})



-- Settings Tab (Unload)

TabSettings:AddButton({

    Name = "🛑 Unload Script",

    Callback = function()

        UnloadScript()

    end

})



OrionLib:Init()

SendNotification("SOSI Hub", "Скрипт успешно загружен со всеми функциями!") 
