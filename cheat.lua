-- Luxen - Emergency Hamburg Menu
-- Utilise Rayfield Interface Suite

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
KeySystem = false,
KeySettings = {
Title = "Luxen",
Subtitle = "Key System",
Note = "Pas de clé requise",
SaveKey = false,
Key = "LUXEN2025"
}
})

-- Services
local Players = game:GetService(“Players”)
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService(“RunService”)

-- Variables de configuration
local settings = {
maxSpeed = 1,
acceleration = 1,
autoModify = false
}

– Onglet Principal - Véhicule
local VehicleTab = Window:CreateTab(“🚗 Véhicule”, 4483362458)

local VehicleSection = VehicleTab:CreateSection(“Modifications de Véhicule”)

– Slider Vitesse Maximum
local SpeedSlider = VehicleTab:CreateSlider({
Name = “🚀 Vitesse Maximum”,
Range = {1, 10},
Increment = 1,
Suffix = “x”,
CurrentValue = 1,
Flag = “MaxSpeed”,
Callback = function(Value)
settings.maxSpeed = Value
Rayfield:Notify({
Title = “Vitesse Modifiée”,
Content = “Vitesse maximum: “ .. Value .. “x”,
Duration = 2,
Image = 4483362458
})
end,
})

– Slider Accélération
local AccelSlider = VehicleTab:CreateSlider({
Name = “⚡ Accélération”,
Range = {1, 10},
Increment = 1,
Suffix = “x”,
CurrentValue = 1,
Flag = “Acceleration”,
Callback = function(Value)
settings.acceleration = Value
Rayfield:Notify({
Title = “Accélération Modifiée”,
Content = “Accélération: “ .. Value .. “x”,
Duration = 2,
Image = 4483362458
})
end,
})

VehicleTab:CreateLabel(“───────────────────────────”)

– Toggle Auto-Modification
local AutoModToggle = VehicleTab:CreateToggle({
Name = “🔄 Modification Automatique”,
CurrentValue = false,
Flag = “AutoModify”,
Callback = function(Value)
settings.autoModify = Value
if Value then
Rayfield:Notify({
Title = “Auto-Mod Activé”,
Content = “Les véhicules seront modifiés automatiquement”,
Duration = 3,
Image = 4483362458
})
else
Rayfield:Notify({
Title = “Auto-Mod Désactivé”,
Content = “Modifications manuelles uniquement”,
Duration = 3,
Image = 4483362458
})
end
end,
})

– Bouton Appliquer maintenant
local ApplyButton = VehicleTab:CreateButton({
Name = “✅ Appliquer les Modifications”,
Callback = function()
local success = modifyCurrentVehicle()
if success then
Rayfield:Notify({
Title = “Succès!”,
Content = “Modifications appliquées au véhicule”,
Duration = 3,
Image = 4483362458
})
else
Rayfield:Notify({
Title = “Erreur”,
Content = “Aucun véhicule trouvé! Montez dans un véhicule”,
Duration = 4,
Image = 4483362458
})
end
end,
})

VehicleTab:CreateLabel(“───────────────────────────”)

– Bouton Reset
local ResetButton = VehicleTab:CreateButton({
Name = “🔄 Réinitialiser les Valeurs”,
Callback = function()
SpeedSlider:Set(1)
AccelSlider:Set(1)
settings.maxSpeed = 1
settings.acceleration = 1
Rayfield:Notify({
Title = “Réinitialisé”,
Content = “Toutes les valeurs ont été remises à 1x”,
Duration = 3,
Image = 4483362458
})
end,
})

– Paragraphe d’informations
VehicleTab:CreateParagraph({
Title = “ℹ️ Instructions”,
Content = “1. Ajustez les sliders pour choisir les valeurs\n2. Montez dans un véhicule\n3. Cliquez sur ‘Appliquer’ ou activez l’auto-modification\n4. Profitez de votre véhicule amélioré!”
})

– Onglet Infos
local InfoTab = Window:CreateTab(“📋 Informations”, 4483362458)

InfoTab:CreateSection(“À propos de Luxen”)

InfoTab:CreateParagraph({
Title = “🎮 Luxen Menu”,
Content = “Menu de modification pour Emergency Hamburg\nVersion: 1.0\nCompatible avec tous les executors”
})

InfoTab:CreateLabel(“───────────────────────────”)

InfoTab:CreateParagraph({
Title = “⚠️ Avertissement”,
Content = “Ce script modifie les propriétés des véhicules. Utilisez-le de manière responsable. Les modifications ne sont pas permanentes et disparaissent à la respawn.”
})

– Statistiques en temps réel
local StatsSection = InfoTab:CreateSection(“📊 Statistiques Actuelles”)

local SpeedLabel = InfoTab:CreateLabel(“Vitesse: 1x”)
local AccelLabel = InfoTab:CreateLabel(“Accélération: 1x”)
local StatusLabel = InfoTab:CreateLabel(“Statut: En attente”)

– Mise à jour des labels en temps réel
spawn(function()
while wait(0.5) do
SpeedLabel:Set(“🚀 Vitesse: “ .. settings.maxSpeed .. “x”)
AccelLabel:Set(“⚡ Accélération: “ .. settings.acceleration .. “x”)

```
	local inVehicle = isPlayerInVehicle()
	if inVehicle then
		StatusLabel:Set("✅ Statut: Dans un véhicule")
	else
		StatusLabel:Set("⏳ Statut: Pas dans un véhicule")
	end
end
```

end)

– Onglet Paramètres
local SettingsTab = Window:CreateTab(“⚙️ Paramètres”, 4483362458)

SettingsTab:CreateSection(“Configuration du Menu”)

– Keybind pour toggle le menu
local MenuKeybind = SettingsTab:CreateKeybind({
Name = “Toggle Menu”,
CurrentKeybind = “RightShift”,
HoldToInteract = false,
Flag = “MenuKeybind”,
Callback = function(Keybind)
Rayfield:Toggle()
end,
})

SettingsTab:CreateLabel(“───────────────────────────”)

– Bouton pour détruire l’interface
local DestroyButton = SettingsTab:CreateButton({
Name = “❌ Fermer Luxen”,
Callback = function()
Rayfield:Notify({
Title = “Au revoir!”,
Content = “Luxen se ferme…”,
Duration = 2,
Image = 4483362458
})
wait(2)
Rayfield:Destroy()
end,
})

– FONCTIONS DE MODIFICATION DES VÉHICULES

– Fonction pour vérifier si le joueur est dans un véhicule
function isPlayerInVehicle()
local character = LocalPlayer.Character
if not character then return false end

```
local humanoid = character:FindFirstChild("Humanoid")
if not humanoid then return false end

return humanoid.SeatPart ~= nil
```

end

– Fonction pour modifier le véhicule actuel
function modifyCurrentVehicle()
local character = LocalPlayer.Character
if not character then return false end

```
local humanoid = character:FindFirstChild("Humanoid")
if not humanoid or not humanoid.SeatPart then return false end

local seat = humanoid.SeatPart
local vehicle = seat.Parent

if vehicle then
	-- Modifier toutes les VehicleSeat du véhicule
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
```

end

– Fonction pour modifier tous les véhicules proches
function modifyNearbyVehicles()
local character = LocalPlayer.Character
if not character then return end

```
local rootPart = character:FindFirstChild("HumanoidRootPart")
if not rootPart then return end

for _, vehicle in pairs(workspace:GetDescendants()) do
	if vehicle:IsA("VehicleSeat") then
		local distance = (vehicle.Position - rootPart.Position).Magnitude
		if distance < 100 then -- Dans un rayon de 100 studs
			vehicle.MaxSpeed = 50 * settings.maxSpeed
			vehicle.Torque = 1000 * settings.acceleration
			vehicle.TurnSpeed = 10
		end
	end
end
```

end

– Boucle principale de modification automatique
RunService.Heartbeat:Connect(function()
if settings.autoModify then
pcall(function()
modifyCurrentVehicle()
end)
end
end)

– Notification de démarrage
Rayfield:Notify({
Title = “Luxen Chargé!”,
Content = “Emergency Hamburg Menu est prêt à l’emploi”,
Duration = 5,
Image = 4483362458
})

– Chargement de la configuration
Rayfield:LoadConfiguration()
