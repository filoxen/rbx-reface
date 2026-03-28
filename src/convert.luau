local convert = {}

local faceByMesh = require("./faceByMesh")
local meshByName = require("./meshByName")

local function headMeshFromHumanoidDescription(humDesc: HumanoidDescription): number
	for _, bodyPartDescription in humDesc:GetChildren() do
		if not bodyPartDescription:IsA("BodyPartDescription") then continue end
		local HeadShape = bodyPartDescription.HeadShape
		if HeadShape ~= "" then
			return meshByName[HeadShape]
		end
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
end



return convert
