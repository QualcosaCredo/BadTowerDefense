

local characters = {
	MAXLEVEL = 4,
	
	["Puncher"] = {
		Name = "Puncher" ,
		buyPrice = 50,
		damage = {10,20,40,50},
		upgradePrice = { 100,250,500,1000 },
		attackRange = {10,14,16,18},
		attackSpeed = 1
	},
	
	["Gunner"] = {
		Name = "Gunner" ,
		buyPrice = 150,
		damage = {12,25,40,55},
		upgradePrice = { 150,400,600,1100 },
		attackRange = {12,16,18,20},
		attackSpeed = 2
	},
	
	["Sniper"] = {
		Name = "Sniper" ,
		buyPrice = 300,
		damage = {20,25,60,75},
		upgradePrice = { 200,500,800,1400 },
		attackRange = {18,24,28,32},
		attackSpeed = 5
	}
}

return characters
