-- require('mobdebug').start()

StartState = Class{__includes = BaseState}

function StartState:init()
    self.name = 'StartState'
    gSounds['intro-music']:play()

end

function StartState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateStack:push(FadeInState({
            r = 255, g = 255, b = 255
        }, 1,
        function()
            gSounds['intro-music']:stop()
            
            gStateStack:push(PlayState(),function()end, true)
            -- gStateStack:push(FadeOutState({
            --     r = 255, g = 255, b = 255
            -- }, 1,
            -- function() end))
        end))
    end
end

function StartState:render()
    -- print("StartSate : setting colors")
    love.graphics.clear(0, 0, 0, 255)
    love.graphics.setColor(56, 56, 56, 255)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Spider Cut!', 0, VIRTUAL_HEIGHT / 2 - 72, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Press Enter', 0, VIRTUAL_HEIGHT / 2 + 68, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['small'])
    -- print("StartState : end")
    -- love.graphics.setColor(255, 255, 255, 255)
    -- love.graphics.draw(gTextures[self.sprite], self.spriteX, self.spriteY)
end