--- A simple texture atlas.
-- @gamemodule TextureAtlas
game_require "librd"

TextureAtlas = {}
TextureAtlas.__index = TextureAtlas

--- Set the object to use the crop defined by a sprite of this atlas.
-- @param Object The object to apply the crop to.
-- @param Sprite The filename defined in the atlas to set the crop to.
-- @param resize[opt] Whether to resize the object to the size of the crop. Defaults to false.
function TextureAtlas:SetObjectCrop(Object, Sprite, resize)
    local Tab = self.Sprites[Sprite]
    if Tab ~= nil then
        Object:SetCropByPixels(Tab.x, Tab.x + Tab.w, Tab.y, Tab.y + Tab.h)
        if resize then
            Object.Width = Tab.w
            Object.Height = Tab.h
        end
    else
        print("TextureAtlas: ", self.File, " Picture not found: ", Sprite)
        print("Available: ")
        for k, v in pairs(self.Sprites) do
            print("\t", k)
        end
    end
end

function TextureAtlas:AssignFrames(Filename)
    local Atlas = self
    local File = io.open(Filename)

    if File ~= nil then

        for line in File:lines() do
            if Atlas.File == nil then
                Atlas.File = line;
                Atlas.Sprites = {}
            else
                local restable = split(line)

                Sprite = {
                    x = tonumber(restable[2]),
                    y = tonumber(restable[3]),
                    w = tonumber(restable[4]),
                    h = tonumber(restable[5])
                }

                Atlas.Sprites[restable[1]] = Sprite
            end
        end

        io.close(File)
    else
        print("Error opening " .. Filename .. ". Atlas won't be constructed.")
    end
end

--- Create a new texture atlas from a file.
-- The file must be a CSV file 
-- and the first line must be the actual image to read from
-- and every line after is a sprite definition consisting of name, x, y, width and height values.
-- @param filename The path (based off the working directory) to read the CSV from.
-- @return A new TextureAtlas.
function TextureAtlas:new(filename)
    local NewAtlas = {}
    setmetatable(NewAtlas, TextureAtlas)
    NewAtlas:AssignFrames(filename)
    return NewAtlas
end

--- Same as new(), but using a filename relative to the skin directory.
-- @see new
function TextureAtlas:skin_new(filename)
    return self:new(GetSkinFile(filename))
end

return TextureAtlas

