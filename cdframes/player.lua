module 'cdframes.player'

local T = require 'T'

local last_used = {}
local ignore_last_used = {}
local updated = true

do
	local t = {}
	function M.cooldowns()
		local time = GetTime()
		for k, v in t do
			if v.started + v.duration <= time then
				T.release(t[k])
				t[k] = nil
			end
		end
		return t
	end
	function start_cooldown(name, icon, started, duration, pet)
		if cdframes.used and not pet and not last_used[strlower(name)] and not ignore_last_used[name] then
			return
		end
		t[name] = T.map(
			'name', name,
			'icon', icon,
			'started', started,
			'duration', duration
		)
	end
	function stop_cooldown(name)
		if t[name] then
			T.release(t[name])
			t[name] = nil
		end
	end
end

CreateFrame'Frame':SetScript('OnUpdate', function()
    updated = true
end)



function BAG_UPDATE_COOLDOWN()
	for bag = 0, 4 do
		if GetBagName(bag) then
			for slot = 1, GetContainerNumSlots(bag) do
				local started, duration, enabled = GetContainerItemCooldown(bag, slot)
				if enabled == 1 then
					local name = link_name(GetContainerItemLink(bag, slot))
					if duration > 3 and duration <= 1800 and GetItemInfo(6948) ~= name then
						start_cooldown(
							name,
							GetContainerItemInfo(bag, slot),
							started,
							duration
						)
					elseif duration == 0 then
						stop_cooldown(started)
					end
				end
			end
		end
	end
	for slot = 0, 19 do
		local started, duration, enabled = GetInventoryItemCooldown('player', slot)
		if enabled == 1 then
			local name = link_name(GetInventoryItemLink('player', slot))
			if duration > 3 and duration <= 1800 then
				start_cooldown(
					name,
					GetInventoryItemTexture('player', slot),
					started,
					duration
				)
			elseif duration == 0 then
				stop_cooldown(started)
			end
		end
	end
end

function SPELL_UPDATE_COOLDOWN()
	local _, _, offset, spell_count = GetSpellTabInfo(GetNumSpellTabs())
	local total_spells = offset + spell_count
	for id = 1, total_spells do
		local started, duration, enabled = GetSpellCooldown(id, BOOKTYPE_SPELL)
		local name = GetSpellName(id, BOOKTYPE_SPELL)
		if enabled == 1 and duration > 2.5 then
			start_cooldown(
				name,
				GetSpellTexture(id, BOOKTYPE_SPELL),
				started,
				duration
			)
		elseif duration == 0 then
			stop_cooldown(name)
		end
		ignore_last_used[name] = enabled == 0 or nil
	end
	for id = 1, HasPetSpells() or 0 do
		local started, duration, enabled = GetSpellCooldown(id, BOOKTYPE_PET)
		local name = GetSpellName(id, BOOKTYPE_PET)
		if enabled == 1 and duration > 2.5 then
			start_cooldown(
				name,
				GetSpellTexture(id, BOOKTYPE_PET),
				started,
				duration,
				true
			)
		elseif duration == 0 then
			stop_cooldown(name)
		end
	end
end

function link_name(link)
	for name in string.gfind(link, '|Hitem:%d+:%d+:%d+:%d+|h[[]([^]]+)[]]|h') do return name end
end

function add_to_last_used(ability)
	if not ability then
		return
	end
	if updated then
		updated = false
		T.wipe(last_used)
	end
	last_used[strlower(ability)] = true
end

do
	local cast
	function SPELLCAST_START()
		cast = arg1
	end
	function SPELLCAST_STOP()
		cast = nil
	end
	function CHAT_MSG_SPELL_FAILED_LOCALPLAYER()
		for name, reason in string.gfind(arg1, 'You fail to %a+ (.*): (.*)') do
			if name == cast and reason ~= 'Another action is in progress.' then
				cast = nil
			end
		end
	end
	do
		local orig = UseContainerItem
		function _G.UseContainerItem(...)
			if not cast then
				add_to_last_used(link_name(GetContainerItemLink(unpack(arg)) or ''))
			end
			return orig(unpack(arg))
		end
	end
	do
		local orig = UseInventoryItem
		function _G.UseInventoryItem(...)
			if not cast then
				add_to_last_used(link_name(GetInventoryItemLink('player', arg[1]) or ''))
			end
			return orig(unpack(arg))
		end
	end
	do
		local orig = CastSpellByName
		function _G.CastSpellByName(...)
			if not cast then
				local _, _, ability = strfind(arg[1], '([^(*]*)')
				add_to_last_used(ability)
			end
			return orig(unpack(arg))
		end
	end
	do
		local orig = CastSpell
		function _G.CastSpell(...)
			if not cast then
				add_to_last_used(GetSpellName(unpack(arg)))
			end
			return orig(unpack(arg))
		end
	end
	do
		local orig = UseAction
		function _G.UseAction(...)
			if not cast and HasAction(arg[1]) and not GetActionText(arg[1]) then
				cdframes_tooltip:SetOwner(UIParent, 'ANCHOR_NONE')
				cdframes_tooltip:SetAction(arg[1])
				add_to_last_used(cdframes_tooltipTextLeft1:GetText())
			end
			return orig(unpack(arg))
		end
	end
end