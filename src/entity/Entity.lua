
Entity = Class{}

function Entity:init(def)
    self.direction = 'down'
    self.previousDirection = ''
    self.walkingSpeed = def.walkingSpeed
    self.animations = self:createAnimations(def.animations)
    
    self.currentAnimation = self.animations['idle-down']

    self.stateMachine = StateMachine {
        ['walk'] = function() return EntityWalkState(self) end,
        ['edge'] = function() return EntityWalkEdgeState(self) end,
        ['idle'] = function() return EntityIdleState(self) end
    }
    self.stateMachine:change('idle')
    self.width = def.width
    self.height = def.height

end

function Entity:changeState(name)
    self.stateMachine:change(name)
    -- printChangeState to "..name)
end

-- function Entity:isMoveAllowed(point)
--     return point.x, point.y
-- end

function Entity:changeAnimation(name)
    self.currentAnimation = self.animations[name]
end

function Entity:createAnimations(animations)
    local animationsReturned = {}

    for k, animationDef in pairs(animations) do
        animationsReturned[k] = Animation {
            texture = animationDef.texture or 'entities',
            frames = animationDef.frames,
            interval = animationDef.interval
        }
    end

    return animationsReturned
end

function Entity:processAI(params, dt)
    self.stateMachine:processAI(params, dt)
end

function Entity:update(dt)
    self.currentAnimation:update(dt)
    self.stateMachine:update(dt)
end

function Entity:render()
    self.stateMachine:render()
end