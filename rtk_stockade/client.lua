-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------

local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------

rtk = {}
Tunnel.bindInterface("rtk_stockade",rtk)
vSERVER = Tunnel.getInterface("rtk_stockade")

-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------

local pos = 0
local nveh = nil
local pveh01 = nil
local pveh02 = nil
local plantando = false
local hackeado = false
local explodiu = false

-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCAL DE INICIO DO HACKING
-----------------------------------------------------------------------------------------------------------------------------------------
local CoordenadaX = 248.7
local CoordenadaY = 209.64
local CoordenadaZ = 106.29
-----------------------------------------------------------------------------------------------------------------------------------------

-- 248.7, 209.64, 106.29

-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCS
-----------------------------------------------------------------------------------------------------------------------------------------

local locs = {
	[1] = { ['x'] = -1221.98, ['y'] = -317.20, ['z'] = 37.60, ['x2'] = 3592.08, ['y2'] = 3763.92, ['z2'] = 29.97, ['h'] = 296.26, ['lugar'] = "1/8" },
	[2] = { ['x'] = -347.37, ['y'] = -26.85, ['z'] = 47.44, ['x2'] = 1245.13, ['y2'] = -3142.11, ['z2'] = 5.55, ['h'] = 248.83, ['lugar'] = "2/8" },
	[3] = { ['x'] = 262.77, ['y'] = 183.03, ['z'] = 104.38, ['x2'] = -343.11, ['y2'] = -925.10, ['z2'] = 30.23, ['h'] = 69.89, ['lugar'] = "3/8" },
	[4] = { ['x'] = 315.79, ['y'] = -264.95, ['z'] = 53.89, ['x2'] = -959.25, ['y2'] = -3047.97, ['z2'] = 13.94, ['h'] = 247.07, ['lugar'] = "4/8" },
	[5] = { ['x'] = 136.28, ['y'] = -1022.26, ['z'] = 29.31, ['x2'] = -1134.31, ['y2'] = 2693.17, ['z2'] = 18.80, ['h'] = 248.58, ['lugar'] = "5/8" },
	[6] = { ['x'] = -2960.66, ['y'] = 466.03, ['z'] = 15.17, ['x2'] = 1710.03, ['y2'] = -1631.85, ['z2'] = 112.48, ['h'] = 84.10, ['lugar'] = "6/8" },
	[7] = { ['x'] = -130.42, ['y'] = 6467.32, ['z'] = 31.40, ['x2'] = 2712.63, ['y2'] = 1521.84, ['z2'] = 24.50, ['h'] = 133.70, ['lugar'] = "7/8" },
	[8] = { ['x'] = 1175.08, ['y'] = 2695.01, ['z'] = 37.92, ['x2'] = -446.65, ['y2'] = -452.10, ['z2'] = 32.95, ['h'] = 107.89, ['lugar'] = "8/8" }
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- HACKEAR
-----------------------------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		local idle = 500
		local ped = PlayerPedId()
		local x,y,z = table.unpack(GetEntityCoords(ped))
		if Vdist(CoordenadaX,CoordenadaY,CoordenadaZ,x,y,z) <= 10 then
			idle = 4
			if Vdist(CoordenadaX,CoordenadaY,CoordenadaZ,x,y,z) <= 3 then
				DrawMarker(21,CoordenadaX,CoordenadaY,CoordenadaZ-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,255,0,0,50,0,0,0,1)
				if Vdist(CoordenadaX,CoordenadaY,CoordenadaZ,x,y,z) <= 1 then
					drawTxt("PRESSIONE  ~r~E~w~  PARA HACKEAR",4,0.5,0.87,0.50,255,255,255,180)
					if IsControlJustPressed(0,38) and vSERVER.checkTimers() and not hackeado then
						TriggerEvent('cancelando',true)
						vRP._playAnim(false,{{"missheist_jewel@hacking","hack_loop"}},true)
						SetEntityHeading(ped,338.41)
						TriggerEvent("mhacking:show")
						TriggerEvent("mhacking:start",6,20,mycallback)
						hackeado = true
					end
				end
			end
		end
		Citizen.Wait(idle)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- HACKEAR
-----------------------------------------------------------------------------------------------------------------------------------------

function mycallback(success,time)
	if success then	
		TriggerEvent("mhacking:hide")
		vSERVER.checkStockade()
		vRP._stopAnim(false)
		TriggerEvent('cancelando',false)
	else
		TriggerEvent("mhacking:hide")
		vSERVER.resetTimer()
		vRP._stopAnim(false)
		TriggerEvent('cancelando',false)
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTSTOCKADE
-----------------------------------------------------------------------------------------------------------------------------------------

function rtk.startStockade()
	pos = math.random(#locs)
	rtk.spawnStockade(locs[pos].x,locs[pos].y,locs[pos].z,locs[pos].x2,locs[pos].y2,locs[pos].z2,locs[pos].h)
	TriggerEvent("Notify","aviso","Hackeado com sucesso, o carro forte está saindo do <b>Banco "..locs[pos].lugar.."</b>.",8000)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWNVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------

function rtk.spawnStockade(x,y,z,x2,y2,z2,h)
  local vhash = GetHashKey("stockade")
  
  RequestModel(vhash)
	while not HasModelLoaded(vhash) do
		RequestModel(vhash)
		Citizen.Wait(10)
	end

	local phash = GetHashKey("s_m_m_security_01")
	RequestModel(phash)

	while not HasModelLoaded(phash) do
		RequestModel(phash)
		Citizen.Wait(10)
	end

	
	SetModelAsNoLongerNeeded(phash)
	if HasModelLoaded(vhash) then
		nveh = CreateVehicle(vhash,x,y,z+0.5,h,true,false)
   		SetVehicleOnGroundProperly(nveh)
		SetEntityInvincible(nveh,false)
		SetEntityAsMissionEntity(nveh,true,true)
    	SetVehicleDoorsLocked(nveh,2)
		SetEntityAsNoLongerNeeded(nveh)
		
		blip = AddBlipForEntity(nveh)
		SetBlipAsFriendly(blip,1)
		SetBlipSprite(blip, 67)
		SetBlipColour(blip, 25)
		SetBlipScale(blip, 0.6)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Carro-Forte | ~g~Cheio")
		EndTextCommandSetBlipName(blip)

		pveh01 = CreatePedInsideVehicle(nveh,4,GetHashKey("s_m_m_security_01"),-1,true,false)
		pveh02 = CreatePedInsideVehicle(nveh,4,GetHashKey("s_m_m_security_01"),0,true,false)
		pveh03 = CreatePedInsideVehicle(nveh,4,GetHashKey("s_m_m_security_01"),1,true,false)
		pveh04 = CreatePedInsideVehicle(nveh,4,GetHashKey("s_m_m_security_01"),2,true,false)
		setPedPropertys(pveh01,"WEAPON_MINISMG")
		setPedPropertys(pveh02,"WEAPON_MINISMG")
		setPedPropertys(pveh03,"WEAPON_CARBINERIFLE")
		setPedPropertys(pveh04,"WEAPON_CARBINERIFLE")

		SetEntityAsMissionEntity(pveh01,false,false)
		SetEntityAsMissionEntity(pveh02,false,false)
		SetEntityAsMissionEntity(pveh03,false,false)
		SetEntityAsMissionEntity(pveh04,false,false)

		TaskVehicleDriveToCoordLongrange(pveh01,nveh,x2,y2,z2,10.0,1074528293,1.0)
	end
end

function setPedPropertys(npc,weapon)
	SetPedShootRate(npc,850)
	SetPedSuffersCriticalHits(npc,0) -- Altere para 1 caso queira que o NPC morra com apenas um tiro na cabeça.
	SetPedAlertness(npc,100)
	AddArmourToPed(npc,100)
	SetPedAccuracy(npc,100)
	SetPedArmour(npc,100)
	SetPedCanSwitchWeapon(npc,true)
	SetEntityHealth(npc,300)
	SetPedFleeAttributes(npc,0,0)
	SetPedConfigFlag(npc,118,false)
	SetPedCanRagdollFromPlayerImpact(npc,0)
	SetPedCombatAttributes(npc,46,true)
	SetEntityIsTargetPriority(npc,1,0)
	SetPedGetOutUpsideDownVehicle(npc,1)
	SetPedPlaysHeadOnHornAnimWhenDiesInVehicle(npc,1)
	SetPedKeepTask(npc,true)
	SetEntityLodDist(npc,250)
	SetPedCombatAbility(npc,2)
	SetPedCombatRange(npc,50)
	SetPedPathAvoidFire(npc,1)
	SetPedPathCanUseLadders(npc,1)
	SetPedPathCanDropFromHeight(npc,1)
	SetPedPathPreferToAvoidWater(npc,1)
	SetPedGeneratesDeadBodyEvents(npc,1)
	GiveWeaponToPed(npc,GetHashKey(weapon),5000,true,true)
	SetPedDropsWeaponsWhenDead(npc, false)
	SetPedCombatAttributes(npc,1,false)
	SetPedCombatAttributes(npc,13,false)
	SetPedCombatAttributes(npc,6,true)
	SetPedCombatAttributes(npc,8,false)
	SetPedCombatAttributes(npc,10,true)
	SetPedFleeAttributes(npc,512,true)
	SetPedConfigFlag(npc,118,false)
	SetPedFleeAttributes(npc,128,true)
	SetEntityLoadCollisionFlag(npc,true)

	SetPedRelationshipGroupHash(npc,GetHashKey("security_guard"))
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- START
-----------------------------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		local idle = 500
		local ped = PlayerPedId()
		local x,y,z = table.unpack(GetEntityCoords(nveh))
		local x2,y2,z2 = table.unpack(GetOffsetFromEntityInWorldCoords(nveh,0.0,-4.0,0.5))
		local coords = GetEntityCoords(ped)
		local dst = GetDistanceBetweenCoords(coords, x,y,z, true)
			if IsPedDeadOrDying(pveh01) and IsPedDeadOrDying(pveh02) and IsPedDeadOrDying(pveh03) and IsPedDeadOrDying(pveh04) and not DoesEntityExist(c4) then
				if not explodiu then
					SetVehicleDoorShut(nveh,2,true)
					SetVehicleDoorShut(nveh,3,true)
				end
				if dst <= 5 then
					idle = 4
					if dst <= 7 and GetClosestVehicle(x,y,z, 4, 1747439474, 16384) and hackeado and not plantando then
						drawTxt("PRESSIONE  ~r~E~w~  PARA PLANTAR A C4",4,0.5,0.87,0.50,255,255,255,180)
						if IsControlJustPressed(0,38) then
							plantando = true
							vSERVER.markOcorrency(x,y,z)
							local c4_hash = GetHashKey("prop_bomb_01")
							local bag_hash = GetHashKey('p_ld_heist_bag_s_pro_o')
							loadModel(c4_hash)
						Wait(10)
							loadModel(bag_hash)
						Wait(10)
							local object = GetClosestObjectOfType(x,y,z,0.7,GetHashKey("door_dside_r"),0,0,0)
							local a2,b2,c2 = table.unpack(GetEntityCoords(object))
							c4 = CreateObject(c4_hash, (a2+b2+c2-20), true, true)
							local bag = CreateObject(bag_hash, coords-20, true, false)
							SetEntityAsMissionEntity(c4, true, true)
							SetEntityAsMissionEntity(bag, true, true)
							local boneIndexf1 = GetPedBoneIndex(PlayerPedId(), 28422)
							local bagIndex1 = GetPedBoneIndex(PlayerPedId(), 57005)
							vRP._playAnim(false,{{'anim@heists@ornate_bank@thermal_charge','thermal_charge'}},false)
						Wait(500)
							SetPedComponentVariation(PlayerPedId(), 5, 0, 0, 0)
							AttachEntityToEntity(c4, PlayerPedId(), boneIndexf1, 0.0,0.0,-0.18,0.0,0.0,-90.0, 0, 1, 1, 0, 1, 1, 1)
							AttachEntityToEntity(bag, PlayerPedId(), bagIndex1, 0.3, -0.25, -0.3, 300.0, 200.0, 300.0, true, true, false, true, 1, true)
						Wait(1700)
							DetachEntity(bag, 1, 1)
							FreezeEntityPosition(bag, true)
						Wait(2600)
							FreezeEntityPosition(bag, false)
							AttachEntityToEntity(bag, PlayerPedId(), bagIndex1, 0.3, -0.25, -0.3, 300.0, 200.0, 300.0, true, true, false, true, 1, true)
						Wait(1100)
							DetachEntity(c4, 1, 1)
							FreezeEntityPosition(c4, true)
						Wait(150)
							DeleteEntity(bag)
							SetPedComponentVariation(PlayerPedId(), 5, 40, 0, 0)
							vRP._stopAnim(false)
						Wait(100)
							local a1,b1,c1 = table.unpack(GetEntityCoords(c4))
							TriggerEvent("Notify","aviso","Você plantou a C4. <b>Afaste-se!</b><br>A C4 será acionada em <b>10 segundos</b>",8000)	
							local particleDictionary = "scr_adversary"
							local particleName = "scr_emp_prop_light"		
							RequestNamedPtfxAsset(particleDictionary)
								while not HasNamedPtfxAssetLoaded(particleDictionary) do
								Citizen.Wait(0)
								end					 
							beepSound = GetSoundId()

							PlaySoundFromEntity(beepSound, "Timer_10s", c4, "DLC_HALLOWEEN_FVJ_Sounds", 1, 0)
									
							SetPtfxAssetNextCall(particleDictionary)
							effect = StartParticleFxLoopedOnEntity(particleName, c4, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.20, 0, 0, 0)
						SetTimeout(10000,function()
							explodiu = true
							FreezeEntityPosition(c4, false)
							DeleteEntity(c4)
							SetVehicleDoorOpen(nveh,2,0,0)
							SetVehicleDoorOpen(nveh,3,0,0)
							NetworkExplodeVehicle(nveh,1,1,1)
							StopParticleFxLooped(effect, 0)
							StopSound(beepSound)
							ReleaseSoundId(beepSound)
							vSERVER.dropSystem(x2,y2,z2)
							RemoveBlip(blip)
							pveh01 = nil
							pveh02 = nil
							pveh03 = nil
							pveh04 = nil
							plantando = false
							hackeado = false	
						end)
					end
				end
			end
		end
		Citizen.Wait(idle)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------

function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

function loadModel(model)
    Citizen.CreateThread(function()
        while not HasModelLoaded(model) do
        	RequestModel(model)
        	Citizen.Wait(1)
        end
    end)
end
