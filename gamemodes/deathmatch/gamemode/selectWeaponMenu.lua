include("addonLists.lua")
AddCSLuaFile( "addonLists.lua" )


function getPrimaryType() 
	if     currentPrimaryClass == "AR" then return weaponList.AR
    elseif currentPrimaryClass == "SMG" then return weaponList.SMG
	elseif currentPrimaryClass == "SHOTGUN" then return weaponList.SHOTGUN
	elseif currentPrimaryClass == "SNIPER" then return weaponList.SNIPER
	else   return weaponList.AR
	end
end

function drawWeaponModel(parent, wep)
	local WeaponModel = vgui.Create( "DModelPanel",ModelFrame1 )
	local WeaponModelWidth, WeaponModelHeight = parent:GetSize()
		WeaponModel:SetParent(parent)
		WeaponModel:SetPos( 0, 0 )
		WeaponModel:SetSize( WeaponModelWidth, WeaponModelHeight )
		WeaponModel:SetModel( weapons.Get(wep).WorldModel )
		WeaponModel:SetCamPos(Vector(0, 70, 0))
		WeaponModel:SetLookAt(Vector( 0, 0, 0 ))
		WeaponModel:SetFOV(50)
		--print(WeaponModel:GetLookAt())
end

function sendClientData()
	local tab = {currentPrimary, currentSecondary, currentMelee}
	net.Start("SelectLoadout") --Unique name accessed by the recipent's
    net.WriteTable(tab)
	net.SendToServer(Entity(1))
end

function SelectWeaponMenu()
	local ply = LocalPlayer() -- LocalPlayer exist within a function that is in context of player (probably from the hooks idk why this is)
	print("--- SELECT WEAPON MENU ---", ply)
	PrintTable(player_manager.AllValidModels())

	local currentPrimaryType = getPrimaryType()
	local currentWeaponType = "primary"

	local Backdrop = vgui.Create( "DFrame" )
	local BackdropWidth, BackDropHeight = 1086, 572;
		Backdrop:SetPos( (ScrW()/2)-(BackdropWidth/2), ScrH()/2-(BackDropHeight/2)-50 )
		Backdrop:SetSize( BackdropWidth, BackDropHeight )
		Backdrop:SetTitle( "" )
		Backdrop:SetVisible( true )
		Backdrop:SetDraggable( false )
		Backdrop:ShowCloseButton( true )
		Backdrop:MakePopup()
		Backdrop.Paint = function(self , w, h)
			surface.SetDrawColor( 66, 73, 85, 255 )
    		surface.DrawRect( 0, 0, w, h )
		end

	local Content = vgui.Create( "DLabel" )
	local ContentWidth, ContentHeight = BackdropWidth, 513;
		Content:SetParent(Backdrop)
		Content:SetPos( 0, BackDropHeight-ContentHeight )
		Content:SetSize( ContentWidth, ContentHeight )
		Content:SetText("")
		Content.Paint = function(self, w, h)
			surface.SetDrawColor( 104, 116, 134, 255 )
    		surface.DrawRect( 0, 0, w, h )
		end
	local ModelFrameBackrop = vgui.Create( "DLabel" )
	local ModelFrameBackropWidth, ModelFrameBackropHeight = 650, 290;
		ModelFrameBackrop:SetParent(Content)
		ModelFrameBackrop:SetPos( ContentWidth-ModelFrameBackropWidth-40, 30 )
		ModelFrameBackrop:SetSize( ModelFrameBackropWidth, ModelFrameBackropHeight )
		ModelFrameBackrop:SetText( "" )
		ModelFrameBackrop.Paint = function(self, w, h)
			surface.SetDrawColor( 0, 0, 0, 100 )
    		surface.DrawRect( 0, 0, w, h )
		end
	local ModelFrame = vgui.Create( "DLabel" )
	local ModelFrameWidth, ModelFrameHeight = ModelFrameBackrop:GetSize()
		ModelFrame:SetParent(ModelFrameBackrop)
		ModelFrame:SetPos( 20, 20 )
		ModelFrame:SetSize( ModelFrameWidth-40, ModelFrameHeight-40 )
		ModelFrame:SetText( "" )
		ModelFrame.Paint = function(self, w, h)
			surface.SetDrawColor( 0, 0, 0, 100 )
    		surface.DrawRect( 0, 0, w, h )
			drawWeaponModel(self, currentPrimary)
		end
	
	local function refreshModelFrame()
		ModelFrame:Remove()
		ModelFrame = vgui.Create( "DLabel" )
		ModelFrame:SetParent(ModelFrameBackrop)
		ModelFrame:SetPos( 20, 20 )
		ModelFrame:SetSize( ModelFrameWidth-40, ModelFrameHeight-40 )
		ModelFrame:SetText( "" )
		ModelFrame.Paint = function(self, w, h)
			surface.SetDrawColor( 0, 0, 0, 100 )
			surface.DrawRect( 0, 0, w, h )
		end
	end 
	

	local WeaponDropdownBottom = vgui.Create( "DComboBox" )
	local WeaponDropdownWidth, WeaponDropdownHeight = 280, 50
		WeaponDropdownBottom:SetParent(Content)
		WeaponDropdownBottom:SetPos( 50, WeaponDropdownHeight+50 )
		WeaponDropdownBottom:SetSize( WeaponDropdownWidth, WeaponDropdownHeight )
		WeaponDropdownBottom:SetValue( weapons.Get(currentPrimary).PrintName )
		for _, val in ipairs(currentPrimaryType) do
			WeaponDropdownBottom:AddChoice( weapons.Get(val).PrintName )
		end
		WeaponDropdownBottom.OnSelect = function( self, index, value )
			currentPrimary = currentPrimaryType[index]
			refreshModelFrame()
			drawWeaponModel(ModelFrame, currentPrimary)
			sendClientData()
		end

	local WeaponDropdownTop = vgui.Create( "DComboBox" )
		WeaponDropdownTop:SetParent(Content)
		WeaponDropdownTop:SetPos( 50, 30 )
		WeaponDropdownTop:SetSize( WeaponDropdownWidth, WeaponDropdownHeight )
		WeaponDropdownTop:SetValue( currentPrimaryClass )
		for _, val in ipairs(PRIMARYCLASSES) do
			WeaponDropdownTop:AddChoice( val )
		end
		WeaponDropdownTop.OnSelect = function( self, index, value )
			if currentWeaponType == "primary" then 
				currentPrimaryClass = PRIMARYCLASSES[index]
				currentPrimaryType = getPrimaryType(currentPrimaryClass)
				WeaponDropdownBottom:Clear()
				WeaponDropdownBottom:SetValue( "Select Weapon" )
				for _, val in ipairs(currentPrimaryType) do
					WeaponDropdownBottom:AddChoice( weapons.Get(val).PrintName )
				end
			else
				if currentWeaponType == "secondary" then 
					currentSecondary = weaponList.PISTOL[index]
					refreshModelFrame()
					drawWeaponModel(ModelFrame, currentSecondary) 
				end
				if currentWeaponType == "melee" then 
					currentMelee = weaponList.MELEE[index]
					refreshModelFrame()
					drawWeaponModel(ModelFrame, currentMelee)
				end
				
				sendClientData()
			end
		end

	local ButtonUnderline = vgui.Create( "DLabel" )
	local ButtonUnderlineWidth, ButtonUnderlineHeight = 200, 4;
		ButtonUnderline:SetParent(Backdrop)
		ButtonUnderline:SetPos( 20, 0 )
		ButtonUnderline:SetSize( ButtonUnderlineWidth, ButtonUnderlineHeight )
		ButtonUnderline:SetText("")
		ButtonUnderline.Paint = function(self, w, h)
			surface.SetDrawColor( 255, 255, 255, 255 )
    		surface.DrawRect( 0, 0, w, h )
		end

	local PrimaryButton = vgui.Create( "DButton" )
	local PrimaryButtonWidth, PrimaryButtonHeight = 200, BackDropHeight-ContentHeight;
	local PrimaryButtonXpos = 20;
		PrimaryButton:SetParent(Backdrop)
		PrimaryButton:SetPos( PrimaryButtonXpos, 0 )
		PrimaryButton:SetSize( PrimaryButtonWidth, PrimaryButtonHeight )
		PrimaryButton:SetText( "" )
		PrimaryButton:SetTextColor( Color(255, 255, 255, 255) )
		PrimaryButton.DoClick = function()
			ButtonUnderline:MoveTo(PrimaryButtonXpos, 0, 0.5, 0, 3)
			WeaponDropdownTop:Clear()
			WeaponDropdownTop:SetValue( currentPrimaryClass )
			for _, val in ipairs(PRIMARYCLASSES) do
				WeaponDropdownTop:AddChoice( val )
			end
			WeaponDropdownBottom:Clear()
			WeaponDropdownBottom:Show()
			WeaponDropdownBottom:SetValue( "Select Weapon" )
			for _, val in ipairs(currentPrimaryType) do
				WeaponDropdownBottom:AddChoice( weapons.Get(val).PrintName )
			end
			currentWeaponType = "primary"
		end
		PrimaryButton.Paint = function(self, w, h)
			surface.SetDrawColor( 0, 0, 0, 0 )
    		surface.DrawRect( 0, 0, w, h )
			draw.SimpleText( "Primary", "ScoreboardDefaultTitle", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end

	local SecondaryButton = vgui.Create( "DButton" )
	local SecondaryButtonWidth, SecondaryButtonHeight = 200, BackDropHeight-ContentHeight;
	local SecondaryButtonXpos = PrimaryButtonXpos+PrimaryButtonWidth+50
		SecondaryButton:SetParent(Backdrop)
		SecondaryButton:SetPos( SecondaryButtonXpos, 0 )
		SecondaryButton:SetSize( SecondaryButtonWidth, SecondaryButtonHeight )
		SecondaryButton:SetText( "" )
		SecondaryButton:SetTextColor( Color(255, 255, 255, 255) )
		SecondaryButton.DoClick = function()
			ButtonUnderline:MoveTo(SecondaryButtonXpos, 0, 0.5, 0, 3)
			WeaponDropdownBottom:CloseMenu()
			WeaponDropdownBottom:Hide()
			WeaponDropdownTop:Clear()
			WeaponDropdownTop:SetValue( weapons.Get(currentSecondary).PrintName )
			for _, val in ipairs(weaponList.PISTOL) do
				WeaponDropdownTop:AddChoice( weapons.Get(val).PrintName )
			end
			currentWeaponType = "secondary"
		end
		SecondaryButton.Paint = function(self, w, h)
			surface.SetDrawColor( 0, 0, 0, 0 )
			surface.DrawRect( 0, 0, w, h )
			draw.SimpleText( "Secondary", "ScoreboardDefaultTitle", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end

	local MeleeButton = vgui.Create( "DButton" )
	local MeleeButtonWidth, MeleeButtonHeight = 200, BackDropHeight-ContentHeight;
	local MeleeButtonXpos = SecondaryButtonXpos+SecondaryButtonWidth+50
		MeleeButton:SetParent(Backdrop)
		MeleeButton:SetPos( MeleeButtonXpos, 0 )
		MeleeButton:SetSize( MeleeButtonWidth, MeleeButtonHeight )
		MeleeButton:SetText( "" )
		MeleeButton:SetTextColor( Color(255, 255, 255, 255) )
		MeleeButton.DoClick = function()
			ButtonUnderline:MoveTo(MeleeButtonXpos, 0, 0.5, 0, 3)
			WeaponDropdownBottom:CloseMenu()
			WeaponDropdownBottom:Hide()
			WeaponDropdownTop:Clear()
			WeaponDropdownTop:SetValue( weapons.Get(currentMelee).PrintName )
			for _, val in ipairs(weaponList.MELEE) do
				WeaponDropdownTop:AddChoice( weapons.Get(val).PrintName )
			end
			currentWeaponType = "melee"
		end
		MeleeButton.Paint = function(self, w, h)
			surface.SetDrawColor( 0, 0, 0, 0 )
			surface.DrawRect( 0, 0, w, h )
			draw.SimpleText( "Melee", "ScoreboardDefaultTitle", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	
	dumbShit()
end
usermessage.Hook("SelectWeaponMenu", SelectWeaponMenu)