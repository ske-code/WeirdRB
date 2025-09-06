local repo = 'https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()
local Options = Library.Options
local Toggles = Library.Toggles

Library.ShowToggleFrameInKeybinds = true
Library.ShowCustomCursor = true
Library.NotifySide = "Left"

local Window = Library:CreateWindow({
    Title = 'ske.gg - Ragebot',
    Center = true,
    AutoShow = true,
    Resizable = true,
    ShowCustomCursor = true,
    NotifySide = "Left",
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local Tabs = {
    Ragebot = Window:AddTab('Ragebot'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

local RagebotLeft = Tabs.Ragebot:AddLeftGroupbox('Ragebot Settings')
local RagebotRight = Tabs.Ragebot:AddRightGroupbox('Tracer Settings')
local ProtectRight = Tabs.Ragebot:AddRightGroupbox('Protect Settings')
local LogsRight = Tabs.Ragebot:AddRightGroupbox('Hit Logs Settings')

getgenv().RagebotEnabled = false
getgenv().FireRate = 500
getgenv().FireWait = 0.002
getgenv().HitSoundId = "rbxassetid://6534948092"
getgenv().DamageValue = 999
getgenv().TeamCheck = true
getgenv().Wallbang = false
getgenv().RandomBullet = false
getgenv().RandomOffset = 5
getgenv().RandomAngle = false
getgenv().RandomAngleAmount = 5
getgenv().ShowTracer = true
getgenv().TracerBrightness = 5
getgenv().TracerLightEmission = 1
getgenv().TracerTextureSpeed = 2
getgenv().TracerWidth = 0.5
getgenv().TracerLifetime = 0.5
getgenv().TracerColor = Color3.fromRGB(180, 143, 255)
getgenv().ProtectEnabled = false
getgenv().TargetLockEnabled = false
getgenv().TargetList = {}
getgenv().Whitelist = {}
getgenv().HitLogsEnabled = true
getgenv().HitLogsDuration = 5

RagebotLeft:AddToggle('RagebotEnabled', {
    Text = 'Enabled',
    Default = false,
    Callback = function(Value)
        getgenv().RagebotEnabled = Value
    end
})

RagebotLeft:AddSlider('FireRate', {
    Text = 'FireRate',
    Default = 500,
    Min = 1,
    Max = 1000,
    Rounding = 0,
    Callback = function(Value)
        getgenv().FireRate = Value
        getgenv().FireWait = 1 / Value
    end
})

RagebotLeft:AddDropdown('HitSound', {
    Values = {'Bell', 'None', 'Classic'},
    Default = 1,
    Callback = function(Value)
        getgenv().HitSoundId = Value == "Bell" and "rbxassetid://6534948092" 
                             or Value == "None" and "rbxassetid://4817809188" 
                             or "rbxassetid://160432334"
    end
})

RagebotLeft:AddSlider('Damage', {
    Text = 'Damage',
    Default = 999,
    Min = 1,
    Max = 999,
    Rounding = 0,
    Callback = function(Value)
        getgenv().DamageValue = Value
    end
})

RagebotLeft:AddToggle('TeamCheck', {
    Text = 'TeamCheck',
    Default = true,
    Callback = function(Value)
        getgenv().TeamCheck = Value
    end
})

RagebotLeft:AddToggle('Wallbang', {
    Text = 'Wallbang',
    Default = false,
    Callback = function(Value)
        getgenv().Wallbang = Value
    end
})

RagebotLeft:AddToggle('RandomBullet', {
    Text = 'Random Bullet',
    Default = false,
    Callback = function(Value)
        getgenv().RandomBullet = Value
    end
})

RagebotLeft:AddSlider('RandomOffset', {
    Text = 'Random Offset',
    Default = 5,
    Min = 1,
    Max = 20,
    Rounding = 0,
    Callback = function(Value)
        getgenv().RandomOffset = Value
    end
})

RagebotLeft:AddToggle('RandomAngle', {
    Text = 'Random Angle',
    Default = false,
    Callback = function(Value)
        getgenv().RandomAngle = Value
    end
})

RagebotLeft:AddSlider('RandomAngleAmount', {
    Text = 'Random Angle Amount',
    Default = 5,
    Min = 1,
    Max = 30,
    Rounding = 0,
    Callback = function(Value)
        getgenv().RandomAngleAmount = Value
    end
})

RagebotLeft:AddToggle('TargetLock', {
    Text = 'Target Lock',
    Default = false,
    Callback = function(Value)
        getgenv().TargetLockEnabled = Value
        if not Value then
            getgenv().LockedTarget = nil
        end
    end
})

RagebotLeft:AddDropdown('TargetList', {
    Values = {},
    Default = 1,
    Multi = true,
    Text = 'Target List',
    Callback = function(Value, Key, State)
        getgenv().TargetList = {}
        for name, selected in pairs(Options.TargetList.Value) do
            if selected then
                table.insert(getgenv().TargetList, name)
            end
        end
    end
})

RagebotLeft:AddDropdown('Whitelist', {
    Values = {},
    Default = 1,
    Multi = true,
    Text = 'Whitelist',
    Callback = function(Value, Key, State)
        getgenv().Whitelist = {}
        for name, selected in pairs(Options.Whitelist.Value) do
            if selected then
                table.insert(getgenv().Whitelist, name)
            end
        end
    end
})

RagebotRight:AddToggle('ShowTracer', {
    Text = 'Tracer',
    Default = true,
    Callback = function(Value)
        getgenv().ShowTracer = Value
    end
}):AddColorPicker('TracerColor', {
    Default = Color3.fromRGB(180, 143, 255),
    Callback = function(Value)
        getgenv().TracerColor = Value
    end
})

RagebotRight:AddSlider('TracerBrightness', {
    Text = 'Brightness',
    Default = 5,
    Min = 1,
    Max = 10,
    Rounding = 0,
    Callback = function(Value)
        getgenv().TracerBrightness = Value
    end
})

RagebotRight:AddSlider('TracerLightEmission', {
    Text = 'Light Emission',
    Default = 1,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Callback = function(Value)
        getgenv().TracerLightEmission = Value
    end
})

RagebotRight:AddSlider('TracerTextureSpeed', {
    Text = 'Texture Speed',
    Default = 2,
    Min = 0,
    Max = 10,
    Rounding = 1,
    Callback = function(Value)
        getgenv().TracerTextureSpeed = Value
    end
})

RagebotRight:AddSlider('TracerWidth', {
    Text = 'Width',
    Default = 0.5,
    Min = 0.1,
    Max = 2,
    Rounding = 1,
    Callback = function(Value)
        getgenv().TracerWidth = Value
    end
})

RagebotRight:AddSlider('TracerLifetime', {
    Text = 'Lifetime',
    Default = 5,
    Min = 1,
    Max = 100,
    Rounding = 0,
    Callback = function(Value)
        getgenv().TracerLifetime = Value / 10
    end
})

ProtectRight:AddToggle('ProtectEnabled', {
    Text = 'Protect',
    Default = false,
    Callback = function(Value)
        getgenv().ProtectEnabled = Value
        if Value then
            protectPlayerName()
        else
            restorePlayerName()
        end
    end
})

LogsRight:AddToggle('HitLogsEnabled', {
    Text = 'Hit Logs',
    Default = true,
    Callback = function(Value)
        getgenv().HitLogsEnabled = Value
    end
})

LogsRight:AddSlider('HitLogsDuration', {
    Text = 'Logs Duration',
    Default = 5,
    Min = 1,
    Max = 10,
    Rounding = 0,
    Callback = function(Value)
        getgenv().HitLogsDuration = Value
    end
})

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local localPlayer = Players.LocalPlayer
local originalName = localPlayer.Name
local originalDisplayName = localPlayer.DisplayName

function updatePlayerLists()
    local playerNames = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            table.insert(playerNames, player.Name)
        end
    end
    
    Options.TargetList:SetValues(playerNames)
    Options.Whitelist:SetValues(playerNames)
end

function protectPlayerName()
    if not getgenv().ProtectEnabled then return end
    
    local randomNames = {
        "Player_" .. math.random(10000, 99999),
        "User_" .. math.random(1000, 9999),
        "Guest_" .. math.random(100, 999),
        "Anonymous_" .. math.random(100000, 999999)
    }
    
    local randomDisplayNames = {
        "Player" .. math.random(1000, 9999),
        "User" .. math.random(100, 999),
        "Guest" .. math.random(10, 99),
        "Anonymous" .. math.random(1000, 9999)
    }
    
    local randomName = randomNames[math.random(1, #randomNames)]
    local randomDisplayName = randomDisplayNames[math.random(1, #randomDisplayNames)]
    
    localPlayer.Name = randomName
    localPlayer.DisplayName = randomDisplayName
    
    spawn(function()
        while getgenv().ProtectEnabled do
            wait(math.random(5, 15))
            if localPlayer.Name == randomName then
                local newRandomName = randomNames[math.random(1, #randomNames)]
                local newRandomDisplayName = randomDisplayNames[math.random(1, #randomDisplayNames)]
                if newRandomName ~= randomName then
                    localPlayer.Name = newRandomName
                    localPlayer.DisplayName = newRandomDisplayName
                    randomName = newRandomName
                    randomDisplayName = newRandomDisplayName
                end
            end
        end
    end)
end

function restorePlayerName()
    localPlayer.Name = originalName
    localPlayer.DisplayName = originalDisplayName
end

function showHitLog(targetName, damage)
    if not getgenv().HitLogsEnabled then return end
    
    Library:Notify(("Hit %s for %d damage"):format(targetName, damage), getgenv().HitLogsDuration)
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

function getRandomAngleOffset()
    if not getgenv().RandomAngle then return Vector3.zero end
    
    local offset = Vector3.new(
        math.random(-getgenv().RandomAngleAmount, getgenv().RandomAngleAmount),
        math.random(-getgenv().RandomAngleAmount, getgenv().RandomAngleAmount),
        math.random(-getgenv().RandomAngleAmount, getgenv().RandomAngleAmount)
    )
    return offset
end

function createBeamTracer(startPos, endPos)
    if not getgenv().ShowTracer then return end
    
    local visualEndPos = endPos
    if getgenv().RandomAngle then
        local angleOffset = getRandomAngleOffset()
        visualEndPos = endPos + angleOffset
    end
    
    local distance = (visualEndPos - startPos).Magnitude
    
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
    attachment1.WorldPosition = visualEndPos
    
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

function isWhitelisted(player)
    for _, whitelistedName in pairs(getgenv().Whitelist) do
        if player.Name == whitelistedName then
            return true
        end
    end
    return false
end

function shouldTargetPlayer(player)
    if isWhitelisted(player) then return false end
    
    if not getgenv().TeamCheck then return true end
    
    if not localPlayer.Team or not player.Team then return true end
    
    return player.Team ~= localPlayer.Team
end

function getNearestTarget()
    local nearestTarget = nil
    local shortestDistance = math.huge
    local targetPosition = nil
    local targetHumanoid = nil
    
    if getgenv().TargetLockEnabled and getgenv().LockedTarget then
        local target = getgenv().LockedTarget
        if target and target.Character then
            local humanoid = target.Character:FindFirstChild("Humanoid")
            local humanoidRootPart = target.Character:FindFirstChild("HumanoidRootPart")
            if humanoid and humanoid.Health > 0 and humanoidRootPart then
                return target, humanoidRootPart.Position, humanoid
            else
                getgenv().LockedTarget = nil
            end
        else
            getgenv().LockedTarget = nil
        end
    end
    
    local validTargets = {}
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and shouldTargetPlayer(player) and player.Character then
            if #getgenv().TargetList > 0 then
                local isInTargetList = false
                for _, targetName in pairs(getgenv().TargetList) do
                    if player.Name == targetName then
                        isInTargetList = true
                        break
                    end
                end
                if not isInTargetList then
                    continue
                end
            end
            
            local humanoid = player.Character:FindFirstChild("Humanoid")
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if humanoid and humanoid.Health > 0 and humanoidRootPart then
                local distance = (humanoidRootPart.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude
                table.insert(validTargets, {
                    target = player,
                    position = humanoidRootPart.Position,
                    humanoid = humanoid,
                    distance = distance
                })
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
                    table.insert(validTargets, {
                        target = npc,
                        position = humanoidRootPart.Position,
                        humanoid = humanoid,
                        distance = distance
                    })
                end
            end
        end
    end
    
    for _, targetInfo in pairs(validTargets) do
        if targetInfo.distance < shortestDistance then
            shortestDistance = targetInfo.distance
            nearestTarget = targetInfo.target
            targetPosition = targetInfo.position
            targetHumanoid = targetInfo.humanoid
        end
    end
    
    if getgenv().TargetLockEnabled and nearestTarget then
        getgenv().LockedTarget = nearestTarget
    end
    
    return nearestTarget, targetPosition, targetHumanoid
end

function isWallBetween(startPos, endPos)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {localPlayer.Character}
    
    local direction = (endPos - startPos)
    local raycastResult = workspace:Raycast(startPos, direction, raycastParams)
    
    if raycastResult then
        local hitPart = raycastResult.Instance
        if hitPart and hitPart.CanCollide then
            local humanoid = hitPart:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid")
            if not humanoid then
                return true
            end
        end
    end
    return false
end

function getWallbangPosition(startPos, endPos)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {localPlayer.Character}
    
    local direction = (endPos - startPos)
    local raycastResult = workspace:Raycast(startPos, direction, raycastParams)
    
    if raycastResult then
        local hitPosition = raycastResult.Position
        local hitNormal = raycastResult.Normal
        return hitPosition - (hitNormal * 0.1)
    end
    return endPos
end

spawn(function()
    while true do
        wait(getgenv().FireWait)
        if getgenv().RagebotEnabled and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local tool = getCurrentTool()
            local nearestTarget, targetPosition, targetHumanoid = getNearestTarget()
            
            if tool and nearestTarget and targetPosition and targetHumanoid then
                local startPos = localPlayer.Character.HumanoidRootPart.Position
                local finalTargetPosition = targetPosition
                
                if not getgenv().Wallbang then
                    if isWallBetween(startPos, finalTargetPosition) then
                        continue
                    end
                end
                
                local visualTargetPosition = targetPosition
                if getgenv().RandomBullet then
                    visualTargetPosition = getRandomOffsetPosition(targetPosition)
                end
                
                local tracerEndPos = visualTargetPosition
                if getgenv().Wallbang then
                    tracerEndPos = getWallbangPosition(startPos, visualTargetPosition)
                end
                
                local args = {
                    os.clock(),
                    tool,
                    CFrame.lookAt(startPos, finalTargetPosition),
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
                createBeamTracer(startPos, tracerEndPos)
                createHitSound(targetPosition)
                
                if nearestTarget:IsA("Player") then
                    showHitLog(nearestTarget.Name, getgenv().DamageValue)
                end
            end
        end
    end
end)

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })
SaveManager:BuildConfigSection(Tabs['UI Settings'])
ThemeManager:ApplyToTab(Tabs['UI Settings'])
SaveManager:LoadAutoloadConfig()

updatePlayerLists()
Players.PlayerAdded:Connect(updatePlayerLists)
Players.PlayerRemoving:Connect(updatePlayerLists)
