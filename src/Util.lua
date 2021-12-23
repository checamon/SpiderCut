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
    -- remove duplicates???
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
