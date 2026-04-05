local convert = {}

local faceByMesh = require("./faceByMesh")
local meshByName = require("./meshByName")

local function headMeshFromHumanoidDescription(humDesc: HumanoidDescription): number
	for _, bodyPartDescription in humDesc:GetChildren() do
		if not bodyPartDescription:IsA("BodyPartDescription") then continue end
		local HeadShape = bodyPartDescription.HeadShape

		-- HACK: these heads are not fully supported yet
		if bodyPartDescription.AssetId == 77954380016578 then
		    return meshByName["Hex"]
		end
		if bodyPartDescription.AssetId == 123297947692270 then
		    return meshByName["Diamond"]
		end
		if bodyPartDescription.AssetId == 83797968787123 then
		    return meshByName["CylinderMadness"]
		end
		if bodyPartDescription.AssetId == 124045894066016 then
		    return meshByName["Octoblox"]
		end
		if bodyPartDescription.AssetId == 87670789201977 then
		    return meshByName["iBot"]
		end

		if HeadShape ~= "" then
			return meshByName[HeadShape]
		end
		warn(`Head with ID {bodyPartDescription.AssetId} has no mesh equivalent - defaulting to classic head`)
	end
	return meshByName["RobloxClassic"]
end

function convert.convertCharacter(humanoid: Humanoid): ()
	local humDesc = humanoid:GetAppliedDescription()
	if humDesc == nil then
		return
	end
	local currentMesh = humDesc.Head
	local targetMesh = headMeshFromHumanoidDescription(humDesc)
	local face = faceByMesh[currentMesh]

	if face == nil then
		warn(`rbx-reface: no face mapping for mesh {currentMesh}`)
		return
	end


	humDesc.Head = targetMesh
	humDesc.Face = face
	humanoid:ApplyDescriptionResetAsync(humDesc)
	-- VERY UGLY HACK: iBot head texture workaround
	if targetMesh == meshByName["iBot"] then
	    local head: MeshPart = humanoid.Parent:FindFirstChild("Head")
		head.TextureID = "rbxassetid://97292285"
	end

end



return convert
