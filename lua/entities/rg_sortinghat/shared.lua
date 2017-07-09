ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Sorting Hat"
ENT.Author = "Stan & Sweg"
ENT.Category = "Hogwarts RolePlay"
ENT.Spawnable = true
ENT.AdminSpawnable = true

	rg_hatmodel = "models/sortinghat/sortinghat.mdl" 
	rg_listOfHouses = {
	{ 
		name = "Hufflepuff", 
		color = Color(255,255,0),
		ulx = "hufflepuff",
		job = TEAM_HUFFLEPUFF
	},
	{ 
		name = "Gryffindor",
		color = Color(255,0,0),
		ulx = "gryffindor",
		job = TEAM_GRYFFINDOR
	},
	{ 
		name = "Ravenclaw",
		color = Color(0,0,255),	
		ulx = "ravenclaw",
		job = TEAM_RAVENCLAW
	},
	{ 
		name = "Slytherin",
		color = Color(0,255,0),	
		ulx = "slytherin",
		job = TEAM_SLYTHERIN 
	}
}

