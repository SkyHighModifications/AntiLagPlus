fx_version 'cerulean'

game { 'gta5' }

author 'Origianl Yorick / Editied SkyHigh Modifications'
description 'Simple script that is supposed to serve as something like a "antilag" kind of thing for FiveM'
version '1.0.0'

ui_page('html/index.html')

client_scripts {
    'config.lua',
    'client.lua'
}

server_script 'server.lua'

files {
    'html/index.html',
    'html/sounds/**'
}
