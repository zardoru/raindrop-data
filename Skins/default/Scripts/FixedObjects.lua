
Filter = { Image = "Global/filter.png" }
JudgeLine = { Image = "VSRG/judgeline.png" }
StageLines = { ImageLeft = "VSRG/stage-left.png", ImageRight = "VSRG/stage-right.png" }

function Filter:Init()
	if GetConfigF("ScreenFilter", "") == 0 then
		return
	end
	
	local FilterVal = GetConfigF("ScreenFilter", "")
	-- print (FilterVal, "========================")

	self.Object = Engine:CreateObject()

	self.Object.Texture = (self.Image)
  
	self.Object.X = self.Noteskin.GearStartX
	self.Object.Width = self.Noteskin.GearWidth
	self.Object.Height = Screen.Height
	self.Object.Alpha = FilterVal
	self.Object.Layer = 1

	local lines = {}
	self.Lines = lines
	for i=1, self.Player.Channels do
		self:AddLine(i, -self.Noteskin["Key" .. i .. "Width"] / 2)
	end

	-- +1
	self:AddLine(self.Player.Channels, self.Noteskin["Key" .. self.Player.Channels .. "Width"] / 2)
end

function Filter:AddLine(i, offset)
	local obj = Engine:CreateObject()
	self.Lines[#self.Lines+1] = obj
	obj.Texture = "Global/white.png"
	with(obj, {
		Width = 3,
		Height = Screen.Height,
		Y = 0,
		X = self.Noteskin["Key" .. i .. "X"] + offset,
		Layer = 2,
		Alpha = self.Object.Alpha,
		Red = 0.4,
		Green = 0.4,
		Blue = 0.4
	})
end

librd.make_new(Filter, Filter.Init)

function JudgeLine:Init()
	self.Object = Engine:CreateObject()
	self.Size = { w = self.Noteskin.GearWidth, h = self.Noteskin.NoteHeight }

	self.Object.Texture = self.Image
	self.Object.Centered = 1

	self.Object.X = self.Noteskin.GearStartX + self.Noteskin.GearWidth / 2
	self.Object.Y = self.Player.JudgmentY
	
	self.Object.Width = self.Size.w
	self.Object.Height = self.Size.h
	self.Object.Layer = 12
end

librd.make_new(JudgeLine, JudgeLine.Init)

function StageLines:Init()
	self.Left = Engine:CreateObject()
	self.Right = Engine:CreateObject()
	
	self.Left.Texture = self.ImageLeft
	self.Left.X = self.Noteskin.GearStartX - self.Left.Width
	self.Left.Height = Screen.Height
	self.Left.Layer = 16

	self.Right.Texture = (self.ImageRight)
	self.Right.X = (self.Noteskin.GearStartX + self.Noteskin.GearWidth)
	self.Right.Height = Screen.Height
	self.Right.Layer = 20
end

librd.make_new(StageLines, StageLines.Init)