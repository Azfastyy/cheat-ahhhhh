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
            
            
            -- Charger le menu principal
            loadMainMenu()
            OrionLib:Destroy()
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

    Rayfield:LoadConfiguration()
end
