local _, ns = ...
local SyLevel = ns.SyLevel

function SyLevel:SetFontSettings()
	SyLevel:UpdateAllPipes()
end

function SyLevel:GetFontSettings()
	local db = SyLevelDB.FontSettings
	return db.typeface, db.size, db.align, db.reference, db.offsetx, db.offsety, db.flags
end