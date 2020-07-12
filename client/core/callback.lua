local clientCallbacks = {}
local currentRequest = 0
local dbg = rdebug()

function callCallback(name,cb,...)
    clientCallbacks[currentRequest] = cb
    dbg.securitySpam('Calling from client side with key %s request %s',getClientKey(GetCurrentResourceName()),name)
    TSE('rcore:callCallback',getClientKey(GetCurrentResourceName()),name,currentRequest,GetPlayerServerId(PlayerId()),...)

    if currentRequest < 65535 then
        currentRequest = currentRequest + 1
    else
        currentRequest = 0
    end
end

exports('callCallback',callCallback)

RegisterNetEvent('rcore:callback')
AddEventHandler('rcore:callback',function(requestId,...)
    if clientCallbacks[requestId] == nil then
        return
    end
    clientCallbacks[requestId](...)
    TSE('rcore:callbackSended',requestId)
end)
