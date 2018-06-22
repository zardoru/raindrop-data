--- Module to assign a sequence of textures over time to an object
-- @gamemodule FrameInterpolator
game_require "TextureAtlas"

FrameInterpolator = {
	TotalFrames = 0
}

FrameInterpolator.__index = FrameInterpolator

function FrameInterpolator.FilenameAssign(fn)
	return (fn + 1) .. ".png"
end

--- Create a new FrameInterpolator. 
-- @param sprite_file A spritesheet's path. 
-- The maximum N of images is acquired from the number of entries
-- on the spritesheet.
-- @param duration How long the sequence lasts.
-- @param object The gameobject to update.
-- @return A new FrameInterpolator instance.
function FrameInterpolator:new(sprite_file, duration, object)
	local out = {}
	setmetatable(out, self)

	out.SpriteSheet = TextureAtlas:new(GetSkinFile(sprite_file))

	if out.SpriteSheet == nil then
		print "Sprite sheet couldn't be found. Sorry."
		return nil
	end

	out.Object = object or Engine:CreateObject()
	local i = 0
	for k, v in pairs(out.SpriteSheet.Sprites) do
		i = i + 1
	end

	out.TotalFrames = i or 1
	out.Duration = duration or 1

	out.CurrentTime = 0

	out.Object.Texture = out.SpriteSheet.File or "null"

	out:Update(0)

	return out
end

function FrameInterpolator:New(sprite_file, duration, object)
	print "[warning] FrameInterpolator:New is deprecated. Prefer the consistently named FrameInterpolator:new."
	return self:new(sprite_file, duration, object)
end

function FrameInterpolator:GetFrameAtFrac(frac)
	local Frame = math.floor(frac * (self.TotalFrames - 1))
	return Frame
end

function FrameInterpolator:SetFraction(frac)
	local fn = self.FilenameAssign(self:GetFrameAtFrac(frac))
	self.SpriteSheet:SetObjectCrop(self.Object, fn)
end

function FrameInterpolator:GetLerp()
	return clamp(self.CurrentTime / self.Duration, 0, 1)
end

--- Update the object's current texture according to time.
-- Every time it changes from 1.png to N.png, mapping 0 to 1.png
-- and the previously set duration to N.png.
-- @param delta The change in time from the last frame.
function FrameInterpolator:Update(delta)
	self.CurrentTime = self.CurrentTime + delta
	self:SetFraction(self:GetLerp())
end
