local remotes = {}
 
 -- Find and list all RemoteEvents in the game
 for _, v in pairs(game:GetDescendants()) do
     if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
         table.insert(remotes, v:GetFullName())
     if v:IsA("RemoteEvent") then
         print("RemoteEvent found: " .. v:GetFullName()) -- This prints the full path
     end
 end
 
 
 setclipboard(table.concat(remotes, "\n")) -- Copies the list to clipboard
 print("Copied all remotes to clipboard.")
