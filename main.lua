local date = tonumber(os.date("%Y%m%d"))

if date > 20231200 then
    return
else
    module.load(header.id, "Champion/" .. player.charName) -- .. "/main"
end
