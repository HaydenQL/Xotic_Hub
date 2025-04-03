-- ⚔️ FE Sword for itschiefkeefhoe (client-side)
local Players = game:GetService("Players")
local player = Players.LocalPlayer

if not player or player.Name ~= "itschiefkeefhoe" then
    warn("[XENO] ❌ Access denied")
    return
end

repeat wait() until player.Character and player.Backpack

-- Create the tool
local tool = Instance.new("Tool")
tool.Name = "XenoBlade"
tool.RequiresHandle = true
tool.CanBeDropped = true

-- Create the handle
local handle = Instance.new("Part")
handle.Name = "Handle"
handle.Size = Vector3.new(1, 4, 1)
handle.BrickColor = BrickColor.new("Bright red")
handle.Material = Enum.Material.Neon
handle.CanCollide = false
handle.Anchored = false
handle.TopSurface = Enum.SurfaceType.Smooth
handle.BottomSurface = Enum.SurfaceType.Smooth

-- Optional: Visual damage
local damageScript = Instance.new("Script")
damageScript.Source = [[
script.Parent.Touched:Connect(function(hit)
	local human = hit.Parent:FindFirstChildOfClass("Humanoid")
	if human then
		human:TakeDamage(25)
	end
end)
]]
damageScript.Parent = handle

-- Finish tool
handle.Parent = tool
tool.GripForward = Vector3.new(0,0,-1)
tool.GripPos = Vector3.new(0,-1,0)
tool.GripRight = Vector3.new(1,0,0)
tool.GripUp = Vector3.new(0,1,0)

tool.Parent = player.Backpack

print("✅ [XENO] Sword given to itschiefkeefhoe")
