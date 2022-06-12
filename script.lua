-- for me: loadfile('Scriptz/sb2 script.lua')()

-- add keybinds to some stuff

-- add more stat tracking 

-- insta max selected items / equipped gear

if not game:IsLoaded() then game.Loaded:Wait() end

if syn then -- synapse
    syn.queue_on_teleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/noobscripter38493/Swordburst-2/main/script.lua'))()")
    
elseif queue_on_teleport then -- krnl
    queue_on_teleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/noobscripter38493/Swordburst-2/main/script.lua'))()") 
    
else
    warn"failed to find execute on teleport function"
end

local mobs_on_floor = {
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
        --"Elite Reaper (not in game)",
        --"DJ Reaper (not in game)",
        "Soul Eater",
        "Shadow Figure",
        --"Meta Figure (not in game)",
        "???????",
        --"Rogue Android (not in game)",
        "Command Falcon",
        --"Armageddon Eagle (not in game)",
        --"Sentry (not in game)",
        --"Watcher (not in game)",
        --"Cybold (not in game)"
    }
}

local bosses_on_floor = {
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
        "Baal, The Tormentor",
        "Grim the Overseer"
    },

    [5287433115] = { -- floor 11
        "Da",
        "Ra",
        "Ka",
        --"Za (not in game)",
        --"Duality Reaper (not in game)",
        --"Saurus, the All-Seeing (not in game)"
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

function find(t, element)
    for _, v in next, t do
        if v.Name == element then
            return v
        end
    end
    
    return nil
end

local plr = Players.LocalPlayer

for _, v in next, getconnections(plr.Idled) do
    v:Disable() 
end

getgenv().char = plr.Character or plr.CharacterAdded:Wait()
getgenv().hrp = char:WaitForChild("HumanoidRootPart")
getgenv().humanoid = char:WaitForChild("Humanoid")

repeat wait() until getrenv()._G.CalculateCombatStyle

getgenv().settings = {
    Autofarm = false,
    Autofarm_Y_Offset = 10,
    Tween_Speed = 70,
    Farm_Only_Bosses = false,
    Boss_Priority = false,
    __IndexBypass = humanoid.WalkSpeed,
    Prioritized_Boss = nil,
    Mob_Priority = false,
    Prioritized_Mob = nil,
    KA = false,
    KA_Range = 20,
    WalkSpeed = humanoid.WalkSpeed,
    speed = false,
    InfSprint = false,
    AttackPlayers = false,
    Animation = getrenv()._G.CalculateCombatStyle()
}

-- disable M1s when killaura is enabled // read wally's funky friday source and innovated
local setThreadIdentity = (syn and syn.set_thread_identity) or setthreadcontext 
local getThreadIdentity = (syn and syn.get_thread_identity) or getthreadidentity

local oldIndentity = getThreadIdentity()

setThreadIdentity(2) -- can't get inputbegan or inputended without setting the thread identity to 2 (roblox's identity) -> printidentity()

for _, v in next, getconnections(UserInputS.InputBegan) do
    local func = v.Function
    
    if func then
        local info = getinfo(func)
        
        if info.source:find("Services.Input") then
            local noMouseClick; noMouseClick = hookfunction(func, function(user_input, game_processed)
                if user_input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if settings.KA then
                        return 
                    end
                end
                
                return noMouseClick(user_input, game_processed)
            end)
        end
    end
end 

setThreadIdentity(oldIndentity)
--

plr.CharacterAdded:Connect(function(new)
    char = new
    hrp = char:WaitForChild("HumanoidRootPart")
    humanoid = char:WaitForChild("Humanoid")
end)

getgenv().game_module = nil
while true do
    for _, v in next, getnilinstances() do
        if v.Name == "MainModule" then
            game_module = v
        end
    end 

    wait(.5)
    
    if game_module then break end
end

local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

local window = lib:MakeWindow({
    Name = "SB2 Script | Made By avg#1496",
    HidePremium = false,
    SaveConfig = false,
    ConfigFolder = false
})

do
    local farm_tab = window:MakeTab({
        Name = "Farm",
        Icon = "",
        PremiumOnly = false
    })
    
    farm_tab:AddParagraph("Warning", "Toggle Invisibility in Character Tab")
    
    local mobs_table = {}
    
    local tween_create
    function tween(to)
        local t = (hrp.Position - to.Position).Magnitude / settings.Tween_Speed -- time = distance / speed
        
        local tween_info = TweenInfo.new(t, Enum.EasingStyle.Linear)
        local cframe = to.CFrame * CFrame.new(0, settings.Autofarm_Y_Offset, 0)
        tween_create = TweenS:Create(hrp, tween_info, {CFrame = cframe})
        
        tween_create:Play()
        tween_create.Completed:Wait()
        
        if not settings.Autofarm then return end
       
        -- prioritize bosses -> teleport to boss room

        local enemy = to.Parent
        local _, err = pcall(function()
            if enemy.Entity.Health.Value <= 0 then error't' end -- dont attack dead mobs // errors if enemy is nil and also errors if the check passes
        end)

        if not err then
            tween(to)
            return
        end
        
        local i = table.find(mobs_table, to.Parent)
        
        if i then
            table.remove(mobs_table, i) -- :thumbs:
        end
    end

    local mobs = workspace.Mobs

    mobs.ChildAdded:Connect(function(mob)
        mob:WaitForChild("HumanoidRootPart")
        
        table.insert(mobs_table, mob)
    end)
    
    mobs.ChildRemoved:Connect(function(mob)
        local i = table.find(mobs_table, mob)
        
        if i then
            table.remove(mobs_table, i)
        end
    end)
    
    for _, v in next, mobs:GetChildren() do
        local tween_to = v:FindFirstChild("HumanoidRootPart")
        
        if tween_to and v:FindFirstChild("Healthbar") then
            table.insert(mobs_table, v)
        end
    end

    RunS.RenderStepped:Connect(function()
        if settings.Autofarm then
            hrp.Velocity = Vector3.new(0, 0, 0) -- smooth tween
        end
    end)

    farm_tab:AddToggle({
        Name = "Autofarm (Ban Risk)",
        Default = false,
        Callback = function(bool)
            settings.Autofarm = bool

            while settings.Autofarm do wait()
                if settings.Boss_Priority and settings.Prioritized_Boss ~= nil then
                    local boss = find(mobs_table, settings.Prioritized_Boss)

                    if boss then
                        local _, err = pcall(function()
                            if boss.Entity.Health.Value <= 0 then error't' end -- dont attack dead mobs // errors if enemy is nil and also errors if the check passes
                        end)
                        
                        if err then continue end
                        
                        local boss_hrp = boss:FindFirstChild("HumanoidRootPart")
                        
                        if boss_hrp then
                            local tween_to = boss_hrp
                            
                            tween(tween_to)
                            
                            continue
                        end
                    end
                end

                if settings.Farm_Only_Bosses then
                    for _, v in next, mobs_table do
                        if find(mobs_table, settings.Prioritized_Boss) or not settings.Autofarm then
                            break

                        else
                            local mob_hrp = v:FindFirstChild("HumanoidRootPart")

                            if mob_hrp then
                                local _, err = pcall(function()
                                    if v.Entity.Health.Value <= 0 then error't' end -- dont attack dead mobs // errors if enemy is nil and also errors if the check passes
                                end)

                                if err then continue end

                                local tween_to = mob_hrp

                                tween(tween_to)
                            end
                        end
                    end

                    continue
                end

                if settings.Mob_Priority and settings.Prioritized_Mob ~= nil then
                    local mob = find(mobs_table, settings.Prioritized_Mob)
            
                    if mob then
                        local _, err = pcall(function()
                            if mob.Entity.Health.Value <= 0 then error't' end -- dont attack dead mobs // errors if enemy is nil and also errors if the check passes
                        end)
                        
                        if err then continue end
                        
                        local mob_hrp = mob:FindFirstChild("HumanoidRootPart")
                        
                        if mob_hrp then
                            local tween_to = mob_hrp
                            
                            tween(tween_to)
                            
                            continue
                        end
                    end
                end
                
                local tween_to = mobs_table[1]:FindFirstChild("HumanoidRootPart")
                
                if tween_to then
                    tween(tween_to)
                end
            end
            
            if tween_create then
                tween_create:Cancel()
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

    local range = Instance.new("Part")
    range.Size = Vector3.new(25, 25, 25)
    range.CanCollide = false
    range.Transparency = 1

    RunS.RenderStepped:Connect(function()
        range.CFrame = game.Players.LocalPlayer.Character:GetPivot()
    end)
    
    


    range.Parent = workspace

    local combat = require(game_module.Services.Combat)
    local remote_key = getupvalue(combat.Init, 2)
    local Event = Rs.Event

    local ka
    farm_tab:AddToggle({
        Name = "Kill Aura (Improved)", -- now attacks multiple enemies at the same time
        Default = false,
        Callback = function(bool)
            settings.KA = bool

            local attacking = {} -- to overwrite attacking table when toggled off
            if bool then
                ka = range.Touched:Connect(function(touching)  
                    if touching:FindFirstAncestor("Mobs") and touching.Name == "HumanoidRootPart" then
                        local enemy = touching.Parent   
                        
                        if not table.find(attacking, enemy) then 
                            table.insert(attacking, enemy)
                            -- should make a killaura function but i am lazy
                            while true do 
                                local i = table.find(attacking, enemy) -- update the position of the element enemy constantly
                                
                                local _, err = pcall(function()
                                    if enemy.Entity.Health.Value <= 0 then error't' end -- dont attack dead mobs // errors if enemy is nil and also errors if the check passes
                                end)
                    
                                if err or enemy:FindFirstChild("Immortal") or (hrp.Position - touching.Position).Magnitude > settings.KA_Range then
                                    table.remove(attacking, i) -- if an enemy walks away but is still alive or it's dead or immortal
                                    
                                    break 
                                end
                                
                                Event:FireServer("Combat", remote_key, {"Attack", nil, "1", enemy}) -- nil = skill (i think)
                                
                                wait(.3) 
                            end
                        end
        
                    elseif settings.AttackPlayers and touching.Parent ~= char and touching.Name == "HumanoidRootPart" then
                        local enemy = touching.Parent   
                        
                        if not table.find(attacking, enemy) then 
                            table.insert(attacking, enemy)

                            while true do 
                                local i = table.find(attacking, enemy) -- update the position of the element enemy constantly
                                
                                local _, err = pcall(function()
                                    if enemy.Entity.Health.Value <= 0 then error't' end -- dont attack dead mobs // errors if enemy is nil and also errors if the check passes
                                end)
                    
                                if not settings.AttackPlayers or err or enemy:FindFirstChild("Immortal") or (hrp.Position - touching.Position).Magnitude > settings.KA_Range then
                                    table.remove(attacking, i) -- if an enemy walks away but is still alive or it's dead or immortal
                                    
                                    break 
                                end
                                
                                Event:FireServer("Combat", remote_key, {"Attack", nil, "1", enemy}) -- nil = skill (i think)
                                
                                wait(.3) 
                            end
                        end
                    end
                end) 

            elseif ka then
                ka:Disconnect()
            end
        end
    })

    farm_tab:AddToggle({
        Name = "Attack Players",
        Default = false,
        Callback = function(bool)
            settings.AttackPlayers = bool
        end
    })
    
    farm_tab:AddSlider({
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
end

do 
    local no_tp = {542351431, 582198062}

    if table.find(no_tp, placeid) then
        lib:MakeNotification({
            Name = "Can't TP",
            Content = "Can't TP. Teleport Not Supported On This Floor (f1 or f7)", --[[
                these 2 floors have a lower streaming radius, (meaning parts dont spawn until u approach them) and it's not an editable property
                
                (https://developer.roblox.com/en-us/api-reference/property/Workspace/StreamingMinRadius)
                ]]
            Image = "",
            Time = 10
        }) 
    else
        local teleports_tab = window:MakeTab({
            Name = 'Teleports',
            Icon = '',
            PremiumOnly = false
        })

        local useless = 0
        -- (garbage code)
        for _, v in next, workspace:GetChildren() do
            if v.Name == "TeleportSystem" then
                if placeid == 548231754 then -- floor 2 
                    for _2, v2 in next, v:GetChildren() do
                        local touching_parts = v2:GetTouchingParts()
                        
                        if #touching_parts == 6 then
                            teleports_tab:AddButton({
                                Name = "Boss Room",
                                Callback = function()
                                    firetouchinterest(hrp, v2, 0)
                    
                                    wait(.5)
                                    
                                    firetouchinterest(hrp, v2, 1)
                                end
                            })
                        
                        elseif touching_parts[1]:IsA("Terrain") then
                            teleports_tab:AddButton({
                                Name = "Dungeon Entrance",
                                Callback = function()
                                    firetouchinterest(hrp, v2, 0)
                    
                                    wait(.5)
                                    
                                    firetouchinterest(hrp, v2, 1)
                                end
                            })
                        end
                    end
                end
                
                if placeid == 555980327 then -- floor 3
                    for _2, v2 in next, v:GetChildren() do
                        teleports_tab:AddButton({
                            Name = "Dungeon Entrance",
                            Callback = function()
                                firetouchinterest(hrp, v2, 0)
                
                                wait(.5)
                                
                                firetouchinterest(hrp, v2, 1)
                            end
                        })
                    end
                end
                
                if placeid == 572487908 then -- floor 4
                    for _2, v2 in next, v:GetChildren() do
                        local touching_parts = v2:GetTouchingParts()
                        
                        table.foreach(touching_parts, function(i, v)
                            if v:IsA("Terrain") then
                                teleports_tab:AddButton({
                                    Name = "Dungeon Entrance",
                                    Callback = function()
                                        firetouchinterest(hrp, v2, 0)
                        
                                        wait(.5)
                                        
                                        firetouchinterest(hrp, v2, 1)
                                    end
                                })
                                
                            elseif i == 4 and v.Name == "Part" and #touching_parts == 4 then
                                teleports_tab:AddButton({
                                    Name = "Boss Room",
                                    Callback = function()
                                        firetouchinterest(hrp, v2, 0)
                        
                                        wait(.5)
                                        
                                        firetouchinterest(hrp, v2, 1)
                                    end
                                })
                            end
                        end)
                    end
                end
                
                if placeid == 580239979 then -- floor 5
                    for _2, v2 in next, v:GetChildren() do
                        local touching_parts = v2:GetTouchingParts()
                        
                        table.foreach(touching_parts, function(i, v)
                            if v:IsA("Terrain") then
                                teleports_tab:AddButton({
                                    Name = "Dungeon Entrance",
                                    Callback = function()
                                        firetouchinterest(hrp, v2, 0)
                        
                                        wait(.5)
                                        
                                        firetouchinterest(hrp, v2, 1)
                                    end
                                })
                            
                            elseif v.Parent ~= workspace and v.Parent.Parent.Parent == workspace then -- lol
                                teleports_tab:AddButton({
                                    Name = "Boss Room",
                                    Callback = function()
                                        firetouchinterest(hrp, v2, 0)
                        
                                        wait(.5)
                                        
                                        firetouchinterest(hrp, v2, 1)
                                    end
                                })
                            end
                        end)
                    end
                end
                
                if placeid == 548878321 then -- floor 8
                    for _2, v2 in next, v:GetChildren() do
                        local touching_parts = v2:GetTouchingParts()
                        
                        if #touching_parts == 3 and touching_parts[1]:IsA("Part") then
                            teleports_tab:AddButton({
                                Name = "Boss Room",
                                Callback = function()
                                    firetouchinterest(hrp, v2, 0)
                    
                                    wait(.5)
                                    
                                    firetouchinterest(hrp, v2, 1)
                                end
                            })
                        
                        elseif #touching_parts == 2 then
                            teleports_tab:AddButton({
                                Name = "Mini Boss",
                                Callback = function()
                                    firetouchinterest(hrp, v2, 0)
                    
                                    wait(.5)
                                    
                                    firetouchinterest(hrp, v2, 1)
                                end
                            })
                        
                        elseif #touching_parts == 3 and touching_parts[1]:IsA("Terrain") then
                            teleports_tab:AddButton({
                                Name = "Dungeon Entrance",
                                Callback = function()
                                    firetouchinterest(hrp, v2, 0)
                    
                                    wait(.5)
                                    
                                    firetouchinterest(hrp, v2, 1)
                                end
                            })
                        end
                    end
                end
                
                if placeid == 573267292 then -- floor 9
                    for _2, v2 in next, v:GetChildren() do
                        local touching_parts = v2:GetTouchingParts()
                        
                        if #touching_parts == 7 and find(touching_parts, "Path") then
                            teleports_tab:AddButton({
                                Name = "Dungeon Entrance",
                                Callback = function()
                                    firetouchinterest(hrp, v2, 0)
                    
                                    wait(.5)
                                    
                                    firetouchinterest(hrp, v2, 1)
                                end
                            })
                        
                        elseif #touching_parts == 6 then
                            teleports_tab:AddButton({
                                Name = "Polyserpant Mini Boss",
                                Callback = function()
                                    firetouchinterest(hrp, v2, 0)
                    
                                    wait(.5)
                                    
                                    firetouchinterest(hrp, v2, 1)
                                end
                            })
                        
                        elseif #touching_parts == 8 and find(touching_parts, "ash") then
                            teleports_tab:AddButton({
                                Name = "Gargoyle Reaper Mini Boss",
                                Callback = function()
                                    firetouchinterest(hrp, v2, 0)
                    
                                    wait(.5)
                                    
                                    firetouchinterest(hrp, v2, 1)
                                end
                            })
                        
                        elseif #touching_parts == 5 then
                            teleports_tab:AddButton({
                                Name = "Main Boss",
                                Callback = function()
                                    firetouchinterest(hrp, v2, 0)
                    
                                    wait(.5)
                                    
                                    firetouchinterest(hrp, v2, 1)
                                end
                            })
                        end
                    end
                end
                
                if placeid == 2659143505 then -- floor 10
                    for _2, v2 in next, v:GetChildren() do
                        local touching_parts = v2:GetTouchingParts()
                        if #touching_parts == 2 then
                            teleports_tab:AddButton({
                                Name = "Main Boss",
                                Callback = function()
                                    firetouchinterest(hrp, v2, 0)
                    
                                    wait(.5)
                                    
                                    firetouchinterest(hrp, v2, 1)
                                end
                            })
                        
                        elseif #touching_parts == 14 then
                            teleports_tab:AddButton({
                                Name = "Dungeon Entrance",
                                Callback = function()
                                    firetouchinterest(hrp, v2, 0)
                    
                                    wait(.5)
                                    
                                    firetouchinterest(hrp, v2, 1)
                                end
                            })
                            
                        elseif #touching_parts == 17 then
                            teleports_tab:AddButton({
                                Name = "Shop",
                                Callback = function()
                                    firetouchinterest(hrp, v2, 0)
                    
                                    wait(.5)
                                    
                                    firetouchinterest(hrp, v2, 1)
                                end
                            })    
                        
                        elseif #touching_parts == 8 and find(touching_parts, "Wedge") then
                            teleports_tab:AddButton({
                                Name = "Mini Boss",
                                Callback = function()
                                    firetouchinterest(hrp, v2, 0)
                    
                                    wait(.5)
                                    
                                    firetouchinterest(hrp, v2, 1)
                                end
                            })    
                            
                        end
                    end
                end
                
                if placeid == 5287433115 then -- floor 11
                    for _2, v2 in next, v:GetChildren() do
                        local touching_parts = v2:GetTouchingParts()
                        
                        if #touching_parts == 13 and not find(touching_parts, "MeshPart") then
                            teleports_tab:AddButton({
                                Name = "Mini Boss",
                                Callback = function()
                                    firetouchinterest(hrp, v2, 0)
                    
                                    wait(.5)
                                    
                                    firetouchinterest(hrp, v2, 1)
                                end
                            })   
                        
                        else
                            useless = useless + 1
                            teleports_tab:AddButton({
                                Name = "Useless Teleport #" .. useless,
                                Callback = function()
                                    firetouchinterest(hrp, v2, 0)
                    
                                    wait(.5)
                                    
                                    firetouchinterest(hrp, v2, 1)
                                end
                            })  
                        end
                    end
                end
            end
        end
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
    for _, v in next, animations:GetChildren() do
        if v.Name ~= "Misc" and v.Name ~= "Spear" and v.Name ~= "Daggers" and v.Name ~= "Dagger" and v.Name ~= "SwordShield" then
            table.insert(ANIMATIONS, v.Name)
            
            if not animSettings:FindFirstChild(v.Name) then
                local string_value = Instance.new("StringValue", animSettings)
                
                string_value.Name = v.Name
                string_value.Value = ""
            end
        end
    end 

    Character_tab:AddDropdown({
        Name = "Weapon Animations (Breaks Skills For Now)", -- should probably just load my own animation tracks and stop theirs
        Default = settings.Animation,
        Options = ANIMATIONS,
        Callback = function(animation)
            settings.Weapon_Animation = animation
        end
    })

    local combat = require(game_module.Services.Combat)
    
    hookfunction(combat.CalculateCombatStyle, function()
        return settings.Weapon_Animation  -- the game uses this function for both animations & skills so it breaks skills
    end)

    local animate_senv = getsenv(char:FindFirstChild("Animate"))
    local playTrack = animate_senv.PlayTrack

    local tracks = getupvalue(playTrack, 1)

    local Normal_Animations = {}
    for i, _ in next, tracks do
        table.insert(Normal_Animations, i)
    end

    Character_tab:AddDropdown({
        Name = "Normal Animations (Scuffed.......)", -- honestly, don't know why it's so scuffed
        Default = settings.Animation,
        Options = Normal_Animations,
        Callback = function(animation)
            setupvalue(playTrack, 2, animation)
        end
    })

    local invisibility
    Character_tab:AddToggle({
        Name = "Invisibility (Client Sided Character)", 
        Default = false, 
        Callback = function(bool)
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
        end
    })

    local Event = Rs.Event
    local infSprint; infSprint = hookmetamethod(game, "__namecall", function(self, ...)
        local ncm = getnamecallmethod()
        local args = {...}
        
        if settings.InfSprint and ncm == "FireServer"  then
            if self == Event then
                if rawget(args, 1) == "Actions" then
                    if rawget(args[2], 2) == "Step" then
                        return -- void
                    end
                end
            end
        end

        return infSprint(self, ...)
    end)

    Character_tab:AddToggle({
        Name = "Infinite Sprint",
        Default = false,
        Callback = function(bool)
            settings.InfSprint = bool
        end
    })
    
    -- doesnt work if walkspeed is checked on the server
    -- wave goodbye to humanoid.Walkspeed = x. if humanoid.WalkSpeed ~= x __index detection. (sb2 doesnt have it tho)
    local newindex; newindex = hookmetamethod(game, "__newindex", function(self, i, v)
        if self == humanoid and i == "WalkSpeed" and not checkcaller() then
            settings.__IndexBypass = v
        end

        return newindex(self, i, v)
    end)
    
    local index_WS; index_WS = hookmetamethod(game, "__index", function(self, i)
        if settings.speed then
            if self == humanoid and i == "WalkSpeed" then
                return settings.__IndexBypass
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

    Character_tab:AddToggle({
        Name = "WalkSpeed Toggle",
        Default = false,
        Callback = function(bool)
            settings.speed = bool
            
            if bool then
                humanoid.WalkSpeed = settings.WalkSpeed 
            else
                humanoid.WalkSpeed = oldWS
            end
        end
    })

    Character_tab:AddSlider({
        Name = "WalkSpeed",
        Min = 0,
        Max = 50,
        Default = oldWS,
        Color = Color3.new(255, 255, 255),
        Increment = 1,
        ValueName = "Speed",
        Callback = function(speed)
            settings.WalkSpeed = speed

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

    local ui_module = game_module.Services.UI

    local upgrade_module = require(ui_module.Upgrade)
    Smithing:AddButton({
        Name = "Open Upgrader",
        Callback = function()
            upgrade_module.Open()
        end
    })

    local dismantler_module = require(ui_module.Dismantle)
    Smithing:AddButton({
        Name = "Open Dismantler",
        Callback = function()
            dismantler_module.Open()
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
    
    function round(num) -- dev forum
        return math.floor(num + 0.5)
    end
    
    coroutine.wrap(function()
        local seconds = 0
        local minutes = 0
        local hours = 0
        local days = 0
        
        while true do wait(1) -- what r string patterns (for real) // catastrophic code
            seconds = round(time())
            minutes = round(seconds / 60)
            hours = round(minutes / 60)
            days = round(hours / 24)
            
            -- hope no one plays longer than 24 hours or else this will break ...
            local displayed = days .. " Days | " .. hours .. " Hours | " .. "%M" .. " Minutes | " .. "%S" .. " Seconds"
            
            local formatted = os.date(displayed, seconds)
    
            time_label:Set("Time Elapsed: " .. formatted)
        end
    end)()
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
        repeat wait() until Rs.Profiles:FindFirstChild(player.Name) ~= nil
        
        refresh_inventoryViewer_list(inventory_viewer)
    end)
    
    Players.PlayerRemoving:Connect(function()
        refresh_inventoryViewer_list(inventory_viewer)
    end)
    
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
    
    local orion = CoreGui.Orion
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
    
    updates:AddParagraph("6/12/22", "Made Autofarm Tweening Smooth (asf)")
    updates:AddParagraph("6/12/22", "Made WalkSpeed less detectable (wasn't detected tho)")
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

    credits:AddParagraph("Credits", "Made by avg#1496 | DM Bugs")

    if setclipboard then
        credits:AddButton({
            Name = "Copy Discord To Clipboard",
            Callback = function()
                setclipboard("avg#1496") 
            end
        })
    else
        credits:AddParagraph("error", "no setclipboard function")
    end
end

lib:Init()
