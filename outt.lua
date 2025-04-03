for _,v in pairs(getgc(true)) do
	if typeof(v) == "Instance" and v:IsA("RemoteEvent") then
		if _G.XenoLog then
			_G.XenoLog("[RemoteEvent] ➜ " .. v:GetFullName())
		end
	end
end
