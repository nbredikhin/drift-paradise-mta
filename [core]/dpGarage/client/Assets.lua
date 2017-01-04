Assets = {}
local stickersLoaded = false

function Assets.start()
	Assets.textures = {
		logo = exports.dpAssets:createTexture("logo_square_simple.png", "dxt5"),
		arrow = exports.dpAssets:createTexture("arrow.png"),
		circle = DxTexture("assets/images/circle_button.png"),
		slider = DxTexture("assets/images/slider.png"),
		sliderCircle = DxTexture("assets/images/slider_circle.png"),

		colorsHue = DxTexture("assets/images/hue.png"),
		colorsSaturation = DxTexture("assets/images/saturation.png"),
		colorsBrightness = DxTexture("assets/images/brightness.png"),

		stickersColorIcon = DxTexture("assets/images/icons/color.png"),
		stickersMoveIcon = DxTexture("assets/images/icons/move.png"),
		stickersRotateIcon = DxTexture("assets/images/icons/rotate.png"),
		stickersScaleIcon = DxTexture("assets/images/icons/scale.png"),

		tuningComponentsIcon = DxTexture("assets/images/icons/components.png"),
		tuningColorIcon = DxTexture("assets/images/icons/color.png"),
		tuningVinylsIcon = DxTexture("assets/images/icons/vinyls.png"),
		tuningSettingsIcon = DxTexture("assets/images/icons/settings.png"),

		buttonCircle = DxTexture("assets/images/button_circle.png"),
		levelIcon = exports.dpAssets:createTexture("level.png"),

		stickersSection1 = DxTexture("assets/images/icons/section1.png"),
		stickersSection2 = DxTexture("assets/images/icons/section2.png"),
		stickersSection3 = DxTexture("assets/images/icons/section3.png"),
		stickersSection4 = DxTexture("assets/images/icons/section4.png"),
		stickersSection5 = DxTexture("assets/images/icons/section5.png"),
		stickersSection6 = DxTexture("assets/images/icons/section6.png"),
	}

	Assets.fonts = {}
	local fontsBySize = {}
	local function loadFont(name, size)
		if fontsBySize[size] then
			Assets.fonts[name] = fontsBySize[size]
			return fontsBySize[size]
		end
		Assets.fonts[name] = exports.dpAssets:createFont("Roboto-Regular.ttf", size)
		fontsBySize[size] = Assets.fonts[name]
		return Assets.fonts[name]
	end

	loadFont("menu", 22)
	loadFont("carNameText", 48)
	loadFont("colorMenuHeader", 20)
	loadFont("colorMenuPrice", 18)
	loadFont("componentName", 30)
	loadFont("componentNameInfo", 15)
	loadFont("menuLabel", 18)
	loadFont("helpText", 16)
	loadFont("moneyText", 24)
	loadFont("levelText", 14)
	loadFont("controlIconButton", 18)
	loadFont("stickersGridText", 12)
	loadFont("tuningPanelText", 14)
	loadFont("tuningPanelKey", 11)
	loadFont("componentItem", 16)
	loadFont("componentItemInfo", 13)
	loadFont("stickerPreviewHelp", 12)
	loadFont("helpPanelText", 14)

	triggerEvent("dpGarage.assetsLoaded", resourceRoot)

	local texturesCount = 0
	for k, v in pairs(Assets.textures) do
		texturesCount = texturesCount + 1
	end
	--outputDebugString("Garage Assets: Created " .. tostring(texturesCount) .. " textures")
end

function Assets.loadSticker(id)
	local assetName = "sticker_" .. tostring(id)
	if Assets.textures[assetName] then
		return Assets.textures[assetName]
	end
	Assets.textures[assetName] = exports.dpAssets:createTexture("stickers/" .. id .. " (Custom).png")
	if not isElement(Assets.textures[assetName]) then
		outputDebugString("No preview for sticker " .. tostring(id))
		Assets.textures[assetName] = exports.dpAssets:createTexture("stickers/" .. id .. ".png")
	end
	return Assets.textures[assetName]
end

function Assets.stop()
	local texturesCount = 0
	for name, texture in pairs(Assets.textures) do
		if isElement(texture) then
			destroyElement(texture)
			texturesCount = texturesCount + 1
		end
	end
	--outputDebugString("Garage Assets: Destroyed " .. tostring(texturesCount) .. " textures")

	for name, font in pairs(Assets.fonts) do
		if isElement(font) then
			destroyElement(font)
		end
	end	
end