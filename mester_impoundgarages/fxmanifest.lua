fx_version 'cerulean'

game 'gta5'

description "Impound garages system by ᏕᎷ ᎷᏋᏕᏖ3Ꮢ#5828. You can find my scripts here: https://mest3rdevelopment.com"

author "ᏕᎷ ᎷᏋᏕᏖ3Ꮢ#5828"

version '1.0'

client_scripts{
    'Config.lua',
    'client/main.lua'
}

server_scripts{
    '@oxmysql/lib/MySQL.lua',
    'Config.lua',
    'ServerConfig.lua',
    'server/main.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/script.js',
    'html/style.css',
}