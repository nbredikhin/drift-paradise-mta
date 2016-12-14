function getMillisecondsFromHours(hours)
    if type(hours) ~= "number" then
        return false
    end
    return math.floor(hours * 60 * 60 * 1000)
end