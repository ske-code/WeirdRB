local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/cat"))()
local Window = Library:CreateWindow("ske.gg", Vector2.new(492, 598), Enum.KeyCode.RightControl)
local AimingTab = Window:CreateTab("Ragebot")

local RagebotSection = AimingTab:CreateSector("Ragebot Settings", "left")
local TracerSection = AimingTab:CreateSector("Tracer Settings", "right")
local ProtectSection = AimingTab:CreateSector("Protect Settings", "left")

local EnabledToggle = RagebotSection:AddToggle("Enabled", false, function(state)
    getgenv().RagebotEnabled = state
end)

local FireRateSlider = RagebotSection:AddSlider("FireRate", 1, 500, 1000, 1, function(value)
    getgenv().FireRate = value
    getgenv().FireWait = 1 / value
end)

local HitSoundDropdown = RagebotSection:AddDropdown("HitSound", {"Bell", "None", "Classic"}, "Bell", true, function(selected)
    getgenv().HitSoundId = selected == "Bell" and "rbxassetid://6534948092" 
                         or selected == "None" and "rbxassetid://4817809188" 
                         or "rbxassetid://160432334"
end)

local DamageSlider = RagebotSection:AddSlider("Damage", 1, 999, 999, 1, function(value)
    getgenv().DamageValue = value
end)

local TeamCheckToggle = RagebotSection:AddToggle("TeamCheck", true, function(state)
    getgenv().TeamCheck = state
end)

local WallbangToggle = RagebotSection:AddToggle("Wallbang", false, function(state)
    getgenv().Wallbang = state
end)

local RandomBulletToggle = RagebotSection:AddToggle("Random Bullet", false, function(state)
    getgenv().RandomBullet = state
end)

local RandomOffsetSlider = RagebotSection:AddSlider("Random Offset", 1, 5, 20, 1, function(value)
    getgenv().RandomOffset = value
end)

local TracerToggle = TracerSection:AddToggle("Tracer", true, function(state)
    getgenv().ShowTracer = state
end)

local BrightnessSlider = TracerSection:AddSlider("Brightness", 1, 5, 10, 1, function(value)
    getgenv().TracerBrightness = value
end)

local LightEmissionSlider = TracerSection:AddSlider("Light Emission", 0, 1, 1, 0.1, function(value)
    getgenv().TracerLightEmission = value
end)

local TextureSpeedSlider = TracerSection:AddSlider("Texture Speed", 0, 2, 10, 0.1, function(value)
    getgenv().TracerTextureSpeed = value
end)

local TracerWidthSlider = TracerSection:AddSlider("Width", 0.1, 0.5, 2, 0.1, function(value)
    getgenv().TracerWidth = value
end)

local TracerLifetimeSlider = TracerSection:AddSlider("Lifetime", 1, 5, 100, 1, function(value)
    getgenv().TracerLifetime = value / 10
end)

local ColorTextbox = TracerSection:AddTextbox("Color (R,G,B)", "180,143,255", function(text)
    local r, g, b = text:match("(%d+),(%d+),(%d+)")
    if r and g and b then
        getgenv().TracerColor = Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b))
    end
end)

local ProtectToggle = ProtectSection:AddToggle("Protect", false, function(state)
    getgenv().ProtectEnabled = state
    if state then
        protectPlayerName()
    end
end)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local localPlayer = Players.LocalPlayer

getgenv().RagebotEnabled = false
getgenv().FireRate = 500
getgenv().FireWait = 1 / 500
getgenv().HitSoundId = "rbxassetid://6534948092"
getgenv().DamageValue = 999
getgenv().TeamCheck = true
getgenv().Wallbang = false
getgenv().RandomBullet = false
getgenv().RandomOffset = 5
getgenv().ShowTracer = true
getgenv().TracerBrightness = 5
getgenv().TracerLightEmission = 1
getgenv().TracerTextureSpeed = 2
getgenv().TracerWidth = 0.5
getgenv().TracerLifetime = 0.5
getgenv().TracerColor = Color3.fromRGB(180, 143, 255)
getgenv().ProtectEnabled = false

function protectPlayerName()
    if not getgenv().ProtectEnabled then return end
    
    local randomNames = {
        "Player_" .. math.random(10000, 99999),
        "User_" .. math.random(1000, 9999),
        "Guest_" .. math.random(100, 999),
        "Anonymous_" .. math.random(100000, 999999)
    }
    
    local originalName = localPlayer.Name
    local randomName = randomNames[math.random(1, #randomNames)]
    
    localPlayer.Name = randomName
    
    spawn(function()
        while getgenv().ProtectEnabled do
            wait(math.random(5, 15))
            if localPlayer.Name == randomName then
                local newRandomName = randomNames[math.random(1, #randomNames)]
                if newRandomName ~= randomName then
                    localPlayer.Name = newRandomName
                    randomName = newRandomName
                end
            end
        end
        localPlayer.Name = originalName
    end)
end

function createHitSound(position)
    local soundPart = Instance.new("Part")
    soundPart.Size = Vector3.new(1, 1, 1)
    soundPart.Transparency = 1
    soundPart.Anchored = true
    soundPart.CanCollide = false
    soundPart.Position = position
    soundPart.Parent = Workspace
    
    local sound = Instance.new("Sound")
    sound.SoundId = getgenv().HitSoundId
    sound.Volume = 0.7
    sound.Parent = soundPart
    sound:Play()
    
    sound.Ended:Connect(function()
        soundPart:Destroy()
    end)
end

function createBeamTracer(startPos, endPos)
    if not getgenv().ShowTracer then return end
    
    local distance = (endPos - startPos).Magnitude
    
    local beam = Instance.new("Beam")
    beam.Color = ColorSequence.new(getgenv().TracerColor)
    beam.Width0 = getgenv().TracerWidth
    beam.Width1 = getgenv().TracerWidth
    beam.Texture = "rbxassetid://7136858729"
    beam.TextureSpeed = getgenv().TracerTextureSpeed
    beam.TextureLength = distance / 5
    beam.Brightness = getgenv().TracerBrightness
    beam.LightEmission = getgenv().TracerLightEmission
    beam.FaceCamera = true
    
    local attachment0 = Instance.new("Attachment")
    local attachment1 = Instance.new("Attachment")
    attachment0.WorldPosition = startPos
    attachment1.WorldPosition = endPos
    
    beam.Attachment0 = attachment0
    beam.Attachment1 = attachment1
    beam.Parent = Workspace
    attachment0.Parent = Workspace
    attachment1.Parent = Workspace
    
    delay(getgenv().TracerLifetime, function()
        beam:Destroy()
        attachment0:Destroy()
        attachment1:Destroy()
    end)
end

function getRandomOffsetPosition(targetPosition)
    local offset = Vector3.new(
        math.random(-getgenv().RandomOffset, getgenv().RandomOffset),
        math.random(-getgenv().RandomOffset, getgenv().RandomOffset),
        math.random(-getgenv().RandomOffset, getgenv().RandomOffset)
    )
    return targetPosition + offset
end

function getCurrentTool()
    if localPlayer.Character then
        for _, tool in pairs(localPlayer.Character:GetChildren()) do
            if tool:IsA("Tool") then
                return tool
            end
        end
    end
    return nil
end

function shouldTargetPlayer(player)
    if not getgenv().TeamCheck then
        return true
    end
    
    if not localPlayer.Team or not player.Team then
        return true
    end
    
    return player.Team ~= localPlayer.Team
end

function getNearestTarget()
    local nearestTarget = nil
    local shortestDistance = math.huge
    local targetPosition = nil
    local targetHumanoid = nil
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and shouldTargetPlayer(player) and player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if humanoid and humanoid.Health > 0 and humanoidRootPart then
                local distance = (humanoidRootPart.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    nearestTarget = player
                    targetPosition = humanoidRootPart.Position
                    targetHumanoid = humanoid
                end
            end
        end
    end
    
    local serverBots = Workspace:FindFirstChild("ServerBots")
    if serverBots then
        for _, npc in pairs(serverBots:GetChildren()) do
            if npc:IsA("Model") then
                local humanoid = npc:FindFirstChild("Humanoid")
                local humanoidRootPart = npc:FindFirstChild("HumanoidRootPart")
                if humanoid and humanoidRootPart then
                    local distance = (humanoidRootPart.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        nearestTarget = npc
                        targetPosition = humanoidRootPart.Position
                        targetHumanoid = humanoid
                    end
                end
            end
        end
    end
    
    return nearestTarget, targetPosition, targetHumanoid
end

spawn(function()
    while true do
        wait(getgenv().FireWait)
        if getgenv().RagebotEnabled and localPlayer.Character then
            local tool = getCurrentTool()
            local nearestTarget, targetPosition, targetHumanoid = getNearestTarget()
            
            if tool and nearestTarget and targetPosition and targetHumanoid then
                local finalTargetPosition = targetPosition
                
                if getgenv().RandomBullet then
                    finalTargetPosition = getRandomOffsetPosition(targetPosition)
                end
                
                local args = {
                    os.clock(),
                    tool,
                    CFrame.lookAt(localPlayer.Character.HumanoidRootPart.Position, finalTargetPosition),
                    getgenv().Wallbang,
                    {
                        ["1"] = {
                            targetHumanoid,
                            false,
                            true,
                            getgenv().DamageValue
                        }
                    }
                }
                
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Shoot"):FireServer(unpack(args))
                createBeamTracer(localPlayer.Character.HumanoidRootPart.Position, finalTargetPosition)
                createHitSound(targetPosition)
            end
        end
    end
end)

AimingTab:CreateConfigSystem("right")
