local players = game:GetService("Players")
local Towers = require(game:GetService("ReplicatedStorage").CharactersStats)

local MAX_SLOTS = 3

local PlayersInventories = {}

local function NewPlayer(player)
	local Inventory = Instance.new("Folder")
	Inventory.Parent = player
	Inventory.Name = "Inventory"

	for i = 1 , MAX_SLOTS do
		local slot = Instance.new("StringValue")
		slot.Name = string.format("%s%d","Slot",i)
		slot.Parent = Inventory
		slot.Value = "None"
	end
	
	local Money = Instance.new("NumberValue")
	Money.Name = "Money"
	Money.Parent = Inventory
	Money.Value = 500
	
	player.Inventory.Slot1.Value = "Puncher"
	player.Inventory.Slot2.Value = "Sniper"
	player.Inventory.Slot3.Value = "Gunner"
	
	PlayersInventories[player.UserId] = Inventory
end

players.PlayerAdded:Connect(NewPlayer)
