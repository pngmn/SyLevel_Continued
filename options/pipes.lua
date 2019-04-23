local P, C = unpack(select(2, ...))

local frame = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
frame.name = "Pipes"
frame.parent = P

do
	local title = P.createFontString(self, "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText(P.Name)

	local subtitle = P.createFontString(self)
	subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
	subtitle:SetPoint("RIGHT", self, -32, 0)
	subtitle:SetText"Select your display locations!"

	local scroll = CreateFrame("ScrollFrame", nil, self)
	scroll:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 0, -8)
	scroll:SetPoint("BOTTOMRIGHT", 0, 4)

	local scrollchild = CreateFrame("Frame", nil, self)
	scrollchild.rows = {}
	scrollchild:SetPoint"LEFT"
	scrollchild:SetHeight(scroll:GetHeight())
	-- So we have correct spacing on the right side.
	scrollchild:SetWidth(scroll:GetWidth() -16)
	self.scrollchild = scrollchild

	local filterFrame = CreateFrame("Frame", nil, self)
	filterFrame.rows = {}
	self.filterFrame = filterFrame

	scroll:SetScrollChild(scrollchild)
	scroll:UpdateScrollChildRect()
	scroll:EnableMouseWheel(true)

	scroll.value = 0
	scroll:SetVerticalScroll(0)
	scrollchild:SetPoint("TOP", 0, 0)

	self:refresh()
end

do
	local CheckBox_OnClick = function(self)
		local pipe = self:GetParent().pipe
		if (self:GetChecked()) then
			P:EnablePipe(pipe)
		else
			P:DisablePipe(pipe)
		end

		P:UpdatePipe(pipe)
	end

	local Filter_OnClick = function(self)
		local pipe = self:GetParent().pipe
		if (self:GetChecked()) then
			P:RegisterFilterOnPipe(pipe, self.name)
		else
			P:UnregisterFilterOnPipe(pipe, self.name)
		end

		P:UpdatePipe(pipe)
	end

	local Row_OnClick = function(self)
		self.owner.active = self

		local filterFrame = self.owner.filterFrame
		filterFrame.pipe = self.pipe

		filterFrame:Show()
		filterFrame:SetParent(self)

		filterFrame:ClearAllPoints()
		filterFrame:SetPoint("TOP", self.check, "BOTTOM")
		filterFrame:SetPoint("LEFT", 16, 0)
		filterFrame:SetPoint("RIGHT", -16, 0)

		self:SetHeight(filterFrame:GetHeight())

		for i=1, #filterFrame do
			local filter = filterFrame[i]
			filter:SetChecked(nil)
			for name, type, desc in P.IterateFiltersOnPipe(self.pipe) do
				filter:SetChecked(filter.name == name)
			end
		end

		do
			local rows = self.owner.scrollchild.rows
			local n = 1
			local row = rows[n]
			while (row) do
				if (row ~= self.owner.active) then
					row:SetBackdropBorderColor(.3, .3, .3)
					row:SetHeight(24)
				end

				n = n + 1
				row = rows[n]
			end
		end
	end

	local Row_OnEnter = function(self)
		self:SetBackdropBorderColor(.5, .9, .06)

		GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
		GameTooltip:SetText"Click for additional settings."
	end

	local Row_OnLeave = function(self)
		if(self ~= self.owner.active) then
			self:SetBackdropBorderColor(.3, .3, .3)
		end

		GameTooltip_Hide()
	end

	local createRow = function(parent, i)
		local row = CreateFrame("Button", nil, parent)

		row:SetBackdrop(_BACKDROP)
		row:SetBackdropColor(.1, .1, .1, .5)
		row:SetBackdropBorderColor(.3, .3, .3)

		if(i == 1) then
			row:SetPoint("TOP", 0, -8)
		else
			row:SetPoint("TOP", parent.rows[i - 1], "BOTTOM")
		end

		row:SetPoint("LEFT", 6, 0)
		row:SetPoint("RIGHT", -6, 0)
		row:SetHeight(24)

		row:SetScript("OnEnter", Row_OnEnter)
		row:SetScript("OnLeave", Row_OnLeave)
		row:SetScript("OnClick", Row_OnClick)

		local check = createCheckBox(row)
		check:SetPoint("LEFT", 10, 0)
		check:SetPoint("TOP", 0, -4)
		check:SetScript("OnClick", CheckBox_OnClick)
		row.check = check

		local label = P.createFontString(row)
		label:SetPoint("LEFT", check, "RIGHT", 5, -1)
		row.label = label

		table.insert(parent.rows, row)
		return row
	end

	function frame:refresh()
		local sChild = self.scrollchild
		local filterFrame = self.filterFrame

		-- XXX: Rewrite this to use P:GetNumFilters()
		local filters = {}
		for name, type, desc in P.IterateFilters() do
			table.insert(filters, {name = name; type = type, desc = desc})
		end

		local numFilters = #filters
		local split = 2
		if (numFilters > 1) then
			split = math.floor(numFilters / 2) + (numFilters % 2) + 1
		end

		for i=1, numFilters do
			local filter = filters[i]
			local check = filterFrame[i]
			if (not check) then
				check = createCheckBox(filterFrame)
				filterFrame[i] = check
			end

			check:ClearAllPoints()
			if (i == 1) then
				check:SetPoint("TOPLEFT", 16, -2)
			elseif (i == split) then
				check:SetPoint("TOP", 16, -2)
			else
				check:SetPoint("TOP", filterFrame[i - 1], "BOTTOM")
			end

			check:SetScript("OnClick", Filter_OnClick)

			local label = check.label
			if (not label) then
				label =  P.createFontString(check)
				label:SetPoint("LEFT", check, "RIGHT", 5, -1)
				check.label = label
			end
			label:SetText(filter.name)

			check.name = filter.name
			check.desc = filter.desc
			check.type = filter.type
			filterFrame[i] = check
		end

		-- We set split to 2 above (which makes this work correctly for
		-- numFilters == 1.
		filterFrame:SetHeight(((split-1) * 16) + 28)
		filterFrame:Hide()
		--[[
		local n = 1
		local unsortedRows = {}
		local sortedRows = {}
		for pipe, active, name, desc in P.IteratePipes() do
			sortedRows[name] = n
			unsortedRows[n] = {pipe, active, name, desc}
			n = n + 1
		end
		function pairsByKeys (t, f)
			local a = {}
			for n in pairs(t) do table.insert(a, n) end
				table.sort(a, f)
				local i = 0
				local iter = function ()
				i = i + 1
				if a[i] == nil then
					return nil
				else
					return a[i], t[a[i]]--[[
				end
			end
			return iter
		end
		n = 1
		for k,v in pairsByKeys(sortedRows) do
			local pipe, active, name, desc = unpack(unsortedRows[v])
			local row = sChild.rows[n] or createRow(sChild, n)

			row:SetBackdropBorderColor(.3, .3, .3)
			row:SetHeight(24)

			row.owner = self
			row.pipe = pipe
			row.check:SetChecked(active)
			row.label:SetText(name)
			n = n + 1
		end]]
		local n = 1
		for pipe, active, name, desc in P.IteratePipes() do
			local row = sChild.rows[n] or createRow(sChild, n)

			row:SetBackdropBorderColor(.3, .3, .3)
			row:SetHeight(24)

			row.owner = self
			row.pipe = pipe
			row.check:SetChecked(active)
			row.label:SetText(name)

			n = n + 1
		end
	end
end

InterfaceOptions_AddCategory(frame)