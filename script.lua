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

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunS = game:GetService("RunService")
local Rs = game:GetService("ReplicatedStorage")

getgenv().getupvalue = debug.getupvalue -- not sure if other exploits that aren't synapse have an alias so this is for that i guess
getgenv().setupvalue = debug.setupvalue

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

repeat wait() until getrenv()._G.CalculateCombatStyle

getgenv().settings = {
    KA = false,
    KA_Range = 20,
    WalkSpeed = humanoid.WalkSpeed,
    speed = false,
    InfSprint = false,
    AttackPlayers = false,
    Animation = getrenv()._G.CalculateCombatStyle()
}

-- disable M1s when killaura is enabled // read wally's funky friday source and innovated
local setThreadIdentity = syn.set_thread_identity
local getThreadIdentity = syn.get_thread_identity

local oldIndentity = getThreadIdentity()

setThreadIdentity(2) -- can't get inputbegan or inputended without setting the thread identity to 2 (roblox's identity) -> printidentity()

for _, v in next, getconnections(game.UserInputService.InputBegan) do
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

local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

local window = lib:MakeWindow({
    Name = "SB2 Script",
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

    local range = Instance.new("Part", workspace)
    range.Size = Vector3.new(25, 25, 25)
    range.CanCollide = false
    range.Transparency = 1

    RunS.RenderStepped:Connect(function()
        range.CFrame = game.Players.LocalPlayer.Character:GetPivot()
    end)

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
                            coroutine.wrap(function()
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
                            end)()
                        end
        
                    elseif settings.AttackPlayers and touching.Parent ~= char and touching.Name == "HumanoidRootPart" then
                        local enemy = touching.Parent   
                        
                        if not table.find(attacking, enemy) then 
                            table.insert(attacking, enemy)

                            coroutine.wrap(function()
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
                            end)()
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
    local teleports_tab = window:MakeTab({
        Name = "Teleports",
        Icon = "",
        PremiumOnly = false
    })
    local no_tp = {542351431, 582198062}

    for _, v in next, workspace:GetChildren() do
        if table.find(no_tp, place_id) then
            lib:MakeNotification({
                Name = "Can't TP",
                Content = "Can't TP. Teleport Not Supported On This Floor (f1 or f7)", --[[
                    these 2 floors have a lower streaming radius, (meaning parts dont spawn until u approach them) and it's not an editable property
                    
                    (https://developer.roblox.com/en-us/api-reference/property/Workspace/StreamingMinRadius)
                    ]]
                Image = "",
                Time = 10
            }) 

            break
        end

        if v.Name == "TeleportSystem" then
            for _, v2 in next, v:GetChildren() do
                teleports_tab:AddButton({
                    Name = "probably boss room", 
                    Callback = function() -- eventually make these show proper names (tower door seems possible)
                        firetouchinterest(hrp, v2, 0)
        
                        wait(.5)
                        
                        firetouchinterest(hrp, v2, 1)
                    end
                })
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
        
        if settings.InfSprint then
            if self == Event and ncm == "FireServer" then
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

    function refresh_inventoryViewer_list(dp) 
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
