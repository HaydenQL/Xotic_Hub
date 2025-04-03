remote:InvokeServer("Claim", game.Players.LocalPlayer.UserId)
remote:InvokeServer(game.Players.LocalPlayer.UserId, os.time())
remote:InvokeServer("DailyReward")
