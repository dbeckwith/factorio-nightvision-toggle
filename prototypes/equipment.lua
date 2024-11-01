local function make_disabled_nve(nve)
  -- copy original
  local disabled_nve = table.deepcopy(nve)

  -- generate new name
  disabled_nve.name = disabled_nve.name .. '-disabled'
  local nve_localised_name = nve.localised_name or {'equipment-name.' .. nve.name}
  -- generate new localized name
  disabled_nve.localised_name = {
    'sonaxaton-nightvision-toggle.disabled',
    nve_localised_name,
  }
  -- generate new localized description
  disabled_nve.localised_description = {
    'sonaxaton-nightvision-toggle.disabled-description',
    nve_localised_name,
  }
  -- make it consume no energy
  disabled_nve.energy_input = '0W'
  -- make it so the night vision never turns on
  disabled_nve.darkness_to_turn_on = 1
  -- produce original item when equipment is taken from the grid
  disabled_nve.take_result = nve.take_result or nve.name

  return disabled_nve
end

local new_nves = {}
for _, nve in pairs(data.raw['night-vision-equipment']) do
  log('adding disabled night vision equipment for ' .. nve.name)
  local disabled_nve = make_disabled_nve(nve)
  table.insert(new_nves, disabled_nve)
end
data:extend(new_nves)
