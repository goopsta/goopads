-- roblox --  

local http   = require("coro-http")
local json   = require("json")
local fs     = require("fs")

local roblox = {}

function roblox.get_inventory(id)
    local res, body = http.request("GET", "https://inventory.roblox.com/v1/users/" .. id .. "/assets/collectibles?sortOrder=Asc&limit=100")
    if res.code < 200 or res.code >= 300 then
        return print("ROBLOX MODULE: failed to request inv: "..res.reason)
    end

    local parsed = json.decode(body).data
    return parsed
end

function roblox.get_user(id)
    local res, body = http.request("GET", "https://users.roblox.com/v1/users/"..id)
    if res.code < 200 or res.code >= 300 then
        return print("failed to request user: "..res.reason)
    end

    local parsed = json.decode(body)
    return parsed
end

function roblox.get_item_of_inventory(id, item)
    -- todo: get an item from the users inventory by passing the item id
    -- search through player inventory

    for i,v in pairs(roblox.get_inventory(id)) do
        if type(v) == "table" then
            if v.assetId == item then
                return v
            end
        end
    end
end

return roblox
