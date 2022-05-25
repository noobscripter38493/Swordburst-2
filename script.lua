if not game:IsLoaded() then game.Loaded:Wait() end

if executed then return warn"executing twice crashes" end

getgenv().executed = true

if syn then -- synapse
    syn.queue_on_teleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/noobscripter38493/Swordburst-2/main/script.lua'))()") 
    
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
    -- probably autofarm eventually
    KA = false,
    KA_Range = 20,
    WalkSpeed = humanoid.WalkSpeed,
    invisible = false
}

plr.CharacterAdded:Connect(function(new)
    char = new
    hrp = char:WaitForChild("HumanoidRootPart")
    humanoid = char:WaitForChild("Humanoid")
    humanoid.WalkSpeed = settings.WalkSpeed
end)

local script
function recursive_find_module()
    for _, v in next, getnilinstances() do
        if v.Name == "MainModule" then
            script = v
            
            return
        end
    end 

    wait(1)
    
    if not script then recursive_find_module() end
end

recursive_find_module()

local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/GreenDeno/Venyx-UI-Library/main/source.lua"))()

local gui = lib.new("SB2 Script")

local page1
do -- page 1
    page1 = gui:addPage("Farm")
    
    local section1_1 = page1:addSection("Combat")
    
    section1_1:addToggle("KillAura", false, function(bool)
        settings.KA = bool
    end)
    
    section1_1:addSlider("KillAura Range", 20, 0, 25, function(v)
        settings.KA_Range = v
    end)

    function GetClosestMob()
        local closest_magnitude = math.huge
        local closest_mob
        
        local mobs = workspace.Mobs
        for _, v in next, mobs:GetChildren() do
            local _, err = pcall(function()
                if v.Entity.Health.Value <= 0 then error't' end -- dont attack already dead mobs
            end)
    
            if err or v:FindFirstChild("Immortal") then continue end -- should work I think
    
            local magnitude = (v:GetPivot().Position - hrp.Position).Magnitude
            
            if magnitude < closest_magnitude then
                closest_magnitude = magnitude
                closest_mob = v
            end
        end 
        
        if closest_magnitude <= settings.KA_Range then
            return closest_mob
        end
        
        return nil
    end
    
    local combat = require(script.Services.Combat)
    local hashed = getupvalues(combat.Init)[2]
    local Event = Rs.Event
    
    coroutine.wrap(function()
        while true do wait(.3) -- don't edit this, attempting to atk faster breaks
            if settings.KA then
                local mob = GetClosestMob()
    
                if mob and not mob:FindFirstChild("Immortal") then
                    Event:FireServer("Combat", hashed, {"Attack", nil, "1", mob})
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
            gui:Notify("Can't TP", "Teleport Not Supported On This Floor (f1 or f7)", function() end)

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
end

do -- page 4
    local page4 = gui:addPage("Misc")
    
    local section4_1 = page4:addSection("Misc Features")

    local oldWS = humanoid.WalkSpeed
    local index_WS; index_WS = hookmetamethod(game, "__index", function(self, i)
        if self == humanoid and i == "WalkSpeed" then
            return oldWS
        end
        
        return index_WS(self, i) 
    end)
    
    local newindex_WS; newindex_WS = hookmetamethod(game, "__newindex", function(self, i, v) -- allow sprint eventually
        if self == humanoid and i == "WalkSpeed" then
            v = settings.WalkSpeed
        end
        
        if self == humanoid and i == "JumpPower" then
            v = settings.JumpPower 
        end
        
        return newindex_WS(self, i, v)
    end)
    
    section4_1:addSlider("WalkSpeed", humanoid.WalkSpeed, 0, 50, function(v)
        settings.WalkSpeed = v
        humanoid.WalkSpeed = v
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
