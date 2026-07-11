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
    Out = function(t) return (1 - (1 - t)^2) end,
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

Tween = {}


function Tween:new(target, property, start_value, end_value, duration, ease, delay)
    local tween = setmetatable({}, { __index = Tween })
    tween.target = target
    tween.property = property
    tween.start_value = start_value or 0
    tween.end_value = end_value or 0
    tween.duration = math.max(duration or 0, 0)
    tween.ease = ease or Ease.Linear
    tween.delay = math.max(delay or 0, 0)
    tween.time = 0
    tween.on_done_callback = nil
    return tween
end


function Tween:on_done(func)
    assert (type(func) == "function", "tweengroup: func is not a function")

    self.on_done_callback = func
end

function Tween:update(delta)
    if self.delay > 0 then
        self.delay = self.delay - delta
        if self.delay >= 0 then
            return false
        end
        delta = -self.delay
        self.delay = 0
    end

    self.time = self.time + delta
    local fraction = self.duration == 0 and 1 or math.min(self.time / self.duration, 1)
    local value = mix(self.ease(fraction), self.start_value, self.end_value)
    if type(self.property) == "string" then
        self.target[self.property] = value
    else
        self.property(self.target, value)
    end

    if fraction >= 1 and self.on_done_callback then
        self.on_done_callback()
        self.on_done_callback = nil
    end

    return fraction >= 1
end

function Tween:reset()
    self.time = 0
end

TweenGroup = {}

function TweenGroup:new()
    local ret = setmetatable({}, { __index = TweenGroup })
    ret.tweens = {}
    ret.next = nil
    ret.done = false
    ret.on_done_callback = nil
    return ret
end

function TweenGroup:on_done(func)
    assert (type(func) == "function", "tweengroup: func is not a function")

    ret.on_done_callback = func
end

function TweenGroup:update(delta)
    if self.next and self.done then
        return self.next(delta)
    end

    local all_done = true
    for _, v in pairs (self.tweens) do
        all_done = all_done and v:update(delta)
    end

    self.done = all_done

    if self.done and self.on_done_callback then
        self.on_done_callback()
        self.on_done_callback = nil
    end
end

function TweenGroup:add(tween)
    table.insert(self.tweens, tween)
    return self
end

function TweenGroup:continue(runner)
    self.next = runner or TweenGroup:new()
    return self.next
end

return {
    Ease = Ease,
    Keyframes = Keyframes,
    Timer = Timer,
    AnimationPlayer = AnimationPlayer,
    Tween = Tween,
    TweenGroup = TweenGroup
}
