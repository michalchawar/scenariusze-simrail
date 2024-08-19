---@param signalOrTrackName string The signal or track name
---@return "signal" | "track" | "unknown", Track | SignalNetworkHolder | nil
function GetSignalOrTrackRef(signalOrTrackName)
  local type = "unknown"
  local ref = nil
  local track = FindTrack(signalOrTrackName)

  if (track == nil) then
      local signal = FindSignal(signalOrTrackName)

      if (signal == nil) then
          Error("Signal/Track not found (" .. signalOrTrackName .. ")")
      end

      type = "signal"
      ref = signal
  else
      type = "track"
      ref = track
  end

  return type, ref
end