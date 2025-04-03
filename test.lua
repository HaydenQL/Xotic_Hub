workspace.ChildAdded:Connect(function(child)
	if child:IsA("Part") then
		_G.XenoLog("🧱 New Part Spawned: " .. child.Name)
	end
end)
