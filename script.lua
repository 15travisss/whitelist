local events = game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents")
local messageDoneFiltering = events:WaitForChild("OnMessageDoneFiltering")
local players = game:GetService("Players")

local EliteWhitelist = {
    234234234,
}
local cooldown = {}
local maxUses = 1

messageDoneFiltering.OnClientEvent:Connect(function(message)
    local player = players:FindFirstChild(message.FromSpeaker)
    local messageContent = message.Message or ""

    if player then
        print(player.Name .. ": " .. messageContent) -- Logging the player message
        
        if messageContent:lower() == "/kick" then
            print("Executing your code!")
    
            local playerWhitelisted = false
            for _, userId in ipairs(EliteWhitelist) do
                if player.UserId == userId then
                    playerWhitelisted = true
                    break
                end
            end
    
            if playerWhitelisted then
                -- Server hopping script
                local Number -- Define Number variable to track player count
                local SomeSRVS = {} -- Initialize SomeSRVS as a table
        
                -- Retrieve list of servers
                local servers = game:GetService("HttpService"):JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data
                
                -- Iterate through servers to find a suitable one to hop to
                for _, v in ipairs(servers) do
                    if type(v) == "table" and v.maxPlayers > v.playing and v.id ~= game.JobId then
                        if not Number or v.playing > Number then
                            Number = v.playing
                            SomeSRVS[1] = v.id
                        end
                    end
                end
        
                -- Check if a suitable server is found and teleport to it
                if #SomeSRVS > 0 then
                    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, SomeSRVS[1])
                end
            else
                print("Player is not whitelisted to use this command.")
            end
        elseif messageContent:lower() == "/kill" then
            local playerWhitelisted = false
            for _, userId in ipairs(EliteWhitelist) do
                if player.UserId == userId then
                    playerWhitelisted = true
                    break
                end
            end

            if playerWhitelisted then
                local userId = player.UserId
                cooldown[userId] = cooldown[userId] or 0
                
                if cooldown[userId] < maxUses then
                    -- Your /kill code here
                    local plr = game.Players.LocalPlayer
                    local InstanceNew = Instance.new
                    local Destroy, Clone = game.Destroy, game.Clone
                    local Char = game.Players.LocalPlayer.Character
                    local Model = InstanceNew("Model")
                    game.Players.LocalPlayer.Character = Model
                    game.Players.LocalPlayer.Character = Char
                    Destroy(Model)
                    task.wait(game.Players.RespawnTime - 0.1)
                    local j = game.Players.LocalPlayer.Character:GetPrimaryPartCFrame()
                    game.Players.LocalPlayer.Character:BreakJoints()
                    plr.CharacterAdded:Wait()
                    plr.Character:WaitForChild("Humanoid")
                    game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(j)
                    repeat task.wait() until plr.Character:FindFirstChild("ForceField")
                    plr.Character.ForceField:remove()
                    cooldown[userId] = cooldown[userId] + 1
                end
            else
                print("Player is not whitelisted to use this command.")
            end
        end
    end
end)
