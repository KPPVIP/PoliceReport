local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")

CreateThread(function()
    MySQL.Async.execute('CREATE TABLE IF NOT EXISTS policereports (id int AUTO_INCREMENT, identifier varchar(100), name varchar(100), number varchar(20), description text, createdAt date DEFAULT CURDATE(), PRIMARY KEY(id))')
end)

RegisterNetEvent('lg: openAllReports')
AddEventHandler('lg: openAllReports', function()
    local idJ = source

    local user_id = vRP.getUserId({source})

    -- here you need to check the job of the player
    -- example: vRP.hasPermission({user_id, perm})
    for i,k in pairs(permissions) do
        if vRP.hasPermission({user_id, k}) then
            MySQL.Async.fetchAll('SELECT *, DATE_FORMAT(createdAt, "'.. date_format .. '") AS date FROM policereports ORDER BY id DESC', {},
            function(result)
                TriggerClientEvent('lg: openAllReports', idJ, result)
            end)

            break
        end
    end
end)

RegisterNetEvent('lg: openReport')
AddEventHandler('lg: openReport', function()
    local source = source
    local name = getName(source)

    -- here you get the player's name
    -- example: xPlayer.getName()
    TriggerClientEvent('lg: openReport', source, name)
end)

-- This function will return the Player Name
function getName(source)
    local user_id = vRP.getUserId({source})
    local name = GetPlayerName(source)
    local wait = true

    vRP.getUserIdentity({user_id, function(identity)
        if identity then
            if identity.nome then
                name = identity.nome .. " " .. identity.sobrenome
            else
                name = identity.firstname .. " " .. identity.name
            end
        end

        wait = false
    end})

    -- wait for name
    local time = 0
    while wait do
        Wait(0)

        if time == 3000 then
            break
        else
            time = time + 1
        end
    end

    return name
end

RegisterNetEvent('lg: saveReport')
AddEventHandler('lg: saveReport', function(data)
    local idJ = source

    local identifier = vRP.getUserId({idJ})

    local name = ""
    local str_anonymous = "No"

    if data.anonymous then
        name = "Anonymous"
        str_anonymous = "Yes"
    else
        name = data.name
    end

    MySQL.Async.execute('DELETE FROM policereports WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    }, function()
        MySQL.Async.insert('INSERT INTO policereports (name, number, description) VALUES (@name, @number, @description)',
        {
            ['@name'] = name, 
            ['@number'] = data.number, 
            ['@description'] = data.description
        }, function(insertedId)
            TriggerClientEvent("lg: PoliceReportNotify", idJ, translate.TR_NOTIFY_REPORT)

            if insertedId ~= 0 then
                local message = translate.TR_NAME .. ' ' .. data.name .. '\n' ..
                translate.TR_PHONE .. ' ' .. data.number .. '\n' ..
                translate.TR_DESCRIPTION .. ' ' .. data.description .. '\n' ..
                translate.TR_ANONYMOUS .. ' ' .. str_anonymous

                sendWebhook(WEBHOOK.DISCORD_URL, WEBHOOK.DISCORD_TITLE, message, WEBHOOK.COLOR)

                for i,k in pairs(permissions) do
                    local players = vRP.getUsersByPermission({k})
                    
                    for j,c in pairs(players) do
                        TriggerClientEvent('lg: PoliceReportNotify', c, translate.TR_NEW_REPORT)
                    end                
                end
            end
        end)
    end)
end)
 
function sendWebhook(DISCORD_WEBHOOK, DISCORD_TITLE, message, color)
    local send = {
        {
            ["color"] = color,
            ["title"] = DISCORD_TITLE,
            
            ['thumbnail'] = {
                ['url'] = WEBHOOK.SIMBOL_IMG,
                ['height'] = WEBHOOK.HEIGHT_SIMBOL,
                ['width'] = WEBHOOK.WIDTH_SIMBOL
            },
            ["description"] = message,
            ["footer"] = {
                ["text"] = WEBHOOK.DISCORD_FOOTER,
                ['icon_url'] = WEBHOOK.DISCORD_FOOTER_IMG
            },
        }
    }
    PerformHttpRequest(DISCORD_WEBHOOK, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = send, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
end