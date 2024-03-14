local player = game:GetService("Players").LocalPlayer
local Replicated = game:GetService("ReplicatedStorage")
local InputService = game:GetService("UserInputService")

local mouse = player:GetMouse()

local screenGui = player.PlayerGui.ScreenGui
local UpgradeFrame = screenGui.Upgrade

local selectedUnit = nil

local function parseAttr(attr: string)
	if not attr then
		return
	end
	
	local parsedData = {}
	local cnt = 1
	print(attr)
	
	for val in string.gmatch(attr,"%d+") do
		parsedData[cnt] = val
		cnt += 1
	end
	
	return parsedData
end

InputService.InputBegan:Connect(function(input,gameprocessed)
	if gameprocessed then
		return
	end
	
	if input.UserInputType == Enum.UserInputType.MouseButton1 and mouse.Target.Parent:IsDescendantOf(workspace.PlacedUnits) then
		selectedUnit = mouse.Target.Parent
		
		local statsStr = parseAttr(selectedUnit:GetAttribute("UnitQueue"))

		UpgradeFrame.UpgradeBackground.AttackSpeedLabel.Text = string.format("Speed: %s",statsStr[1])
		UpgradeFrame.UpgradeBackground.AttackRangeLabel.Text = string.format("Range: %s",statsStr[2])
		
		UpgradeFrame.UpgradeBackground.NameLabel.Text = mouse.Target.Parent.Name
		UpgradeFrame.UpgradeBackground.LevelLabel.Text = string.format("Level: %s",statsStr[4])
		UpgradeFrame.UpgradeBackground.BuyButton.Text = string.format("Price: %s",statsStr[5])
		UpgradeFrame.UpgradeBackground.DamageLabel.Text =  string.format("Damage: %s",statsStr[6])
				
		UpgradeFrame.Visible = true
	end
end)

UpgradeFrame.UpgradeBackground.CloseButton.MouseButton1Click:Connect(function()
	UpgradeFrame.Visible = false
end)

UpgradeFrame.UpgradeBackground.BuyButton.MouseButton1Click:Connect(function()
	local money = player:FindFirstChild("Inventory").Money
	
	local statsStr = parseAttr(selectedUnit:GetAttribute("UnitQueue"))
	
	local price =tonumber(statsStr[5])
	
	local id = tonumber(statsStr[3])
	
	print(statsStr,id)
	
	if money.Value >= price and id ~= nil then
		money.Value -= price
		
		Replicated.UpgradeDefender:FireServer(id)
	end
	
end)