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

    -- NIL SAFE VALUES
    local sp = sun_pitch or 90
    local vis = visibility or 99999
    local cloud = cloud_coverage or 0

    -- Night / twilight
    if sp < SUN_THRESHOLD then
        return 1
    end

    -- Low visibility
    if vis > 0 and vis < VIS_THRESHOLD then
        return 1
    end

    -- Heavy clouds
    if cloud > CLOUD_THRESHOLD then
        return 1
    end

    return 0
end

function update_lights()

    -- HARD GUARD (čekaj da datarefovi postoje)
    if sun_pitch == nil then return end

    local t = now()

    -- SAFE desired
    local desired = should_lights_be_on()
    if desired == nil then return end

    -- INIT (bez delay-a)
    if not initialized then
        last_state = desired or 0
        target_state = desired or 0
        last_change_time = t or 0
        initialized = true
    end

    -- dodatni safety (nikad nil)
    if target_state == nil then target_state = last_state or 0 end
    if last_state == nil then last_state = desired or 0 end
    if last_change_time == nil then last_change_time = t end

    -- detect change
    if desired ~= target_state then
        target_state = desired
        last_change_time = t
    end

    -- delay (nil-safe)
    if target_state ~= last_state then
        if t ~= nil and last_change_time ~= nil then
            if (t - last_change_time) >= DELAY_SECONDS then
                last_state = target_state
            end
        end
    end

    -- apply (final safety)
    if last_state == 1 then
        set("sim/graphics/scenery/airport_light_level", 1.0)
    else
        set("sim/graphics/scenery/airport_light_level", 0.0)
    end

end

do_every_frame("update_lights()")