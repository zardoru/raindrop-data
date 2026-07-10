AutoAnimation = {}

function AutoAnimation:Init()
	if not self.Player.Auto then
		return
	end
	self.AutoBN = Engine:CreateObject()
	
  local sx = self.Noteskin.GearStartX + self.Noteskin.GearWidth/2
	BnMoveFunction = getMoveFunction(sx, -60, sx, 100, self.AutoBN)
			
	self.AutoBN.Texture = "VSRG/auto.png"

	self.AutoBN.Centered = 1


	local w = self.AutoBN.Width
	local h = self.AutoBN.Height
	
	factor = 350 / w * 3/4
	self.AutoBN.Width = w * factor
	self.AutoBN.Height = h * factor
	self.AutoBN.Layer = 14
	self.AutoFinishAnimation = getUncropFunction(w*factor, h*factor, w, h, self.AutoBN)
	self.RunAutoAnimation = true
end

librd.make_new(AutoAnimation, AutoAnimation.Init)

function AutoAnimation:OnSongFinish()
	if self.AutoBN then
		RunAutoAnimation = false
	end
end

function AutoAnimation:Run(Delta)
	if self.AutoBN and self.RunAutoAnimation == true then
			local BeatRate = self.Player.Beat / 2
			local Scale = sin( math.pi * 2 * BeatRate )
			Scale = Scale * Scale * 0.25 + 0.75
			self.AutoBN.Scale = Scale
		end
end
