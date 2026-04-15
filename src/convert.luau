local convert = {}

local faceByMesh = require("./faceByMesh")
local meshByName = require("./meshByName")

-- these heads do not expose HeadShape correctly due to Roblox not migrating them fully
-- they are mapped by AssetId instead
local meshByAssetId: {[number]: string} = {
	[77954380016578]  = "Hex",
	[123297947692270] = "Diamond",
	[83797968787123]  = "CylinderMadness",
	[124045894066016] = "Octoblox",
	[87670789201977]  = "iBot",
}

local function headMeshFromHumanoidDescription(humDesc: HumanoidDescription): number
	for _, bodyPartDescription in humDesc:GetChildren() do
		if not bodyPartDescription:IsA("BodyPartDescription") then continue end

		local meshName = meshByAssetId[bodyPartDescription.AssetId]
		if meshName then
			return meshByName[meshName]
		end

		local HeadShape = bodyPartDescription.HeadShape
		if HeadShape ~= "" then
			return meshByName[HeadShape]
		end

		warn(`rbx-reface: head with ID {bodyPartDescription.AssetId} has no mesh equivalent - defaulting to classic head`)
	end
	return meshByName["RobloxClassic"]
end

function convert.applyHeadDescription(humDesc: HumanoidDescription): ()
	local currentMesh = humDesc.Head
	local targetMesh = headMeshFromHumanoidDescription(humDesc)
	local face = faceByMesh[currentMesh]

	if face == nil then
		warn(`rbx-reface: no face mapping for mesh {currentMesh}`)
		return
	end

	humDesc.Head = targetMesh
	humDesc.Face = face
	return targetMesh
end

function convert.fixiBotTexture(humanoid: Humanoid, targetMesh: number): ()
	-- iBot's texture is not correctly restored
	if targetMesh == meshByName["iBot"] then
		local head = humanoid.Parent:FindFirstChild("Head")
		if head then
			(head :: MeshPart).TextureID = "rbxassetid://97292285"
		else
			warn(`rbx-reface: could not find Head part to apply iBot texture workaround`)
		end
	end
end

function convert.convertCharacter(humanoid: Humanoid): ()
	local humDesc = humanoid:GetAppliedDescription()
	if humDesc == nil then
		warn(`rbx-reface: could not get applied description for {humanoid.Parent.Name}`)
		return
	end

	local targetMesh = convert.applyHeadDescription(humDesc)

	local ok, err = pcall(function()
		humanoid:ApplyDescriptionResetAsync(humDesc)
	end)

	if not ok then
		warn(`rbx-reface: failed to apply description: {err}`)
		return
	end

	convert.fixHeadTexture(humanoid, targetMesh)
end

return convert
