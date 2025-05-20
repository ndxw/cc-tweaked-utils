local args = {...}
destX = tonumber(args[1])
destY = tonumber(args[2])
destZ = tonumber(args[3])

facing = "E" -- set this value before running

home = {}
x, y, z = gps.locate()
if x == nil then
    print("GPS not working or not set up correctly!")
    return
end
home[1] = x
home[2] = y
home[3] = z

lastPos = {}

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

goTo(destX, destY, destZ)