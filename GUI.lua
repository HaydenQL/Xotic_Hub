local remotes = {}

for _, v in pairs(game:GetDescendants()) do
    if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
        table.insert(remotes, v:GetFullName())
    end
end

setclipboard(table.concat(remotes, "\n")) -- Copies the list to clipboard
print("Copied all remotes to clipboard.")
