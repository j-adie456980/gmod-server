GM.Name = "Deathmatch"
GM.Author = "Sharker"
GM.Email = "alienmode6@gmail.com"
GM.Website = "http://brokenpixel.cf"

function GM:Initialize()
	self.BaseClass.Initialize( self )
end

team.SetUp(1, "Counter Terrorists", Color(0,0,255))
team.SetUp(2, "Terrorists", Color(255,0,0))
team.SetUp(3, "Specxtator", Color(0,255,0))
team.SetUp(4, "No Team", Color(0,0,0))

team.SetUp(1, "Fart Fellas", Color(0,0,255))