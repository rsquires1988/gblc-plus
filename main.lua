GBLC = LibStub("AceAddon-3.0"):NewAddon("GBLC", "AceConsole-3.0", "AceEvent-3.0")

function GBLC:OnInitialize()
---------------------------------------
-- Global variable initialization
---------------------------------------
	self.db = LibStub("AceDB-3.0"):New("GuildBankListCreatorDb", defaults)
	GBLC:RegisterChatCommand('gblc', 'HandleChatCommand');

	if (ListLimiter == nil) then
		ListLimiter = 0
	end
	
	if (ShowLinks == nil) then
		ShowLinks = true
	end
	
	if (StackItems == nil) then
		StackItems = false
	end

	if (UseCSV == nil) then
		UseCSV = false
	end
end

function GBLC:BoolText(input)
	local booltext = 'False'

	if (input) then
		booltext = 'True'
	end
	
	return booltext
end


function GBLC:HandleChatCommand(input)	

	local lcinput = string.lower(input)
	local gotcommands = false

---------------------------------------
-- Display help
---------------------------------------

	if (string.match(lcinput, "help")) then
		GBLC:Print('Guild Bank List Creator Help')
		GBLC:Print('Usage:')
		GBLC:Print('/gblc                         -- Creates list of items')
		GBLC:Print('/gblc status               -- Shows settings')
		GBLC:Print('/gblc limit (number) -- Sets a character limit on (number) to split')
		GBLC:Print('-- the list with extra linefeed. This is useful when you paste the')
		GBLC:Print('-- list to Discord which limits post lengths to 2000 characters.')
		GBLC:Print('-- Set limit to 0 if you don\'t want to get linefeed splits')
		GBLC:Print('/gblc nolimit           -- Same as limit 0')	
		GBLC:Print('/gblc links true       -- Shows Wowhead links on each item')
		GBLC:Print('/gblc links false      -- No Wowhead links on any items')
		GBLC:Print('/gblc stack true       -- Combines items with same name')
		GBLC:Print('/gblc stack false      -- Shows individual items')
		GBLC:Print('/gblc csv true         -- Output in CSV format')
		GBLC:Print('/gblc csv false        -- Output in original format')
		gotcommands = true
	end

---------------------------------------
-- Display status
---------------------------------------

	if (string.match(lcinput, "status")) then
		GBLC:Print('Guild Bank List Creator Status')
		GBLC:Print('Character limit: ' .. ListLimiter)
		GBLC:Print('Show Wowhead links: ' .. GBLC:BoolText(ShowLinks))
		GBLC:Print('Combine items to stacks: ' .. GBLC:BoolText(StackItems))
		if (not UseCSV) then
			GBLC:Print('Output CSV: ' .. GBLC:BoolText(UseCSV))
		else
			GBLC:Print('Output CSV: ' .. GBLC:BoolText(UseCSV) .. '. The character limiter is off.')
		end
		gotcommands = true
	end

---------------------------------------
-- Set limit
---------------------------------------

	if (string.match(lcinput, "limit")) then
		local snumbers = tonumber(string.match(lcinput, "limit (%d+)"))
		
		if (string.match(lcinput, "nolimit")) then
			snumbers = 0
		end
		
		if ((snumbers > 0) and (snumbers < 150)) then
			GBLC:Print('Limiter number too low.')
			snumbers = 500
		end
		ListLimiter = snumbers
		GBLC:Print('Setting character limit to ' .. ListLimiter)
		gotcommands = true
	end
	
---------------------------------------
-- Enable or disable Wowhead links
---------------------------------------

	if (string.match(lcinput, "links true")) then
		GBLC:Print('Showing Wowhead links')
		ShowLinks = true
		gotcommands = true
	end
	
	if (string.match(lcinput, "links false")) then
		GBLC:Print('Hiding Wowhead links')
		ShowLinks = false
		gotcommands = true
	end

---------------------------------------
-- Enable or disable stacking items
---------------------------------------
	if (string.match(lcinput, "stack true")) then
		GBLC:Print('Combining items of same name to stacks')
		StackItems = true
		gotcommands = true
	end
	
	if (string.match(lcinput, "stack false")) then
		GBLC:Print('Showing individual items')
		StackItems = false
		gotcommands = true
	end

---------------------------------------
-- Enable or disable CSV format
---------------------------------------
	if (string.match(lcinput, "csv true")) then
		GBLC:Print('Printing list in CSV format. The character limiter is now off.')
		UseCSV = true
		gotcommands = true
	end
	
	if (string.match(lcinput, "csv false")) then
		GBLC:Print('Printing list in user readable format')
		UseCSV = false
		gotcommands = true
	end

---------------------------------------
-- Generate list
---------------------------------------

	if (not gotcommands) then
		local bags = GBLC:GetBags()
		local bagItems = GBLC:GetBagItems()
		local itemlistsort = {}
		local exportString = ''
		local wowheadlink = ''
		local copper = GetMoney()
		local moneystring = (("%dg %ds %dc"):format(copper / 100 / 100, (copper / 100) % 100, copper % 100));
		local gametimehours, gametimeminutes = GetGameTime()
		local texthours = string.format("%02d", gametimehours)
		local textminutes = string.format("%02d", gametimeminutes)
		if (not UseCSV) then
			exportString = 'Bank list updated on ' .. date("%d.%m.%Y ") .. texthours .. '.' .. textminutes .. ' server time\nCharacter: ' .. UnitName('player') .. '\nGold: ' .. moneystring .. '\n\n'
		else
			exportString = date("%d.%m.%Y") .. ',' .. texthours .. '.' .. textminutes .. ',' .. UnitName('player') .. ',' .. moneystring .. '\n'
		end
		
		local exportLength = string.len(exportString)

		for i=1, #bagItems do
			if (ShowLinks) then
				wowheadlink = 'https://classic.wowhead.com/item=' .. bagItems[i].itemID
				if (not UseCSV) then
					wowheadlink = '    ' .. wowheadlink
				end
			else
				wowheadlink = ''
			end
			if (not UseCSV) then
				itemlistsort[i] = bagItems[i].itemName .. ' (' .. bagItems[i].count .. ')' .. wowheadlink ..'\n'
			else
				itemlistsort[i] = bagItems[i].itemName .. ',' .. bagItems[i].count .. ',' .. wowheadlink ..', \n'
			end
		end
		
		table.sort(itemlistsort);

		for i=1, #itemlistsort do
			if ((ListLimiter > 0) and (not UseCSV)) then
				if ((exportLength + string.len(itemlistsort[i])) > ListLimiter) then
					exportString = exportString .. '\nList continued\n'
					exportLength = 0
				end
			end
			exportString = exportString .. itemlistsort[i]
			exportLength = exportLength + string.len(itemlistsort[i])
		end

		GBLC:DisplayExportString(exportString)
		
	end

end

function GBLC:GetBags()

	local bags = {}

	for container = -1, 12 do
		bags[#bags + 1] = {
			container = container,
			bagName = GetBagName(container)
		}
	end

	return bags;
end

function GBLC:GetBagItems()
	local bagItems = {}

	for container = -1, 12 do
	local numSlots = GetContainerNumSlots(container)

	for slot=1, numSlots do
		local texture, count, locked, quality, readable, lootable, link, isFiltered, hasNoValue, itemID = GetContainerItemInfo(container, slot)

		if itemID then
			local sName, sLink, iRarity, iLevel, iMinLevel, sType, sSubType, iStackCount = GetItemInfo(itemID)
			local stacked = false
			
			if ((StackItems) and (#bagItems > 0)) then
				for stackitem = 1, #bagItems do
					if (bagItems[stackitem].itemID == itemID) then
						bagItems[stackitem].count = bagItems[stackitem].count + count
						stacked = true
						break
					end
				end
			end

			if (not stacked) then
				bagItems[#bagItems + 1] = {					
					itemName = sName,
					itemID = itemID,
					count = count
				}
			end
		end
	end
	end

	return bagItems
end

function GBLC:DisplayExportString(str)

	gblcFrame:Show();
	gblcFrameScroll:Show()
	gblcFrameScrollText:Show()
	gblcFrameScrollText:SetText(str)
	gblcFrameScrollText:HighlightText()
	
	gblcFrameButton:SetScript("OnClick", function(self)
		gblcFrame:Hide();
		end
	);
end
