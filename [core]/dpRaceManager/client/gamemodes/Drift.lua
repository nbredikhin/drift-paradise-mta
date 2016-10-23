Drift = RaceGamemode:subclass "Drift"

function Drift:init(...)
    self.super:init(...)
end

function Drift:raceStarted(...)
    self.super:raceStarted(...)
    
    DriftPoints.start()
end

function Drift:raceStopped()
    self.super:raceStopped()

    DriftPoints.stop()
end

function Drift:clientFinished()
    FinishScreen.show(true)
    toggleAllControls(false)
    triggerServerEvent("Race.clientFinished", RaceClient.raceElement)
end