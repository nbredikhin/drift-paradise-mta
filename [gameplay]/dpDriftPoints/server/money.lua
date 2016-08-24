addEvent("dpDriftPoints.earnedPoints", true)
addEventHandler("dpDriftPoints.earnedPoints", resourceRoot, function (points)
	local prize = math.floor(points / 1000)
	if prize < 1 then
		return
	end

	local money = client:getData("money")
	if not money then
		return
	end
	client:setData("money", money + prize)
end)