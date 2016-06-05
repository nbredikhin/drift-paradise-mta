if true then
	return
end

fileDelete("lol.xml")
local m = fileCreate("lol.xml")
local res = ""
for i = 0, 300, 1 do
	local src = "assets/textures/stickers/" .. tostring(i) .. ".png"
	if fileExists(src) then
		res = res .. '\t<file src="'..src..'"/>\n'
		--outputChatBox("check: " .. tostring(src))
	end
end
m:write(res)
m:close()
outputChatBox("done")