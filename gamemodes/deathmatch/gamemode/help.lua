include( "lang.lua" )

local ply = LocalPlayer()

function help()

	local reportp = vgui.Create( "DFrame" )
		reportp:SetPos(ScrW()/2 - 250 , ScrH()/2 - 250)
		reportp:SetSize(500, 300)
		reportp:SetVisible( true )
		reportp:SetTitle( reporttitle )
		reportp:SetDraggable( true )
		reportp:ShowCloseButton( true )
		reportp:MakePopup()

	local description = vgui.Create( "DTextEntry" )
		description:SetPos( 40, 40 )
		description:SetWide(420)
		description:SetTall(200)
		description:SetParent(reportp)
		description:SetText( "Hello, world!" )
end
usermessage.Hook("menu", help )