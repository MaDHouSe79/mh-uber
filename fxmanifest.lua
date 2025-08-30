fx_version 'cerulean'
game 'gta5'
author 'MaDHouSe79'
description 'MH - Uber'
version '1.0.0'
repository 'https://github.com/MaDHouSe79/mh-uber'
shared_scripts {'@ox_lib/init.lua', 'shared/locale.lua', 'locales/en.lua', 'locales/*.lua', 'shared/config.lua', 'shared/vehicles.lua'}
client_scripts {'client/main.lua'}
server_scripts {'@oxmysql/lib/MySQL.lua', 'server/main.lua', 'server/update.lua'}
dependencies {'oxmysql'}
lua54 'yes'