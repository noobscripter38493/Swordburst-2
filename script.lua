-- loadfile('Scriptz/sb2 script.lua')()
-- loadstring(game:HttpGet('https://raw.githubusercontent.com/noobscripter38493/Swordburst-2/main/script.lua'))()
if SB2Script then return end
getgenv().SB2Script = true

while not game:IsLoaded() do
    task.wait()
end

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
        "Canyon Knight",
        "Ruin Kobold Knight",
        "Ruined Kobold Knight"
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
        "Rahjin the Thief King",
        "Ruined Kobold Lord"
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
        "Baal, The Tormentor",
        "Grim, The Overseer"
    },

    [5287433115] = { -- floor 11
        "Da, the Demeanor",
        "Ra, the Enlightener",
        "Ka, the Mischief",
        "Za, the Eldest",
        "Duality Reaper",
        "Saurus, the All-Seeing",
        "Neon Chest"
    }
}

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputS = game:GetService("UserInputService")
local TweenS = game:GetService("TweenService")
local RunS = game:GetService("RunService")
local Rs = game:GetService("ReplicatedStorage")
local Event = Rs.Event

getgenv().getupvalue = debug.getupvalue -- not sure if other exploits that aren't synapse have an alias so this is for that i guess
getgenv().setupvalue = debug.setupvalue
getgenv().getinfo = debug.getinfo
getgenv().hookfunc = hookfunction
getgenv().setreadonly = setreadonly or makereadonly or makewritable

local placeid = game.PlaceId

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

local vim = game:GetService("VirtualInputManager")

coroutine.wrap(function()
    while true do
        vim:SendKeyEvent(true, Enum.KeyCode.Home, false, game)
        task.wait(1)
        vim:SendKeyEvent(false, Enum.KeyCode.Home, false, game)
        task.wait(60 * 15)
    end
end)()

local char = plr.Character or plr.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

while not getrenv()._G.CalculateCombatStyle do
    task.wait()
end

local settings = { -- defaults
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
    KA_Keybind = "R",
    RemoveDamageNumbers = false,
    AttackPlayers = false,
    Animation = getrenv()._G.CalculateCombatStyle(),
    MaxAutofarmDistance = 5000,
    excludedMobs = {},
    Height = 30,
    Autofarm_Idle_Min = 30,
    Autofarm_Idle_Max = 70,
    WebhookURL = "",
    skillSilentAim = false,
    SkillCount = 0,
    WeaponSkill = "Weapon Class Skill"
}

local doLoad = {
    Height = true,
    Autofarm_Idle_Min = true,
    Autofarm_Idle_Max = true,
    MaxAutofarmDistance = true,
    KA_Keybind = true,
    KA_Range = true,
    Autofarm_Y_Offset = true,
    WebhookURL = true,
    Tween_Speed = true,
    skillSilentAim = true,
    SkillCount = true,
    WeaponSkill = true
}

local HttpS = game:GetService("HttpService")
local function save_settings()
    writefile("SB2 Script/Settings.json", HttpS:JSONEncode(settings))
end

if not isfolder("SB2 Script") then
    makefolder("SB2 Script")
end

if not isfile("SB2 Script/Settings.json") then
    save_settings()
end

xpcall(function() 
    HttpS:JSONDecode(readfile("SB2 Script/Settings.json"))
end, save_settings)

local saved_settings = HttpS:JSONDecode(readfile("SB2 Script/Settings.json"))
for i, v in next, saved_settings do
    if not doLoad[i] then 
        continue
    end
    
    settings[i] = v
end

coroutine.wrap(function()
    while true do
        save_settings()
        task.wait(5)
    end
end)()

local function WaitForDescendant(parent, descendant_name)
    local already = parent:FindFirstChild(descendant_name, true)
    if already then
        return already 
    end
    
    local thread = coroutine.running()
    local con; con = parent.DescendantAdded:Connect(function(c)
        if c.Name == descendant_name then
            con:Disconnect()
            coroutine.resume(thread, c)
        end
    end)
    
    return coroutine.yield()
end

local parts = {}
local function setNoClipParts()
    table.clear(parts)
    
    for _, part in next, char:GetDescendants() do
        if part:IsA("BasePart") and part.CanCollide then
            parts[#parts + 1] = part
        end
    end

    task.wait(1)
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

local actions = require(game_module.Services.Actions)

local old = actions.StartSwing
actions.StartSwing = function(...)
    if settings.KA then
        return
    end

    return old(...)
end

local rf = Rs.Function
local inventory_module = require(game_module.Services.UI.Inventory)
local nc; nc = hookmetamethod(game, "__namecall", function(self, ...)
    local ncm = getnamecallmethod()
    local args = {...}
    
    if self == Event and ncm == "FireServer" then
        if settings.InfSprint and args[1] == "Actions" then 
            if args[2][2] == "Step" then
                return
            end
        end

    elseif self == rf and ncm == "InvokeServer" then
        if not checkcaller() and args[1] == "Equipment" then
            if getupvalue(inventory_module.GetInventoryData, 1) ~= Rs.Profiles[plr.Name] then
                return
            end
        end
    end

    return nc(self, ...)
end)

local request = (syn and syn.request) or (fluxus and fluxus.request) or request
local identify = identifyexecutor
if typeof(request) ~= "function" then
    local err_message = ("%s Executor is not compatible with this script. Join discord: discord.gg/eWGZ8rYpxR"):format(identify and "The " .. identify() or "Your")
    return plr:Kick(err_message)
end

local response = request({
    Url = "https://raw.githubusercontent.com/shlexware/Orion/main/source",
    Method = "GET"
})
local lib = loadstring(response.Body)()

while not lib do
    task.wait()
end

local protected = gethui and gethui() or CoreGui
local orion = protected:WaitForChild("Orion")

local window = lib:MakeWindow({
    Name = "SB2 Script | OneTaPuXd on v3rm | .gg/eWGZ8rYpxR",
    HidePremium = false,
    SaveConfig = false,
    ConfigFolder = false
})

local function getMobHealth(mob)
    local entity = mob and mob:FindFirstChild("Entity")
    return entity and entity:FindFirstChild("Health")
end

do
    local farm_tab = window:MakeTab({
        Name = "Autofarm",
        Icon = "",
        PremiumOnly = false
    })

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
            if excludedMobs[boss.Name] then continue end

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
            if excludedMobs[boss.Name] then continue end

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

    local function DoStuff()
        local to
        if settings.Farm_Only_Bosses then
            to = searchForAnyBoss(bosses_on_floor[placeid])
            to = to and to:FindFirstChild("HumanoidRootPart")
            to = to or floatPart

            shouldFloat = to == floatPart
            return to
        end

        local boss = settings.Prioritized_Boss
        if settings.Boss_Priority and boss then
            to = searchForBoss(boss)
        end

        local mob = settings.Prioritized_Mob
        if not to and settings.Mob_Priority and mob then
            to = searchForMob(mob)
        end

        if not to then
            to = searchForAnyEnemy()
        end

        to = to and to:FindFirstChild("HumanoidRootPart") or floatPart

        shouldFloat = to == floatPart
        return to
    end
    
    local IsWaitingFromHealthFloat = false
    local function playerHealthChecks()
        local minPercentage = settings.Autofarm_Idle_Min / 100
        local maxPercantage = settings.Autofarm_Idle_Max / 100

        if not IsWaitingFromHealthFloat and playerHealth < minPercentage * maxPlayerHealth then
            IsWaitingFromHealthFloat = true
            shouldFloat = true  
            return floatPart
        end

        if IsWaitingFromHealthFloat and playerHealth > maxPercantage * maxPlayerHealth then
            IsWaitingFromHealthFloat = false
        end

        if not IsWaitingFromHealthFloat then
            return DoStuff()
        end
            
        shouldFloat = true
        return floatPart
    end

    local marked = {}
    local t = tick()
    local function TweenF()
        local to = playerHealthChecks()
        local enemy = to ~= floatPart and to.Parent

        local mob_health
        if not shouldFloat then
            mob_health = getMobHealth(enemy)
        end
        while mob_health and mob_health.Value > 0 or shouldFloat do
            task.wait()

            coroutine.wrap(function()
                to = playerHealthChecks()
                enemy = to ~= floatPart and to.Parent

                local distance = (hrp.Position - to.Position).Magnitude
                if enemy and distance < 100 and not marked[enemy] then
                    local oldto = to
                    local oldenemy = enemy
                    
                    mob_health = getMobHealth(oldenemy)
                    if not mob_health then 
                        return
                    end
                    
                    marked[oldenemy] = mob_health:GetPropertyChangedSignal("Value"):Connect(function()
                        t = tick()
                    end)

                    coroutine.wrap(function()
                        while true do 
                            local success = pcall(function()
                                distance = (hrp.Position - oldto.Position).Magnitude
                            end)
                            
                            if not success or distance > 100 then
                                local con = marked[oldenemy]
                                if con.Connected then
                                    marked[oldenemy]:Disconnect()
                                end

                                marked[oldenemy] = nil

                                break
                            end
                            
                            task.wait(1)
                        end
                    end)()
                end

                if not shouldFloat then
                    mob_health = getMobHealth(enemy)
                end

                local seconds = distance / settings.Tween_Speed
                local y_offset = shouldFloat and 0 or settings.ForceLower or settings.Autofarm_Y_Offset
                local cframe = to.CFrame * CFrame.new(0, y_offset, 0)

                local tween_info = TweenInfo.new(seconds, Enum.EasingStyle.Linear)
                local tween = TweenS:Create(hrp, tween_info, {CFrame = cframe})
                table.insert(tweens, tween)
                
                tween:Play()
                tween.Completed:Wait()
            end)()
            
            if not settings.Autofarm or not to.Parent then
                break 
            end
        end
    end

    coroutine.wrap(function()
        while true do
            if settings.Autofarm and not shouldFloat and settings.KA then
                local count = 0
                for _, _ in next, marked do
                    count = count + 1
                end

                if count > 0 and tick() - t > 10 then
                    settings.ForceLower = 0
                    task.wait(1)
                    settings.ForceLower = nil
                end
            end

            task.wait(1)
        end
    end)()
    
    RunS.RenderStepped:Connect(function()
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
    
    for _, mob in next, mobs:GetChildren() do
        coroutine.wrap(function()
            mob:WaitForChild("HumanoidRootPart")
            mobs_table[mob] = mob
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

                while #marked ~= 0 do
                    for i, v in next, marked do
                        v:Disconnect()
                        marked[i] = nil
                    end

                    task.wait()
                end
                
                return
            end

            while settings.Autofarm do
                TweenF()
                task.wait()
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
        Default = settings.MaxAutofarmDistance,
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
        Default = settings.Autofarm_Y_Offset,
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
        Default = settings.Height,
        Color = Color3.new(255, 255, 255),
        Increment = 1,
        ValueName = "Studs",
        Callback = function(v)
            settings.Height = v
        end
    })

    farm_tab:AddSlider({
        Name = "Idle Float when under % health",
        Min = 0,
        Max = 100,
        Default = settings.Autofarm_Idle_Min,
        Color = Color3.new(255, 255, 255),
        Increment = 1,
        ValueName = "%",
        Callback = function(v)
            settings.Autofarm_Idle_Min = v
        end
    })

    farm_tab:AddSlider({
        Name = "Resume Farm when over % health",
        Min = 0,
        Max = 100,
        Default = settings.Autofarm_Idle_Max,
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
        Default = settings.Tween_Speed,
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

    local skillService = require(game_module.Services.Skills)
    local UseSkill = skillService.UseSkill
    local GetCooldown = skillService.GetCooldown

    local attacking = {}
    local pauseKillAura = false
    local function killaura_function(enemy, player)
        while true do
            local i = table.find(attacking, enemy)
            local success, shouldFarm = pcall(function()
                return enemy.Entity.Health.Value > 0
            end)

            if not success or not shouldFarm or not settings.KA then
                table.remove(attacking, i)
                return
            end

            local enemy_hrp = enemy:FindFirstChild("HumanoidRootPart")
            if not enemy_hrp or enemy:FindFirstChild("Immortal") or (hrp.Position - enemy_hrp.Position).Magnitude > settings.KA_Range then
                table.remove(attacking, i)
                break 
            end

            if player and not settings.AttackPlayers then
                table.remove(attacking, i)
                break
            end

            if not pauseKillAura then
                Event:FireServer("Combat", remote_key, {"Attack", nil, "1", enemy})
            end
            
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
            
            local animation_style = animations[combat_style(nil, true)]
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
                attacking[#attacking + 1] = enemy
                killaura_function(enemy)

            elseif settings.AttackPlayers then
                attacking[#attacking + 1] = enemy
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
        Default = settings.KA_Range,
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
    local ka_bind = combat:AddBind({
        Name = "Kill Aura Keybind",
        Default = Enum.KeyCode[settings.KA_Keybind],
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
    
    local inputbegan
    for _, v in next, orion:GetDescendants() do
        if v:IsA("TextLabel") and v.Text == "Kill Aura Keybind" then
            v.Parent.TextButton.MouseButton1Down:Connect(function()
                if inputbegan and inputbegan.Connected then
                    return
                end
                
                inputbegan = UserInputS.InputBegan:Connect(function(inputobj)
                    if inputobj.UserInputType == Enum.UserInputType.Keyboard then
                        inputbegan:Disconnect()
                        
                        local key = inputobj.KeyCode
                        local key2 = tostring(key)
                        settings.KA_Keybind = key2:split("Code.")[2]
                        task.wait(.5)
                        ka_bind:Set(key)
                    end
                end)
            end)
            
            break
        end
    end
    
    local skillsData = game.ReplicatedStorage.Database.Skills
    local skill_classes = {}
    for i, v in next, skillsData:GetChildren() do
        if v:FindFirstChild("Class") then
            skill_classes[v.Class.Value] = v.Name
        end
    end

    local GetCombatStyle = getrenv()._G.CalculateCombatStyle
    local style
    local hotkeys = Rs.Profiles[plr.Name].Hotkeys

    local selectSkill
    task.spawn(function()
        hotkeys:WaitForChild("Summon Pistol")

        while not selectSkill do
            task.wait(1)
        end

        selectSkill:Refresh({"Summon Pistol"})
    end)

    range.Touched:Connect(function(touching)
        if settings.SkillAura and touching.Parent ~= char and touching.Name == "HumanoidRootPart" then
            local enemy = touching.Parent
            local mob = table.find(mobs_on_floor[placeid], enemy.Name)
            local boss = table.find(bosses_on_floor[placeid], enemy.Name)

            if not boss and not mob then
                return
            end

            local health2 = getMobHealth(enemy)
            if health2 and health2.Value > 0 then
                style = GetCombatStyle()

                local skill = settings.WeaponSkill == "Summon Pistol" and "Summon Pistol" or skill_classes[style] 
                if skill and GetCooldown(skill) then
                    pauseKillAura = true
                    UseSkill(skill)
                    
                    task.wait(.5)
                    pauseKillAura = false
                end
            end
        end
    end)

    local level = WaitForDescendant(plr, "Level")
    combat:AddToggle({
        Name = "Skill Aura",
        Default = false,
        Callback = function(bool)
            local n = string.match(level.Text, "%d+")
            if tonumber(n) < 22 then
                return lib:MakeNotification({
                    Name = "Your Level is Not High Enough",
                    Content = "Reach Level 22 Before Using Skill Aura",
                    Image = "",
                    Time = 5
                })
            end
            
            settings.SkillAura = bool
        end
    })

    local passive = {
        Heal = true,
        ["Summon Tree"] = true,
        ["Summon Pistol"] = true,
        Block = true,
        Roll = true
    }

    local skillHandlers
    for _, v in next, getgc(true) do
        if typeof(v) == "table" and rawget(v, "skillHandlers") then
            skillHandlers = v.skillHandlers
            break
        end
    end

    --[[
    local nc5; nc5 = hookmetamethod(game, "__namecall", function(self, ...)
        if self == Event and getnamecallmethod() == "FireServer" then
            local args = {...}
            local t = args[2]
            if args[1] == "Skills" and t[1] == "UseSkill" and t[2] == "Summon Pistol" then
                local rand = math.random() / 10000
                t[3].Direction = t[3].Direction + Vector3.new(rand, rand, rand)
                return  nc5(self, unpack(args))
            end
        end
        
        return nc5(self, ...) 
    end)
    ]]

    for i, old2 in next, skillHandlers do
        if passive[i] then
            continue
        end

        skillHandlers[i] = function(...)
            task.spawn(function(...)
                for _ = 1, settings.SkillCount do
                    task.spawn(old2, ...)
                end
            end, ...)
            
            return old(...)
        end
    end

    selectSkill = combat:AddDropdown({
        Name = "Select Skill to Use",
        Default = settings.WeaponSkill,
        Options = {"Weapon Class Skill"},
        Callback = function(skill)
            settings.WeaponSkill = skill
        end
    })

    combat:AddSlider({
        Name = "Skill Multiplier",
        Min = 0,
        Max = 3,
        Default = settings.SkillCount,
        Color = Color3.new(255, 255, 255),
        Increment = 1,
        ValueName = "Skills",
        Callback = function(v)
            settings.SkillCount = v
        end
    })

    combat:AddToggle({
        Name = "Skill Silent Aim",
        Default = false,
        Callback = function(bool)
            settings.skillSilentAim = bool
        end
    })

    local mobs = workspace.Mobs
    local function GetClosestMob()
        local closest_magnitude = math.huge
        local closest_hrp
        
        for _, mob in next, mobs:GetChildren() do
            local mob_hrp = mob:FindFirstChild("HumanoidRootPart")
            if not mob_hrp then 
                continue 
            end

            local magnitude = (mob_hrp.Position - hrp.Position).Magnitude
            if magnitude < closest_magnitude then
                closest_hrp = mob_hrp
                closest_magnitude = magnitude
            end
        end
        
        return closest_hrp
    end

    local myCframe
    local index; index = hookmetamethod(game, "__index", function(self, i)
        if self == hrp and i == "CFrame" then
            local consts
            local success = pcall(function()
                consts = getconstants(3)
            end)
            if success and table.find(consts, "lookVector") then
                myCframe = index(self, i)
                return myCframe
            end
        end

        return index(self, i)
    end)

    local mt = getrawmetatable(CFrame.new())
    setreadonly(mt, false)

    local old = mt.__index
    mt.__index = newcclosure(function(self, i)
        if settings.skillSilentAim and rawequal(self, myCframe) and i == "lookVector" then
            local mob = GetClosestMob()
            if mob then
                local cf = CFrame.new(hrp.Position, mob.Position)
                return old(cf, "lookVector")
            end
        end

        return old(self, i)
    end)

    setreadonly(mt, true)
end

local dismantle = {}
local rates = setmetatable({Legendary = .05}, {
    __index = function(self, i)
        self[i] = .04
        return .04 
    end
})

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
    
    local data = Rs.Database.Items
    local function AutoEquip()
        if not settings.AutoEquip then 
            return 
        end

        task.wait(1)

        local highest_damage = 0
        local highest_defense = 0
        local highest_weapon
        local highest_armor

        for _, item in next, inventory:GetChildren() do
            local item_data = inv_utility.GetItemData(item)

            local class = item_data.Type
            if class ~= "Weapon" and class ~= "Clothing" then 
                continue 
            end
            
            local v2 = data[item.Name]
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

    local function AutoDismantle(item)
        task.wait(1)
        
        local itemdata = inv_utility.GetItemData(item)
        local class = rawget(itemdata, "Type")
        if class ~= "Weapon" and class ~= "Clothing" then return end
        
        local rarity = getRarity(data[item.Name])
            
        if dismantle[rarity] then
            Event:FireServer("Equipment", {"Dismantle", {item}})
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
        Name = "Autofarm Exclusion",
        Icon = "",
        PremiumOnly = false
    })

    local all_on_floor = {}
    for i, v in next, bosses_on_floor[placeid] do
        all_on_floor[i] = v
    end

    for _, v in next, mobs_on_floor[placeid] do
        all_on_floor[#all_on_floor + 1] = v
    end

    for _, mob_name in next, all_on_floor do
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

    local function GetClosestPartFromVector(v3)
        local closest_magnitude = math.huge
        local closest_part

        for _, v in next, workspace:GetDescendants() do
            if v.Parent.Name == "TeleportSystem" and v.Name == "Part" then
                local distance = (v3 - v.Position).Magnitude
                if distance < closest_magnitude then
                    closest_magnitude = distance
                    closest_part = v
                end
            end
        end

        return closest_part
    end

    local function makespecialtpbutton(name, pos)
        task.spawn(function()
            plr:RequestStreamAroundAsync(pos)
            task.wait(1)

            local totouch = GetClosestPartFromVector(pos)
            teleports_tab:AddButton({
                Name = name,
                Callback = function()
                    firetouchinterest(hrp, totouch, 0)
                    task.wait(.1)
                    firetouchinterest(hrp, totouch, 1)
                end
            })
        end)
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
    
    local function loop_workspace(entrance, boss, miniboss, shop)
        local totouch1 = entrance and GetClosestPartFromVector(entrance)
        local totouch2 = boss and GetClosestPartFromVector(boss)
        local totouch3 = miniboss and GetClosestPartFromVector(miniboss)
        local totouch4 = shop and GetClosestPartFromVector(shop)

        if totouch1 then
            makeTPbutton("Dungeon Entrance", totouch1)
        end

        if totouch2 then
            makeTPbutton("Boss Room", totouch2)
        end

        if totouch3 then
            makeTPbutton("Mini Boss", totouch3)
        end

        if totouch4 then -- floor 10
            makeTPbutton("Shop", totouch4)
        end
    end

    if placeid == 542351431 then -- floor 1
        local dungeon_entrance = Vector3.new(-1181, 70, 308)
        local miniboss = Vector3.new(139, 225, -132)
        local boss = Vector3.new(-2942, -125, 336)

        loop_workspace(dungeon_entrance, boss, miniboss)
    end

    if placeid == 548231754 then -- floor 2
        local dungeon_entrance = Vector3.new(-2185, 161, -2321)
        local boss = Vector3.new(-2943, 201, -9805)
        
        loop_workspace(dungeon_entrance, boss)
    end
    
    if placeid == 555980327 then -- floor 3
        local dungeon_entrance = Vector3.new(1179, 6737, 1675)
        local boss = Vector3.new(448, 4279, -385)

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

    if placeid == 582198062 then -- floor 7
        local dungeon_entrance = Vector3.new(1219, 1083, -274)
        local boss = Vector3.new(3347, 800, -804)

        makespecialtpbutton("Dungeon Entrance", dungeon_entrance)
        makespecialtpbutton("Boss", boss)
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
        local DaRaKa = Vector3.new(4801, 1646, 2083)
        local Za = Vector3.new(4001, 421, -3794)
        local duality_reaper = Vector3.new(4763, 501, -4344)
        local neon_chest = Vector3.new(5204, 2294, 5778)
        local sauraus = Vector3.new(5333, 3230, 5589)

        makespecialtpbutton("Duality Reaper", duality_reaper)
        makespecialtpbutton("Da, Ra, Ka", DaRaKa)
        makespecialtpbutton("Za", Za)
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

    local shouldAnimate
    Character_tab:AddToggle({
        Name = "Weapon Animation",
        Default = false,
        Callback = function(bool)
            shouldAnimate = bool
        end
    })

    Character_tab:AddDropdown({
        Name = "Weapon Animations",
        Default = settings.Animation,
        Options = ANIMATIONS,
        Callback = function(animation)
            settings.Weapon_Animation = animation
        end
    })

    local combat = require(game_module.Services.Combat)
    
    local old5; old5 = hookfunc(combat.CalculateCombatStyle, function(bool, brah)
        if checkcaller() and brah then
            return settings.Weapon_Animation
        end

        if checkcaller() then
            return old5(bool)
        end

        if not shouldAnimate or bool == false then
            return old5(bool)    
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
        Name = "Invisibility (only u can see u)", 
        Default = false, 
        Callback = function(bool)
            invisibility = bool
            goinvisible(char)
        end
    })

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
                Event:FireServer("Equipment", {"Dismantle", items})
            end
        end
    end
    
    local screen = Instance.new("ScreenGui", CoreGui)
    local function create_confirm()
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
        new.Visible = true
        new.Parent = screen
        
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

    local rarities = {"Common", "Uncommon", "Rare", "Legendary"}
    local names = {"Commons", "Uncommons", "Rares", "Legendaries"}

    for i, v in next, names do
        Smithing:AddButton({
            Name = "Dismantle All " .. v,
            Callback = function()
                local confirm = create_confirm()

                if confirm then
                    local rarity = rarities[i]
                    Dismantle_Rarity(rarity)
                end
            end
        })
    end
end

do
    local Stats = window:MakeTab({
        Name = "Session Stats",
        Icon = "",
        PremiumOnly = false
    }) 
    
    local time_label = Stats:AddLabel("Elapsed Time")
    coroutine.wrap(function()
        local floor = math.floor
        while true do task.wait(1)
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

            local displayed = ("%s %s | %s %s | %s %s | %s %s"):format(days, o1, hours, o2, minutes, o3, seconds, o4)   
            time_label:Set("Time Elapsed: " .. displayed)
        end
    end)()
    
    local item_info
    for _, v in next, getreg() do
        if typeof(v) == "table" then
            item_info = rawget(v, "GetItemData")
            if item_info then
                break
            end
        end
    end

    local upgrade_amount = {
        Legendary = 20,
        Rare = 15,
        Uncommon = 10,
        Common = 10
    }
    local database = Rs.Database
    local itemDatas = setmetatable({}, {
        __newindex = function(self, i, v)
            local item = item_info(v)
            local info = setmetatable(item, {
                __index = function(self2, i2)
                    if rawget(self2, "finding") then 
                        return 
                    end
                    self2.finding = true
                    
                    task.spawn(function()
                        local response2 = request({
                            Url = "https://www.roblox.com/library/" .. self2.icon:match("%d+"),
                            Method = "GET"
                        })
                        
                        local s = response2.Body:split("https://tr.rbxcdn.com/")
                        local more = s[2]:split("'")
                        local url = ("https://tr.rbxcdn.com/%s"):format(more[1])
                        self2[i2] = url
                    end)
                end
            })
            
            if info.Type ~= "Weapon" and info.Type ~= "Clothing" then 
                return
            end
            
            local stats = info.stats
            local base
            for _, v2 in next, stats do
                if v2[1] == "Damage" or v2[1] == "Defense" then
                    base = v2[2]
                    info.base = base
                    break
                end
            end
            
            local rarity = info.rarity
            local upgrades = upgrade_amount[rarity]
            info.potential = math.floor(base + (base * rates[rarity] * upgrades))
            rawset(self, i, info)
        end
    })
    
    for _, v in next, database.Items:GetChildren() do
        itemDatas[v.Name] = v
    end

    local profile = Rs.Profiles[plr.Name]
    local inventory = profile.Inventory

    local ignored_rarities = {}
    local webhook_toggle
    inventory.ChildAdded:Connect(function(c)
        if not webhook_toggle then 
            return 
        end

        local webhookURL = settings.WebhookURL
        if not webhookURL:find("https://discord.com/api/webhooks/") then 
            return 
        end

        local item_data = itemDatas[c.Name]
        if not item_data then
            return warn("no item data found for", c.Name)    
        end

        local item_rarity = item_data.rarity
        if ignored_rarities[item_rarity] then return end

        local item_class = item_data.Type
        local item_name = item_data.name
        local item_image = item_data.image
        while not item_image do
            item_image = item_data.image
            if item_image then 
                break
            end
            
            task.wait(1)
        end
        
        local item_potential = tostring(item_data.potential)
        local item_base = tostring(item_data.base)
        local item_level = tostring(item_data.level)
        local was_dismantled = tostring(dismantle[item_rarity])
        
        request({
            Url = webhookURL,
            Method = "POST",
            Body = HttpS:JSONEncode({
                username = "i <3 swordburst 2",
                embeds = {{
                    title = ("%s Rarity Item Drop (%s)"):format(item_rarity, item_name),
                    color = 16711680,
                    
                    fields = {{
                        name = "Item Level",
                        value = item_level
                    }, {
                        name = "Item Class",
                        value = item_class
                    }, {
                        name = "Item Base",
                        value = item_base
                    }, {
                        name = "Item Potential",
                        value = item_potential
                    }, {
                        name = "Item Was Dismantled",
                        value = was_dismantled
                    }},
                    
                    image = {
                        url = item_image
                    }
                }}
            }),
            Headers = {["Content-Type"] = "application/json"}
        })
    end)

    Stats:AddToggle({
        Name = "Webhook Toggle",
        Default = false,
        Callback = function(bool)
            webhook_toggle = bool
        end
    })

    Stats:AddTextbox({
        Name = "Item Drop Webhook URL",
        Default = settings.WebhookURL,
        TextDisappear = true,
        Callback = function(url)
            settings.WebhookURL = url:gsub(" ", "")
        end
    })
    
    local rarities = {"Common", "Uncommon", "Rare", "Legendary"}
    local names = {"Commons", "Uncommons", "Rares", "Legendaries"}
    for i, v in next, names do
        Stats:AddToggle({
            Name = "Webhook Ignore Rarity | " .. v,
            Default = false,
            Callback = function(bool)
                local rarity = rarities[i]
                ignored_rarities[rarity] = bool
            end
        })
    end
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

    local inventory_viewer = Misc_tab:AddDropdown({
        Name = "Inventory Viewer (Open Inventory)",
        Default = plr.Name,
        Options = players_names,
        Callback = function(player)
            setupvalue(inventory_module.GetInventoryData, 1, Rs.Profiles[player])
        end
    })

    local function update_inventoryViewer_list(player)  
        local names = {}

        for _, v in next, Players:GetPlayers() do
            if not player or player.Name ~= v.Name then
                table.insert(names, v.Name)
            end
        end

        inventory_viewer:Refresh(names, true)
    end
    
    Players.PlayerAdded:Connect(function(player)
        while not Rs.Profiles:FindFirstChild(player.Name) do
             task.wait(1)
        end
        
        update_inventoryViewer_list()
    end)
    
    Players.PlayerRemoving:Connect(update_inventoryViewer_list)
    
    local fps = getfpscap and getfpscap() or 60
    Misc_tab:AddSlider({
        Name = "Set FPS Cap (Requires executor FPS unlocker on)",
        Min = 0,
        Max = 500,
        Default = fps,
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

    credits:AddButton({
        Name = "Discord Server (Auto Prompt) code: eWGZ8rYpxR",
        Callback = function()
            request({
                Url = "http://127.0.0.1:6463/rpc?v=1",
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json",
                    ["Origin"] = "https://discord.com"
                },
                Body = HttpS:JSONEncode({
                    cmd = "INVITE_BROWSER",
                    args = {
                        code = "eWGZ8rYpxR"
                    },
                    nonce = HttpS:GenerateGUID()
                })
            })
        end
    })
end

lib:Init()
