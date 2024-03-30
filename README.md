# goopads, the solution to manual trading
goopads is an automatic trade advert posting system for the roblox trading fansite "rolimons"

# SETUP
if you don't have luvit installed and you're skeptical of the given luvit binary, you can install luvit from https://luvit.io/ and insert the luvit.exe it gives you into the folder that goopads is in.

make sure your roblox inventory is public, or else goopads won't be able to scrape your items to put onto your advertisements.
# CONFIG
test_mode: (bool) turn this on if you just want to test your config, it does not send any ads to the rolimons site

cookie: (string) insert your _RoliVerification cookie from the rolimons website into here (you can get this by using editthiscookie)

userid: (number) insert your roblox user id (used to get items from your inventory (MAKE SURE YOUR INVENTORY IS PUBLIC))


delay: (number) the number of minutes between posting ads (the rolimons minimum is 15 minutes)

exclude_held: (bool) use this if you do not want to send out ads with items that are currently within the trading hold period

downgrade_only: (bool) use this if you only want to send downgrade tagged ads

upgrade_only: (bool) same as downgrade_only, but with upgrades

webhook: (bool) use this if you would like to log all your trade ads to a discord webhook

webhook_url: (string) insert your webhook url
