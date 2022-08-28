include("settings.lua")

round = {}
-- Variables
round.pause	= round_pause
round.limit = rounds

-- Read Variables
round.min = -1
round.sec = round_sec

round.finish = false

util.AddNetworkString( "PaintTimeLeft" )
util.AddNetworkString( "PaintRoundsLeft" )

function round.Begin()
	net.Start( "PaintRoundsLeft" ) 
		net.WriteInt( round.limit, 8 )
	net.Broadcast()
	round.min = round_min
end

function round.Pause()
	if (round.pause == 0) then
		round.sec = round_sec
		round.min = round_min
		round.finish = false
		for k, ply in pairs(player.GetAll()) do
			ply:Freeze(false)
		end
	else
		print(round.pause)
		round.pause = round.pause - 1
	end
end

function round.End()

	round.finish = true
	round.limit = round.limit - 1

	net.Start( "PaintRoundsLeft" ) 
		net.WriteInt( round.limit, 8 )
	net.Broadcast()


	if round.limit == 0 then
		for k, ply in pairs(player.GetAll()) do
			ply:Freeze(true)
		end
		PrintMessage(3, "----GAME OVER----")
	else
		for k, ply in pairs(player.GetAll()) do
			ply:SetFrags(0)
			ply:SetDeaths(0)
			ply:Freeze(true)
		end

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

		PrintMessage(3, "----END OF ROUND----")
		PrintMessage(3, "ROUNDS LEFT:  " .. round.limit)
		print("--Pause--")
		timer.Create("round.Pause", 1, round_pause+1, round.Pause)
	end
end

function round.Handle()
	if round.finish == false then

		-- send current round time to client HUD
		net.Start( "PaintTimeLeft" ) 
			net.WriteTable( {round.min, round.sec} )
		net.Broadcast()

		if (round.min == -1) then round.Begin() end 

		print(round.min, round.sec)
		
		if (round.min == 0 and round.sec == 0) then -- round is over
			round.End()
		else 										-- round is ongoing
			round.pause = round_pause
			round.sec = round.sec - 1
		
			if(round.sec < 0) then
				round.sec = round_sec
				round.min = round.min - 1
			end
		end
	end
end
timer.Create("round.Handle", 1, 0, round.Handle)