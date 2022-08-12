-- loadfile('Scriptz/sb2 script.lua')()
-- loadstring(game:HttpGet('https://raw.githubusercontent.com/noobscripter38493/Swordburst-2/main/script.lua'))()
if SB2Script then return end
getgenv().SB2Script = true

repeat task.wait() until game:IsLoaded() 

local teleport_execute = queue_on_teleport or (fluxus and fluxus.queue_on_teleport) or (syn and syn.queue_on_teleport)
if teleport_execute then
    teleport_execute("loadstring(game:HttpGet('https://raw.githubusercontent.com/noobscripter38493/Swordburst-2/main/script.lua'))()")
else
    warn"failed to find execute on teleport function"
end

local mobs_on_floor = {
    [540240728] = {}, -- arcadia -- floor 1
    [737272595] = {}, -- battle arena floor 1
    [566212942] = {}, -- floor 6 helmfrith

    [542351431] = { -- floor 1
        "Frenzy Boar",
        "Wolf",
        "Hermit Crab",
        "Bear",
        "Ruin Knight",
        "Draconite",
        "Ruin Kobold Knight"
    },

    [548231754] = { -- floor 2
        "Leaf Beetle",
        "Leaf Ogre",
        "Leafray",
        "Pearl Keeper",
        "Bushback Tortoise",
        "Wasp"
    },

    [555980327] = { -- floor 3
        "Snowgre",
        "Angry Snowman",
        "Icewhal",
        "Ice Elemental",
        "Snowhorse",
        "Ice Walker"
    },

    [572487908] = { -- floor 4
        "Wattlechin Crocodile",
        "Birchman",
        "Treehorse",
        "Treeray",
        "Boneling",
        "Bamboo Spiderling",
        "Bamboo Spider",
        "Dungeon Dweller",
        "Lion Protector",
    },

    [580239979] = { -- floor 5
        "Girdled Lizard",
        "Angry Cactus",
        "Desert Vulture",
        "Sand Scorpion",
        "Giant Centipede",
        "Green Patrolman",
        "Centaurian Defender",
        "Patrolman Elite",
    },

    [582198062] = { -- floor 7
        "Jelly Wisp",
        "Firefly",
        "Shroom Back Clam",
        "Gloom Shroom",
        "Horned Sailfin Iguana",
        "Blightmouth",
        "Snapper"
    },
    
    [548878321] = { -- floor 8
        "Giant Praying Mantis",
        "Petal Knight",
        "Leaf Rhino",
        "Sky Raven",
        "Wingless Hippogriff",
        "Forest Wanderer",
        "Dungeon Crusador"
    },

    [573267292] = { -- floor 9
        "Batting Eye",
        "Lingerer",
        "Fishrock Spider",
        "Reptasaurus",
        "Ent",
        "Undead Warrior",
        "Enraged Lingerer",
        "Undead Berserker"
    },

    [2659143505] = { -- floor 10
        "Winged Minion",
        "Clay Giant",
        "Wendigo",
        "Grunt",
        "Guard Hound",
        "Minion",
        "Shady Villager",
        "Undead Servant",
    },

    [5287433115] = { -- floor 11
        "Reaper",
        "Elite Reaper",
        "DJ Reaper",
        "Soul Eater",
        "Shadow Figure",
        "Meta Figure",
        "???????",
        "Rogue Android",
        "Command Falcon",
        "Armageddon Eagle",
        "Sentry",
        "Watcher",
        "Cybold"
    }
}

local bosses_on_floor = {
    [540240728] = {}, -- arcadia -- floor 1
    [737272595] = {}, -- battle arena floor 1
    [566212942] = {}, -- floor 6 helmfrith
    
    [542351431] = { -- floor 1
        "Dire Wolf",
        "Rahjin the Thief King"
    },

    [548231754] = { -- floor 2
        "Pearl Guardian",
        "Gorrock the Grove Protector",
        "Borik the BeeKeeper"
    },

    [555980327] = { -- floor 3
        "Qerach The Forgotten Golem",
        "Alpha Icewhal",
        "Ra'thae the Ice King"
    },

    [572487908] = { -- floor 4
        "Rotling",
        "Irath the Lion",
    },

    [580239979] = { -- floor 5
        "Fire Scorpion",
        "Sa'jun the Centurian Chieftain"
    },
    
    [582198062] = { -- floor 7
        "Frogazoid",
        "Smashroom"
    },

    [548878321] = { -- floor 8
        "Hippogriff",
        "Formaug the Jungle Giant"
    },

    [573267292] = { -- floor 9
        "Gargoyle Reaper",
        "Polyserpant",
        "Mortis the Flaming Sear"
    },

    [2659143505] = { -- floor 10
        "Baal  The  Tormentor",
        "Grim  the  Overseer"
    },

    [5287433115] = { -- floor 11
        "Da, the Demeanor",
        "Ra, the Enlightener",
        "Ka, the Mischief",
        "Za, the Eldest",
        "Duality Reaper",
        "Saurus, the All-Seeing"
    }
}

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputS = game:GetService("UserInputService")
local TweenS = game:GetService("TweenService")
local RunS = game:GetService("RunService")
local Rs = game:GetService("ReplicatedStorage")

getgenv().getupvalue = debug.getupvalue -- not sure if other exploits that aren't synapse have an alias so this is for that i guess
getgenv().setupvalue = debug.setupvalue
getgenv().getinfo = debug.getinfo
getgenv().hookfunc = hookfunction

local placeid = game.PlaceId

local floor_data = require(Rs.Database.Locations)

local floor_ids = {}
for i, v in next, floor_data.floors do -- probably remove this
    for i2, v2 in next, v do
        if i2 == "PlaceId" then
           floor_ids[i] = v2
        end
    end
end

local function copy_table(t)
    local c = {}
    
    for i, v in next, t do
        c[i] = v
    end
    
    return c
end

local plr = Players.LocalPlayer

for _, v in next, getconnections(plr.Idled) do
    v:Disable() 
end

local char = plr.Character or plr.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

repeat task.wait() until getrenv()._G.CalculateCombatStyle

local settings = {
    Autofarm = false,
    Autofarm_Y_Offset = 10,
    Tween_Speed = 50,
    Farm_Only_Bosses = false,
    Boss_Priority = false,
    MuteSwingSounds = false,
    Prioritized_Boss = nil,
    Mob_Priority = false,
    Prioritized_Mob = nil,
    KA = false,
    KA_Range = 20,
    WalkSpeed = humanoid.WalkSpeed,
    speed = false,
    AutoEquip = false,
    InfSprint = false,
    InfJump = false,
    RemoveDeathEffects = false,
    RemoveDamageNumbers = false,
    AttackPlayers = false,
    Animation = getrenv()._G.CalculateCombatStyle(),
    MaxAutofarmDistance = 5000,
    excludedMobs = {},
    Height = 30,
    Autofarm_Idle_Min = 30,
    Autofarm_Idle_Max = 70
}

local parts = {}
local function setNoClipParts()
    table.clear(parts)

    while #parts ~= 3 do
        for _, part in next, char:GetDescendants() do
            if part:IsA("BasePart") and part.CanCollide then
                if table.find(parts, part) then continue end

                parts[#parts + 1] = part
            end
        end

        task.wait(1)
    end
end

setNoClipParts()

local function noclip()
    if not settings.Autofarm then return end
    
    for _, v in next, parts do
        v.CanCollide = false -- thx infinite yield
    end
end

RunS.Stepped:Connect(noclip)

local playerHealth
local maxPlayerHealth
local function setUpPlayerHealthValues(health)
    local currentHealthSignal = health:GetPropertyChangedSignal("Value"):Connect(function()
        playerHealth = health.Value
    end)
    playerHealth = health.Value

    local maxHealthSignal = health:GetPropertyChangedSignal("MaxValue"):Connect(function()
        maxPlayerHealth = health.MaxValue
    end)
    maxPlayerHealth = health.MaxValue

    local humanoidDied; humanoidDied = humanoid.Died:Connect(function()
        humanoidDied:Disconnect()
        maxHealthSignal:Disconnect()
        currentHealthSignal:Disconnect()
    end)
end

local health = char:WaitForChild("Entity"):WaitForChild("Health")
setUpPlayerHealthValues(health)

plr.CharacterAdded:Connect(function(new)
    char = new
    hrp = char:WaitForChild("HumanoidRootPart")
    humanoid = char:WaitForChild("Humanoid")

    health = new:WaitForChild("Entity"):WaitForChild("Health")
    setUpPlayerHealthValues(health)

    setNoClipParts()
end)

local game_module
while true do
    for _, v in next, getnilinstances() do
        if v.Name == "MainModule" then
            game_module = v
            break
        end
    end 

    game_module = game_module or plr.PlayerScripts.CardinalClient:FindFirstChild("MainModule")
    if game_module then break end

    task.wait(.5)
end

-- disable M1s when killaura is enabled
local setThreadIdentity = (syn and syn.set_thread_identity) or setthreadcontext or (fluxus and fluxus.set_thread_identity) or setidentity
setThreadIdentity(2)

for _, v in next, getconnections(UserInputS.InputBegan) do
    local f = v.Function
    if not f then continue end
    
    local info = getinfo(f)
    if info.source:find("Input") then
        local noMouseClick; noMouseClick = hookfunc(f, function(user_input, game_processed, ...)
            if user_input.UserInputType == Enum.UserInputType.MouseButton1 then
                if settings.KA then
                    return
                end
            end
            
            return noMouseClick(user_input, game_processed, ...)
        end)

        break
    end
end

setThreadIdentity(7)

local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

repeat task.wait() until lib

local protected = gethui and gethui() or CoreGui
local orion = protected:WaitForChild("Orion")

local window = lib:MakeWindow({
    Name = "SB2 Script | Made By OneTaPuXd on v3rm",
    HidePremium = false,
    SaveConfig = false,
    ConfigFolder = false
})

do
    local farm_tab = window:MakeTab({
        Name = "Autofarm",
        Icon = "",
        PremiumOnly = false
    })
    
    local function getMobHealth(mob)
        local entity = mob and mob:FindFirstChild("Entity")
        return entity and entity:FindFirstChild("Health")
    end

    farm_tab:AddParagraph("Warning", "SB2 Mods are extremely active and autofarm will likely get you banned")
    local mobs_table = {}

    local function distanceCheck(enemy) 
        local enemy_hrp = enemy:FindFirstChild("HumanoidRootPart")
        if not enemy_hrp then return end

        local distance = (hrp.Position - enemy_hrp.Position).Magnitude
        local maxdistance = settings.MaxAutofarmDistance
        return distance < maxdistance
    end
    
    local excludedMobs = settings.excludedMobs
    local function searchForMob(mobName)
        local closest_magnitude = math.huge
        local closest_mob

        for _, mob in next, mobs_table do
            if excludedMobs[mob.Name] then continue end

            if mob.Name == mobName and distanceCheck(mob) then
                local mob_hrp = mob:FindFirstChild("HumanoidRootPart")
                if not mob_hrp then continue end

                local mob_health = getMobHealth(mob)
                if mob_health and mob_health.Value > 0 then
                    local magnitude = (mob_hrp.Position - hrp.Position).Magnitude
                    if magnitude < closest_magnitude then
                        closest_mob = mob
                        closest_magnitude = magnitude
                    end
                end
            end
        end

        return closest_mob
    end

    local function searchForAnyEnemy()
        local closest_magnitude = math.huge
        local closest_mob
        
        for _, mob in next, mobs_table do
            if excludedMobs[mob.Name] then continue end

            if distanceCheck(mob) then
                local mob_hrp = mob:FindFirstChild("HumanoidRootPart")
                if not mob_hrp then continue end

                local mob_health = getMobHealth(mob)
                if mob_health and mob_health.Value > 0 then
                    local magnitude = (mob_hrp.Position - hrp.Position).Magnitude
                    if magnitude < closest_magnitude then
                        closest_mob = mob
                        closest_magnitude = magnitude
                    end
                end
            end
        end

        return closest_mob
    end
    
    local function searchForBoss(bossName)
        local closest_magnitude = math.huge
        local closest_boss

        for _, boss in next, mobs_table do
            if boss.Name == bossName and distanceCheck(boss) then
                local boss_hrp = boss:FindFirstChild("HumanoidRootPart")
                if not boss_hrp then continue end

                local boss_health = getMobHealth(boss)
                if boss_health and boss_health.Value > 0 then
                    local magnitude = (boss_hrp.Position - hrp.Position).Magnitude
                    if magnitude < closest_magnitude then
                        closest_boss = boss
                        closest_magnitude = magnitude
                    end
                end
            end
        end

        return closest_boss
    end
    
    local function searchForAnyBoss(bosses)
        local closest_magnitude = math.huge
        local closest_boss

        for _, boss in next, mobs_table do
            for _, bossName in next, bosses do
                if boss.Name == bossName and distanceCheck(boss) then
                    local boss_hrp = boss:FindFirstChild("HumanoidRootPart")
                    if not boss_hrp then continue end

                    local boss_health = getMobHealth(boss)
                    if boss_health and boss_health.Value > 0 then
                        local magnitude = (boss_hrp.Position - hrp.Position).Magnitude
                        if magnitude < closest_magnitude then
                            closest_boss = boss
                            closest_magnitude = magnitude
                        end
                    end
                end
            end
        end

        return closest_boss
    end

    local tweens = {}

    local floatPart = Instance.new("Part")
    floatPart.Transparency = 1
    floatPart.Anchored = true
    floatPart.Size = Vector3.new(1, 1, 1)
    floatPart.CanCollide = false

    local shouldFloat = false
    RunS.RenderStepped:Connect(function()
        if shouldFloat then return end

        local height = settings.Height
        floatPart.CFrame = hrp.CFrame * CFrame.new(0, height, 0)
    end)
    floatPart.Parent = workspace
    
    local function playerHealthChecks(to)
        local minPercentage = settings.Autofarm_Idle_Min
        local maxPercantage = settings.Autofarm_Idle_Max
        if shouldFloat then
            if playerHealth > maxPercantage / 100 * maxPlayerHealth then
                shouldFloat = false
            else
                to = floatPart
            end
        end

        if playerHealth < minPercentage / 100 * maxPlayerHealth then
            to = floatPart
            shouldFloat = true
        end

        if to == floatPart then
            to = searchForAnyBoss(bosses_on_floor[placeid]) or floatPart
        end

        return to
    end

    local function TweenF(to)
        local enemy = to.Parent
        to = playerHealthChecks(to)

        local mob_health
        if not shouldFloat then
            mob_health = getMobHealth(enemy)
        end
        while mob_health and mob_health.Value > 0 or shouldFloat do
            coroutine.wrap(function()
                to = playerHealthChecks(to)
                local distance = (hrp.Position - to.Position).Magnitude
                local seconds = distance / settings.Tween_Speed

                local y_offset = shouldFloat and 0 or settings.Autofarm_Y_Offset
                local cframe = to.CFrame * CFrame.new(0, y_offset, 0)

                local tween_info = TweenInfo.new(seconds, Enum.EasingStyle.Linear)
                local tween = TweenS:Create(hrp, tween_info, {CFrame = cframe})
                tweens[#tweens + 1] = tween
                
                tween:Play()
                tween.Completed:Wait()
            end)()
            
            if not settings.Autofarm or not to.Parent then
                break 
            end

            task.wait()
        end
        
        pcall(function()
            mobs_table[enemy] = nil
        end)
    end

    RunS.RenderStepped:Connect(function() -- smooth tween
        if not settings.Autofarm then return end
        hrp.Velocity = Vector3.zero
    end)
    

    local mobs = workspace.Mobs
    mobs.ChildAdded:Connect(function(mob)
        mob:WaitForChild("HumanoidRootPart")
        mobs_table[mob] = mob
    end)
    
    mobs.ChildRemoved:Connect(function(mob)
        pcall(function()
            mobs_table[mob] = nil
        end)
    end)
    
    for _, v in next, mobs:GetChildren() do
        coroutine.wrap(function()
            v:WaitForChild("HumanoidRootPart")
            mobs_table[v] = v
        end)()
    end
    
    farm_tab:AddToggle({
        Name = "Autofarm (HIGH BAN RISK)",
        Default = false,
        Callback = function(bool)
            settings.Autofarm = bool

            if not bool then
                while #tweens ~= 0 do
                    for i, v in next, tweens do
                        shouldFloat = false
                        v:Cancel()
                        tweens[i] = nil
                    end

                    task.wait()
                end
                
                return
            end

            while true do task.wait()
                if not settings.Autofarm then break end
                
                if settings.Farm_Only_Bosses then
                    local boss = searchForAnyBoss(bosses_on_floor[placeid])
                    local boss_hrp = boss and boss:FindFirstChild("HumanoidRootPart")

                    if boss_hrp then
                        TweenF(boss_hrp)
                    else
                        TweenF(floatPart)
                    end
                    
                    continue
                end
                
                if settings.Boss_Priority and settings.Prioritized_Boss ~= nil then
                    local boss = searchForBoss(settings.Prioritized_Boss)
                    local boss_hrp = boss and boss:FindFirstChild("HumanoidRootPart")
                        
                    if boss_hrp then
                        TweenF(boss_hrp)
                        
                        continue
                    end
                end

                if settings.Mob_Priority and settings.Prioritized_Mob ~= nil then
                    local mob = searchForMob(settings.Prioritized_Mob)
                    local mob_hrp = mob and mob:FindFirstChild("HumanoidRootPart")
                        
                    if mob_hrp then
                        TweenF(mob_hrp)
                        
                        continue
                    end
                end
                
                local mob = searchForAnyEnemy()
                local mob_hrp = mob and mob:FindFirstChild("HumanoidRootPart")
                if mob_hrp then
                    TweenF(mob_hrp)
                end
            end
        end
    })
    
    farm_tab:AddToggle({
        Name = "Farm Only Bosses",
        Default = false,
        Callback = function(bool)
            settings.Farm_Only_Bosses = bool
        end
    })

    farm_tab:AddToggle({
        Name = "Boss Priority", 
        Default = false,
        Callback = function(bool)
            settings.Boss_Priority = bool
        end
    })

    farm_tab:AddDropdown({
        Name = "Prioritized Boss",
        Default = nil,
        Options = bosses_on_floor[placeid],
        Callback = function(boss)
            settings.Prioritized_Boss = boss
        end
    })

    farm_tab:AddToggle({
        Name = "Mob Priority", 
        Default = false,
        Callback = function(bool)
            settings.Mob_Priority = bool
        end
    })

    farm_tab:AddDropdown({
        Name = "Prioritized Mob",
        Default = nil,  
        Options = mobs_on_floor[placeid],
        Callback = function(mob)
            settings.Prioritized_Mob = mob
        end
    })

    farm_tab:AddSlider({
        Name = "Max Autofarm Radius",
        Min = 0,
        Max = 10000,
        Default = 5000,
        Color = Color3.new(255, 255, 255),
        Increment = 100,
        ValueName = "Studs",
        Callback = function(v)
            settings.MaxAutofarmDistance = v
        end
    })
    
    farm_tab:AddSlider({
        Name = "Autofarm Y Offset",
        Min = 0,
        Max = 30,
        Default = 10,
        Color = Color3.new(255, 255, 255),
        Increment = 1,
        ValueName = "Y Offset",
        Callback = function(v)
            settings.Autofarm_Y_Offset = v
        end
    })

    farm_tab:AddSlider({
        Name = "Idle Float Height (supports only farm bosses & health %)",
        Min = 30,
        Max = 100,
        Default = 30,
        Color = Color3.new(255, 255, 255),
        Increment = 1,
        ValueName = "Studs",
        Callback = function(v)
            settings.Height = v
        end
    })

    farm_tab:AddSlider({
        Name = "Idle farm when under % health",
        Min = 0,
        Max = 100,
        Default = 30,
        Color = Color3.new(255, 255, 255),
        Increment = 1,
        ValueName = "%",
        Callback = function(v)
            settings.Autofarm_Idle_Min = v
        end
    })

    farm_tab:AddSlider({
        Name = "Resume farm when over % health",
        Min = 0,
        Max = 100,
        Default = 70,
        Color = Color3.new(255, 255, 255),
        Increment = 1,
        ValueName = "%",
        Callback = function(v)
            settings.Autofarm_Idle_Max = v
        end
    })

    farm_tab:AddSlider({
        Name = "Tween Speed",
        Min = 0, 
        Max = 100,
        Default = 50,
        Color = Color3.new(255, 255, 255),
        Increment = 1,
        ValueName = "Speed",
        Callback = function(v)
            settings.Tween_Speed = v
        end
    })
end

do
    local combat = window:MakeTab({
        Name = "Combat",
        Icon = "",
        PremiumOnly = false
    })

    local range = Instance.new("Part")
    range.Size = Vector3.new(25, 25, 25)
    range.CanCollide = false
    range.Transparency = 1

    RunS.RenderStepped:Connect(function()
        range.CFrame = char:GetPivot()
    end)

    range.Parent = workspace

    local _combat = require(game_module.Services.Combat)
    local remote_key = getupvalue(_combat.Init, 2)
    local Event = Rs.Event

    local attacking = {}
    local function killaura_function(enemy, player)
        while true do 
            local i = table.find(attacking, enemy)
            
            local success = pcall(function()
                if enemy.Entity.Health.Value <= 0 then error() end
            end)

            local enemy_hrp = enemy:FindFirstChild("HumanoidRootPart")
            if not enemy_hrp or not success or not settings.KA or enemy:FindFirstChild("Immortal") or (hrp.Position - enemy_hrp.Position).Magnitude > settings.KA_Range then
                table.remove(attacking, i)

                break 
            end

            if player and not settings.AttackPlayers then
                table.remove(attacking, i)

                break
            end
            
            Event:FireServer("Combat", remote_key, {"Attack", nil, "1", enemy}) -- nil = skill (i think)
            
            task.wait(.3) 
        end
    end

    local combat_style
    local animations
    for _, v in next, getgc(true) do
        if typeof(v) == "table" then
            local Initanis = rawget(v, "InitAnimations")
            if Initanis then
                local o = copy_table(v)
                setrawmetatable(v, {
                    __index = o, 
                    __newindex = function(self, i2, v2)
                        rawset(o, i2, v2)

                        if i2 == "animations" then
                            animations = v2
                        end
                    end
                })
                
                animations = o.animations
                table.clear(v)
            end
            
            local calculate = rawget(v, "CalculateCombatStyle")
            if calculate then
                combat_style = calculate
            end
        end
        
        if combat_style and animations then break end
    end

    coroutine.wrap(function()
        while true do
            if #attacking == 0 then task.wait(.1) continue end
            
            local animation_style = animations[combat_style()]
            for _, v in next, animation_style do
                if v.Name:find("Swing") then
                    local length = v.Length
                    v:AdjustSpeed(1 / length)
                    v:Play()

                    task.wait(.5)
                end
            end
        end
    end)()

    range.Touched:Connect(function(touching)  
        if not settings.KA or touching.Parent == char or touching.Name ~= "HumanoidRootPart" then 
            return
        end

        local enemy = touching.Parent
        if not table.find(attacking, enemy) then 
            local mob = table.find(mobs_on_floor[placeid], enemy.Name)
            local boss = table.find(bosses_on_floor[placeid], enemy.Name)
            local chest = enemy.Name:match("Chest")

            if mob or boss or chest then
                table.insert(attacking, enemy)
                killaura_function(enemy)

            elseif settings.AttackPlayers then
                table.insert(attacking, enemy)
                killaura_function(enemy, true)
            end
        end
    end)

    combat:AddToggle({
        Name = "Kill Aura",
        Default = false,
        Callback = function(bool)
            settings.KA = bool
            attacking = {} -- to overwrite attacking table when toggled off
        end
    })

    combat:AddToggle({
        Name = "Attack Players",
        Default = false,
        Callback = function(bool)
            settings.AttackPlayers = bool
        end
    })
    
    combat:AddSlider({
        Name = "Kill Aura Range",
        Min = 0,
        Max = 25,
        Default = 20,
        Color = Color3.new(255, 255, 255),
        Increment = 1,
        ValueName = "Range",
        Callback = function(v)
            settings.KA_Range = v
        end
    })

    local function getkabutton()
        for _, v in next, orion:GetDescendants() do
            if v:IsA("TextLabel") and v.Text == "Kill Aura" then
                local o = v.Parent:FindFirstChild("TextButton")
                if o then
                    return o
                end

                lib:MakeNotification({
                    Name = "KA Keybind Error",
                    Content = "Failed to find button",
                    Image = "",
                    Time = 5
                })
            end
        end
    end

    local ka_button = getkabutton()
    combat:AddBind({
        Name = "Kill Aura Keybind",
        Default = Enum.KeyCode.R,
        Hold = false,
        Callback = function()
            if ka_button then
                firesignal(ka_button.MouseButton1Down)
                firesignal(ka_button.MouseButton1Up) 
            else
                ka_button = getkabutton()
                if not ka_button then return end

                firesignal(ka_button.MouseButton1Down)
                firesignal(ka_button.MouseButton1Up)
            end
        end
    })
end

do
    local farm_tab2 = window:MakeTab({
        Name = "Farm Tab (util)",
        Icon = "",
        PremiumOnly = false
    })

    local getStats
    local getUpgrade
    local function getRarity(item)
        local rarity = item:FindFirstChild("Rarity")
        return rarity and rarity.Value
    end

    for _, v in next, getgc() do
        if typeof(v) == "function" and islclosure(v) then
            local info = getinfo(v)
            
            if info.name == "getStats" then
                getStats = v
            end
            
            if info.name == "getUpgrade" then
                getUpgrade = v 
            end
            
            if getStats and getUpgrade then break end
        end     
    end

    local data = Rs.Database.Items
    --[[
    formulas

    non legends: math.floor(base + (base * 0.04 * upgrade_count))
    legends: math.floor(base + (base * 0.05 * upgrade_count))

    ]]
    
    local ui_module = game_module.Services.UI
    local dismantler_module = require(ui_module.Dismantle)
    local inv_utility = getupvalue(dismantler_module.Init, 4)

    local profiles = Rs.Profiles
    local inventory = profiles[plr.Name].Inventory
    local rf = Rs.Function
    local event = Rs.Event

    local rates = setmetatable({Legendary = .05}, {
        __index = function(self, i)
            self[i] = .04
            return .04 
        end
    })
    local function AutoEquip()
        if not settings.AutoEquip then return end
        task.wait(1)

        local highest_damage = 0
        local highest_defense = 0
        local highest_weapon
        local highest_armor

        for _, item in next, inventory:GetChildren() do
            local itemdata = inv_utility.GetItemData(item)

            local class = itemdata.Type
            if class ~= "Weapon" and class ~= "Clothing" then continue end
            
            for _, v2 in next, data:GetChildren() do
                if v2.Name == item.Name then
                    local stats = getStats(v2)
                    local base
                    for _, v3 in next, stats do
                        if v3[1] == "Damage" or v3[1] == "Defense" then
                            base = tonumber(v3[2])
                            break
                        end
                    end
                    
                    local upgrades = getUpgrade(item)
                    local rarity = getRarity(v2)
                    local stat = math.floor(base + (base * rates[rarity] * upgrades))
                    
                    if class == "Weapon" then
                        if stat > highest_damage then
                            highest_damage = stat
                            highest_weapon = item
                        end

                    elseif class == "Clothing" then
                        if stat > highest_defense then
                            highest_defense = stat
                            highest_armor = item
                        end
                    end
                end
            end
        end
        
        if highest_weapon then
            rf:InvokeServer("Equipment", {"EquipWeapon", highest_weapon, "Right"})
        end

        if highest_armor then
            rf:InvokeServer("Equipment", {"Wear", highest_armor})
        end
    end

    inventory.ChildAdded:Connect(AutoEquip)
    farm_tab2:AddToggle({
        Name = "Auto Equip Best Weapon/Armor",
        Default = false,
        Callback = function(bool)
            settings.AutoEquip = bool
            AutoEquip()
        end
    })

    local isEquipped
    for _, v in next, getgc() do
        if typeof(v) == "function" and islclosure(v) then
            if getinfo(v).name == "isEquipped" then
                isEquipped = v
                break
            end
        end
    end

    local dismantle = {}
    local function AutoDismantle()
        local shouldDismantle = false
        for _, v in next, dismantle do
            if v then
                shouldDismantle = true
                break
            end
        end

        if not shouldDismantle then return end

        task.wait(1)
        local items = {}
        for _, item in next, inventory:GetChildren() do
            local itemdata = inv_utility.GetItemData(item)
            if isEquipped(item) then continue end

            local class = itemdata.Type
            if class ~= "Weapon" and class ~= "Clothing" then continue end

            for _, v2 in next, data:GetChildren() do
                if v2.Name == item.Name then
                    local rarity = getRarity(v2)
                    
                    if dismantle[rarity] then
                        items[#items + 1] = item
                    end
                end
            end

            if #items > 0 then
                event:FireServer("Equipment", {"Dismantle", {unpack(items)}})
            end
        end
    end

    local rarities = {"Common", "Uncommon", "Rare", "Legendary"}
    local names = {"Commons", "Uncommons", "Rares", "Legendaries"}

    for i, v in next, names do
        farm_tab2:AddToggle({
            Name = "Auto Dismantle " .. v,
            Default = false,
            Callback = function(bool)
                local rarity = rarities[i]
                dismantle[rarity] = bool
            end
        })
    end

    inventory.ChildAdded:Connect(AutoDismantle)
end

do
    local farm_tab3 = window:MakeTab({
        Name = "Mob Exclusion",
        Icon = "",
        PremiumOnly = false
    })

    for _, mob_name in next, mobs_on_floor[placeid] do
        farm_tab3:AddToggle({
            Name = mob_name,
            Default = false,
            Callback = function(bool)
                local excludedMobs = settings.excludedMobs
                excludedMobs[mob_name] = bool
            end
        })
    end
end

do
    local teleports_tab = window:MakeTab({
        Name = 'Teleports',
        Icon = "",
        PremiumOnly = false
    })

    local function getTouchPart()
        for _, v in next, workspace:GetDescendants() do
            if v.Parent.Name == "TeleportSystem" and v.Name == "Part" then
                return v
            end
        end
    end

    local function makespecialtpbutton(name, pos) -- floors 3 and 11
        teleports_tab:AddButton({
            Name = name .. " | may have to press twice",
            Callback = function()
                local totouch = getTouchPart()
                firetouchinterest(hrp, totouch, 0)
                task.wait(.1)

                for _ = 1, 100 do
                    hrp.CFrame = pos
                    task.wait()
                end

                firetouchinterest(hrp, totouch, 1)
            end
        })
    end

    local function makeTPbutton(name, part)
        teleports_tab:AddButton({
            Name = name,
            Callback = function()
                firetouchinterest(hrp, part, 0)
                task.wait(.1)
                firetouchinterest(hrp, part, 1)
            end
        })
    end
    
    local floor = math.floor
    local function loop_workspace(entrance, boss, miniboss, shop)
        for _, v in next, workspace:GetChildren() do
            if v.Name == "TeleportSystem" then
                for _, v2 in next, v:GetChildren() do
                    local posX = floor(v2.Position.X)
                    local posY = floor(v2.Position.Y)
                    local posZ = floor(v2.Position.Z)
                    local pos = Vector3.new(posX, posY, posZ)

                    if pos == entrance then
                        makeTPbutton("Dungeon Entrance", v2)
                    end

                    if pos == boss then
                        makeTPbutton("Boss Room", v2)
                    end

                    if pos == miniboss then
                        makeTPbutton("Mini Boss", v2)
                    end

                    if pos == shop then -- floor 10
                        makeTPbutton("Shop", v2)
                    end
                end
            end
        end
    end

    if placeid == 548231754 then -- floor 2
        local dungeon_entrance = Vector3.new(-2185, 161, -2321)
        local boss = Vector3.new(-2943, 201, -9805)
        
        loop_workspace(dungeon_entrance, boss)
    end
    
    if placeid == 555980327 then -- floor 3
        local dungeon_entrance = Vector3.new(1179, 6737, 1675)
        local boss = CFrame.new(448.331146, 4279.3374, -385.050385)

        makespecialtpbutton("Boss Room", boss)
        loop_workspace(dungeon_entrance)
    end
    
    if placeid == 572487908 then -- floor 4
        local dungeon_entrance = Vector3.new(-1946, 5169, -1415)
        local boss = Vector3.new(-2319, 2280, -515)
        
        loop_workspace(dungeon_entrance, boss)
    end
    
    if placeid == 580239979 then -- floor 5
        local dungeon_entrance = Vector3.new(-1562, 4040, -868)
        local boss = Vector3.new(2189, 1308, -122)
        
        loop_workspace(dungeon_entrance, boss)
    end
    
    if placeid == 548878321 then -- floor 8
        local dungeon_entrance = Vector3.new(-6679, 7801, 10006)
        local boss = Vector3.new(1848, 4110, 7723)
        local miniboss = Vector3.new(-808, 3174, -941)
        
        loop_workspace(dungeon_entrance, boss, miniboss)
    end
    
    if placeid == 573267292 then -- floor 9
        local dungeon_entrance = Vector3.new(878, 3452, -11139)
        local boss = Vector3.new(12241, 461, -3656)
        local miniboss_gargoyle = Vector3.new(-256, 3077, -4605)
        local miniboss_poly = Vector3.new(1973, 2986, -4487)
        
        loop_workspace(dungeon_entrance, boss, miniboss_gargoyle)
        loop_workspace(nil, nil, miniboss_poly)
    end
    
    if placeid == 2659143505 then -- floor 10
        local miniboss = Vector3.new(-895, 467, 6505)
        local boss = Vector3.new(45, 1003, 25432)
        local dungeon_entrance = Vector3.new(-606, 697, 9989)
        local shop = Vector3.new(-252, 504, 6163)
        
        loop_workspace(dungeon_entrance, boss, miniboss, shop)
    end
    
    if placeid == 5287433115 then -- floor 11
        local DaRaKa = CFrame.new(4846.48242, 1639.76953, 2090.85107)
        local duality_reaper = CFrame.new(5899.98291, 852.757568, -4255.58643)
        local neon_chest = CFrame.new(4834.57959, 2543.39868, 5274.56055)
        local sauraus = CFrame.new(5208.86279, 2349.82617, 5985.12402)

        makespecialtpbutton("Duality Reaper", duality_reaper)
        makespecialtpbutton("Da, Ra, Ka", DaRaKa)
        makespecialtpbutton("Neon Chest", neon_chest)
        makespecialtpbutton("Boss Room", sauraus)
    end
end

do
    local Character_tab = window:MakeTab({
        Name = "Character",
        Icon = "",
        PremiumOnly = false
    })
    
    local profiles = Rs.Profiles
    local animSettings = profiles[plr.Name].AnimSettings

    local animations = Rs.Database.Animations
    local ANIMATIONS = {}
    local blacklisted_animations = {"Spear", "Misc", "Daggers", "SwordShield", "Dagger"}
    for _, v in next, animations:GetChildren() do
        if not table.find(blacklisted_animations, v.Name) then
            table.insert(ANIMATIONS, v.Name)
            
            if not animSettings:FindFirstChild(v.Name) then
                local string_value = Instance.new("StringValue")
                
                string_value.Name = v.Name
                string_value.Value = ""
                string_value.Parent = animSettings
            end
        end
    end 

    Character_tab:AddDropdown({
        Name = "Weapon Animations",
        Default = settings.Animation,
        Options = ANIMATIONS,
        Callback = function(animation)
            settings.Weapon_Animation = animation
        end
    })

    local combat = require(game_module.Services.Combat)
    
    local hook; hook = hookfunc(combat.CalculateCombatStyle, function(bool, ...)
        if bool ~= nil and not bool then
            return hook(bool, ...)    
        end
        
        return settings.Weapon_Animation
    end)

    local invisibility = false
    local function goinvisible(new)
        if not invisibility then return end
        local old_root = new:WaitForChild("LowerTorso"):WaitForChild("Root")
        local new_root = old_root:Clone()

        new_root.Parent = old_root.Parent
        old_root:Destroy()
    end

    plr.CharacterAdded:Connect(goinvisible)

    Character_tab:AddToggle({
        Name = "Invisibility (Client Sided Character)", 
        Default = false, 
        Callback = function(bool)
            invisibility = bool
            goinvisible(char)
        end
    })

    local Event = Rs.Event
    local infSprint; infSprint = hookmetamethod(game, "__namecall", function(self, ...)
        local ncm = getnamecallmethod()
        
        if settings.InfSprint and ncm == "FireServer"  then
            if self == Event then
                local args = {...}
                if args[1] == "Actions" then
                    if args[2][2] == "Step" then
                        return
                    end
                end
            end
        end

        return infSprint(self, ...)
    end)

    Character_tab:AddToggle({
        Name = "Infinite Jump",
        Default = false,
        Callback = function(bool)
            settings.InfJump = bool
        end
    })

    UserInputS.InputBegan:Connect(function(key, processed)
        if processed then return end
        if not settings.InfJump then return end
        
        if key.KeyCode == Enum.KeyCode.Space then
            pcall(function() -- dont know if this can error // dont want to find out 
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end)
        end
    end)

    Character_tab:AddToggle({
        Name = "Infinite Sprint",
        Default = false,
        Callback = function(bool)
            settings.InfSprint = bool
        end
    })

    local walkspeed = humanoid.WalkSpeed
    local game_ws = humanoid.WalkSpeed
    local index_WS; index_WS = hookmetamethod(game, "__index", function(self, i)
        if self == humanoid and i == "WalkSpeed" and not checkcaller() then
            return game_ws
        end
        
        return index_WS(self, i) 
    end)
    
    local newindex_WS; newindex_WS = hookmetamethod(game, "__newindex", function(self, i, v)
        if self == humanoid and i == "WalkSpeed" and not checkcaller() then 
            if settings.speed then 
                v = walkspeed
            end

            game_ws = v
        end
        
        return newindex_WS(self, i, v)
    end)

    Character_tab:AddToggle({
        Name = "WalkSpeed Toggle",
        Default = false,
        Callback = function(bool)
            settings.speed = bool
            
            if bool then
                humanoid.WalkSpeed = walkspeed 
            else
                humanoid.WalkSpeed = game_ws
            end
        end
    })

    Character_tab:AddSlider({
        Name = "WalkSpeed",
        Min = 0,
        Max = 50,
        Default = walkspeed,
        Color = Color3.new(255, 255, 255),
        Increment = 1,
        ValueName = "Speed",
        Callback = function(speed)
            walkspeed = speed

            if settings.speed then
                humanoid.WalkSpeed = speed
            end
        end
    })
end

do  
    local Smithing = window:MakeTab({
        Name = "Smithing",
        Icon = "",
        PremiumOnly = false
    })

    local isEquipped
    for _, v in next, getgc() do
        if typeof(v) == "function" and islclosure(v) then
            if getinfo(v).name == "isEquipped" then
                isEquipped = v
                break
            end
        end
    end

    local ui_module = game_module.Services.UI
    local dismantler_module = require(ui_module.Dismantle)
    local inv_utility = getupvalue(dismantler_module.Init, 4)

    local event = Rs.Event
    local inventory = Rs.Profiles[plr.Name].Inventory
    local function Dismantle_Rarity(rarity)
        local items = {}
        for _, item in next, inventory:GetChildren() do
            local data = inv_utility.GetItemData(item)
            if isEquipped(item) then continue end

            if data.rarity == rarity then
                for _, v2 in next, data do
                    if v2 == "Weapon" or v2 == "Armor" then
                        items[#items + 1] = item
                        break
                    end
                end
            end

            if #items > 0 then
                event:FireServer("Equipment", {"Dismantle", {unpack(items)}})
            end
        end
    end
    
    local function create_confirm()
        local oldscreen = CoreGui:FindFirstChild("ScreenGui")
        local screen = oldscreen or Instance.new("ScreenGui", CoreGui)
        
        local popup = CoreGui.RobloxGui.PopupFrame
        local new = popup:Clone()
        
        local thread = coroutine.running()
        new.PopupAcceptButton.MouseButton1Click:Connect(function()
            new:Destroy()
            coroutine.resume(thread, true)
        end)
        
        new.PopupDeclineButton.MouseButton1Click:Connect(function()
            new:Destroy()
            coroutine.resume(thread, false)
        end)
        
        new.PopupText.Text = "Confirm Dismantle? (CANNOT BE UNDONE)"
        new.Parent = screen
        new.Visible = true
        
        return coroutine.yield()
    end

    local crystalForge_module = require(ui_module.CrystalForge)
    Smithing:AddButton({
        Name = "Open Crystal Forge",
        Callback = function()
            crystalForge_module.Open()
        end
    })

    local upgrade_module = require(ui_module.Upgrade)
    Smithing:AddButton({
        Name = "Open Upgrader",
        Callback = function()
            upgrade_module.Open()
        end
    })
    
    Smithing:AddButton({
        Name = "Open Dismantler",
        Callback = function()
            dismantler_module.Open()
        end
    })

    Smithing:AddButton({
        Name = "Dismantle All Commons",
        Callback = function()
            local confirm = create_confirm()

            if confirm then
                Dismantle_Rarity("Common")
            end
        end
    })

    Smithing:AddButton({
        Name = "Dismantle All Uncommons",
        Callback = function()
            local confirm = create_confirm()

            if confirm then
                Dismantle_Rarity("Uncommon")
            end
        end
    })

    Smithing:AddButton({
        Name = "Dismantle All Rares",
        Callback = function()
            local confirm = create_confirm()

            if confirm then
                Dismantle_Rarity("Rare")
            end
        end
    })

    Smithing:AddButton({
        Name = "Dismantle All Legendaries",
        Callback = function()
            local confirm = create_confirm()

            if confirm then
                Dismantle_Rarity("Legendary")
            end
        end
    })
end

do
    local Stats = window:MakeTab({
        Name = "Session Stats",
        Icon = "",
        PremiumOnly = false
    }) 
    
    local time_label = Stats:AddLabel("Elapsed Time")
    coroutine.wrap(function()
        -- what r string patterns (for real)
        --[[
        local round = math.round
        local seconds = round(time())
        local minutes = round(seconds / 60)
        local hours = round(minutes / 60)
        local days = round(hours / 24)
        
        local temp
        if hours >= 24 then
            temp = hours - 24
        end
        
        if hours >= 48 then
            temp = hours - 48
        end
        
        if hours >= 72 then
            temp = hours - 72
        end
        
        if hours >= 96 then
            temp = hours - 96
        end
        
        hours = temp or hours
        
        local displayed = days .. " Days | " .. hours .. " Hours | " .. "%M Minutes | " .. "%S Seconds"
        local formatted = os.date(displayed, seconds)
        ]]
        
        --[[
            local seconds = floor(time())
            local minutes = 0
            local hours = 0
            local days = 0
            
            while true do
                if seconds >= 60 then
                    seconds = seconds - 60
                    minutes = minutes + 1
                end
                
                if minutes >= 60 then
                    minutes = minutes - 60
                    hours = hours + 1
                end
                
                if hours >= 24 then
                    hours = hours - 24
                    days = days + 1
                end
                
                if hours < 24 and minutes < 60 and seconds < 60 then
                    break
                end
            end
        ]]

        local floor = math.floor
        while true do task.wait(1) -- this is the last time i rewrite this
            local seconds = floor(time())
            local minutes = floor(seconds / 60)
            seconds = seconds - (60 * minutes)
            
            local hours = floor(minutes / 60)
            minutes = minutes - (60 * hours)
            
            local days = floor(hours / 24)
            hours = hours - (24 * days)
            
            local o1 = days == 1 and "Day" or "Days"
            local o2 = hours == 1 and "Hour" or "Hours"
            local o3 = minutes == 1 and "Minute" or "Minutes"
            local o4 = seconds == 1 and "Second" or "Seconds"

            local displayed = ("%s %s | %s %s | %s %s | %s %s"):format(days, o1, hours, o2, minutes, o3, seconds, o4) -- wtf
            time_label:Set("Time Elapsed: " .. displayed)
        end
    end)()
end

do
    local function removeEffects(func_name)
        for _, v in next, getgc(true) do
            local old = typeof(v) == "table" and rawget(v, func_name)
    
            if old then
                v[func_name] = function(...)
                    if func_name == "Damage Text" then
                       if settings.RemoveDamageNumbers then return end

                    elseif func_name == "DeathExplosion" then
                        if settings.RemoveDeathEffects then return end
                    end

                    return old(...) 
                end
            end
        end
    end

    removeEffects("Damage Text") -- remove X variables are still false, does nothing until toggled
    removeEffects("DeathExplosion")
    
    local Performance_tab = window:MakeTab({
        Name = "Perf Boosters",
        Icon = "",
        PremiumOnly = false
    })

    local hiteffects = workspace:FindFirstChild("HitEffects")
    Performance_tab:AddToggle({
        Name = "Remove Hit Effects",
        Default = false,
        Callback = function(bool)
            hiteffects = hiteffects or workspace:FindFirstChild("HitEffects")
            if not hiteffects then return end

            if bool then
                hiteffects.Parent = nil
            else
                hiteffects.Parent = workspace
            end
        end
    })

    Performance_tab:AddToggle({
        Name = "Remove Damage Numbers",
        Default = false,
        Callback = function(bool)
            settings.RemoveDamageNumbers = bool
        end
    })

    Performance_tab:AddToggle({
        Name = "Remove Death Effects",
        Default = false,
        Callback = function(bool)
            settings.RemoveDeathEffects = bool
        end
    })

    local tomute = false
    local sound_names = {"SwordHit", "Unsheath", "SwordSlash"}
    local sounds = {}

    for _, v in next, workspace:GetDescendants() do
        if table.find(sound_names, v.Name) then
            sounds[v] = v
        end
    end 

    local function muteswings(descendant)
        if table.find(sound_names, descendant.Name) then
            sounds[descendant] = descendant
            descendant.Volume = tomute and 0 or .3
        end
    end

    workspace.DescendantAdded:Connect(muteswings)
    workspace.DescendantRemoving:Connect(function(descendant)
        sounds[descendant] = nil
    end)

    Performance_tab:AddToggle({
        Name = "Mute Swing Sounds",
        Default = false,
        Callback = function(bool)
            tomute = bool
            for _, v in next, sounds do
                v.Volume = tomute and 0 or .3
            end
        end
    })
end

do 
    local Misc_tab = window:MakeTab({
        Name = "Misc",
        Icon = "",
        PremiumOnly = false
    })
    
    local players_names = {}
    
    for _, v in next, Players:GetPlayers() do
        table.insert(players_names, v.Name) 
    end
    
    local inventory = require(game_module.Services.UI.Inventory)
    local inventory_viewer = Misc_tab:AddDropdown({
        Name = "Inventory Viewer (Open Inventory)",
        Default = plr.Name,
        Options = players_names,
        Callback = function(player)
            setupvalue(inventory.GetInventoryData, 1, Rs.Profiles[player]) -- trick the game into getting the inventory data of the selected player instead of your own data
        end
    })

    local function refresh_inventoryViewer_list(dp) 
        local players_instances = Players:GetPlayers()
        local players_names = {}
        
        for _, v in next, players_instances do
            table.insert(players_names, v.Name)
        end
        
        dp:Refresh(players_names, true)
    end
    
    Players.PlayerAdded:Connect(function(player)
        repeat task.wait() until Rs.Profiles:FindFirstChild(player.Name) ~= nil
        
        refresh_inventoryViewer_list(inventory_viewer)
    end)
    
    Players.PlayerRemoving:Connect(function()
        refresh_inventoryViewer_list(inventory_viewer)
    end)
    
    local fps = getfpscap and getfpscap() or 60
    Misc_tab:AddSlider({
        Name = "Set FPS Cap (Requires executor FPS unlocker on)",
        Min = 0,
        Max = 500,
        Default = fps, -- synapse does not have getfpscap (bad0)
        Color = Color3.new(255, 255, 255),
        Increment = 1,
        ValueName = "FPS",
        Callback = function(v)
            setfpscap(v)
        end
    })
    
    Misc_tab:AddToggle({
        Name = "Infinite Zoom Distance",
        Default = false,
        Callback = function(bool)
            if bool then
                plr.CameraMaxZoomDistance = math.huge
            else
                plr.CameraMaxZoomDistance = 15
            end
        end
    })
    
    Misc_tab:AddBind({
        Name = "GUI Keybind",
        Default = Enum.KeyCode.RightShift,
        Hold = false,
        Callback = function()
            orion.Enabled = not orion.Enabled
        end
    })  
end

do
    local updates = window:MakeTab({
        Name = "Updates",
        Icon = "",
        PremiumOnly = false
    }) 
    
    updates:AddParagraph("8/9/22", "Added Autofarm Radius Slider")
    updates:AddParagraph("8/9/22", "further improved teleports on f11")
    updates:AddParagraph("8/4/22", "Fixed auto equip & auto dismantle")
    updates:AddParagraph("8/4/22", "session time shows the correct time now")
    updates:AddParagraph("8/4/22", "Added support for more exploits")
    updates:AddParagraph("8/3/22", "Added teleport support for floor 11 dungeon")
    updates:AddParagraph("8/2/22", "Added KillAura Keybind")
    updates:AddParagraph("7/30/22", "Added Infinite Jump (avoid game making u fall through map on teleport)")
    updates:AddParagraph("7/29/22", "Added Killaura & Autofarm support for floor 11 dungeon")
    updates:AddParagraph("7/9/22", "removed esp (crashes)")
    updates:AddParagraph("7/8/22", "Attack animation now plays after death")
    updates:AddParagraph("7/7/22", "Fixed ESP crash (i think)?")
    updates:AddParagraph("7/7/22", "Added player ESP (mob soon)")
    updates:AddParagraph("7/3/22", "killaura animations works for players now")
    updates:AddParagraph("7/3/22", "Killaura now looks 'legit' (plays attack animation)")
    updates:AddParagraph("7/3/22", "Mute Swings now mutes others swings")
    updates:AddParagraph("7/3/22", "Added Auto Dismantle")
    updates:AddParagraph("7/2/22", "Added Mob Exclusion to Autofarm")
    updates:AddParagraph("7/2/22", "Killaura now supports chests (mostly useless (lol))")
    updates:AddParagraph("7/1/22", "Added Auto Equip Best Weapon")
    updates:AddParagraph("7/1/22", "Added Tween Speed")
    updates:AddParagraph("7/1/22", "Added Performance Boosters")
    updates:AddParagraph("6/28/22", "Killaura now works for baal & grim")
    updates:AddParagraph("6/27/22", "Moved dismantle confirm to an external popup box")
    updates:AddParagraph("6/15/22", "Added Upgrade Equipped Weapons (armors later)")
    updates:AddParagraph("6/15/22", "Added a confirm to dismantle all (there is a bug when u dismantle an equipped item)")
    updates:AddParagraph("6/15/22", "Added dismantle all of a certain rarity")
    updates:AddParagraph("6/13/22", "Included Crystal Forge to the smithing tab")
    updates:AddParagraph("6/13/22", "Fixed farm only bosses making your velocity 0")
    updates:AddParagraph("6/13/22", "Fixed farm only bosses not working")
    updates:AddParagraph("6/13/22", "Fixed A bug where changing Y offset would activate autofarm")
    updates:AddParagraph("6/13/22", "Skills Now Work with Animations")
    updates:AddParagraph("6/13/22", "Fixed Attack Players not toggling off")
    updates:AddParagraph("6/13/22", "Removed a Useless Animation Feature")
    updates:AddParagraph("6/12/22", "Made Autofarm Tweening Smooth")
    updates:AddParagraph("6/12/22", "Fixed an Autofarm Bug (Teleport after death)")
    updates:AddParagraph("6/5/22", "Made All Floors show actual TP locations")
    updates:AddParagraph("6/4/22", "Made Some Floors show actual TP locations (wip)")
    updates:AddParagraph("6/3/22", "Autofarm Added (improving)")
    updates:AddParagraph("6/2/22", "M1s are stopped when Kill Aura is enabled")
end

do
    local credits = window:MakeTab({
        Name = "Credits",
        Icon = "",
        PremiumOnly = false
    })

    credits:AddParagraph("Credits", "Made by OneTaPuXd on v3rm | PM Bugs")
    if setclipboard then
        credits:AddButton({
            Name = "Copy v3rm url to clipboard",
            Callback = function()
                setclipboard("https://v3rmillion.net/member.php?action=profile&uid=1229592")
            end
        })

        credits:AddButton({
            Name = "copy v3rm thread to clipboard",
            Callback = function()
                setclipboard("https://v3rmillion.net/showthread.php?tid=1172798")
            end
        })
    else
        credits:AddParagraph("v3rm url", "https://v3rmillion.net/member.php?action=profile&uid=1229592")
    end

    local http = game:GetService("HttpService")
    local request = (syn and syn.request) or (fluxus and fluxus.request) or request
    credits:AddButton({
        Name = "Discord Server (Auto Prompt) join code: eWGZ8rYpxR",
        Callback = function()
            if typeof(request) ~= "function" then return end

            request({
                Url = "http://127.0.0.1:6463/rpc?v=1",
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json",
                    ["Origin"] = "https://discord.com"
                },
                Body = http:JSONEncode({
                    cmd = "INVITE_BROWSER",
                    args = {
                        code = "eWGZ8rYpxR"
                    },
                    nonce = http:GenerateGUID()
                })
            })
        end
    })
end

lib:Init()
