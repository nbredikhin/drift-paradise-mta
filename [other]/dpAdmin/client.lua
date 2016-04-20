-- local screenSource = dxCreateScreenSource(512, 512)
-- function makeScreenshot()
	
-- end

-- addEventHandler("onClientRender", root, function ()
-- 	dxUpdateScreenSource(screenSource)
-- end)

-- setTimer(function ()
-- 	local pixels = dxGetTexturePixels(screenSource)
-- 	pixels = dxConvertPixels(pixels, "jpeg")
-- 	triggerServerEvent("onScreenshot", resourceRoot, pixels)
-- end, 500, 0)