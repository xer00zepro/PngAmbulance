-- Charger les fichiers requis

-- Exemple : Require ESX framework
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Définir les événements et les fonctions pour activer le script lorsque nécessaire

-- Exemple : Événement déclenché lorsqu'un joueur meurt
RegisterServerEvent('playerDeath')
AddEventHandler('playerDeath', function()
    local emsInCity = IsEMSPresent()
  
    if not emsInCity then
        TriggerClientEvent('startEMSRescue', -1, source) -- Déclencher l'événement côté client pour démarrer le sauvetage EMS pour tous les clients
    end
end)

-- Créer une fonction pour gérer l'arrivée de l'ambulance/hélicoptère et le traitement du joueur

-- Exemple : Fonction appelée lorsque l'ambulance/hélicoptère arrive
function HandleEMSRescue(playerId)
    local playerPed = GetPlayerPed(playerId)
    local ambulanceModel = Config.AmbulanceModel -- Modèle de l'ambulance depuis la configuration
    local helicopterModel = Config.HelicopterModel -- Modèle de l'hélicoptère depuis la configuration
  
    -- Créer et faire apparaître l'ambulance ou l'hélicoptère
    local vehicle
    if IsModelInCdimage(ambulanceModel) and IsModelValid(ambulanceModel) then
        vehicle = CreateVehicle(ambulanceModel, x, y, z, h, true, false)
    elseif IsModelInCdimage(helicopterModel) and IsModelValid(helicopterModel) then
        vehicle = CreateVehicle(helicopterModel, x, y, z, h, true, false)
    end

    if vehicle then
        -- Faites sortir l'ambulancier du véhicule et faites-le s'approcher du joueur décédé
      
        -- Implémentez la logique pour réanimer le joueur et effectuer l'animation appropriée
      
        -- Déclenchez un événement pour informer le client que le traitement EMS est terminé
        TriggerClientEvent('finishEMSRescue', playerId)
    else
        print('Impossible de créer le véhicule EMS')
    end
end

-- Créer une fonction pour gérer le transport du joueur vers l'hôpital

-- Exemple : Fonction appelée pour transporter le joueur vers l'hôpital
function TransportToHospital(playerId)
    local playerPed = GetPlayerPed(playerId)
    local hospitalCoords = Config.HospitalCoords -- Coordonnées de l'hôpital depuis la configuration

    -- Implémentez la logique pour transporter le joueur vers l'hôpital avec un itinéraire visible
  
    -- Implémentez la logique pour gérer l'affichage de l'itinéraire côté client
  
    -- Déclenchez un événement pour informer le client que le transport vers l'hôpital est terminé
    TriggerClientEvent('finishTransportToHospital', playerId)
end

-- Définir d'autres fonctions utilitaires nécessaires

-- Exemple : Fonction pour vérifier si EMS est présent en ville
function IsEMSPresent()
    -- Implémentez la logique pour vérifier si EMS est présent en ville
    -- Utilisez ESX pour obtenir des informations sur les joueurs EMS en ligne
    local players = ESX.GetPlayers()
  
    for _, playerId in ipairs(players) do
        local player = ESX.GetPlayerFromId(playerId)
        if player and player.job and player.job.name == 'ems' then
            return true
        end
    end

    return false
end

-- Activer le script lorsque nécessaire en utilisant les événements appropriés

-- Exemple : Événement déclenché lorsque le joueur meurt
AddEventHandler('playerDeath', function()
    local playerId = source
    local emsInCity = IsEMSPresent()
  
    if not emsInCity then
        TriggerClientEvent('startEMSRescue', -1, playerId)
       end
end)

-- Exemple : Événement déclenché lorsque le joueur est réanimé
AddEventHandler('esx_ambulancejob:revive', function(playerId)
    if playerId then
        TriggerClientEvent('startTransportToHospital', -1, playerId)
    end
end)
