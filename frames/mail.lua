local P, C = unpack(select(2, ...))
if C["EnableMail"] ~= true then return end

local stack = {}

local function send(self)
	if not SendMailFrame:IsShown() then return end

	for i=1, ATTACHMENTS_MAX_SEND do
		local slotLink = GetSendMailItemLink(i)
		local slotFrame = _G["SendMailAttachment"..i]

        P:TextDisplay(slotFrame, slotLink)
	end
end

local function inbox()
    if not InboxFrame:IsShown() then return end
	local numItems = GetInboxNumItems()
	local index = ((InboxFrame.pageNum - 1) * INBOXITEMS_TO_DISPLAY) + 1

	for i=1, INBOXITEMS_TO_DISPLAY do
		local slotFrame = _G["MailItem"..i.."Button"]
		if index <= numItems then
			for j=1, ATTACHMENTS_MAX_RECEIVE do
				local attachLink = GetInboxItemLink(index, j)
				if attachLink then
					table.insert(stack, attachLink)
				end
			end
		end

        P:TextDisplay(slotFrame, unpack(stack))
		wipe(stack)

		index = index + 1
	end
end

local function letter()
	if not InboxFrame.openMailID then return end

	for i=1, ATTACHMENTS_MAX_RECEIVE do
		local itemLink = GetInboxItemLink(InboxFrame.openMailID, i)
		if itemLink then
			local slotFrame = _G["OpenMailAttachmentButton"..i]

            P:TextDisplay(slotFrame, itemLink)
		end
	end
end

P:RegisterEvent("MAIL_SHOW", send)
P:RegisterEvent("MAIL_SEND_INFO_UPDATE", send)
P:RegisterEvent("MAIL_SEND_SUCCESS", send)
hooksecurefunc("OpenMail_Update", letter)
hooksecurefunc("InboxFrame_Update", inbox)