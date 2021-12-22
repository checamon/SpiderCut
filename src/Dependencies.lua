--
-- libraries
--

Class = require 'lib/class'
Event = require 'lib/knife.event'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

require 'src/Animation'
require 'src/constants'
require 'src/StateMachine'
require 'src/Util'

require 'src/Level'
require 'src/Segment'
require 'src/Player'
require 'src/Ball'

require 'src/entity/entity_defs'
require 'src/entity/Entity'

require 'src/states/BaseState'
require 'src/states/StateStack'

require 'src/states/entity/EntityBaseState'
require 'src/states/entity/EntityIdleState'
require 'src/states/entity/EntityWalkState'
require 'src/states/entity/EntityWalkEdgeState'

require 'src/states/game/StartState'
require 'src/states/game/FadeInState'
require 'src/states/game/FadeOutState'
require 'src/states/game/PlayState'
require 'src/states/game/GameOverState'

gTextures = {
    ['entities'] = love.graphics.newImage('graphics/entities.png')
}

gFrames = {
    ['entities'] = GenerateQuads(gTextures['entities'], 16, 16)
}

gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32)
}

gSounds = {
    ['music'] = love.audio.newSource('sounds/music.wav', 'static'),
    ['field-music'] = love.audio.newSource('sounds/field_music.wav', 'static'),
    ['battle-music'] = love.audio.newSource('sounds/battle_music.mp3', 'static'),
    ['blip'] = love.audio.newSource('sounds/blip.wav', 'static'),
    ['powerup'] = love.audio.newSource('sounds/powerup.wav', 'static'),
    ['hit'] = love.audio.newSource('sounds/hit.wav', 'static'),
    ['run'] = love.audio.newSource('sounds/run.wav', 'static'),
    ['heal'] = love.audio.newSource('sounds/heal.wav', 'static'),
    ['exp'] = love.audio.newSource('sounds/exp.wav', 'static'),
    ['levelup'] = love.audio.newSource('sounds/levelup.wav', 'static'),
    ['victory-music'] = love.audio.newSource('sounds/victory.wav', 'static'),
    ['intro-music'] = love.audio.newSource('sounds/intro.mp3', 'static')
}

gImages = {
    ['img1'] = love.graphics.newImage('graphics/images/wp_18.jpg'),
    ['img2'] = love.graphics.newImage('graphics/images/wp_30.jpg'),
    ['img3'] = love.graphics.newImage('graphics/images/wp_46.jpg'),
}