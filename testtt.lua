-- Run this once when your GUI loads
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remote = ReplicatedStorage:FindFirstChild("LineformEvent") or Instance.new("RemoteEvent")
remote.Name = "LineformEvent"
remote.Parent = ReplicatedStorage
