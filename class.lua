--[[
	Copyright (c) 2013, Kyle Davis (tm512)

	Permission is hereby granted, free of charge, to any person
	obtaining a copy of this software and associated documentation
	files (the "Software"), to deal in the Software without
	restriction, including without limitation the rights to use,
	copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the
	Software is furnished to do so, subject to the following
	conditions:
	
	The above copyright notice and this permission notice shall be
	included in all copies or substantial portions of the Software.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
	HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
	OTHER DEALINGS IN THE SOFTWARE.
]]--

local function rethack (t, basebak, mtbak, ...)
	-- reset
	t.base = basebak
	setmetatable (t.self, mtbak)

	return ...
end

local function super (t, k)
	return function (self, ...)
		-- backup base class and self metatable
		local basebak = t.base
		local mtbak = getmetatable (t.self)

		-- set the metatable to the base class, so that function calls call from the base class, not inherited
		setmetatable (t.self, t.base)
		-- set our next base class to the base's base class, enabling further super calls
		t.base = t.base.base

		-- this grabs all return values of the function and returns them after doing other necessary stuff
		return rethack (t, basebak, mtbak, basebak [k] (t.self, ...))
	end
end

return function (base)
	local new = { }
	new.__index = new

	function new.new (...)
		local self = { }
		setmetatable (self, new)

		-- setup super
		self.super = setmetatable ({ self = self, base = base }, { __index = super })

		-- call optional init function:
		if (self.init) then
			self:init (...)
		end

		return self
	end

	if (base) then
		new.base = base
		setmetatable (new, { __index = base })
	end

	return new
end
