function dxDrawBorderedText(text, left, top, right, bottom, color, borderColor, scale, font, alignX, alignY, clip, wordBreak, postGUI,
        colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    for oX = -1, 1 do
        for oY = -1, 1 do
            dxDrawText(text, left + oX, top + oY, right + oX, bottom + oY, borderColor, scale, font,
                alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
        end
    end
    dxDrawText(text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI)
end
