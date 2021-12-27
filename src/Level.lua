-- require('mobdebug').start()
Level = Class {}

function Level:init(def, stage)
    self.stage = stage
    self.points = {}
    self.player = {}
    self.segments = self:createLevelFromDef(def, stage)
    self.polygon = self:createPolygon()
    self.mesh = poly2mesh(self.points)
end

function Level:update(dt)
    self.mesh = poly2mesh(self.points)
end

function Level:render()
    self:renderBackground()
    self:renderOuterSegments()
end

function Level:renderOuterSegments()
    for k, segment in pairs(self.segments) do segment:render() end
end

function Level:renderBackground()
    love.graphics.draw(gImages[(self.stage % #gImages)], LEVEL_RENDER_OFFSET,
                       LEVEL_RENDER_OFFSET_TOP)
    if self.mesh:type() == "Mesh" then 
        love.graphics.draw(self.mesh, 0, 0) 
    end
end

function Level:createLevelFromDef(def, stage)
    local level = {}
    for i, seg in pairs(def[1].segments) do
        table.insert(level, Segment(seg.p1, seg.p2, seg.width, seg.face) )
    end
    return level
end

function Level:createLevel()
    local level = {
        [1] = Segment({LEVEL_RENDER_OFFSET, LEVEL_RENDER_OFFSET_TOP}, {
            VIRTUAL_WIDTH - LEVEL_RENDER_OFFSET, LEVEL_RENDER_OFFSET_TOP
        }, .5, 'down'),
        [2] = Segment({
            VIRTUAL_WIDTH - LEVEL_RENDER_OFFSET, LEVEL_RENDER_OFFSET_TOP
        }, {
            VIRTUAL_WIDTH - LEVEL_RENDER_OFFSET,
            VIRTUAL_HEIGHT - LEVEL_RENDER_OFFSET
        }, .5, 'left'),
        [3] = Segment({
            VIRTUAL_WIDTH - LEVEL_RENDER_OFFSET,
            VIRTUAL_HEIGHT - LEVEL_RENDER_OFFSET
        }, {LEVEL_RENDER_OFFSET, VIRTUAL_HEIGHT - LEVEL_RENDER_OFFSET}, .5, 'up'),
        [4] = Segment({
            LEVEL_RENDER_OFFSET, VIRTUAL_HEIGHT - LEVEL_RENDER_OFFSET
        }, {LEVEL_RENDER_OFFSET, LEVEL_RENDER_OFFSET_TOP}, .5, 'right')
    }
    -- local level = {
    --     [1] = Segment({LEVEL_RENDER_OFFSET,LEVEL_RENDER_OFFSET_TOP},{VIRTUAL_WIDTH - LEVEL_RENDER_OFFSET, LEVEL_RENDER_OFFSET_TOP},.5),
    --     [2] = Segment({VIRTUAL_WIDTH - LEVEL_RENDER_OFFSET, LEVEL_RENDER_OFFSET_TOP},{VIRTUAL_WIDTH - LEVEL_RENDER_OFFSET, VIRTUAL_HEIGHT - LEVEL_RENDER_OFFSET},.5),
    --     [3] = Segment({VIRTUAL_WIDTH - LEVEL_RENDER_OFFSET, VIRTUAL_HEIGHT - LEVEL_RENDER_OFFSET},{VIRTUAL_WIDTH / 2 + 10, VIRTUAL_HEIGHT - LEVEL_RENDER_OFFSET},.5),
    --     [4] = Segment({VIRTUAL_WIDTH / 2 + 10, VIRTUAL_HEIGHT - LEVEL_RENDER_OFFSET},{VIRTUAL_WIDTH / 2 + 10, VIRTUAL_HEIGHT / 2},.5),        
    --     [5] = Segment({VIRTUAL_WIDTH / 2 + 10, VIRTUAL_HEIGHT / 2},{LEVEL_RENDER_OFFSET,VIRTUAL_HEIGHT / 2},.5),
    --     [6] = Segment({LEVEL_RENDER_OFFSET,VIRTUAL_HEIGHT / 2},{LEVEL_RENDER_OFFSET,LEVEL_RENDER_OFFSET_TOP},.5)
    -- }
    return level
end

function Level:insideBounds2(x, y)
    local shape = love.physics.newPolygonShape(self.polygonPoints)
    return shape:testPoint(x, y)
end

function Level:insideBounds(x, y, segments)
    if not segments then segments = self.segments end

    local up, down, left, right = false
    local upSeg, downSeg, leftSeg, rightSeg = nil

    -- find closest segments
    for i, segment in pairs(segments) do
        -- check raycast on y axis
        if segment.vertical then
            if y <= math.max(segment.firstPointY, segment.secondPointY) and y >=
                math.min(segment.firstPointY, segment.secondPointY) then
                if x <= segment.firstPointX then
                    if not rightSeg then
                        rightSeg = segment
                    elseif math.abs(segment.firstPointX - x) <
                        math.abs(rightSeg.firstPointX - x) then
                        rightSeg = segment
                    end
                else
                    if not leftSeg then
                        leftSeg = segment
                    elseif math.abs(segment.firstPointX - x) <
                        math.abs(leftSeg.firstPointX - x) then
                        leftSeg = segment
                    end
                end
            end
        end
        if segment.horizontal then
            if x <= math.max(segment.firstPointX, segment.secondPointX) and x >=
                math.min(segment.firstPointX, segment.secondPointX) then
                if y <= segment.firstPointY then
                    if not downSeg then
                        downSeg = segment
                    elseif math.abs(segment.firstPointY - y) <
                        math.abs(downSeg.firstPointY - y) then
                        downSeg = segment
                    end
                else
                    if not upSeg then
                        upSeg = segment
                    elseif math.abs(segment.firstPointY - y) <
                        math.abs(upSeg.firstPointY - y) then
                        upSeg = segment
                    end
                end
            end
        end
    end
    if not rightSeg or not leftSeg or not upSeg or not downSeg then
        return false
    end

    if rightSeg.face ~= 'left' or leftSeg.face ~= 'right' or upSeg.face ~=
        'down' or downSeg.face ~= 'up' then return false end
    return true
end

function Level:insideBounds3(x, y)
    x = math.floor(x)
    y = math.floor(y)
    local oddNodes = false
    local j = #self.polygon
    local polygon = self.polygon
    for i = 1, #polygon do
        if (polygon[i].y < y and polygon[j].y >= y or polygon[j].y < y and
            polygon[i].y >= y) then
            if (polygon[i].x + (y - polygon[i].y) /
                (polygon[j].y - polygon[i].y) * (polygon[j].x - polygon[i].x) <
                x) then oddNodes = not oddNodes end
        end
        j = i
    end
    return oddNodes
end

function Level:createPolygon()
    local polygon = {}
    local polygonPoints = {}
    local pointlist = {}
    local j = 1
    for i, segment in ipairs(self.segments) do
        polygon[i] = {}
        polygon[i + 1] = {}
        polygon[i].x, polygon[i].y, polygon[i + 1].x, polygon[i + 1].y =
            segment:segmentToPoints()
        polygonPoints[j] = polygon[i].x
        polygonPoints[j + 1] = polygon[i].y
        polygonPoints[j + 2] = polygon[i + 1].x
        polygonPoints[j + 3] = polygon[i + 1].y

        table.insert(pointlist, polygon[i].x)
        table.insert(pointlist, polygon[i].y)

        j = j + 4
        i = i + 1
    end
    self.polygonPoints = polygonPoints
    self.points = pointlist
    return polygon
end

function Level:pointOnEdge(x, y, segments)
    if not segments then segments = self.segments end
    local margin = 2
    for i, segment in pairs(segments) do
        if segment.vertical then -- vertical line
            if x >= segment.firstPointX - margin and x <= segment.firstPointX +
                margin and y <=
                math.max(segment.firstPointY, segment.secondPointY) and y >=
                math.min(segment.firstPointY, segment.secondPointY) then
                return true
            end
        elseif segment.horizontal then -- horizontal line
            if y >= segment.firstPointY - margin and y <= segment.firstPointY +
                margin and x <=
                math.max(segment.firstPointX, segment.secondPointX) and x >=
                math.min(segment.firstPointX, segment.secondPointX) then
                return true
            end
        end
    end
    return false
end

function Level:getTouchingSegment(x, y)
    local margin = 2
    for i, segment in pairs(self.segments) do
        if segment.vertical then -- vertical line
            if x >= segment.firstPointX - margin and x <= segment.firstPointX +
                margin and y <=
                math.max(segment.firstPointY, segment.secondPointY) and y >=
                math.min(segment.firstPointY, segment.secondPointY) then
                return i, segment
            end
        elseif segment.horizontal then -- horizontal line
            if y >= segment.firstPointY - margin and y <= segment.firstPointY +
                margin and x <=
                math.max(segment.firstPointX, segment.secondPointX) and x >=
                math.min(segment.firstPointX, segment.secondPointX) then
                return i, segment
            end
        end
    end
    return nil
end

function Level:cutLevel()

    local newSegs = self.player.trailSegments
    local startSegi, startSeg = self.player.trailStartSegment[1],
                                self.player.trailStartSegment[2]
    local endSegi, endSeg = self.player.trailFinishSegment[1],
                            self.player.trailFinishSegment[2]
    local first = 0
    local last = 0
    local firstFace = ''

    -- check if it is same start and finish segment
    if startSegi == endSegi then
        -- print("cutlevel same start and end segment: "..tostring(startSegi)..' - '..tostring(endSegi))
        local s = {}
        -- split the start/end segment
        local new = {}
        local split = self.segments[startSegi]:copy()

        newSegs[1]:joinPerpendicular(split)
        newSegs[#newSegs]:joinPerpendicular(split)
        -- print("-- joined perpendicular start and end segment from new segments")
        newSegs[1]:debug()
        newSegs[#newSegs]:debug()
        local previous = #self.segments
        if startSegi > 1 and startSegi < #self.segments then
            previous = startSegi - 1
        end
        local part1, part2, temp = {}
        local inOrder = false
        local j, k = 1, 1
        local insertedNewSegs = false
        -- print("-- Create new segments table")
        -- create the new set of segments
        while k <= #self.segments do
            -- print(" segment to be inserted "..tostring(k))
            if k == startSegi and not insertedNewSegs then
                -- print("Reached the segment being cut")
                -- print_r(self.segments[k])
                -- print("split the segment")
                part1, temp, part2 = self.segments[k]:splitInThreeWithSegments(
                                         newSegs[1], newSegs[#newSegs])
                -- print("part1")
                part1:debug()
                -- print("part2")
                part2:debug()

                -- print("insert first part")
                new[j] = part1
                -- print_r(new)
                j = j + 1
                -- insert new segs
                -- print("-- insert new segments into new set")
                for i, segment in pairs(newSegs) do
                    if i + 1 < #newSegs then
                        newSegs[i + 1]:joinPerpendicular(segment)
                    end
                    new[j] = segment:copy()
                    j = j + 1
                end
                insertedNewSegments = true
                new[j] = part2
                j = j + 1
                -- print_r(new)
                -- print("-- finished inserting new segments and parts")
            else
                new[j] = self.segments[k]:copy()
                j = j + 1
            end
            k = k + 1
        end

        -- print("order segments in cutlevel same start and end segment")
        new = self:orderSegments(new)
        -- print_r(new)
        -- print("calculate faces")
        self:calculateSegmentFaces(new, new[1].face)
        -- print_r(new)
        self.segments = new
    else
        -- create two set of segments, one to one side of the cut, one to the other
        local board1 = {}
        local board2 = {}

        -- create first board
        local k = 1
        local j = 1
        local last = #self.segments
        local insertedNewSegments = false
        local savedStart, savedEnd = {}
        local board2StartSegi, board2EndSegi = 0
        -- create first board
        while k <= #self.segments do
            -- print("-----start Loop for "..tostring(k).."-----")
            if k == startSegi and not insertedNewSegments then
                board2StartSegi = k
                -- print("-- this segment is the start segment and not inserted new segments yet") 
                -- print("newsegs[1] is joined perpendicular to k segment:")              
                newSegs[1]:debug()
                newSegs[1]:joinPerpendicular(self.segments[k])
                newSegs[1]:debug()
                -- print("newSegs[1] is joined -- finished")
                local startPart1, startPart2 =
                    self.segments[k]:splitInTwoWithSegment(newSegs[1])
                -- print("-- Segment k split into 2 segments by newsegs[1]: ")
                startPart1:debug()
                startPart2:debug()

                if self.segments[last]:endEqualsStartOf(self.segments[k]) or
                    self.segments[last]:startEqualsStartOf(self.segments[k]) then -- last one is linked to the start of this one
                    -- keep first part of segment
                    -- print("-- keep first part of the k segment")
                    self.segments[k] = startPart1
                    savedStart = startPart2
                else -- keep second part of the segment (which is the first one touching the last segment)
                    -- print("-- keep second part of the k segment")
                    self.segments[k] = startPart2
                    savedStart = startPart1
                end

                board1[j] = self.segments[k]
                j = j + 1

                -- print("-- before checking for inserted new segments - Board1")
                -- print_r(board1)
                if not insertedNewSegments then
                    k = endSegi -- skip to last segment to cut and insert it as well  
                    last = k - 1
                    board2EndSegi = k
                    newSegs[#newSegs]:joinPerpendicular(self.segments[k])

                    -- print("-- not inserted items, proceed to insert in order new segments")
                    for i, newseg in ipairs(newSegs) do
                        board1[j] = newseg:copy()
                        j = j + 1
                    end
                    -- print_r(board1)

                    local endPart1, endPart2 =
                        self.segments[k]:splitInTwoWithSegment(newSegs[#newSegs])
                    -- print("-- proceed to insert the second split segment")
                    if self.segments[last]:endEqualsEndOf(self.segments[k]) or
                        self.segments[last]:startEqualsEndOf(self.segments[k]) then -- next one is linked to the start of this one
                        self.segments[k] = endPart1
                        savedEnd = endPart2
                        -- print("-- keep first part of the k segment")
                    else
                        self.segments[k] = endPart2
                        savedEnd = endPart1
                        -- print("-- keep second part of the k segment")
                    end

                    board1[j] = self.segments[k]:copy()
                    j = j + 1
                    -- print_r(board1)
                    insertedNewSegments = true
                end
            elseif k == endSegi and not insertedNewSegments then
                board2StartSegi = k
                -- print("-- this segment is the end segment and not inserted new segments yet") 
                -- print("newsegs[#newSegs] is joined perpendicular to k segment:")              
                newSegs[#newSegs]:debug()
                newSegs[#newSegs]:joinPerpendicular(self.segments[k])
                newSegs[#newSegs]:debug()
                -- print("newSegs[#newSegs] is joined -- finished")
                local endPart1, endPart2 =
                    self.segments[k]:splitInTwoWithSegment(newSegs[#newSegs])
                -- print("-- Segment k split into 2 segments by newsegs[#newSegs]: ")
                endPart1:debug()
                endPart2:debug()

                if self.segments[last]:endEqualsStartOf(self.segments[k]) or
                    self.segments[last]:startEqualsStartOf(self.segments[k]) then -- last one is linked to the start of this one
                    -- keep first part of segment
                    self.segments[k] = endPart1
                    savedEnd = endPart2
                else -- keep second part of the segment (which is the first one touching the last segment)
                    self.segments[k] = endPart2
                    savedEnd = endPart1
                end

                board1[j] = self.segments[k]
                j = j + 1

                if not insertedNewSegments then
                    k = startSegi -- skip to last segment to cut and insert it as well  
                    last = k - 1
                    board2EndSegi = k
                    newSegs[1]:joinPerpendicular(self.segments[k])
                    -- print("-- not inserted items, proceed to insert in reverse order new segments")

                    local i = #newSegs
                    while i >= 1 do
                        board1[j] = newSegs[i]:copy()
                        board1[j]:switchDirection()
                        j = j + 1
                        i = i - 1
                    end
                    -- print_r(board1)

                    local startPart1, startPart2 =
                        self.segments[k]:splitInTwoWithSegment(newSegs[1])
                    -- print("-- Segment k split into 2 segments by newsegs[1]: ")
                    startPart1:debug()
                    startPart2:debug()

                    if self.segments[last]:endEqualsEndOf(self.segments[k]) or
                        self.segments[last]:startEqualsEndOf(self.segments[k]) then -- next one is linked to the start of this one
                        self.segments[k] = startPart1
                        savedstart = startPart2
                    else
                        self.segments[k] = startPart2
                        savedStart = startPart1
                    end

                    board1[j] = self.segments[k]:copy()
                    j = j + 1
                    -- print_r(board1)
                    insertedNewSegments = true
                end

            elseif k ~= startSegi and k ~= endSegi then
                board1[j] = self.segments[k]:copy()
                j = j + 1
            end

            last = k
            k = k + 1
        end
        -- print("order segments in cutlevel board1")
        board1 = self:orderSegments(board1)
        self:calculateSegmentFaces(board1, board1[1].face)
        -- print("PREPARE BOARD 1 -- FINAL")
        -- print_r(board1)

        -- create second board
        -- print('---- Create Second board from '..tostring(board2StartSegi)..' to '..tostring(board2EndSegi))
        j = 1
        if board2StartSegi < board2EndSegi then
            board2[j] = savedStart
            j = j + 1
            -- print_r(board2)

            -- print('-- inserted first segment, proceed with skipped segments in first board, start < end')
            k = board2StartSegi + 1

            while k < board2EndSegi do
                board2[j] = self.segments[k]:copy()
                k = k + 1
                j = j + 1
            end
            -- print_r(board2)
            -- print('-- inserted original skipped segments')
            board2[j] = savedEnd
            -- print('-- inserted saved end segment')
            -- print_r(board2)
            j = j + 1
            -- insert new segments in order
            -- print("-- proceed to insert in order new segments")
            for i, newseg in ipairs(newSegs) do
                board2[j] = newseg:copy()
                j = j + 1
            end
            -- print_r(board2)

        else
            -- print('-- inserted first segment, proceed with skipped segments in first board, end < start')
            board2[j] = savedEnd
            j = j + 1
            -- print('inserted saved end')
            -- print_r(board2)

            k = board2EndSegi + 1
            -- print('-- insert the skipped segments')
            while k < board2StartSegi do
                board2[j] = self.segments[k]:copy()
                k = k + 1
                j = j + 1
            end
            -- print_r(board2)
            -- print('insert the saved start segment')
            -- insert new segments reverse order
            board2[j] = savedStart
            j = j + 1
            -- print_r(board2)
            -- print('-- insert the new segments in reverse order')
            local i = #newSegs
            while i >= 1 do
                board2[j] = newSegs[i]:copy()
                board2[j]:switchDirection()
                j = j + 1
                i = i - 1
            end
            -- print('-- inserted new segments, final board2 before ordering')
            -- print_r(board2)
        end

        -- print("order segments in cutlevel board2")
        board2 = self:orderSegments(board2)
        self:calculateSegmentFaces(board2, board2[1].face)
        -- print("PREPARE BOARD 2 -- FINAL")
        -- print_r(board2)

        if self:containsBalls(board1) == 0 then
            self.segments = board2
        elseif self:containsBalls(board2) == 0 then
            self.segments = board1
        else
            self.segments = self:getPerimeter(board1) >
                                self:getPerimeter(board2) and board1 or board2
        end
    end

    self:createPolygon()
    self.mesh = poly2mesh(self.points)
end

function Level:orderSegments(segs)
    -- returns the list of segments in the level linked to each other in order and perpendicular to each other
    local new = {}
    -- -- print('----- order Segments : ')
    -- print_s(segs)

    new[1] = segs[1]
    table.remove(segs, 1)

    local found = false
    local k = #segs
    local i = 1
    while i <= k do
        -- -- print('----- segment i = '..tostring(i) .. '#segs '..tostring(#segs))
        -- print_s(new)
        -- -- print(' --new search')
        -- print_s(segs)
        for j, s in ipairs(segs) do
            -- -- print("test if j is next segment to i, j = "..tostring(j))
            if new[i]:endEqualsStartOf(s) then
                found = true

                -- -- print("new[i] end equals start of ")
                -- s:debug()
                if new[i].vertical == s.vertical and new[i].horizontal ==
                    s.horizontal then
                    -- -- print("join contiguous "..tostring(i).. 'with'..tostring(j))
                    new[i]:joinContiguous(s)
                    table.remove(segs, j)
                    i = i - 1
                    k = k - 1
                    break
                else
                    -- -- print("join perpendicular "..tostring(i).. 'with'..tostring(j))
                    s:joinPerpendicular(new[i])
                    new[i + 1] = s
                    table.remove(segs, j)
                    break
                end
            elseif new[i]:endEqualsEndOf(s) then
                found = true

                -- -- print("new[i] end equals end of ")
                -- s:debug()
                s:switchDirection()
                if new[i].vertical == s.vertical and new[i].horizontal ==
                    s.horizontal then
                    -- -- print("join contiguous "..tostring(i).. 'with'..tostring(j))
                    new[i]:joinContiguous(s)
                    table.remove(segs, j)
                    i = i - 1
                    k = k - 1
                    break
                else
                    -- -- print("join perpendicular "..tostring(i).. 'with'..tostring(j))
                    s:joinPerpendicular(new[i])
                    new[i + 1] = s
                    table.remove(segs, j)
                    break
                end
            end
        end

        local fi, fs = 0, {}

        if not found then
            -- -- print("search didnt yield any segment")
            local margin = 2
            while not found and margin < 5 do
                fi, fs = self:findNearestSegment(new[i].secondPointX,
                                                 new[i].secondPointY, segs,
                                                 margin)

                if not fs then
                    fi, fs = self:findNearestSegment(new[i].firstPointX,
                                                     new[i].firstPointY, segs,
                                                     margin)

                    if not fs then
                        margin = margin + 1
                    else
                        found = true
                    end
                else
                    found = true
                end
            end

            if found then
                if new[i].vertical == fs.vertical then
                    -- -- print("join contiguous "..tostring(i).. 'with'..tostring(fi))
                    new[i]:joinContiguous(fs)
                    table.remove(segs, fi)
                    i = i - 1
                    k = k - 1
                else
                    -- -- print("join perpendicular "..tostring(i).. 'with'..tostring(fi))
                    fs:joinPerpendicular(new[i])
                    new[i + 1] = fs
                    table.remove(segs, fi)
                end
            end
        end
        if not found then
            -- print("ERROR -- order segments does not find next segment to ")
            new[i]:debug("number: " .. tostring(i))
            break
        else
            found = false
        end

        i = i + 1
    end
    -- -- print("finished ordering: #new " ..tostring(#new))
    return new
end

function Level:calculateSegmentFaces(segments, firstFace)
    -- start segment, end segment, list of segments to calculate faces for (when cutting the map)
    local face = firstFace
    for k, s in ipairs(segments) do
        s.face = face
        if k + 1 <= #segments then
            if face == 'up' then
                if s.direction == 'right' then
                    if segments[k + 1].direction == 'up' then
                        face = 'left'
                    else
                        face = 'right'
                    end
                else
                    if segments[k + 1].direction == 'up' then
                        face = 'right'
                    else
                        face = 'left'
                    end
                end
            elseif face == 'down' then
                if s.direction == 'right' then
                    if segments[k + 1].direction == 'up' then
                        face = 'right'
                    else
                        face = 'left'
                    end
                else
                    if segments[k + 1].direction == 'up' then
                        face = 'left'
                    else
                        face = 'right'
                    end
                end
            elseif face == 'right' then
                if s.direction == 'up' then
                    if segments[k + 1].direction == 'right' then
                        face = 'down'
                    else
                        face = 'up'
                    end
                else
                    if segments[k + 1].direction == 'right' then
                        face = 'up'
                    else
                        face = 'down'
                    end
                end
            elseif face == 'left' then
                if s.direction == 'up' then
                    if segments[k + 1].direction == 'right' then
                        face = 'up'
                    else
                        face = 'down'
                    end
                else
                    if segments[k + 1].direction == 'right' then
                        face = 'down'
                    else
                        face = 'up'
                    end
                end
            end
        end
    end
end

function Level:getPerimeter(segments)
    local p = 0
    if not segments then segments = self.segments end
    for k, s in pairs(segments) do p = p + s:length() end
    return p
end

function Level:findNearestSegment(x, y, segments, margin)
    if not segments then segments = self.segments end
    if not margin then margin = 2 end
    -- find a touching segment within margins
    for i, segment in pairs(segments) do
        if segment.vertical then -- vertical line
            if x >= segment.firstPointX - margin and x <= segment.firstPointX +
                margin and y <=
                math.max(segment.firstPointY, segment.secondPointY) and y >=
                math.min(segment.firstPointY, segment.secondPointY) then
                return i, segment
            end
        elseif segment.horizontal then -- horizontal line
            if y >= segment.firstPointY - margin and y <= segment.firstPointY +
                margin and x <=
                math.max(segment.firstPointX, segment.secondPointX) and x >=
                math.min(segment.firstPointX, segment.secondPointX) then
                return i, segment
            end
        end
    end
    return nil, nil
end

function Level:containsBalls(segments)
    -- returns numbere of balls inside the bounds passed in or self.segments
    if not segments then segments = self.segments end
    local counter = 0

    for k, b in pairs(self.balls) do
        if self:insideBounds(b.x + 4, b.y + 4, segments) or
            self:pointOnEdge(b.x + 4, b.y + 4, seegments) then
            counter = counter + 1
        end
    end
    return counter
end
