AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_hud.lua" )
AddCSLuaFile( "shop.lua" )
AddCSLuaFile( "lang.lua" )
AddCSLuaFile( "settings.lua" )
AddCSLuaFile( "menu.lua" )
AddCSLuaFile( "addonLists.lua" )
AddCSLuaFile( "selectTeamMenu.lua" )
AddCSLuaFile( "selectWeaponMenu.lua" )
AddCSLuaFile( "help.lua" )
AddCSLuaFile( "sv_helpers.lua" )

include( "settings.lua" )
include( "sv_roundSystem.lua" )
include( "shared.lua" )
include( "lang.lua")
include( "addonLists.lua" )
include( "sv_helpers.lua" )

resource.AddFile(c_sound)
resource.AddFile(t_sound)
resource.AddFile(n_sound)
resource.AddFile(f_sound)

local first = true

local thirdperson = false

local model_team1 = modelList[1]

local model_team2 = modelList[2]

util.AddNetworkString( "PlayerJoinedMsg" )

function GM:PlayerInitialSpawn( ply )
	ply:KillSilent()
	ply:GodEnable()
	ply:Freeze(true)
	ply:Spectate( OBS_MODE_ROAMING )
   	ply:SpectateEntity( ent )
	InitializeLoadOut(ply)
	umsg.Start("SelectTeamMenu", ply)
	umsg.End()
end

function GM:PlayerSpawn( ply )

	ply:Freeze(false)
	
	ply:AllowFlashlight(true)
	
	print("--PlayerSpawn--")
	print("Team Num: ", ply:Team())
	print("Team Name: ", team.GetName(ply:Team()))

	if ply:Team() == 4 then
		ply:GodEnable()
		ply:Freeze(true)
		ply:Spectate( OBS_MODE_ROAMING )
   	 	ply:SpectateEntity( ent )
		umsg.Start("SelectTeamMenu", ply)
		umsg.End()
	else
	if ply:Team() == 3 then
    	ply:Spectate( OBS_MODE_ROAMING )
   	 	ply:SpectateEntity( ent )
	else
		ply:GodDisable()
		ply:UnSpectate()
	
	if ply:Team() == 1 then
		ply:SetTeam(1)
		ply:SetModel(model_team1)
		ply:GiveAmmo(64, "Pistol", true)
		ply:SetArmor(100)
		GetCurrentLoadOut(ply)
		
	elseif ply:Team() == 2 then
		ply:SetTeam(2)
		ply:SetModel(model_team2)
		ply:GiveAmmo(64, "Pistol", true)
		ply:SetArmor(100)
		GetCurrentLoadOut(ply)
	end
	ply:SetupHands()
	end
	umsg.Start("getteam", ply )
	umsg.Long(ply:Team())
	umsg.End()
	if ply:Team() ~= 3 then
	if ply:Team() ~= 4 then
	if allowbuy == false then
	umsg.Start("open", ply )
	umsg.End()
	end
	end
	end
	end
end

function GM:ShowHelp( ply )
	--PrintTable(team.GetClass(1))
	--print(ply)
end

function GM:ShowSpare2( ply )
	umsg.Start("getteam", ply )
	umsg.Long(ply:Team())
	umsg.End()
	if ply:Team() ~= 3 then
	if allowbuy == true then
	if allowbuylater == true then
		buy()
	end
	else
	buy()
	end
	else
	buy()
	end
end

-- OPEN TEAM MENU F2 --
function GM:ShowTeam( ply )
	umsg.Start("SelectTeamMenu", ply )
	umsg.End()
end

-- OPEN WEAPON MENU F3 --
function GM:ShowSpare1( ply )
	umsg.Start("SelectWeaponMenu", ply )
	umsg.End()
end

function buy()
umsg.Start("open", ply)
umsg.End()
end

function GM:PlayerDeath( victim, inflictor, attacker )
victim:Freeze( true )
umsg.Start("killscreen", victim)
umsg.String(attacker:Name())
umsg.End()
umsg.Start("weapon", victim)
umsg.String(attacker:GetActiveWeapon())
umsg.End()
umsg.Start("coins", attacker)
umsg.End()
end

function GM:PlayerShouldTakeDamage( ply, victim )
if ply:IsPlayer() then
	if victim:IsPlayer() then
		if(ply:Team() == victim:Team()) then
			return false
		end
	end
end
if first == true then
	if first_blood == true then
		surface.PlaySound(f_sound)
	end
	first = false
end
-- Coins for the killer
return true
end
function GM:PlayerConnect( name, ip )
   PrintMessage( HUD_PRINTTALK,"[Server]" .. name .. joinmsg)
end

util.AddNetworkString( "SelectLoadout" )
net.Receive( "SelectLoadout", function(len, ply) 
	local weapons = net.ReadTable()
	local primary = weapons[1]
	local secondary = weapons[2]
	local melee = weapons[3]
	SetCurrentLoadOut(ply, primary, secondary, melee)
end )

util.AddNetworkString( "w" )
net.Receive( "w", function(len, ply)  
local we = net.ReadString()
	if we == "smg" then
		ply:Give("weapon_smg1")
	elseif we == "ps_ammo" then
		ply:GiveAmmo(20, "Pistol", true)
	elseif we == "smg_ammo" then
		ply:GiveAmmo(20, "SMG1", true )
	elseif we == "shotgun" then
		ply:Give("weapon_zm_shotgun")
	elseif we == "shotgun_ammo" then
		ply:GiveAmmo(20, "buckshot",true)
	elseif we == "mac" then
		ply:Give("weapon_zm_mac10")
	elseif we == "mac_ammo" then
		ply:GiveAmmo(30, "smg1",true)
	elseif we == "rifle" then
		ply:Give("weapon_zm_rifle")
	elseif we == "rifle_ammo" then
		ply:GiveAmmo(6,"357",true)
	elseif we == "car" then
		local car = ents.Create( "prop_vehicle_jeep_old" )
		car:SetModel( "models/buggy.mdl" )
		car:SetKeyValue("vehiclescript", "scripts/vehicles/jeep_test.txt")
		car:SetPos(ply:GetPos() + Vector(0,10,0))
		car:SetAngles(Angle(0,-90,0))
		car:Spawn()
	else
		ply:Give(we)
	end
end )

util.AddNetworkString("team")
net.Receive( "team", function(len, ply) 
	local teamselect = net.ReadString()
	if teamselect == "1" then
		ply:SetTeam(1)
	else
		ply:SetTeam(2)
	end
	net.Start( "PlayerJoinedMsg" )
		net.WriteInt(ply:Team(), 8)
		net.WriteTable( ply:GetPlayerInfo() )
	net.Broadcast()
	ply:KillSilent()
	ply:Spawn()
end )

util.AddNetworkString("z")
net.Receive( "z", function(len, ply) 
	local z = net.ReadString()
	if z == "spec" then
		ply:KillSilent()
		ply:SetTeam(3)
		ply:KillSilent()
		ply:Spawn()

	elseif z == "team" then
		ply:KillSilent()
		ply:SetTeam(4)
		ply:KillSilent()
		ply:Spawn()
		
	elseif z == "respawn" then
		ply:Freeze(false)
		if ply:Team() ~= 3 then
			ply:KillSilent()
			ply:SetTeam(4)
			ply:KillSilent()
			ply:Spawn()
		end
	elseif z == "end" then
		for k, v in pairs(player.GetAll()) do
			v:SetFrags(0)
			v:SetDeaths(0)
		end
	elseif z == "spawn" then
		ply:Spawn()
		print("CLIENT CALL TO SERVER - Z SPAWN")
	elseif z == "un" then
		ply:Freeze(true)
	elseif z == "an" then
		ply:Freeze(false)
	elseif z == "mapvote" then
		MapVote.Start(20,true,20,"")
	end
end ) 

function GM:PlayerSetHandsModel( ply, ent )

	local simplemodel = player_manager.TranslateToPlayerModelName( ply:GetModel() )
	local info = player_manager.TranslatePlayerHands( simplemodel )
	if ( info ) then
		ent:SetModel( info.model )
		ent:SetSkin( info.skin )
		ent:SetBodyGroups( info.body )
	end

end