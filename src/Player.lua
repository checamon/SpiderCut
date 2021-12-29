
-- require('mobdebug').start()

Player = Class{__includes = Entity}

function Player:init(def, level )
    Entity.init(self,def)

    self.x = 1
    self.y = LEVEL_RENDER_OFFSET_TOP - TILE_SIZE / 2 + 1

    self.trail = {}
    self.level = level
    self.trailSegments = {}    
    self.trailStartSegment = {}
    self.trailFinishSegment = {}
    self.score = 0
    self.multiplier = 1

    Event.on('on-edge',function() 
        self:onEdge()
        -- self:playerDebug("after on-edge event ")
    end)

    Event.on('walking',function() 
        self:onWalking()
        -- self:playerDebug("after walking event ")
    end)

    Event.on('change-direction', function()
        self:onChangeDirection()
        -- self:playerDebug("after change-direction event ")
    end)

    Event.on('back-to-wall', function ()
        self:onBackToWall()
        -- self:playerDebug("after back-to-wall event ")
    end)
end

function Player:isMoveAllowed(point)
    point = {point[1] + self.width/2, point[2] + self.width/2}
    for i,segment in pairs (self.trailSegments) do
        if segment:pointInSegment(point) then
            return false
        end
    end
    return true
end

function Player:changeState(state)
    Entity.changeState(self,state)    
end

function Player:update(dt)
    Entity.update(self, dt)    
    
end

function Player:createAnimations(animations)
    return Entity.createAnimations(self,animations)
end

function Player:changeAnimation(name)
    Entity.changeAnimation(self,name)
end

function Player:render()    
    Entity.render(self)
    self:renderTrailSegments()

    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end

function Player:renderTrailSegments()
    for i,segment in pairs (self.trailSegments) do
        segment:render()
        -- print_r(segment)
    end
end

function Player:insideBounds()
     return self.level:insideBounds(self.x + TILE_SIZE / 2, self.y + TILE_SIZE / 2)
end

function Player:onEdge()
    self.trail = {}
    self.trailSegments = {}
    self.trailFinishSegment = {}
    self.trailStartSegment = {}
    self.trailStartSegment[1], self.trailStartSegment[2] = self.level:getTouchingSegment(self.x + TILE_SIZE / 2, self.y + TILE_SIZE / 2)
    table.insert(self.trail,
            {['x'] = self.x + self.width/2,['y'] = self.y + self.height/2}
    )

end

function Player:onWalking()
    if #self.trail > 1 then
        table.remove(self.trail)
        table.remove(self.trailSegments)
    end
    table.insert(self.trail,
            {['x'] = self.x + self.width/2,['y'] = self.y + self.height/2}
    )
    if #self.trail == 2 then        
        table.insert(self.trailSegments,
        Segment(
            {self.trail[1].x, self.trail[1].y},
            {self.trail[2].x, self.trail[2].y},
            .5,'',{r=250,g=150,b=150}
            )
        )
    end
end

function Player:onChangeDirection()
    if self:insideBounds() then
        if #self.trail > 1 then
            table.remove(self.trail)
            table.remove(self.trailSegments)
        end
    
        table.insert(self.trail,
            {['x'] = self.x + self.width/2,['y'] = self.y + self.height/2}
        )
        if #self.trail == 2 then 
            
            table.insert(self.trailSegments,
                Segment(
                    {self.trail[1].x, self.trail[1].y},
                    {self.trail[2].x, self.trail[2].y},
                    .5,'',{r=250,g=150,b=150}
                )
            )
        end
        self.trail = {}
        table.insert(self.trail,
        {['x'] = self.x + self.width/2,['y'] = self.y + self.height/2}
        )
    end
end

function Player:onBackToWall()
    if self:onTheEdge() and #self.trail > 0 then
        self.trailFinishSegment[1], self.trailFinishSegment[2] = self.level:getTouchingSegment(self.x + TILE_SIZE / 2, self.y + TILE_SIZE / 2)
        local k = #self.trailSegments
        local j = #self.trail + 1
        if #self.trail > 1 then
            table.remove(self.trail)
        end
        table.insert(self.trail,
            {['x'] = self.x + self.width/2,['y'] = self.y + self.height/2}
        )
        if #self.trail == 2 then
            table.remove(self.trailSegments)
            table.insert(self.trailSegments,
                Segment(
                    {self.trail[1].x, self.trail[1].y},
                    {self.trail[2].x, self.trail[2].y},
                    .5,'',{r=250,g=150,b=150}
                )
            )
        end
        self:resetTrail()
    end
end

function Player:reset()
    self.x = 1
    self.y = LEVEL_RENDER_OFFSET_TOP - TILE_SIZE / 2 + 1
    self.trail = {}
    self.trailSegments = {}
    self.trailStartSegment = {}
    self.trailFinishSegment = {}
end

function Player:resetTrail()
    self:playerDebug('Player:resetTrail')
    if #self.trailStartSegment > 0 and #self.trailFinishSegment > 0 then
        self.level:cutLevel()
    end
    self.trail = {}
    self.trailStartSegment = {}
    self.trailFinishSegment = {}
    self.trailSegments = {}
end

function Player:onTheEdge()
    return self.level:pointOnEdge(self.x + TILE_SIZE / 2, self.y + TILE_SIZE / 2)
end

function Player:playerDebug(msg)
    -- print('------------------------------------')
    if msg then
        -- print(msg)
    end
    -- print("Player Position x,y = " ..tostring(self.x)..','..tostring(self.y))
    -- print("Player Center x,y = " ..tostring(self.x+8)..','..tostring(self.y+8))
    -- print("Player direction : "..self.direction .. ' previous: '..self.previousDirection)
    -- print('......................')
    -- print("Player trail points: ")
    -- print_r(self.trail)
    -- print('......................')
    -- print("Player segments: ")
    -- print_s(self.trailSegments)
    -- print('......................')
    -- print("Trail Start")
    if self.trailStartSegment[2] ~= nil then
        self.trailStartSegment[2]:debug(tostring(self.trailStartSegment[1]))
    end
    -- print('......................')
    -- print("Trail Finish")
    if self.trailFinishSegment[2] ~= nil then
        self.trailFinishSegment[2]:debug(tostring(self.trailFinishSegment[1]))
    end
    -- print('------------------------------------')
end