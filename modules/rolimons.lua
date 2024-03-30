local http     = require("coro-http")
local json     = require("json")
local fs       = require("fs")
local roblox   = require("./roblox")
local log      = require("./log")

local config = json.parse(fs.readFileSync("./config.json"))

local rolimons = {}

-- rolimons --

function rolimons.post_ad(parameters)
    local offering = parameters.offering
    local tags = parameters.tags

    local url = "https://www.rolimons.com/tradeapi/create"

    local headers = {
        {"Content-Type", "application/json"},
        {"Cookie", "_RoliVerification="..config.auth.cookie},
        {"User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36 Edg/122.0.0.0"}
    }

    local ad = {
        player_id = roblox.get_user(config.auth.userid).id,
        offer_item_ids = offering,
        request_item_ids = { },
        request_tags = tags
    }


    local body = json.encode(ad)

    if config.test_mode ~= true then
        local res,body = http.request("POST", url, headers, body)

        if res.code < 200 or res.code >= 300 then
            return log.msg("failed to send: "..res.reason, "RED")
        end

        if json.parse(body).message == "Ad creation cooldown has not elapsed" then
            return log.msg("\nfailed to send trade because the creation cooldown has not elapsed\ntry increasing your cooldown!\n", "RED")
        end
    end

    log.msg("successfully posted trade ad!", "GREEN")

    local pstring = [[
            
----------------------------------
offering:
]]

    for i,v in pairs(offering) do
        pstring = pstring..""..roblox.get_item_of_inventory(roblox.get_user(config.auth.userid).id, v).name.."\n"
    end
    pstring = pstring.."\n----------------------------------\nrequesting:\n----------------------------------\ntags:\n"

    for i,v in pairs(tags) do
        pstring = pstring..""..v.."\n"
    end

    pstring = pstring.."\n----------------------------------"

    if config.connections.webhook then
        local wh_body = json.encode({
            content = "new ad sent by goopads!\n```\n"..pstring.."\n```"
        })

        local wh_headers = {
            {"Content-Type", "application/json"},
            {"User-Agent", "goopads"},
        }

        local wh_res, wh_body = http.request("POST", config.connections.webhook_url, wh_headers, wh_body, 5000)
        if wh_res.code < 200 or wh_res.code >= 300 then
            return log.msg("failed to send webhook: "..res.reason, "RED")
        end
    end

    log.msg(pstring, "GREEN")
end

return rolimons
