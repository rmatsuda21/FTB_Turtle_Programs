-- Written by: thunderdraker
-- 12/12/2020

dia, iniY = ...
if(dia == nil or iniY == nil) then
	print("Need argument to use...")
	print("Usage: quarry <diameter> <y-level>")
	return
end

posX = 0
posY = 0
posZ = 0
rot = 0
iniY = tonumber(iniY)-1

-- Look toward rotation n
function lookToward(n)
	local i = rot
	while i ~= n do
		i = (i + 1) % 4
		turtle.turnRight()
	end
end

-- Go back to (0, 0, 0)
function toOrigin()
	lookToward(2)
	for _ = posY, 1, -1 do
		turtle.up()
	end
	
	for _ = posZ, 1, -1 do
		turtle.forward()
	end
	
	turtle.turnLeft()
	for _ = posX, 1, -1 do
		turtle.forward()
	end
end

-- Return to previous position before going to origin
function returnToTask()
	lookToward(0)
	for _ = 1, posZ, 1 do
		turtle.forward()
	end
	
	turtle.turnRight()
	for _ = 1, posX, 1 do
		turtle.forward()
	end

	for _ = 1, posY, 1 do
		turtle.down()
	end
	lookToward(rot)
end

-- Drops inventory
-- If not at origin when this is called, items will be dropped where the turtle currently is
function emptyInv() 
	for i = 2, 16, 1 do
		turtle.select(i)
		turtle.drop()
	end
end

function getMoreFuel()
	toOrigin()
	
	lookToward(2)
	emptyInv()
	
	lookToward(3)
	turtle.suck()
	emptyInv() -- This is to remove any excess charcoal/fuel that is sucked

	returnToTask()
end

function checkFuel()
	local fLevel = turtle.getFuelLevel();
	if fLevel <= posX + posY + posZ + 1 then
		turtle.select(1)
		turtle.refuel()

		if turtle.getItemCount() <= 1 then
			getMoreFuel()
		end
	end
end

function dig()
	
end

function quarry()
	checkFuel()
	-- Initialize turtle position
	turtle.digDown()
	turtle.down()
	turtle.digDown()
	turtle.down()
	turtle.digDown()
	posY = 2

	while posY < iniY - 1 do
		for i = 1, dia, 1 do
			for j = 1, dia, 1 do
				
			end
		end
	end
end

quarry()