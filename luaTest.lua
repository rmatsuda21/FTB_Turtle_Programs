-- Written by: thunderdraker
-- 12/12/2020

uselessItem = {"minecraft:cobblestone", "minecraft:stone", "minecraft:dirt", "minecraft:gravel", "minecraft:sand", "minecraft:netherrack"}

dia, iniY = ...
if(dia == nil or iniY == nil) then
	print("Need argument to use...")
	print("Usage: quarry <diameter> <y-level>")
	return
end

posX = 0
posY = 0
posZ = 0
currentRot = 0
prevRot = 0

iniY = tonumber(iniY)-1
dia = tonumber(dia)

function turnRight()
	turtle.turnRight()
	currentRot = ( currentRot + 1 ) % 4
end

function turnLeft()
	turtle.turnLeft()
	currentRot = ( currentRot - 1 ) % 4
end

-- Look toward rotation n
function lookToward(n)
	local i = currentRot
	while i ~= n do
		i = (i + 1) % 4
		turnRight()
	end
end

-- Go back to (0, 0, 0)
function toOrigin()
	prevRot = currentRot
	lookToward(2)
	local i
	for i = posY, 1, -1 do
		turtle.up()
	end
	
	for i = posZ, 1, -1 do
		turtle.forward()
	end
	
	turnLeft()
	for i = posX, 1, -1 do
		turtle.forward()
	end
end

-- Return to previous position before going to origin
function returnToTask()
	lookToward(0)
	local i
	for i = 1, posZ, 1 do
		turtle.forward()
	end
	
	turnRight()
	for i_ = 1, posX, 1 do
		turtle.forward()
	end

	for iniY = 1, posY, 1 do
		turtle.down()
	end
	lookToward(prevRot)
end

-- Drops inventory
-- If not at origin when this is called, items will be dropped where the turtle currently is
function emptyInv() 
	local i
	for i = 2, 16, 1 do
		turtle.select(i)
		turtle.drop()
	end
end

-- Goes to origin and grabs more fuel
function getMoreFuel()
	toOrigin()
	
	-- lookToward(2)
	emptyInv()
	
	-- lookToward(3)
	turnRight()
	turtle.select(1)
	while turtle.suck() == false do
		term.clear()
		term.setCursorPos(1,1)
		io.write("Please add more fuel to Turtle and Fuel Chest")
	end
	emptyInv() -- This is to remove any excess charcoal/fuel that is sucked

	returnToTask()
end

-- Checks if we have enough fuel to return to origin to refuel
function checkFuel()
	while turtle.getFuelLevel() <= posX + posY + posZ + 1 do
		turtle.select(1)
		turtle.refuel()

		if turtle.getItemCount() <= 1 then
			getMoreFuel()
		end
	end
end

-- Check inventory and remove useless items
-- If inventory is full, go to origin and store and refuel
function checkInv()
	local full = true
	local i, k
	for i = 2, 16, 1 do
		turtle.select(i)
		if turtle.getItemCount() > 0 then
			for k = 1, #uselessItem - 1, 1 do
				if turtle.getItemDetail().name == uselessItem[k] then
					turtle.drop()
					full = false
					break
				end
			end 
		else
			full = false
		end
	end

	if full then
		getMoreFuel()
	end
end

-- Digs straight and cleans inventory
function digStraight()
	checkFuel()

	turtle.dig()
	if turtle.detect() == true then
		turtle.dig()
	end
	turtle.forward()
	turtle.digDown()
	turtle.digUp()

	if currentRot == 0 then
		posZ = posZ + 1
	elseif currentRot == 2 then
		posZ = posZ - 1
	elseif currentRot == 1 then
		posX = posX + 1
	elseif currentRot == 3 then
		posX = posX - 1
	end

	checkInv()
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

	local i, j
	while posY < iniY - 1 do
		for i = 1, dia, 1 do
			for j = 1, dia - 1, 1 do
				digStraight()
			end

			print(i)
			if i ~= dia then
				print(i)
				print(dia)
				if i % 2 == 1 then
					turnRight()
				else
					turnLeft()
				end
				
				digStraight()
				
				if i % 2 == 1 then
					turnRight()
				else
					turnLeft()
				end
			end
		end

		turtle.down()
		turtle.digDown()
		turtle.down()
		turtle.digDown()
		turtle.down()
		turtle.digDown()

		posY = posY + 3

		if dia % 2 == 0 then
			turnRight()
		else
			turnRight()
			turnRight()
		end
	end
end

quarry()