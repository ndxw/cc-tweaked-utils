--[[
rectangle is relative to initial heading
turtle starts in bottom left corner and travels clockwise
ensure turtle has 16 stacks of sand before running
]]

print("Turtle usage:\n\t- Rectangle is relative to initial heading: turtle starts in bottom left corner and travels CW\n\t- Ensure sufficient materials in chest\nDo you acknowledge? (y/N)")
ack = read()

if not (ack == "y") then
    return
end

width = 5
depth = 3
totalTiles = 2 * (width + depth) - 4
-- for width = 5, depth = 3, turning tiles = {3, 7, 9}
turningTiles = {depth, depth + (width-1), depth + (width-1) + (depth-1)}

facing = "E" -- set this value before running

-- initialize GPS information
home = {}
lastPos = {}
lastDir = "E"
homeX, homeY, homeZ = gps.locate()
if homeX == nil then
    print("GPS not working or not set up correctly!")
    return
end
home[1] = homeX
home[2] = homeY
home[3] = homeZ

turtle.select(1)

function selectNext()
    next = turtle.getSelectedSlot()
    turtle.select(math.fmod(next, 16) + 1)
end

-- inertial orientation tracking
function turn (turn)
    if turn == "R" then
        turtle.turnRight()
        if facing == "N" then
            facing = "E"
        elseif facing == "E" then
            facing = "S"
        elseif facing == "S" then
            facing = "W"
        elseif facing == "W" then
            facing = "N"
        end
    elseif turn == "L" then
        turtle.turnLeft()
        if facing == "N" then
            facing = "W"
        elseif facing == "E" then
            facing = "N"
        elseif facing == "S" then
            facing = "E"
        elseif facing == "W" then
            facing = "S"
        end
    end
end

-- absolute move
function goTo (x, y, z)
    xCurr, yCurr, zCurr = gps.locate()
    dx = x - xCurr
    dy = y - yCurr
    dz = z - zCurr

    -- move to the correct y level
    if dy < 0 then
        for i = 1,math.abs(dy) do
            turtle.down()
        end
    else
        for i = 1,math.abs(dy) do
            turtle.up()
        end
    end

    -- move to correct z value

    while not (facing == "S") do
        turn("L")
    end

    if dz < 0 then
        for i = 1,math.abs(dz) do
            turtle.back()
        end
    else
        for i = 1,math.abs(dz) do
            turtle.forward()
        end
    end

    -- move to correct x value
    
    while not (facing == "E") do
        turn("L")
    end

    if dx < 0 then
        for i = 1,math.abs(dx) do
            turtle.back()
        end
    else
        for i = 1,math.abs(dx) do
            turtle.forward()
        end
    end
end

function restock ()
    -- record current position and heading
    currX, currY, currZ = gps.locate()
    lastPos[1] = currX
    lastPos[2] = currY
    lastPos[3] = currZ
    lastDir = facing

    -- go to home
    goTo(home[1], home[2], home[3])

    -- pull items from above chest
    for i = 1,16 do
        turtle.select(i)
        while turtle.getItemSpace() >= 64 do
            result, reason = turtle.suckUp(64)
            if reason == "No items to take" then
                return reason
            end
        end
    end

    -- go to last position and resume
    goTo(lastPos[1], lastPos[2], lastPos[3])
    while not (facing == lastDir) do
        turn("L")
    end
end


-- main loop
tile = 1
while tile <= totalTiles do
    -- check if sufficient materials
    totalMaterialCount = 0
    for i = 1,16 do
        totalMaterialCount = totalMaterialCount + turtle.getItemCount(i)
    end
    if totalMaterialCount == 0 then
        restock()
    end

    -- place
    if turtle.getItemCount(turtle.getSelectedSlot()) == 0 then
        selectNext()
    end

    blockExists, blockInfo = turtle.inspectDown()
    if blockInfo["name"] == "minecraft:water" then
        turtle.placeDown()
    else
        turtle.forward()
        tile = tile + 1
        -- check if the turtle has reached one of the corners and turn if so
        for j = 1,3 do
            if tile == turningTiles[j] then
                turn("R")
                break
            end
        end
    end

end