function WaitUntilVDReady()
    WaitUntil(function()
        return GetValue("_vdReady") == true
    end)
end