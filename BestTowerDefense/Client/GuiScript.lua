local player = game:GetService("Players").LocalPlayer
local inventory = player:WaitForChild("Inventory")

local MAXHEALTH = 200
local MAXBAR = 592

local function SetGui()
	local ScreenGui = player.PlayerGui.ScreenGui
	
	local invChild = inventory:GetChildren()
	
	local base = workspace.Map.Base
	

	-- /* This should be wrapped into a new stack, it could slowdown the process of UI rendering when 'x' enemies are fount */
	for i, slots in ScreenGui.CharactersSlots:GetChildren() do
		slots.SlotButton.Text = invChild[i].Value
	end
	

	ScreenGui.Currency.Money.Text = inventory:WaitForChild("Money").Value

	-- string.format takes unnecessary space filling up the callstack, you could have used concatenation here, It would have been coeherced to a string.
	ScreenGui.BaseHealth.healthLabel.Text = string.format("%d",base.Health.Value)

	-- this is OK, 'health / maxhealth' is a good approach, but you obviously would handle cases where the health goes below 0 >:c
	ScreenGui.BaseHealth.healthBar.Size = UDim2.new(base.Health.Value/MAXHEALTH,0,0.6,0) --MAXBAR - ((MAXBAR/100) * ((base.Health.Value * 100) / MAXHEALTH))
end

-- /* THIS WERE NOT TESTED ANY LEADING CODE COULD BE POTENTIALLY INCORRECT, SEMANTICALLY WISE */
--
-- A continious loop, is sometime bad like in ur case, instead update each value individually at change.
-- e.g:
---[[
--- @param ValueObject entity will be our handler upon change
--- @return nil
---]]
-- local function at_update(entity, fn)
--	if not entity.value then
--		return
--	end
--	entity:GetPropertyChangedSignal("Value"):Connect(fn)
--end
--at_update(base.Health, function(v) ScreenGui.BaseHealth.healthLabel.Text = v end)


while task.wait() do
	SetGui()
end
