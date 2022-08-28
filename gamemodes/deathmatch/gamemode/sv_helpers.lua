include( "settings.lua" )

function dumbShit()
    print("-----------dumbShiz-------------")
end

function GM:PlayerSay( sender, text, teamChat )
	if (text == "give me some ammo!") then sender:GiveAmmo(1000, sender:GetActiveWeapon():GetPrimaryAmmoType(), false) end
    if (text == "update team name") then 
        TeamNames = { 'A', 'B', 'C', 'D'}
        team.SetClass(1, TeamNames) 
        team_name_1 = "A"
        team_name_2 = "B"
    end
	if (text == "update time") then round_min = 9 end
    if (text == "run heler 1") then dumbShit() end
    print("doo doo")
    return text
end