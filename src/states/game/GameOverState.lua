-- require('mobdebug').start()

GameOverState = Class{__includes = BaseState}

function GameOverState:init(score)
    self.name = 'GameOverState'
    gSounds['intro-music']:play()
    self.score = score or 0
end

function GameOverState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateStack:push(FadeInState({
            r = 0, g = 0, b = 0
        }, 1,
        function()
            gSounds['intro-music']:stop()
            
            gStateStack:push(StartState(),function()end, true)
            gStateStack:push(FadeOutState({
                r = 0, g = 0, b = 0
            }, 1,
            function() end))
        end))
    end
end

function GameOverState:render()
    love.graphics.clear(0, 0, 0, 255)

    love.graphics.setColor(56, 56, 56, 255)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('GAME OVER', 0, VIRTUAL_HEIGHT / 2 - 72, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['medium'])

    love.graphics.printf('Score: '..tostring(self.score), 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')

    love.graphics.printf('Try keeping away from the balls but do not lose them all!!!', 0, VIRTUAL_HEIGHT / 2 + 48, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press Enter', 0, VIRTUAL_HEIGHT / 2 + 88, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['small'])

    love.graphics.setColor(255, 255, 255, 255)
    -- love.graphics.draw(gTextures[self.sprite], self.spriteX, self.spriteY)
end