local brick = require("src.objects.brick")

local lines = io.lines("map.txt")
if lines == nil then
	return nil
end

local bricks = {}

local i = 0
for line in lines do
	for j = 1, #line do
		if line:sub(j, j) == "#" then
			bricks[#bricks + 1] = brick:new(Game.playing.world, 128 * (j - 1), 128 * (i - 1))
		end
	end
	i = i + 1
end

return bricks
