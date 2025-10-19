-- Luxen Key System
-- Orion Library

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/weakhoes/Roblox-UI-Libs/refs/heads/main/Orion%20Lib/Orion%20Lib%20Source.lua')))()

-- Configuration des cles
local validKeys = {
    "LUXEN2025",
    "AZFASTY",
    "EMERGENCY"
}

local keyEntered = false

-- Fonction pour verifier la cle
local function checkKey(key)
    for _, validKey in pairs(validKeys) do
        if key == validKey then
            return true
        end
    end
    return false
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

-- Notification de bienvenue
OrionLib:MakeNotification({
    Name = "Bienvenue sur Luxen!",
    Content = "Entrez votre cle pour continuer",
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
    Name = "Authentification"
})

-- Input pour la cle
local keyInput = ""

KeySection:AddTextbox({
    Name = "Entrez votre cle",
    Default = "",
    TextDisappear = true,
    Callback = function(Value)
        keyInput = Value
    end
})

-- Bouton pour valider la cle
KeySection:AddButton({
    Name = "Valider la cle",
    Callback = function()
        if checkKey(keyInput) then
            keyEntered = true
            OrionLib:MakeNotification({
                Name = "Succes!",
                Content = "Cle valide! Chargement de Luxen...",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
            wait(1)
            OrionLib:Destroy()
            
            -- Charger le menu principal ici
            loadstring(game:HttpGet('https://raw.githubusercontent.com/Azfastyy/cheat-ahhhhh/refs/heads/main/cheat.lua'))()
        else
            OrionLib:MakeNotification({
                Name = "Erreur!",
                Content = "Cle invalide! Reessayez.",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        end
    end
})

KeySection:AddParagraph("Informations", "Cles valides:\n- LUXEN2025\n- AZFASTY\n- EMERGENCY")

-- Onglet Obtenir une cle
local GetKeyTab = KeyWindow:MakeTab({
    Name = "Obtenir une cle",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local GetKeySection = GetKeyTab:AddSection({
    Name = "Comment obtenir une cle"
})

GetKeySection:AddParagraph("Discord", "Rejoins notre Discord pour obtenir une cle gratuite!")

GetKeySection:AddButton({
    Name = "Copier le Discord",
    Callback = function()
        setclipboard("discord.gg/luxen")
        OrionLib:MakeNotification({
            Name = "Copie!",
            Content = "Lien Discord copie dans le presse-papier",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
})

GetKeySection:AddParagraph("Cles de test", "Pour tester le menu, utilisez:\nLUXEN2025")

-- Onglet Parametres
local SettingsTab = KeyWindow:MakeTab({
    Name = "Parametres",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local SettingsSection = SettingsTab:AddSection({
    Name = "Options"
})

SettingsSection:AddButton({
    Name = "Fermer le Key System",
    Callback = function()
        OrionLib:MakeNotification({
            Name = "Au revoir!",
            Content = "Luxen Key System ferme...",
            Image = "rbxassetid://4483345998",
            Time = 2
        })
        wait(2)
        OrionLib:Destroy()
    end
})

OrionLib:Init()
