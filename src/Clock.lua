Clock = Class {}

function Clock:init(timelimit, direction)
    self.timeLimit = timelimit
    self.direction = direction
    self.color = {56 / 255, 56 / 255, 56 / 255, 1}
    self.currentTime = ""
    self.timer = 0
    self.startTime = self:getOsTime()
end

function Clock:update(dt)
    local passed = math.floor((self:getOsTime() - self.startTime) * 10 + 0.5)
    if self.direction == 'down' then
        self.currentTime = tostring(self.timeLimit - passed)
    else
        self.currentTime = tostring(passed)
    end
end

function Clock:render()
    TODO TODO
    if self.currentTime * 1 <= 10 then
        local a = math.abs(math.cos(love.timer.getTime() * .85 % 2 * math.pi))
        love.graphics.setColor(.8, .12, .12, a)
    else
        love.graphics.setColor(self.color[1], self.color[2], self.color[3],
                               self.color[4])
    end
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Time: ' .. self.currentTime, 0, 5, VIRTUAL_WIDTH,
                         'right')
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(1, 1, 1, 1)
end

function Clock:getOsTime() return os.clock() end
