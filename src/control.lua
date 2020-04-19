local function toggle_nightvision(player)
  local character = player.character
  if character == nil then return end
  local grid = character.grid
  if grid == nil then return end

  local any_toggled = false

  for _, nve in pairs(grid.equipment) do
    if nve.type == 'night-vision-equipment' then
      local name = nve.name
      local position = nve.position
      local energy = nve.energy
      local shield = nve.shield
      local idx = string.find(name, '-disabled', -string.len('-disabled'))
      local toggled_name = ''
      if idx == nil then
        toggled_name = name .. '-disabled'
      else
        toggled_name = string.sub(name, 0, idx-1)
      end
      if game.equipment_prototypes[toggled_name] then
        grid.take({
          equipment = name,
          position = position,
        })
        local toggled_nve = grid.put({
          name = toggled_name,
          position = position,
        })
        toggled_nve.energy = energy
        if shield > 0 then
          toggled_nve.shield = shield
        end
        any_toggled = true
      end
    end
  end

  if any_toggled then
    -- TODO: play sound
  end
end

script.on_event(defines.events.on_lua_shortcut, function(event)
  if event.prototype_name == 'sonaxaton-nightvision-toggle' then
    local player = game.players[event.player_index]
    if player ~= nil then
      toggle_nightvision(player)
    end
  end
end)

script.on_event('sonaxaton-nightvision-toggle', function(event)
  local player = game.players[event.player_index]
  if player ~= nil then
    toggle_nightvision(player)
  end
end)
