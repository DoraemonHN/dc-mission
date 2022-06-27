fx_version 'cerulean'
game 'gta5'

description 'Daily Missions'
version '1.0.0'

client_script {
    'config.lua',
    'client/main.lua',
    'client/menu.lua',
    'client/npc.lua',
}

server_script {
    'config.lua',
    'server/main.lua',
    "@oxmysql/lib/MySQL.lua"
}

