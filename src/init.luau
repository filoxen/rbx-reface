local Players = game:GetService("Players")
local reface = {}
local convert = require("@self/convert")

local function onPlayerAdded(player: Player)
    player.CharacterAdded:Connect(function(character: Model)
        convert.convertCharacter(character.Humanoid)
    end)
    if player.Character then
        convert.convertCharacter(player.Character.Humanoid)
    end
end

function reface.init()
    Players.PlayerAdded:Connect(onPlayerAdded)
    for _, player in Players:GetPlayers() do
        onPlayerAdded(player)
    end
end

return reface
