local Players = game:GetService("Players")
local reface = {}
local convert = require("@self/convert")
local typing = require("@self/typing")

local function onPlayerAdded(player: Player)
    player.CharacterAppearanceLoaded:Connect(function(character: typing.CharacterModel)
        convert.convertCharacter(character.Humanoid)
    end)
    if player.Character then
        convert.convertCharacter((player.Character :: typing.CharacterModel).Humanoid)
    end
end

function reface.init()
    Players.PlayerAdded:Connect(onPlayerAdded)
    for _, player in Players:GetPlayers() do
        onPlayerAdded(player)
    end
end

return reface
