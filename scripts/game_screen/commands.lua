return {
	['getinfo'] = function(scripts, cursor, game)
		local obj = cursor:info(game.world.objs)
		if obj then scripts.obj_info:cout(obj) end
	end,
	['switch'] = function(scripts, cursor, game)
		local obj = cursor:info(game.world.objs)
		if obj and obj.switch then 
			obj:switch() 
			game.inputResult = 'Door ID#'..obj:getID()..' is '..(obj.loc and 'closed' or 'open')
		end
	end
}
