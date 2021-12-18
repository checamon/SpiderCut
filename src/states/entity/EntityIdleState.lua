-- require('mobdebug').start()

EntityIdleState = Class{__includes = BaseState}

function EntityIdleState:init(entity)
    self.entity = entity

    self.entity:changeAnimation('idle-' .. self.entity.direction)

end

function EntityIdleState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        if not self.entity:onTheEdge() then
            Event.dispatch('walking')
            self.entity:changeState('walk')
        else           
            Event.dispatch('on-edge')
            self.entity:changeState('edge')
        end        
    end
end

function EntityIdleState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],self.entity.x, self.entity.y)
    
    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.entity.x, self.entity.y, self.entity.width, self.entity.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end