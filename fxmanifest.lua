fx_version 'cerulean'
game "gta5"

author 'SCORZ'
description 'Garages resource'

client_scripts {
    'config.lua',
    'lang.lua',
    'client/client.lua',
    'client/utils.lua',
    'client/functions.lua',
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'config.lua',
    'lang.lua',
    'server/server.lua'
}