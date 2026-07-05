Phrases = {
	Content = {
		"show me your metrics.ini",
		"Must wear shoes, no baby powder allowed",
		"a noodle soup a day and your skills won't decay",
		"hey girl im kaiden want to go out",
		"now with more drops, sadly rain does not produce dubstep.",
		"top 10 bms plays",
		"i'll only date you if you're kaiden",
        "dude nice",
		"future metallic can - premium skin",
		"\"what the fuck is VOS\"",
		"Party like it's BM98.",
		"Everyone seems a bit too obsessed with the moon. I wonder if they're werewolves...",
		"rice and noodles erryday",
		"protip: to be overjoy you just have to avoid missing",
		"\"Like the game you may all know stepmania\"",
		"Are you kaiden yet?",
		"mario paint music!!",
		"very spammy",
		"misses are bad",
		"canmusic makes you ET",
		"You'll full combo it this time.",
		"big colorful buttons",
	}
}

function Phrases.Init()
	Phrases.VSize = 40
	PhraseFont = Fonts.TruetypeFont(GetSkinFile("font.ttf"));
	Phrases.Text = StringObject2D()
	Phrases.Text.Font = PhraseFont
	Phrases.Text.FontSize = Phrases.VSize
	
	local selected = Phrases.Content[math.random(#Phrases.Content)]
	Phrases.Text.Text = selected
	Phrases.Text.Layer = 12
	Phrases.Text.Alpha = 0
	Phrases.Text.Rotation = 0
	Phrases.Text.X = - Phrases.Text.TextSize / 2 + Screen.Width / 2
	Phrases.Text.Y = Screen.Height * 3 / 4
	
	Phrases.BG = Engine:CreateObject()

	Phrases.BG.Texture = "Global/white.png"
	Phrases.BG.Height = Phrases.VSize + 20
	Phrases.BG.Layer = 11
	Phrases.BG.Width = Screen.Width
	Phrases.BG.X = 0
	Phrases.BG.Y = Screen.Height * 3 / 4
	Phrases.BG.Red = 0.15
	Phrases.BG.Green = 0.15
	Phrases.BG.Blue = 0.15
	Phrases.BG.Alpha = 0.85
	
	Engine:AddTarget(Phrases.Text)
end

function Phrases.Fade(frac)
	Phrases.Text.Alpha = frac
	
	Phrases.BG.Alpha = frac
end