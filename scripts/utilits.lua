local screens = require "scripts.screens"
Text = screens.Text
Menu = screens.Menu
Screen = screens.Screen

defaults = require "scripts.defaults"

Char = require "scripts.objs.char"
Door = require "scripts.objs.door"

function lerp(a, b, t)
	return a + (b - a) * t
end
