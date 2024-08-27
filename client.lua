local ESX = exports["es_extended"]:getSharedObject()

local function DisableControl()
    DisableControlAction(0, 38, true)
    DisableControlAction(0, 289, true)
    DisableControlAction(0, 22, true)
    DisableControlAction(0, 37, true)
    DisableControlAction(0, 68, true)
    DisableControlAction(0, 69, true)
end

local function AttachEntityAndPlayAnim(data)
    local cachePed = cache.ped
    local animDict, animName = Shared.AnimDict, Shared.AnimName
    local getForward = GetEntityForwardVector(cachePed)
    local bones = GetPedBoneIndex(cachePed, 0x796E) 

    lib.requestAnimDict(animDict, 10000)

    TaskPlayAnim(cachePed, animDict, animName, 8.0, -8.0, -1, 50, 0, false, false, false)
    AttachEntityToEntity(data.entity, cachePed, bones, 1.0, 1.0, -0.1, 90.0, 0.0, 0.0, true, false, true, false, 0, true)
    CreateThread(function ()
        while true do
            ESX.ShowHelpNotification("Appuie sur G pour jeter le véhicule")
            DisableControl()
            if not IsEntityPlayingAnim(cachePed, animDict, animName, 3) then
                TaskPlayAnim(cachePed, animDict, animName, 8.0, -8.0, -1, 50, 0, false, false, false)
            end
            if IsControlJustPressed(0, 113) then
                ClearPedTasks(cachePed)
                DetachEntity(data.entity, true, true)
        
                SetEntityVelocity(data.entity, getForward.x * Shared.VelocityMultiplierXY, getForward.y * Shared.VelocityMultiplierXY , getForward.z * Shared.VelocityMultiplierZ)
                break
            end
            if not DoesEntityExist(data.entity) then
                break
            end
            Wait(1)
        end
    end)
end

local optionsVariable = {
    {
        label = "Porter le véhicule",
        name = "Carry-Vehicle",
        icon = "fa-solid fa-hands-holding",
        distance = 4,
        canInteract = function (entity, distance, coords, name, bone)
            return not IsEntityDead(cache.ped) and distance < 4 and not IsEntityAttachedToAnyPed(entity)
        end,
        onSelect = function(data)
            AttachEntityAndPlayAnim(data)
        end
    }
}
exports.ox_target:addGlobalVehicle(optionsVariable)

