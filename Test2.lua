repeat wait() until _G.XenoLog
_G.XenoLog("🧱 Watching for your thrown Handle and preserving it with collision...")

local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()

char.DescendantAdded:Connect(function(obj)
	if obj:IsA("BasePart") and obj.Name == "Handle" then
		_G.XenoLog("📦 Detected thrown Handle: " .. obj:GetFullName())

		-- Wait briefly to let it launch
		task.wait(0.2)

		if obj and obj.Parent then
			-- Clone the part
			local clone = obj:Clone()
			clone.Name = "SavedHandle"
			clone.Parent = workspace

			-- Full collision setup
			clone.Anchored = false
			clone.CanCollide = true
			clone.Massless = false
			clone.Material = Enum.Material.Neon
			clone.Color = Color3.fromRGB(255, 0, 0)
			clone.CustomPhysicalProperties = PhysicalProperties.new(1000, 0.3, 0.5)

			-- Add aggressive spin
			local bav = Instance.new("BodyAngularVelocity")
			bav.AngularVelocity = Vector3.new(0, 999999, 0)
			bav.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
			bav.P = 3000
			bav.Parent = clone

			_G.XenoLog("✅ Cloned brick saved as 'SavedHandle' with collision enabled.")
		end
	end
end)
