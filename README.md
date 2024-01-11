This addon is a fork of SapperMorton's Guild Bank List Creator, which is no longer functional in modern classic WoW. This version is tested and working in SoD.

Guild Bank List Creator Plus creates copy-pastable, Discord-postable, lists of items on a character.  Please remember to open your bank in-game before creating a list to ensure that all items owned by your guild bank character are included on the list.

Items with suffixes ("X of the Y") will have their exact stats included in the mouseover tooltip of the Wowhead link after posting to Discord. (New in GBLC Plus 0.6)


TO GENERATE THE LIST, just type /gblc. I recommend making a macro and putting it somewhere on your bank character's action bars.

Command line options:
/gblc help
/gblc status
/gblc limit (number)
/gblc nolimit
/gblc links true|false
/gblc stack true|false
/gblc csv true|false
/gblc categorize true|false (New in GBLC Plus 0.6)
/gblc sort rarity|alpha (New in GBLC Plus 0.6)
/gblc exclude item name (count)
/gblc exclude id itemID (count)
/gblc include item name (count)
/gblc include id itemID (count)
/gblc clearitem item name
/gblc clearitem id itemID
/gblc clearlist


Help shows a short help for the addon.

Status shows your settings: limit number and wether you want to show Wowhead links or not.

Limit sets character limit for adding additional linefeed which is followed by "List continued" text. This is useful if you're pasting the list to Discord which has limited to 2000 characters per post. Set this to zero if you don't want added linefeeds.

Nolimit is the same as limit 0.

Links True adds Wowhead links for each item to the final list.

Links False hides Wowhead links

Stack True activates stacking of items with the same name

Stack False shows individual bag items

Csv True makes the addon output the list in CSV format. This also deactivates character limiter.

Csv False makes the addon output the list in original format. Character limiter is active.

Categorize True separates the list by itemType.

Categorize False outputs a monolithic list of all items.

Sort Rarity (default) outputs a list sorted by Rarity > MinLevel > Suffix > Alphabetical

Sort Alpha outputs a list only sorted alphabetically

Exclusion list (account wide).

Now you can add items to be excluded from the final list. Good for removing Hearthstones or other items that are private for the alt. Excluded items are listed as separate list after the main list.

New commands are:

/gblc exclude item name (count)    - Excludes item with given name. If no value is given for count, it is set to 1.

Example: /gblc exclude Silk Cloth 200

Excludes 200 Silk Cloth from the list. The addon lists total amount-200 silk cloth on the list.

/gblc exclude id itemID (count)    - Excludes item with given itemID. If no value is given for count, it is set to 1.

Example: /gblc exclude id 4306 200

Excludes 200 Silk Cloth from the list. The addon lists total amount-200 silk cloth on the list.

/gblc include item name (count)    - Includes excluded items back to main list. If no value is given for count, it is set to 1.

Example: /gblc include Silk Cloth 200

Moves 200 Silk Cloth back from the exclusion list. If the exclusion amount reaches zero, the addon automatically deletes the exclusion list entry.

/gblc include item id itemID (count)    - Includes excluded items back to main list. If no value is given for count, it is set to 1.

Example: /gblc include id 4306 200

Moves 200 Silk Cloth back from the exclusion list. If the exclusion amount reaches zero, the addon automatically deletes the exclusion list entry.

/gblc clearitem item name    - Clears item name from the exclusion list.

Example: /gblc clearitem Silk Cloth

Removes Silk Cloth entry from the exclusion list.

/gblc clearitem id itemID    - Clears item itemID from the exclusion list.

Example: /gblc clearitem id 4306

Removes Silk Cloth entry from the exclusion list.

/gblc clearlist    - Clears the exclusion list.



Please  note that with exclusion list you are possibly dealing with items which your character doesn't have on them or even have seen. This raises errors because on how Blizzard has made the system. So don't be alarmed if there's some "Unseen item with ID number".
