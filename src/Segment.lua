-- require('mobdebug').start()
Segment = Class {}

local symbols = {['up'] = 207, ['down'] = 209, ['right'] = 199, ['left'] = 182}

function Segment:init(firstPoint, secondPoint, lineWidth, face, color)
    self.firstPointX = firstPoint[1]
    self.firstPointY = firstPoint[2]
    self.secondPointX = secondPoint[1]
    self.secondPointY = secondPoint[2]
    self.lineWidth = lineWidth or 3
    self.vertical = self.firstPointX == self.secondPointX
    self.horizontal = self.firstPointY == self.secondPointY
    self.face = face or ''
    self.direction = self:calculateDirection()
    self.color = color or {r = 255, g = 255, b = 255}
end

function Segment:render()
    love.graphics.setColor(self.color.r, self.color.g, self.color.b, 255)
    love.graphics.setLineWidth(self.lineWidth)
    love.graphics.line(self.firstPointX, self.firstPointY, self.secondPointX,
                       self.secondPointY)

    love.graphics.setColor(255, 255, 255, 255)

    -- debug
    -- love.graphics.setFont(gFonts['small'])
    -- love.graphics.printf(self.face,self.firstPointX + 2, self.firstPointY + 2 / 2,25,'left' )

end

function Segment:segmentToPoints()
    return self.firstPointX, self.firstPointY, self.secondPointX,
           self.secondPointY
end

function Segment:length()
    return math.sqrt((self.secondPointX - self.firstPointX) *
                         (self.secondPointX - self.firstPointX) +
                         (self.secondPointY - self.firstPointY) *
                         (self.secondPointY - self.firstPointY))
end

function Segment:sideOfSegment(x, y)
    if y < self.firstPointY and y < self.secondPointY then -- above
        return 'up'
    end
    if y > self.firstPointY and y > self.secondPointY then -- below
        return 'down'
    end
    if x < self.firstPointX and x < self.secondPointX then -- left
        return 'left'
    end
    if x > self.firstPointX and x > self.secondPointX then -- right
        return 'right'
    end

end

function Segment:debug(msg)
    if not msg then msg = '' end
    -- print("Segment:debug ".. msg .." ...............")
    -- print("FirstPoint: "..tostring(self.firstPointX)..','..tostring(self.firstPointY))
    -- print("SecondPoint: "..tostring(self.secondPointX)..','..tostring(self.secondPointY))
    -- print("face: "..self.face.. ' - Direction: '..self.direction)
end

function Segment:copy()
    local copy = {}
    copy.firstPointX = self.firstPointX
    copy.firstPointY = self.firstPointY
    copy.secondPointX = self.secondPointX
    copy.secondPointY = self.secondPointY
    copy.lineWidth = self.lineWidth
    copy.face = self.face
    return Segment({copy.firstPointX, copy.firstPointY},
                   {copy.secondPointX, copy.secondPointY}, copy.lineWidth,
                   copy.face)
end

function Segment:endEqualsStartOf(s)
    -- segments are linked at the end of this one
    if self.secondPointX == s.firstPointX and self.secondPointY == s.firstPointY then
        return true
    end
    return false
end
function Segment:endEqualsEndOf(s)
    -- segments are linked at the end of this one
    if self.secondPointX == s.secondPointX and self.secondPointY ==
        s.secondPointY then return true end
    return false
end

function Segment:startEqualsEndOf(s)
    -- segments are linked at the beginning of this one
    if self.firstPointX == s.secondPointX and self.firstPointY == s.secondPointY then
        return true
    end
    return false
end
function Segment:startEqualsStartOf(s)
    -- segments are linked at the beginning of this one
    if self.firstPointX == s.firstPointX and self.firstPointY == s.PointY then
        return true
    end
    return false
end

function Segment:calculateDirection()
    local dir = ''

    if self.vertical then
        if self.firstPointY < self.secondPointY then
            dir = 'down'
        else
            dir = 'up'
        end
    else
        if self.firstPointX < self.secondPointX then
            dir = 'right'
        else
            dir = 'left'
        end
    end
    return dir
end

function Segment:splitInTwoWithPoint(point) -- number
    local s1, s2 = {}
    if point > 0 then
        if self.vertical then
            s1 = Segment({self.firstPointX, self.firstPointY},
                         {self.secondPointX, point}, self.lineWidth, self.face)
            s2 = Segment({self.firstPointX, point},
                         {self.secondPointX, self.secondPointY}, self.lineWidth,
                         self.face)
        else
            s1 = Segment({self.firstPointX, self.firstPointY},
                         {point, self.secondPointY}, self.lineWidth, self.face)
            s2 = Segment({point, self.firstPointY},
                         {self.secondPointX, self.secondPointY}, self.lineWidth,
                         self.face)
        end
    else
        return nil, nil
    end

    return s1, s2
end

function Segment:splitInTwoWithSegment(segment)
    local point = 0
    if self.vertical then
        if self.firstPointY == segment.firstPointY then
            point = segment.firstPointY
        else
            point = segment.secondPointY
        end
    elseif self.horizontal then
        if self.firstPointX == segment.firstPointX then
            point = segment.firstPointX
        else
            point = segment.secondPointX
        end
    end

    return self:splitInTwoWithPoint(point)
end

function Segment:joinPerpendicular(s)
    -- changes the self, not the parameter
    if s.vertical then
        local sx = s.firstPointX
        if math.abs(self.firstPointX - sx) < math.abs(self.secondPointX - sx) then
            self.firstPointX = sx
        else
            self.secondPointX = sx
        end
    else
        local sy = s.firstPointY
        if math.abs(self.firstPointY - sy) < math.abs(self.secondPointY - sy) then
            self.firstPointY = sy
        else
            self.secondPointY = sy
        end
    end
end

function Segment:switchDirection()
    local temp = {}
    temp.firstPointX = self.firstPointX
    temp.firstPointY = self.firstPointY
    self.firstPointX = self.secondPointX
    self.firstPointY = self.secondPointY
    self.secondPointX = temp.firstPointX
    self.secondPointY = temp.firstPointY
    self:notDirection()
end

function Segment:notDirection()
    if self.direction == 'down' then
        self.direction = 'up'
    elseif self.direction == 'up' then
        self.direction = 'down'
    elseif self.direction == 'right' then
        self.direction = 'left'
    elseif self.direction == 'left' then
        self.direction = 'right'
    end
end

function Segment:notFace()
    if self.face == 'up' then
        self.face = 'down'
    elseif self.face == 'down' then
        self.face = 'up'
    elseif self.face == 'right' then
        self.face = 'left'
    elseif self.face == 'left' then
        self.face = 'right'
    end
end

function Segment:joinContiguous(s)
    -- second segment becomes part of first one
    if self.vertical then
        self.secondPointY = s.secondPointY
    else
        self.secondPointX = s.secondPointX
    end
end

function Segment:compare(s)
    -- returns >0 if self is to the right or below
    -- returns <0 if self is to the left or above
    -- returns 0 if both are same point
    if self.vertical and s.vertical then
        if self.firstPointX == s.firstPointX then
            return 0
        else
            return self.firstPointX - s.firstPointX
        end
    elseif self.horizontal and s.horizontal then
        if self.firstPointY == s.firstPointY then
            return 0
        else
            return self.firstPointY - s.firstPointY
        end
    else
        return (self.firstPointX + self.firstPointY + self.secondPointX +
                   self.secondPointY) -
                   (s.firstPointX + s.firstPointY + s.secondPointX +
                       s.secondPointY)
    end
end

function Segment:splitInThreeWithSegments(s1, s2)
    local p1, p2, p3, t = {}
    if self.direction == 'down' or self.direction == 'right' then
        if s1:compare(s2) < 0 then
            p1, t = self:splitInTwoWithSegment(s1)
            p2, p3 = t:splitInTwoWithSegment(s2)
        else
            p1, t = self:splitInTwoWithSegment(s2)
            p2, p3 = t:splitInTwoWithSegment(s1)
        end
    else
        if s1:compare(s2) < 0 then
            p1, t = self:splitInTwoWithSegment(s2)
            p2, p3 = t:splitInTwoWithSegment(s1)
        else
            p1, t = self:splitInTwoWithSegment(s1)
            p2, p3 = t:splitInTwoWithSegment(s2)
        end
    end

    return p1, p2, p3
end

function Segment:insert(list) end

function Segment:pointInSegment(point)
    -- remove "+ 8" and replace by sprite.width / 2
    if self.direction == 'up' or self.direction == 'down' then
        if point[1] <= self.firstPointX + 1 and point[1] >= self.firstPointX - 1 then
            if self.direction == 'down' then
                if point[2] >= self.firstPointY and point[2] <=
                    self.secondPointY then return true end
            else
                if point[2] >= self.secondPointY and point[2] <=
                    self.firstPointY then return true end
            end
        end
    else
        if point[2] <= self.firstPointY + 1 and point[2] >= self.firstPointY - 1 then
            if self.direction == 'right' then
                if point[1] >= self.firstPointX and point[1] <=
                    self.secondPointX then return true end
            else
                if point[1] >= self.secondPointX and point[1] <=
                    self.firstPointX then return true end
            end
        end
    end

    return false
end
