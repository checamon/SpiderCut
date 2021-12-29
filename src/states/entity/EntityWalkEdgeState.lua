-- require('mobdebug').start()


EntityWalkEdgeState = Class{__includes = BaseState}

function EntityWalkEdgeState:init(entity)
    self.entity = entity
    self.entity:changeAnimation('walk-'..self.entity.direction)
end

function EntityWalkEdgeState:update(dt)

    local dy = math.floor(self.entity.walkingSpeed * dt + 0.5)
    local dx = math.floor(self.entity.walkingSpeed * dt + 0.5)

    if self.entity.direction == 'left' then
        if self.entity.level:pointOnEdge(self.entity.x - dx + TILE_SIZE / 2, self.entity.y + TILE_SIZE / 2) then
            self.entity.x = self.entity.x - dx
            Event.dispatch('on-edge')
        else
            if self.entity.level:insideBounds(self.entity.x + TILE_SIZE / 2 - dx, self.entity.y + TILE_SIZE / 2) then
                self.entity:changeState('walk')
                Event.dispatch('walking')
                self.entity.x = self.entity.x - dx
            end
        end
    elseif self.entity.direction == 'right' then
        if self.entity.level:pointOnEdge(self.entity.x + dx + TILE_SIZE / 2, self.entity.y + TILE_SIZE / 2) then
            self.entity.x = self.entity.x + dx
            Event.dispatch('on-edge')
        else
            if self.entity.level:insideBounds(self.entity.x + TILE_SIZE / 2 + dx, self.entity.y + TILE_SIZE / 2) then
                self.entity:changeState('walk')
                Event.dispatch('walking')
                self.entity.x = self.entity.x + dx
            end
        end
    elseif self.entity.direction == 'up' then
        if self.entity.level:pointOnEdge(self.entity.x + TILE_SIZE / 2, self.entity.y - dy + TILE_SIZE / 2) then
            self.entity.y = self.entity.y - dy
            Event.dispatch('on-edge')
        else
            if self.entity.level:insideBounds(self.entity.x + TILE_SIZE / 2, self.entity.y + TILE_SIZE / 2 - dy) then
                self.entity:changeState('walk')
                Event.dispatch('walking')
                self.entity.y = self.entity.y - dy
            end
        end
    elseif self.entity.direction == 'down' then
        if self.entity.level:pointOnEdge(self.entity.x + TILE_SIZE / 2, self.entity.y + dy + TILE_SIZE / 2) then
            self.entity.y = self.entity.y + dy
            Event.dispatch('on-edge')
        else            
            if self.entity.level:insideBounds(self.entity.x + TILE_SIZE / 2, self.entity.y + TILE_SIZE / 2 + dy) then
                self.entity:changeState('walk')
                Event.dispatch('walking')
                self.entity.y = self.entity.y + dy
            end
        end
    end

    if love.keyboard.isDown('left') then
        if self.entity.direction ~= 'left' then
            self.entity.previousDirection = self.entity.direction
        end
        self.entity.direction = 'left'
        self.entity:changeAnimation('walk-left')
    elseif love.keyboard.isDown('right') then
        if self.entity.direction ~= 'right' then
            self.entity.previousDirection = self.entity.direction
        end
        self.entity.direction = 'right'
        self.entity:changeAnimation('walk-right')
    elseif love.keyboard.isDown('up') then
        if self.entity.direction ~= 'up' then
            self.entity.previousDirection = self.entity.direction
        end
        self.entity.direction = 'up'
        self.entity:changeAnimation('walk-up')
    elseif love.keyboard.isDown('down') then
        if self.entity.direction ~= 'down' then
            self.entity.previousDirection = self.entity.direction
        end
        self.entity.direction = 'down'
        self.entity:changeAnimation('walk-down')
    else
        self.entity:changeState('idle')
    end


end

function EntityWalkEdgeState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],self.entity.x, self.entity.y)
    
    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.entity.x, self.entity.y, self.entity.width, self.entity.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end
