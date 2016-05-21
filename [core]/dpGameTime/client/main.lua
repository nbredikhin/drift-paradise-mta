-- TODO: Синхронизация времени

local oldTime
function forceTime(hh, mm)
	oldTime = {getTime()}
	setTime(hh, mm)
end

function restoreTime()
	if not oldTime then
		return
	end
	setTime(unpack(oldTime))
	oldTime = nil
end