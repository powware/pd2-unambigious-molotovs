UnambigiousMolotovs = UnambigiousMolotovs or {}
UnambigiousMolotovs.color = Color(0.1, 1, 0.2, 0)
UnambigiousMolotovs.damage_color = Color(0.3, 1, 0.2, 0)
UnambigiousMolotovs.damage_indicator_duration = 0.2
Hooks:PostHook(
    EnvironmentFire,
    "update",
    "UnambigiousMolotovs_EnvironmentFire_update",
    function(self, unit, t, dt)
        for index, damage_effect_entry in pairs(self._molotov_damage_effect_table) do
            if damage_effect_entry.body ~= nil then
                local damage_range = self._range * (index == 1 and 1.5 or 1)

                damage_effect_entry._brush = damage_effect_entry._brush or Draw:brush(Color(0.1, 1, 0.2, 0))

                damage_effect_entry._brush_damage_indicator_duration =
                    damage_effect_entry._brush_damage_indicator_duration or
                    UnambigiousMolotovs.damage_indicator_duration

                damage_effect_entry._brush_damage_indicator_duration =
                    damage_effect_entry._brush_damage_indicator_duration + dt

                if damage_effect_entry._brush_damage then
                    damage_effect_entry._brush_damage_indicator_duration = 0
                    damage_effect_entry._brush:set_color(UnambigiousMolotovs.damage_color)
                    damage_effect_entry._brush_damage = false
                elseif
                    damage_effect_entry._brush_damage_indicator_duration >=
                        UnambigiousMolotovs.damage_indicator_duration
                 then
                    damage_effect_entry._brush:set_color(UnambigiousMolotovs.color)
                end

                damage_effect_entry._brush:cylinder(
                    damage_effect_entry.effect_current_position,
                    damage_effect_entry.effect_current_position + Vector3(0, 0, 5),
                    damage_range,
                    100
                )
            end
        end
    end
)

Hooks:PostHook(
    EnvironmentFire,
    "_do_damage",
    "UnambigiousMolotovs_EnvironmentFire__do_damage",
    function(self)
        for index, damage_effect_entry in pairs(self._molotov_damage_effect_table) do
            if damage_effect_entry.body ~= nil then
                damage_effect_entry._brush_damage = true
            end
        end
    end
)
