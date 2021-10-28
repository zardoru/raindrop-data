-- bezier over 1 dimension
local function Bez1D (p2, p1, t)
    local cx = 3 * p1
    local bx = 3 * (p2 - p1) - cx
    local ax = 1 - cx - bx
    local xt = ax * t * t * t + bx * t * t + cx * t

    return xt
end

-- 1D cubic bez derivative
local function BezdAdT(aa1, aa2, t)
    return 3 * (1 - 3 * aa2 + 3 * aa1) * t * t +
            2 * (3 * aa2 - 6 * aa1) * t +
            3 * aa1
end

-- p[1] == x, p[2] == y
function CubicBezier(p1, p2, t)
    return Bez1D(p2[1], p1[1], t), Bez1D(p2[2], p1[2], t)
end

---@alias EaseFunc fun(t:number):number
---@type table<string, EaseFunc>
Ease = {
    Linear = function(t) return t  end,
    In = function(t) return t * t end,
    Out = function(t) return (1 - math.pow(1 - t, 2)) end,
    ElasticSquare = function(p)
        local attn = 1 + 1 - math.asin(1.0 / p) * 2.0 / math.pi
        local pi = math.pi
        local sin = math.sin
        return function(x)
            return sin(x * x * pi / 2.0 * attn) * p
        end
    end,
    CubicBezier = function(p1, p2)
        --[[
            based off
          http://greweb.me/2012/02/bezier-curve-based-easing-functions-from-concept-to-implementation/
        ]]

        return function(t)

            -- newton raphson
            local function tforx(ax)
                local guess = ax
                for i = 1, 4 do
                    local cs = BezdAdT(p1[1], p2[1], guess)
                    if cs == 0 then
                        return guess
                    end

                    local cx = Bez1D(p1[1], p2[1], guess) - ax
                    guess = guess - cx / cs
                end

                return guess
            end

            return Bez1D(p1[2], p2[2], tforx(t))
        end
    end
}

---@class Keyframes
local Keyframes = {}

function Keyframes:init()
    local keyframesByProperty = {}
    local duration = 0

    -- group keyframes by property and find overall duration
    for _, keyframe in pairs(List) do
        local time = keyframe[1]
        local propertyList = keyframe[2]
        local ease = keyframe.Ease or Ease.Linear

        duration = max(duration, time)

        for propName, propValue in pairs(propertyList) do
            keyframesByProperty[propName] = {
                Time = time,
                Value = propValue,
                Ease = ease
            }
        end
    end

    self.KeyframesByProperty = keyframesByProperty
    self.Duration = duration
    self.Loop = self.Loop or false
end

librd.make_new(Keyframes, Keyframes.init)

---@class Timer
local Timer = {}

function Timer:init()
    self.CurrentTime = self.CurrentTime or 0
end

function Timer:Update(dt)
    self.CurrentTime = self.CurrentTime + dt
end

function Timer:Reset()
    self.CurrentTime = 0
end

function Timer:SetCurrentTime(t)
    self.CurrentTime = t
end

---@param keyframes Keyframes
function Timer:RunAnimation(object, keyframes)

    -- for every keyframed property
    for prop, propKeyframes in pairs(keyframes.KeyframesByProperty) do
        -- last value by default
        local propValue = propKeyframes[#propKeyframes].Value

        -- for every keyframe in this property's twine
        for i, propKeyframe in ipairs(propKeyframes) do
            if i + 1 > #propKeyframes then
                break
            end

            -- is this the active keyframe?
            local nextPropKeyframe = propKeyframes[i + 1]
            if nextPropKeyframe.Time > self.CurrentTime then
                -- yes, it is. eased interpolation off then current property
                local keyframeDuration = nextPropKeyframe.Time - propKeyframe.Time
                local positionInInterval = self.CurrentTime - propKeyframe.Time
                local frac = propKeyframe.Ease(positionInInterval / keyframeDuration)

                propValue = mix(frac, propKeyframe.Value, nextPropKeyframe.Value)

                -- no reason to look at the next one
                break
            end
        end

        object[prop] = propValue
    end

    return self:IsAnimationDone(keyframes)
end

---@param keyframes Keyframes
function Timer:IsAnimationDone(keyframes)
    return self.CurrentTime >= keyframes.Duration
end

librd.make_new(Timer, Timer.init)

-----@class AnimationPlayer
--local AnimationPlayer = {}
--
--function AnimationPlayer:init()
--    self.
--end

--librd.make_new(AnimationPlayer, AnimationPlayer.init)

return {
    Ease = Ease,
    Keyframes = Keyframes,
    Timer = Timer
    --,AnimationPlayer = AnimationPlayer
}