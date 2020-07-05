--[ scoreboard powered by: https://szymczakovv.pl ]--
-- Nazwa: scoreboard
-- Autor: Szymczakovv#0001
-- Data: 05/06/2020
-- Wersja: 0.01

Citizen.CreateThread(function()
    listOn = false
    while true do
        Wait(0)

        if IsControlPressed(0, 48)--[[ Z`etka ]] then
            if not listOn then
                local players = {}
                local ptable = GetActivePlayers()
                for _, i in ipairs(ptable) do
                    local wantedLevel = GetPlayerWantedLevel(i)
                    r, g, b = GetPlayerRgbColour(i)
                    table.insert(players, 
                    '<tr style=\"color: rgb(' .. r .. ', ' .. g .. ', ' .. b .. ')\"><td>' .. GetPlayerServerId(i) .. '</td><td>' .. sanitize(GetPlayerName(i)) .. '</td>'
                    )
                end
                
                SendNUIMessage({ text = table.concat(players) })

                listOn = true
                while listOn do
                    Wait(0)
                    if(IsControlPressed(0, 48) --[[ Z`etka ]] == false) then
                        listOn = false
                        SendNUIMessage({
                            meta = 'close'
                        })
                        break
                    end
                end
            end
        end
    end
end)

local listOn = false

function sanitize(txt)
    local replacements = {
        ['&' ] = '&amp;', 
        ['<' ] = '&lt;', 
        ['>' ] = '&gt;', 
        ['\n'] = '<br/>'
    }
    return txt
        :gsub('[&<>\n]', replacements)
        :gsub(' +', function(s) return ' '..('&nbsp;'):rep(#s-1) end)
end


local HUD = {	
	ID	= true 
}

local UI = { 
	x		=  0.000,
	y		= -0.001
}

Citizen.CreateThread(function()
	while true do Citizen.Wait(1)

		local pd = GetPlayerPed(-1)

		if(IsPedInAnyVehicle(pd, false))then

			local pdv = GetVehiclePedIsIn(GetPlayerPed(-1),false)
			local PlateNum = GetVehicleNumberPlateText(pdv)

		end		
		
		if HUD.ID then
			local playerID = GetPlayerServerId(PlayerId())
			drawTxt(UI.x + 0.52, 	UI.y + 1.260, 1.0,1.0,0.55, "~y~www.szymczakovv.pl", 155, 155, 255, 255)  

		end		
		
	end
end)


-- DrawText function
function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a) 
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(21, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

