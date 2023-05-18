local isUsingCane = false
local caneObject = nil
local caneModel = "prop_cs_walking_stick"
local boneIndex = GetPedBoneIndex(GetPlayerPed(-1), 57005) -- Attaché à la main droite
print("[^1Auteur^0] : ^4Sly Zapesti#9737^0")
function AttachCane()
    RequestModel(caneModel)
    while not HasModelLoaded(caneModel) do
        Citizen.Wait(100)
    end
    
    caneObject = CreateObject(caneModel, 0, 0, 0, true, true, false)
    AttachEntityToEntity(caneObject, GetPlayerPed(-1), boneIndex, 0.12, 0.00, 0.0, 290.0, .0, 65.0, true, true, false, true, 1, true)
end

function DetachCane()
    DeleteObject(caneObject)
    caneObject = nil
end

function ToggleCane()
    if not isUsingCane then
        isUsingCane = true
        AttachCane()
        
        RequestAnimSet("move_m@casual@a")
        RequestAnimDict("missheistfbisetup1")
        
        while not HasAnimSetLoaded("move_m@casual@a") or not HasAnimDictLoaded("missheistfbisetup1") do
            Citizen.Wait(100)
        end
        
        local ped = GetPlayerPed(-1)
        SetPedMovementClipset(ped, "move_m@casual@a", true)
        TaskPlayAnim(ped, "move_m@casual@a", "move_m@casual@a", 1.0, 1.0, -1, 50, 0, false, false, false)
        TaskPlayAnim(ped, "missheistfbisetup1", "outro_loop_f", 1.0, -1.0, -1, 50, 0, false, false, false)
    else
        isUsingCane = false
        DetachCane()
        
        local ped = GetPlayerPed(-1)
        ClearPedTasks(ped)
        ResetPedMovementClipset(ped, true)
    end
end

RegisterCommand("cane", function(source, args)
    ToggleCane()
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if isUsingCane then
            local ped = GetPlayerPed(-1)
            local coords = GetPedBoneCoords(ped, boneIndex)
            local _, _, z = table.unpack(coords)
            if z <= 0.95 then -- Si la canne touche le sol, le joueur s'appuie dessus
SetPedToRagdoll(ped, 1000, 1000, 0, true, true, false)
end
end
end
end)


