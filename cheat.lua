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
		Note = "Pas de cle requise",
		SaveKey = false,
		Key = "LUXEN2025"
	}
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

-- FONCTIONS (definies avant utilisation)
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
