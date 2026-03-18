--[[ 
    NYTRAX CHEATS 1.0 - REVISÃO FINAL
    Base: Velocidade Original 1.0 (Bypass High Speed)
    Removido: Noclip
    Integrado: Novo ESP (Box Outline + Inv 5s)
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local StartTime = tick()

_G.Settings = {
    Aimbot = false, Smoothness = 100, FOV = 120, ShowFOV = false,
    ESP = false, ESPLines = false, ESPBox = false, ESPInv = false,
    SafeSpeed = 16, InfiniteJump = false, 
    Optimizer = false, SpinBot = false, SpinSpeed = 50
}

-- === SISTEMA DE INVENTÁRIO (5 SEGUNDOS) ===
local PlayerInvs = {}
task.spawn(function()
    while true do
        if _G.Settings.ESPInv then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then
                    local items = {}
                    if p:FindFirstChild("Backpack") then
                        for _, item in pairs(p.Backpack:GetChildren()) do table.insert(items, item.Name) end
                    end
                    if p.Character then
                        for _, item in pairs(p.Character:GetChildren()) do
                            if item:IsA("Tool") then table.insert(items, item.Name .. " (Mão)") end
                        end
                    end
                    PlayerInvs[p] = #items > 0 and table.concat(items, ", ") or "Vazio"
                end
            end
        end
        task.wait(5)
    end
end)

-- === LIMPEZA DE ESP ===
local ESP_Data = {}
local function RemoveESP(Player)
    if ESP_Data[Player] then
        for _, obj in pairs(ESP_Data[Player]) do obj:Remove() end
        ESP_Data[Player] = nil
    end
end
Players.PlayerRemoving:Connect(RemoveESP)

-- === MODO BATATA E FPS ===
local FPSGui = Instance.new("ScreenGui", game.CoreGui)
local FPSLabel = Instance.new("TextLabel", FPSGui)
FPSLabel.Size = UDim2.new(0, 100, 0, 30); FPSLabel.Position = UDim2.new(0, 10, 0, 10)
FPSLabel.BackgroundTransparency = 1; FPSLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
FPSLabel.Font = Enum.Font.GothamBold; FPSLabel.TextSize = 16; FPSLabel.Text = "FPS: 0"; FPSLabel.Visible = false

local frameCount = 0
local lastUpdate = tick()
RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    if tick() - lastUpdate >= 1 then
        FPSLabel.Text = "FPS: " .. frameCount
        frameCount = 0; lastUpdate = tick()
    end
end)

local function ApplyUltraPotato()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation") then
            v.Material = Enum.Material.SmoothPlastic; v.Reflectance = 0
        elseif v:IsA("Decal") or v:IsA("Texture") then v:Destroy() end
    end
    Lighting.GlobalShadows = false; settings().Rendering.QualityLevel = 1; FPSLabel.Visible = true
end

-- === JANELA NYTRAX 1.0 ===
local Window = Rayfield:CreateWindow({
   Name = "Nytrax Cheats 1.0",
   LoadingTitle = "Nytrax Premium",
   LoadingSubtitle = "O melhor para SRP",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "NytraxHub"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = true,
   KeySettings = {
      Title = "Nytrax Cheats - Segurança",
      Subtitle = "Key System",
      Note = "Pegue sua key no Discord.",
      FileName = "NytraxKey",
      SaveKey = true,
      GrabKeyFromSite = true,
      Key = {"https://raw.githubusercontent.com/Silveira2017/nytrax-keys/main/keys.json"}
   }
})

local TabC = Window:CreateTab("Combat", 4483362458)
local TabP = Window:CreateTab("Player", 4483362458)
local TabV = Window:CreateTab("Visual/Mundo", 4483362458)
local TabI = Window:CreateTab("Servidor/Info", 4483362458)

-- COMBAT
TabC:CreateToggle({Name = "Ativar Aimbot", CurrentValue = false, Callback = function(v) _G.Settings.Aimbot = v end})
TabC:CreateSlider({Name = "Suavidade", Range = {1, 100}, Increment = 1, CurrentValue = 100, Callback = function(v) _G.Settings.Smoothness = v end})
TabC:CreateSlider({Name = "Raio FOV", Range = {30, 800}, Increment = 5, CurrentValue = 120, Callback = function(v) _G.Settings.FOV = v end})
TabC:CreateToggle({Name = "Mostrar Círculo", CurrentValue = false, Callback = function(v) _G.Settings.ShowFOV = v end})

-- PLAYER (VOLTADO SPEED 1.0)
TabP:CreateSlider({
   Name = "Velocidade (Bypass 1.0)", 
   Range = {16, 400}, 
   Increment = 1, 
   CurrentValue = 16, 
   Callback = function(v) _G.Settings.SafeSpeed = v end
})
TabP:CreateToggle({Name = "Spin Bot", CurrentValue = false, Callback = function(v) _G.Settings.SpinBot = v end})
TabP:CreateToggle({Name = "Pulo Infinito", CurrentValue = false, Callback = function(v) _G.Settings.InfiniteJump = v end})

-- VISUAL
TabV:CreateToggle({Name = "ESP Nome/Vida", CurrentValue = false, Callback = function(v) _G.Settings.ESP = v end})
TabV:CreateToggle({Name = "ESP Box (Outline)", CurrentValue = false, Callback = function(v) _G.Settings.ESPBox = v end})
TabV:CreateToggle({Name = "ESP Inventário (5s)", CurrentValue = false, Callback = function(v) _G.Settings.ESPInv = v end})
TabV:CreateToggle({Name = "ESP Linhas", CurrentValue = false, Callback = function(v) _G.Settings.ESPLines = v end})
TabV:CreateToggle({Name = "Modo Batata", CurrentValue = false, Callback = function(v) if v then ApplyUltraPotato() end end})

-- INFO
TabI:CreateLabel("Script: Nytrax Cheats 1.0")
TabI:CreateLabel("Mapa: " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name)

-- === LOOP DE RENDERIZAÇÃO ===
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5; FOVCircle.Color = Color3.new(1,1,1); FOVCircle.Filled = false

RunService.RenderStepped:Connect(function()
    FOVCircle.Visible = _G.Settings.ShowFOV
    FOVCircle.Radius = _G.Settings.FOV
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

    -- SPEED ORIGINAL 1.0 (BYPASS SRP)
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if hum and _G.Settings.SafeSpeed > 16 and hum.MoveDirection.Magnitude > 0 then
        -- Usando o multiplicador original da versão que você gostou
        LocalPlayer.Character:TranslateBy(hum.MoveDirection * (_G.Settings.SafeSpeed / 100) * 0.5)
    end

    -- ESP RENDERING
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            if not ESP_Data[p] then
                ESP_Data[p] = { Line = Drawing.new("Line"), Box = Drawing.new("Square"), Text = Drawing.new("Text") }
            end
            local data = ESP_Data[p]
            local char = p.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    if _G.Settings.ESP or _G.Settings.ESPInv then
                        data.Text.Visible = true; data.Text.Position = Vector2.new(pos.X, pos.Y - 45)
                        local txt = p.Name .. " [" .. math.floor(char.Humanoid.Health) .. " HP]"
                        if _G.Settings.ESPInv then txt = txt .. "\nInv: " .. (PlayerInvs[p] or "...") end
                        data.Text.Text = txt; data.Text.Center = true; data.Text.Outline = true; data.Text.Size = 13; data.Text.Color = Color3.new(1,1,1)
                    else data.Text.Visible = false end

                    if _G.Settings.ESPBox then
                        data.Box.Visible = true; data.Box.Filled = false; data.Box.Thickness = 1
                        data.Box.Size = Vector2.new(2200/pos.Z, 3200/pos.Z)
                        data.Box.Position = Vector2.new(pos.X - data.Box.Size.X/2, pos.Y - data.Box.Size.Y/2)
                        data.Box.Color = Color3.fromRGB(0, 255, 120)
                    else data.Box.Visible = false end

                    if _G.Settings.ESPLines then
                        data.Line.Visible = true; data.Line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y); data.Line.To = Vector2.new(pos.X, pos.Y)
                    else data.Line.Visible = false end
                else data.Text.Visible = false; data.Box.Visible = false; data.Line.Visible = false end
            else data.Text.Visible = false; data.Box.Visible = false; data.Line.Visible = false end
        end
    end

    -- SPINBOT & AIMBOT
    if _G.Settings.SpinBot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(50), 0)
    end
    if _G.Settings.Aimbot then
        local target, dist = nil, _G.Settings.FOV
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local p_pos, p_on = Camera:WorldToViewportPoint(p.Character.Head.Position)
                local mag = (Vector2.new(p_pos.X, p_pos.Y) - FOVCircle.Position).Magnitude
                if p_on and mag < dist then target = p.Character.Head; dist = mag end
            end
        end
        if target then Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Position), _G.Settings.Smoothness / 100) end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if _G.Settings.InfiniteJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

Rayfield:Notify({Title = "Nytrax 1.0", Content = "Speed Original e Novo ESP Ativos!", Duration = 3})
