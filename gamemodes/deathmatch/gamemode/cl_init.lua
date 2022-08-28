include( "shared.lua" )
include( "cl_hud.lua" )
include( "round.lua" )
include( "shop.lua" )
include( "lang.lua" )
include( "settings.lua" )
include( "menu.lua" )
include( "selectTeamMenu.lua" )
include( "selectWeaponMenu.lua" )
include( "help.lua" )
include( "addonLists.lua" )
include( "sv_helpers.lua" )

net.Receive( "PlayerJoinedMsg", function(len, ply)
    local teamNum = net.ReadInt(8)
    local playerSent = net.ReadTable()
    local teamColor = Color( 54, 212, 222, 255 )
    
    if (LocalPlayer():Team() ~= teamNum and LocalPlayer():GetPlayerInfo()["guid"] ~= playerSent["guid"]) then 
        teamColor = Color( 222, 54, 54, 255 ) 
    end

    chat.AddText( Color( 115, 255, 112, 255 ), playerSent["name"], Color( 255, 255, 255, 255 ), " has joined ", teamColor, team.GetName(teamNum) )
end )