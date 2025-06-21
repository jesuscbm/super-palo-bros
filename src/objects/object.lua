local object = {}
object.__index = object

function object:new(...)
    local obj = {}
    setmetatable(obj, self)
    if obj.init then obj:init(...) end
    return obj
end

function object:extend()
    local subclass = {}
    setmetatable(subclass, self)
    subclass.__index = subclass
    return subclass
end

return object
