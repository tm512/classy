local class = require 'class'

-- create a new class, inheriting nothing
local base = class ()

-- define optional constructor function.
-- base.new will call this automatically
function base:init (num)
	self.num = num
end

-- define a function that we can override in a derived class
function base:stuff (a)
	print ("calling from base: " .. self.num + a)
end

local inherit = class (base)

function inherit:init (num, text)
	-- call base:init, using super
	self.super:init (num)
	self.text = text
end

-- override base:stuff
function inherit:stuff (a)
	print ("calling from inherit (" .. self.text .. "): " .. self.num * a)

	-- call base:stuff, using super
	self.super:stuff (a)
end

local a = inherit.new (5, "Hello!")
a:stuff (3)
