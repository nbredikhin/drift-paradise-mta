addEvent("dpDriftPoints.earnedPoints")
addEventHandler("dpDriftPoints.earnedPoints", resourceRoot, function (points)
	triggerServerEvent("dpDriftPoints.earnedPoints", resourceRoot, points)
end)