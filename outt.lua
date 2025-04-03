local ids = {
    2788229376, -- Adonis
    2030473490, -- Kohl's Admin
    5951389993, -- HD Admin (vulnerable)
    926280790,  -- Test
    4925462889, -- IceHub
}

for _, id in ipairs(ids) do
	pcall(function()
		local bd = require(id)
		_G.XenoLog("✅ Test require success: " .. id)
	end)
end
