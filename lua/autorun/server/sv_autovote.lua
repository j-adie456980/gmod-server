hook.Add( "Initialize", "AutoTTTMapVote", function()
      if GAMEMODE_NAME == "terrortown" then
        function CheckForMapSwitch()
           -- Check for mapswitch
           local rounds_left = math.max(0, GetGlobalInt("dm_rounds_left", 6) - 1)
           SetGlobalInt("dm_rounds_left", rounds_left)
 
           local time_left = math.max(0, (GetConVar("ttt_time_limit_minutes"):GetInt() * 60) - CurTime())
           local switchmap = false
           local nextmap = string.upper(game.GetMapNext())
 
            if rounds_left <= 0 then
              LANG.Msg("limit_round", {mapname = nextmap})
              switchmap = true
            elseif time_left <= 0 then
              LANG.Msg("limit_time", {mapname = nextmap})
              switchmap = true
            end
            if switchmap then
                timer.Stop("end2prep")
                MapVote.Start(nil, nil, nil, nil)
            end
        end
      end
end )


