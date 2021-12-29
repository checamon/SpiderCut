-- require('mobdebug').start()
--[[
    Given an "atlas" (a texture with multiple sprites), as well as a
    width and a height for the tiles therein, split the texture into
    all of the quads by simply dividing it evenly.
]] function GenerateQuads(atlas, tilewidth, tileheight)
    local sheetWidth = atlas:getWidth() / tilewidth
    local sheetHeight = atlas:getHeight() / tileheight

    local sheetCounter = 1
    local spritesheet = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            spritesheet[sheetCounter] = love.graphics.newQuad(x * tilewidth,
                                                              y * tileheight,
                                                              tilewidth,
                                                              tileheight,
                                                              atlas:getDimensions())
            sheetCounter = sheetCounter + 1
        end
    end

    return spritesheet
end

--[[
    Recursive table printing function.
    https://coronalabs.com/blog/2014/09/02/tutorial-printing-table-contents/
]]
function print_r(t)
    local print_r_cache = {}
    local function sub_print_r(t, indent)
        if (print_r_cache[tostring(t)]) then
            print(indent .. "*" .. tostring(t))
        else
            print_r_cache[tostring(t)] = true
            if (type(t) == "table") then
                for pos, val in pairs(t) do
                    if (type(val) == "table") then
                        print(indent .. "[" .. pos .. "] => " .. tostring(t) ..
                                  " {")
                        sub_print_r(val, indent ..
                                        string.rep(" ", string.len(pos) + 8))
                        print(indent .. string.rep(" ", string.len(pos) + 6) ..
                                  "}")
                    elseif (type(val) == "string") then
                        print(indent .. "[" .. pos .. '] => "' .. val .. '"')
                    else
                        print(indent .. "[" .. pos .. "] => " .. tostring(val))
                    end
                end
            else
                print(indent .. tostring(t))
            end
        end
    end
    if (type(t) == "table") then
        print(tostring(t) .. " {")
        sub_print_r(t, "  ")
        print("}")
    else
        sub_print_r(t, "  ")
    end
    print()
end

function math.round(x, precision) return x + precision - (x + precision) % 1 end

function print_s(segments)
    for k, s in ipairs(segments) do s:debug(tostring(k)) end
end

-- convert a list of points forming a polygon {x1, y1, x2, y2, ...} into a mesh

function poly2mesh(points)
    -- print("util - poly2mesh: ")
    -- print_r(points)
    if #points > 2 then
        local polypts = love.math.triangulate(points)
        local tlist

        local vnums = {}
        local vcoords = {}
        do
            local verthash = {}
            local n = 0
            local v
            -- use unique vertices by using a coordinate hash table
            for i = 1, #polypts do
                for j = 1, 3 do
                    local px = polypts[i][j * 2 - 1]
                    local py = polypts[i][j * 2]
                    if not verthash[px] then
                        verthash[px] = {}
                    end
                    if not verthash[px][py] then
                        n = n + 1
                        verthash[px][py] = n
                        vcoords[n * 2 - 1] = px
                        vcoords[n * 2] = py
                        v = n
                    else
                        v = verthash[px][py]
                    end
                    vnums[(i - 1) * 3 + j] = v
                end
            end
        end
        local mesh = love.graphics.newMesh(#vcoords, "triangles", "static")
        for i = 1, #vcoords / 2 do
            local x, y = vcoords[i * 2 - 1], vcoords[i * 2]

            -- Here's where the UVs are assigned
            mesh:setVertex(i, x, y, x / 50, y / 50, .5, .5, .9, 1)
        end
        mesh:setVertexMap(vnums)
        return mesh
    else
        return nil
    end
end

-- point in shape calculation
function PointWithinShape(shape, tx, ty)
	if #shape == 0 then 
		return false
	elseif #shape == 1 then 
		return shape[1].x == tx and shape[1].y == ty
	elseif #shape == 2 then 
		return PointWithinLine(shape, tx, ty)
	else 
		return CrossingsMultiplyTest(shape, tx, ty)
	end
end

function BoundingBox(box, tx, ty)
	return	(box[2].x >= tx and box[2].y >= ty)
		and (box[1].x <= tx and box[1].y <= ty)
		or  (box[1].x >= tx and box[2].y >= ty)
		and (box[2].x <= tx and box[1].y <= ty)
end

function colinear(line, x, y, e)
	e = e or 0.1
	m = (line[2].y - line[1].y) / (line[2].x - line[1].x)
	local function f(x) return line[1].y + m*(x - line[1].x) end
	return math.abs(y - f(x)) <= e
end

function PointWithinLine(line, tx, ty, e)
	e = e or 0.66
	if BoundingBox(line, tx, ty) then
		return colinear(line, tx, ty, e)
	else
		return false
	end
end

-------------------------------------------------------------------------
-- The following function is based off code from
-- [ http://erich.realtimerendering.com/ptinpoly/ ]
--
--[[
 ======= Crossings Multiply algorithm ===================================
 * This version is usually somewhat faster than the original published in
 * Graphics Gems IV; by turning the division for testing the X axis crossing
 * into a tricky multiplication test this part of the test became faster,
 * which had the additional effect of making the test for "both to left or
 * both to right" a bit slower for triangles than simply computing the
 * intersection each time.  The main increase is in triangle testing speed,
 * which was about 15% faster; all other polygon complexities were pretty much
 * the same as before.  On machines where division is very expensive (not the
 * case on the HP 9000 series on which I tested) this test should be much
 * faster overall than the old code.  Your mileage may (in fact, will) vary,
 * depending on the machine and the test data, but in general I believe this
 * code is both shorter and faster.  This test was inspired by unpublished
 * Graphics Gems submitted by Joseph Samosky and Mark Haigh-Hutchinson.
 * Related work by Samosky is in:
 *
 * Samosky, Joseph, "SectionView: A system for interactively specifying and
 * visualizing sections through three-dimensional medical image data",
 * M.S. Thesis, Department of Electrical Engineering and Computer Science,
 * Massachusetts Institute of Technology, 1993.
 *
 --]]

--[[ Shoot a test ray along +X axis.  The strategy is to compare vertex Y values
 * to the testing point's Y and quickly discard edges which are entirely to one
 * side of the test ray.  Note that CONVEX and WINDING code can be added as
 * for the CrossingsTest() code; it is left out here for clarity.
 *
 * Input 2D polygon _pgon_ with _numverts_ number of vertices and test point
 * _point_, returns 1 if inside, 0 if outside.
 --]]
function CrossingsMultiplyTest(pgon, tx, ty)
	local i, yflag0, yflag1, inside_flag
	local vtx0, vtx1
	
	local numverts = #pgon

	vtx0 = pgon[numverts]
	vtx1 = pgon[1]

	-- get test bit for above/below X axis
	yflag0 = ( vtx0.y >= ty )
	inside_flag = false
	
	for i=2,numverts+1 do
		yflag1 = ( vtx1.y >= ty )
	
		--[[ Check if endpoints straddle (are on opposite sides) of X axis
		 * (i.e. the Y's differ); if so, +X ray could intersect this edge.
		 * The old test also checked whether the endpoints are both to the
		 * right or to the left of the test point.  However, given the faster
		 * intersection point computation used below, this test was found to
		 * be a break-even proposition for most polygons and a loser for
		 * triangles (where 50% or more of the edges which survive this test
		 * will cross quadrants and so have to have the X intersection computed
		 * anyway).  I credit Joseph Samosky with inspiring me to try dropping
		 * the "both left or both right" part of my code.
		 --]]
		if ( yflag0 ~= yflag1 ) then
			--[[ Check intersection of pgon segment with +X ray.
			 * Note if >= point's X; if so, the ray hits it.
			 * The division operation is avoided for the ">=" test by checking
			 * the sign of the first vertex wrto the test point; idea inspired
			 * by Joseph Samosky's and Mark Haigh-Hutchinson's different
			 * polygon inclusion tests.
			 --]]
			if ( ((vtx1.y - ty) * (vtx0.x - vtx1.x) >= (vtx1.x - tx) * (vtx0.y - vtx1.y)) == yflag1 ) then
				inside_flag =  not inside_flag
			end
		end

		-- Move to the next pair of vertices, retaining info as possible.
		yflag0  = yflag1
		vtx0    = vtx1
		vtx1    = pgon[i]
	end

	return  inside_flag
end

function GetIntersect( points )
	local g1 = points[1].x
	local h1 = points[1].y
	
	local g2 = points[2].x
	local h2 = points[2].y
	
	local i1 = points[3].x
	local j1 = points[3].y

	local i2 = points[4].x
	local j2 = points[4].y
	
	local xk = 0
	local yk = 0
	
	if checkIntersect({x=g1, y=h1}, {x=g2, y=h2}, {x=i1, y=j1}, {x=i2, y=j2}) then
		local a = h2-h1
		local b = (g2-g1)
		local v = ((h2-h1)*g1) - ((g2-g1)*h1)

		local d = i2-i1
		local c = (j2-j1)
		local w = ((j2-j1)*i1) - ((i2-i1)*j1)

		xk = (1/((a*d)-(b*c))) * ((d*v)-(b*w))
		yk = (-1/((a*d)-(b*c))) * ((a*w)-(c*v))
	end
	return xk, yk
end