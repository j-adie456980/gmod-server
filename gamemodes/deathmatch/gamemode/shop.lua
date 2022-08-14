local ply = LocalPlayer()

include("settings.lua")
include("menu.lua")

local plyteam

local coins = 100
		
function getkillcoins(data)
	coins = coins + x
end
usermessage.Hook( "coins" , getkillcoins )

function getteam(data)
	plyteam = data:ReadLong()
end
usermessage.Hook( "getteam" , getteam )

function Panel() 

		if plyteam ~= 3 then
			shopname2 = shopname
		else
			shopname2 = nogame
		end

		local p = vgui.Create( "DFrame" )
		p:SetPos(ScrW()/2 - 250 , ScrH()/2 - 250)
		p:SetSize(500, 300)
		p:SetVisible( true )
		p:SetTitle( shopname2 )
		p:SetDraggable( false )
		p:ShowCloseButton( true )
		p:SetFGColor(0,0,0,255)
		p:MakePopup()
		
		function show_coins()
			local c = vgui.Create( "DLabel", p )
			c:SetPos(120, 3)
			c:SetColor(Color(255,0,0,255))
			c:SetText(coinsname..": ")
			local c2 = vgui.Create( "DLabel", p )
			c2:SetPos(180, 3)
			c2:SetColor(Color(255,0,0,255))
			c2:SetText(coins)
		end
		timer.Create("show_coins", 1, 0, show_coins)
		
		local ask = vgui.Create( "DFrame" )
		ask:SetPos(ScrW()/2 - 100 , ScrH()/2 - 20)
		ask:SetSize(200,100)
		ask:SetTitle(warn)
		ask:SetVisible( false )
		ask:SetDraggable( false )
		ask:MakePopup()
		ask:ShowCloseButton( false )
		
		local ask_btn_yes = vgui.Create( "DButton" )
		ask_btn_yes:SetParent(ask)
		ask_btn_yes:SetPos(25, 70)
		ask_btn_yes:SetSize(50, 20 )
		ask_btn_yes:SetText(yes)
		ask_btn_yes.DoClick = function()
			net.Start( "z" )
				net.WriteString( "spec" )
			net.SendToServer()
			ask:Close()
			p:Close()
		end
		
		local ask_btn_no = vgui.Create( "DButton" )
		ask_btn_no:SetParent(ask)
		ask_btn_no:SetPos(125, 70)
		ask_btn_no:SetSize(50, 20 )
		ask_btn_no:SetText(no)
		ask_btn_no.DoClick = function()
			ask:SetVisible( false )
			p:SetVisible( true )
		end
		
		local warning = vgui.Create("DLabel", ask)
		warning:SetPos(10,10)
		warning:SetSize(180,20)
		warning:SetWrap( true )
		warning:SetText("If you want to be a spectator")
		
		local warning2 = vgui.Create("DLabel", ask)
		warning2:SetPos(10,20)
		warning:SetSize(180,20)
		warning2:SetWrap( true )
		warning2:SetText("all items you bought will be lost!")
		
		if plyteam ~= 3 then
		local w_list = vgui.Create( "DListView" )
		w_list:SetMultiSelect( false )
		w_list:AddColumn("Weapons")
		w_list:AddColumn("Price in Kill Coins")
		w_list:SetParent(p)
		w_list:SetSize(220,220)
		w_list:SetPos(30,30)
		
		local itemname = vgui.Create("DLabel", p)
			itemname:SetPos(300,30)
			itemname:SetSize(180,20)
			itemname:SetWrap( true )
			itemname:SetText("No weapon selected")
		local itemprice = vgui.Create("DLabel", p)
			itemprice:SetPos(300,30)
			itemprice:SetSize(180,40)
			itemprice:SetWrap( true )
			itemprice:SetText("No weapon selected")
		local buybtn = vgui.Create("DButton")
		buybtn:SetParent(p)
		buybtn:SetPos(300, 220)
		buybtn:SetSize(120, 30)
		buybtn:SetText(buyname)
		
		-- Here you can add your custom weapons
		-- Example how you can add weapons: w_list:AddLine("TheFileNameOfTheWeapon","16")
		-- Here you can look how to add swep: https://www.youtube.com/watch?v=86GFG0y7fHc
		 
		w_list:AddLine(pistol_mun_buy, "4")
		w_list:AddLine(shotgun_buy,"12")
		w_list:AddLine(shotgun_mun_buy,"6")
		w_list:AddLine(smg_buy,"8")
		w_list:AddLine(smg_mun_buy,"6")
		w_list:AddLine(mac_buy,"6")
		w_list:AddLine(mac_mun_buy,"2")
		w_list:AddLine(rifle_buy,"10")
		w_list:AddLine(rifle_mun_buy,"4")
		w_list:AddLine(car_buy, "16")
		w_list.OnClickLine = function(parent,selected,isselected)
			itemname:SetText(itemtrans..": "..selected:GetValue(1))
			itemprice:SetText(coinsname..": "..selected:GetValue(2))
			buybtn.DoClick = function()
			local price = tonumber(selected:GetValue(2))
			local item = selected:GetValue(1)
			if coins >= price then
				net.Start("w")
				if item == pistol_mun_buy then
					net.WriteString("ps_ammo")
				elseif item == smg_buy then
					net.WriteString("smg")
				elseif item == smg_mun_buy then
					net.WriteString("smg_ammo")
				elseif item == shotgun_buy then
					net.WriteString("shotgun")
				elseif item == shotgun_mun_buy then
					net.WriteString("shotgun_ammo")
				elseif item == mac_buy then
					net.WriteString("mac")
				elseif item == mac_mun_buy then
					net.WriteString("mac_ammo")
				elseif item == rifle_buy then
					net.WriteString("rifle")
				elseif item == rifle_mun_buy then
					net.WriteString("rifle_ammo")
				elseif item == car_buy then
					net.WriteString("car")
				else
					net.WriteString(item)
				end
				coins = coins - price
				net.SendToServer()
			else
				chat.AddText("["..shopname.."] "..nocoins)
			end
			end
			end
		end

		if plyteam == 3 then
		local bp = vgui.Create( "DButton" )
		bp:SetParent(p)
		bp:SetPos(30, 260)
		bp:SetSize(120, 30)
		bp:SetText(entergame)
		bp.DoClick = function()
			net.Start( "z" )
				net.WriteString( "team" )
			net.SendToServer()
			p:Close()
		end
		end
	
		if plyteam ~= 3 then
		local bz = vgui.Create( "DButton" )
		bz:SetParent(p)
		bz:SetPos(30, 260)
		bz:SetSize(120, 30)
		bz:SetText(specmsg)
		bz.DoClick = function()
			ask:SetVisible( true )
			p:SetVisible( false )
		end
				

		local close = vgui.Create( "DButton" )
		close:SetParent(p)
		close:SetPos(200, 260)
		close:SetSize(120, 30)
		close:SetText(closebtn)
		close.DoClick = function()
			p:Close()
		end
		local changeteam = vgui.Create( "DButton" )
		changeteam:SetParent(p)
		changeteam:SetPos(370, 260)
		changeteam:SetSize(120, 30)
		changeteam:SetText(changeteamname)
		changeteam.DoClick = function()
			menu()
			p:Close()
		end
		end
		
end
usermessage.Hook( "open" , Panel )
