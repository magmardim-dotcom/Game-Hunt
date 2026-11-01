local screens = require "scripts/screens"
Text = screens.Text
Menu = screens.Menu
Screen = screens.Screen

Char = require "scripts/objs/char"
Door = require "scripts/objs/door"

function lerp(a, b, t)
	return a + (b - a) * t
end
