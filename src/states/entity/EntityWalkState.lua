-- require('mobdebug').start()


EntityWalkState = Class{__includes = BaseState}

function EntityWalkState:init(entity)
    self.entity = entity
    self.entity:changeAnimation('walk-'..self.entity.direction)
end

function EntityWalkState:update(dt)
    -- print("EntityWalkState - Current Position:" .. tostring(self.entity.x) .. "," .. tostring(self.entity.y))
    if self.entity.direction == 'up' then
        local move = {math.floor(self.entity.x + 0.5), math.floor(self.entity.y - self.entity.walkingSpeed * dt + 0.5)}
        if self.entity:isMoveAllowed(move) then
            self.entity.y = move[2]           
            if self.entity.y + TILE_SIZE / 2 < LEVEL_RENDER_OFFSET_TOP - 2  then
                self.entity.y = self.entity.y + self.entity.walkingSpeed * dt
                Event.dispatch('back-to-wall')        
                self.entity:changeState('edge')
            end
        end
    elseif self.entity.direction == 'down' then
        local move = {math.floor(self.entity.x + 0.5), math.floor(self.entity.y + self.entity.walkingSpeed * dt + 0.5)}
        if self.entity:isMoveAllowed(move) then
            self.entity.y = move[2]
            if self.entity.y + TILE_SIZE / 2  > VIRTUAL_HEIGHT - LEVEL_RENDER_OFFSET + 2 then
                self.entity.y = self.entity.y - self.entity.walkingSpeed * dt
                Event.dispatch('back-to-wall')
                self.entity:changeState('edge')
            end
        end
    elseif self.entity.direction == 'right' then
        local move = {math.floor(self.entity.x + self.entity.walkingSpeed * dt + 0.5), math.floor(self.entity.y + 0.5)}
        if self.entity:isMoveAllowed(move) then
            self.entity.x = move[1]
            if self.entity.x + TILE_SIZE / 2 > VIRTUAL_WIDTH - TILE_SIZE / 2 + 2 or self.entity.previousdirection == 'left' then
                self.entity.x = self.entity.x - self.entity.walkingSpeed * dt
                Event.dispatch('back-to-wall')
                self.entity:changeState('edge')
            end
        end
    elseif self.entity.direction == 'left' then
        local move = {math.floor(self.entity.x - self.entity.walkingSpeed * dt + 0.5),math.floor(self.entity.y + 0.5)}
        if self.entity:isMoveAllowed(move) then
            self.entity.x = move[1]
            if self.entity.x < 0 or self.entity.previousdirection == 'right' then
                self.entity.x = self.entity.x + self.entity.walkingSpeed * dt
                Event.dispatch('back-to-wall')
                self.entity:changeState('edge')
            end
        end
    end
    if love.keyboard.isDown('left') then
        if self.entity.direction ~= 'left' then
            self.entity.previousDirection = self.entity.direction
            Event.dispatch('change-direction')
        else
            Event.dispatch('walking')
        end
        self.entity.direction = 'left'
        self.entity:changeAnimation('walk-left')
    elseif love.keyboard.isDown('right') then
        if self.entity.direction ~= 'right' then
            self.entity.previousDirection = self.entity.direction
            Event.dispatch('change-direction')
        else
            Event.dispatch('walking')
        end
        self.entity.direction = 'right'
        self.entity:changeAnimation('walk-right')
    elseif love.keyboard.isDown('up') then
        if self.entity.direction ~= 'up' then
            self.entity.previousDirection = self.entity.direction
            Event.dispatch('change-direction')
        else
            Event.dispatch('walking')
        end
        self.entity.direction = 'up'
        self.entity:changeAnimation('walk-up')
    elseif love.keyboard.isDown('down') then
        if self.entity.direction ~= 'down' then
            self.entity.previousDirection = self.entity.direction
            Event.dispatch('change-direction')
        else
            Event.dispatch('walking')
        end
        self.entity.direction = 'down'
        self.entity:changeAnimation('walk-down')
    else
        self.entity:changeState('idle')
    end
    if not self.entity:insideBounds() then
        Event.dispatch('back-to-wall')        
        self.entity:changeState('edge')
    end
end

function EntityWalkState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],self.entity.x, self.entity.y)
    
    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.entity.x, self.entity.y, self.entity.width, self.entity.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end
