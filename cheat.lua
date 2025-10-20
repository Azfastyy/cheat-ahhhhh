-- Luxen Key System - Version sans HMAC
-- Compatible avec tous les jeux

local API_SECRET = "LUXEN_API_SECRET_HEADER_2025"

-- URL de l'API
local function getApiUrl()
    local parts = {"https://", "luxen-roblox", "-api.vercel", ".app"}
    return table.concat(parts, "")
end

local apiUrl = getApiUrl()

-- Fonction pour obtenir le HWID
local function getHWID()
    return game:GetService("RbxAnalyticsService"):GetClientId()
end

-- Fonction pour verifier la cle (SANS HMAC)
local function checkKey(key)
    local hwid = getHWID()
    local HttpService = game:GetService("HttpService")
    
    local body = {
        key = key,
        hwid = hwid
    }
    
    local success, response = pcall(function()
        return request({
            Url = apiUrl .. "/api/check-key",
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
                ["X-API-Secret"] = API_SECRET
            },
            Body = HttpService:JSONEncode(body)
        })
    end)
    
    if success and response and response.StatusCode == 200 then
        local data = HttpService:JSONDecode(response.Body)
        if data.token and data.refreshToken then
            getgenv().authToken = data.token
            getgenv().refreshToken = data.refreshToken
            return true, "Key valid"
        end
    elseif response then
        local data = HttpService:JSONDecode(response.Body)
        return false, data.error or "Server error"
    end
    
    return false, "Connection error"
end

-- Scripts par jeu
local gameScripts = {
    [109983668079237] = "https://raw.githubusercontent.com/Azfastyy/SAB-MENU-LUXEN-ROBLOX/refs/heads/main/main.lua", -- STEAL A BRAINROT
    [126884695634066] = "https://raw.githubusercontent.com/Azfastyy/GAG-CHEAT-LUXEN/refs/heads/main/main.lua", -- GROW A GARDEN
    [7711635737]      = "https://raw.githubusercontent.com/Azfastyy/EH-CHEAT-LUXEN/refs/heads/main/main.lua", -- EMERGENCY HAMBURG
    [79546208627805]  = "https://raw.githubusercontent.com/Azfastyy/99nights-CHEAT-LUXEN/refs/heads/main/main.lua", -- 99 NIGHTS
    [2753915549]      = "https://raw.githubusercontent.com/Azfastyy/BF-CHEAT-LUXEN/refs/heads/main/main.lua", -- BLOX FRUITS
}

-- Fonction pour charger le script du jeu
local function loadMainMenu(OrionLibRef)
    local placeId = game.PlaceId
    local scriptUrl = gameScripts[placeId]

    if scriptUrl then
        OrionLibRef:MakeNotification({
            Name = "Loading...",
            Content = "Loading your script...",
            Image = "rbxassetid://4483345998",
            Time = 2
        })
        
        wait(0.5)
        
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
            OrionLibRef:MakeNotification({
                Name = "Error",
                Content = "Failed to load the script: "..tostring(err),
                Image = "rbxassetid://4483345998",
                Time = 6
            })
            warn("Failed to load script:", err)
        else
            -- Fermer Orion seulement si le script a bien chargé
            wait(1)
            OrionLibRef:Destroy()
        end
    else
        OrionLibRef:MakeNotification({
            Name = "Unsupported Game",
            Content = "This game is not supported! PlaceId: " .. tostring(placeId),
            Image = "rbxassetid://4483345998",
            Time = 6
        })
    end
end

-- Orion Library
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/weakhoes/Roblox-UI-Libs/refs/heads/main/Orion%20Lib/Orion%20Lib%20Source.lua')))()

local keyInput = ""

-- Creation de la fenetre
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
            OrionLib:MakeNotification({
                Name = "Success !",
                Content = "Key is valid ! Luxen is loading...",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
            wait(1)
            -- Charger le script AVANT de destroy Orion
            loadMainMenu(OrionLib)
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

-- Onglet Get Key
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

-- Onglet Settings
local SettingsTab = KeyWindow:MakeTab({
    Name = "Settings",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

SettingsTab:AddButton({
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

OrionLib:Init()
