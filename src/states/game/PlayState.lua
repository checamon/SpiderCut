-- require('mobdebug').start()

PlayState = Class {__includes = BaseState}

function PlayState:init()
    self.name = "PlayState"
    self.stage = 1
    self.level = Level(LEVELS_DEF[1], self.stage)
    self.player = Player(ENTITY_DEFS["player"], self.level)
    self.level.player = self.player
    self.balls = self.level.balls
    self.clock = self.level.clock

    gSounds["music"]:setPitch(1)
    gSounds["music"]:setLooping(true)
    gSounds["music"]:play()
end

function PlayState:enter()
end

function PlayState:update(dt)
    self.level:update(dt)
    self.player:update(dt)
    self:checkEndLevel(self.level)
end

function PlayState:render()
    love.graphics.clear(0, 0, 0, 255 / 255)
    love.graphics.setColor(56 / 255, 56 / 255, 56 / 255, 1)

    love.graphics.setFont(gFonts["small"])
    love.graphics.printf("Score " .. tostring(self.player.score), LEVEL_RENDER_OFFSET, LEVEL_RENDER_OFFSET_TOP/2, VIRTUAL_WIDTH, "left")

    love.graphics.setFont(gFonts["medium"])
    love.graphics.printf("Stage " .. tostring(self.stage), 0, 5, VIRTUAL_WIDTH, "center")

    self.level:render()
    self.player:render()
end

function PlayState:checkEndLevel(level)
    if #self.balls <= 0 then
        -- game over - reset level
        print("game over due to 0 balls")
        self:gameOver()
    end

    -- check perimeter of level, if low enough, create new level move on to the next stage
    if level:getPerimeter() < 500 then
        print("next stage due to perimeter goal reached")
        self:nextStage()
    end

    -- check if clock finished counting limit time
    if self.clock.direction == "up" and self.clock.currentTime * 1 > self.clock.timeLimit then
        print("game over due to time limit reached")
        self:gameOver()
    elseif self.clock.direction == "down" and self.clock.currentTime * 1 <= 0 then
        print("game over due to time limit reached")
        self:gameOver()
    elseif self.clock.direction == "up" and self.clock.currentTime * 1 > self.clock.timeLimit - 10 then
        gSounds["music"]:setPitch(1.25)
    elseif self.clock.direction == "down" and self.clock.currentTime * 1 <= 10 then
        gSounds["music"]:setPitch(1.25)
    end

    -- remove balls outside bounds
    for k, ball in pairs(self.balls) do
        if ball.remove then
            table.remove(self.balls, k)
            self.player.score = self.player.score - 1
        elseif ball.hitPlayer then
            -- check if any ball hit the player trail segments
            print("game over due to player hit by ball")
            self:gameOver()
        end
    end
end

function PlayState:gameOver()
    gStateStack:pop()
    gSounds["music"]:stop()
    gStateStack:push(
        GameOverState(self.player.score),
        function()
        end
    )
end

function PlayState:nextStage()
    gStateStack:push(
        FadeOutState(
            {
                r = 255 / 255,
                g = 255 / 255,
                b = 255 / 255
            },
            1,
            function()
                self.stage = self.stage + 1
                local nextDef = self.stage % (#LEVELS_DEF + 1)
                if nextDef == 0 then nextDef = 1 end
                self.level = Level(LEVELS_DEF[nextDef], self.stage)
                self.balls = self.level.balls
                self.clock = self.level.clock
                self.player:reset()
                self.player.score = self.player.score + self.player.multiplier * #self.balls
                self.player.multiplier = self.player.multiplier + #self.balls
                self.level.player = self.player
                self.player.level = self.level
                gSounds["music"]:stop()
                gSounds["heal"]:play()
                gStateStack:push(
                    FadeOutState(
                        {r = 1 / 255, g = 1 / 255, b = 1 / 255},
                        1,
                        function()
                            gSounds["music"]:setPitch(1)
                            gSounds["music"]:play()
                        end
                    )
                )
            end
        )
    )
end
