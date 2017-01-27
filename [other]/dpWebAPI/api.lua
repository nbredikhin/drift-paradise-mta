function processRequest(url, requestHeaders, cookies, hostname)
    local query = urlParser.parse(url).query
    if not query.username then
        return false
    end
    local result = exports.dpCore:getUserAccount(query.username)
    if not result then
        result = { error = "User not found" }
    end
    return {
        data = toJSON(result),
        headers = {
            ["Access-Control-Allow-Origin"] = "*",
            ["Access-Control-Allow-Methods"] = "GET,PUT,POST,DELETE,OPTIONS",
            ["Access-Control-Allow-Headers"] = "X-Requested-With,Content-Type,Cache-Control",
        }
    }
end