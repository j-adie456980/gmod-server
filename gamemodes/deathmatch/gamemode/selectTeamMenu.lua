AddCSLuaFile( "addonLists.lua" )
include("addonLists.lua")



function SelectTeamMenu()

	print("--- SELECT TEAM MENU ---", LocalPlayer())

	local Backdrop = vgui.Create( "DFrame" )
	local BackdropWidth, BackDropHeight = ScrW(), 572;
		Backdrop:SetPos( 0, ScrH()/2-250 )
		Backdrop:SetSize( BackdropWidth, BackDropHeight )
		Backdrop:SetTitle( "" )
		Backdrop:SetVisible( true )
		Backdrop:SetDraggable( false )
		Backdrop:ShowCloseButton( true )
		Backdrop:MakePopup()
		Backdrop.Paint = function(self , w, h)
			surface.SetDrawColor( 0, 0, 0, 200 )
    		surface.DrawRect( 0, 0, w, h )
		end

	local Content = vgui.Create( "DLabel" )
	local ContentWidth, ContentHeight = ScrW(), 506;
		Content:SetParent(Backdrop)
		Content:SetPos( 0, BackDropHeight/2-(ContentHeight/2) )
		Content:SetSize( ContentWidth, ContentHeight )
		Content:SetText("")
		Content.Paint = function(self, w, h)
			surface.SetDrawColor( 66, 73, 85, 255 )
    		surface.DrawRect( 0, 0, w, h )
		end

	local ContentBorder = vgui.Create( "DLabel" )
		--TOP BORDER--
		ContentBorder:SetParent(Content)
		ContentBorder:SetPos( 0, 0 )
		ContentBorder:SetSize( ScrW(), 4 )
		ContentBorder:SetText( "" )
		ContentBorder.Paint = function(self, w, h)
			surface.SetDrawColor( 0, 0, 0, 255 )
    		surface.DrawRect( 0, 0, w, h )
		end
		--BOTTOM BORDER--
		ContentBorder = vgui.Create( "DLabel" )
		ContentBorder:SetParent(Content)
		ContentBorder:SetPos( 0, ContentHeight-4)
		ContentBorder:SetSize( ScrW(), 4 )
		ContentBorder:SetText( "" )
		ContentBorder.Paint = function(self, w, h)
			surface.SetDrawColor( 0, 0, 0, 255 )
    		surface.DrawRect( 0, 0, w, h )
		end

	local ContentDivider = vgui.Create( "DLabel" )
		--TOP DIVIDER--
		ContentDivider:SetParent(Content)
		ContentDivider:SetPos( ScrW()/2-(16/2), 0)
		ContentDivider:SetSize( 16, 136 )
		ContentDivider:SetText( "" )
		ContentDivider.Paint = function(self, w, h)
			surface.SetDrawColor( 0, 0, 0, 255 )
    		surface.DrawRect( 0, 0, w, h )
		end
		--BOTTOM DIVIDER--
		ContentDivider = vgui.Create( "DLabel" )
		ContentDivider:SetParent(Content)
		ContentDivider:SetPos( ScrW()/2-(16/2), ContentHeight-136)
		ContentDivider:SetSize( 16, 136 )
		ContentDivider:SetText( "" )
		ContentDivider.Paint = function(self, w, h)
			surface.SetDrawColor( 0, 0, 0, 255 )
    		surface.DrawRect( 0, 0, w, h )
		end

	local ModelFrame1 = vgui.Create( "DLabel" )
	local ModelFrameWidth, ModelFrameHeight = 295, 431;
		ModelFrame1:SetParent(Content)
		ModelFrame1:SetPos( ScrW()/2-186-ModelFrameWidth, (ContentHeight/2)-(ModelFrameHeight/2) )
		ModelFrame1:SetSize( ModelFrameWidth, ModelFrameHeight )
		ModelFrame1:SetText( "" )
		ModelFrame1.Paint = function(self, w, h)
			surface.SetDrawColor( 0, 0, 0, 100 )
    		surface.DrawRect( 0, 0, w, h )
		end
	local ModelFrame2 = vgui.Create( "DLabel" )
		ModelFrame2:SetParent(Content)
		ModelFrame2:SetPos( ScrW()/2+186, (ContentHeight/2)-(ModelFrameHeight/2))
		ModelFrame2:SetSize( ModelFrameWidth, ModelFrameHeight )
		ModelFrame2:SetText( "" )
		ModelFrame2.Paint = function(self, w, h)
			surface.SetDrawColor( 0, 0, 0, 100 )
    		surface.DrawRect( 0, 0, w, h )
		end
	local TeamButton1 = vgui.Create( "DButton" )
	local TeamButtonWidth, TeamButtonHeight = ModelFrameWidth, 71;
		TeamButton1:SetParent(ModelFrame1)
		TeamButton1:SetPos( 0, ModelFrameHeight-TeamButtonHeight)
		TeamButton1:SetSize( TeamButtonWidth, TeamButtonHeight )
		TeamButton1:SetText( "" )
		TeamButton1:SetTextColor( Color(255, 255, 255, 255) )
		TeamButton1.DoClick = function()
			net.Start( "team" )
			net.WriteString( "1" )
			net.SendToServer()
			Backdrop:Close()
		end
		TeamButton1.Paint = function(self, w, h)
			surface.SetDrawColor( 0, 0, 0, 200 )
    		surface.DrawRect( 0, 0, w, h )
			draw.SimpleText( team.GetName(1), "HDRDemoText", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	local TeamButton2 = vgui.Create( "DButton" )
		TeamButton2:SetParent(ModelFrame2)
		TeamButton2:SetPos( 0, ModelFrameHeight-TeamButtonHeight)
		TeamButton2:SetSize( TeamButtonWidth, TeamButtonHeight )
		TeamButton2:SetText( "" )
		TeamButton2:SetTextColor( Color(255, 255, 255, 255) )
		TeamButton2.DoClick = function()
			net.Start( "team" )
				net.WriteString( "2`" )
			net.SendToServer()
			Backdrop:Close()
		end
		TeamButton2.Paint = function(self, w, h)
			surface.SetDrawColor( 0, 0, 0, 200 )
    		surface.DrawRect( 0, 0, w, h )
			draw.SimpleText( team.GetName(2), "HDRDemoText", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	local TeamButton3 = vgui.Create( "DButton" )
	local TeamButton3Width, TeamButton3Height = 200, TeamButtonHeight;
		TeamButton3:SetParent(Content)
		TeamButton3:SetPos( (ScrW()/2)-(TeamButton3Width/2), (ContentHeight/2)-(TeamButton3Height/2))
		TeamButton3:SetSize( TeamButton3Width, TeamButton3Height )
		TeamButton3:SetText( "" )
		TeamButton3:SetTextColor( Color(255, 255, 255, 255) )
		TeamButton3.DoClick = function()
			net.Start( "team" )
				net.WriteString( "3" )
			net.SendToServer()
			Backdrop:Close()
		end
		TeamButton3.Paint = function(self, w, h)
			surface.SetDrawColor( 0, 0, 0, 160 )
    		surface.DrawRect( 0, 0, w, h )
			draw.SimpleText( "Spectate", "HDRDemoText", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	local TeamModel1 = vgui.Create( "DModelPanel",ModelFrame1 )
		TeamModel1:SetPos(-60, -40)
		TeamModel1:SetSize( 420, 400 )
		TeamModel1:SetModel( modelList[1] )
	local TeamModel2 = vgui.Create( "DModelPanel",ModelFrame2 )
		TeamModel2:SetPos(-70, -40)
		TeamModel2:SetSize( 420, 400 )
		TeamModel2:SetModel( modelList[2] )

end
usermessage.Hook("SelectTeamMenu", SelectTeamMenu)