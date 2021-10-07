local DifficultyList = {
    Transform = Transformation(),
    Font = Fonts.TruetypeFont(GetSkinFile("fonts/rounded-mgenplus-1c-light.ttf")),
    Song = nil,
    FontSize = 35,
    ItemDistance = 35,
    DiffNameX = 80,
    DiffNumX = 0,
    DiffChannelsX = 60,
    DifficultyIndex = Wheel.DifficultyIndex,
    DiffCount = 1
}

function DifficultyList:Init()
    self.BgBox = Engine:CreateObject()
    self.SelectBox = Engine:CreateObject()
    self:OnDifficultyUpdate(self.DifficultyIndex)
end

function DifficultyList:RemoveAllObjects(tbl)
    for key, value in pairs(tbl) do
        Engine:RemoveTarget(value)
        tbl[key] = nil
    end
end

function DifficultyList:SetSong(song)
    -- print(song, self.Song)
    if self.Song == song then
        return
    end

    if song == nil then
        self.SelectBox.Alpha = 0
        self.BgBox.Alpha = 0
    else
        if self.DifficultyIndex < song.DifficultyCount then
            self.SelectBox.Alpha = 1
        else
            self.SelectBox.Alpha = 0
        end

        self.BgBox.Alpha = 1
    end

    self.Song = song

    self.Difficulties = {}
    for i = 1, self.Song.DifficultyCount do
        table.insert(self.Difficulties, self.Song:GetDifficulty(i - 1))
    end

    -- remove existing strings
    self.Strings = self.Strings or {}
    self:RemoveAllObjects(self.Strings)

    self.DifficultyNumber = self.DifficultyNumber or {}
    self:RemoveAllObjects(self.DifficultyNumber)

--     self.DifficultyChannels = self.DifficultyNumber or {}
--     self:RemoveAllObjects(self.DifficultyNumber)

    for key, value in pairs(self.Difficulties) do
        local itemY = (key - 1) * self.ItemDistance
        self.Strings           [key] = StringObject2D()
        self.DifficultyNumber  [key] = StringObject2D()
--         self.DifficultyChannels[key] = StringObject2D()

        -- print(key, value.Name, value.Level, value.Channels)

        with(self.Strings[key], {
            Font = self.Font,
            ChainTransformation = self.Transform,
            FontSize = self.FontSize,
            Y = itemY,
            X = self.DiffNameX,
            Text = "(" .. value.Channels .. ") " .. value.Name
        })

        -- print(value.Level)
        with(self.DifficultyNumber[key], {
            Font = self.Font,
            ChainTransformation = self.Transform,
            FontSize = self.FontSize,
            Y = itemY,
            X = self.DiffNumX,
            Text = "Lv." .. value.Level
        })

        -- self.DifficultyNumber[key]

        Engine:AddTarget(self.Strings[key])
        Engine:AddTarget(self.DifficultyNumber[key])
    end

    self.DiffCount = self.Song.DifficultyCount
    self:OnDifficultyUpdate(self.DifficultyIndex)
end

function DifficultyList:OnDifficultyUpdate(i)
    self.DifficultyIndex = i

    self.SelectBox.Texture = "Global/white.png"
    with(self.SelectBox, {
        ChainTransformation = self.Transform,
        Width = 400,
        Height = self.ItemDistance,
        X = 0,
        Y = self.DifficultyIndex * self.ItemDistance + 5,
        Red = 0.5,
        Green = 0.6,
        Blue = 0.05
    })

    self.BgBox.Texture = "Global/white.png"
    local pad = 10
    with(self.BgBox, {
        ChainTransformation = self.Transform,
        Width = 400 + pad * 2,
        Height = max(self.DiffCount, 6) * self.ItemDistance + pad * 3,
        X = -pad,
        Y = -pad,
        Red = 0.1,
        Green = 0.1,
        Blue = 0.05
    })
end

function DifficultyList:Update(dt)
    if Wheel.DifficultyIndex ~= self.DifficultyIndex then
        self.DiffCount = self.Song.DifficultyCount
        self:OnDifficultyUpdate(Wheel.DifficultyIndex)
    end
end

return DifficultyList