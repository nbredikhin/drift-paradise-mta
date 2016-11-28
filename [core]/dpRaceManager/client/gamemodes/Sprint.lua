Sprint = RaceGamemode:subclass "Sprint"

function Sprint:init(...)
    self.super:init(...)
    self.ghostmodeEnabled = true
end