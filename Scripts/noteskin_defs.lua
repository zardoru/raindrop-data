require "utils"
require "librd"

-- Auxiliary variables.
--[[
    Key1 = C4,
    Key2 = C1,
    Key3 = C2,
    Key4 = C3,
    Key5 = C2,
    Key6 = C1,
    Key7 = C4,
]]

NoteImage1 = "VSRG/note5.png"
NoteImage2 = "VSRG/note3.png"
NoteImage3 = "VSRG/note2.png"
NoteImage4 = "VSRG/note1.png"
NoteImage5 = "VSRG/note4.png"
NoteImage6 = "VSRG/note6.png"
NoteImageHold1 = "VSRG/note5L.png"
NoteImageHold2 = "VSRG/note3L.png"
NoteImageHold3 = "VSRG/note2L.png"
NoteImageHold4 = "VSRG/note1L.png"
NoteImageHold5 = "VSRG/note4L.png"
NoteImageHold6 = "VSRG/note6L.png"

GearStartX = 300

Channels1Sizes = {
    84
}

Channels4Sizes = {
    100,
    100,
    100,
    100
}

Channels5Sizes = {
    100,
    90,
    100,
    90,
    100
}

Channels6Sizes = {
    80,
    80,
    80,
    80,
    80,
    80
}

Channels7Sizes = {
    70,
    70,
    70,
    80,
    70,
    70,
    70
}

Channels8Sizes = {
    70,
    70,
    70,
    70,
    70,
    70,
    70,
    70
}

Channels9Sizes = {
    70,
    70,
    70,
    70,
    70,
    70,
    70,
    70,
    70
}

Channels10Sizes = {
    56,
    56,
    56,
    56,
    56,
    56,
    56,
    56,
    56,
    56
}

Channels12Sizes = {
    56 * 5,
    56,
    56,
    56,
    56,
    56,
    56 * 5,
    56,
    56,
    56,
    56,
    56
}

Channels16Sizes = {
    42,
    42,
    42,
    42,
    42,
    42,
    42,
    42,
    42,
    42,
    42,
    42,
    42,
    42,
    42,
    42
}

Channels6SizesSpecial = {}
Channels8SizesSpecial = {}
for k, v in ipairs(Channels8Sizes) do
    if k == 1 then
        Channels6SizesSpecial[k] = Channels6Sizes[k] * 1.3
        Channels8SizesSpecial[k] = v * 1.3
    else
        Channels6SizesSpecial[k] = Channels6Sizes[k]
        Channels8SizesSpecial[k] = v
    end
end

Channels1Positions = {}
Channels4Positions = {}
Channels5Positions = {}
Channels6Positions = {}
Channels6PositionsSpecial = {}
Channels7Positions = {}
Channels8Positions = {}
Channels8PositionsSpecial = {}
Channels9Positions = {}
Channels10Positions = {}
Channels12Positions = {}
Channels16Positions = {}

Sizeup(Channels1Positions, Channels1Sizes, 1)
Sizeup(Channels4Positions, Channels4Sizes, 4)
Sizeup(Channels5Positions, Channels5Sizes, 5)

Sizeup(Channels6PositionsSpecial, Channels6SizesSpecial, 6)
Sizeup(Channels6Positions, Channels6Sizes, 6)

Sizeup(Channels7Positions, Channels7Sizes, 7)

Sizeup(Channels8PositionsSpecial, Channels8SizesSpecial, 8)
Sizeup(Channels8Positions, Channels8Sizes, 8)

Sizeup(Channels9Positions, Channels9Sizes, 9)
Sizeup(Channels10Positions, Channels10Sizes, 10)

-- Sizeup(Channels12Positions, Channels12Sizes, 12)
-- special treatment for channels12
local ch12Pos = GearStartX + 56 / 2
GearWidthByChannels[12] = 56 * 10
local ch12lanes = { 2, 3, 4, 5, 6, 8, 9, 10, 11, 12 }
for k, v in ipairs(ch12lanes) do
    Channels12Positions[v] = ch12Pos
    ch12Pos = ch12Pos + 56
end

Channels12Positions[1] = Channels12Positions[2] + 56 * 4 / 2
Channels12Positions[7] = Channels12Positions[8] + 56 * 4 / 2

Sizeup(Channels16Positions, Channels16Sizes, 16)

Special8KWidth = sum(Channels8SizesSpecial)
Special6KWidth = sum(Channels6SizesSpecial)

GearHeightCommon = 80

-- Actual channels configuration.
-- Lane X positions are always centered.
--

C1 = "key5.png"
C1D = "key5d.png"
C2 = "key3.png"
C2D = "key3d.png"
C3 = "key2.png"
C3D = "key2d.png"
C4 = "key1.png"
C4D = "key1d.png"
C5 = "key4.png"
C5D = "key4d.png"

-- Channels16 is, of course, DP.
Channels16 = {
    -- Gear bindings

    Key1 = C3, -- scratch channel on the left side
    Key2 = C1,
    Key3 = C2,
    Key4 = C1,
    Key5 = C2,
    Key6 = C1,
    Key7 = C2,
    Key8 = C1,

    Key9 = C3, -- scratch channel on the right side
    Key10 = C4,
    Key11 = C5,
    Key12 = C4,
    Key13 = C5,
    Key14 = C4,
    Key15 = C5,
    Key16 = C4,


    Key1Down = C3D, -- scratch channel on the left side
    Key2Down = C1D,
    Key3Down = C2D,
    Key4Down = C1D,
    Key5Down = C2D,
    Key6Down = C1D,
    Key7Down = C2D,
    Key8Down = C1D,

    Key9Down = C3D, -- scratch channel on the right side
    Key10Down = C4D,
    Key11Down = C5D,
    Key12Down = C4D,
    Key13Down = C5D,
    Key14Down = C4D,
    Key15Down = C5D,
    Key16Down = C4D,

    GearHeight = GearHeightCommon,
    GearWidth = GearWidthByChannels[16],
    GearStartX = GearStartX,
    NoteHeight = 40,
    BarlineWidth = GearWidthByChannels[16],

    -- Note Images
    Key1Image = NoteImage3,
    Key2Image = NoteImage1,
    Key3Image = NoteImage2,
    Key4Image = NoteImage1,
    Key5Image = NoteImage2,
    Key6Image = NoteImage1,
    Key7Image = NoteImage2,
    Key8Image = NoteImage1,

    Key9Image = NoteImage3,
    Key10Image = NoteImage4,
    Key11Image = NoteImage5,
    Key12Image = NoteImage4,
    Key13Image = NoteImage5,
    Key14Image = NoteImage4,
    Key15Image = NoteImage5,
    Key16Image = NoteImage4,

    -- Hold Bodies
    Key1HoldImage = NoteImageHold3,
    Key2HoldImage = NoteImageHold1,
    Key3HoldImage = NoteImageHold2,
    Key4HoldImage = NoteImageHold1,
    Key5HoldImage = NoteImageHold2,
    Key6HoldImage = NoteImageHold1,
    Key7HoldImage = NoteImageHold2,
    Key8HoldImage = NoteImageHold1,

    Key9HoldImage = NoteImageHold3,
    Key10HoldImage = NoteImageHold4,
    Key11HoldImage = NoteImageHold5,
    Key12HoldImage = NoteImageHold4,
    Key13HoldImage = NoteImageHold5,
    Key14HoldImage = NoteImageHold4,
    Key15HoldImage = NoteImageHold5,
    Key16HoldImage = NoteImageHold4,

    -- Lane positions
    Key1X = Channels16Positions[1],
    Key2X = Channels16Positions[2],
    Key3X = Channels16Positions[3],
    Key4X = Channels16Positions[4],
    Key5X = Channels16Positions[5],
    Key6X = Channels16Positions[6],
    Key7X = Channels16Positions[7],
    Key8X = Channels16Positions[8],

    Key9X = Channels16Positions[16],
    Key10X = Channels16Positions[9],
    Key11X = Channels16Positions[10],
    Key12X = Channels16Positions[11],
    Key13X = Channels16Positions[12],
    Key14X = Channels16Positions[13],
    Key15X = Channels16Positions[14],
    Key16X = Channels16Positions[15],

    -- Lane Widths
    Key1Width = Channels16Sizes[1],
    Key2Width = Channels16Sizes[2],
    Key3Width = Channels16Sizes[3],
    Key4Width = Channels16Sizes[4],
    Key5Width = Channels16Sizes[5],
    Key6Width = Channels16Sizes[6],
    Key7Width = Channels16Sizes[7],
    Key8Width = Channels16Sizes[8],
    Key9Width = Channels16Sizes[16],
    Key10Width = Channels16Sizes[10],
    Key11Width = Channels16Sizes[11],
    Key12Width = Channels16Sizes[12],
    Key13Width = Channels16Sizes[13],
    Key14Width = Channels16Sizes[14],
    Key15Width = Channels16Sizes[15],
    Key16Width = Channels16Sizes[9]
}

-- Channels12 is of course, 5k DP.
Channels12 = {
    -- Gear bindings
    Key1 = "", -- scratch channel on the left side
    Key2 = C5,
    Key3 = C4,
    Key4 = C3,
    Key5 = C4,
    Key6 = C2,

    Key7 = "", -- scratch channel on the right side
    Key8 = C1,
    Key9 = C4,
    Key10 = C3,
    Key11 = C4,
    Key12 = C5,

    Key1Down = "", -- scratch channel on the left side
    Key2Down = C5D,
    Key3Down = C4D,
    Key4Down = C3D,
    Key5Down = C4D,
    Key6Down = C2D,

    Key7Down = "", -- scratch channel on the right side
    Key8Down = C1D,
    Key9Down = C4D,
    Key10Down = C3D,
    Key11Down = C4D,
    Key12Down = C5D,

    GearHeight = GearHeightCommon,
    GearWidth = GearWidthByChannels[12],
    GearStartX = GearStartX,
    NoteHeight = 40,
    BarlineWidth = GearWidthByChannels[12],

    -- Note Images
    Key1Image = NoteImage6,
    Key2Image = NoteImage5,
    Key3Image = NoteImage4,
    Key4Image = NoteImage3,
    Key5Image = NoteImage4,
    Key6Image = NoteImage2,

    Key7Image = NoteImage6,
    Key8Image = NoteImage1,
    Key9Image = NoteImage4,
    Key10Image = NoteImage3,
    Key11Image = NoteImage4,
    Key12Image = NoteImage5,

    -- Hold Bodies
    Key1HoldImage = NoteImageHold6,
    Key2HoldImage = NoteImageHold5,
    Key3HoldImage = NoteImageHold4,
    Key4HoldImage = NoteImageHold3,
    Key5HoldImage = NoteImageHold4,
    Key6HoldImage = NoteImageHold2,

    Key7HoldImage = NoteImageHold6,
    Key8HoldImage = NoteImageHold1,
    Key9HoldImage = NoteImageHold4,
    Key10HoldImage = NoteImageHold3,
    Key11HoldImage = NoteImageHold4,
    Key12HoldImage = NoteImageHold5,

    -- Lane positions
    Key1X = Channels12Positions[1],
    Key2X = Channels12Positions[2],
    Key3X = Channels12Positions[3],
    Key4X = Channels12Positions[4],
    Key5X = Channels12Positions[5],
    Key6X = Channels12Positions[6],

    Key7X = Channels12Positions[7],
    Key8X = Channels12Positions[8],
    Key9X = Channels12Positions[9],
    Key10X = Channels12Positions[10],
    Key11X = Channels12Positions[11],
    Key12X = Channels12Positions[12],

    -- Lane Widths
    Key1Width = Channels12Sizes[1],
    Key2Width = Channels12Sizes[2],
    Key3Width = Channels12Sizes[3],
    Key4Width = Channels12Sizes[4],
    Key5Width = Channels12Sizes[5],
    Key6Width = Channels12Sizes[6],
    Key7Width = Channels12Sizes[7],
    Key8Width = Channels12Sizes[8],
    Key9Width = Channels12Sizes[9],
    Key10Width = Channels12Sizes[10],
    Key11Width = Channels12Sizes[11],
    Key12Width = Channels12Sizes[12]
}

-- Channels10 is of course, 5k DP.
Channels10 = {
    -- Gear bindings
    Key1 = C5,
    Key2 = C4,
    Key3 = C3,
    Key4 = C4,
    Key5 = C2,

    Key6 = C1,
    Key7 = C4,
    Key8 = C3,
    Key9 = C4,
    Key10 = C5,

    Key1Down = C5D,
    Key2Down = C4D,
    Key3Down = C3D,
    Key4Down = C4D,
    Key5Down = C2D,

    Key6Down = C1D,
    Key7Down = C4D,
    Key8Down = C3D,
    Key9Down = C4D,
    Key10Down = C5D,

    GearHeight = GearHeightCommon,
    GearWidth = GearWidthByChannels[12],
    GearStartX = GearStartX,
    NoteHeight = 40,
    BarlineWidth = GearWidthByChannels[12],

    -- Note Images
    Key1Image = NoteImage5,
    Key2Image = NoteImage4,
    Key3Image = NoteImage3,
    Key4Image = NoteImage4,
    Key5Image = NoteImage2,

    Key6Image = NoteImage1,
    Key7Image = NoteImage4,
    Key8Image = NoteImage3,
    Key9Image = NoteImage4,
    Key10Image = NoteImage5,

    -- Hold Bodies
    Key1HoldImage = NoteImageHold5,
    Key2HoldImage = NoteImageHold4,
    Key3HoldImage = NoteImageHold3,
    Key4HoldImage = NoteImageHold4,
    Key5HoldImage = NoteImageHold2,

    Key6HoldImage = NoteImageHold1,
    Key7HoldImage = NoteImageHold4,
    Key8HoldImage = NoteImageHold3,
    Key9HoldImage = NoteImageHold4,
    Key10HoldImage = NoteImageHold5,

    -- Lane positions
    Key1X = Channels10Positions[1],
    Key2X = Channels10Positions[2],
    Key3X = Channels10Positions[3],
    Key4X = Channels10Positions[4],
    Key5X = Channels10Positions[5],

    Key6X = Channels10Positions[6],
    Key8X = Channels10Positions[8],
    Key7X = Channels10Positions[7],
    Key9X = Channels10Positions[9],
    Key10X = Channels10Positions[10],

    -- Lane Widths
    Key1Width = Channels10Sizes[1],
    Key2Width = Channels10Sizes[2],
    Key3Width = Channels10Sizes[3],
    Key4Width = Channels10Sizes[4],
    Key5Width = Channels10Sizes[5],
    Key6Width = Channels10Sizes[6],
    Key7Width = Channels10Sizes[7],
    Key8Width = Channels10Sizes[8],
    Key9Width = Channels10Sizes[9],
    Key10Width = Channels10Sizes[10],
}


-- Channels9 is, by default, pop'n like.
Channels9 = {
    Key1 = C4,
    Key2 = C1,
    Key3 = C2,
    Key4 = C3,
    Key5 = C5,
    Key6 = C3,
    Key7 = C2,
    Key8 = C1,
    Key9 = C4,
    Key1Down = C4D,
    Key2Down = C1D,
    Key3Down = C2D,
    Key4Down = C3D,
    Key5Down = C5D,
    Key6Down = C3D,
    Key7Down = C2D,
    Key8Down = C1D,
    Key9Down = C4D,

    GearHeight = GearHeightCommon,
    GearStartX = GearStartX,
    NoteHeight = 40,
    GearWidth = GearWidthByChannels[9],
    BarlineWidth = GearWidthByChannels[9],

    -- Note Images
    Key1Image = NoteImage4,
    Key2Image = NoteImage1,
    Key3Image = NoteImage2,
    Key4Image = NoteImage3,
    Key5Image = NoteImage5,
    Key6Image = NoteImage3,
    Key7Image = NoteImage2,
    Key8Image = NoteImage1,
    Key9Image = NoteImage4,

    -- Hold Bodies
    Key1HoldImage = NoteImageHold4,
    Key2HoldImage = NoteImageHold1,
    Key3HoldImage = NoteImageHold2,
    Key4HoldImage = NoteImageHold3,
    Key5HoldImage = NoteImageHold5,
    Key6HoldImage = NoteImageHold3,
    Key7HoldImage = NoteImageHold2,
    Key8HoldImage = NoteImageHold1,
    Key9HoldImage = NoteImageHold4,

    -- Lane positions
    Key1X = Channels9Positions[1],
    Key2X = Channels9Positions[2],
    Key3X = Channels9Positions[3],
    Key4X = Channels9Positions[4],
    Key5X = Channels9Positions[5],
    Key6X = Channels9Positions[6],
    Key7X = Channels9Positions[7],
    Key8X = Channels9Positions[8],
    Key9X = Channels9Positions[9],
    -- Lane Widths
    Key1Width = Channels9Sizes[1],
    Key2Width = Channels9Sizes[2],
    Key3Width = Channels9Sizes[3],
    Key4Width = Channels9Sizes[4],
    Key5Width = Channels9Sizes[5],
    Key6Width = Channels9Sizes[6],
    Key7Width = Channels9Sizes[7],
    Key8Width = Channels9Sizes[8],
    Key9Width = Channels9Sizes[9],

}

-- Channels8 is, by default, 7k+1. Key1 is always the scratch channel.
Channels8Special = {
    -- Gear bindings
    Key1 = C5,
    Key2 = C4,
    Key3 = C1,
    Key4 = C2,
    Key5 = C3,
    Key6 = C2,
    Key7 = C1,
    Key8 = C4,
    Key1Down = C5D,
    Key2Down = C4D,
    Key3Down = C1D,
    Key4Down = C2D,
    Key5Down = C3D,
    Key6Down = C2D,
    Key7Down = C1D,
    Key8Down = C4D,

    GearHeight = GearHeightCommon,
    GearStartX = GearStartX,
    NoteHeight = 40,
    GearWidth = Special8KWidth,
    BarlineWidth = Special8KWidth,

    -- Note Images
    Key1Image = NoteImage5,
    Key2Image = NoteImage4,
    Key3Image = NoteImage1,
    Key4Image = NoteImage2,
    Key5Image = NoteImage3,
    Key6Image = NoteImage2,
    Key7Image = NoteImage1,
    Key8Image = NoteImage4,

    -- Hold Bodies
    Key1HoldImage = NoteImageHold5,
    Key2HoldImage = NoteImageHold4,
    Key3HoldImage = NoteImageHold1,
    Key4HoldImage = NoteImageHold2,
    Key5HoldImage = NoteImageHold3,
    Key6HoldImage = NoteImageHold2,
    Key7HoldImage = NoteImageHold1,
    Key8HoldImage = NoteImageHold4,

    -- Lane positions
    Key1X = Channels8PositionsSpecial[1],
    Key2X = Channels8PositionsSpecial[2],
    Key3X = Channels8PositionsSpecial[3],
    Key4X = Channels8PositionsSpecial[4],
    Key5X = Channels8PositionsSpecial[5],
    Key6X = Channels8PositionsSpecial[6],
    Key7X = Channels8PositionsSpecial[7],
    Key8X = Channels8PositionsSpecial[8],

    -- Lane Widths
    Key1Width = Channels8SizesSpecial[1],
    Key2Width = Channels8SizesSpecial[2],
    Key3Width = Channels8SizesSpecial[3],
    Key4Width = Channels8SizesSpecial[4],
    Key5Width = Channels8SizesSpecial[5],
    Key6Width = Channels8SizesSpecial[6],
    Key7Width = Channels8SizesSpecial[7],
    Key8Width = Channels8SizesSpecial[8]
}

Channels8 = {
    -- Gear bindings
    Key1 = C1,
    Key2 = C2,
    Key3 = C3,
    Key4 = C5,
    Key5 = C5,
    Key6 = C3,
    Key7 = C2,
    Key8 = C1,
    Key1Down = C1D,
    Key2Down = C2D,
    Key3Down = C3D,
    Key4Down = C5D,
    Key5Down = C5D,
    Key6Down = C3D,
    Key7Down = C2D,
    Key8Down = C1D,

    GearHeight = GearHeightCommon,
    GearStartX = GearStartX,
    NoteHeight = 40,
    GearWidth = GearWidthByChannels[8],
    BarlineWidth = GearWidthByChannels[8],

    -- Note Images
    Key1Image = NoteImage1,
    Key2Image = NoteImage2,
    Key3Image = NoteImage3,
    Key4Image = NoteImage5,
    Key5Image = NoteImage5,
    Key6Image = NoteImage3,
    Key7Image = NoteImage2,
    Key8Image = NoteImage1,

    -- Hold Bodies
    Key1HoldImage = NoteImageHold1,
    Key2HoldImage = NoteImageHold2,
    Key3HoldImage = NoteImageHold3,
    Key4HoldImage = NoteImageHold5,
    Key5HoldImage = NoteImageHold5,
    Key6HoldImage = NoteImageHold3,
    Key7HoldImage = NoteImageHold2,
    Key8HoldImage = NoteImageHold1,

    -- Lane positions
    Key1X = Channels8Positions[1],
    Key2X = Channels8Positions[2],
    Key3X = Channels8Positions[3],
    Key4X = Channels8Positions[4],
    Key5X = Channels8Positions[5],
    Key6X = Channels8Positions[6],
    Key7X = Channels8Positions[7],
    Key8X = Channels8Positions[8],

    -- Lane Widths
    Key1Width = Channels8Sizes[1],
    Key2Width = Channels8Sizes[2],
    Key3Width = Channels8Sizes[3],
    Key4Width = Channels8Sizes[4],
    Key5Width = Channels8Sizes[5],
    Key6Width = Channels8Sizes[6],
    Key7Width = Channels8Sizes[7],
    Key8Width = Channels8Sizes[8]
}

-- 7 Channels. By default, it's o2jam-like.
Channels7 = {
    -- Gear bindings
    Key1 = C4,
    Key2 = C3,
    Key3 = C4,
    Key4 = C1,
    Key5 = C4,
    Key6 = C3,
    Key7 = C4,
    Key1Down = C4D,
    Key2Down = C3D,
    Key3Down = C4D,
    Key4Down = C1D,
    Key5Down = C4D,
    Key6Down = C3D,
    Key7Down = C4D,

    GearHeight = GearHeightCommon,
    GearStartX = GearStartX,
    NoteHeight = 40,
    GearWidth = GearWidthByChannels[7],
    BarlineWidth = GearWidthByChannels[7],

    -- Note Images
    Key1Image = NoteImage4,
    Key2Image = NoteImage3,
    Key3Image = NoteImage4,
    Key4Image = NoteImage1,
    Key5Image = NoteImage4,
    Key6Image = NoteImage3,
    Key7Image = NoteImage4,

    -- Hold Bodies
    Key1HoldImage = NoteImageHold4,
    Key2HoldImage = NoteImageHold3,
    Key3HoldImage = NoteImageHold4,
    Key4HoldImage = NoteImageHold1,
    Key5HoldImage = NoteImageHold4,
    Key6HoldImage = NoteImageHold3,
    Key7HoldImage = NoteImageHold4,

    -- Lane positions
    Key1X = Channels7Positions[1],
    Key2X = Channels7Positions[2],
    Key3X = Channels7Positions[3],
    Key4X = Channels7Positions[4],
    Key5X = Channels7Positions[5],
    Key6X = Channels7Positions[6],
    Key7X = Channels7Positions[7],

    -- Lane Widths
    Key1Width = Channels7Sizes[1],
    Key2Width = Channels7Sizes[2],
    Key3Width = Channels7Sizes[3],
    Key4Width = Channels7Sizes[4],
    Key5Width = Channels7Sizes[5],
    Key6Width = Channels7Sizes[6],
    Key7Width = Channels7Sizes[7],
}

-- 6 Channels. By default, it's solo-like.
Channels6Special = {
    Key1 = C5,
    Key2 = C1,
    Key3 = C2,
    Key4 = C1,
    Key5 = C2,
    Key6 = C1,
    Key1Down = C5D,
    Key2Down = C1D,
    Key3Down = C2D,
    Key4Down = C1D,
    Key5Down = C2D,
    Key6Down = C1D,
    Key1Image = NoteImage5,
    Key2Image = NoteImage1,
    Key3Image = NoteImage2,
    Key4Image = NoteImage1,
    Key5Image = NoteImage2,
    Key6Image = NoteImage1,
    Key1HoldImage = NoteImageHold5,
    Key2HoldImage = NoteImageHold1,
    Key3HoldImage = NoteImageHold2,
    Key4HoldImage = NoteImageHold1,
    Key5HoldImage = NoteImageHold2,
    Key6HoldImage = NoteImageHold1,

    GearHeight = GearHeightCommon,
    Key1Width = Channels6SizesSpecial[1],
    Key2Width = Channels6SizesSpecial[2],
    Key3Width = Channels6SizesSpecial[3],
    Key4Width = Channels6SizesSpecial[4],
    Key5Width = Channels6SizesSpecial[5],
    Key6Width = Channels6SizesSpecial[6],
    Key1X = Channels6PositionsSpecial[1],
    Key2X = Channels6PositionsSpecial[2],
    Key3X = Channels6PositionsSpecial[3],
    Key4X = Channels6PositionsSpecial[4],
    Key5X = Channels6PositionsSpecial[5],
    Key6X = Channels6PositionsSpecial[6],

    GearWidth = Special6KWidth,
    BarlineWidth = Special6KWidth,
    GearStartX = GearStartX,
    NoteHeight = 40
}

Channels6 = {
    Key1 = C4,
    Key2 = C3,
    Key3 = C4,
    Key4 = C4,
    Key5 = C3,
    Key6 = C4,
    Key1Down = C4D,
    Key2Down = C3D,
    Key3Down = C4D,
    Key4Down = C4D,
    Key5Down = C3D,
    Key6Down = C4D,
    Key1Image = NoteImage4,
    Key2Image = NoteImage3,
    Key3Image = NoteImage4,
    Key4Image = NoteImage4,
    Key5Image = NoteImage3,
    Key6Image = NoteImage4,
    Key1HoldImage = NoteImageHold4,
    Key2HoldImage = NoteImageHold3,
    Key3HoldImage = NoteImageHold4,
    Key4HoldImage = NoteImageHold4,
    Key5HoldImage = NoteImageHold3,
    Key6HoldImage = NoteImageHold4,

    GearHeight = GearHeightCommon,

    Key1Width = Channels6Sizes[1],
    Key2Width = Channels6Sizes[2],
    Key3Width = Channels6Sizes[3],
    Key4Width = Channels6Sizes[4],
    Key5Width = Channels6Sizes[5],
    Key6Width = Channels6Sizes[6],
    Key1X = Channels6Positions[1],
    Key2X = Channels6Positions[2],
    Key3X = Channels6Positions[3],
    Key4X = Channels6Positions[4],
    Key5X = Channels6Positions[5],
    Key6X = Channels6Positions[6],

    GearWidth = GearWidthByChannels[6],
    BarlineWidth = GearWidthByChannels[6],
    GearStartX = GearStartX,
    NoteHeight = 40
}

-- 5 Channels. By default, ez2dj-like.
Channels5 = {
    Key1 = C1,
    Key2 = C2,
    Key3 = C3,
    Key4 = C2,
    Key5 = C1,
    Key1Down = C1D,
    Key2Down = C2D,
    Key3Down = C3D,
    Key4Down = C2D,
    Key5Down = C1D,
    GearHeight = GearHeightCommon,
    Key1Binding = 2,
    Key2Binding = 3,
    Key3Binding = 4,
    Key4Binding = 5,
    Key5Binding = 6,
    Key1Image = NoteImage1,
    Key2Image = NoteImage2,
    Key3Image = NoteImage3,
    Key4Image = NoteImage2,
    Key5Image = NoteImage1,
    Key1HoldImage = NoteImageHold1,
    Key2HoldImage = NoteImageHold2,
    Key3HoldImage = NoteImageHold3,
    Key4HoldImage = NoteImageHold2,
    Key5HoldImage = NoteImageHold1,
    Key1Width = Channels5Sizes[1],
    Key2Width = Channels5Sizes[2],
    Key3Width = Channels5Sizes[3],
    Key4Width = Channels5Sizes[4],
    Key5Width = Channels5Sizes[5],
    Key1X = Channels5Positions[1],
    Key2X = Channels5Positions[2],
    Key3X = Channels5Positions[3],
    Key4X = Channels5Positions[4],
    Key5X = Channels5Positions[5],
    GearWidth = GearWidthByChannels[5],
    BarlineWidth = GearWidthByChannels[5],
    GearStartX = GearStartX,
    NoteHeight = 40
}

-- 4 Channels. By default, it's DJMax-like.
Channels4 = {
    Key1 = C4,
    Key2 = C3,
    Key3 = C3,
    Key4 = C4,
    Key1Down = C4D,
    Key2Down = C3D,
    Key3Down = C3D,
    Key4Down = C4D,
    GearHeight = GearHeightCommon,
    Key1Binding = 2,
    Key2Binding = 3,
    Key3Binding = 5,
    Key4Binding = 6,
    Key1Image = NoteImage4,
    Key2Image = NoteImage3,
    Key3Image = NoteImage3,
    Key4Image = NoteImage4,
    Key1HoldImage = NoteImageHold4,
    Key2HoldImage = NoteImageHold3,
    Key3HoldImage = NoteImageHold3,
    Key4HoldImage = NoteImageHold4,
    Key1Width = Channels4Sizes[1],
    Key2Width = Channels4Sizes[2],
    Key3Width = Channels4Sizes[3],
    Key4Width = Channels4Sizes[4],
    Key1X = Channels4Positions[1],
    Key2X = Channels4Positions[2],
    Key3X = Channels4Positions[3],
    Key4X = Channels4Positions[4],
    GearWidth = GearWidthByChannels[4],
    BarlineWidth = GearWidthByChannels[4],
    GearStartX = GearStartX,
    NoteHeight = 40
}

Channels1 = {
    Key1 = C3,
    Key1Down = C3D,
    GearHeight = GearHeightCommon,
    Key1Binding = 3,
    Key1Image = NoteImage3,
    Key1HoldImage = NoteImageHold3,
    Key1Width = Channels1Sizes[1],
    Key1X = Channels1Positions[1],
    GearWidth = GearWidthByChannels[1],
    BarlineWidth = GearWidthByChannels[1],
    GearStartX = GearStartX,
    NoteHeight = 40
}

Noteskin = {}
Noteskin[1] = Channels1 -- Yes, I'm completely serious. 
Noteskin[4] = Channels4
Noteskin[5] = Channels5
Noteskin[6] = Channels6
Noteskin[7] = Channels7
Noteskin[8] = Channels8
Noteskin[9] = Channels9
Noteskin[10] = Channels10
Noteskin[12] = Channels12
Noteskin[16] = Channels16
Noteskin.__index = Noteskin
NoteskinSpecial = {}
NoteskinSpecial[6] = Channels6Special
NoteskinSpecial[8] = Channels8Special
setmetatable(NoteskinSpecial, Noteskin)

skin_require("custom_defs")
