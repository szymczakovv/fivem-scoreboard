
--[ Scoreboard - edited by szymczakovv ]--
-- Name: Scoreboard Reworked from esx_scoreboard and szymczakovv_scoreboard (first version of scoreboard on github)
-- Author: szymczakovv#1937
-- Date: 06/01/2021
-- Version: 2.0
-- Original: https://github.com/esx-community/esx_scoreboard

local Keys = { ["Z"] = 20, ["X"] = 73 }
local Connectedplayers = {}
local fpscount = 0
local fps = 0
local open = false

RegisterNetEvent('fivem-scoreboard:GetConnectedPlayers')
AddEventHandler('fivem-scoreboard:GetConnectedPlayers', function(data)
	Connectedplayers = data

	table.sort(Connectedplayers, function(a,b) 
		if (a ~= nil) and (b~= nil) then
		  return a.id < b.id
		end
	end)

	if open then
		SendNUIMessage({action = "display",  data = Connectedplayers,fps = math.floor(fps/10)})
	end
end)

CreateThread(function()
	while true do
		fps = 0
		fps =  fpscount
		fpscount = 0
		if open then
			SendNUIMessage({action = "display",  data = Connectedplayers,fps = math.floor(fps/10)})
		end
		Wait(10000)
	end
end)


Citizen.CreateThread(function()

	while true do

		Citizen.Wait(0)

		if IsControlJustPressed(0, Keys['Z']) and IsInputDisabled(0) then

			open = true
			SendNUIMessage({action = "display",  data = Connectedplayers,fps = math.floor(fps/10)})
			SetNuiFocus(false,false)
		end
        fpscount = fpscount + 1 
		if IsControlJustReleased(0, Keys['Z']) and IsInputDisabled(0) or IsControlJustPressed(0, Keys['X']) then

			open = false
			SendNUIMessage({action = "close"})
			SetNuiFocus(false,false)

		fpscount = fpscount + 1 

		end
		fpscount = fpscount + 1 

		if IsControlJustPressed(1, 20) and not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then


			TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_CLIPBOARD", 0, false)


		end

		if IsControlJustReleased(1, 20) then 

			ClearPedTasks(GetPlayerPed(-1)) 

		end  

	end

end)


RegisterNetEvent('fivem-scoreboard:toggleID')

AddEventHandler('fivem-scoreboard:toggleID', function(state)

	if state then

		idVisable = state

	else

		idVisable = not idVisable

	end



	SendNUIMessage({

		action = 'toggleID',

		state = idVisable

	})

end)


RegisterNetEvent('fivem-scoreboard:chat')
AddEventHandler('fivem-scoreboard:chat', function(id, color, message)
	local _source = PlayerId()
	local target = GetPlayerFromServerId(id)
	
	if target == _source then
		TriggerEvent('chat:addMessage', {
		            template = '<div style="padding: 0.4vw; margin: 0.5vw; font-size: 15px; background-color: rgba(	042,100,120, 0.4); border-radius: 3px;"><i class="fas fa-user-circle"></i>&nbsp;{0}</div>',

        args = {message}
})
	elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(_source)), GetEntityCoords(GetPlayerPed(target)), true) < 60 then
		TriggerEvent('chat:addMessage', {
		            template = '<div style="padding: 0.4vw; margin: 0.5vw; font-size: 15px; background-color: rgba(	042,100,120, 0.4); border-radius: 3px;"><i class="fas fa-user-circle"></i>&nbsp;{0}</div>',

        args = {message}
})
	end
end)




Citizen.CreateThread(function()

	while true do

		Citizen.Wait(0)

			if IsControlJustPressed(1, 20) then

				TriggerServerEvent('fivem-scoreboard:server', GetPlayerServerId(PlayerId()))

		end

	end

end)



local color = {r = 255, g = 162, b = 0}

local font = 1

timer = 0

local showPlayerBlips = false

local ignorePlayerNameDistance = false

local playerNamesDist = 25

local displayIDHeight = 1.5 

local red = 255

local green = 255

local blue = 255

function DrawText3D(x,y,z, text)

    local onScreen,_x,_y=World3dToScreen2d(x,y,z)

    local px,py,pz=table.unpack(GetGameplayCamCoords())



    SetTextScale(0.40, 0.40)

    SetTextFont(4)

    SetTextProportional(1)

    SetTextColour(255, 255, 255, 215)

    SetTextEntry("STRING")

    SetTextCentre(1)

    AddTextComponentString(text)

    DrawText(_x,_y)

    local factor = (string.len(text)) / 370

    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)

end

function DrawText3SD(x,y,z, text) 

    local onScreen,_x,_y=World3dToScreen2d(x,y,z)

    local px,py,pz=table.unpack(GetGameplayCamCoords())

    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)



    local scale = (1/dist)*2

    local fov = (1/GetGameplayCamFov())*100

    local scale = scale*fov

    

    if onScreen then

        SetTextScale(1.0*scale, 1.55*scale)

        SetTextFont(0)

        SetTextProportional(1)

        SetTextColour(red, green, blue, 255)

        SetTextDropshadow(0, 0, 0, 0, 255)

        SetTextEdge(2, 0, 0, 0, 150)

        SetTextDropShadow()

        SetTextOutline()

        SetTextEntry("STRING")

        SetTextCentre(1)

        AddTextComponentString(text)

        World3dToScreen2d(x,y,z, 0) --Added Here

        DrawText(_x,_y)

    end

end



Citizen.CreateThread(function()

    while true do

          if IsControlPressed(0, 48)--[[ INPUT_PHONE ]] then

        for i=0,99 do

            N_0x31698aa80e0223f8(i)

        end

        for id = 0, 256 do

            if  ((NetworkIsPlayerActive( id )) and GetPlayerPed( id ) ~= GetPlayerPed( -1 )) then

                ped = GetPlayerPed( id )

                blip = GetBlipFromEntity( ped ) 

 

                x1, y1, z1 = table.unpack( GetEntityCoords( GetPlayerPed( -1 ), true ) )

                x2, y2, z2 = table.unpack( GetEntityCoords( GetPlayerPed( id ), true ) )

                distance = math.floor(GetDistanceBetweenCoords(x1,  y1,  z1,  x2,  y2,  z2,  true))



                if(ignorePlayerNameDistance) then

                    if NetworkIsPlayerTalking(id) then

                        red = 0

                        green = 0

                        blue = 255

                        DrawText3D(x2, y2, z2 + displayIDHeight, GetPlayerServerId(id))

                    else

                        red = 255

                        green = 255

                        blue = 255

                        DrawText3D(x2, y2, z2 + displayIDHeight, GetPlayerServerId(id))

                    end

                end



                if ((distance < playerNamesDist)) then

                    if not (ignorePlayerNameDistance) then

                        if NetworkIsPlayerTalking(id) then

                            red = 0

                            green = 0

                            blue = 255

                            DrawText3D(x2, y2, z2 + displayIDHeight, GetPlayerServerId(id))

                        else

                            red = 255

                            green = 255

                            blue = 255

                            DrawText3D(x2, y2, z2 + displayIDHeight, GetPlayerServerId(id))

                        end

                    end

                end  

            end

        end

    end

        Citizen.Wait(0)

    end

end)


RegisterNUICallback('close', function(data, cb)
	open = false
    SetNuiFocus(false,false)
end)

RegisterNUICallback('NuiFocus', function(data, cb)
    SetNuiFocus(false,false)
end)