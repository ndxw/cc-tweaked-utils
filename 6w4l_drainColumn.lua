print("Turtle usage:\n\t- Turtle must be placed on at (1,0) facing (1,1), the bottom left corner of the water column\n\t- Turtle must be placed with its bottom at water level\n\t- Drains a water column 6 blocks wide and 4 blocks long\nDo you acknowledge? (y/N)")

--[[
ack = read()
if not (ack == "y") then
    return
end
]]

blocksDescended = 0

function ascend()
    for i = 1,blocksDescended do
        turtle.up()
    end
end

function selectNext()
    next = turtle.getSelectedSlot()
    turtle.select(math.fmod(next, 16) + 1)
end

-- navigate to descension block
turtle.turnRight()
turtle.forward()
turtle.forward()
turtle.turnLeft()
turtle.forward()
turtle.forward()

-- main loop
blockBelow, blockInfo = turtle.inspectDown()
while blockInfo["name"] == "minecraft:water" or not blockBelow do
    if math.fmod(blocksDescended, 3) == 0 then
        -- check if sufficient materials
        totalMaterialCount = 0
        for i = 1,16 do
            totalMaterialCount = totalMaterialCount + turtle.getItemCount(i)
        end
        if totalMaterialCount < 2 then
            break
        end
            -- place
        while turtle.getItemCount(turtle.getSelectedSlot()) == 0 do
            selectNext()
        end

        -- place left sponge
        turtle.turnLeft()
        turtle.place()
        turtle.turnRight()
        -- place right sponge
        turtle.turnRight()
        if turtle.forward() then
            turtle.place()
            turtle.back()
        end
        turtle.turnLeft()
    end
    turtle.down()
    blocksDescended = blocksDescended + 1
    blockBelow, blockInfo = turtle.inspectDown()
end

ascend()

-- return home
turtle.back()
turtle.back()
turtle.turnLeft()
turtle.forward()
turtle.forward()
turtle.turnRight()