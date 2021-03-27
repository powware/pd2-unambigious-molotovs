UnambiguousMolotovs = UnambiguousMolotovs or {}
UnambiguousMolotovs.color = Color(0.1, 1, 0.2, 0)
UnambiguousMolotovs.damage_color = Color(0.3, 1, 0.2, 0)
UnambiguousMolotovs.damage_indicator_duration = 0.15

Hooks:PostHook(
    EnvironmentFire,
    "update",
    "UnambiguousMolotovs_EnvironmentFire_update",
    function(self, unit, t, dt)
        if self._burn_duration <= 0 then
            return
        end

        for index, damage_effect_entry in pairs(self._molotov_damage_effect_table) do
            if damage_effect_entry.body ~= nil then
                local damage_range = self._range * (index == 1 and 1.5 or 1)

                damage_effect_entry._brush = damage_effect_entry._brush or Draw:brush(UnambiguousMolotovs.color)

                damage_effect_entry._brush_damage_indicator_duration =
                    damage_effect_entry._brush_damage_indicator_duration or
                    UnambiguousMolotovs.damage_indicator_duration

                damage_effect_entry._brush_damage_indicator_duration =
                    damage_effect_entry._brush_damage_indicator_duration + dt

                if damage_effect_entry._brush_damage then
                    damage_effect_entry._brush_damage_indicator_duration = 0
                    damage_effect_entry._brush:set_color(UnambiguousMolotovs.damage_color)
                    damage_effect_entry._brush_damage = false
                elseif
                    damage_effect_entry._brush_damage_indicator_duration >=
                        UnambiguousMolotovs.damage_indicator_duration
                 then
                    damage_effect_entry._brush:set_color(UnambiguousMolotovs.color)
                end

                damage_effect_entry._brush:cylinder(
                    damage_effect_entry.effect_current_position,
                    damage_effect_entry.effect_current_position + Vector3(0, 0, 5),
                    damage_range,
                    50
                )
            end
        end
    end
)

Hooks:PostHook(
    EnvironmentFire,
    "_do_damage",
    "UnambiguousMolotovs_EnvironmentFire__do_damage",
    function(self)
        for index, damage_effect_entry in pairs(self._molotov_damage_effect_table) do
            if damage_effect_entry.body ~= nil then
                damage_effect_entry._brush_damage = true
            end
        end
    end
)
