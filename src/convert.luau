local convert = {}

local faceByMesh = require("./faceByMesh")

local meshByName: {[string]: number} = {
	["Barrel"] = 6340170,
	["Blockhead"] = 6340101,
	["Cheeks"] = 746767604,
	["Chiseled"] = 616387160,
	["ClassicFemaleV2"] = 4637266996,
	["ClassicMaleV2"] = 4637245706,
	["CoolThing"] = 6340258,
	["CylinderMadness"] = 6340192,
	["Diamond"] = 8330576,
	["EraserHead"] = 6340161,
	["FatHead"] = 8330389,
	["FlatTop"] = 6340208,
	["GoldenKorbloxGeneral"] = 6678831309,
	["GoldenMrRobot"] = 6653077909,
	["HeadlessHead"] = 134082579,
	["Hex"] = 6340141,
	["iBot"] = 100302996,
	["KnightOfChivalry"] = 2510300430,
	["KnightOfCourage"] = 2535709102,
	["ManHead"] = 86498048,
	["MercilessNinja"] = 6652984223,
	["MrToilet"] = 4416630203,
	["Narrow"] = 746774687,
	["NeoClassicFemaleV2"] = 4637441617,
	["NeoClassicMaleV2"] = 4637163809,
	["Octoblox"] = 6340133,
	["Paragon"] = 616398268,
	["Peabrain"] = 8330578,
	["Perfection"] = 6340269,
	["RobloxClassic"] = 2432102561,
	["Roll"] = 6340198,
	["Roundy"] = 6340213,
	["RoxBox"] = 6340154,
	["TheEngineer"] = 6711225558,
	["Trim"] = 6340227,
	["WomanHead"] = 86498113,
}

local function headMeshFromHumanoidDescription(humDesc: HumanoidDescription): number
	for _, bodyPartDescription: BodyPartDescription in humDesc:GetChildren() do
		local HeadShape = bodyPartDescription.HeadShape
		if HeadShape ~= "" then
			return meshByName[HeadShape]
		end
	end
	return meshByName["RobloxClassic"]
end

function convert.convertCharacter(humanoid: Humanoid): ()
	local humDesc = humanoid:GetAppliedDescription()
	local currentMesh = humDesc.Head
	local targetMesh = headMeshFromHumanoidDescription(humDesc)
	local face = faceByMesh[currentMesh]

	if face == nil then
		return
	end

	humDesc.Head = targetMesh
	humDesc.Face = face
	humanoid:ApplyDescriptionResetAsync(humDesc)
end



return convert
