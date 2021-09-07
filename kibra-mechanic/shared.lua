KIBRA = {}

KIBRA.Mechanic = {
    ["Los Santos Custom"] = {
        ["MekanikName"] = "Los Santos Custom",
        ["MekanikJob"] = "lscustom",
        ["ErisimRutbe"] = "boss",
        ["AracSpawn"] = vector3(-362.62, -116.05, 38.6964),
        ["PatronMenu"] = vector3(-346.72, -127.55, 39.0096),
        ["MekanikShop"] = vector3(-346.13, -112.24, 39.0096),
        ["Araclar"] = {
           [1] = {Label = "Büyük Dorse", Model = "flatbed"},
           [2] = {Label = "SlamVan", Model = "slamvan"},
           [3] = {Label = "Halatlı Çekici", Model = "towtruck2"},
        }
    },

    ["Benny Custom"] = {
        ["MekanikName"] = "Benny Custom",
        ["MekanikJob"] = "benny",
        ["ErisimRutbe"] = "boss",
        ["AracSpawn"] = vector3(-210.80, -1304.4, 31.2971),
        ["PatronMenu"] = vector3(-195.98, -1340.1, 34.8994),
        ["MekanikShop"] = vector3(-196.41, -1318.0, 31.0893),
        ["Araclar"] = {
           [1] = {Label = "Büyük Dorse", Model = "flatbed"},
           [2] = {Label = "SlamVan", Model = "slamvan"},
           [3] = {Label = "Halatlı Çekici", Model = "towtruck2"},
        }
    },

    ["Dünya Mekanik"] = {
        ["MekanikName"] = "Dünya Mekanik",
        ["MekanikJob"] = "mekanik3",
        ["ErisimRutbe"] = "boss",
        ["AracSpawn"] = vector3(-1602.8, -826.44, 10.0311),
        ["PatronMenu"] = vector3(-1618.9, -833.08, 10.1298),
        ["MekanikShop"] = vector3(-1613.6, -837.65, 10.1298),
        ["Araclar"] = {
           [1] = {Label = "Büyük Dorse", Model = "flatbed"},
           [2] = {Label = "SlamVan", Model = "slamvan"},
           [3] = {Label = "Halatlı Çekici", Model = "towtruck2"},
        }
    },
}

KIBRA.MechanicShop = {
    Items = {
    [1] = { name = "telsiz", price = 10, count = 100,  info = {},  type = "item", slot = 1, },
    [2] = { name = "tamirkiti", price = 10, count = 100,  info = {},  type = "item", slot = 2, },
    }
}