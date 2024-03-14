local player = game:GetService("Players").LocalPlayer
local inventory = player:WaitForChild("Inventory")

local MAXHEALTH = 200
local MAXBAR = 592

local function SetGui()
	local ScreenGui = player.PlayerGui.ScreenGui
	
	local invChild = inventory:GetChildren()
	
	local base = workspace.Map.Base
	
	for i, slots in ScreenGui.CharactersSlots:GetChildren() do
		slots.SlotButton.Text = invChild[i].Value
	end
	
	ScreenGui.Currency.Money.Text = inventory:WaitForChild("Money").Value
	
	ScreenGui.BaseHealth.healthLabel.Text = string.format("%d",base.Health.Value)
	ScreenGui.BaseHealth.healthBar.Size = UDim2.new(base.Health.Value/MAXHEALTH,0,0.6,0) --MAXBAR - ((MAXBAR/100) * ((base.Health.Value * 100) / MAXHEALTH))
	
	
end

while task.wait() do
	SetGui()
end