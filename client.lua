local isAntiLagEnabled = true
local reverse = 0

RegisterCommand("antilag", function()
    isAntiLagEnabled = not isAntiLagEnabled
    PlaySoundFrontend(-1, 'CONFIRM_BEEP', 'HUD_MINI_GAME_SOUNDSET', true)
    message("~" .. (isAntiLagEnabled and "g" or "r") ..
        "~Antilag is now " .. (isAntiLagEnabled and "enabled" or "disabled") .. "~")
end, false)

local function isPlayerInDriverSeat()
    return GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) == PlayerPedId()
end

local function isGearReverse(gear)
    return gear == reverse 
end

local function isVehicleInAir(vehicle)
    return IsEntityInAir(vehicle)
end

local function handleAntiLag(vehicle, gear, rpm, delay)
    for _, carModel in pairs(Config.Cars) do
        local vehicleModel = GetEntityModel(vehicle)
        if GetHashKey(carModel) == vehicleModel then
            if not isGearReverse(gear) and not isVehicleInAir(vehicle) then
                if not IsControlPressed(1, 71) and not IsControlPressed(1, 72) then
                    if rpm > Config.RPM then
                        TriggerServerEvent("flames", VehToNet(vehicle))
                        TriggerServerEvent("SHM-AntiLag:PlayWithinDistance", 25.0,
                            tostring(math.random(1, 6)),
                            0.9)
                        SetVehicleTurboPressure(vehicle, 25)
                        Wait(delay)
                    end
                end
            end
        end
    end
end

CreateThread(function()
    while true do
        Wait(1000)
        local player = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(player, false)

        if isPlayerInDriverSeat() and isAntiLagEnabled then
            local rpm = GetVehicleCurrentRpm(vehicle, player)
            local gear = GetVehicleCurrentGear(vehicle)
            local delay = math.random(25, Config.explosionSpeed)

            handleAntiLag(vehicle, gear, rpm, delay)
        end
    end
end)

local exhausts = { "exhaust", "exhaust_2", "exhaust_3", "exhaust_4" }
local fxName = "veh_backfire"
local fxGroup = "core"

RegisterNetEvent('sound_client:PlayWithinDistance')
AddEventHandler('sound_client:PlayWithinDistance', function(coords, disMax, audoFile, audioVol)
    local entityCoords   = GetEntityCoords(PlayerPedId())
    local distance       = #(entityCoords - coords)
    local distanceRatio  = distance / disMax        -- calculate the distance ratio
    local adjustedVolume = audioVol / distanceRatio -- adjust volume based on distance ratio

    if (distance <= disMax) then
        SendNUIMessage({
            transactionType   = 'playSound',
            transactionFile   = audoFile,
            transactionVolume = adjustedVolume -- use the adjusted volume
        })
    end
end)

RegisterNetEvent("client_flames")
AddEventHandler("client_flames", function(vehicle)
    if NetworkDoesEntityExistWithNetworkId(vehicle) then
        for _, bones in pairs(exhausts) do
            local boneIndex = GetEntityBoneIndexByName(NetToVeh(vehicle), bones)
            if boneIndex ~= -1 then
                UseParticleFxAssetNextCall(fxGroup)
                local startParticle = StartParticleFxLoopedOnEntityBone(fxName, NetToVeh(vehicle), 0.0, 0.0, 0.0, 0.0,
                    0.0,
                    0.0,
                    GetEntityBoneIndexByName(NetToVeh(vehicle), bones), Config.flameSize, 0.0, 0.0, 0.0)
                StopParticleFxLooped(startParticle, true)
            end
        end
    end
end)

function message(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end
