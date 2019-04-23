local P, C = unpack(select(2, ...))

local argcheck = P.argcheck

function P:SetFontSettings()
	P:UpdateAllPipes()
end

function P:GetFontSettings()
	local db = PingumaniaItemLevelDB.FontSettings
	return db.typeface, db.size, db.align, db.reference, db.offsetx, db.offsety, db.flags, db.color
end