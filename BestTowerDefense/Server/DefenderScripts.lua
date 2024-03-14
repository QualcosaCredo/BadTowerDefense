local ReplicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")

local Defenders = workspace.Characters
local spawnedEnemies = workspace.SpawnedEnemies

local characterStats = require(ReplicatedStorage.CharactersStats)
local enemiesStats = require(ReplicatedStorage.EnemiesStats)

local Units = {
	character = {},
	unitStats = {}
}
local totalPlacedUnits = 0

local function CheckDistance(range: number,defenderPos: CFrame,EnemyPos: CFrame)
	if (EnemyPos.Position - defenderPos.Position).Magnitude < range then
		return true
	end

	return false
end

local function AttackEnemy(enemy,unitDamage)
	local enemyHumanoid = enemy.Humanoid
	
	enemyHumanoid.Health -= unitDamage
	if enemyHumanoid.Health <= 0 then

		for i,player in players:GetPlayers() do
			player.Inventory.Money.Value += enemiesStats[enemy.Name].moneyReward
		end
		enemy:Destroy()
	end
end

local function newAttr(attr)
	local str = ""
	
	if attr then
		for _, val in attr do
			if type(val) == "number" then
			str = string.format("%s%d ",str,val)
			end
		end

		return str
	end
	
	return nil
end

local function parseAttr(attr: string)
	if not attr then
		return
	end

	local parsedData = {}
	local cnt = 1

	for val in string.gmatch(attr,"%d+") do
		parsedData[cnt] = val
		cnt += 1
	end

	return parsedData
end

ReplicatedStorage.AddDefender.OnServerEvent:Connect(function(player,charName,Pos: CFrame)
	local newUnit
	
	for _, char in Defenders:GetChildren() do
		if char.Name == charName then
			newUnit = char:Clone()
			break
		end
	end

	newUnit.Parent = workspace.PlacedUnits
	newUnit.HumanoidRootPart.CFrame = Pos
	
	local charStats = characterStats[charName]
	
	local DefenderStats = {}
	
	DefenderStats.id = totalPlacedUnits
	DefenderStats.level = 1
	DefenderStats.damage = charStats.damage[DefenderStats.level]
	DefenderStats.upgradePrice = charStats.upgradePrice[DefenderStats.level]
	DefenderStats.attackRange = charStats.attackRange[DefenderStats.level]
	DefenderStats.attackSpeed = charStats.attackSpeed
	
	newUnit:SetAttribute("UnitQueue",newAttr(DefenderStats))
	
	print(DefenderStats.id,newUnit)
	
	Units.character[DefenderStats.id] = newUnit
	Units.unitStats[DefenderStats.id] = DefenderStats
	totalPlacedUnits += 1
	
	task.spawn(function()
		while newUnit do
			for _, enemy in pairs(spawnedEnemies:GetChildren()) do
				if CheckDistance(Units.unitStats[DefenderStats.id].attackRange,newUnit.HumanoidRootPart.CFrame,enemy.HumanoidRootPart.CFrame) and enemy then
					AttackEnemy(enemy,Units.unitStats[DefenderStats.id].damage)
					wait(Units.unitStats[DefenderStats.id].attackSpeed)
					break
				end
			end
			task.wait()
		end
	end)
end)

ReplicatedStorage.UpgradeDefender.OnServerEvent:Connect(function(player,id: number)
	local defenderStats = Units.unitStats[id]
	
	if defenderStats.level >= characterStats.MAXLEVEL then
		return
	end
	
	local charStats = characterStats[Units.character[id].Name]
	
	defenderStats.level += 1
	defenderStats.damage = charStats.damage[defenderStats.level]
	defenderStats.upgradePrice = charStats.upgradePrice[defenderStats.level]
	defenderStats.attackRange = charStats.attackRange[defenderStats.level]
	
	defenderStats.attackSpeed = charStats.attackSpeed
	
	Units.character[id]:SetAttribute("UnitQueue",newAttr(defenderStats))
end)

