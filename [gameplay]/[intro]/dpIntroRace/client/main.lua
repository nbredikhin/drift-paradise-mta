function startIntroRace()
	IntroCutscene.start()
	Race.create()
end

function stopIntroRace()

end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	startIntroRace()
end)