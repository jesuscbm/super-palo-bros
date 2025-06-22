local elements = {}
local brick = require("src.objects.brick")
local cheese = require("src.objects.cheese")
local mill = require("src.objects.mill")

local lines = io.lines("map.txt")
if lines == nil then
	return nil
end

elements.bricks = {}
elements.cheese = {}
elements.mills = {}

local i = 0
for line in lines do
	for j = 1, #line do
		local c = line:sub(j, j)
		if c == "#" then
			elements.bricks[#elements.bricks + 1] = brick:new(Game.playing.world, 128 * (j - 1), 128 * (i - 1))
		elseif c == "$" then
			elements.cheese[#elements.cheese + 1] = cheese:new(Game.playing.world, 128 * (j - 1), 128 * (i - 1))
		elseif c == "o" then
			elements.mills[#elements.mills + 1] = mill:new(Game.playing.world, 128 * (j - 1), 128 * (i - 1))
		end
	end
	i = i + 1
end

return elements
