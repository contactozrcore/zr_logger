fx_version 'cerulean'
game 'gta5'
lua54 'yes'

node_version '22'

author 'Author - @Zeeroo'
name 'zr_logger'
description 'System for FiveM Event and StateBag Logging (API Key of Artifacts by JGScripts).'
version '1.0.5'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/config.lua'
}

server_scripts {
    'src/eventLogger.lua',
    'src/checkArtifactVersion.js'
}

dependencies {
    'ox_lib'
}