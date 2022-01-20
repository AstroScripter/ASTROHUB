local maxplayers, gamelink, goodserver, data_table = math.huge, "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
if not _G.FailedServerID then _G.FailedServerID = {} end

local function serversearch()
    data_table = game:GetService"HttpService":JSONDecode(game:HttpGetAsync(gamelink))
    for _, v in pairs(data_table.data) do
        pcall(function()
            if type(v) == "table" and v.id and v.playing and tonumber(maxplayers) > tonumber(v.playing) and not table.find(_G.FailedServerID, v.id) then
                maxplayers = v.playing
                goodserver = v.id
            end
        end)
    end
end

function getservers()
    pcall(serversearch)
    for i, v in pairs(data_table) do
        if i == "nextPageCursor" then
            if gamelink:find"&cursor=" then
                gamelink = gamelink:gsub(gamelink:sub(gamelink:find"&cursor="), "")
            end
            gamelink = gamelink .."&cursor="..v
            pcall(getservers)
        end
    end
end

wait()
pcall(getservers)
table.insert(_G.FailedServerID, goodserver)
game:GetService"TeleportService":TeleportToPlaceInstance(game.PlaceId, goodserver)
