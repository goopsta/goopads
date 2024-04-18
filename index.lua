
local http     = require("coro-http")
local json     = require("json")
local fs       = require("fs")
local roblox   = require("./modules/roblox")
local rolimons = require("./modules/rolimons")
local log      = require("./modules/log")
local alg      = require("./modules/alg")

local config = json.parse(fs.readFileSync("./config.json"))

function create_thread(func, ...)
	local thread = coroutine.create(func)
	coroutine.resume(thread, ...)
	return thread
end

function wait(seconds)
    local start = os.time()
    repeat until os.time() > start + seconds
end

function get_rand_ad_type()
    if config.config.downgrade_only == true then return "downgrade" end
    if config.config.upgrade_only   == true then return "upgrade"   end
    local rand = math.random(2)
    if rand == 1 then
        return "upgrade"
    else
        return "downgrade"
    end
end

function init()

    log.msg([[
            _ |\_
            \` ..\
        __,.-" =__Y=
        ."        )
 _    /   ,    \/\_
((____|    )_-\ \_-`
`-----'`-----` `--`]])
    log.trail("goop")
    log.msg("ads", "MAGENTA")
    log.trail("rolimons ", "BLUE")
    log.msg("automatic trade advert posting\n__________________________________\n")
    print("got user "..roblox.get_user(config.auth.userid).name.." ("..roblox.get_user(config.auth.userid).id..")")
    print("current user has "..#roblox.get_inventory(config.auth.userid).." items")

    print("posting first ad in 5 seconds")
    wait(5)
    print("attempting to post trade ad...")

    -- create first trade

    local ad_type = get_rand_ad_type()

    if ad_type == "upgrade" then
        rolimons.post_ad({
            offering = alg.create_upgrade_offering(),
            tags = {"upgrade"}
        })
    else
        rolimons.post_ad({
            offering = alg.create_downgrade_offering(),
            tags = {"downgrade"}
        })
    end

    log.msg("waiting "..config.config.delay.." minutes before sending out another ad...", "BLUE")

    local ad_type2 = "downgrade"

    while true do
        wait(60*config.config.delay)

        if ad_type2 == "upgrade" then
            rolimons.post_ad({
                offering = alg.create_upgrade_offering(),
                tags = {"upgrade"}
            })
	    if not config.config.upgrade_only then
	   	ad_type2 = "downgrade"
	    end
        else
            rolimons.post_ad({
                offering = alg.create_downgrade_offering(),
                tags = {"downgrade"}
            })
	    if not config.config.downgrade_only then
	    	ad_type2 = "upgrade"
	    end
        end
        
        log.msg("waiting "..config.config.delay.." minutes before sending out another ad...", "BLUE")
    end

end

init()
