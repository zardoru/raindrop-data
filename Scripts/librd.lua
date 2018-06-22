--- Module that declares many utilitarian functions
-- @module librd

--- Split the line using the given separator.
-- @param line The text to split.
-- @param[opt] _sep The separator to use. Comma by default.
-- @return An array with the split line.
function split(line, _sep)
    local sep = _sep or ","
	local restable = {}
	local i = 1
	for k in string.gmatch(line, "([^" .. sep .. "]+)") do
		restable[i] = k
		i = i + 1
	end

	return restable
end

string.split = split

floor = math.floor
ceil = math.ceil
sin = math.sin
cos = math.cos
min = math.min
max = math.max
pow = math.pow

--- Clamp value between min and max.
-- @param v The value to clamp.
-- @param mn The Minimum value.
-- @param mx The maximum value.
-- @return The clamped value.
function clamp (v, mn, mx)
    return math.min(math.max(v, mn), mx)
end

--- Return the sign of the given argument. 
-- @param x The value to check for a sign.
-- @return 0 if value is 0, -1 if negative, 1 if positive.
function sign(x)
    if x == 0 then return 0 end
    if x > 0 then return 1 else return -1 end
end

--- Sum all values in the table.
-- @param l The table to sum from.
-- @return The sum of the values.
function sum(l)
	local rt = 0
	for k,v in ipairs(l) do
		rt = rt + v
	end
  return rt
end

--- Join 2 tables into a single table. Leaves both initial tables intact.
-- @param a First table.
-- @param b Second table.
-- @return Joined A and B tables.
table.join = function (a, b)
    local ret = {}
    for k,v in pairs(a) do
        ret[k] = v
    end
    for k,v in pairs(b) do
        ret[k] = v
    end
    return ret
end

--- Prints a table one level deep.
table.dump = function (a)
	print ("a = {")
	for k,v in pairs(a) do
		print (k, "=", v, ",")
	end
	print ("}")
end

--- Lerp a value.
-- @param current Value to map the linear interpolation.
-- @param start Start value for the linear mapping
-- @param finish Finish value for the linear mapping
-- @param startval Value to map start to.
-- @param endval Value to map finish to.
-- @return The lerped value.
function lerp(current, start, finish, startval, endval)
	return (current - start) * (endval - startval) / (finish - start) + startval
end

--- Lerp a value, then clamp between start and end.
-- Order is the same as lerp.
-- @see lerp
function clerp(c, s, f, sv, ev)
	return clamp(lerp(c,s,f,sv,ev), sv, ev)
end

--- Normalized version of lerp.
-- @param r A value between 0 and 1 to use for the interpolation.
-- @param s The value to map 0 to.
-- @param e The value to map 1 to.
-- @return The mixed value.
function mix(r, s, e)
	return lerp(r, 0, 1, s, e)
end

--- Clamped version of mix. Clamps the output.
-- @see mix
function cmix(r, s, e)
	return clerp(r, 0, 1, s, e)
end

--- Get the fractional part of a number
-- @param d The number
-- @return The fractional part of the number
function fract(d)
	return d - floor(d)
end

--- Assign values of t into obj. Assignment order is not guaranteed.
-- The object is modified in-place.
-- @param obj The object to assign the values to.
-- @param t The table with values to map to obj.
-- @return obj, after assignment.
function with(obj, t)
		if type(t) == "table" then
	    for k,v in pairs(t) do
	        obj[k] = v
	    end
		end
    return obj
end

--- Perform action to every element of table. Does not modify original table.
-- @param f Function to apply.
-- @param t Table to apply function to.
function map(f, t)
	local ret = {}
	for k,v in pairs(t) do
		ret[k] = f(v)
	end
	return ret
end

--[[
	Warning: using pairs (underlying on the with)
	does not guarantee order. If you're setting image with
	ScreenObject or with, you could potentially end up
	side effect'd at the wrong order.
]]
function ScreenObject(t)
	local x = Engine:CreateObject()
  return with(x, t)
end

--- Adjust a transform object into a box. Keeps aspect ratio of the transform.
-- The X and Y of the transform as well as scale are adjusted to be centered.
-- The parameters of the adjustment are x, y, w and h.
-- If AdjustByWidth is set on these parameters, the transform will try to fit the object horizontally.
-- Otherwise, it will do so vertically. It will overflow the other dimension depending on what you adjust it to.
-- @param transform The transform to adjust.
-- @param params The parameters of the adjustment.
function AdjustInBox(transform, params)
    params = params or {x = 0, y = 0, w = Screen.Width, h = Screen.Height}
	local x = params.x or 0
	local y = params.y or 0
	local w = params.w or Screen.Width
	local h = params.h or Screen.Height
	local adjustByWidth = params.AdjustByWidth or false
	local oldWidth = transform.Width
	local oldHeight = transform.Height
	local Background = transform or params.Background

	if not Background then return end

	Background.X = x
	Background.Y = y

	local VRatio = h / Background.Height

	if adjustByWidth then 
		VRatio = w / Background.Width
	end

	Background.ScaleX = VRatio
	Background.ScaleY = VRatio

	local modWidth = Background.ScaleX * Background.Width
	local modHeight = Background.ScaleY * Background.Height

	-- Center in box.
	Background.X = x + w / 2 - modWidth / 2
	Background.Y = y + h / 2 - modHeight / 2
end

librd = {
	--- Create a constructor with the following characteristics:
	-- The parameters will be self and a table of values that will be assigned to the object.
	-- The constructor will be called afterwards.
	-- @param t The object to create a 'new' function for.
	-- @param initializer The object's constructor.
	make_new = function (t, initializer)
        assert(initializer)
				t.__index = t
				t.new = function (self, rt)
									local ret = {}
									setmetatable(ret, self)
									with(t, rt)
									initializer(ret)
									return ret
							 end
			return t
		end,
	--- Convert an integer to a table of digits.
	-- @param i The number to convert.
	-- @param base The base to convert to.
	-- @return The table of digits.
	intToDigits = function(i, base)
		local b = base or 10
		local ret = {}
		i = floor(i)
		while i >= 1 do
			local rem = floor(i) % b
			table.insert(ret, 1, rem)
			i = floor(i / 10)
		end
    return ret
	end
}

return librd
