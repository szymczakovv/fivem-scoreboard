
--[ Scoreboard - edited by szymczakovv ]--
-- Name: Scoreboard Reworked from esx_scoreboard and szymczakovv_scoreboard (first version of scoreboard on github)
-- Author: szymczakovv#1937
-- Date: 06/01/2021
-- Version: 2.0
-- Original: https://github.com/esx-community/esx_scoreboard

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local Connectedplayers = {}
local settings = {
    discord = {
        guildId = "SERVER ID HERE",
		botToken = "BOT TOKEN HERE",
    }
}

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Wait(1000)
		GetFirstData()
	end
end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
    AddPlayerToScoreboard(xPlayer)
end)

AddEventHandler('esx:playerDropped', function(playerId)
    RemoveFromScoreboard(playerId)
end)

Citizen.CreateThread(function()
	while true do
		Wait(10000)
		UpdatePing()
	end
end)

function GetFirstData()
    local players = ESX.GetPlayers()

    for i,v in ipairs(players) do
        local xPlayer = ESX.GetPlayerFromId(v)
        local discord = GetDiscord(v)
        Connectedplayers[v] = {
            ["id"] = v,
            ["ping"] = GetPlayerPing(v),
            ["steam"] = GetPlayerName(v),
            ["discord"] = discord["username"],
            ["avatar"] = discord["avatar"]
        }
    end
    TriggerClientEvent('fivem-scoreboard:GetConnectedPlayers',-1,Connectedplayers)
end

function AddPlayerToScoreboard(xPlayer)
    local discord = GetDiscord(xPlayer.source)
    Connectedplayers[xPlayer.source] = {
        ["id"] = xPlayer.source,
        ["ping"] = GetPlayerPing(xPlayer.source),
        ["steam"] = GetPlayerName(xPlayer.source),
        ["discord"] = discord["username"],
        ["avatar"] = discord["avatar"]
    }
    TriggerClientEvent('fivem-scoreboard:GetConnectedPlayers',-1,Connectedplayers)
	TriggerClientEvent('fivem-scoreboard:toggleID', playerId, false)
end

function UpdatePing()
    for i,v in ipairs(GetPlayers()) do
        if(Connectedplayers[v] ~= nil) then
            Connectedplayers[v].ping = GetPlayerPing(v)
        end
    end
    TriggerClientEvent('fivem-scoreboard:GetConnectedPlayers',-1,Connectedplayers)
end

function RemoveFromScoreboard(id)
    Connectedplayers[id] = nil
    TriggerClientEvent('fivem-scoreboard:GetConnectedPlayers',-1,Connectedplayers)
end


function GetDiscord(source)
    local data = {}
    local waiting = true
	local num = 0
	local num2 = GetNumPlayerIdentifiers(source)
    local discord = nil
	while num < num2 and not discord do
	local a = GetPlayerIdentifier(source, num)
	if string.find(a, "discord") then discord = a end
		num = num+1
    end
    PerformHttpRequest("https://discordapp.com/api/guilds/".. settings.discord.guildId .."/members/"..string.sub(discord, 9), function(err, text, headers)
        if err == 200 then
            local member = json.decode(text)
            data["username"] = member.user.username.."#"..member.user.discriminator
            if member.user.avatar then
                data["avatar"] = "https://i.imgur.com/jblm4Ul.png"
            else
                data["avatar"] = "https://i.imgur.com/jblm4Ul.png"
            end
        else 
            data["avatar"] = "https://i.imgur.com/jblm4Ul.png"
			data["username"] = "No Discord"
        end
        waiting = false
    end, "GET", "", {["Content-type"] = "application/json", ["Authorization"] = "Bot "..settings.discord.botToken})

    while waiting do Wait(0) end
    
    return data
end

function GetLevels(policecount,emscount,taxicount)

    if policecount <= 3 then
        policecount = "low"
    elseif policecount >= 4 and policecount <= 6 then
        policecount = "medium"
    elseif policecount >= 7 then
        policecount = "high"
    end

    if emscount <= 3 then
        emscount = "low"
    elseif emscount >= 4 and emscount <= 6 then
        emscount = "medium"
    elseif emscount >= 7 then
        emscount = "high"
    end

    if taxicount <= 3 then
        taxicount = "low"
    elseif taxicount >= 4 and taxicount <= 6 then
        taxicount = "medium"
    elseif taxicount >= 7 then
        taxicount = "high"
    end

    return {
        police = policecount,
        ems = emscount,
        taxi = taxicount
    }

end


RegisterServerEvent('fivem-scoreboard:server') 
AddEventHandler('fivem-scoreboard:server', function(id)
	TriggerClientEvent('fivem-scoreboard:chat', -1 , id , {256, 152, 247}, 'Obywatel [' .. id .. ']: przegląda wykaz mieszkańców.')
end)
