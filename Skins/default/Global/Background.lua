
if BackgroundAnimation then
	return
end

BackgroundAnimation = {Duration = 0.25}

function BackgroundAnimation:Init()
	if self.Initialized then
		return
	end

	self.shader = Shader()
	self.shader:Compile [[
		#version 120
		varying vec2 texcoord;
		uniform sampler2D tex;
		uniform vec4 color;
		uniform float frac;
		uniform float persp;
		void main(void) {
			vec2 uv = texcoord - .5;
			float z = sqrt(abs(.5*.5 - uv.x*uv.x - uv.y*uv.y)) / persp;

			vec2 rv = uv;
			uv /= z;
			
			uv.x += frac / 4.;
			/*vec4 col = texture2D(tex, uv) 
			float v = (col.r + col.g + col.b) / 3.;
			vec4 gs = vec4(v,v,v,1.);
			vec4 nc = vec4(0.48, 0.79, 1., 1.);
			gl_FragColor = gs * persp * z;
			*/
			gl_FragColor = texture2D(tex, vec2(mod(uv.x, 1.0), mod(uv.y, 1.0))) * (z + 0.2);
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
end

function BGAOut(frac)
	-- BackgroundAnimation.Pink.Y = -BackgroundAnimation.Pink.Height * (1-frac)
	BackgroundAnimation.shader:Send("persp", (frac) * 0.9 + 0.1)
	return 1
end

function BGAIn(frac)
	return BGAOut(1-frac)
end

function BackgroundAnimation:In()
	Engine:AddAnimation(self.Blue, "BGAIn", Easing.In, BackgroundAnimation.Duration, 0)
end

function BackgroundAnimation:Out()
	Engine:AddAnimation(self.Blue, "BGAOut", Easing.Out, BackgroundAnimation.Duration, 0)
end

function BackgroundAnimation:UpdateObjects()
end

function BackgroundAnimation:Update(Delta)
	self.t = self.t + Delta
	self.shader.Send(self.shader, "frac", self.t)
end
