-- Smart Runway Light Control (XP12) - FIXED INIT

-- SETTINGS
local DELAY_ON = 60
local DELAY_OFF = 300  -- 5 min
local SUN_THRESHOLD = -6
local VIS_THRESHOLD = 8000
local CLOUD_THRESHOLD = 0.6

-- DATAREFS
dataref("sun_pitch", "sim/graphics/scenery/sun_pitch_degrees", "readonly")
dataref("visibility", "sim/weather/visibility_reported_m", "readonly")
dataref("cloud_coverage", "sim/weather/cloud_coverage[0]", "readonly")

dataref("light_level", "sim/graphics/scenery/airport_light_level")

-- STATE
local last_state = -1
local target_state = -1
local last_change_time = 0
local initialized = false

-- TIME
function now()
    return os.clock()
end

-- LOGIC
function should_lights_be_on()

    if sun_pitch < SUN_THRESHOLD then
        return 1
    end

    if visibility > 0 and visibility < VIS_THRESHOLD then
        return 1
    end

    if cloud_coverage > CLOUD_THRESHOLD then
        return 1
    end

    return 0
end

function update_lights()

    local t = now()
    local desired = should_lights_be_on()

    -- ✅ INIT (NO DELAY)
    if not initialized then
        last_state = desired
        target_state = desired
        last_change_time = t
        initialized = true
    end

    -- detect change
    if desired ~= target_state then
        target_state = desired
        last_change_time = t
    end

    -- apply delay only AFTER init
    if target_state ~= last_state then
        if (t - last_change_time) >= DELAY_SECONDS then
            last_state = target_state
        end
    end

    -- apply
    if last_state == 1 then
        set("sim/graphics/scenery/airport_light_level", 1.0)
    else
        set("sim/graphics/scenery/airport_light_level", 0.0)
    end

end

do_every_frame("update_lights()")