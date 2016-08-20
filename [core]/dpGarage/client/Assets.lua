Assets = {}

function Assets.start()
	Assets.textures = {
		logo = exports.dpAssets:createTexture("logo_square_simple.png"),
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

		levelIcon = exports.dpAssets:createTexture("level.png"),

		stickersSection1 = DxTexture("assets/images/icons/section1.png"),
		stickersSection2 = DxTexture("assets/images/icons/section2.png"),
		stickersSection3 = DxTexture("assets/images/icons/section3.png"),
		stickersSection4 = DxTexture("assets/images/icons/section4.png"),
		stickersSection5 = DxTexture("assets/images/icons/section5.png"),
		stickersSection6 = DxTexture("assets/images/icons/section6.png"),
	}

	for i, section in ipairs(TuningConfig.stickers) do
		for i, sticker in ipairs(section) do
			Assets.textures["sticker_" .. tostring(sticker.id)] = exports.dpAssets:createTexture("stickers/" .. sticker.id .. ".png")
		end
	end

	Assets.fonts = {
		menu = exports.dpAssets:createFont("Roboto-Regular.ttf", 22),
		colorMenuHeader = exports.dpAssets:createFont("Roboto-Regular.ttf", 20),
		colorMenuPrice = exports.dpAssets:createFont("Roboto-Regular.ttf", 18),
		componentName = exports.dpAssets:createFont("Roboto-Regular.ttf", 30),
		menuLabel = exports.dpAssets:createFont("Roboto-Regular.ttf", 18),
		helpText = exports.dpAssets:createFont("Roboto-Regular.ttf", 16),
		moneyText = exports.dpAssets:createFont("Roboto-Regular.ttf", 24),
		levelText = exports.dpAssets:createFont("Roboto-Regular.ttf", 14),
		controlIconButton = exports.dpAssets:createFont("Roboto-Regular.ttf", 18),
		stickersGridText = exports.dpAssets:createFont("Roboto-Regular.ttf", 12),

		tuningPanelText = exports.dpAssets:createFont("Roboto-Regular.ttf", 14),
		componentItem = exports.dpAssets:createFont("Roboto-Regular.ttf", 16),
		componentItemInfo = exports.dpAssets:createFont("Roboto-Regular.ttf", 13),
		stickerPreviewHelp = exports.dpAssets:createFont("Roboto-Regular.ttf", 12),
	}
end

function Assets.stop()
	for name, texture in pairs(Assets.textures) do
		if isElement(texture) then
			destroyElement(texture)
		end
	end

	for name, font in pairs(Assets.fonts) do
		if isElement(font) then
			destroyElement(font)
		end
	end	
end