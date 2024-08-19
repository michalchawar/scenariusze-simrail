--- Send the player radio message throughout the radio
--- @param key string The sound name to play
function RadioPlayerCall(key)
    RadioCall("Player_" .. key, true)
end