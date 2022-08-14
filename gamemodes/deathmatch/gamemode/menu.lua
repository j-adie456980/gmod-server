include("lang.lua")
-- Menu system
function menu()
		local teamselector = vgui.Create( "DFrame" )
			teamselector:SetPos( ScrW()/2-150, ScrH()/2-150 )
			teamselector:SetSize( 300, 300 )
			teamselector:SetTitle( "Derma Paint" )
			teamselector:SetVisible( true )
			teamselector:SetDraggable( false )
			teamselector:ShowCloseButton( false )
			teamselector:MakePopup()
			teamselector.Paint = function()
				draw.RoundedBox( 8, 0, 0, teamselector:GetWide(), teamselector:GetTall(), Color( 0, 0, 0, 255 ) )
			end
		
		local team1btn = vgui.Create( "DButton" )
		team1btn:SetParent(teamselector)
		team1btn:SetPos(50, 170)
		team1btn:SetSize(100, 40 )
		team1btn:SetText(joinname..team1)
		team1btn.DoClick = function()
			net.Start( "team" )
				net.WriteString( "1" )
			net.SendToServer()
			teamselector:Close()
		end
		
		local team2btn = vgui.Create( "DButton" )
		team2btn:SetParent(teamselector)
		team2btn:SetPos(350, 170)
		team2btn:SetSize(100, 40 )
		team2btn:SetText(joinname..team2)
		team2btn.DoClick = function()
			net.Start( "team" )
				net.WriteString( "2" )
			net.SendToServer()
			teamselector:Close()
		end
		
		function team1num(data)
			local team1_num = vgui.Create("DLabel")
			team1_num:SetPos(50,140)
			team1_num:SetSize(100,20)
			team1_num:SetParent(teamselector)
			team1_num:SetText(playername.." :"..data:ReadLong())
		end
		usermessage.Hook("team1num", team1num)
		
		function team2num(data)
			local team2_num = vgui.Create("DLabel")
			team2_num:SetPos(350,140)
			team2_num:SetSize(100,20)
			team2_num:SetParent(teamselector)
			team2_num:SetText(playername.." :"..data:ReadLong())
		end
		usermessage.Hook("team2num", team2num)
		
		
		local team1_model = vgui.Create( "DModelPanel",teamselector )
			team1_model:SetPos( 50, 10 )
			team1_model:SetSize( 100, 150 )
			team1_model:SetModel( "models/player/group01/male_07.mdl" )
			
		local team2_model = vgui.Create( "DModelPanel",teamselector )
			team2_model:SetPos( 350, 10 )
			team2_model:SetSize( 100, 150 )
			team2_model:SetModel( "models/player/odessa.mdl" )
		

end
usermessage.Hook("teamselector", menu)
