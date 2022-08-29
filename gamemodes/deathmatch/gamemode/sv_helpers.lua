include( "addonLists.lua" )
include( "settings.lua" )

local playerLoadouts = {}

function dumbShit()
    print("-----------dumbShiz-------------")
end

function GM:PlayerSay( sender, text, teamChat )
	if (text == "give me some ammo!") then sender:GiveAmmo(1000, sender:GetActiveWeapon():GetPrimaryAmmoType(), false) end
    if (text == "update team name") then end
	if (text == "update time") then round_min = 9 end
    if (text == "run heler 1") then dumbShit() end
    print("doo doo")
    return text
end

function InitializeLoadOut(Player)
    --add database case at some point
    --else
    local tempLoadOut = {}
    tempLoadOut.primary = weaponList.AR[1]
    tempLoadOut.secondary = weaponList.PISTOL[1]
    tempLoadOut.melee = weaponList.MELEE[1]
    playerLoadouts[Player:GetPlayerInfo()["guid"]] = tempLoadOut --add new player to player loadouts table
end

function GetCurrentLoadOut(Player)
    local tempLoadOut = playerLoadouts[Player:GetPlayerInfo()["guid"]]
    Player:Give(tempLoadOut.primary)
    Player:Give(tempLoadOut.secondary)
    Player:Give(tempLoadOut.melee)
    Player:Give("weapon_frag")
end

function SetCurrentLoadOut(Player, primary, secondary, melee)

    local tempLoadOut = {}
    tempLoadOut.primary = primary
    tempLoadOut.secondary = secondary
    tempLoadOut.melee = melee
 
    playerLoadouts[Player:GetPlayerInfo()["guid"]] = tempLoadOut
end