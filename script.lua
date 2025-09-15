local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Window = Rayfield:CreateWindow({
    Name = "0iq's Destruction simulator GUI",
    Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
    LoadingTitle = "Destruction simulator",
    LoadingSubtitle = "by 0iq",
    ShowText = "0iq's gui", -- for mobile users to unhide rayfield, change if you'd like
    Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

    ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil, -- Create a custom folder for your hub/game
        FileName = "Big Hub"
    },

    Discord = {
        Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
        Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
        RememberJoins = true -- Set this to false to make them join the discord every time they load it up
    },

    KeySystem = false, -- Set this to true to use our key system
    KeySettings = {
        Title = "Untitled",
        Subtitle = "Key System",
        Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
        FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
        SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
        GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
        Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
    }
})

local MainTab = Window:CreateTab("Main tab", 4483362458) -- Title, Image

local Helpful = MainTab:CreateSection("Helpful functions")

local SellButton = MainTab:CreateButton({
    Name = "Sell",
    Callback = function()
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("sellBricks"):FireServer()
    end,
})

local AutoSellBool
local AutoSellToggle = MainTab:CreateToggle({
    Name = "Auto Sell",
    CurrentValue = false,
    Flag = "AutoSellToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        AutoSellBool = Value
        while AutoSellBool do
            task.wait(.2)
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("sellBricks"):FireServer()
        end
    end,
})

local GunOrBombSection = MainTab:CreateSection("Choose explode (gun works obly)")

local GunOrBomb = "Gun"
local GunOrBombDropdown = MainTab:CreateDropdown({
    Name = "Gun or Bomb",
    Options = {"Gun","Bomb"},
    CurrentOption = {"Gun"},
    MultipleOptions = false,
    Flag = "GunOrBombDropdown", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Options)
        GunOrBomb = Options[1]
    end,
})

local SelfExplodeSection = MainTab:CreateSection("Self Explode Section (gun/bomb in your hand required)")

local SelfExplodeCooldown = 500
local SelfExplodeSlider = MainTab:CreateSlider({
    Name = "Explode Cooldown",
    Range = {0, 5000},
    Increment = 10,
    Suffix = "Milliseconds",
    CurrentValue = 500,
    Flag = "SelfExplodeSlider", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        SelfExplodeCooldown = Value
    end,
})

local SelfExplodeBool = false
local SelfExplodeToggle = MainTab:CreateToggle({
    Name = "Explodes Yourself",
    CurrentValue = false,
    Flag = "SelfExplodeToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        SelfExplodeBool = Value
        while SelfExplodeBool do
            task.wait(SelfExplodeCooldown/1000)
            if GunOrBomb == "Gun" then
                local args = {
                    tick(),
                    LocalPlayer.Character:WaitForChild("Launcher"):WaitForChild("Stats"),
                    LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position,
                    LocalPlayer.Character:WaitForChild("Launcher"):WaitForChild("Assets"):WaitForChild("Rocket"):WaitForChild("Boom")
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("explodeRocket"):FireServer(unpack(args))
            else
                local args = {
                    tick(),
                    LocalPlayer.Character:WaitForChild("Bomb"):WaitForChild("Stats"),
                    LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("explodeBomb"):FireServer(unpack(args))
            end
        end
    end,
})

local CursorExplodeSection = MainTab:CreateSection("Explode Cursor Section (gun/bomb in your hand required)")

local CursorExplodeCooldown = 500
local CursorExplodeSlider = MainTab:CreateSlider({
    Name = "Explode Cooldown",
    Range = {0, 5000},
    Increment = 10,
    Suffix = "Milliseconds",
    CurrentValue = 500,
    Flag = "CursorExplodeSlider", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        CursorExplodeCooldown = Value
    end,
})

local CursorExplodeBool = false
local CursorExplodeToggle = MainTab:CreateToggle({
    Name = "Explodes Cursor (Hold E to explode cursor)",
    CurrentValue = false,
    Flag = "CursorExplodeToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        SelfExplodeBool = Value
        while SelfExplodeBool do
            task.wait(CursorExplodeCooldown/1000)
            local mousePosition = LocalPlayer:GetMouse().Hit.p
            if UserInputService:IsKeyDown(Enum.KeyCode.E) then
                if GunOrBomb == "Gun" then
                    local args = {
                        tick(),
                        LocalPlayer.Character:WaitForChild("Launcher"):WaitForChild("Stats"),
                        mousePosition,
                        LocalPlayer.Character:WaitForChild("Launcher"):WaitForChild("Assets"):WaitForChild("Rocket"):WaitForChild("Boom")
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("explodeRocket"):FireServer(unpack(args))
                else
                    local args = {
                        tick()-1,
                        game:GetService("Players").LocalPlayer.Character:WaitForChild("Bomb"):WaitForChild("Stats"),
                        vector.create(-6.669300556182861, 1.4908807277679443, -482.17095947265625)
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("explodeBomb"):FireServer(unpack(args))

                    local args = {
                        tick(),
                        LocalPlayer.Character:WaitForChild("Bomb"):WaitForChild("Stats"),
                        mousePosition
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("explodeBomb"):FireServer(unpack(args))
                end
            end
        end
    end,
})

local MiscTab = Window:CreateTab("Misc tab", 4483362458) -- Title, Image

local GetAllBoosts = MiscTab:CreateButton({
    Name = "Get All Boosts",
    Callback = function()
        local args = {
            "CoinBoost",
            86400,
            2
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("generateBoost"):FireServer(unpack(args))

        local args = {
            "SuperJump",
            86400,
            2
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("generateBoost"):FireServer(unpack(args))

        local args = {
            "ExtraSpeed",
            86400,
            2
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("generateBoost"):FireServer(unpack(args))

        local args = {
            "BrickBoost",
            86400,
            2
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("generateBoost"):FireServer(unpack(args))

        local args = {
            "XPBoost",
            86400,
            2
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("generateBoost"):FireServer(unpack(args))
    end,
})

local Get55Level = MiscTab:CreateButton({
    Name = "Get 55 Level",
    Callback = function()
        for i = 1, 3, 1 do
            local args = {
            "Levels",
            480,
            19 --max level per use
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("generateBoost"):FireServer(unpack(args))
        end
    end,
})

local Get99MCoins = MiscTab:CreateButton({
    Name = "Get 99M Coins",
    Callback = function()
        local args = {
            "Coins",
            480,
            99999999
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("generateBoost"):FireServer(unpack(args))
    end,
})

local autoMoneyGen = false
local autoMoneyGenToggle = MiscTab:CreateToggle({
    Name = "Auto Money Generation",
    CurrentValue = false,
    Flag = "autoMoneyGenToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        autoMoneyGen = Value
        while autoMoneyGen do
            task.wait(.01)
            local args = {
                "Coins",
                480,
                99999999
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("generateBoost"):FireServer(unpack(args))
        end
    end,
})

local PlayerTab = Window:CreateTab("Player tab", 4483362458) -- Title, Image

local SpeedSlider = PlayerTab:CreateSlider({
    Name = "Player Speed ",
    Range = {0, 200},
    Increment = 1,
    Suffix = "Bananas",
    CurrentValue = 16,
    Flag = "SpeedSlider", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = Value
    end,
})

local JumpSlider = PlayerTab:CreateSlider({
    Name = "Jump Power",
    Range = {0, 200},
    Increment = 1,
    Suffix = "Bananas",
    CurrentValue = 50,
    Flag = "JumpSlider", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        LocalPlayer.Character:WaitForChild("Humanoid").JumpPower = Value
        LocalPlayer.Character:WaitForChild("Humanoid").UseJumpPower = true
    end,
})

local FunTab = Window:CreateTab("Fun tab", 4483362458) -- Title, Image

local EveryoneExplodeSection = MainTab:CreateSection("Everyone Explode Section (gun/bomb in your hand required)")

local EveryoneExplodeCooldown = 500
local EveryoneExplodeSlider = MainTab:CreateSlider({
    Name = "Explode Cooldown",
    Range = {0, 5000},
    Increment = 10,
    Suffix = "Milliseconds",
    CurrentValue = 500,
    Flag = "EveryoneExplodeSlider", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        EveryoneExplodeCooldown = Value
    end,
})

local EveryoneExplodeBool = false
local EveryoneExplodeToggle = FunTab:CreateToggle({
    Name = "Explodes Everyone",
    CurrentValue = false,
    Flag = "EveryoneExplodeToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        EveryoneExplodeBool = Value
        while EveryoneExplodeBool do
            task.wait(EveryoneExplodeCooldown/1000)
            for _, player in ipairs(Players:GetChildren()) do
                task.wait()
                if player.Name ~= LocalPlayer.Name then
                    if GunOrBomb == "Gun" then
                        local args = {
                            tick(),
                            LocalPlayer.Character:WaitForChild("Launcher"):WaitForChild("Stats"),
                            player.Character:WaitForChild("HumanoidRootPart").Position,
                            LocalPlayer.Character:WaitForChild("Launcher"):WaitForChild("Assets"):WaitForChild("Rocket"):WaitForChild("Boom")
                        }
                        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("explodeRocket"):FireServer(unpack(args))
                    else
                        local args = {
                            tick(),
                            LocalPlayer.Character:WaitForChild("Bomb"):WaitForChild("Stats"),
                            player.Character:WaitForChild("HumanoidRootPart").Position
                        }
                        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("explodeBomb"):FireServer(unpack(args))
                    end
                end
            end
        end
    end,
})
