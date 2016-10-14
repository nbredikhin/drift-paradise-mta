RPC.method("request", function (client, data)
    RPC.call(client, "response", tostring(data) .. " World")
end)