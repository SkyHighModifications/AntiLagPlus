local ANTI_LAG_EVENT = "flames"
local PLAY_WITHIN_DISTANCE_EVENT = "SHM-AntiLag:PlayWithinDistance"

RegisterNetEvent(ANTI_LAG_EVENT)
AddEventHandler(ANTI_LAG_EVENT, function(entity)
    if type(entity) == "number" then
        TriggerClientEvent("client_flames", -1, entity)
    else
        print("[WARNING] Invalid 'entity' type in 'flames' event.")
    end
end)

RegisterNetEvent(PLAY_WITHIN_DISTANCE_EVENT)
AddEventHandler(PLAY_WITHIN_DISTANCE_EVENT, function(disMax, audioFile, audioVol)
    local playerCoords = GetEntityCoords(GetPlayerPed(source))
    if type(disMax) == "number" and type(audioFile) == "string" and type(audioVol) == "number" then
        TriggerClientEvent(PLAY_WITHIN_DISTANCE_EVENT, -1, playerCoords, disMax, audioFile, audioVol)
    else
        print("[WARNING] Invalid parameters in 'PlayWithinDistance' event.")
    end
end)
