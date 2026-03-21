✈️ X-Plane 12 – Smart Runway Light Control (FlyWithLua)

📌 Overview

This script improves the default runway lighting behavior in X-Plane 12 by eliminating rapid on/off switching (flickering) caused by frequent weather and lighting changes.

By default, X-Plane dynamically toggles runway lights based on environmental conditions such as cloud cover and visibility. However, the simulator reacts too aggressively to short-term changes (e.g. passing clouds), resulting in unrealistic and distracting light flickering.

This script introduces a smoothed, delay-based control system that stabilizes runway lighting behavior and makes it more consistent with real-world airport operations.

🚀 Features

⏱️ Delay-based switching (hysteresis)
Prevents rapid toggling of runway lights
Configurable delay (e.g. 3–5 minutes)

🌤️ Smart environmental logic
Uses multiple factors instead of a single threshold:
Sun angle (day/night detection)
Visibility (low visibility conditions)
Cloud coverage

⚡ Correct initial state
Lights are immediately set correctly at sim start (no delay)

🎯 Realistic behavior
Lights stay stable during transient weather changes
Mimics real-world airport lighting logic more closely


🧠 How It Works

The script evaluates whether runway lights should be ON or OFF based on:

Sun position (civil twilight threshold)
Reported visibility
Cloud layer coverage

Instead of applying changes instantly, it:

Detects a change in desired state
Starts a timer
Applies the change only if conditions persist for a defined period

This prevents flickering caused by short-lived environmental fluctuations.

⚙️ Requirements
X-Plane 12
FlyWithLua plugin

📂 Installation
Install FlyWithLua

Place the .lua script into:

X-Plane 12/Resources/plugins/FlyWithLua/Scripts/
Start X-Plane


🔧 Configuration

You can adjust the behavior by editing the following parameters:

local DELAY_SECONDS = 300      -- Delay before switching lights
local SUN_THRESHOLD = -6       -- Sun angle (degrees)
local VIS_THRESHOLD = 8000     -- Visibility threshold (meters)
local CLOUD_THRESHOLD = 0.6    -- Cloud coverage (0.0–1.0)

⚠️ Notes
This is a workaround for current X-Plane 12 lighting behavior
It overrides the default airport light logic
Weather datarefs in XP12 may occasionally behave inconsistently

💡 Future Improvements
Separate ON/OFF delays (faster ON, slower OFF)
Gradual light intensity transitions (fade in/out)
METAR-based logic for more accurate real-world behavior

🙌 Credits
Created as a community workaround for known X-Plane 12 runway lighting issues.
