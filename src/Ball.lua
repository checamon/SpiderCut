
Ball = Class{}

function Ball:init(x, y, dx, dy)
    self.x = x
    self.y = y
    self.width = 8
    self.height = 8

    -- these variables are for keeping track of our velocity on both the
    -- X and Y axis, since the ball can move in two dimensions
    self.dy = dx
    self.dx = dy
    self.remove = false
    self.hitPlayer = false
end
function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2
    self.dx = 0
    self.dy = 0
end

function Ball:update(dt,level)
    local tempX = math.floor((self.x + self.dx * dt) + 0.5)
    local tempY = math.floor((self.y + self.dy * dt) + 0.5)

    local trailSeg = level:pointOnEdge(tempX,tempY,level.player.trailSegments)
    if trailSeg then
        self.hitPlayer = true
        -- print("ball hits player")
        gSounds['hit']:play()
        return
    end

    local i, segment = level:getTouchingSegment(tempX,tempY)
    if segment then
        local direction = self:getCollisionDirection(segment, tempX, tempY)
        if direction == 'up' or direction == 'down' then
            self.dy = - self.dy
        elseif direction == 'right' or direction == 'left' then
            self.dx = -self.dx
        elseif level:pointOnEdge(tempX,tempY) then
            self.dx = -self.dx
            self.dy = -self.dy
        elseif not level:insideBounds(tempX,tempY) then
            self.dx = -self.dx
            self.dy = -self.dy
        end
        gSounds['blip']:stop()
        gSounds['blip']:play()
    end

    if not level:insideBounds(tempX,tempY) and not level:pointOnEdge(tempX,tempY) then
        self.remove = true
        print("ball outside or touching segment")
    end

    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    
end

function Ball:render()
    love.graphics.setColor(1,0.1,0.1,1)
    love.graphics.circle('fill', self.x, self.y, self.width/2)
    love.graphics.setColor(1,1,1,1)
end

function Ball:getCollisionDirection(segment,x,y)
    return segment:sideOfSegment(x,y)
end