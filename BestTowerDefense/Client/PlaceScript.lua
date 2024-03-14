local player = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local characters = workspace.Characters
local Button = player.PlayerGui.ScreenGui.CharactersSlots

local charStats = require(ReplicatedStorage.CharactersStats)

local Map = workspace.Map

local mouse = player:GetMouse()

local lastInput = nil
local lastKey = nil

UserInputService.InputBegan:Connect(function(input)
	lastInput = input.UserInputType
	lastKey = input.KeyCode
end)

local function InsertCharacter(button)
	local selected = nil
	
	for _, slots in player.Inventory:GetChildren() do
		if slots.Value == button.Text then
			selected = slots.Value
			break
		end
	end
	
	local tempChar = characters:FindFirstChild(selected):Clone()
	tempChar.Parent = workspace	
	
	mouse.TargetFilter = tempChar
	
	lastInput = nil
	
	local placeable = false
	
	local range = charStats[selected].attackRange[1]
	
	local rangeSphere = Instance.new("Part")
	rangeSphere.Parent = tempChar
	
	rangeSphere.Size = Vector3.new(range,range,range)
	rangeSphere.Transparency = 0
	rangeSphere.CanCollide = false
	rangeSphere.Anchored = true
	rangeSphere.Shape = Enum.PartType.Ball
	rangeSphere.Material = Enum.Material.ForceField
	rangeSphere.CastShadow = false
	
	while task.wait() and lastKey ~= Enum.KeyCode.Q do	
		tempChar.HumanoidRootPart.CFrame = CFrame.new(0,1,0) + mouse.Hit.Position 
		rangeSphere.CFrame = tempChar.HumanoidRootPart.CFrame

		if mouse.Target == Map.Terrain then
			for _, part in tempChar:GetChildren() do
				if part:IsA("BasePart") then
					part.Transparency = 0.5
					part.Color = Color3.fromRGB(0,255,0)
				end
				
				rangeSphere.Color = Color3.fromRGB(0,255,0)
				
				placeable = true
			end
		else
			for _, part in tempChar:GetChildren() do
				if part:IsA("BasePart") then
					part.Transparency = 0.5
					part.Color = Color3.fromRGB(255,0,0)
				end
				
				rangeSphere.Color = Color3.fromRGB(255,0,0)
				placeable = false
			end
		end
		
		if lastInput == Enum.UserInputType.MouseButton1 and placeable and player.Inventory.Money.Value >= charStats[selected].buyPrice then 
			player.Inventory.Money.Value -= charStats[selected].buyPrice
			ReplicatedStorage.AddDefender:FireServer(selected,tempChar.HumanoidRootPart.CFrame)
			break
		end
		
		lastInput = nil
		lastKey = nil
	end
	
	tempChar:Destroy()
	rangeSphere:Destroy()
end

Button.Slot1.SlotButton.MouseButton1Click:Connect(function()
	InsertCharacter(Button.Slot1.SlotButton)
end)

Button.Slot2.SlotButton.MouseButton1Click:Connect(function()
	InsertCharacter(Button.Slot2.SlotButton)
end)

Button.Slot3.SlotButton.MouseButton1Click:Connect(function()
	InsertCharacter(Button.Slot3.SlotButton)
end)

