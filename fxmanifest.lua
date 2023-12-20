fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game 'rdr3'

author 'RexShack#3041'
description 'rsg-travel'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    '@rsg-core/shared/locale.lua',
    'locales/en.lua', 
    'locales/*.lua', 
    'config.lua',
    '@ox_lib/init.lua'
}

client_scripts {
    'client/client.lua',
}

server_scripts {
    'server/server.lua'
}

dependencies {
    'ox_lib',
    'rsg-core',
}

lua54 'yes'