Garage = {}
local isActive = false

function Garage.start()
	if isActive then
		return false
	end
	isActive = true
	outputChatBox("Garage.start()")
end

function Garage.stop()
	if not isActive then
		return false
	end
	isActive = false
	outputChatBox("Garage.stop()")
end

function Garage.isActive()
	return isActive
end