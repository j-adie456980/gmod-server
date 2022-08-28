include("round.lua")
include("shop.lua")
include("lang.lua")
include("settings.lua")
-- Add external font
resource.AddFile( "resource/fonts/battlefield.ttf" )

-- Create Fonts
surface.CreateFont("BFont24", {
	font = "Futura Light BT",
	size = 24,
	weight = 1000,
	antialias = true,
})

surface.CreateFont("BFont80", {
	font = "Futura Light BT",
	size = 80,
	weight = 500,
	antialias = true,
})

surface.CreateFont("BFont42", {
	font = "Futura Light BT",
	size = 42,
	weight = 1000,
	antialias = true,
})

surface.CreateFont("BFont64", {
	font = "Futura Light BT",
	size = 64,
	weight = 1000,
	antialias = true,
})

local hpSmooth = 0
local show_tip = 0
local item = "Nothing"
local spawnsec = 0
local killer = "Nothing"
local HUDTopYPos = 0
local min = 0
local sec = 0

local triangleLeft = {
	{ x = (ScrW()/2)-700, y = HUDTopYPos },
	{ x = (ScrW()/2)-624, y = HUDTopYPos },
	{ x = (ScrW()/2)-624, y = HUDTopYPos+50 }
}
--any -1's make up for the additional mising pixel from placing an odd numbered width by a screen width / 2
local triangleRight = {
	{ x = (ScrW()/2)+624-1, y = HUDTopYPos },
	{ x = (ScrW()/2)+700, y = HUDTopYPos },
	{ x = (ScrW()/2)+624-1, y = HUDTopYPos+50 },
}

local trapezoidLeft = {
	{ x = (ScrW()/2)-139, y = HUDTopYPos },
	{ x = (ScrW()/2)-78, y = HUDTopYPos },
	{ x = (ScrW()/2)-78, y = HUDTopYPos+50 },
	{ x = (ScrW()/2)-139, y = HUDTopYPos+76 },
}

local trapezoidRight = {
	{ x = (ScrW()/2)+78-1, y = HUDTopYPos },
	{ x = (ScrW()/2)+139-1, y = HUDTopYPos },
	{ x = (ScrW()/2)+139-1, y = HUDTopYPos+76 },
	{ x = (ScrW()/2)+78-1, y = HUDTopYPos+50 },
}

function killscreen(data)
	killer = data:ReadString()
end
usermessage.Hook("killscreen", killscreen )

function weapon(data)
	item = data:ReadString()
end
usermessage.Hook("weapon", weapon )

net.Receive( "TIMEPaint", function(len, ply)
	local temp = net.ReadTable()
	min = temp[1]
	sec = temp[2]
end)

function time()
	draw.RoundedBox( 0, ScrW()/2-(155/2), HUDTopYPos, 155, 50, Color(0,0,0,200) )
	if (sec < 10) then draw.SimpleText( min .. ":0" .. sec, "ScoreboardDefaultTitle", ScrW()/2, 50/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	else draw.SimpleText( min .. ":" .. sec, "ScoreboardDefaultTitle", ScrW()/2, 50/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
end
hook.Add( "HUDPaint" , "TIME", time )
	
function HUD()
	local ply = LocalPlayer()
	local hp = ply:Health()
	if ply:Team() == 4 then
		draw.RoundedBox(0,0,0,ScrW(),ScrH(),Color(0,0,0,234))
	end

	--Main Score HUD Top--

	local team1Name = team.GetName(1)
	local team1Score = team.TotalFrags(1)
	local team2Name = team.GetName(2)
	local team2Score = team.TotalFrags(2)

	--flips team 2 to left of screen for players on team 2--
	if (ply:Team() == 2) then
		local tempName = team1Name
		local tempScore = team1Score
		team1Name = team2Name
		team1Score = team2Score
		team2Name = tempName
		team2Score = tempScore
	end

	--Team Score Left--
	draw.RoundedBox( 0, ScrW()/2-293, HUDTopYPos, 154, 76, Color( 0, 0, 0, 150 ) )
	draw.SimpleText( team1Score, "BFont64", ScrW()/2-(293)+(154/2), HUDTopYPos+(76/2), Color( 54, 212, 222, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	--Team Score Right--
	draw.RoundedBox( 0, ScrW()/2+138, HUDTopYPos, 154, 76, Color( 0, 0, 0, 150 ) )
	draw.SimpleText( team2Score, "BFont64", ScrW()/2+(138)+(154/2), HUDTopYPos+(76/2), Color( 222, 54, 54, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	--Team Name Left--
	draw.RoundedBox( 0, ScrW()/2-624, HUDTopYPos, 331, 50, Color( 0, 0, 0, 100 ) )
	draw.SimpleText( team1Name, "ScoreboardDefaultTitle", ScrW()/2-(624)+(331/2), HUDTopYPos+(50/2), Color( 54, 212, 222, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	--Team Name Right--
	draw.RoundedBox( 0, ScrW()/2+292, HUDTopYPos, 331, 50, Color( 0, 0, 0, 100 ) )
	draw.SimpleText( team2Name, "ScoreboardDefaultTitle", ScrW()/2+(292)+(331/2), HUDTopYPos+(50/2), Color( 222, 54, 54, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	--Decoration--
	surface.SetDrawColor( 0, 0, 0, 100 )
	draw.NoTexture()
	surface.DrawPoly( triangleLeft )
	surface.DrawPoly( triangleRight )
	surface.SetDrawColor( 0,0,0,150 )
	draw.NoTexture()
	surface.DrawPoly( trapezoidLeft )
	surface.DrawPoly( trapezoidRight )

	--Death Screen--
	if ply:Team() == 1 or ply:Team() == 2 then
		if(hp < 1) then
			spawnsec = spawnsec + 1
			draw.RoundedBox(2,0,ScrH()/2-150,ScrW(),300,Color(0,0,0,230))
			surface.SetFont("DermaLarge")
			surface.SetTextPos(ScrW()/2 - 5, ScrH()/2 - 80)
			surface.DrawText(math.Round((900 - spawnsec + 100)/3/100) .." " .. sec_name)
			surface.SetTextPos(ScrW()/2 - 5, ScrH()/2 - 20)
			surface.DrawText(deathmsg .. " " .. killer )
			surface.SetTextPos(ScrW()/2 - 5, ScrH()/2 + 20)
			surface.SetFont("Trebuchet24")
			surface.DrawText(weapon_name .. ": " .. item ) 		
			if spawnsec == 900 then
				net.Start( "z" )
				net.WriteString( "spawn" )
				net.SendToServer()
			end
			
		else
			spawnsec = 0	
		end
	end

	if (false) then
		--Rounds Remaining--
		local roundname 
			
		if round.limit == 1 then roundname = langroundone
		else roundname = langround end
		
		draw.RoundedBox( 0, 0, ScrH()-50, 225, 50, Color(0,0,0,100) )
		draw.SimpleText( roundname..": "..round.limit, "ScoreboardDefaultTitle", 225/2, ScrH()-50+(50/2), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end

	function math.gcd(a,b) while a ~= 0 do a, b = b%a, a end return b end
	
	local scrw = ScrW()
	local scrh = ScrH()
	 
	local basew = scrw
	local baseh = scrh
	 
	local d = math.Round(basew/baseh,2)
	local gcd = math.gcd(basew,baseh)
	 
	local arWidth = d > 1 and scrh/gcd or scrw/gcd
	local arHeight = d > 1 and scrh/gcd or scrw/gcd
	 
	local mw = (scrw/arWidth) * d
	local mh = (scrh/arHeight) * d
	 
	local function BetterScreenScale()
	    return math.Clamp(ScrH() / 1080, 0.6, 1)
	end
	 
	function FontSizeToScale(size)
	    return math.Round(BetterScreenScale() * size)
	end
	 
	d_scale = d
	 
	function DScale()
	    return d_scale or 1
	end
	 
	local x = scrw * 0.5 --base x
	local y = scrh * 0.5 --base y
	local w = mw --base w
	local h = mh --base h

	-- Player
	local ply = LocalPlayer()
	local hp, maxhp = ply:Health(), ply:GetMaxHealth()
	local ap = ply:Armor()

	if ply:Alive() then
		-- Weapon Variables
		local activeWep = ply:GetActiveWeapon()
		local wepClip = 0
		local wepAmmo = 0
		local wepAmmoType = 0

		-- Validity Check
		if IsValid(activeWep) then
			wepClip = activeWep:Clip1()
			wepAmmo = ply:GetAmmoCount(activeWep:GetPrimaryAmmoType())
			wepAmmoType = activeWep:GetPrimaryAmmoType()
		end

		-- Smooth Health
		hpSmooth = math.Approach(hpSmooth, hp, 25 * FrameTime())
		local hpMath = math.Clamp(hpSmooth / 100, 0, 1) * (w / 3) * d_scale

		-- Behind Thingy of HP Bar
		barW, barH = (w / 3) * d_scale, (h / 12) * d_scale

		surface.SetDrawColor(0, 0, 0, 200)
		surface.DrawRect(x - barW / 2, y * 1.9 - barH, (w / 3) * d_scale, (h / 40) * d_scale)

		-- Health Loss Bar
		local barHP = math.Clamp(hp / maxhp, 0, 1) * (w / 3) * d_scale

		surface.SetDrawColor(240, 40, 60, 200)
		surface.DrawRect(x - barW / 2, y * 1.9 - barH, hpMath, (h / 40) * d_scale)

		-- HP Bar
		surface.SetDrawColor(255, 255, 255)
		surface.DrawRect(x - barW / 2, y * 1.9 - barH, barHP, (h / 40) * d_scale)

		-- Health Cross
		barW, barH = (w / 2.2) * d_scale, (h / 9.5) * d_scale

		surface.SetMaterial(Material("materials/health_cross.png"))
		surface.DrawTexturedRect(x - barW / 2, y * 1.9 - barH, (h / 15) * d_scale, (h / 15) * d_scale)

		-- Divider
		barW, barH = (w / 2) * d_scale, (h / 9) * d_scale

		surface.SetDrawColor(255, 255, 255)
		surface.DrawRect(x - barW / 2, y * 1.9 - barH, 1, (h / 12) * d_scale)

		-- Armor Text
		barW, barH = (w / 1.9) * d_scale, (h / 13.5) * d_scale

		draw.SimpleText(ap, "BFont24", x - barW / 2, y * 1.9 - barH, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

		-- Health Text
		barW, barH = (w * -0.18) * d_scale, (h / 13.5) * d_scale

		draw.SimpleText(hp, "BFont24", x - barW, y * 1.9 - barH, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

		-- Armor Icon
		surface.SetFont("BFont24")
		local txtSize = surface.GetTextSize(ap)

		barW, barH = (w / 3.1) * d_scale + txtSize, (h / 8) * d_scale

		surface.SetMaterial(Material("materials/armor_shield.png"))
		surface.DrawTexturedRect(x - barW, y * 1.9 - barH, (h / 10) * d_scale, (h / 10) * d_scale)

		-- Ammo Text
		--if wepAmmo > 0 then
		if wepAmmoType ~= -1 then
			if wepAmmo < 0 then wepAmmo = 0 end
			if wepClip < 0 then wepClip = 0 end
			if wepAmmoType ~= 10 then -- 10 = grenade ammo --
				--ammo--
				barW, barH = (w * -1.3) * d_scale, (h / 13.5) * d_scale
				draw.SimpleText(wepAmmo, "BFont42", x - barW, y * 1.9 - barH, Color(150, 150, 150), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
				--clip--
				barW, barH = (w * -1.2) * d_scale, (h / 13.5) * d_scale
				draw.SimpleText(wepClip, "BFont80", x - barW, y * 1.9 - barH, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
			else
				--ammo--
				barW, barH = (w * -1.2) * d_scale, (h / 13.5) * d_scale
				draw.SimpleText(wepAmmo, "BFont80", x - barW, y * 1.9 - barH, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
			end
		end

	end
end
hook.Add( "HUDPaint" , "HUD", HUD )

-- Hides the default Hud
function hidehud(name)
	for k, v in pairs({"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo"}) do
		if name == v then 
			return false 
		end
	end
end
hook.Add("HUDShouldDraw", "HideOurHud", hidehud)

function wep()
	
	-- Weaponswitch system
	
end

hook.Add( "HUDPaint" , "WEP", wep )
