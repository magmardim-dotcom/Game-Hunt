local paths = love.filesystem.getRequirePath( )
love.filesystem.setRequirePath( paths..';scripts/screens/?.lua;' )

return {
	defaults = require 'defaults',
	Screen = require 'screen',
	Menu = require 'menu',
	Text = require 'text',
	
}
