local http     = require("coro-http")
local json     = require("json")
local fs       = require("fs")
local roblox   = require("./roblox")
local rolimons = require("./rolimons")

local config = json.parse(fs.readFileSync("./config.json"))

local algorithm = {}

function algorithm.get_rand_item(parameters)
    local inv = roblox.get_inventory(parameters.id)
    local below = parameters.below or math.huge
    local above = parameters.above or 0

    local items = {}
    local skipped = {}

    for i,v in pairs(roblox.get_inventory(config.auth.userid)) do
        if v.recentAveragePrice > above and v.recentAveragePrice < below then
            if v.isOnHold and config.config.exclude_held then
                skipped[#skipped+1] = v
            else
                items[#items+1] = v.assetId
            end
        end
    end

    local rand = math.random(1,#items)
    return items[rand]
end

function algorithm.create_upgrade_offering()
    local amt = math.random(2,4)

    local offering = {}

    local count = 1
    repeat
        offering[#offering+1] = algorithm.get_rand_item({id = config.auth.userid})
        count = count + 1
    until count == amt

    return offering
end

function algorithm.create_downgrade_offering()
    local offering = {}

    offering[#offering+1] = algorithm.get_rand_item({id = config.auth.userid, above = 1800})

    return offering
end

return algorithm
