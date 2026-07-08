local OptionsMode = {
    Speed = 1,
    Game = 2
}

local OptionType = {
    List = 1,
    Numeric = 2
}

local Options = {
    Padding = 10,
    Transform = Transformation(),
    BaseSize = Vec2(Screen.Width - 410 , 50),
    MaxSize = Vec2(Screen.Width , 550),
    Position = Vec2(0, 130),
    TargetSize = Vec2(0, 0),
    F1IsDown = false,
    F2IsDown = false,
    Open = false,
    CurrentMode = OptionsMode.Speed,
}

local SpeedOptions = {
    {
        Name = function() return "HS Type" end,
        Type = OptionType.List,
        Values = function()
            return {
                { Description = "Most Common", Value = 4 },
                { Description = "First BPM", Value = 3 },
                { Description = "Constant (CMOD)", Value = 2 },
                { Description = "Maximum (MMOD)", Value = 1 },
                { Description = "First", Value = 0 },
                { Description = "Multiplier", Value = 5 }
            }
        end,
        Action = function(parameters, value)
            parameters.SpeedType = value
            Options:RedrawOptions()
        end
    },
    {
        Name = function() return "Number Type" end,
        Type = OptionType.List,
        Values = function()
            return {
                { Description = "Units Per Sec", Value = false },
                { Description = "Milliseconds On Screen", Value = true }
            }
        end,
        Action = function(parameters, value)
            parameters.GreenNumber = value
        end
    }
}

local GameOptions = {
    {
        Name = function() return "Gauge Type" end,
        Type = OptionType.List,
        Values = function()
            return {
                { Description = "Auto", Value = 0 },
                { Description = "Groove", Value = LifeType.LT_GROOVE },
                { Description = "Survival", Value = LifeType.LT_SURVIVAL },
                { Description = "EXHARD", Value = LifeType.LT_EXHARD },
                { Description = "DEATH", Value = LifeType.LT_DEATH },
                { Description = "Easy", Value = LifeType.LT_EASY },
                { Description = "O2Jam", Value = LifeType.LT_O2JAM },
                { Description = "Stepmania L4", Value = LifeType.LT_STEPMANIA },
                { Description = "No Recovery", Value = LifeType.LT_NORECOV },
                { Description = "osu!mania", Value = LifeType.LT_OSUMANIA },
                { Description = "Battery", Value = LifeType.LT_BATTERY },
                { Description = "LR2/Assist", Value = LifeType.LT_LR2_ASSIST },
                { Description = "LR2/Easy", Value = LifeType.LT_LR2_EASY },
                { Description = "LR2/Groove", Value = LifeType.LT_LR2_NORMAL },
                { Description = "LR2/Hard", Value = LifeType.LT_LR2_HARD},
                { Description = "LR2/EXHARD", Value = LifeType.LT_LR2_EXHARD },
                { Description = "LR2/HAZARD", Value = LifeType.LT_LR2_HAZARD },
                { Description = "LR2/CLASS", Value = LifeType.LT_LR2_CLASS },
                { Description = "LR2/EXCLASS", Value = LifeType.LT_LR2_EXCLASS },
                { Description = "LR2/EXHARDCLASS", Value = LifeType.LT_LR2_EXHARDCLASS },
            }
        end,
        Action = function(parameters, value)
            parameters.GaugeType = value
        end
    },
    {
        Name = function() return "System Type" end,
        Type = OptionType.List,
        Values = function()
            return {
                { Description = "Auto", Value = TI_NONE},
                { Description = "Raindrop", Value = TI_RAINDROP},
                { Description = "osu!mania", Value = TI_OSUMANIA},
                { Description = "O2Jam", Value = TI_O2JAM},
                { Description = "Stepmania", Value = TI_STEPMANIA},
                { Description = "RDAC", Value = TI_RDAC},
                { Description = "LR2", Value = TI_LR2}
            }
        end,
        Action = function(parameters, value)
            parameters.SystemType = value
        end
    }
}

function Options:Init(font)
    local pad = self.Padding

    -- account for padding
    local padVec = Vec2(- pad * 2, 0)
    self.BaseSize = self.BaseSize + padVec
    self.MaxSize = self.MaxSize + padVec
    self.TargetSize = self.BaseSize
    self.Position = self.Position + padVec

    self.Transform.Position = self.Position

    self.bgSongSelectTicker = ScreenObject {
        Texture = "Global/filter.png",
        -- 410 matches then Song Wheel's width
        Size = self.BaseSize,
        Parent = self.Transform,
        Z = 20
    }

    self.strSongSelectInfoText = StringObject2D()
    with(self.strSongSelectInfoText, {
        Font = font,
        FontSize = 30,
        Parent = self.Transform,
        Position = Vec2(40, 0),
        Text = "F1 for speed options. F2 for game options.",
        Z = 21
    })

    Engine:AddTarget(self.strSongSelectInfoText)

    self.Objects = {}
end

function Options:RedrawOptions()
    -- remove existing
    for key, value in ipairs(self.Objects) do
        Engine:RemoveTarget(value)
        self.Objects[key] = nil
    end

    -- get sets of options to use
    local opts
    if self.CurrentMode == OptionsMode.Speed then
        opts = SpeedOptions
    else
        opts = GameOptions
    end

    -- add a component for each option
    for _, option in ipairs(opts) do
        local item = option.Name()
        local values = option.Values()

        local label = StringObject2D()
        with(label, {

        })

        table.insert(self.Objects, label)


        local valueLabel = StringObject2D()
        with(valueLabel, {

        })
        table.insert(self.Objects, valueLabel)
    end
end

function Options:KeyEvent(keycode, isPressedDown)

    -- print(keycode, isPressedDown)
    local newMode
    if keycode == 290 then -- F1
        self.F1IsDown = isPressedDown
        newMode = OptionsMode.Speed
    end

    if keycode == 291 then -- F2
        self.F2IsDown = isPressedDown
        newMode = OptionsMode.Game
    end

    if self.F2IsDown or self.F1IsDown then
        self.TargetSize = self.MaxSize
        self.Open = true
    else
        self.TargetSize = self.BaseSize
        self.Open = false
    end

    -- only change modes during key presses
    if Open and isPressedDown then
        self.CurrentMode = newMode
        self:RedrawOptions()
    end
end

function Options:Update(dt)
    local boxDeltaSize = self.TargetSize - self.bgSongSelectTicker.Size

    if boxDeltaSize.x == 0 and boxDeltaSize.y == 0 then
        return
    end

    local possibleChange = boxDeltaSize * dt * 15
    local effectiveChange

    if self.Open then
        effectiveChange = boxDeltaSize:min(possibleChange)
    else
        effectiveChange = boxDeltaSize:max(possibleChange)
    end

    self.bgSongSelectTicker.Size = self.bgSongSelectTicker.Size + effectiveChange
end

return Options