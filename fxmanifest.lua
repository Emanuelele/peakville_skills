fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Lele'
description 'Sistema skill e quest'
version '1.0.0'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'shared/config.lua',
    'shared/functions.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/logger.lua',
    'server/functions.lua',
    'server/validators/*.lua',
    'server/classes/*.lua',
    'server/managers/*.lua',
    'server/listeners/*.lua',
    'server/main.lua'
}

client_scripts {
    'client/main.lua'
}

ui_page 'web/build/index.html'
files {
    'web/build/index.html',
    'web/build/**/*'
}
