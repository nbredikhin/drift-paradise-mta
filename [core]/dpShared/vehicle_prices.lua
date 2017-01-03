-- {цена, уровень, донат-валюта}
local vehiclesPrices = {
    -- 1 класс
    toyota_ae86             = {0, 1},
    nissan_skyline2000      = {0, 1},
    honda_civic             = {0, 1},
    -- 2 класс
    mazda_mx5miata          = {0, 1},
    nissan_180sx            = {0, 1},
    mitsubishi_eclipse      = {0, 1},
    nissan_silvia_s13       = {0, 1},
    -- 3 класс
    nissan_datsun_240z      = {0, 1},
    mazda_rx7_fc            = {0, 1},
    nissan_skyline_er34     = {0, 1},
    toyota_mark2_100        = {0, 1},
    bmw_e30                 = {0, 1},
    toyota_altezza          = {0, 1},
    -- 4 класс
    honda_s2000             = {0, 1},
    subaru_impreza          = {0, 1},
    bmw_e34                 = {0, 1},
    nissan_silvia_s14       = {0, 1},
    nissan_silvia_s15       = {0, 1},
    mazda_rx8               = {0, 1},
    -- 5 класс
    bmw_e60                 = {0, 1},
    toyota_supra            = {0, 1},
    bmw_e46                 = {0, 1},
    nissan_skyline_gtr34    = {0, 1},
    subaru_brz              = {0, 1},
    -- 6 класс
    nissan_gtr35            = {0, 1},
    lamborghini_huracan     = {0, 1},
    ferrari_458_italia      = {0, 1},
    lamborghini_aventador   = {0, 1},
}

function getVehiclePrices(name)
    if name then
        return vehiclesPrices[name]
    end
end
