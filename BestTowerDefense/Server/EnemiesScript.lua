local Replicated = game:GetService("ReplicatedStorage")
local PathFindingService = game:GetService("PathfindingService")

local EnemiesStats = require(Replicated.EnemiesStats)
local SpawnedEnemies = workspace.SpawnedEnemies

local PathOptions = workspace.Map

local path = PathFindingService:CreatePath({
	AgentCanJump = false,
	AgentCanClimb = false,
	Costs = {
		Terrain = math.huge,
		Track = 200
	}
})

local startPos = PathOptions.Spawn.Position
local EndPos = PathOptions.Base.Position

path:ComputeAsync(startPos, EndPos)

local waypoints = path:GetWaypoints()

local function HitBase(Enemy)
	local base = workspace.Map.Base

	base.Health.Value -= Enemy.Humanoid.Health
	Enemy:Destroy()
end

local function SpawnEnemy(EnemyName: string)
	local newEnemy = workspace.Enemies:FindFirstChild(EnemyName):Clone()
	newEnemy.Parent = SpawnedEnemies
	newEnemy.HumanoidRootPart.CFrame = workspace.Map.Spawn.CFrame

	for _, parts in newEnemy:GetChildren() do
		if parts:IsA("BasePart") then
			parts.CanCollide = false
		end
	end
	
	newEnemy.Humanoid.Health = EnemiesStats[EnemyName].health
	newEnemy.Humanoid.WalkSpeed = EnemiesStats[EnemyName].speed
	
	local step = 1
	
	local checkpoints = #waypoints
	
	task.spawn(function()
		while step < checkpoints and newEnemy.Humanoid.Health > 0 do
			newEnemy.Humanoid:MoveTo(waypoints[step].Position)
			
			newEnemy.Humanoid.MoveToFinished:Wait()
			
			step += 1
		end
		
		if step == checkpoints then
			HitBase(newEnemy)
		else newEnemy:Destroy()
		end
	end)
end

local currentWave = 0

local NUMENEMIES = 10

local function GenerateWave()
	local difficulty = 0
	
	for i = 1, NUMENEMIES do
		if difficulty < currentWave then
			difficulty += currentWave/NUMENEMIES
		end
		
		
		if difficulty <= 1 then
			SpawnEnemy("Zombie")
		elseif difficulty > 1 and difficulty < 3 then
			SpawnEnemy("Heavy")
		elseif difficulty > 5 then SpawnEnemy("Boss")
		end
		task.wait(1)
	end
end

local players = game:GetService("Players")

local function HasWaveEnded()
	if #SpawnedEnemies:GetChildren() == 0 then
		for _, player in players:GetPlayers() do
			player.Inventory.Money.Value += 500
		end
		return true
	end
	return false
end

while task.wait() do
	if HasWaveEnded() then
		currentWave += 1
		GenerateWave()
	end
end