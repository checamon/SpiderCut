-- require('mobdebug').start()

PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.name = 'PlayState'
    self.stage = 1
    self.level = Level(self.stage)
    self.player = Player ( ENTITY_DEFS['player'] , self.level)
    self.level.player = self.player
    self.balls = {}
    self:createBalls()
    self.level.balls = self.balls

    gSounds['music']:setLooping(true)
    gSounds['music']:play()

end

function PlayState:enter()
end

function PlayState:update(dt)
    self.level:update(dt)
    self.player:update(dt)
    self:updateBalls(dt, self.level)
    self:checkEndLevel(self.level)
end

function PlayState:render()
    love.graphics.clear(0, 0, 0, 255/255)    
    love.graphics.setColor(40/255, 45/255, 52/255,255/255)

    love.graphics.setFont(gFonts['small'])
    love.graphics.printf('Score '..tostring(self.player.score), 
        0, 5, VIRTUAL_WIDTH, 'left')

    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Stage '..tostring(self.stage), 
        0, 5, VIRTUAL_WIDTH, 'center')

    self.level:render()
    self.player:render()
    self:renderBalls(dt)
end

function PlayState:createBalls()
    self.balls = {}

    for i = 1, self.stage do
        table.insert(self.balls,Ball(
            math.random(LEVEL_RENDER_OFFSET + 5, VIRTUAL_WIDTH - LEVEL_RENDER_OFFSET - 5), --X
            math.random(LEVEL_RENDER_OFFSET_TOP + 5, VIRTUAL_HEIGHT - LEVEL_RENDER_OFFSET - 5), --Y
            math.random(20,90),math.random(20,90) -- speed
        ))
    end
end

function PlayState:updateBalls(dt, level)
    for k,ball in pairs(self.balls) do
        ball:update(dt,level)
    end
    -- remove balls outside bounds
    for k,ball in pairs(self.balls) do
        if ball.remove then
            table.remove(self.balls,k)
            self.player.score = self.player.score - 1
        elseif ball.hitPlayer then
            -- check if any ball hit the player trail segments
            self:gameOver()
        end        
    end

end

function PlayState:checkEndLevel (level)
    if #self.balls <= 0 then
        -- game over - reset level
        self:gameOver()
    end

    -- check perimeter of level, if low enough, create new level move on to the next stage
    if level:getPerimeter() < 500 then
        self:nextStage()
    end
end

function PlayState:renderBalls(dt)
    for k,ball in pairs(self.balls) do
        ball:render()
    end
end

function PlayState:gameOver()
    gStateStack:pop()
    gSounds['music']:stop()
    gStateStack:push(GameOverState(self.player.score),function() end)
end

function PlayState:nextStage()
    gStateStack:push(FadeOutState({
        r = 255/255, g = 255/255, b = 255/255}, 1,function()
        self.stage = self.stage + 1
        self.level = Level(self.stage)
        self.player:reset()
        self.player.score = self.player.score + self.player.multiplier * #self.balls
        self.player.multiplier = self.player.multiplier + #self.balls
        self.balls = {}
        self:createBalls()
        self.level.player = self.player
        self.player.level = self.level
        self.level.balls = self.balls
        gSounds['music']:stop()
        gSounds['heal']:play()        
        gStateStack:push(FadeOutState({r = 1/255, g = 1/255, b = 1/255}, 1,function()
            gSounds['music']:play()
        end))
    end))
end