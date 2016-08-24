FileUtils = {}

function FileUtils.loadFile(path, count)
	local file = fileOpen(path)
	if not file then
		return false
	end
	if not count then
		count = fileGetSize(file)
	end
	local data = fileRead(file, count)
	fileClose(file)
	return data
end

function FileUtils.saveFile(path, data)
	if not path then
		return false
	end
	if fileExists(path) then
		fileDelete(path)
	end
	local file = fileCreate(path)
	fileWrite(file, data)
	fileClose(file)
	return true
end