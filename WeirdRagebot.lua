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

RagebotLeft:AddInput('FireRate', {
    Text = 'FireRate (Inf) ',
    Default = '500',
    Placeholder = 'Enter FireRate',
    Callback = function(Value)
        local numValue = tonumber(Value)
        if numValue and numValue > 0 then
            getgenv().FireRate = numValue
            getgenv().FireWait = 1 / numValue
        else
            Options.FireRate:SetValue(tostring(getgenv().FireRate))
        end
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
RagebotRight:AddToggle('TracerAnimation', {
    Text = 'Tracer Animation',
    Default = false,
    Callback = function(Value)
        getgenv().TracerAnimation = Value
    end
})

RagebotRight:AddSlider('TracerAppearSpeed', {
    Text = 'Appear Speed',
    Default = 1,
    Min = 0.1,
    Max = 50,
    Rounding = 1,
    Callback = function(Value)
        getgenv().TracerAppearSpeed = Value
    end
})

RagebotRight:AddSlider('TracerDisappearSpeed', {
    Text = 'Disappear Speed',
    Default = 1,
    Min = 0.1,
    Max = 50,
    Rounding = 1,
    Callback = function(Value)
        getgenv().TracerDisappearSpeed = Value
    end
})

getgenv().TracerAnimation = false
getgenv().TracerAppearSpeed = 1
getgenv().TracerDisappearSpeed = 1
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
    
    if getgenv().TracerAnimation then
        local beam = Instance.new("Beam")
        beam.Color = ColorSequence.new(getgenv().TracerColor)
        beam.Width0 = 0
        beam.Width1 = 0
        beam.Texture = "rbxassetid://7136858729"
        beam.TextureSpeed = getgenv().TracerTextureSpeed
        beam.Brightness = getgenv().TracerBrightness
        beam.LightEmission = getgenv().TracerLightEmission
        beam.FaceCamera = true
        
        local attachment0 = Instance.new("Attachment")
        local attachment1 = Instance.new("Attachment")
        attachment0.WorldPosition = startPos
        attachment1.WorldPosition = startPos
        
        beam.Attachment0 = attachment0
        beam.Attachment1 = attachment1
        beam.Parent = Workspace
        attachment0.Parent = Workspace
        attachment1.Parent = Workspace
        
        local appearTweenInfo = TweenInfo.new(0.2 / getgenv().TracerAppearSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local mainTweenInfo = TweenInfo.new(getgenv().TracerLifetime, Enum.EasingStyle.Linear)
        local disappearTweenInfo = TweenInfo.new(0.3 / getgenv().TracerDisappearSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        
        local appearTween = game:GetService("TweenService"):Create(beam, appearTweenInfo, {Width0 = getgenv().TracerWidth, Width1 = getgenv().TracerWidth})
        local mainTween = game:GetService("TweenService"):Create(attachment1, mainTweenInfo, {WorldPosition = endPos})
        local disappearTween = game:GetService("TweenService"):Create(beam, disappearTweenInfo, {Width0 = 0, Width1 = 0})
        
        appearTween:Play()
        mainTween:Play()
        
        delay(getgenv().TracerLifetime, function()
            disappearTween:Play()
            disappearTween.Completed:Connect(function()
                beam:Destroy()
                attachment0:Destroy()
                attachment1:Destroy()
            end)
        end)
    else
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
function showHitLog(targetName, damage)
    if not getgenv().HitLogsEnabled then return end
    
    Library:Notify(("Hit %s for %d damage"):format(targetName, damage), getgenv().HitLogsDuration)
end
function canSeeTarget(startPos, endPos)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {localPlayer.Character}
    
    local direction = (endPos - startPos)
    local distance = direction.Magnitude
    local raycastResult = workspace:Raycast(startPos, direction.Unit * distance, raycastParams)
    
    if raycastResult then
        local hitPart = raycastResult.Instance
        if hitPart and hitPart.CanCollide then
            local model = hitPart:FindFirstAncestorOfClass("Model")
            if model then
                local humanoid = model:FindFirstChild("Humanoid")
                if humanoid then
                    return true
                end
            end
            return false
        end
    end
    return true
end

function findVisiblePosition(startPos, targetPos)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {localPlayer.Character}
    
    local direction = (targetPos - startPos)
    local distance = direction.Magnitude
    
    local raycastResult = workspace:Raycast(startPos, direction.Unit * distance, raycastParams)
    
    if not raycastResult then
        return startPos, targetPos
    end
    
    local hitPosition = raycastResult.Position
    local hitPart = raycastResult.Instance
    
    if not hitPart then
        return startPos, targetPos
    end
    
    local obstacleSize = hitPart.Size
    local obstacleCFrame = hitPart.CFrame
    
    local toObstacle = (hitPosition - startPos)
    local rightVector = obstacleCFrame.RightVector
    local upVector = obstacleCFrame.UpVector
    local lookVector = obstacleCFrame.LookVector
    
    local dotRight = toObstacle:Dot(rightVector)
    local dotUp = toObstacle:Dot(upVector)
    local dotLook = toObstacle:Dot(lookVector)
    
    local offsetDirection
    if math.abs(dotRight) >= math.abs(dotUp) and math.abs(dotRight) >= math.abs(dotLook) then
        offsetDirection = dotRight > 0 and rightVector or -rightVector
    elseif math.abs(dotUp) >= math.abs(dotLook) then
        offsetDirection = dotUp > 0 and upVector or -upVector
    else
        offsetDirection = dotLook > 0 and lookVector or -lookVector
    end
    
    local offsetDistance = (obstacleSize.X + obstacleSize.Y + obstacleSize.Z) / 6 + 2
    local testStartPos = hitPosition + offsetDirection * offsetDistance
    
    local testDirection = (targetPos - testStartPos)
    local testDistance = testDirection.Magnitude
    local testRay = workspace:Raycast(testStartPos, testDirection.Unit * testDistance, raycastParams)
    
    if not testRay then
        return testStartPos, targetPos
    end
    
    return hitPosition, targetPos
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
                    if not canSeeTarget(startPos, finalTargetPosition) then
                        continue
                    end
                end
                
                local visualTargetPosition = targetPosition
                if getgenv().RandomBullet then
                    visualTargetPosition = getRandomOffsetPosition(targetPosition)
                end
                
                local tracerStartPos = startPos
                local tracerEndPos = visualTargetPosition
                
                if getgenv().Wallbang then
                    tracerStartPos, tracerEndPos = findVisiblePosition(startPos, visualTargetPosition)
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
                createBeamTracer(tracerStartPos, tracerEndPos)
                createHitSound(targetPosition)
                
                if nearestTarget:IsA("Player") then
                    showHitLog(nearestTarget.Name, getgenv().DamageValue)
                end
            end
        end
    end
end)
local AntiLockRight = Tabs.Ragebot:AddLeftGroupbox('Anti Lock Settings')

getgenv().AntiLockEnabled = false
getgenv().AntiLockStrength = 50
getgenv().AntiLockRandomness = 10
getgenv().AntiLockPattern = "Circular"

AntiLockRight:AddToggle('AntiLockEnabled', {
    Text = 'Anti Lock',
    Default = false,
    Callback = function(Value)
        getgenv().AntiLockEnabled = Value
    end
})

AntiLockRight:AddSlider('AntiLockStrength', {
    Text = 'Strength',
    Default = 50,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Callback = function(Value)
        getgenv().AntiLockStrength = Value
    end
})

AntiLockRight:AddSlider('AntiLockRandomness', {
    Text = 'Randomness',
    Default = 10,
    Min = 0,
    Max = 50,
    Rounding = 0,
    Callback = function(Value)
        getgenv().AntiLockRandomness = Value
    end
})

AntiLockRight:AddDropdown('AntiLockPattern', {
    Values = {'Circular', 'Random', 'Figure8', 'Sinusoidal'},
    Default = 1,
    Callback = function(Value)
        getgenv().AntiLockPattern = Value
    end
})

function applyAntiLockOffset(targetPosition)
    if not getgenv().AntiLockEnabled or getgenv().AntiLockStrength == 0 then
        return targetPosition
    end

    local strength = getgenv().AntiLockStrength / 100
    local randomness = getgenv().AntiLockRandomness / 100
    local time = tick()
    
    local offset = Vector3.new(0, 0, 0)
    
    if getgenv().AntiLockPattern == "Circular" then
        local radius = strength * 5
        local angle = time * 5
        offset = Vector3.new(
            math.cos(angle) * radius,
            math.sin(angle) * radius * 0.5,
            0
        )
    elseif getgenv().AntiLockPattern == "Random" then
        offset = Vector3.new(
            (math.random() - 0.5) * strength * 10 * (1 + randomness),
            (math.random() - 0.5) * strength * 5 * (1 + randomness),
            (math.random() - 0.5) * strength * 3 * (1 + randomness)
        )
    elseif getgenv().AntiLockPattern == "Figure8" then
        local scale = strength * 4
        offset = Vector3.new(
            math.sin(time * 3) * scale,
            math.sin(time * 6) * scale * 0.5,
            0
        )
    elseif getgenv().AntiLockPattern == "Sinusoidal" then
        local scale = strength * 6
        offset = Vector3.new(
            math.sin(time * 4) * scale,
            math.cos(time * 2) * scale * 0.7,
            math.sin(time * 3) * scale * 0.3
        )
    end

    return targetPosition + offset
end
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
local LegitTab = Window:AddTab('LegitBot')
local LegitLeft = LegitTab:AddLeftGroupbox('Aimbot Settings')
local LegitRight = LegitTab:AddRightGroupbox('Tracer Settings')

getgenv().LegitAimbotEnabled = false
getgenv().LegitAimbotFOV = 50
getgenv().LegitAimbotSmoothness = 10
getgenv().LegitAimbotPrediction = false
getgenv().LegitAimbotPredictionAmount = 0.1
getgenv().LegitTracerEnabled = false
getgenv().LegitTracerColor = Color3.fromRGB(255, 100, 100)
getgenv().LegitTracerWidth = 0.3
getgenv().LegitTracerLifetime = 0.3
getgenv().LegitHealthCheck = true
getgenv().LegitVisibilityCheck = true
getgenv().LegitHitLogs = true
getgenv().LegitShowUI = false
getgenv().AimbotActive = false

LegitLeft:AddToggle('LegitAimbotEnabled', {
    Text = 'Aimbot Enabled',
    Default = false,
    Callback = function(Value)
        getgenv().LegitAimbotEnabled = Value
    end
})

LegitLeft:AddSlider('LegitAimbotFOV', {
    Text = 'FOV',
    Default = 50,
    Min = 10,
    Max = 1000,
    Rounding = 0,
    Callback = function(Value)
        getgenv().LegitAimbotFOV = Value
    end
})

LegitLeft:AddSlider('LegitAimbotSmoothness', {
    Text = 'Smoothness',
    Default = 10,
    Min = 1,
    Max = 30,
    Rounding = 0,
    Callback = function(Value)
        getgenv().LegitAimbotSmoothness = Value
    end
})

LegitLeft:AddToggle('LegitAimbotPrediction', {
    Text = 'Prediction',
    Default = false,
    Callback = function(Value)
        getgenv().LegitAimbotPrediction = Value
    end
})

LegitLeft:AddSlider('LegitAimbotPredictionAmount', {
    Text = 'Prediction Amount',
    Default = 0.1,
    Min = 0.05,
    Max = 0.3,
    Rounding = 2,
    Callback = function(Value)
        getgenv().LegitAimbotPredictionAmount = Value
    end
})

LegitLeft:AddToggle('LegitHealthCheck', {
    Text = 'Health Check',
    Default = true,
    Callback = function(Value)
        getgenv().LegitHealthCheck = Value
    end
})

LegitLeft:AddToggle('LegitVisibilityCheck', {
    Text = 'Visibility Check',
    Default = true,
    Callback = function(Value)
        getgenv().LegitVisibilityCheck = Value
    end
})

LegitLeft:AddToggle('LegitHitLogs', {
    Text = 'Hit Logs',
    Default = true,
    Callback = function(Value)
        getgenv().LegitHitLogs = Value
    end
})

LegitRight:AddToggle('LegitTracerEnabled', {
    Text = 'Tracer Enabled',
    Default = false,
    Callback = function(Value)
        getgenv().LegitTracerEnabled = Value
    end
}):AddColorPicker('LegitTracerColor', {
    Default = Color3.fromRGB(255, 100, 100),
    Callback = function(Value)
        getgenv().LegitTracerColor = Value
    end
})

LegitRight:AddSlider('LegitTracerWidth', {
    Text = 'Tracer Width',
    Default = 0.3,
    Min = 0.1,
    Max = 2,
    Rounding = 1,
    Callback = function(Value)
        getgenv().LegitTracerWidth = Value
    end
})

LegitRight:AddSlider('LegitTracerLifetime', {
    Text = 'Tracer Lifetime',
    Default = 0.3,
    Min = 0.1,
    Max = 1,
    Rounding = 1,
    Callback = function(Value)
        getgenv().LegitTracerLifetime = Value
    end
})

LegitRight:AddToggle('LegitShowUI', {
    Text = 'Show Mobile UI',
    Default = false,
    Callback = function(Value)
        getgenv().LegitShowUI = Value
        updateMobileUI()
    end
})

local mobileUI
function updateMobileUI()
    if mobileUI then
        mobileUI:Destroy()
        mobileUI = nil
    end
    
    if getgenv().LegitShowUI then
        mobileUI = Instance.new("ScreenGui")
        mobileUI.Parent = game:GetService("CoreGui")
        
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0, 100, 0, 50)
        button.Position = UDim2.new(0, 20, 0, 150)
        button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Text = "AIM OFF"
        button.Font = Enum.Font.SourceSansBold
        button.TextSize = 14
        button.Parent = mobileUI
        
        button.MouseButton1Click:Connect(function()
            getgenv().AimbotActive = not getgenv().AimbotActive
            if getgenv().AimbotActive then
                button.Text = "AIM ON"
                button.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
            else
                button.Text = "AIM OFF"
                button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            end
        end)
    end
end

function getPredictedPosition(targetPos, targetVelocity)
    if not getgenv().LegitAimbotPrediction then return targetPos end
    local prediction = getgenv().LegitAimbotPredictionAmount
    return targetPos + (targetVelocity * prediction)
end

function canSeeTargetLegit(startPos, endPos)
    if not getgenv().LegitVisibilityCheck then return true end
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {localPlayer.Character}
    local direction = (endPos - startPos)
    local distance = direction.Magnitude
    local raycastResult = workspace:Raycast(startPos, direction.Unit * distance, raycastParams)
    if raycastResult then
        local hitPart = raycastResult.Instance
        if hitPart and hitPart.CanCollide then
            local model = hitPart:FindFirstAncestorOfClass("Model")
            if model then
                local humanoid = model:FindFirstChild("Humanoid")
                if humanoid then
                    return true
                end
            end
            return false
        end
    end
    return true
end

function getTargetInFOV()
    local camera = workspace.CurrentCamera
    local mousePos = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
    local fov = getgenv().LegitAimbotFOV
    local bestTarget = nil
    local bestScreenPos = nil
    local bestDistance = math.huge
    local bestHumanoid = nil
    local bestPosition = nil
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and shouldTargetPlayer(player) and player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if humanoid and humanoidRootPart then
                if getgenv().LegitHealthCheck and humanoid.Health <= 0 then
                    continue
                end
                local screenPos, onScreen = camera:WorldToViewportPoint(humanoidRootPart.Position)
                if onScreen then
                    local screenDistance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if screenDistance <= fov and screenDistance < bestDistance then
                        if canSeeTargetLegit(camera.CFrame.Position, humanoidRootPart.Position) then
                            bestTarget = player
                            bestScreenPos = Vector2.new(screenPos.X, screenPos.Y)
                            bestDistance = screenDistance
                            bestHumanoid = humanoid
                            bestPosition = humanoidRootPart.Position
                        end
                    end
                end
            end
        end
    end
    return bestTarget, bestScreenPos, bestHumanoid, bestPosition
end
function showLegitHitLog(targetName, damage)
    if not getgenv().LegitHitLogs then return end
    Library:Notify(("Hit %s for %d damage"):format(targetName, damage), 3)
end

local legitShootConnection
legitShootConnection = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Shoot").OnClientEvent:Connect(function(...)
    local args = {...}
    if getgenv().LegitHitLogs and getgenv().AimbotActive then
        if args[5] and args[5]["1"] then
            local hitData = args[5]["1"]
            if hitData[1] and hitData[1]:IsA("Humanoid") then
                local model = hitData[1].Parent
                if model and model:FindFirstChild("HumanoidRootPart") then
                    local player = Players:GetPlayerFromCharacter(model)
                    if player then
                        showLegitHitLog(player.Name, hitData[4] or 0)
                    end
                end
            end
        end
    end
    if getgenv().LegitTracerEnabled and getgenv().AimbotActive and localPlayer.Character then
        local target, _, _, targetPos = getTargetInFOV()
        if target and target.Character and targetPos then
            local humanoidRootPart = target.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local targetVelocity = humanoidRootPart.Velocity
                local predictedPos = getPredictedPosition(targetPos, targetVelocity)
                local beam = Instance.new("Beam")
                beam.Color = ColorSequence.new(getgenv().LegitTracerColor)
                beam.Width0 = getgenv().LegitTracerWidth
                beam.Width1 = getgenv().LegitTracerWidth
                beam.Texture = "rbxassetid://7136858729"
                beam.TextureSpeed = 2
                beam.Brightness = 5
                beam.LightEmission = 1
                beam.FaceCamera = true
                local attachment0 = Instance.new("Attachment")
                local attachment1 = Instance.new("Attachment")
                attachment0.WorldPosition = localPlayer.Character.Head.Position
                attachment1.WorldPosition = predictedPos
                beam.Attachment0 = attachment0
                beam.Attachment1 = attachment1
                beam.Parent = Workspace
                attachment0.Parent = Workspace
                attachment1.Parent = Workspace
                delay(getgenv().LegitTracerLifetime, function()
                    beam:Destroy()
                    attachment0:Destroy()
                    attachment1:Destroy()
                end)
            end
        end
    end
end)

spawn(function()
    while true do
        wait()
        if getgenv().LegitAimbotEnabled and getgenv().AimbotActive and localPlayer.Character then
            local target, screenPos, humanoid, targetPos = getTargetInFOV()
            if target and target.Character and targetPos then
                local humanoidRootPart = target.Character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    local targetVelocity = humanoidRootPart.Velocity
                    local predictedPos = getPredictedPosition(targetPos, targetVelocity)
                    local camera = workspace.CurrentCamera
                    local currentCFrame = camera.CFrame
                    local targetCFrame = CFrame.lookAt(currentCFrame.Position, predictedPos)
                    local smoothness = getgenv().LegitAimbotSmoothness
                    local newCFrame = currentCFrame:Lerp(targetCFrame, 1/smoothness)
                    camera.CFrame = newCFrame
                end
            end
        end
    end
end)
