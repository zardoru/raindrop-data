
if BackgroundAnimation then
	return
end

game_require "Animation"

BackgroundAnimation = {Duration = 0.25}

function BackgroundAnimation:Init()
	if self.Initialized then
		return
	end

    self.anim = nil

	self.shader = Shader()
	self.shader:Compile [[
		#version 330
		in vec2 texcoord;
		uniform sampler2D tex;
		uniform vec4 color;
		uniform float frac;
		uniform float persp;
		out vec4 FragColor;
		void main(void) {
			vec2 uv = texcoord - .5;
			float z = sqrt(abs(.5*.5 - uv.x*uv.x - uv.y*uv.y)) / persp;

			vec2 rv = uv;
			uv /= z;
			
			uv.x += frac / 4.;
			/*vec4 col = texture(tex, uv) 
			float v = (col.r + col.g + col.b) / 3.;
			vec4 gs = vec4(v,v,v,1.);
			vec4 nc = vec4(0.48, 0.79, 1., 1.);
			FragColor = gs * persp * z;
			*/
			FragColor = texture(tex, vec2(mod(uv.x, 1.0), mod(uv.y, 1.0))) * (z + 0.2) * color;
		}
	]]

	self.Initialized = true
	self.Blue = Engine:CreateObject()

	self.Blue.Texture  = "Global/tile_aqua.png"

	self.Blue.Height = Screen.Height
	self.Blue.Width = Screen.Width
	self.Blue.Shader = self.shader

	self.Blue.Y = 0
	self.Blue.Z = 0

	self.t = 0
	-- The old C++ animation runner used to initialize this through BGAIn/BGAOut.
	-- The background shader is now self-contained, so never leave its divisor at 0.
	self.shader:Send("persp", 1.0)
	self.shader:Send("frac", 0.0)
end

function BackgroundAnimation:In()
    self.anim = Tween:new(self.shader, function(shader, v)
        shader:Send("persp", v)
    end, 1.0, 0.1, self.Duration, Ease.In)
end

function BackgroundAnimation:Out()
    self.anim = Tween:new(self.shader, function(shader, v)
        shader:Send("persp", v)
    end, 0.1, 1.0, self.Duration, Ease.Out)
end

function BackgroundAnimation:UpdateObjects()
end

function BackgroundAnimation:Update(dt)
    if self.anim ~= nil then
        if self.anim:update(dt) then
            self.anim = nil
        end
    end

    self.t = self.t + dt
    self.shader.Send(self.shader, "frac", self.t)
end
