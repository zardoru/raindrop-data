local DifficultyList = {
    Transform = Transformation(),
    DifficultyNamesTransform = Transformation(),
    Font = Fonts.TruetypeFont(GetSkinFile("fonts/rounded-mgenplus-1c-light.ttf")),
    Song = nil,
    FontSize = 35,
    ItemDistance = 35,
    DiffNameX = 80,
    DiffNumX = 0,
    DiffChannelsX = 60,
    DifficultyIndex = Wheel.DifficultyIndex,
    DiffCount = 1,
    TargetStringOffset = Vec2(0, 0),
}

function DifficultyList:Init()
    self.BgBox = Engine:CreateObject()
    self.SelectBox = Engine:CreateObject()
    self.DifficultyNamesTransform.Parent = self.Transform
    self:SetSong(nil)
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

    self.DiffCount = self.Song.DifficultyCount
    self:OnDifficultyUpdate(self.DifficultyIndex)

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
            Parent = self.DifficultyNamesTransform,
            FontSize = self.FontSize,
            Position = Vec2(self.DiffNameX, itemY),
            Text = "(" .. value.Channels .. ") " .. value.Name,
            Scissor = true,
            ScissorRegion = self.Box
        })

        -- print(value.Level)
        with(self.DifficultyNumber[key], {
            Font = self.Font,
            Parent = self.DifficultyNamesTransform,
            FontSize = self.FontSize,
            Position = Vec2(self.DiffNumX, itemY),
            Text = "Lv." .. value.Level,
            Scissor = true,
            ScissorRegion = self.Box
        })

        Engine:AddTarget(self.Strings[key])
        Engine:AddTarget(self.DifficultyNumber[key])
    end
end

function DifficultyList:OnDifficultyUpdate(i)
    -- local deltaDiffIndex = i - self.DifficultyIndex
    self.DifficultyIndex = i

    local idx = clamp(i - 3, 0, max(self.DiffCount - 6, 1))
    -- print(idx)
    self.TargetStringOffset.Y = idx * -self.ItemDistance
    -- print("New Target", self.TargetStringOffset.Y)

    self.Box = AABB(
            self.Transform.X,
            self.Transform.Y,
            self.Transform.X + 400,
            self.Transform.Y + 6 * self.ItemDistance + 5
    )

    self.SelectBox.Texture = "Global/white.png"
    with(self.SelectBox, {
        Parent = self.DifficultyNamesTransform,
        Size = Vec2(400, self.ItemDistance),
        Position = Vec2(0, self.DifficultyIndex * self.ItemDistance + 5),
        Red   = 0.1,
        Green = 0.3,
        Blue  = 0.7,
        Scissor = true,
        ScissorRegion = self.Box
    })

    self.BgBox.Texture = "Global/white.png"
    local pad = 10
    local pos = Vec2(-pad, -pad)
    local size = self.Box.size + Vec2(pad * 2, pad * 3)
    -- print(self.Box.x, self.Box.y, self.Box.x2, self.Box.y2, size.x, size.y)
    with(self.BgBox, {
        Parent = self.Transform,
        Size = size,
        Position = pos,
        Red = 0,
        Green = 0,
        Blue = 0,
        -- Red = 0.1,
        -- Green = 0.1,
        -- Blue = 0.05
    })
end

function DifficultyList:OnClick(pos)
    if self.Box ~= nil then
        if self.Box:contains(pos) then
            print("click!")
        end
    end
end

function DifficultyList:Update(dt)
    if Wheel.DifficultyIndex ~= self.DifficultyIndex then
        self.DiffCount = self.Song.DifficultyCount
        self:OnDifficultyUpdate(Wheel.DifficultyIndex)
    end

    local deltaOffset = (self.TargetStringOffset - self.DifficultyNamesTransform.position) * dt
    -- print(deltaOffset.Y * 5, self.TargetStringOffset.Y, self.StringTransform.Y)
    self.DifficultyNamesTransform.position = self.DifficultyNamesTransform.position + deltaOffset * 5

end

return DifficultyList