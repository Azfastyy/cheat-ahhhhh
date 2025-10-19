-- Luxen - Emergency Hamburg Menu
-- Avec Key System integre

local apiUrl = "https://luxen-roblox-api.vercel.app"

-- Fonction pour obtenir le HWID
local function getHWID()
    local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
    return hwid
end

-- Fonction pour verifier la cle
local function checkKey(key)
    local hwid = getHWID()
    local HttpService = game:GetService("HttpService")
    
    local success, response = pcall(function()
        return request({
            Url = apiUrl .. "/api/check-key",
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode({
                key = key,
                hwid = hwid
            })
        })
    end)
    
    if success and response then
        if response.StatusCode == 200 then
            local data = HttpService:JSONDecode(response.Body)
            return data.success, data.message or data.error
        else
            local data = HttpService:JSONDecode(response.Body)
            return false, data.error or "Erreur serveur"
        end
    else
        return false, "Erreur de connexion a l'API"
    end
end

-- Orion Library pour le Key System
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/weakhoes/Roblox-UI-Libs/refs/heads/main/Orion%20Lib/Orion%20Lib%20Source.lua')))()

local keyEntered = false
local keyInput = ""

-- Creation de la fenetre du Key System
local KeyWindow = OrionLib:MakeWindow({
    Name = "Luxen - Key System",
    HidePremium = true,
    SaveConfig = false,
    IntroEnabled = true,
    IntroText = "Luxen Menu",
    IntroIcon = "rbxassetid://4483345998"
})

OrionLib:MakeNotification({
    Name = "Welcome on Luxen!",
    Content = "Please enter ur key",
    Image = "rbxassetid://4483345998",
    Time = 5
})

-- Onglet Key System
local KeyTab = KeyWindow:MakeTab({
    Name = "Key System",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local KeySection = KeyTab:AddSection({
    Name = "Auth"
})

KeySection:AddTextbox({
    Name = "Enter ur key",
    Default = "",
    TextDisappear = true,
    Callback = function(Value)
        keyInput = Value
    end
})

KeySection:AddButton({
    Name = "Check",
    Callback = function()
        if keyInput == "" then
            OrionLib:MakeNotification({
                Name = "Error !",
                Content = "Please enter a key",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
            return
        end
        
        OrionLib:MakeNotification({
            Name = "Checking...",
            Content = "Checking the key...",
            Image = "rbxassetid://4483345998",
            Time = 2
        })
        
        local success, message = checkKey(keyInput)
        
        if success then
            keyEntered = true
            OrionLib:MakeNotification({
                Name = "Succes !",
                Content = "Key is valid ! Luxen is loading...",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
            wait(1)
            OrionLib:Destroy()
            
            -- Charger le menu principal
            loadMainMenu()
        else
            OrionLib:MakeNotification({
                Name = "Error !",
                Content = message,
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        end
    end
})

--KeySection:AddParagraph("Information", "Enter a key for ")

-- Onglet Obtenir une cle
local GetKeyTab = KeyWindow:MakeTab({
    Name = "Get a key",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local GetKeySection = GetKeyTab:AddSection({
    Name = "How to get a key"
})

GetKeySection:AddParagraph("Discord", "Join our discord")

GetKeySection:AddButton({
    Name = "Copy Discord",
    Callback = function()
        setclipboard("discord.gg/luxen")
        OrionLib:MakeNotification({
            Name = "Copied !",
            Content = "The link is copied",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
})

GetKeySection:AddParagraph("HWID", "Your HWID: " .. getHWID())

GetKeySection:AddButton({
    Name = "Copy HWID",
    Callback = function()
        setclipboard(getHWID())
        OrionLib:MakeNotification({
            Name = "Copied !",
            Content = "The HWID is copied",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
})

-- Onglet Parametres
local SettingsTab = KeyWindow:MakeTab({
    Name = "Settings",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local SettingsSection = SettingsTab:AddSection({
    Name = "Options"
})

SettingsSection:AddButton({
    Name = "Close",
    Callback = function()
        OrionLib:MakeNotification({
            Name = "Bye bye",
            Content = "Luxen closing...",
            Image = "rbxassetid://4483345998",
            Time = 2
        })
        wait(2)
        OrionLib:Destroy()
    end
})

-- Test de connexion API au demarrage
spawn(function()
    wait(2)
    local testSuccess, testMessage = checkKey("TEST123")
    if not testSuccess and testMessage == "Erreur de connexion a l'API" then
        OrionLib:MakeNotification({
            Name = "Avertissement",
            Content = "Impossible de contacter l'API. Verifiez votre connexion.",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    end
end)

OrionLib:Init()

-- FONCTION POUR CHARGER LE MENU PRINCIPAL


local gameScripts = {
    [109983668079237] = "https://raw.githubusercontent.com/Azfastyy/SAB-MENU-LUXEN-ROBLOX/refs/heads/main/main.lua", -- STEAL A BRAINROT
    [126884695634066] = "https://raw.githubusercontent.com/Azfastyy/GAG-CHEAT-LUXEN/refs/heads/main/main.lua", -- GROW A GARDEN
    [7711635737]      = "https://raw.githubusercontent.com/Azfastyy/EH-CHEAT-LUXEN/refs/heads/main/main.lua", -- EMERGENCY HAMBURG
    [79546208627805]  = "https://raw.githubusercontent.com/Azfastyy/99nights-CHEAT-LUXEN/refs/heads/main/main.lua", -- 99 NIGHTS
    [2753915549]      = "https://raw.githubusercontent.com/Azfastyy/BF-CHEAT-LUXEN/refs/heads/main/main.lua", -- BLOX FRUITS
}

-- Fonction pour charger le script du jeu correspondant
local function loadMainMenu()
    local placeId = game.PlaceId
    local scriptUrl = gameScripts[placeId]

    if scriptUrl then
        -- Fermer Orion
        pcall(function() OrionLib:Destroy() end)
        
        -- Charger le script distant
        local ok, err = pcall(function()
            local source = game:HttpGet(scriptUrl)
            local fn = loadstring(source)
            if type(fn) == "function" then
                fn()
            else
                error("loadstring returned non-function")
            end
        end)

        if not ok then
            -- Notification d'erreur
            OrionLib:MakeNotification({
                Name = "Error",
                Content = "Failed to load the script: "..tostring(err),
                Image = "rbxassetid://4483345998",
                Time = 6
            })
            warn("Failed to load script:", err)
        end
    else
        -- Jeu non supporté, notification
        OrionLib:MakeNotification({
            Name = "Unsupported Game",
            Content = "This game is not supported!",
            Image = "rbxassetid://4483345998",
            Time = 6
        })
    end
end



function loadScriptMenu()
    local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
    
    local Window = Rayfield:CreateWindow({
        Name = "Luxen - Emergency Hamburg",
        LoadingTitle = "Luxen Menu",
        LoadingSubtitle = "by Azfasty",
        ConfigurationSaving = {
            Enabled = true,
            FolderName = "Luxen",
            FileName = "EmergencyHamburg_Config"
        },
        KeySystem = false
    })
    
    -- Services
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local RunService = game:GetService("RunService")
    
    -- Variables de configuration
    local settings = {
        maxSpeed = 1,
        acceleration = 1,
        autoModify = false
    }
    
    -- FONCTIONS
    function isPlayerInVehicle()
        local character = LocalPlayer.Character
        if not character then return false end
        
        local humanoid = character:FindFirstChild("Humanoid")
        if not humanoid then return false end
        
        return humanoid.SeatPart ~= nil
    end
    
    function modifyCurrentVehicle()
        local character = LocalPlayer.Character
        if not character then return false end
        
        local humanoid = character:FindFirstChild("Humanoid")
        if not humanoid or not humanoid.SeatPart then return false end
        
        local seat = humanoid.SeatPart
        local vehicle = seat.Parent
        
        if vehicle then
            for _, part in pairs(vehicle:GetDescendants()) do
                if part:IsA("VehicleSeat") then
                    part.MaxSpeed = 50 * settings.maxSpeed
                    part.Torque = 1000 * settings.acceleration
                    part.TurnSpeed = 10
                end
            end
            return true
        end
        
        return false
    end
    
    -- Notification de demarrage
    Rayfield:Notify({
        Title = "Luxen Charge!",
        Content = "Emergency Hamburg Menu est pret",
        Duration = 3,
        Image = 4483362458
    })
    
    -- ONGLET VEHICULE
    local VehicleTab = Window:CreateTab("Vehicule", 4483362458)
    
    local VehicleSection = VehicleTab:CreateSection("Modifications de Vehicule")
    
    local SpeedSlider = VehicleTab:CreateSlider({
        Name = "Vitesse Maximum",
        Range = {1, 10},
        Increment = 1,
        Suffix = "x",
        CurrentValue = 1,
        Flag = "MaxSpeed",
        Callback = function(Value)
            settings.maxSpeed = Value
            Rayfield:Notify({
                Title = "Vitesse Modifiee",
                Content = "Vitesse: " .. Value .. "x",
                Duration = 2,
                Image = 4483362458
            })
        end,
    })
    
    local AccelSlider = VehicleTab:CreateSlider({
        Name = "Acceleration",
        Range = {1, 10},
        Increment = 1,
        Suffix = "x",
        CurrentValue = 1,
        Flag = "Acceleration",
        Callback = function(Value)
            settings.acceleration = Value
            Rayfield:Notify({
                Title = "Acceleration Modifiee",
                Content = "Acceleration: " .. Value .. "x",
                Duration = 2,
                Image = 4483362458
            })
        end,
    })
    
    local AutoModToggle = VehicleTab:CreateToggle({
        Name = "Modification Automatique",
        CurrentValue = false,
        Flag = "AutoModify",
        Callback = function(Value)
            settings.autoModify = Value
            if Value then
                Rayfield:Notify({
                    Title = "Auto-Mod Active",
                    Content = "Modifications automatiques activees",
                    Duration = 3,
                    Image = 4483362458
                })
            else
                Rayfield:Notify({
                    Title = "Auto-Mod Desactive",
                    Content = "Modifications manuelles uniquement",
                    Duration = 3,
                    Image = 4483362458
                })
            end
        end,
    })
    
    local ApplyButton = VehicleTab:CreateButton({
        Name = "Appliquer Maintenant",
        Callback = function()
            local success = modifyCurrentVehicle()
            if success then
                Rayfield:Notify({
                    Title = "Succes!",
                    Content = "Modifications appliquees",
                    Duration = 3,
                    Image = 4483362458
                })
            else
                Rayfield:Notify({
                    Title = "Erreur",
                    Content = "Montez dans un vehicule!",
                    Duration = 4,
                    Image = 4483362458
                })
            end
        end,
    })
    
    local ResetButton = VehicleTab:CreateButton({
        Name = "Reinitialiser",
        Callback = function()
            SpeedSlider:Set(1)
            AccelSlider:Set(1)
            settings.maxSpeed = 1
            settings.acceleration = 1
            Rayfield:Notify({
                Title = "Reinitialise",
                Content = "Valeurs remises a 1x",
                Duration = 3,
                Image = 4483362458
            })
        end,
    })
    
    local Paragraph = VehicleTab:CreateParagraph({
        Title = "Instructions",
        Content = "1. Ajustez les sliders\n2. Montez dans un vehicule\n3. Cliquez Appliquer ou activez Auto-Mod"
    })
    
    -- ONGLET INFOS
    local InfoTab = Window:CreateTab("Informations", 4483362458)
    
    InfoTab:CreateSection("A propos de Luxen")
    
    InfoTab:CreateParagraph({
        Title = "Luxen Menu v1.0",
        Content = "Menu pour Emergency Hamburg\nPar Azfasty"
    })
    
    local SpeedLabel = InfoTab:CreateLabel("Vitesse: 1x")
    local AccelLabel = InfoTab:CreateLabel("Acceleration: 1x")
    local StatusLabel = InfoTab:CreateLabel("Statut: En attente")
    
    -- ONGLET PARAMETRES
    local SettingsTab = Window:CreateTab("Parametres", 4483362458)
    
    SettingsTab:CreateSection("Configuration")
    
    local MenuKeybind = SettingsTab:CreateKeybind({
        Name = "Toggle Menu",
        CurrentKeybind = "RightShift",
        HoldToInteract = false,
        Flag = "MenuKeybind",
        Callback = function(Keybind)
            Rayfield:Toggle()
        end,
    })
    
    local DestroyButton = SettingsTab:CreateButton({
        Name = "Fermer Luxen",
        Callback = function()
            Rayfield:Notify({
                Title = "Au revoir!",
                Content = "Luxen se ferme...",
                Duration = 2,
                Image = 4483362458
            })
            wait(2)
            Rayfield:Destroy()
        end,
    })
    
    -- Mise a jour des labels
    spawn(function()
        while wait(1) do
            SpeedLabel:Set("Vitesse: " .. settings.maxSpeed .. "x")
            AccelLabel:Set("Acceleration: " .. settings.acceleration .. "x")
            
            if isPlayerInVehicle() then
                StatusLabel:Set("Statut: Dans un vehicule")
            else
                StatusLabel:Set("Statut: Pas dans un vehicule")
            end
        end
    end)
    
    -- Boucle de modification automatique
    RunService.Heartbeat:Connect(function()
        if settings.autoModify then
            pcall(function()
                modifyCurrentVehicle()
            end)
        end
    end)
    
    Rayfield:LoadConfiguration()
end
