fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Author - @Zeeroo'
name 'zr_logger'
description 'System for FiveM Event and StateBag Logging.'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/config.lua'
}

server_scripts {
    'src/eventLogger.lua'
}

dependencies {
    'ox_lib'
}