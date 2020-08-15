-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------

local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
local idgens = Tools.newIDGenerator()

-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------

rtk = {}
Tunnel.bindInterface("rtk_stockade",rtk)
vCLIENT = Tunnel.getInterface("rtk_stockade")

-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------

local timers = 0
local blips = {}

-----------------------------------------------------------------------------------------------------------------------------------------
-- WEBHOOK
-----------------------------------------------------------------------------------------------------------------------------------------

local webhookcarroforte = "linkdoseuwebhook"

function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKTIMERS
-----------------------------------------------------------------------------------------------------------------------------------------

function rtk.checkTimers()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getInventoryItemAmount(user_id,"laptop") >= 1 then
			local policia = vRP.getUsersByPermission("policia.permissao")
			if #policia < -1 then -- Informe o número de policiais necessários para startar o hacking.
				TriggerClientEvent("Notify",source,"aviso","Número insuficiente de policiais no momento.",8000)
				return false
			elseif (os.time()-timers) <= 3600 then
				TriggerClientEvent("Notify",source,"aviso","O sistema foi hackeado ou sofreu uma tentativa de hacking, aguarde <b>"..vRP.format(parseInt((3600-(os.time()-timers)))).." segundos</b> até que o mesmo retorne a funcionar.",8000)
				return false
			else
				timers = os.time()
				return true
			end
		else
			TriggerClientEvent("Notify",source,"importante","Precisa de um <b>Pendrive</b> para hackear o sistema.",8000)
			return false
		end
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKSTOCKADE
-----------------------------------------------------------------------------------------------------------------------------------------

function rtk.checkStockade()
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if user_id then
		vCLIENT.startStockade(source)
		SendWebhookMessage(webhookcarroforte,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- DROPAR
-----------------------------------------------------------------------------------------------------------------------------------------

function rtk.dropSystem(x,y,z)
	TriggerEvent("DropSystem:create","dinheiro-sujo",math.random(150000,250000),x,y,z,3600) -- Altere o math.random() para a quantidade desejada, caso queira um valor fixo, apenas tire o math.random()
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- RESETTIMER
-----------------------------------------------------------------------------------------------------------------------------------------

function rtk.resetTimer()
	timers = 0
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- MARCAR OCORRENCIA
-----------------------------------------------------------------------------------------------------------------------------------------

function rtk.markOcorrency(x,y,z)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local policia = vRP.getUsersByPermission("policia.permissao")
		for l,w in pairs(policia) do
			local player = vRP.getUserSource(parseInt(w))
			if player then
				async(function()
					local id = idgens:gen()
					blips[id] = vRPclient.addBlip(player,x,y,z,304,3,"Ocorrência",0.5,false)
					vRPclient._playSound(player,"CONFIRM_BEEP","HUD_MINI_GAME_SOUNDSET")
					TriggerClientEvent('chatMessage',player,"911",{64,64,255},"Recebemos uma denuncia de que um ^1Carro Forte^0 está sendo interceptado.")
					SetTimeout(50000,function() vRPclient.removeBlip(player,blips[id]) idgens:free(id) end)
				end)
			end
		end
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- GIVE MONEY
-----------------------------------------------------------------------------------------------------------------------------------------

function rtk.giveMoney()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		random = math.random(2000,4500)
		vRP.giveInventoryItem(user_id,"dinheiro-sujo",parseInt(random))
		TriggerClientEvent("Notify",source,"sucesso","Você roubou <b>"..random.."</b> de dinheiro sujo.")
	end
end