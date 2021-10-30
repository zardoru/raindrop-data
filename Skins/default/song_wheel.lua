-- Read "state" as the wheel's state
local State = {
	X = 0,
	ListY = 0,
	PendingY = 0,
	TargetY = 0,
	LastSign = 0,
	Time = 0,
	ScrollSpeed = 0,
	Cursor = nil
}


local WheelItems = {}
local WheelItemStrings = {}

-- Wheel item size
local ItemWidth = 400
local ItemHeight = 48
local WheelFontSize = 36

-- Wheel transformation
local WheelEnterX = Screen.Width - ItemWidth
local WheelExitX = Screen.Width + 16
local WheelSpeed = 900

local function FracToWheelIndex(t)
	return t * Wheel.DisplayItemCount + Wheel.DisplayStartIndex
end

-- List transformation
function TransformListHorizontal(t)
	return State.X
end

function TransformListVertical(t)
	return State.ListY + FracToWheelIndex(t) * ItemHeight
end

function TransformListWidth(t)
	return ItemWidth
end

function TransformListHeight(t)
	return ItemHeight
end

function OnItemHover(Index, BoundIndex, Line, Selected)
	-- updText()
end

function OnItemHoverLeave(Index, BoundIndex, Line, Selected)
	State.Cursor = Wheel.SelectedIndex
end

function OnItemClick(Index, BoundIndex, Line, Song)
	-- print (Index, BoundIndex, Line, Song, Wheel.ListIndex, Wheel.SelectedIndex, Wheel.CursorIndex)
	if Song and (Index == Wheel.SelectedIndex) then
		Wheel:ConfirmSelection()
	else
		Wheel.SelectedIndex = Index
		if not Song then
			Wheel:ConfirmSelection() -- Go into directories inmediately
		else
			updText()
			State.Cursor = Index
		end
	end
end


-- This gets called for every item - ideally you dispatch for every item.
function TransformItem(Item, Song, IsSelected, Index)
	WheelItems[Item](Song, IsSelected, Index);
end

function TransformString(Item, Song, IsSelected, Index, Txt)
	WheelItemStrings[Item](Song, IsSelected, Index, Txt);
end

-- This recieves song and difficulty changes.
function OnSongChange(song, Diff)
	updText()
	State.Cursor = Wheel.SelectedIndex
end

function CreateWheelItems()
	local WheelBackground = Object2D()
	State.WheelBackground = WheelBackground
	WheelBackground.Texture = "Global/white.png"
	WheelBackground.Width = ItemWidth
	WheelBackground.Height = ItemHeight

	WheelItems[Wheel:AddSprite(WheelBackground)] = function(Song, IsSelected, Index)
		if IsSelected == true then
			WheelBackground.Red   = 0.1
			WheelBackground.Green = 0.3
			WheelBackground.Blue  = 0.7
		else
			if Index == Wheel.ListIndex then
				WheelBackground.Red = 0.05
				WheelBackground.Green = 0.15
				WheelBackground.Blue = 0.35
			else
				local Nrm = Index % 2

				local colorDim = 1

				if Song then
					WheelBackground.Red   = 1
					WheelBackground.Green = 1
					WheelBackground.Blue  = 1

					if Nrm == 0 then
						colorDim = 0
					else
						colorDim = 0.15
					end
				else -- Directory
					WheelBackground.Red   = 155 / 255
					WheelBackground.Green = 75 / 255
					WheelBackground.Blue  = 30 / 255

					if Nrm == 0 then
						colorDim = 0.25
					else
						colorDim = 0.5
					end
				end

				WheelBackground.Red   = colorDim * WheelBackground.Red
				WheelBackground.Green = colorDim * WheelBackground.Green
				WheelBackground.Blue  = colorDim * WheelBackground.Blue
			end
		end
		--(WheelBackground)
	end

	strName = StringObject2D()
	--strArtist = StringObject2D()
	--strDuration = StringObject2D()
	--strLevel = StringObject2D()
	--strSubtitle = StringObject2D()

	wheelfont = Fonts.TruetypeFont(GetSkinFile("fonts/rounded-mgenplus-1c-light.ttf"))

	strName.Font = wheelfont
	strName.FontSize = WheelFontSize
	--strArtist.Font = wheelfont
	--strArtist.FontSize = 24
	--strDuration.Font = wheelfont
	--strDuration.FontSize = 30
	--strLevel.Font = wheelfont
	--strLevel.FontSize = 16
	--strSubtitle.Font = wheelfont
	--strSubtitle.FontSize = 22

	local dur_x = 50

	-- Transform these strings according to what they are
	WheelItemStrings[Wheel:AddString(strName)] = function(Song, IsSelected, Index, Txt)
		strName.X = strName.X + 10
		if Song then
			strName.Text = Song.Title .. Song.Subtitle
		else
			strName.Text = Txt
		end

		local w = strName.TextSize
		local m = ItemWidth - dur_x - 20
		if w > m then
			strName.ScaleX = m / w
		else
			strName.ScaleX = 1
		end

	end

	--WheelItemStrings[Wheel:AddString(strArtist)] = function(Song, IsSelected, Index, Txt)
	--	strArtist.X = strArtist.X + 10
	--	strArtist.Y = strArtist.Y + 45
	--	strArtist.Red = 1
	--	if Song then
	--		strArtist.Text = "by " .. Song.Author
	--		strArtist.Blue = 0.3
	--		strArtist.Green = 0.7
	--	else
	--		strArtist.Text = "directory..."
	--		strArtist.Blue = 0.3
	--		strArtist.Green = 0.3
	--	end
	--
	--	local w = strArtist.TextSize
	--	local m = ItemWidth - 20
	--
	--	if w > m then
	--		strArtist.ScaleX = m / w
	--	else
	--		strArtist.ScaleX = 1
	--	end
	--end
	--
	--WheelItemStrings[Wheel:AddString(strDuration)] = function(Song, IsSelected, Index, Txt)
	--	if Song then
	--		local s = floor(Song:GetDifficulty(0).Duration % 60)
	--		local m = floor((Song:GetDifficulty(0).Duration - s) / 60)
	--		strDuration.Text = string.format("%d:%02d", m, s)
	--	else
	--		strDuration.Text = ""
	--	end
	--	strDuration.X = strDuration.X + ItemWidth - dur_x
	--	strDuration.Y = strDuration.Y + 10
	--end
	--
	--WheelItemStrings[Wheel:AddString(strLevel)] = function(Song, IsSelected, Index, Txt)
	--
	--end
	--
	--WheelItemStrings[Wheel:AddString(strSubtitle)] = function(Song, IsSelected, Index, Txt)
	--	strSubtitle.X = strSubtitle.X + 10
	--	strSubtitle.Y = strSubtitle.Y + 25
	--	if Song then
	--		strSubtitle.Text = Song.Subtitle
	--	else
	--		strSubtitle.Text = ""
	--	end
	--
	--	local w = strSubtitle.TextSize
	--	local m = ItemWidth - 20
	--
	--	if w > m then
	--		strSubtitle.ScaleX = m / w
	--	else
	--		strSubtitle.ScaleX = 1
	--	end
	--end


	WheelSeparator = ScreenObject {
		Texture = "Global/white.png",
		Size = Vec2(5, Screen.Height),
		Y = 0
	}

	wheeltick = ScreenObject {
		Texture = "Global/white.png",
		Size = Vec2(12, 8),
		Layer = 25
	}

	Wheel.DisplayItemCount = ceil(Screen.Height / ItemHeight) + 1
	--Wheel.DisplayItemOffset = - Wheel.DisplayItemCount / 2
end

function UpdateWheel(Delta)
	State.X = clamp(State.X + (WheelEnterX - State.X) * Delta * WheelSpeed, WheelExitX, WheelEnterX)

	WheelSeparator.X = State.X - WheelSeparator.Width
	wheeltick.Width = math.max(16, Screen.Width / Wheel.ItemCount)
	wheeltick.X = (Wheel.SelectedIndex % Wheel.ItemCount) / (Wheel.ItemCount - 1) * (Screen.Width - wheeltick.Width)
	wheeltick.Y = 110

	local Offset = Screen.Height / 2 - ItemHeight / 2
	-- local SelectedSongCenterY = math.floor(-Wheel.SelectedIndex * ItemHeight + Offset)
	local targetY = State.TargetY -- SelectedSongCenterY
	State.PendingY = targetY - State.ListY
	State.ScrollSpeed = -math.abs(State.PendingY) / 0.25

	-- don't overshoot
	local dist = math.abs(targetY - State.ListY)
	local deltaWheel = sign(State.PendingY) * math.min(State.ScrollSpeed * Delta, dist)

	if math.abs(State.PendingY) < 1 then
		State.ListY = State.ListY + State.PendingY
		State.PendingY = 0
	else
		State.ListY = State.ListY - deltaWheel
		State.PendingY = State.PendingY - deltaWheel
	end

	-- Display -halfCount to +halfCount 
	-- what's the center's current index?
	local centerCurrentIndex = floor(-State.ListY / ItemHeight)
	Wheel.DisplayStartIndex = centerCurrentIndex

end

function WheelOnScroll(yoff)
	-- if Box:contains() then
		Wheel.SelectedIndex = Wheel.SelectedIndex - yoff
		State.Cursor = Wheel.SelectedIndex
		Wheel.CursorIndex = State.Cursor
		State.TargetY = State.TargetY + yoff * ItemHeight
	-- end
end