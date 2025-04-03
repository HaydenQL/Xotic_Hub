local victim = game.Players:FindFirstChild("Fireeigg")
for i = 1, 10 do
    game.ReplicatedStorage.RagdollEvent:FireServer(victim)
    wait(0.2)
end
