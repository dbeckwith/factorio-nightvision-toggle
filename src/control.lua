local function toggle_nightvision(player)
  local character = player.character
  if character == nil then return end
  local grid = character.grid
  if grid == nil then return end

  local any_toggled = false

  for _, nve in pairs(grid.equipment) do
    if nve.type == 'night-vision-equipment' then
      -- log('looking at ' .. serpent.block(nve.prototype))
      local name = nve.name
      local position = nve.position
      local energy = nve.energy
      local shield = nve.shield
      log('name: ' .. name)
      local idx = string.find(name, '-disabled', -string.len('-disabled'))
      local toggled_name = ''
      if idx == nil then
        toggled_name = name .. '-disabled'
      else
        toggled_name = string.sub(name, 0, idx-1)
      end
      log('toggled name: ' .. toggled_name)
      if game.equipment_prototypes[toggled_name] then
        log('looks good, toggling ' .. name .. ' equipment at ' .. position.x .. ',' .. position.y)
        grid.take({
          equipment = name,
          position = position,
        })
        log('took existing equipment')
        local toggled_nve = grid.put({
          name = toggled_name,
          position = position,
        })
        -- log('new equip valid? ' .. toggled_nve.valid)
        log('setting energy to ' .. energy)
        toggled_nve.energy = energy
        if shield > 0 then
          log('setting shield to ' .. shield)
          toggled_nve.shield = shield
        end
        any_toggled = true
      end
    end
  end

  if any_toggled then
    -- play sound
  end
end

script.on_event(defines.events.on_lua_shortcut, function(event)
  if event.prototype_name == 'sonaxaton-nightvision-toggle-shortcut' then
    local player = game.players[event.player_index]
    if player ~= nil then
      toggle_nightvision(player)
    end
  end
end)
