
--[ Scoreboard - edited by szymczakovv ]--
-- Name: Scoreboard Reworked from esx_scoreboard and szymczakovv_scoreboard (first version of scoreboard on github)
-- Author: szymczakovv#1937
-- Date: 06/01/2021
-- Version: 2.0
-- Original: https://github.com/esx-community/esx_scoreboard

resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

server_script 'sv_scoreboard.lua'

client_script 'cl_scoreboard.lua'

ui_page 'ui/index.html'

files {
	'ui/*'
}
