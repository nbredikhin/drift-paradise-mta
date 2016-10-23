Duel = RaceGamemode:subclass "Duel"

function Duel:clientFinished()
    triggerServerEvent("Race.clientFinished", RaceClient.raceElement)
end