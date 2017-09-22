
-- Structure constants
IntroDuration = 0
ExitDuration = 0

function Init()
    obj = Engine:CreateObject()
    obj.Texture = "VSRG/auto.png"
    obj.Lighten = 1
end

--[[ 
--key: scan code
--code: 1 is press, 2 is release (0 was repeat)
--is_mouse_input: 0 if not mouse input, 1 if it is.
--]]
function KeyEvent(key, code, is_mouse_input)

end

-- Intro
function OnIntroBegin()

end

-- Fraction = Time / IntroDuration
function UpdateIntro(Fraction, Delta)

end

function OnIntroEnd()

end

-- Main loop
local t = 0
function Update(Delta)
    t = t + Delta
    obj.LightenFactor = sin(t)
end

-- Exit/Outro
function OnExitBegin()

end

function UpdateExit(Fraction, Delta)

end

function OnExitEnd()

end

-- Resource cleanup (i.e. custom allocated resources...)
function Cleanup()

end
