include("settings.lua")

round = {}
-- Variables
round.Break	= round_break
round.limit = rounds

-- Read Variables
round.TimeLeft = -1
round.sec = round_sec

local ende = false

util.AddNetworkString( "TIMEPaint" )

function round.Begin()
	round.TimeLeft = round_min-1
end

function round.End()
	local ply = LocalPlayer()
		if team.TotalFrags(1) > team.TotalFrags(2) then
			if endroundsound == true then
			surface.PlaySound(t_sound)
			end
		elseif team.TotalFrags(1) < team.TotalFrags(2) then
			if endroundsound == true then
			surface.PlaySound(c_sound)
			end
		else 
			if endroundsound == true then
			surface.PlaySound(n_sound)
			end
		end
		ende = true
		
		if round.limit == 0 then
		
		end
end

function awards()
	if ende == true then
		draw.RoundedBox(2,0,ScrH()/2-150,ScrW(),300,Color(0,0,0,230))
	end
end

hook.Add( "HUDPaint" , "awards", awards )


function round.Handle()

	net.Start( "TIMEPaint" )
    	net.WriteTable( {round.TimeLeft, round.sec} )
	net.Broadcast()
	print(round.sec)

	if (round.TimeLeft == -1) then
		round.Begin()
		return
	end
	
	if (round.Break == 0) then -- Rundenpause zuende
		ende = false
		round.sec = round_sec
		round.TimeLeft = round_min
		round.Break = round_break
		
		if round.limit == 0 then
			round.limit = rounds
		else
			round.limit = round.limit - 1
		end
	else
		round.Break = round.Break - 1
	end
	
	if (ende == false) then
		round.Break = round_break
		round.sec = round.sec - 1
	
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