include("settings.lua")

round = {}
-- Variables
round.Break	= round_break
round.limit = rounds

-- Read Variables
round.TimeLeft = -1

round.sec = round_sec

local winner
local s
local draw_winner
local ende = false

function round.Begin()
	round.TimeLeft = round_min-1
end

local r = vgui.Create( "DLabel", s )
		r:SetPos(ScrW()/2-50,ScrH()/2-3)
		r:SetSize(500,30)
		r:SetFont("DermaLarge")
		r:SetVisible(false)

function round.End()
	local ply = LocalPlayer()
		if team.TotalFrags(1) > team.TotalFrags(2) then
			r:SetText(cwin)
			if endroundsound == true then
			surface.PlaySound(t_sound)
			end
		elseif team.TotalFrags(1) < team.TotalFrags(2) then
			r:SetText(twin)
			if endroundsound == true then
			surface.PlaySound(c_sound)
			end
		else 
			r:SetText(noteam)
			if endroundsound == true then
			surface.PlaySound(n_sound)
			end
		end
		ende = true
		r:SetVisible(true)
		net.Start( "z" )
			net.WriteString( "end" )
		net.SendToServer()
		
		if round.limit == 0 then
		if allowmapvote == true then
			timer.Create( "MapVoteTimer", 3, 1, function()
			net.Start("z")
			net.WriteString("mapvote")
			net.SendToServer()
			end )
		end
		end
end

function awards()
	if ende == true then
		draw.RoundedBox(2,0,ScrH()/2-150,ScrW(),300,Color(0,0,0,230))
	end
end

hook.Add( "HUDPaint" , "awards", awards )

function round.Handle()

	if (round.TimeLeft == -1) then
		round.Begin()
		return
	end
	
	if (round.Break == 0) then -- Rundenpause zuende
		ende = false
		r:SetVisible(false)
		round.sec = round_sec
		round.TimeLeft = round_min
		round.Break = round_break
		
		net.Start( "z" )
			net.WriteString( "respawn" )
		net.SendToServer()
		
		if round.limit == 0 then
			round.limit = rounds
		else
			round.limit = round.limit - 1
		end
	else
		round.Break = round.Break - 1
		net.Start( "z" )
		net.WriteString( "un" )
		net.SendToServer()
	end
	
	if (ende == false) then
		round.Break = round_break
		round.sec = round.sec - 1
		net.Start( "z" )
		net.WriteString( "an" )
		net.SendToServer()
	
		if(round.sec < 0) then
			round.sec = round_sec
			round.TimeLeft = round.TimeLeft - 1
		end
	end
	
	if (round.TimeLeft == 0) then
		if(round.sec == 0) then
			if ende == false then
				round.End()
			end
		end
	end
end
timer.Create("round.Handle", 1, 0, round.Handle)