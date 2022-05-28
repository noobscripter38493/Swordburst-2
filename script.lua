if not game:IsLoaded() then game.Loaded:Wait() end

if executed then return warn'executing twice crashes' end

getgenv().executed = true

if syn then -- synapse
    syn.queue_on_teleport("https://raw.githubusercontent.com/noobscripter38493/Swordburst-2/main/script.lua") 
    
elseif queue_on_teleport then -- krnl
    queue_on_teleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/noobscripter38493/Swordburst-2/main/script.lua'))()") 
    
else
    warn"failed to find execute on teleport function"
end

local Players = game:GetService("Players")
local Rs = game:GetService("ReplicatedStorage")

local place_id = game.PlaceId

local floor_data = require(Rs.Database.Locations)

local floor_ids = {}
for i, v in next, floor_data.floors do -- probably remove this
    for i2, v2 in next, v do
        if i2 == "PlaceId" then
           floor_ids[i] = v2
        end
    end
end

local plr = Players.LocalPlayer
getgenv().char = plr.Character or plr.CharacterAdded:Wait()
getgenv().hrp = char:WaitForChild("HumanoidRootPart")
getgenv().humanoid = char:WaitForChild("Humanoid")

getgenv().settings = {
    KA = false,
    KA_Range = 20,
    WalkSpeed = humanoid.WalkSpeed,
    speed = false,
    invisible = false,
    InfSprint = false,
    AttackPlayers = false
}

plr.CharacterAdded:Connect(function(new)
    char = new
    hrp = char:WaitForChild("HumanoidRootPart")
    humanoid = char:WaitForChild("Humanoid")
end)

function recursive_find_module()
    for _, v in next, getnilinstances() do
        if v.Name == "MainModule" then
            return v
        end
    end 

    wait(.5)
    
    return recursive_find_module()
end

getgenv().game_module = recursive_find_module()

local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/GreenDeno/Venyx-UI-Library/main/source.lua"))()

local gui = lib.new("SB2 Script")

local page1
do -- page 1
    function GetClosestEnemy() -- re writing kill aura to use touched and untouched events
        local closest_magnitude = math.huge
        local closest_enemy
        
        local mobs = workspace.Mobs

        for _, v in next, mobs:GetChildren() do
            local _, err = pcall(function()
                if v.Entity.Health.Value <= 0 then error't' end -- dont attack dead mobs
            end)
    
            if err or v:FindFirstChild("Immortal") then continue end -- should work I think
    
            local magnitude = (v:GetPivot().Position - hrp.Position).Magnitude
            
            if magnitude < closest_magnitude then
                closest_magnitude = magnitude
                closest_enemy = v
            end
        end
        
        if settings.AttackPlayers then
            local Players = game:GetService("Players")

            for _, v in next, Players:GetChildren() do
                if v ~= plr then
                    if v.Character then
                        local character = v.Character

                        local _, err = pcall(function()
                            if character.Entity.Health.Value <= 0 then error't' end -- dont attack dead players
                        end)

                        if err or v:FindFirstChild("Immortal") or not Rs.Profiles[v.Name].Settings.PvP.Value then continue end -- should work I think

                        local magnitude = (character:GetPivot().Position - hrp.Position).Magnitude
                        
                        if magnitude < closest_magnitude then
                            closest_magnitude = magnitude
                            closest_enemy = character
                        end
                    end
                end
            end
        end
        
        if closest_magnitude <= settings.KA_Range then 
            return closest_enemy
        end
        
        return nil
    end

    page1 = gui:addPage("Farm")
    
    local section1_1 = page1:addSection("Combat")
    
    section1_1:addToggle("KillAura", false, function(bool)
        settings.KA = bool
    end)

    section1_1:addToggle("Attack Players", false, function(bool)
        settings.AttackPlayers = bool
    end)
    
    section1_1:addSlider("KillAura Range", 20, 0, 25, function(v)
        settings.KA_Range = v
    end)
    
    local combat = require(game_module.Services.Combat)
    local hashed = getupvalues(combat.Init)[2]
    local Event = Rs.Event
    
    coroutine.wrap(function() -- use signals instead of checking every .3s eventually
        while true do wait(.3) -- don't edit this, attempting to atk faster breaks
            if settings.KA then 
                local enemy = GetClosestEnemy()
    
                if enemy and not enemy:FindFirstChild("Immortal") then
                    Event:FireServer("Combat", hashed, {"Attack", nil, "1", enemy}) -- nil = skill (i think)
                end
            end
        end
    end)()
end

do -- page 2
    local page2 = gui:addPage("Teleports")
    
    local section2_1 = page2:addSection("Locations")
    
    local no_tp = {542351431, 582198062}
    for _, v in next, workspace:GetChildren() do
        if table.find(no_tp, place_id) then
            gui:Notify("Can't TP", "Teleport Not Supported On This Floor (f1 or f7)")
            -- make tp tab not show if not supported
            break
        end

        if v.Name == "TeleportSystem" then
            for _, v2 in next, v:GetChildren() do
                section2_1:addButton("probably boss room", function() -- eventually make these show proper names (tower door seems possible)
                    firetouchinterest(hrp, v2, 0)
    
                    wait(.5)
                    
                    firetouchinterest(hrp, v2, 1)
                end)
            end
        end
    end
end

do -- page 3
    local page4 = gui:addPage("Character")

    local section3_1 = page4:addSection("Character")

    local invisibility
    section3_1:addToggle("Invisibility (Client Sided Character)", false, function(bool)
        settings.invisibile = bool

        if bool then
            local old_root = char:FindFirstChild("Root", true)
            local new_root = old_root:Clone()

            new_root.Parent = old_root.Parent
            old_root:Destroy()

            invisibility = plr.CharacterAdded:Connect(function(new)
                local old_root = new:WaitForChild("LowerTorso"):WaitForChild("Root")
                local new_root = old_root:Clone()

                new_root.Parent = old_root.Parent
                old_root:Destroy()
            end)

        elseif invisibility then
            invisibility:Disconnect()
        end
    end)

    section3_1:addToggle("Infinite Sprint", false, function(bool)
        settings.InfSprint = bool
    end)

    local Event = Rs.Event
    local infsprint; infsprint = hookmetamethod(game, "__namecall", function(self, ...)
        local ncm = getnamecallmethod()
        local args = {...}
        
        if settings.InfSprint then
            if self == Event and ncm == "FireServer" then
                if args[1] == "Actions" then
                    if args[2][2] == "Step" then
                        return -- void // no return check detection (if remote:FireServer() then print'detected' end)
                    end
                end
            end
        end
        
        return infsprint(self, ...)
    end)
end

do -- page 4
    local page4 = gui:addPage("Misc")
    
    local section4_1 = page4:addSection("Misc Features")

    local oldWS = humanoid.WalkSpeed
    local index_WS; index_WS = hookmetamethod(game, "__index", function(self, i)
        if settings.speed then
            if self == humanoid and i == "WalkSpeed" then
                return oldWS
            end
        end
        
        return index_WS(self, i) 
    end)
    
    local newindex_WS; newindex_WS = hookmetamethod(game, "__newindex", function(self, i, v)
        if settings.speed then 
            if self == humanoid and i == "WalkSpeed" then
                v = settings.WalkSpeed
            end
        end
        
        return newindex_WS(self, i, v)
    end)
    
    section4_1:addToggle("WalkSpeed Toggle", false, function(bool)
        settings.speed = bool
        
        if not bool then
            humanoid.WalkSpeed = 20
        else
            humanoid.WalkSpeed = settings.WalkSpeed
        end
    end)

    section4_1:addSlider("WalkSpeed", humanoid.WalkSpeed, 0, 50, function(v)
        settings.WalkSpeed = v

        if settings.speed then
            humanoid.WalkSpeed = v
        end
    end)

    section4_1:addToggle("Infinite Zoom Distance", false, function(bool)
        if bool then
            plr.CameraMaxZoomDistance = math.huge
        else
            plr.CameraMaxZoomDistance = 15
        end
    end)

    section4_1:addKeybind("GUI Toggle Keybind (Click 2x to Change)", Enum.KeyCode.RightShift, function()
        gui:toggle() 
    end)
end

gui:SelectPage(page1, true)
