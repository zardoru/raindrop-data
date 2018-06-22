--- A module to ease creation of a medium amount of objects 
-- @gamemodule FixedObjects
game_require "librd"

FixedObjects = { 
--- Multiply width and X coordinates by this. 1 by default.
-- @modvar XRatio
	XRatio = 1, 
--- Multiply height and Y coordinates by this. 1 by default.
-- @modvar YRatio
	YRatio = 1
}
--- Create a new object from the given parameters.
-- If a field has "text" instead of a value, it'll be replaced by constants["text"].
-- @param tbl An array of arrays that follow a structure of Tex,Name,X,Y,Z,Rot,Sx,Sy
-- @param constants A table defining constants for use in each of these fields. 
function FixedObjects:CreateObjectFromParameters(tbl, constants)
	local Object = Engine:CreateObject()

	print("Create object " .. tbl[2])

	local name = tbl[2]
	-- table.dump(constants)
	Object.Texture = constants[tbl[1]] or tbl[1] or 0
	with (Object, {
		X = (constants[tbl[3]] or tbl[3] or 0) * self.XRatio,
		Y = (constants[tbl[4]] or tbl[4] or 0) * self.YRatio,
		Width = (constants[tbl[5]] or tbl[5] or 1) * self.XRatio,
		Height = (constants[tbl[6]] or tbl[6] or 1) * self.YRatio,
		Layer = constants[tbl[7]] or tbl[7] or Object.Layer,
		Rotation = constants[tbl[9]] or tbl[9] or 0,
		ScaleX = constants[tbl[10]] or tbl[10] or 1,
		ScaleY = constants[tbl[11]] or tbl[11] or 1
	})

	-- Object.Centered = constants[tbl[8]] or tbl[8] or 0
	self.Sprites[name] = Object
end

--- Create game objects from a CSV file. The CSV file must follow
-- the structure of CreateObjectFromParameters.
-- @param file A filename to read from. Read relative to skin directory.
-- @param constants A table of constants to pass to CreateObjectFromParameters.
function FixedObjects:CreateFromCSV(file, constants)
	local File = io.open(GetSkinFile(file))
	print ("Opening " .. GetSkinFile(file))

	constants = constants or {}

	if File == nil then
		return
	end

	for line in File:lines() do
		if line[1] ~= "#" then -- Not a comment
			local tbl = string.split(line)
			if tbl then
				-- table.dump(tbl)
				self:CreateObjectFromParameters(tbl, constants)
			end
		end
	end

	io.close(File)
end

function FixedObjects:new()
	local ret = {}
	ret.Sprites = {}
	setmetatable(ret, self)
	return ret
end

FixedObjects.__index = FixedObjects

return FixedObjects
