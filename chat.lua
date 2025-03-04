local mt = getrawmetatable(game)
setreadonly(mt, false)
local old = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
    if tostring(getnamecallmethod()) == "Kick" and self == game.Players.LocalPlayer then
        return old(self, "You have been kicked.")
    end
    return old(self, ...)
end)
