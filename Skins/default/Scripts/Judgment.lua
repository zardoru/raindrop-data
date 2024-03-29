JudgmentObject = {
	FadeoutTime = 0.4,
	FadeoutDuration = 0.15,
	Tilt = 0, -- in degrees

	ScaleTime = 0.075,
	Scale = 0.15,
	ScaleHit = 1.5,
	ScaleOK = 0.9,
	ScaleMiss = 1,
	ScaleExtra = 0.1,
   ScaleMaskX = 0,
   ScaleMaskY = 1,

	-- if not nil it overrides default position
	--Position = {},

	Table = {
		"judge-flawless.png", -- w0/1
		"judge-sweet.png", -- w2
		"judge-nice.png", -- w3
		"judge-ok.png", -- w4
      "judge-meh.png", -- w5
		"judge-weak.png", -- w6
	},

	TimingIndicator = "hiterror.png",
	ShowTimingIndicator = true,
	ScaleLerp = nil -- function(x) return 1 - (1 - x) * (1 - x) end -- Ease.ElasticSquare(2.5)
}


function JudgmentObject:Init()
  print "Judgment Initializing."
	self.Atlas = TextureAtlas:skin_new("VSRG/judgment.csv")
  
  
  self.defaultX = self.Noteskin.GearWidth / 2 + self.Noteskin.GearStartX
  self.defaultY = Screen.Height * 0.4
  self.ScaleLerp = self.ScaleLerp or function (x) return x end
  print ("Judgment Default Pos: ", self.defaultX, self.defaultY)
  
	self.Object = ScreenObject {
		Layer = 28,
		Centered = 1,
		Texture = self.Atlas.File,
		Alpha = 0
	}

	self.Transform = Transformation()
	self.Object.Parent = self.Transform
  
	if self.Position then 
		self.Transform.X = self.Position.x or self.defaultX
		self.Transform.Y = self.Position.y or self.defaultY
	else
		self.Transform.X = self.defaultX
		self.Transform.Y = self.defaultY  
	end

	self.Transform.Width = self.Scale
	self.Transform.Height = self.Scale


  	print ("Judgment Real pos/Texture: ", self.Transform.X, self.Transform.Y, self.Object.Texture)

	self.LastAlternation = 0
	self.Time = self.FadeoutTime + self.FadeoutDuration

	self.IndicatorObject = ScreenObject {
		Texture = ("VSRG/" .. self.TimingIndicator),
		Layer = 24,
		Centered = 1,
		Alpha = 0,
	}
	self.IndicatorObject.Scale =  1 / self.Scale

	self.IndicatorObject.Parent = self.Transform
  --self.Value = 0
end

librd.make_new(JudgmentObject, JudgmentObject.Init)

function JudgmentObject:GetComboLerp()
	local AAAThreshold = 8.0 / 9.0
	return clerp(self.Player.Combo,  -- cur
							 0, self.Player.Scorekeeper.MaxNotes * AAAThreshold, -- start end
							 0, 1) -- start val end val
end

function JudgmentObject:Run(Delta)
	local ComboLerp = self:GetComboLerp()
	
	if Game.Active and self.Value then
		local AlphaRatio
		self.Time = min(self.Time + Delta, self.ScaleTime)

		local sval
		if self.Value < 3 then
			sval = self.ScaleHit
		elseif self.Value < 5 then
			sval = self.ScaleOK
		else
			sval = self.ScaleMiss
		end

		local s = lerp(self.ScaleLerp(self.Time / self.ScaleTime), 0, 1, sval, 1)
      
      -- print(self.ScaleMaskX)
		self.Transform.ScaleX = 1 + (s - 1) * self.ScaleMaskX
		self.Transform.ScaleY = 1 + (s - 1) * self.ScaleMaskY
      
      -- print(self.Transform.ScaleY)

		if self.Time > self.FadeoutTime then
			local Time = self.Time - self.FadeoutTime
			if Time > 0 then
				local Ratio = Time / self.FadeoutDuration

				if Ratio < 1 then
					AlphaRatio = 1 - Ratio
				else
					AlphaRatio = 0
				end

			end
		else
			AlphaRatio = 1
		end

		local w = self.Object.Width 
		local h = self.Object.Height 

		self.Object.Alpha = (AlphaRatio)

		if self.LastAlternation == 0 then
			self.Transform.Rotation = (self.Tilt * ComboLerp)
		else
			self.Transform.Rotation = (-self.Tilt * ComboLerp)
		end

		local bestValue = 1
		if self.Player.Scorekeeper.UsesW0 then 
			bestValue = 0
		end

		if self.Value ~= bestValue
			and self.ShowTimingIndicator then -- not a "flawless"
			self.IndicatorObject.Alpha = AlphaRatio

			if self.Early then -- early
				self.IndicatorObject.X = - (w / 2 + 130)
			else
				-- late
				self.IndicatorObject.X = w / 2 + 130
			end
		else
			self.IndicatorObject.Alpha = 0
		end
	else
		self.IndicatorObject.Alpha = 0
		self.Object.Alpha = 0
	end
end

function JudgmentObject:OnHit(JudgmentValue, Time, l, h, r, pn)
	if pn ~= self.Player.Number then
		return
	end


    if JudgmentValue <= 0 or JudgmentValue > #self.Table then
        return
    end

	self.Value = JudgmentValue

	local kvalue = self.Value
	if self.Value == 0 then
		self.Object.Lighten = (1)
		self.Object.LightenFactor = (2.0)
		self.Value = 0
		kvalue = 1
	else
		self.Object.Lighten = 0
		self.Object.LightenFactor = 0
	end

	if self.LastAlternation == 0 then
		self.LastAlternation = 1
	else
		self.LastAlternation = 0
	end

    self.Atlas:SetObjectCrop(self.Object, self.Table[kvalue])
    self.Object.Height = self.Atlas.Sprites[self.Table[kvalue]].h
    self.Object.Width = self.Atlas.Sprites[self.Table[kvalue]].w
    self.Time = 0
    self.Early = Time < 0

	if JudgmentValue ~= 5 then
		if JudgmentValue ~= -1 then
			local CLerp = self:GetComboLerp()
			-- self.Object.Scale = (self.Scale + CLerp * self.ScaleExtra)
		else
			-- self.Object.Scale = (self.Scale)
		end
	else
		self.Object.Scale = (self.ScaleMiss)
	end

end

function JudgmentObject:OnMiss(t, l, h, pn)
  self:OnHit(6, t, l, h, h, pn)
end
