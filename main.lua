GBLC = LibStub("AceAddon-3.0"):NewAddon("GBLC", "AceConsole-3.0", "AceEvent-3.0")
FrameText = ''

-- Added all lookup tables
local rarityLookup = {
    [0] = "Poor",
    [1] = "Common",
    [2] = "Uncommon",
    [3] = "Rare",
    [4] = "Epic",
    [5] = "Legendary",
    [6] = "Arifact",
    [7] = "Heirloom"
}

local slotLookup = {
    ["INVTYPE_AMMO"] = "Ammo",
    ["INVTYPE_HEAD"] = "Head",
    ["INVTYPE_NECK"] = "Neck",
    ["INVTYPE_SHOULDER"] = "Shoulder",
    ["INVTYPE_BODY"] = "Shirt",
    ["INVTYPE_CHEST"] = "Chest",
    ["INVTYPE_ROBE"] = "Chest",
    ["INVTYPE_WAIST"] = "Waist",
    ["INVTYPE_LEGS"] = "Legs",
    ["INVTYPE_FEET"] = "Feet",
    ["INVTYPE_WRIST"] = "Wrist",
    ["INVTYPE_HAND"] = "Hands",
    ["INVTYPE_FINGER"] = "Finger",
    ["INVTYPE_TRINKET"] = "Trinket",
    ["INVTYPE_CLOAK"] = "Back",
    ["INVTYPE_WEAPON"] = "One-Hand",
    ["INVTYPE_SHIELD"] = "Off Hand",
    ["INVTYPE_2HWEAPON"] = "Two-Hand",
    ["INVTYPE_WEAPONMAINHAND"] = "Main Hand",
    ["INVTYPE_WEAPONOFFHAND"] = "Off Hand",
    ["INVTYPE_HOLDABLE"] = "Held In Off-hand",
    ["INVTYPE_RANGED"] = "Ranged",
    ["INVTYPE_THROWN"] = "Thrown",
    ["INVTYPE_RANGEDRIGHT"] = "Ranged",
    ["INVTYPE_RELIC"] = "Relic",
    ["INVTYPE_TABARD"] = "Tabard",
    ["INVTYPE_BAG"] = "Bag",
}

local stackableLookup = {
    -- some falses need to look in sub table
    ["Consumable"] = true,
    ["Container"] = false, -- this will be wrong in wotlk
    ["Weapon"] = false,
    ["Gem"] = true, -- ?
    ["Armor"] = false,
    ["Reagent"] = true,
    ["Projectile"] = true,
    ["Trade Goods"] = true,
    ["Item Enhancement"] = false, -- some edge cases, but they're BoP
    ["Recipe"] = false,
    ["Money"] = true, -- probably, not sure if this is obsolete in classic or not, key may be Money(OBSOLETE)
    ["Quiver"] = false,
    ["Quest"] = true,
    ["Key"] = true, -- maybe
    ["Permanent"] = false, -- no idea, may be similar to money aka Permanent(OBSOLETE)
    ["Miscellaneous"] = {
                            ["Junk"] = true,
                            ["Reagent"] = true,
                            ["Companion Pets"] = false,
                            ["Holiday"] = true,
                            ["Other"] = true,
                            ["Mount"] = false,
                            ["Mount Equipment"] = false
                        },
--    ["Glyph"] = false,
--    ["Battle Pets"] = false,
--     ["WoW Token"] = false,
    ["Profession"] = true -- not sure
}

local suffixOfTheBearLookup = {
    [1179] = "+1 STA, +1 STR", [1180] = "+2 STA, +1 STR", [1181] = "+1 STA, +2 STR",
    [1182] = "+2 STA, +2 STR", [1183] = "+3 STA, +2 STR", [1184] = "+2 STA, +3 STR",
    [1185] = "+3 STA, +3 STR", [1186] = "+4 STA, +3 STR", [1187] = "+3 STA, +4 STR",
    [1188] = "+4 STA, +4 STR", [1189] = "+5 STA, +4 STR", [1190] = "+4 STA, +5 STR",
    [1191] = "+5 STA, +5 STR", [1192] = "+6 STA, +5 STR", [1193] = "+5 STA, +6 STR",
    [1194] = "+6 STA, +6 STR", [1195] = "+7 STA, +6 STR", [1196] = "+6 STA, +7 STR",
    [1197] = "+7 STA, +7 STR", [1198] = "+8 STA, +7 STR", [1199] = "+7 STA, +8 STR",
    [1200] = "+8 STA, +8 STR", [1201] = "+9 STA, +8 STR", [1202] = "+8 STA, +9 STR",
    [1203] = "+9 STA, +9 STR", [1204] = "+10 STA, +9 STR", [1205] = "+9 STA, +10 STR",
    [1206] = "+10 STA, +10 STR", [1207] = "+11 STA, +10 STR", [1208] = "+10 STA, +11 STR",
    [1209] = "+11 STA, +11 STR", [1210] = "+12 STA, +11 STR", [1211] = "+11 STA, +12 STR",
    [1212] = "+12 STA, +12 STR", [1213] = "+13 STA, +12 STR", [1214] = "+12 STA, +13 STR",
    [1215] = "+13 STA, +13 STR", [1216] = "+14 STA, +13 STR", [1217] = "+13 STA, +14 STR",
    [1218] = "+14 STA, +14 STR", [1219] = "+15 STA, +14 STR", [1220] = "+14 STA, +15 STR",
    [1221] = "+15 STA, +15 STR", [1222] = "+16 STA, +15 STR", [1223] = "+15 STA, +16 STR",
    [1224] = "+16 STA, +16 STR", [1225] = "+17 STA, +16 STR", [1226] = "+16 STA, +17 STR",
    [1227] = "+17 STA, +17 STR", [1228] = "+18 STA, +17 STR", [1229] = "+17 STA, +18 STR",
    [1230] = "+18 STA, +18 STR", [1231] = "+19 STA, +18 STR", [1232] = "+18 STA, +19 STR",
    [1233] = "+19 STA, +19 STR", [1234] = "+20 STA, +19 STR", [1235] = "+19 STA, +20 STR",
    [1236] = "+20 STA, +20 STR", [1237] = "+21 STA, +20 STR", [1238] = "+20 STA, +21 STR",
    [1239] = "+21 STA, +21 STR", [1240] = "+22 STA, +21 STR", [1241] = "+21 STA, +22 STR",
    [1242] = "+22 STA, +22 STR", [1243] = "+23 STA, +22 STR", [1244] = "+22 STA, +23 STR",
    [1245] = "+23 STA, +23 STR", [1246] = "+24 STA, +23 STR", [1247] = "+23 STA, +24 STR",
    [1248] = "+24 STA, +24 STR", [1249] = "+25 STA, +24 STR", [1250] = "+24 STA, +25 STR",
    [1251] = "+25 STA, +25 STR", [1252] = "+26 STA, +25 STR", [1253] = "+25 STA, +26 STR",
    [1254] = "+26 STA, +26 STR", [1255] = "+27 STA, +26 STR", [1256] = "+26 STA, +27 STR",
    [1257] = "+27 STA, +27 STR", [1258] = "+28 STA, +27 STR", [1259] = "+27 STA, +28 STR",
    [1260] = "+28 STA, +28 STR", [1261] = "+29 STA, +28 STR", [1262] = "+28 STA, +29 STR",
    [1263] = "+29 STA, +29 STR"
}

local suffixOfTheBoarLookup = {
    [1094] = "+1 SPI, +1 STR", [1095] = "+2 SPI, +1 STR", [1096] = "+1 SPI, +2 STR",
    [1097] = "+2 SPI, +2 STR", [1098] = "+3 SPI, +2 STR", [1099] = "+2 SPI, +3 STR",
    [1100] = "+3 SPI, +3 STR", [1101] = "+4 SPI, +3 STR", [1102] = "+3 SPI, +4 STR",
    [1103] = "+4 SPI, +4 STR", [1104] = "+5 SPI, +4 STR", [1105] = "+4 SPI, +5 STR",
    [1106] = "+5 SPI, +5 STR", [1107] = "+6 SPI, +5 STR", [1108] = "+5 SPI, +6 STR",
    [1109] = "+6 SPI, +6 STR", [1110] = "+7 SPI, +6 STR", [1111] = "+6 SPI, +7 STR",
    [1112] = "+7 SPI, +7 STR", [1113] = "+8 SPI, +7 STR", [1114] = "+7 SPI, +8 STR",
    [1115] = "+8 SPI, +8 STR", [1116] = "+9 SPI, +8 STR", [1117] = "+8 SPI, +9 STR",
    [1118] = "+9 SPI, +9 STR", [1119] = "+10 SPI, +9 STR", [1120] = "+9 SPI, +10 STR",
    [1121] = "+10 SPI, +10 STR", [1122] = "+11 SPI, +10 STR", [1123] = "+10 SPI, +11 STR",
    [1124] = "+11 SPI, +11 STR", [1125] = "+12 SPI, +11 STR", [1126] = "+11 SPI, +12 STR",
    [1127] = "+12 SPI, +12 STR", [1128] = "+13 SPI, +12 STR", [1129] = "+12 SPI, +13 STR",
    [1130] = "+13 SPI, +13 STR", [1131] = "+14 SPI, +13 STR", [1132] = "+13 SPI, +14 STR",
    [1133] = "+14 SPI, +14 STR", [1134] = "+15 SPI, +14 STR", [1135] = "+14 SPI, +15 STR",
    [1136] = "+15 SPI, +15 STR", [1137] = "+16 SPI, +15 STR", [1138] = "+15 SPI, +16 STR",
    [1139] = "+16 SPI, +16 STR", [1140] = "+17 SPI, +16 STR", [1141] = "+16 SPI, +17 STR",
    [1142] = "+17 SPI, +17 STR", [1143] = "+18 SPI, +17 STR", [1144] = "+17 SPI, +18 STR",
    [1145] = "+18 SPI, +18 STR", [1146] = "+19 SPI, +18 STR", [1147] = "+18 SPI, +19 STR",
    [1148] = "+19 SPI, +19 STR", [1149] = "+20 SPI, +19 STR", [1150] = "+19 SPI, +20 STR",
    [1151] = "+20 SPI, +20 STR", [1152] = "+21 SPI, +20 STR", [1153] = "+20 SPI, +21 STR",
    [1154] = "+21 SPI, +21 STR", [1155] = "+22 SPI, +21 STR", [1156] = "+21 SPI, +22 STR",
    [1157] = "+22 SPI, +22 STR", [1158] = "+23 SPI, +22 STR", [1159] = "+22 SPI, +23 STR",
    [1160] = "+23 SPI, +23 STR", [1161] = "+24 SPI, +23 STR", [1162] = "+23 SPI, +24 STR",
    [1163] = "+24 SPI, +24 STR", [1164] = "+25 SPI, +24 STR", [1165] = "+24 SPI, +25 STR",
    [1166] = "+25 SPI, +25 STR", [1167] = "+26 SPI, +25 STR", [1168] = "+25 SPI, +26 STR",
    [1169] = "+26 SPI, +26 STR", [1170] = "+27 SPI, +26 STR", [1171] = "+26 SPI, +27 STR",
    [1172] = "+27 SPI, +27 STR", [1173] = "+28 SPI, +27 STR", [1174] = "+27 SPI, +28 STR",
    [1175] = "+28 SPI, +28 STR", [1176] = "+29 SPI, +28 STR", [1177] = "+28 SPI, +29 STR",
    [1178] = "+29 SPI, +29 STR"
}

local suffixOfTheEagleLookup = {
    [839] = "+1 INT, +1 STA", [840] = "+2 INT, +1 STA", [841] = "+1 INT, +2 STA",
    [842] = "+2 INT, +2 STA", [843] = "+3 INT, +2 STA", [844] = "+2 INT, +3 STA",
    [845] = "+3 INT, +3 STA", [846] = "+4 INT, +3 STA", [847] = "+3 INT, +4 STA",
    [848] = "+4 INT, +4 STA", [849] = "+5 INT, +4 STA", [850] = "+4 INT, +5 STA",
    [851] = "+5 INT, +5 STA", [852] = "+6 INT, +5 STA", [853] = "+5 INT, +6 STA",
    [854] = "+6 INT, +6 STA", [855] = "+7 INT, +6 STA", [856] = "+6 INT, +7 STA",
    [857] = "+7 INT, +7 STA", [858] = "+8 INT, +7 STA", [859] = "+7 INT, +8 STA",
    [860] = "+8 INT, +8 STA", [861] = "+9 INT, +8 STA", [862] = "+8 INT, +9 STA",
    [863] = "+9 INT, +9 STA", [864] = "+10 INT, +9 STA", [865] = "+9 INT, +10 STA",
    [866] = "+10 INT, +10 STA", [867] = "+11 INT, +10 STA", [868] = "+10 INT, +11 STA",
    [869] = "+11 INT, +11 STA", [870] = "+12 INT, +11 STA", [871] = "+11 INT, +12 STA",
    [872] = "+12 INT, +12 STA", [873] = "+13 INT, +12 STA", [874] = "+12 INT, +13 STA",
    [875] = "+13 INT, +13 STA", [876] = "+14 INT, +13 STA", [877] = "+13 INT, +14 STA",
    [878] = "+14 INT, +14 STA", [879] = "+15 INT, +14 STA", [880] = "+14 INT, +15 STA",
    [881] = "+15 INT, +15 STA", [882] = "+16 INT, +15 STA", [883] = "+15 INT, +16 STA",
    [884] = "+16 INT, +16 STA", [885] = "+17 INT, +16 STA", [886] = "+16 INT, +17 STA",
    [887] = "+17 INT, +17 STA", [888] = "+18 INT, +17 STA", [889] = "+17 INT, +18 STA",
    [890] = "+18 INT, +18 STA", [891] = "+19 INT, +18 STA", [892] = "+18 INT, +19 STA",
    [893] = "+19 INT, +19 STA", [894] = "+20 INT, +19 STA", [895] = "+19 INT, +20 STA",
    [896] = "+20 INT, +20 STA", [897] = "+21 INT, +20 STA", [898] = "+20 INT, +21 STA",
    [899] = "+21 INT, +21 STA", [900] = "+22 INT, +21 STA", [901] = "+21 INT, +22 STA",
    [902] = "+22 INT, +22 STA", [903] = "+23 INT, +22 STA", [904] = "+22 INT, +23 STA",
    [905] = "+23 INT, +23 STA", [906] = "+24 INT, +23 STA", [907] = "+23 INT, +24 STA",
    [908] = "+24 INT, +24 STA", [909] = "+25 INT, +24 STA", [910] = "+24 INT, +25 STA",
    [911] = "+25 INT, +25 STA", [912] = "+26 INT, +25 STA", [913] = "+25 INT, +26 STA",
    [914] = "+26 INT, +26 STA", [915] = "+27 INT, +26 STA", [916] = "+26 INT, +27 STA",
    [917] = "+27 INT, +27 STA", [918] = "+28 INT, +27 STA", [919] = "+27 INT, +28 STA",
    [920] = "+28 INT, +28 STA", [921] = "+29 INT, +28 STA", [922] = "+28 INT, +29 STA",
    [923] = "+29 INT, +29 STA"
}

local suffixOfTheFalconLookup = {
    [227] = "+1 AGI, +1 INT", [229] = "+2 AGI, +1 INT", [231] = "+1 AGI, +2 INT",
    [232] = "+2 AGI, +2 INT", [233] = "+3 AGI, +2 INT", [234] = "+2 AGI, +3 INT",
    [235] = "+3 AGI, +3 INT", [236] = "+4 AGI, +3 INT", [237] = "+3 AGI, +4 INT",
    [238] = "+4 AGI, +4 INT",
    [247] = "+5 AGI, +4 INT", [248] = "+4 AGI, +5 INT", [249] = "+5 AGI, +5 INT",
    [250] = "+6 AGI, +5 INT", [251] = "+5 AGI, +6 INT", [252] = "+6 AGI, +6 INT",
    [253] = "+7 AGI, +6 INT", [254] = "+6 AGI, +7 INT", [255] = "+7 AGI, +7 INT",
    [435] = "+8 AGI, +7 INT", [436] = "+7 AGI, +8 INT", [437] = "+8 AGI, +8 INT",
    [438] = "+9 AGI, +8 INT", [439] = "+8 AGI, +9 INT", [440] = "+9 AGI, +9 INT",
    [441] = "+10 AGI, +9 INT", [442] = "+9 AGI, +10 INT", [443] = "+10 AGI, +10 INT",
    [444] = "+11 AGI, +10 INT", [445] = "+10 AGI, +11 INT", [446] = "+11 AGI, +11 INT",
    [447] = "+12 AGI, +11 INT", [448] = "+11 AGI, +12 INT", [449] = "+12 AGI, +12 INT",
    [450] = "+13 AGI, +12 INT", [451] = "+12 AGI, +13 INT", [452] = "+13 AGI, +13 INT",
    [453] = "+14 AGI, +13 INT", [454] = "+13 AGI, +14 INT", [455] = "+14 AGI, +14 INT",
    [456] = "+15 AGI, +14 INT", [457] = "+14 AGI, +15 INT", [458] = "+15 AGI, +15 INT",
    [459] = "+16 AGI, +15 INT", [460] = "+15 AGI, +16 INT", [461] = "+16 AGI, +16 INT",
    [462] = "+17 AGI, +16 INT", [463] = "+16 AGI, +17 INT", [464] = "+17 AGI, +17 INT",
    [465] = "+18 AGI, +17 INT", [466] = "+17 AGI, +18 INT", [467] = "+18 AGI, +18 INT",
    [468] = "+19 AGI, +18 INT", [469] = "+18 AGI, +19 INT", [470] = "+19 AGI, +19 INT",
    [471] = "+20 AGI, +19 INT", [472] = "+19 AGI, +20 INT", [473] = "+20 AGI, +20 INT",
    [474] = "+21 AGI, +20 INT", [475] = "+20 AGI, +21 INT", [476] = "+21 AGI, +21 INT",
    [477] = "+22 AGI, +21 INT", [478] = "+21 AGI, +22 INT", [479] = "+22 AGI, +22 INT",
    [480] = "+23 AGI, +22 INT", [481] = "+22 AGI, +23 INT", [482] = "+23 AGI, +23 INT",
    [483] = "+24 AGI, +23 INT", [484] = "+23 AGI, +24 INT", [485] = "+24 AGI, +24 INT",
    [486] = "+25 AGI, +24 INT", [487] = "+24 AGI, +25 INT", [488] = "+25 AGI, +25 INT",
    [489] = "+26 AGI, +25 INT", [490] = "+25 AGI, +26 INT", [491] = "+26 AGI, +26 INT",
    [492] = "+27 AGI, +26 INT", [493] = "+26 AGI, +27 INT", [494] = "+27 AGI, +27 INT",
    [495] = "+28 AGI, +27 INT", [496] = "+27 AGI, +28 INT", [497] = "+28 AGI, +28 INT",
    [498] = "+29 AGI, +28 INT", [499] = "+28 AGI, +29 INT", [500] = "+29 AGI, +29 INT"
}

local suffixOfTheGorillaLookup = {
    [924] = "+1 INT, +1 STR", [925] = "+2 INT, +1 STR", [926] = "+1 INT, +2 STR",
    [927] = "+2 INT, +2 STR", [928] = "+3 INT, +2 STR", [929] = "+2 INT, +3 STR",
    [930] = "+3 INT, +3 STR", [931] = "+4 INT, +3 STR", [932] = "+3 INT, +4 STR",
    [933] = "+4 INT, +4 STR", [934] = "+5 INT, +4 STR", [935] = "+4 INT, +5 STR",
    [936] = "+5 INT, +5 STR", [937] = "+6 INT, +5 STR", [938] = "+5 INT, +6 STR",
    [939] = "+6 INT, +6 STR", [940] = "+7 INT, +6 STR", [941] = "+6 INT, +7 STR",
    [942] = "+7 INT, +7 STR", [943] = "+8 INT, +7 STR", [944] = "+7 INT, +8 STR",
    [945] = "+8 INT, +8 STR", [946] = "+9 INT, +8 STR", [947] = "+8 INT, +9 STR",
    [948] = "+9 INT, +9 STR", [949] = "+10 INT, +9 STR", [950] = "+9 INT, +10 STR",
    [951] = "+10 INT, +10 STR", [952] = "+11 INT, +10 STR", [953] = "+10 INT, +11 STR",
    [954] = "+11 INT, +11 STR", [955] = "+12 INT, +11 STR", [956] = "+11 INT, +12 STR",
    [957] = "+12 INT, +12 STR", [958] = "+13 INT, +12 STR", [959] = "+12 INT, +13 STR",
    [960] = "+13 INT, +13 STR", [961] = "+14 INT, +13 STR", [962] = "+13 INT, +14 STR",
    [963] = "+14 INT, +14 STR", [964] = "+15 INT, +14 STR", [965] = "+14 INT, +15 STR",
    [966] = "+15 INT, +15 STR", [967] = "+16 INT, +15 STR", [968] = "+15 INT, +16 STR",
    [969] = "+16 INT, +16 STR", [970] = "+17 INT, +16 STR", [971] = "+16 INT, +17 STR",
    [972] = "+17 INT, +17 STR", [973] = "+18 INT, +17 STR", [974] = "+17 INT, +18 STR",
    [975] = "+18 INT, +18 STR", [976] = "+19 INT, +18 STR", [977] = "+18 INT, +19 STR",
    [978] = "+19 INT, +19 STR", [979] = "+20 INT, +19 STR", [980] = "+19 INT, +20 STR",
    [981] = "+20 INT, +20 STR", [982] = "+21 INT, +20 STR", [983] = "+20 INT, +21 STR",
    [984] = "+21 INT, +21 STR", [985] = "+22 INT, +21 STR", [986] = "+21 INT, +22 STR",
    [987] = "+22 INT, +22 STR", [988] = "+23 INT, +22 STR", [989] = "+22 INT, +23 STR",
    [990] = "+23 INT, +23 STR", [991] = "+24 INT, +23 STR", [992] = "+23 INT, +24 STR",
    [993] = "+24 INT, +24 STR", [994] = "+25 INT, +24 STR", [995] = "+24 INT, +25 STR",
    [996] = "+25 INT, +25 STR", [997] = "+26 INT, +25 STR", [998] = "+25 INT, +26 STR",
    [999] = "+26 INT, +26 STR", [1000] = "+27 INT, +26 STR", [1001] = "+26 INT, +27 STR",
    [1002] = "+27 INT, +27 STR", [1003] = "+28 INT, +27 STR", [1004] = "+27 INT, +28 STR",
    [1005] = "+28 INT, +28 STR", [1006] = "+29 INT, +28 STR", [1007] = "+28 INT, +29 STR",
    [1008] = "+29 INT, +29 STR"
}

local suffixOfTheMonkeyLookup = {
    [584] = "+1 AGI, +1 STA", [585] = "+2 AGI, +1 STA", [586] = "+1 AGI, +2 STA",
    [587] = "+2 AGI, +2 STA", [588] = "+3 AGI, +2 STA", [589] = "+2 AGI, +3 STA",
    [590] = "+3 AGI, +3 STA", [591] = "+4 AGI, +3 STA", [592] = "+3 AGI, +4 STA",
    [593] = "+4 AGI, +4 STA", [594] = "+5 AGI, +4 STA", [595] = "+4 AGI, +5 STA",
    [596] = "+5 AGI, +5 STA", [597] = "+6 AGI, +5 STA", [598] = "+5 AGI, +6 STA",
    [599] = "+6 AGI, +6 STA", [600] = "+7 AGI, +6 STA", [601] = "+6 AGI, +7 STA",
    [602] = "+7 AGI, +7 STA", [603] = "+8 AGI, +7 STA", [604] = "+7 AGI, +8 STA",
    [605] = "+8 AGI, +8 STA", [606] = "+9 AGI, +8 STA", [607] = "+8 AGI, +9 STA",
    [608] = "+9 AGI, +9 STA", [609] = "+10 AGI, +9 STA", [610] = "+9 AGI, +10 STA",
    [611] = "+10 AGI, +10 STA", [612] = "+11 AGI, +10 STA", [613] = "+10 AGI, +11 STA",
    [614] = "+11 AGI, +11 STA", [615] = "+12 AGI, +11 STA", [616] = "+11 AGI, +12 STA",
    [617] = "+12 AGI, +12 STA", [618] = "+13 AGI, +12 STA", [619] = "+12 AGI, +13 STA",
    [620] = "+13 AGI, +13 STA", [621] = "+14 AGI, +13 STA", [622] = "+13 AGI, +14 STA",
    [623] = "+14 AGI, +14 STA", [624] = "+15 AGI, +14 STA", [625] = "+14 AGI, +15 STA",
    [626] = "+15 AGI, +15 STA", [627] = "+16 AGI, +15 STA", [628] = "+15 AGI, +16 STA",
    [629] = "+16 AGI, +16 STA", [630] = "+17 AGI, +16 STA", [631] = "+16 AGI, +17 STA",
    [632] = "+17 AGI, +17 STA", [633] = "+18 AGI, +17 STA", [634] = "+17 AGI, +18 STA",
    [635] = "+18 AGI, +18 STA", [636] = "+19 AGI, +18 STA", [637] = "+18 AGI, +19 STA",
    [638] = "+19 AGI, +19 STA", [639] = "+20 AGI, +19 STA", [640] = "+19 AGI, +20 STA",
    [641] = "+20 AGI, +20 STA", [642] = "+21 AGI, +20 STA", [643] = "+20 AGI, +21 STA",
    [644] = "+21 AGI, +21 STA", [645] = "+22 AGI, +21 STA", [646] = "+21 AGI, +22 STA",
    [647] = "+22 AGI, +22 STA", [648] = "+23 AGI, +22 STA", [649] = "+22 AGI, +23 STA",
    [650] = "+23 AGI, +23 STA", [651] = "+24 AGI, +23 STA", [652] = "+23 AGI, +24 STA",
    [653] = "+24 AGI, +24 STA", [654] = "+25 AGI, +24 STA", [655] = "+24 AGI, +25 STA",
    [656] = "+25 AGI, +25 STA", [657] = "+26 AGI, +25 STA", [658] = "+25 AGI, +26 STA",
    [659] = "+26 AGI, +26 STA", [660] = "+27 AGI, +26 STA", [661] = "+26 AGI, +27 STA",
    [662] = "+27 AGI, +27 STA", [663] = "+28 AGI, +27 STA", [664] = "+27 AGI, +28 STA",
    [665] = "+28 AGI, +28 STA", [666] = "+29 AGI, +28 STA", [667] = "+28 AGI, +29 STA",
    [668] = "+29 AGI, +29 STA"
}

local suffixOfTheOwlLookup = {
    [754] = "+1 INT, +1 SPI", [755] = "+2 INT, +1 SPI", [756] = "+1 INT, +2 SPI",
    [757] = "+2 INT, +2 SPI", [758] = "+3 INT, +2 SPI", [759] = "+2 INT, +3 SPI",
    [760] = "+3 INT, +3 SPI", [761] = "+4 INT, +3 SPI", [762] = "+3 INT, +4 SPI",
    [763] = "+4 INT, +4 SPI", [764] = "+5 INT, +4 SPI", [765] = "+4 INT, +5 SPI",
    [766] = "+5 INT, +5 SPI", [767] = "+6 INT, +5 SPI", [768] = "+5 INT, +6 SPI",
    [769] = "+6 INT, +6 SPI", [770] = "+7 INT, +6 SPI", [771] = "+6 INT, +7 SPI",
    [772] = "+7 INT, +7 SPI", [773] = "+8 INT, +7 SPI", [774] = "+7 INT, +8 SPI",
    [775] = "+8 INT, +8 SPI", [776] = "+9 INT, +8 SPI", [777] = "+8 INT, +9 SPI",
    [778] = "+9 INT, +9 SPI", [779] = "+10 INT, +9 SPI", [780] = "+9 INT, +10 SPI",
    [781] = "+10 INT, +10 SPI", [782] = "+11 INT, +10 SPI", [783] = "+10 INT, +11 SPI",
    [784] = "+11 INT, +11 SPI", [785] = "+12 INT, +11 SPI", [786] = "+11 INT, +12 SPI",
    [787] = "+12 INT, +12 SPI", [788] = "+13 INT, +12 SPI", [789] = "+12 INT, +13 SPI",
    [790] = "+13 INT, +13 SPI", [791] = "+14 INT, +13 SPI", [792] = "+13 INT, +14 SPI",
    [793] = "+14 INT, +14 SPI", [794] = "+15 INT, +14 SPI", [795] = "+14 INT, +15 SPI",
    [796] = "+15 INT, +15 SPI", [797] = "+16 INT, +15 SPI", [798] = "+15 INT, +16 SPI",
    [799] = "+16 INT, +16 SPI", [800] = "+17 INT, +16 SPI", [801] = "+16 INT, +17 SPI",
    [802] = "+17 INT, +17 SPI", [803] = "+18 INT, +17 SPI", [804] = "+17 INT, +18 SPI",
    [805] = "+18 INT, +18 SPI", [806] = "+19 INT, +18 SPI", [807] = "+18 INT, +19 SPI",
    [808] = "+19 INT, +19 SPI", [809] = "+20 INT, +19 SPI", [810] = "+19 INT, +20 SPI",
    [811] = "+20 INT, +20 SPI", [812] = "+21 INT, +20 SPI", [813] = "+20 INT, +21 SPI",
    [814] = "+21 INT, +21 SPI", [815] = "+22 INT, +21 SPI", [816] = "+21 INT, +22 SPI",
    [817] = "+22 INT, +22 SPI", [818] = "+23 INT, +22 SPI", [819] = "+22 INT, +23 SPI",
    [820] = "+23 INT, +23 SPI", [821] = "+24 INT, +23 SPI", [822] = "+23 INT, +24 SPI",
    [823] = "+24 INT, +24 SPI", [824] = "+25 INT, +24 SPI", [825] = "+24 INT, +25 SPI",
    [826] = "+25 INT, +25 SPI", [827] = "+26 INT, +25 SPI", [828] = "+25 INT, +26 SPI",
    [829] = "+26 INT, +26 SPI", [830] = "+27 INT, +26 SPI", [831] = "+26 INT, +27 SPI",
    [832] = "+27 INT, +27 SPI", [833] = "+28 INT, +27 SPI", [834] = "+27 INT, +28 SPI",
    [835] = "+28 INT, +28 SPI", [836] = "+29 INT, +28 SPI", [837] = "+28 INT, +29 SPI",
    [838] = "+29 INT, +29 SPI"
}

local suffixOfTheTigerLookup = {
    [669] = "+1 AGI, +1 STR", [670] = "+2 AGI, +1 STR", [671] = "+1 AGI, +2 STR",
    [672] = "+2 AGI, +2 STR", [673] = "+3 AGI, +2 STR", [674] = "+2 AGI, +3 STR",
    [675] = "+3 AGI, +3 STR", [676] = "+4 AGI, +3 STR", [677] = "+3 AGI, +4 STR",
    [678] = "+4 AGI, +4 STR", [679] = "+5 AGI, +4 STR", [680] = "+4 AGI, +5 STR",
    [681] = "+5 AGI, +5 STR", [682] = "+6 AGI, +5 STR", [683] = "+5 AGI, +6 STR",
    [684] = "+6 AGI, +6 STR", [685] = "+7 AGI, +6 STR", [686] = "+6 AGI, +7 STR",
    [687] = "+7 AGI, +7 STR", [688] = "+8 AGI, +7 STR", [689] = "+7 AGI, +8 STR",
    [690] = "+8 AGI, +8 STR", [691] = "+9 AGI, +8 STR", [692] = "+8 AGI, +9 STR",
    [693] = "+9 AGI, +9 STR", [694] = "+10 AGI, +9 STR", [695] = "+9 AGI, +10 STR",
    [696] = "+10 AGI, +10 STR", [697] = "+11 AGI, +10 STR", [698] = "+10 AGI, +11 STR",
    [699] = "+11 AGI, +11 STR", [700] = "+12 AGI, +11 STR", [701] = "+11 AGI, +12 STR",
    [702] = "+12 AGI, +12 STR", [703] = "+13 AGI, +12 STR", [704] = "+12 AGI, +13 STR",
    [705] = "+13 AGI, +13 STR", [706] = "+14 AGI, +13 STR", [707] = "+13 AGI, +14 STR",
    [708] = "+14 AGI, +14 STR", [709] = "+15 AGI, +14 STR", [710] = "+14 AGI, +15 STR",
    [711] = "+15 AGI, +15 STR", [712] = "+16 AGI, +15 STR", [713] = "+15 AGI, +16 STR",
    [714] = "+16 AGI, +16 STR", [715] = "+17 AGI, +16 STR", [716] = "+16 AGI, +17 STR",
    [717] = "+17 AGI, +17 STR", [718] = "+18 AGI, +17 STR", [719] = "+17 AGI, +18 STR",
    [720] = "+18 AGI, +18 STR", [721] = "+19 AGI, +18 STR", [722] = "+18 AGI, +19 STR",
    [723] = "+19 AGI, +19 STR", [724] = "+20 AGI, +19 STR", [725] = "+19 AGI, +20 STR",
    [726] = "+20 AGI, +20 STR", [727] = "+21 AGI, +20 STR", [728] = "+20 AGI, +21 STR",
    [729] = "+21 AGI, +21 STR", [730] = "+22 AGI, +21 STR", [731] = "+21 AGI, +22 STR",
    [732] = "+22 AGI, +22 STR", [733] = "+23 AGI, +22 STR", [734] = "+22 AGI, +23 STR",
    [735] = "+23 AGI, +23 STR", [736] = "+24 AGI, +23 STR", [737] = "+23 AGI, +24 STR",
    [738] = "+24 AGI, +24 STR", [739] = "+25 AGI, +24 STR", [740] = "+25 AGI, +25 STR",
    [741] = "+25 AGI, +25 STR", [742] = "+26 AGI, +25 STR", [743] = "+25 AGI, +26 STR",
    [744] = "+26 AGI, +26 STR", [745] = "+27 AGI, +26 STR", [746] = "+26 AGI, +27 STR",
    [747] = "+27 AGI, +27 STR", [748] = "+28 AGI, +27 STR", [749] = "+27 AGI, +28 STR",
    [750] = "+28 AGI, +28 STR", [751] = "+29 AGI, +28 STR", [752] = "+28 AGI, +29 STR",
    [753] = "+29 AGI, +29 STR"
}

local suffixOfTheWhaleLookup = {
    [1009] = "+1 SPI, +1 STA", [1010] = "+2 SPI, +1 STA", [1011] = "+1 SPI, +2 STA",
    [1012] = "+2 SPI, +2 STA", [1013] = "+3 SPI, +2 STA", [1014] = "+2 SPI, +3 STA",
    [1015] = "+3 SPI, +3 STA", [1016] = "+4 SPI, +3 STA", [1017] = "+3 SPI, +4 STA",
    [1018] = "+4 SPI, +4 STA", [1019] = "+5 SPI, +4 STA", [1020] = "+4 SPI, +5 STA",
    [1021] = "+5 SPI, +5 STA", [1022] = "+6 SPI, +5 STA", [1023] = "+5 SPI, +6 STA",
    [1024] = "+6 SPI, +6 STA", [1025] = "+7 SPI, +6 STA", [1026] = "+6 SPI, +7 STA",
    [1027] = "+7 SPI, +7 STA", [1028] = "+8 SPI, +7 STA", [1029] = "+7 SPI, +8 STA",
    [1030] = "+8 SPI, +8 STA", [1031] = "+9 SPI, +8 STA", [1032] = "+8 SPI, +9 STA",
    [1033] = "+9 SPI, +9 STA", [1034] = "+10 SPI, +9 STA", [1035] = "+9 SPI, +10 STA",
    [1036] = "+10 SPI, +10 STA", [1037] = "+11 SPI, +10 STA", [1038] = "+10 SPI, +11 STA",
    [1039] = "+11 SPI, +11 STA", [1040] = "+12 SPI, +11 STA", [1041] = "+11 SPI, +12 STA",
    [1042] = "+12 SPI, +12 STA", [1043] = "+13 SPI, +12 STA", [1044] = "+12 SPI, +13 STA",
    [1045] = "+13 SPI, +13 STA", [1046] = "+14 SPI, +13 STA", [1047] = "+13 SPI, +14 STA",
    [1048] = "+14 SPI, +14 STA", [1049] = "+15 SPI, +14 STA", [1050] = "+14 SPI, +15 STA",
    [1051] = "+15 SPI, +15 STA", [1052] = "+16 SPI, +15 STA", [1053] = "+15 SPI, +16 STA",
    [1054] = "+16 SPI, +16 STA", [1055] = "+17 SPI, +16 STA", [1056] = "+16 SPI, +17 STA",
    [1057] = "+17 SPI, +17 STA", [1058] = "+18 SPI, +17 STA", [1059] = "+17 SPI, +18 STA",
    [1060] = "+18 SPI, +18 STA", [1061] = "+19 SPI, +18 STA", [1062] = "+18 SPI, +19 STA",
    [1063] = "+19 SPI, +19 STA", [1064] = "+20 SPI, +19 STA", [1065] = "+19 SPI, +20 STA",
    [1066] = "+20 SPI, +20 STA", [1067] = "+21 SPI, +20 STA", [1068] = "+20 SPI, +21 STA",
    [1069] = "+21 SPI, +21 STA", [1070] = "+22 SPI, +21 STA", [1071] = "+21 SPI, +22 STA",
    [1072] = "+22 SPI, +22 STA", [1073] = "+23 SPI, +22 STA", [1074] = "+22 SPI, +23 STA",
    [1075] = "+23 SPI, +23 STA", [1076] = "+24 SPI, +23 STA", [1077] = "+23 SPI, +24 STA",
    [1078] = "+24 SPI, +24 STA", [1079] = "+25 SPI, +24 STA", [1080] = "+24 SPI, +25 STA",
    [1081] = "+25 SPI, +25 STA", [1082] = "+26 SPI, +25 STA", [1083] = "+25 SPI, +26 STA",
    [1084] = "+26 SPI, +26 STA", [1085] = "+27 SPI, +26 STA", [1086] = "+26 SPI, +27 STA",
    [1087] = "+27 SPI, +27 STA", [1088] = "+28 SPI, +27 STA", [1089] = "+27 SPI, +28 STA",
    [1090] = "+28 SPI, +28 STA", [1091] = "+29 SPI, +28 STA", [1092] = "+28 SPI, +29 STA",
    [1093] = "+29 SPI, +29 STA"
}

local suffixOfTheWolfLookup = {
    [228] = "+1 AGI, +1 SPI", [256] = "+2 AGI, +1 SPI",
    [501] = "+1 AGI, +2 SPI", [502] = "+2 AGI, +2 SPI", [503] = "+3 AGI, +2 SPI",
    [504] = "+2 AGI, +3 SPI", [505] = "+3 AGI, +3 SPI", [506] = "+4 AGI, +3 SPI",
    [507] = "+3 AGI, +4 SPI", [508] = "+4 AGI, +4 SPI", [509] = "+5 AGI, +4 SPI",
    [510] = "+4 AGI, +5 SPI", [511] = "+5 AGI, +5 SPI", [512] = "+6 AGI, +5 SPI",
    [513] = "+5 AGI, +6 SPI", [514] = "+6 AGI, +6 SPI", [515] = "+7 AGI, +6 SPI",
    [516] = "+6 AGI, +7 SPI", [517] = "+7 AGI, +7 SPI", [518] = "+8 AGI, +7 SPI",
    [519] = "+7 AGI, +8 SPI", [520] = "+8 AGI, +8 SPI", [521] = "+9 AGI, +8 SPI",
    [522] = "+8 AGI, +9 SPI", [523] = "+9 AGI, +9 SPI", [524] = "+10 AGI, +9 SPI",
    [525] = "+9 AGI, +10 SPI", [526] = "+10 AGI, +10 SPI", [527] = "+11 AGI, +10 SPI",
    [528] = "+10 AGI, +11 SPI", [529] = "+11 AGI, +11 SPI", [530] = "+12 AGI, +11 SPI",
    [531] = "+11 AGI, +12 SPI", [532] = "+12 AGI, +12 SPI", [533] = "+13 AGI, +12 SPI",
    [534] = "+12 AGI, +13 SPI", [535] = "+13 AGI, +13 SPI", [536] = "+14 AGI, +13 SPI",
    [537] = "+13 AGI, +14 SPI", [538] = "+14 AGI, +14 SPI", [539] = "+15 AGI, +14 SPI",
    [540] = "+14 AGI, +15 SPI", [541] = "+15 AGI, +15 SPI", [542] = "+16 AGI, +15 SPI",
    [543] = "+15 AGI, +16 SPI", [544] = "+16 AGI, +16 SPI", [545] = "+17 AGI, +16 SPI",
    [546] = "+16 AGI, +17 SPI", [547] = "+17 AGI, +17 SPI", [548] = "+18 AGI, +17 SPI",
    [549] = "+17 AGI, +18 SPI", [550] = "+18 AGI, +18 SPI", [551] = "+19 AGI, +18 SPI",
    [552] = "+18 AGI, +19 SPI", [553] = "+19 AGI, +19 SPI", [554] = "+20 AGI, +19 SPI",
    [555] = "+19 AGI, +20 SPI", [556] = "+20 AGI, +20 SPI", [557] = "+21 AGI, +20 SPI",
    [558] = "+20 AGI, +21 SPI", [559] = "+21 AGI, +21 SPI", [560] = "+22 AGI, +21 SPI",
    [561] = "+21 AGI, +22 SPI", [562] = "+22 AGI, +22 SPI", [563] = "+23 AGI, +22 SPI",
    [564] = "+22 AGI, +23 SPI", [565] = "+23 AGI, +23 SPI", [566] = "+24 AGI, +23 SPI",
    [567] = "+23 AGI, +24 SPI", [568] = "+24 AGI, +24 SPI", [569] = "+25 AGI, +24 SPI",
    [570] = "+24 AGI, +25 SPI", [571] = "+25 AGI, +25 SPI", [572] = "+26 AGI, +25 SPI",
    [573] = "+25 AGI, +26 SPI", [574] = "+26 AGI, +26 SPI", [575] = "+27 AGI, +26 SPI",
    [576] = "+26 AGI, +27 SPI", [577] = "+27 AGI, +27 SPI", [578] = "+28 AGI, +27 SPI",
    [579] = "+27 AGI, +28 SPI", [580] = "+28 AGI, +28 SPI", [581] = "+29 AGI, +28 SPI",
    [582] = "+28 AGI, +29 SPI", [583] = "+29 AGI, +29 SPI"
}

local suffixOfAgilityLookup = {
    [14] = "+1 AGI", [17] = "+2 AGI", [18] = "+3 AGI",
    [93] = "+4 AGI", [111] = "+5 AGI", [132] = "+6 AGI",
    [151] = "+7 AGI", [167] = "+8 AGI", [168] = "+9 AGI",
    [171] = "+10 AGI", [172] = "+11 AGI", [173] = "+12 AGI",
    [211] = "+13 AGI", [212] = "+14 AGI", [267] = "+15 AGI",
    [358] = "+16 AGI", [359] = "+17 AGI", [360] = "+18 AGI",
    [361] = "+19 AGI", [362] = "+20 AGI", [363] = "+21 AGI",
    [364] = "+22 AGI", [365] = "+23 AGI", [366] = "+24 AGI",
    [367] = "+25 AGI", [368] = "+26 AGI", [369] = "+27 AGI",
    [370] = "+28 AGI", [371] = "+29 AGI", [372] = "+30 AGI",
    [373] = "+31 AGI", [374] = "+32 AGI", [375] = "+33 AGI",
    [376] = "+34 AGI", [377] = "+35 AGI", [378] = "+36 AGI",
    [379] = "+37 AGI", [380] = "+38 AGI", [381] = "+39 AGI",
    [382] = "+40 AGI", [1279] = "+41 AGI", [1280] = "+42 AGI",
    [1281] = "+43 AGI", [1282] = "+44 AGI", [1283] = "+45 AGI",
    [1284] = "+46 AGI"
}

local suffixOfDefenseLookup = {
    [48] = "+1 DEF", [62] = "+1 DEF", [74] = "+2 DEF",
    [89] = "+3 DEF", [108] = "+3 DEF", [128] = "+4 DEF",
    [147] = "+5 DEF", [1607] = "+8 DEF", [1608] = "+5 DEF",
    [1609] = "+6 DEF", [1610] = "+7 DEF", [1611] = "+7 DEF",
    [1612] = "+9 DEF", [1613] = "+9 DEF", [1614] = "+10 DEF",
    [1615] = "+11 DEF", [1616] = "+13 DEF", [1617] = "+15 DEF",
    [1618] = "+17 DEF", [1619] = "+21 DEF", [1620] = "+11 DEF",
    [1621] = "+12 DEF", [1622] = "+13 DEF", [1623] = "+14 DEF",
    [1624] = "+15 DEF", [1625] = "+16 DEF", [1626] = "+17 DEF",
    [1627] = "+18 DEF", [1628] = "+19 DEF", [1629] = "+19 DEF",
    [1630] = "+20 DEF", [1631] = "+21 DEF", [1632] = "+22 DEF",
    [1633] = "+23 DEF", [1634] = "+23 DEF", [1635] = "+24 DEF",
    [1636] = "+25 DEF", [1637] = "+25 DEF"
}

local suffixOfIntellectLookup = {
    [5] = "+1 INT", [25] = "+2 INT", [26] = "+3 INT",
    [94] = "+4 INT", [112] = "+5 INT", [133] = "+6 INT",
    [152] = "+7 INT", [174] = "+8 INT", [175] = "+9 INT",
    [176] = "+10 INT", [177] = "+11 INT", [178] = "+12 INT",
    [213] = "+13 INT", [214] = "+14 INT", [383] = "+15 INT",
    [384] = "+16 INT", [385] = "+17 INT", [386] = "+18 INT",
    [387] = "+19 INT", [388] = "+20 INT", [389] = "+21 INT",
    [390] = "+22 INT", [391] = "+23 INT", [392] = "+24 INT",
    [393] = "+25 INT", [394] = "+26 INT", [395] = "+27 INT",
    [396] = "+28 INT", [397] = "+29 INT", [398] = "+30 INT",
    [399] = "+31 INT", [400] = "+32 INT", [401] = "+33 INT",
    [402] = "+34 INT", [403] = "+35 INT", [404] = "+36 INT",
    [405] = "+37 INT", [406] = "+38 INT", [407] = "+39 INT",
    [408] = "+40 INT", [1285] = "+41 INT", [1286] = "+42 INT",
    [1287] = "+43 INT", [1288] = "+44 INT", [1289] = "+45 INT",
    [1290] = "+46 INT"
}

local suffixOfSpiritLookup = {
    [16] = "+1 SPI", [27] = "+2 SPI", [28] = "+3 SPI",
    [95] = "+4 SPI", [113] = "+5 SPI", [134] = "+6 SPI",
    [153] = "+7 SPI", [179] = "+8 SPI", [180] = "+9 SPI",
    [181] = "+10 SPI", [182] = "+11 SPI", [183] = "+12 SPI",
    [215] = "+13 SPI", [216] = "+14 SPI", [409] = "+15 SPI",
    [410] = "+16 SPI", [411] = "+17 SPI", [412] = "+18 SPI",
    [413] = "+19 SPI", [414] = "+20 SPI", [415] = "+21 SPI",
    [416] = "+22 SPI", [417] = "+23 SPI", [418] = "+24 SPI",
    [419] = "+25 SPI", [420] = "+26 SPI", [421] = "+27 SPI",
    [422] = "+28 SPI", [423] = "+29 SPI", [424] = "+30 SPI",
    [425] = "+31 SPI", [426] = "+32 SPI", [427] = "+33 SPI",
    [428] = "+34 SPI", [429] = "+36 SPI", [430] = "+37 SPI",
    [431] = "+38 SPI", [432] = "+39 SPI", [433] = "+40 SPI",
    [434] = "+35 SPI", [1291] = "+41 SPI", [1292] = "+42 SPI",
    [1293] = "+43 SPI", [1294] = "+44 SPI", [1295] = "+45 SPI",
    [1296] = "+46 SPI"
}

local suffixOfStaminaLookup = {
    [15] = "+1 STA", [19] = "+2 STA", [22] = "+3 STA",
    [96] = "+4 STA", [114] = "+5 STA", [135] = "+6 STA",
    [154] = "+7 STA", [184] = "+8 STA", [185] = "+9 STA",
    [186] = "+10 STA", [187] = "+11 STA", [188] = "+12 STA",
    [217] = "+13 STA", [218] = "+14 STA", [287] = "+15 STA",
    [333] = "+16 STA", [334] = "+17 STA", [335] = "+18 STA",
    [336] = "+19 STA", [337] = "+20 STA", [338] = "+21 STA",
    [339] = "+22 STA", [340] = "+23 STA", [341] = "+24 STA",
    [342] = "+25 STA", [343] = "+26 STA", [344] = "+27 STA",
    [345] = "+28 STA", [346] = "+29 STA", [347] = "+30 STA",
    [348] = "+31 STA", [349] = "+32 STA", [350] = "+33 STA",
    [351] = "+34 STA", [352] = "+35 STA", [353] = "+36 STA",
    [354] = "+37 STA", [355] = "+38 STA", [356] = "+39 STA",
    [357] = "+40 STA", [1267] = "+41 STA", [1268] = "+42 STA",
    [1269] = "+43 STA", [1270] = "+44 STA", [1271] = "+45 STA",
    [1272] = "+46 STA"
}

local suffixOfStrengthLookup = {
    [6] = "+1 STR", [23] = "+2 STR", [24] = "+3 STR",
    [97] = "+4 STR", [115] = "+5 STR", [136] = "+6 STR",
    [155] = "+7 STR", [189] = "+8 STR", [190] = "+9 STR",
    [191] = "+10 STR", [192] = "+11 STR", [193] = "+12 STR",
    [219] = "+13 STR", [220] = "+14 STR", [307] = "+15 STR",
    [308] = "+16 STR", [309] = "+17 STR", [310] = "+18 STR",
    [311] = "+19 STR", [312] = "+20 STR", [313] = "+21 STR",
    [314] = "+22 STR", [315] = "+23 STR", [316] = "+24 STR",
    [317] = "+25 STR", [318] = "+26 STR", [319] = "+27 STR",
    [320] = "+28 STR", [321] = "+29 STR", [322] = "+30 STR",
    [323] = "+31 STR", [324] = "+32 STR", [325] = "+33 STR",
    [326] = "+34 STR", [327] = "+35 STR", [328] = "+36 STR",
    [329] = "+37 STR", [330] = "+38 STR", [331] = "+39 STR",
    [332] = "+40 STR", [1273] = "+41 STR", [1274] = "+42 STR",
    [1275] = "+43 STR", [1276] = "+44 STR", [1277] = "+45 STR",
    [1278] = "+46 STR"
}

local suffixOfArcaneResistanceLookup = {
    [1307] = "+1 Arcane Resistance", [1308] = "+2 Arcane Resistance", [1309] = "+3 Arcane Resistance",
    [1310] = "+4 Arcane Resistance", [1311] = "+5 Arcane Resistance", [1312] = "+6 Arcane Resistance",
    [1313] = "+7 Arcane Resistance", [1314] = "+8 Arcane Resistance", [1315] = "+9 Arcane Resistance",
    [1316] = "+10 Arcane Resistance", [1317] = "+11 Arcane Resistance", [1318] = "+12 Arcane Resistance",
    [1319] = "+13 Arcane Resistance", [1320] = "+14 Arcane Resistance", [1321] = "+15 Arcane Resistance",
    [1322] = "+16 Arcane Resistance", [1323] = "+17 Arcane Resistance", [1324] = "+18 Arcane Resistance",
    [1325] = "+19 Arcane Resistance", [1326] = "+20 Arcane Resistance", [1327] = "+21 Arcane Resistance",
    [1328] = "+22 Arcane Resistance", [1329] = "+23 Arcane Resistance", [1330] = "+24 Arcane Resistance",
    [1331] = "+25 Arcane Resistance", [1332] = "+26 Arcane Resistance", [1333] = "+27 Arcane Resistance",
    [1334] = "+28 Arcane Resistance", [1335] = "+29 Arcane Resistance", [1336] = "+30 Arcane Resistance",
    [1337] = "+31 Arcane Resistance", [1338] = "+32 Arcane Resistance", [1339] = "+33 Arcane Resistance",
    [1340] = "+34 Arcane Resistance", [1341] = "+35 Arcane Resistance", [1342] = "+36 Arcane Resistance",
    [1343] = "+37 Arcane Resistance", [1344] = "+38 Arcane Resistance", [1345] = "+39 Arcane Resistance",
    [1346] = "+40 Arcane Resistance", [1347] = "+41 Arcane Resistance", [1348] = "+42 Arcane Resistance",
    [1349] = "+43 Arcane Resistance", [1350] = "+44 Arcane Resistance", [1351] = "+45 Arcane Resistance",
    [1352] = "+46 Arcane Resistance"
}

local suffixOfFireResistanceLookup = {
    [1399] = "+1 Fire Resistance", [1400] = "+2 Fire Resistance", [1401] = "+3 Fire Resistance",
    [1402] = "+4 Fire Resistance", [1403] = "+5 Fire Resistance", [1404] = "+6 Fire Resistance",
    [1405] = "+7 Fire Resistance", [1406] = "+8 Fire Resistance", [1407] = "+9 Fire Resistance",
    [1408] = "+10 Fire Resistance", [1409] = "+11 Fire Resistance", [1410] = "+12 Fire Resistance",
    [1411] = "+13 Fire Resistance", [1412] = "+14 Fire Resistance", [1413] = "+15 Fire Resistance",
    [1414] = "+16 Fire Resistance", [1415] = "+17 Fire Resistance", [1416] = "+18 Fire Resistance",
    [1417] = "+19 Fire Resistance", [1418] = "+20 Fire Resistance", [1419] = "+21 Fire Resistance",
    [1420] = "+22 Fire Resistance", [1421] = "+23 Fire Resistance", [1422] = "+24 Fire Resistance",
    [1423] = "+25 Fire Resistance", [1424] = "+26 Fire Resistance", [1425] = "+27 Fire Resistance",
    [1426] = "+28 Fire Resistance", [1427] = "+29 Fire Resistance", [1428] = "+30 Fire Resistance",
    [1429] = "+31 Fire Resistance", [1430] = "+32 Fire Resistance", [1431] = "+33 Fire Resistance",
    [1432] = "+34 Fire Resistance", [1433] = "+35 Fire Resistance", [1434] = "+36 Fire Resistance",
    [1435] = "+37 Fire Resistance", [1436] = "+38 Fire Resistance", [1437] = "+39 Fire Resistance",
    [1438] = "+40 Fire Resistance", [1439] = "+41 Fire Resistance", [1440] = "+42 Fire Resistance",
    [1441] = "+43 Fire Resistance", [1442] = "+44 Fire Resistance", [1443] = "+45 Fire Resistance",
    [1444] = "+46 Fire Resistance"
}

local suffixOfFrostResistanceLookup = {
    [1353] = "+1 Frost Resistance", [1354] = "+2 Frost Resistance", [1355] = "+3 Frost Resistance",
    [1356] = "+4 Frost Resistance", [1357] = "+5 Frost Resistance", [1358] = "+6 Frost Resistance",
    [1359] = "+7 Frost Resistance", [1360] = "+8 Frost Resistance", [1361] = "+9 Frost Resistance",
    [1362] = "+10 Frost Resistance", [1363] = "+11 Frost Resistance", [1364] = "+12 Frost Resistance",
    [1365] = "+13 Frost Resistance", [1366] = "+14 Frost Resistance", [1367] = "+15 Frost Resistance",
    [1368] = "+16 Frost Resistance", [1369] = "+17 Frost Resistance", [1370] = "+18 Frost Resistance",
    [1371] = "+19 Frost Resistance", [1372] = "+20 Frost Resistance", [1373] = "+21 Frost Resistance",
    [1374] = "+22 Frost Resistance", [1375] = "+23 Frost Resistance", [1376] = "+24 Frost Resistance",
    [1377] = "+25 Frost Resistance", [1378] = "+26 Frost Resistance", [1379] = "+27 Frost Resistance",
    [1380] = "+28 Frost Resistance", [1381] = "+29 Frost Resistance", [1382] = "+30 Frost Resistance",
    [1383] = "+31 Frost Resistance", [1384] = "+32 Frost Resistance", [1385] = "+33 Frost Resistance",
    [1386] = "+34 Frost Resistance", [1387] = "+35 Frost Resistance", [1388] = "+36 Frost Resistance",
    [1389] = "+37 Frost Resistance", [1390] = "+38 Frost Resistance", [1391] = "+39 Frost Resistance",
    [1392] = "+40 Frost Resistance", [1393] = "+41 Frost Resistance", [1394] = "+42 Frost Resistance",
    [1395] = "+43 Frost Resistance", [1396] = "+44 Frost Resistance", [1397] = "+45 Frost Resistance",
    [1398] = "+46 Frost Resistance"
}

local suffixOfNatureResistanceLookup = {
    [1491] = "+1 Nature Resistance", [1492] = "+2 Nature Resistance", [1493] = "+3 Nature Resistance",
    [1494] = "+4 Nature Resistance", [1495] = "+5 Nature Resistance", [1496] = "+6 Nature Resistance",
    [1497] = "+7 Nature Resistance", [1498] = "+8 Nature Resistance", [1499] = "+9 Nature Resistance",
    [1500] = "+10 Nature Resistance", [1501] = "+11 Nature Resistance", [1502] = "+12 Nature Resistance",
    [1503] = "+13 Nature Resistance", [1504] = "+14 Nature Resistance", [1505] = "+15 Nature Resistance",
    [1506] = "+16 Nature Resistance", [1507] = "+17 Nature Resistance", [1508] = "+18 Nature Resistance",
    [1509] = "+19 Nature Resistance", [1510] = "+20 Nature Resistance", [1511] = "+21 Nature Resistance",
    [1512] = "+22 Nature Resistance", [1513] = "+23 Nature Resistance", [1514] = "+24 Nature Resistance",
    [1515] = "+25 Nature Resistance", [1516] = "+26 Nature Resistance", [1517] = "+27 Nature Resistance",
    [1518] = "+28 Nature Resistance", [1519] = "+29 Nature Resistance", [1520] = "+30 Nature Resistance",
    [1521] = "+31 Nature Resistance", [1522] = "+32 Nature Resistance", [1523] = "+33 Nature Resistance",
    [1524] = "+34 Nature Resistance", [1525] = "+35 Nature Resistance", [1526] = "+36 Nature Resistance",
    [1527] = "+37 Nature Resistance", [1528] = "+38 Nature Resistance", [1529] = "+39 Nature Resistance",
    [1530] = "+40 Nature Resistance", [1531] = "+41 Nature Resistance", [1532] = "+42 Nature Resistance",
    [1533] = "+43 Nature Resistance", [1534] = "+44 Nature Resistance", [1535] = "+45 Nature Resistance",
    [1536] = "+46 Nature Resistance"
}

local suffixOfShadowResistanceLookup = {
    [1445] = "+1 Shadow Resistance", [1446] = "+2 Shadow Resistance", [1447] = "+3 Shadow Resistance",
    [1448] = "+4 Shadow Resistance", [1449] = "+5 Shadow Resistance", [1450] = "+6 Shadow Resistance",
    [1451] = "+7 Shadow Resistance", [1452] = "+8 Shadow Resistance", [1453] = "+9 Shadow Resistance",
    [1454] = "+10 Shadow Resistance", [1455] = "+11 Shadow Resistance", [1456] = "+12 Shadow Resistance",
    [1457] = "+13 Shadow Resistance", [1458] = "+14 Shadow Resistance", [1459] = "+15 Shadow Resistance",
    [1460] = "+16 Shadow Resistance", [1461] = "+17 Shadow Resistance", [1462] = "+18 Shadow Resistance",
    [1463] = "+19 Shadow Resistance", [1464] = "+20 Shadow Resistance", [1465] = "+21 Shadow Resistance",
    [1466] = "+22 Shadow Resistance", [1467] = "+23 Shadow Resistance", [1468] = "+24 Shadow Resistance",
    [1469] = "+25 Shadow Resistance", [1470] = "+26 Shadow Resistance", [1471] = "+27 Shadow Resistance",
    [1472] = "+28 Shadow Resistance", [1473] = "+29 Shadow Resistance", [1474] = "+30 Shadow Resistance",
    [1475] = "+31 Shadow Resistance", [1476] = "+32 Shadow Resistance", [1477] = "+33 Shadow Resistance",
    [1478] = "+34 Shadow Resistance", [1479] = "+35 Shadow Resistance", [1480] = "+36 Shadow Resistance",
    [1481] = "+37 Shadow Resistance", [1482] = "+38 Shadow Resistance", [1483] = "+39 Shadow Resistance",
    [1484] = "+40 Shadow Resistance", [1485] = "+41 Shadow Resistance", [1486] = "+42 Shadow Resistance",
    [1487] = "+43 Shadow Resistance", [1488] = "+44 Shadow Resistance", [1489] = "+45 Shadow Resistance",
    [1490] = "+46 Shadow Resistance"
}

local suffixOfArcaneWrathLookup = {
    [1799] = "+1 Arcane DMG", [1800] = "+3 Arcane DMG", [1801] = "+4 Arcane DMG",
    [1802] = "+6 Arcane DMG", [1803] = "+7 Arcane DMG", [1804] = "+9 Arcane DMG",
    [1805] = "+10 Arcane DMG", [1806] = "+11 Arcane DMG", [1807] = "+13 Arcane DMG",
    [1808] = "+14 Arcane DMG", [1809] = "+16 Arcane DMG", [1810] = "+17 Arcane DMG",
    [1811] = "+19 Arcane DMG", [1812] = "+20 Arcane DMG", [1813] = "+21 Arcane DMG",
    [1814] = "+23 Arcane DMG", [1815] = "+24 Arcane DMG", [1816] = "+26 Arcane DMG",
    [1817] = "+27 Arcane DMG", [1818] = "+29 Arcane DMG", [1819] = "+30 Arcane DMG",
    [1820] = "+31 Arcane DMG", [1821] = "+33 Arcane DMG", [1822] = "+34 Arcane DMG",
    [1823] = "+36 Arcane DMG", [1824] = "+37 Arcane DMG", [1825] = "+39 Arcane DMG",
    [1826] = "+40 Arcane DMG", [1827] = "+41 Arcane DMG", [1828] = "+43 Arcane DMG",
    [1829] = "+44 Arcane DMG", [1830] = "+46 Arcane DMG", [1831] = "+47 Arcane DMG",
    [1832] = "+49 Arcane DMG", [1833] = "+50 Arcane DMG", [1834] = "+51 Arcane DMG",
    [1835] = "+53 Arcane DMG", [1836] = "+54 Arcane DMG"
}

local suffixOfFieryWrathLookup = {
    [1875] = "+1 Fire DMG", [1876] = "+3 Fire DMG", [1877] = "+4 Fire DMG",
    [1878] = "+6 Fire DMG", [1879] = "+7 Fire DMG", [1880] = "+9 Fire DMG",
    [1881] = "+10 Fire DMG", [1882] = "+11 Fire DMG", [1883] = "+13 Fire DMG",
    [1884] = "+14 Fire DMG", [1885] = "+16 Fire DMG", [1886] = "+17 Fire DMG",
    [1887] = "+19 Fire DMG", [1888] = "+20 Fire DMG", [1889] = "+21 Fire DMG",
    [1890] = "+23 Fire DMG", [1891] = "+24 Fire DMG", [1892] = "+26 Fire DMG",
    [1893] = "+27 Fire DMG", [1894] = "+29 Fire DMG", [1895] = "+30 Fire DMG",
    [1896] = "+31 Fire DMG", [1897] = "+33 Fire DMG", [1898] = "+34 Fire DMG",
    [1899] = "+36 Fire DMG", [1900] = "+37 Fire DMG", [1901] = "+39 Fire DMG",
    [1902] = "+40 Fire DMG", [1903] = "+41 Fire DMG", [1904] = "+43 Fire DMG",
    [1905] = "+44 Fire DMG", [1906] = "+46 Fire DMG", [1907] = "+47 Fire DMG",
    [1908] = "+49 Fire DMG", [1909] = "+50 Fire DMG", [1910] = "+51 Fire DMG",
    [1911] = "+53 Fire DMG", [1912] = "+54 Fire DMG"
}

local suffixOfFrozenWrathLookup = {
    [1951] = "+1 Frost DMG", [1952] = "+3 Frost DMG", [1953] = "+4 Frost DMG",
    [1954] = "+6 Frost DMG", [1955] = "+7 Frost DMG", [1956] = "+9 Frost DMG",
    [1957] = "+10 Frost DMG", [1958] = "+11 Frost DMG", [1959] = "+13 Frost DMG",
    [1960] = "+14 Frost DMG", [1961] = "+16 Frost DMG", [1962] = "+17 Frost DMG",
    [1963] = "+19 Frost DMG", [1964] = "+20 Frost DMG", [1965] = "+21 Frost DMG",
    [1966] = "+23 Frost DMG", [1967] = "+24 Frost DMG", [1968] = "+26 Frost DMG",
    [1969] = "+27 Frost DMG", [1970] = "+29 Frost DMG", [1971] = "+30 Frost DMG",
    [1972] = "+31 Frost DMG", [1973] = "+33 Frost DMG", [1974] = "+34 Frost DMG",
    [1975] = "+36 Frost DMG", [1976] = "+37 Frost DMG", [1977] = "+39 Frost DMG",
    [1978] = "+40 Frost DMG", [1979] = "+41 Frost DMG", [1980] = "+43 Frost DMG",
    [1981] = "+44 Frost DMG", [1982] = "+46 Frost DMG", [1983] = "+47 Frost DMG",
    [1984] = "+49 Frost DMG", [1985] = "+50 Frost DMG", [1986] = "+51 Frost DMG",
    [1987] = "+53 Frost DMG", [1988] = "+54 Frost DMG"
}

local suffixOfHolyWrathLookup = {
    [1913] = "+1 Holy DMG", [1914] = "+3 Holy DMG", [1915] = "+4 Holy DMG",
    [1916] = "+6 Holy DMG", [1917] = "+7 Holy DMG", [1918] = "+9 Holy DMG",
    [1919] = "+10 Holy DMG", [1920] = "+11 Holy DMG", [1921] = "+13 Holy DMG",
    [1922] = "+14 Holy DMG", [1923] = "+16 Holy DMG", [1924] = "+17 Holy DMG",
    [1925] = "+19 Holy DMG", [1926] = "+20 Holy DMG", [1927] = "+21 Holy DMG",
    [1928] = "+23 Holy DMG", [1929] = "+24 Holy DMG", [1930] = "+26 Holy DMG",
    [1931] = "+27 Holy DMG", [1932] = "+29 Holy DMG", [1933] = "+30 Holy DMG",
    [1934] = "+31 Holy DMG", [1935] = "+33 Holy DMG", [1936] = "+34 Holy DMG",
    [1937] = "+36 Holy DMG", [1938] = "+37 Holy DMG", [1939] = "+39 Holy DMG",
    [1940] = "+40 Holy DMG", [1941] = "+41 Holy DMG", [1942] = "+43 Holy DMG",
    [1943] = "+44 Holy DMG", [1944] = "+46 Holy DMG", [1945] = "+47 Holy DMG",
    [1946] = "+49 Holy DMG", [1947] = "+50 Holy DMG", [1948] = "+51 Holy DMG",
    [1949] = "+53 Holy DMG", [1950] = "+54 Holy DMG"
}

local suffixOfNaturesWrathLookup = {
    [1989] = "+1 Nature DMG", [1990] = "+3 Nature DMG", [1991] = "+4 Nature DMG",
    [1992] = "+6 Nature DMG", [1993] = "+7 Nature DMG", [1994] = "+9 Nature DMG",
    [1995] = "+10 Nature DMG", [1996] = "+11 Nature DMG", [1997] = "+13 Nature DMG",
    [1998] = "+14 Nature DMG", [1999] = "+16 Nature DMG", [2000] = "+17 Nature DMG",
    [2001] = "+19 Nature DMG", [2002] = "+20 Nature DMG", [2003] = "+21 Nature DMG",
    [2004] = "+23 Nature DMG", [2005] = "+24 Nature DMG", [2006] = "+26 Nature DMG",
    [2007] = "+27 Nature DMG", [2008] = "+29 Nature DMG", [2009] = "+30 Nature DMG",
    [2010] = "+31 Nature DMG", [2011] = "+33 Nature DMG", [2012] = "+34 Nature DMG",
    [2013] = "+36 Nature DMG", [2014] = "+37 Nature DMG", [2015] = "+39 Nature DMG",
    [2016] = "+40 Nature DMG", [2017] = "+41 Nature DMG", [2018] = "+43 Nature DMG",
    [2019] = "+44 Nature DMG", [2020] = "+46 Nature DMG", [2021] = "+47 Nature DMG",
    [2022] = "+49 Nature DMG", [2023] = "+50 Nature DMG", [2024] = "+51 Nature DMG",
    [2025] = "+53 Nature DMG", [2026] = "+54 Nature DMG"
}

local suffixOfShadowWrathLookup = {
    [1837] = "+1 Shadow DMG", [1838] = "+3 Shadow DMG", [1839] = "+4 Shadow DMG",
    [1840] = "+6 Shadow DMG", [1841] = "+7 Shadow DMG", [1842] = "+9 Shadow DMG",
    [1843] = "+10 Shadow DMG", [1844] = "+11 Shadow DMG", [1845] = "+13 Shadow DMG",
    [1846] = "+14 Shadow DMG", [1847] = "+16 Shadow DMG", [1848] = "+17 Shadow DMG",
    [1849] = "+19 Shadow DMG", [1850] = "+20 Shadow DMG", [1851] = "+21 Shadow DMG",
    [1852] = "+23 Shadow DMG", [1853] = "+24 Shadow DMG", [1854] = "+26 Shadow DMG",
    [1855] = "+27 Shadow DMG", [1856] = "+29 Shadow DMG", [1857] = "+30 Shadow DMG",
    [1858] = "+31 Shadow DMG", [1859] = "+33 Shadow DMG", [1860] = "+34 Shadow DMG",
    [1861] = "+36 Shadow DMG", [1862] = "+37 Shadow DMG", [1863] = "+39 Shadow DMG",
    [1864] = "+40 Shadow DMG", [1865] = "+41 Shadow DMG", [1866] = "+43 Shadow DMG",
    [1867] = "+44 Shadow DMG", [1868] = "+46 Shadow DMG", [1869] = "+47 Shadow DMG",
    [1870] = "+49 Shadow DMG", [1871] = "+50 Shadow DMG", [1872] = "+51 Shadow DMG",
    [1873] = "+53 Shadow DMG", [1874] = "+54 Shadow DMG"
}

local suffixOfBlockingLookup = {
    [1647] = "+1% Block", [1648] = "+1% Block, +1 STR", [1649] = "+1% Block, +1 STR",
    [1650] = "+1% Block, +2 STR", [1651] = "+1% Block, +2 STR", [1652] = "+1% Block, +3 STR",
    [1653] = "+1% Block, +3 STR", [1654] = "+1% Block, +4 STR", [1655] = "+1% Block, +4 STR",
    [1656] = "+1% Block, +5 STR", [1657] = "+2% Block, +5 STR", [1658] = "+2% Block, +6 STR",
    [1659] = "+2% Block, +6 STR", [1660] = "+2% Block, +7 STR", [1661] = "+2% Block, +7 STR",
    [1662] = "+2% Block, +8 STR", [1663] = "+2% Block, +8 STR", [1664] = "+2% Block, +9 STR",
    [1665] = "+2% Block, +9 STR", [1666] = "+2% Block, +9 STR", [1667] = "+3% Block, +9 STR",
    [1668] = "+3% Block, +10 STR", [1669] = "+3% Block, +10 STR", [1670] = "+3% Block, +10 STR",
    [1671] = "+3% Block, +10 STR", [1672] = "+3% Block, +11 STR", [1673] = "+3% Block, +11 STR",
    [1674] = "+3% Block, +12 STR", [1675] = "+3% Block, +12 STR", [1676] = "+3% Block, +12 STR",
    [1677] = "+4% Block, +12 STR", [1678] = "+4% Block, +12 STR", [1679] = "+4% Block, +12 STR",
    [1680] = "+4% Block, +12 STR", [1681] = "+4% Block, +12 STR", [1682] = "+4% Block, +13 STR",
    [1683] = "+4% Block, +13 STR", [1684] = "+4% Block, +14 STR", [1685] = "+4% Block, +14 STR",
    [1686] = "+4% Block, +14 STR", [1687] = "+4% Block, +14 STR", [1688] = "+4% Block, +15 STR",
    [1689] = "+4% Block, +15 STR", [1690] = "+4% Block, +16 STR", [1691] = "+4% Block, +16 STR",
    [1692] = "+4% Block, +16 STR", [1693] = "+4% Block, +16 STR", [1694] = "+4% Block, +17 STR",
    [1695] = "+4% Block, +17 STR", [1696] = "+4% Block, +18 STR", [1697] = "+4% Block, +18 STR",
    [1698] = "+4% Block, +18 STR", [1699] = "+4% Block, +18 STR", [1700] = "+4% Block, +19 STR",
    [1701] = "+4% Block, +19 STR", [1702] = "+4% Block, +20 STR", [1703] = "+4% Block, +20 STR"
}

local suffixOfBeastSlayingLookup = {
    [49] = "+2 DMG to Beasts", [64] = "+4 DMG to Beasts",
    [76] = "+6 DMG to Beasts", [91] = "+8 DMG to Beasts",
    [110] = "+10 DMG to Beasts", [130] = "+12 DMG to Beasts",
    [149] = "+14 DMG to Beasts"
}

local suffixOfConcentrationLookup = {
    [2067] = "+1 MP5", [2068] = "+1 MP5", [2069] = "+1 MP5",
    [2070] = "+2 MP5", [2071] = "+2 MP5", [2072] = "+2 MP5",
    [2073] = "+3 MP5", [2074] = "+3 MP5", [2075] = "+4 MP5",
    [2076] = "+4 MP5", [2077] = "+4 MP5", [2078] = "+5 MP5",
    [2079] = "+5 MP5", [2080] = "+6 MP5", [2081] = "+6 MP5",
    [2082] = "+6 MP5", [2083] = "+7 MP5", [2084] = "+7 MP5",
    [2085] = "+8 MP5", [2086] = "+8 MP5", [2087] = "+8 MP5",
    [2088] = "+9 MP5", [2089] = "+9 MP5", [2090] = "+10 MP5",
    [2091] = "+10 MP5", [2092] = "+10 MP5", [2093] = "+11 MP5",
    [2094] = "+11 MP5", [2095] = "+12 MP5", [2096] = "+12 MP5",
    [2097] = "+12 MP5", [2098] = "+13 MP5", [2099] = "+13 MP5",
    [2100] = "+14 MP5", [2101] = "+14 MP5", [2102] = "+14 MP5",
    [2103] = "+15 MP5", [2104] = "+15 MP5"
}

local suffixOfEludingLookup = {
    [1742] = "+1% Dodge", [1743] = "+1% Dodge", [1744] = "+1% Dodge",
    [1745] = "+1% Dodge", [1746] = "+1% Dodge", [1747] = "+1% Dodge",
    [1748] = "+1% Dodge, +1 AGI", [1749] = "+1% Dodge, +1 AGI", [1750] = "+1% Dodge, +1 AGI",
    [1751] = "+1% Dodge, +2 AGI", [1752] = "+1% Dodge, +2 AGI", [1753] = "+1% Dodge, +2 AGI",
    [1754] = "+1% Dodge, +3 AGI", [1755] = "+1% Dodge, +3 AGI", [1756] = "+1% Dodge, +3 AGI",
    [1757] = "+1% Dodge, +4 AGI", [1758] = "+1% Dodge, +4 AGI", [1759] = "+1% Dodge, +4 AGI",
    [1760] = "+1% Dodge, +5 AGI", [1761] = "+1% Dodge, +5 AGI", [1762] = "+1% Dodge, +5 AGI",
    [1763] = "+1% Dodge, +6 AGI", [1764] = "+1% Dodge, +6 AGI", [1765] = "+1% Dodge, +6 AGI",
    [1766] = "+1% Dodge, +7 AGI", [1767] = "+1% Dodge, +7 AGI", [1768] = "+1% Dodge, +7 AGI",
    [1769] = "+1% Dodge, +8 AGI", [1770] = "+1% Dodge, +8 AGI", [1771] = "+1% Dodge, +8 AGI",
    [1772] = "+1% Dodge, +9 AGI", [1773] = "+1% Dodge, +9 AGI", [1774] = "+1% Dodge, +9 AGI",
    [1775] = "+1% Dodge, +9 AGI", [1776] = "+1% Dodge, +9 AGI", [1777] = "+1% Dodge, +9 AGI",
    [1778] = "+1% Dodge, +9 AGI", [1779] = "+1% Dodge, +9 AGI", [1780] = "+1% Dodge, +10 AGI",
    [1781] = "+1% Dodge, +10 AGI", [1782] = "+1% Dodge, +10 AGI", [1783] = "+1% Dodge, +11 AGI",
    [1784] = "+1% Dodge, +11 AGI", [1785] = "+1% Dodge, +11 AGI", [1786] = "+1% Dodge, +12 AGI",
    [1787] = "+1% Dodge, +12 AGI", [1788] = "+1% Dodge, +12 AGI", [1789] = "+1% Dodge, +12 AGI",
    [1790] = "+1% Dodge, +13 AGI", [1791] = "+1% Dodge, +13 AGI", [1792] = "+1% Dodge, +13 AGI",
    [1793] = "+1% Dodge, +14 AGI", [1794] = "+1% Dodge, +14 AGI", [1795] = "+1% Dodge, +14 AGI",
    [1796] = "+1% Dodge, +14 AGI", [1797] = "+1% Dodge, +15 AGI", [1798] = "+1% Dodge, +15 AGI"
}

local suffixOfHealingLookup = {
    [2027] = "+2 to Heals", [2028] = "+4 to Heals", [2029] = "+7 to Heals",
    [2030] = "+9 to Heals", [2031] = "+11 to Heals", [2032] = "+13 to Heals",
    [2033] = "+15 to Heals", [2034] = "+18 to Heals", [2035] = "+20 to Heals",
    [2036] = "+22 to Heals", [2037] = "+24 to Heals", [2038] = "+26 to Heals",
    [2039] = "+29 to Heals", [2040] = "+31 to Heals", [2041] = "+33 to Heals",
    [2042] = "+35 to Heals", [2043] = "+37 to Heals", [2044] = "+40 to Heals",
    [2045] = "+42 to Heals", [2046] = "+44 to Heals", [2047] = "+46 to Heals",
    [2048] = "+48 to Heals", [2049] = "+51 to Heals", [2050] = "+53 to Heals",
    [2051] = "+55 to Heals", [2052] = "+57 to Heals", [2053] = "+59 to Heals",
    [2054] = "+62 to Heals", [2055] = "+64 to Heals", [2056] = "+66 to Heals",
    [2057] = "+68 to Heals", [2058] = "+70 to Heals", [2059] = "+73 to Heals",
    [2060] = "+75 to Heals", [2061] = "+77 to Heals", [2062] = "+79 to Heals",
    [2063] = "+81 to Heals", [2064] = "+84 to Heals"
}

local suffixOfMarksmanshipLookup = {
    [1704] = "+2 Ranged AP", [1705] = "+5 Ranged AP", [1706] = "+7 Ranged AP",
    [1707] = "+10 Ranged AP", [1708] = "+12 Ranged AP", [1709] = "+14 Ranged AP",
    [1710] = "+17 Ranged AP", [1711] = "+19 Ranged AP", [1712] = "+22 Ranged AP",
    [1713] = "+24 Ranged AP", [1714] = "+26 Ranged AP", [1715] = "+29 Ranged AP",
    [1716] = "+31 Ranged AP", [1717] = "+34 Ranged AP", [1718] = "+36 Ranged AP",
    [1719] = "+38 Ranged AP", [1720] = "+41 Ranged AP", [1721] = "+43 Ranged AP",
    [1722] = "+46 Ranged AP", [1723] = "+48 Ranged AP", [1724] = "+50 Ranged AP",
    [1725] = "+53 Ranged AP", [1726] = "+55 Ranged AP", [1727] = "+58 Ranged AP",
    [1728] = "+60 Ranged AP", [1729] = "+62 Ranged AP", [1730] = "+65 Ranged AP",
    [1731] = "+67 Ranged AP", [1732] = "+70 Ranged AP", [1733] = "+72 Ranged AP",
    [1734] = "+74 Ranged AP", [1735] = "+77 Ranged AP", [1736] = "+79 Ranged AP",
    [1737] = "+82 Ranged AP", [1738] = "+84 Ranged AP", [1739] = "+86 Ranged AP",
    [1740] = "+89 Ranged AP", [1741] = "+91 Ranged AP"
}

local suffixOfPowerLookup = {
    [1547] = "+2 AP", [1548] = "+4 AP", [1549] = "+6 AP",
    [1550] = "+8 AP", [1551] = "+10 AP", [1552] = "+12 AP",
    [1553] = "+14 AP", [1554] = "+16 AP", [1555] = "+18 AP",
    [1556] = "+20 AP", [1557] = "+22 AP", [1558] = "+24 AP",
    [1559] = "+26 AP", [1560] = "+28 AP", [1561] = "+30 AP",
    [1562] = "+32 AP", [1563] = "+34 AP", [1564] = "+36 AP",
    [1565] = "+38 AP", [1566] = "+40 AP", [1567] = "+42 AP",
    [1568] = "+44 AP", [1569] = "+46 AP", [1570] = "+48 AP",
    [1571] = "+50 AP", [1572] = "+52 AP", [1573] = "+54 AP",
    [1574] = "+56 AP", [1575] = "+58 AP", [1576] = "+60 AP",
    [1577] = "+62 AP", [1578] = "+64 AP", [1579] = "+66 AP",
    [1580] = "+68 AP", [1581] = "+70 AP", [1582] = "+72 AP",
    [1583] = "+74 AP", [1584] = "+76 AP", [1585] = "+78 AP",
    [1586] = "+80 AP", [1587] = "+82 AP", [1588] = "+84 AP",
    [1589] = "+86 AP", [1590] = "+88 AP", [1591] = "+90 AP",
    [1592] = "+92 AP"
}

local suffixOfRegenerationLookup = {
    [2105] = "+1 HP5", [2106] = "+1 HP5", [2107] = "+1 HP5",
    [2108] = "+1 HP5", [2109] = "+1 HP5", [2110] = "+2 HP5",
    [2111] = "+2 HP5", [2112] = "+2 HP5", [2113] = "+2 HP5",
    [2114] = "+3 HP5", [2115] = "+3 HP5", [2116] = "+3 HP5",
    [2117] = "+3 HP5", [2118] = "+4 HP5", [2119] = "+4 HP5",
    [2120] = "+4 HP5", [2121] = "+4 HP5", [2122] = "+5 HP5",
    [2123] = "+5 HP5", [2124] = "+5 HP5", [2125] = "+5 HP5",
    [2126] = "+6 HP5", [2127] = "+6 HP5", [2128] = "+6 HP5",
    [2129] = "+6 HP5", [2130] = "+7 HP5", [2131] = "+7 HP5",
    [2132] = "+7 HP5", [2133] = "+7 HP5", [2134] = "+8 HP5",
    [2135] = "+8 HP5", [2136] = "+8 HP5", [2137] = "+8 HP5",
    [2138] = "+9 HP5", [2139] = "+9 HP5", [2140] = "+9 HP5",
    [2141] = "+9 HP5", [2142] = "+10 HP5"
}

local suffixOfRestorationLookup = {
    [2146] = "+10 STA, +22 to Heals, +4 MP5",
    [2147] = "+11 STA, +22 to Heals, +4 MP5",
    [2148] = "+10 STA, +24 to Heals, +4 MP5",
    [2153] = "+11 STA, +24 to Heals, +4 MP5",
    [2156] = "+15 STA, +33 to Heals, +6 MP5",
    [2160] = "+13 STA, +29 to Heals, +5 MP5",
    [2162] = "+11 STA, +26 to Heals, +4 MP5"
}

local suffixOfSorceryLookup = {
    [2143] = "+11 STA, +10 INT, +12 Damage/Healing SP",
    [2144] = "+11 STA, +10 INT, +12 Damage/Healing SP",
    [2145] = "+10 STA, +10 INT, +13 Damage/Healing SP",
    [2152] = "+11 STA, +11 INT, +13 Damage/Healing SP",
    [2155] = "+15 STA, +15 INT, +18 Damage/Healing SP",
    [2159] = "+13 STA, +13 INT, +15 Damage/Healing SP",
    [2161] = "+11 STA, +11 INT, +14 Damage/Healing SP"
}

local suffixOfStrikingLookup = {
    [2149] = "+11 STR, +10 AGI, +10 STA",
    [2150] = "+10 STR, +11 AGI, +10 STA",
    [2151] = "+10 STR, +10 AGI, +11 STA",
    [2154] = "+11 STR, +11 AGI, +11 STA",
    [2157] = "+15 STR, +15 AGI, +15 STA",
    [2158] = "+13 STR, +13 AGI, +13 STA",
    [2163] = "+11 STR, +11 AGI, +12 STA"
}

local suffixOfCriticalStrikeLookup = {
    [51] = "+1% Crit",
    [78] = "+2% Crit",
    [116] = "+3% Crit",
    [156] = "+4% Crit"
}

function GBLC:OnInitialize()

	---------------------------------------
	-- Global variable initialization
	---------------------------------------

	self.db = LibStub("AceDB-3.0"):New("GuildBankListCreatorDb", defaults)
	GBLC:RegisterChatCommand('gblc', 'HandleChatCommand');

	if (ListLimiter == nil) then
		ListLimiter = 0
	end

	if (ShowLinks == nil) then
		ShowLinks = true
	end

	if (StackItems == nil) then
		StackItems = false
	end

	if (UseCSV == nil) then
		UseCSV = false
	end

	if (ExcludeList == nil) then
		ExcludeList = {}
	end

-- 	--Debug
--         -- Function to get and print item types and subtypes
--     function PrintItemTypesAndSubtypes()
--         local itemTypes = { GetAuctionItemClasses() }
--
--         for i, itemType in ipairs(itemTypes) do
--             print("Item Type:", itemType)
--
--             local itemSubTypes = { GetAuctionItemSubClasses(i) }
--             for j, itemSubType in ipairs(itemSubTypes) do
--                 print("  SubType:", itemSubType)
--             end
--         end
--     end
--
--     -- Call the function to print types and subtypes
--     PrintItemTypesAndSubtypes()

end

function GBLC:BoolText(input)

	---------------------------------------
	-- Make string Title Case
	---------------------------------------

	local booltext = 'False'

	if (input) then
		booltext = 'True'
	end

	return booltext
end

function GBLC:ClearFrameText()
	FrameText = ''
end

function GBLC:AddLine(linetext)
	FrameText = FrameText .. linetext .. '\n'
end

function GBLC:GetSuffixStats(suffix, suffixID)
    local suffixLookup = {
		[" of the Bear"] = suffixOfTheBearLookup,
		[" of the Boar"] = suffixOfTheBoarLookup,
		[" of the Eagle"] = suffixOfTheEagleLookup,
		[" of the Falcon"] = suffixOfTheFalconLookup,
		[" of the Gorilla"] = suffixOfTheGorillaLookup,
        [" of the Monkey"] = suffixOfTheMonkeyLookup,
        [" of the Owl"] = suffixOfTheOwlLookup,
        [" of the Tiger"] = suffixOfTheTigerLookup,
        [" of the Whale"] = suffixOfTheWhaleLookup,
        [" of the Wolf"] = suffixOfTheWolfLookup,
        [" of Agility"] = suffixOfAgilityLookup,
        [" of Defense"] = suffixOfDefenseLookup,
        [" of Intellect"] = suffixOfIntellectLookup,
        [" of Spirit"] = suffixOfSpiritLookup,
        [" of Stamina"] = suffixOfStaminaLookup,
        [" of Strength"] = suffixOfStrengthLookup,
        [" of Arcane Resistance"] = suffixOfArcaneResistanceLookup,
        [" of Fire Resistance"] = suffixOfFireResistanceLookup,
        [" of Frost Resistance"] = suffixOfFrostResistanceLookup,
        [" of Nature Resistance"] = suffixOfNatureResistanceLookup,
        [" of Shadow Resistance"] = suffixOfShadowResistanceLookup,
        [" of Arcane Wrath"] = suffixOfArcaneWrathLookup,
        [" of Fiery Wrath"] = suffixOfFieryWrathLookup,
        [" of Frozen Wrath"] = suffixOfFrozenWrathLookup,
        [" of Holy Wrath"] = suffixOfHolyWrathLookup,
        [" of Nature's Wrath"] = suffixOfNaturesWrathLookup,
        [" of Shadow Wrath"] = suffixOfShadowWrathLookup,
        [" of Blocking"] = suffixOfBlockingLookup,
        [" of Beast Slaying"] = suffixOfBeastSlayingLookup,
        [" of Concentration"] = suffixOfConcentrationLookup,
        [" of Eluding"] = suffixOfEludingLookup,
        [" of Healing"] = suffixOfHealingLookup,
        [" of Marksmanship"] = suffixOfMarksmanshipLookup,
        [" of Power"] = suffixOfPowerLookup,
        [" of Regeneration"] = suffixOfRegenerationLookup,
        [" of Restoration"] = suffixOfRegenerationLookup,
        [" of Sorcery"] = suffixOfSorceryLookup,
        [" of Striking"] = suffixOfStrikingLookup,
        [" of Critical Strike"] = suffixOfCriticalStrikeLookup
    }

    if suffixLookup[suffix] and suffixLookup[suffix][tonumber(suffixID)] then
        return suffixLookup[suffix][tonumber(suffixID)]
    else
        return ""
    end
end

function GBLC:HandleChatCommand(input)

	---------------------------------------
	-- Main chat command handler function
	---------------------------------------

	local lcinput = string.lower(input)
	local gotcommands = false

	---------------------------------------
	-- Display help
	---------------------------------------

	if (string.match(lcinput, "help")) then
		GBLC:ClearFrameText()
--		GBLC:AddLine('OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO')
		GBLC:AddLine('Guild Bank List Creator Help')
		GBLC:AddLine('Usage:')
		GBLC:AddLine('/gblc             -- Creates list of items')
		GBLC:AddLine('/gblc status      -- Shows addon settings and exclusions')
		GBLC:AddLine('/gblc limit (number)')
		GBLC:AddLine('                  -- Sets a character limit on(number) to')
		GBLC:AddLine('                  -- split the list with extra linefeed.')
		GBLC:AddLine('                  -- This is useful when you paste the')
		GBLC:AddLine('                  -- list to Discord which limits post')
		GBLC:AddLine('                  -- lengths to 2000 characters.')
		GBLC:AddLine('                  -- Set limit to 0 if you don\'t')
		GBLC:AddLine('                  -- want to get linefeed splits')
		GBLC:AddLine('/gblc nolimit     -- Same as limit 0')
		GBLC:AddLine('/gblc links true  -- Shows Wowhead links on each item')
		GBLC:AddLine('/gblc links false -- No Wowhead links on any items')
		GBLC:AddLine('/gblc stack true  -- Combines items with same name')
		GBLC:AddLine('/gblc stack false -- Shows individual items')
		GBLC:AddLine('/gblc csv true    -- Output in CSV format')
		GBLC:AddLine('/gblc csv false   -- Output in original format')
		GBLC:AddLine('/gblc exclude item name (count)')
		GBLC:AddLine('                  -- Excludes (count) number of items')
		GBLC:AddLine('                  -- from the list. If no number is')
		GBLC:AddLine('                  -- provided the count is 1.')
		GBLC:AddLine('/gblc exclude id itemID (count)')
		GBLC:AddLine('                  -- Excludes (count) items from the list.')
		GBLC:AddLine('                  -- If there\'s no number, count is 1.')
		GBLC:AddLine('/gblc include item name (count)')
		GBLC:AddLine('                  -- Includes (count) items to the list')
		GBLC:AddLine('                  -- from the exclusion list. If there\'s')
		GBLC:AddLine('                  -- no number, count is 1.')
		GBLC:AddLine('/gblc include id itemID (count)')
		GBLC:AddLine('                  -- Includes (count) items to the list')
		GBLC:AddLine('                  -- from the exclusion list. If no number')
		GBLC:AddLine('                  -- is provided the count is 1.')
		GBLC:AddLine('/gblc clearitem item name')
		GBLC:AddLine('                  -- Clears an item from the exclusion')
		GBLC:AddLine('                  -- list.')
		GBLC:AddLine('/gblc clearitem id itemID')
		GBLC:AddLine('                  -- Clears an item from the exclusion')
		GBLC:AddLine('                  -- list.')
		GBLC:AddLine('/gblc clearlist   -- Clears the exclusion list.')
		GBLC:DisplayExportString(FrameText)
		GBLC:ClearFrameText()
		gotcommands = true
	end

	---------------------------------------
	-- Clear exclusion list
	---------------------------------------

	if (string.match(lcinput, "clearlist")) then
		GBLC:Print('Clearing exclusion list')
		for eitemID, ecount in pairs(ExcludeList) do
			GBLC:RemoveItem(eitemID)
		end
		ExcludeList = nil
		ExcludeList = {}
		GBLC:Print('Exclusion list cleared')
		gotcommands = true
	end

	---------------------------------------
	-- Clear item from exclusion list
	---------------------------------------

	if (string.match(lcinput, "clearitem")) then

		if (string.match(lcinput, "clearitem id ")) then
			local eitemid = tonumber(string.match(lcinput, "clearitem id (%d+)"))
			GBLC:RemoveItem(eitemid)
			GBLC:Print('Removed ' .. GBLC:GetItemLink(eitemid) .. ' from exclusion list.')
		else
			local ename = GBLC:WordCase(string.match(lcinput, "clearitem ([%w%s]+)"))
			ename = string.gsub(ename, "^ ", "")
			local itemID = GBLC:GetItemID(ename)
			local sLink = GBLC:GetItemLink(ename)
			if itemID == nil then
				GBLC:Print( "'" .. ename .. "'" .. ' does not exist.')
			else
				GBLC:RemoveItem(itemID)
			end
		end
		gotcommands = true
	end

	---------------------------------------
	-- Display status
	---------------------------------------

	if (string.match(lcinput, "status")) then

		GBLC:ClearFrameText()
		GBLC:AddLine('Guild Bank List Creator Status\n')
		GBLC:AddLine('Character limit: ' .. ListLimiter)
		GBLC:AddLine('Show Wowhead links: ' .. GBLC:BoolText(ShowLinks))
		GBLC:AddLine('Combine items to stacks: ' .. GBLC:BoolText(StackItems))
		if (not UseCSV) then
			GBLC:AddLine('Output CSV: ' .. GBLC:BoolText(UseCSV))
		else
			GBLC:AddLine('Output CSV: ' .. GBLC:BoolText(UseCSV) .. '. The character limiter is off.')
		end
		if ExcludeList ~= nil then

			GBLC:AddLine('\nExcluded items:')
			local excludeTable = {}
			local eic = 0
			for eitemID, ecount in pairs(ExcludeList) do
				eic = eic + 1
				local sName = GBLC:GetItemName(eitemID)
				excludeTable[eic] = sName .. ' (' .. ecount .. ')'
			end

			table.sort(excludeTable)

			for i=1 , #excludeTable do
				GBLC:AddLine(excludeTable[i])
			end

		end
		GBLC:DisplayExportString(FrameText)
		GBLC:ClearFrameText()

		gotcommands = true
	end

	---------------------------------------
	-- Exclude / include items
	---------------------------------------

	if (string.match(lcinput, "exclude")) then
		local ecount = nil
		local eitemid = nil
		local ename = ''

		if (string.match(lcinput, "exclude id ")) then

			---------------------------------------
			-- Exclude with itemID
			---------------------------------------

			eitemid = tonumber(string.match(lcinput, "exclude id (%d+)"))
			ecount = tonumber(string.match(lcinput, "exclude id %d+ (%d+)"))

			if ecount == nil then
				ecount = 1
			end

			local itemID = GBLC:GetItemID(eitemid)
			local sLink = GBLC:GetItemLink(eitemid)

			if itemID == nil then
				GBLC:Print( "ItemID " .. eitemid .. ' does not exist.')
			else
				GBLC:Print('Adding ' .. ecount .. ' ' .. sLink .. ' to the exclude list.')
				GBLC:ExcludeList(itemID, ecount)
			end
		else

			---------------------------------------
			-- Exclude with itemName
			---------------------------------------

			ecount = tonumber(string.match(lcinput, "exclude [%w%s]+(%d+)"))

			if ecount == nil then
				ecount = 1
			end

			ename = GBLC:WordCase(string.match(lcinput, "exclude ([%w%s]+)"))
			ename = string.gsub(ename, "^ ", "")
			local itemID = GBLC:GetItemID(ename)
			local sLink = GBLC:GetItemLink(ename)
			if itemID == nil then
				GBLC:Print( "'" .. ename .. "'" .. ' does not exist.')
			else
				GBLC:Print('Adding ' .. ecount .. ' ' .. sLink .. ' to the exclude list.')
				GBLC:ExcludeList(itemID, ecount)
			end
		end
		gotcommands = true
	end

	if (string.match(lcinput, "include")) then

		if (string.match(lcinput, "include id ")) then

			---------------------------------------
			-- Include with itemID
			---------------------------------------

			eitemid = tonumber(string.match(lcinput, "include id (%d+)"))
			ecount = tonumber(string.match(lcinput, "include id %d+ (%d+)"))

			if ecount == nil then
				ecount = 1
			end

			local itemID = GBLC:GetItemID(eitemid)
			local sLink = GBLC:GetItemLink(eitemid)

			if itemID == nil then
				GBLC:Print( "ItemID " .. eitemid .. ' does not exist.')
			else
				GBLC:Print('Removing ' .. ecount .. ' ' .. sLink .. ' from the exclude list.')
				GBLC:IncludeList(itemID, ecount)
			end
		else

			---------------------------------------
			-- Include with itemName
			---------------------------------------

			ecount = tonumber(string.match(lcinput, "include [%w%s]+(%d+)"))

			if ecount == nil then
				ecount = 1
			end

			ename = GBLC:WordCase(string.match(lcinput, "include ([%w%s]+)"))
			ename = string.gsub(ename, "^ ", "")
			local itemID = GBLC:GetItemID(ename)
			local sLink = GBLC:GetItemName(ename)
			if itemID == nil then
				GBLC:Print( "'" .. ename .. "'" .. ' does not exist.')
			else
				GBLC:Print('Removing ' .. ecount .. ' ' .. sLink .. ' from the exclude list.')
				GBLC:IncludeList(itemID, ecount)
			end
		end
		gotcommands = true
	end

	---------------------------------------
	-- Set limit
	---------------------------------------

	if (string.match(lcinput, "limit")) then
		local snumbers = tonumber(string.match(lcinput, "limit (%d+)"))

		if (string.match(lcinput, "nolimit")) then
			snumbers = 0
		end

		if ((snumbers > 0) and (snumbers < 150)) then
			GBLC:Print('Limiter number too low. Setting to 500.')
			snumbers = 500
		end
		ListLimiter = snumbers
		GBLC:Print('Setting character limit to ' .. ListLimiter)
		gotcommands = true
	end

	---------------------------------------
	-- Enable or disable Wowhead links
	---------------------------------------

	if (string.match(lcinput, "links true")) then
		GBLC:Print('Showing Wowhead links')
		ShowLinks = true
		gotcommands = true
	end

	if (string.match(lcinput, "links false")) then
		GBLC:Print('Hiding Wowhead links')
		ShowLinks = false
		gotcommands = true
	end

	---------------------------------------
	-- Enable or disable stacking items
	---------------------------------------

	if (string.match(lcinput, "stack true")) then
		GBLC:Print('Combining items of same name to stacks')
		StackItems = true
		gotcommands = true
	end

	if (string.match(lcinput, "stack false")) then
		GBLC:Print('Showing individual items')
		StackItems = false
		gotcommands = true
	end

	---------------------------------------
	-- Enable or disable CSV format
	---------------------------------------

	if (string.match(lcinput, "csv true")) then
		GBLC:Print('Printing list in CSV format. The character limiter is now off.')
		UseCSV = true
		gotcommands = true
	end

	if (string.match(lcinput, "csv false")) then
		GBLC:Print('Printing list in user readable format')
		UseCSV = false
		gotcommands = true
	end

	---------------------------------------
	-- Generate list
	---------------------------------------

	if (not gotcommands) then
		local bags = GBLC:GetBags()
		local bagItems = GBLC:GetBagItems()
		local itemlistsort = {}
		local wowheadlink = ''
		local copper = GetMoney()
		local moneystring = (("%dg %ds %dc"):format(copper / 100 / 100, (copper / 100) % 100, copper % 100));
		local gametimehours, gametimeminutes = GetGameTime()
		local texthours = string.format("%02d", gametimehours)
		local textminutes = string.format("%02d", gametimeminutes)

		---------------------------------------
		-- Generate output normal or CSV format
		-- depending on user settings
		---------------------------------------

		GBLC:ClearFrameText()

        -- Changed datetime formatting to American style, TODO: add formatting options
		if (not UseCSV) then
			GBLC:AddLine('Bank list updated on ' .. date("%m/%d/%Y ") .. texthours .. ':' .. textminutes .. ' server time\nCharacter: ' .. UnitName('player') .. '\nGold: ' .. moneystring .. '\n')
		else
			GBLC:AddLine(date("%m/%d/%Y") .. ',' .. texthours .. ':' .. textminutes .. ',' .. UnitName('player') .. ',' .. moneystring)
		end

		local exportLength = string.len(FrameText)
		local antii = 0

		for i=1, #bagItems do

			local finalCount = 0

			local stats = self:GetSuffixStats(bagItems[i].suffixName, tonumber(bagItems[i].suffix))
			wowheadlink = GBLC:WowheadLink(bagItems[i].itemID)

			if (ExcludeList[bagItems[i].itemID] == nil) then
				finalCount = bagItems[i].count
			else
				finalCount = bagItems[i].count - ExcludeList[bagItems[i].itemID]
			end

		---------------------------------------
		-- Add item to list if finalCount is
		-- larger than zero. In case of nothing
		-- to add, we need to backtrack a step
		-- on the next time we're adding stuff
		---------------------------------------

			if not UseCSV then
				if finalCount > 0 then
                    local statsString = stats and stats ~= "" and ' "' .. stats .. '"' or ''
                    itemlistsort[(i-antii)] = '[' .. bagItems[i].name .. '](' .. wowheadlink .. statsString .. ') (' .. finalCount .. ') - ' .. bagItems[i].minLevel .. ' ' .. bagItems[i].rarity .. ' ' .. bagItems[i].subType .. ' ' .. bagItems[i].equipLoc

-- 					itemlistsort[(i-antii)] = '[' .. bagItems[i].name .. '](' .. wowheadlink .. ' "' .. stats .. '"' .. ') (' .. finalCount .. ') - ' .. bagItems[i].minLevel .. ' ' .. bagItems[i].rarity .. ' ' .. bagItems[i].subType .. ' ' .. bagItems[i].equipLoc
				end
			else
				if finalCount > 0 then
					itemlistsort[(i-antii)] = bagItems[i].itemName .. ',' .. finalCount .. ',' .. wowheadlink
				end
			end

			if finalCount <= 0 then
				antii = antii + 1
			end
		end

		table.sort(itemlistsort);

		for i=1, #itemlistsort do
			if ((ListLimiter > 0) and (not UseCSV)) then
				if ((exportLength + string.len(itemlistsort[i])) > ListLimiter) then
					GBLC:AddLine('\nList continued')
					exportLength = 0
				end
			end
			GBLC:AddLine(itemlistsort[i])
			exportLength = exportLength + string.len(itemlistsort[i])
		end

		local enumber = 0
		for eitemID, ecount in pairs(ExcludeList) do
			if ((eitemID ~= nil) and (eitemID > 0)) then
				enumber = enumber + 1
			end
		end

		if enumber > 0 then

			GBLC:AddLine('\nExcluded items')
			exportLength = 0
			local eic = 0
			local excludeTable = {}

			for eitemID, ecount in pairs(ExcludeList) do

				eic = eic +1
				local excludeString = ''
				local sName = GBLC:GetItemName(eitemID)
				wowheadlink = GBLC:WowheadLink(eitemID)

				if not UseCSV then
					excludeTable[eic] = sName .. ' (' .. ecount .. ')' .. wowheadlink
				else
					excludeTable[eic] = sName .. ',' .. ecount .. ',' .. wowheadlink ..','
				end
			end

			table.sort(excludeTable)

			for i=1 , #excludeTable do

				if ((ListLimiter > 0) and (not UseCSV)) then
					if ((exportLength + string.len(excludeTable[i])) > ListLimiter) then
						GBLC:AddLine('\nList continued')
						exportLength = 0
					end
				end

				GBLC:AddLine(excludeTable[i])

			end

		end

		GBLC:DisplayExportString(FrameText, true)
		GBLC:ClearFrameText()

	end

end

function GBLC:GetItemName(eitemID)

	---------------------------------------
	-- Get Item Name with itemID
	---------------------------------------

	local sName, sLink, iRarity, iLevel, iMinLevel, sType, sSubType, iStackCount, sItemEquipLoc = GetItemInfo(eitemID)
	if sName == nil then
		sName = 'Unseen item with ID ' .. eitemID
	end

	return sName
end

function GBLC:GetItemLink(eitemID)

	---------------------------------------
	-- Get Item Link with itemID
	---------------------------------------

	local sName, sLink, iRarity, iLevel, iMinLevel, sType, sSubType, iStackCount = GetItemInfo(eitemID)
	if sLink == nil then
		sLink = 'Unseen item with ID ' .. eitemID
	end
	return sLink
end

function GBLC:GetItemID(eitemName)

	---------------------------------------
	-- Get ItemID with item name
	---------------------------------------

	local itemID, itemType, itemSubType, itemEquipLoc, icon, itemClassID, itemSubClassID = GetItemInfoInstant(eitemName)
	return itemID
end

function GBLC:WowheadLink(witemID)

	---------------------------------------
	-- Create Wowhead link
	---------------------------------------

	local wowheadlink = ''

	if ((ShowLinks) and (witemID ~= nil)) then
		wowheadlink = 'https://classic.wowhead.com/item=' .. witemID
		if (not UseCSV) then
			wowheadlink = wowheadlink
		end
	end

	return wowheadlink
end

function GBLC:WordCase(instring)

	---------------------------------------
	-- Make String Title Case
	---------------------------------------

	local function tchelper(first, rest)
		return first:upper()..rest:lower()
	end

	local newstring = ' ' .. string.gsub(instring, "(%a)([%w_']*)", tchelper)
	newstring = string.gsub(newstring, "^%s+", "") -- just in case there's extra spaces at the start of the string

	return newstring
end

function GBLC:ExcludeList(eitemID, ecount)

	---------------------------------------
	-- Add item count to exclude list
	---------------------------------------

	if (ExcludeList[eitemID] == nil) then
		ExcludeList[eitemID] = ecount
	else
		ExcludeList[eitemID] = ExcludeList[eitemID] + ecount
	end

	return true
end

function GBLC:RemoveItem(eitemID)

	---------------------------------------
	-- Remove item from exclude list
	---------------------------------------

	GBLC:IncludeList(eitemID, 0, true)
end

function GBLC:IncludeList(eitemID, ecount, etrash)

	---------------------------------------
	-- Remove item count from exclude list
	---------------------------------------

	if (ExcludeList[eitemID] == nil) then
		GBLC:Print('There is no itemID ' .. eitemID .. ' in the exclude list')
		return false
	else
		ExcludeList[eitemID] = ExcludeList[eitemID] - ecount
	end

	if (ExcludeList[eitemID] >= 0) then
		GBLC:Print('Exclusion ' .. GBLC:GetItemLink(eitemID) .. ' count reached zero. Removing entry.')
		ExcludeList[eitemID] = nil
		table.remove(ExcludeList, eitemID)
	end

	if (etrash) then
		if (ExcludeList[eitemID] >= 0) then
			GBLC:Print('Removing ' .. GBLC:GetItemLink(eitemID) .. ' from the exclusion list.')
			ExcludeList[eitemID] = nil
			table.remove(ExcludeList, eitemID)
		end
	end

	return true
end

-- Helper function to get human-readable rarity
function GBLC:getReadableRarity(rarity)
    return rarityLookup[rarity] or ""
end

function GBLC:getReadableSlot(slot)
	return slotLookup[slot] or ""
end

function GBLC:GetBags()

	---------------------------------------
	-- Get list of character bags
	---------------------------------------

	local bags = {}

	for container = -1, 12 do
		bags[#bags + 1] = {
			container = container,
			bagName = C_Container.GetBagName(container)
		}
	end

	return bags;
end

-- Heavily modified
function GBLC:GetBagItems()
    local bagItems = {}

    for container = -1, 12 do
        local numSlots = C_Container.GetContainerNumSlots(container)

        for slot = 1, numSlots do
            local itemLink = C_Container.GetContainerItemLink(container, slot)

            if itemLink then
                local itemName, itemID, itemRarity, _, itemMinLevel, itemType, itemSubType, _, itemEquipLoc = GetItemInfo(itemLink)
                local count = select(2, C_Container.GetContainerItemInfo(container, slot)) or 1

                local isStackable = stackableLookup[itemType] and (type(stackableLookup[itemType]) ~= "table" or stackableLookup[itemType][itemSubType])

                local _, _, Color, Ltype, Id, Enchant, Gem1, Gem2, Gem3, Gem4, Suffix, Unique, LinkLvl, Name = string.find(itemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
                local suffixName = string.match(itemName, " of .+$")

                local stacked = false

                if StackItems and #bagItems > 0 then
                    for stackitem = 1, #bagItems do
                        if bagItems[stackitem].itemID == Id then
                            if isStackable then
                                -- Stackable items (like materials) are combined across all bags
                                count = GetItemCount(Id)
                                bagItems[stackitem].count = count
                                stacked = true
                                break
                            elseif bagItems[stackitem].suffix == Suffix then
                                -- Non-stackable items with the same suffix are combined
                                bagItems[stackitem].count = bagItems[stackitem].count + count
                                stacked = true
                                break
                            end
                        end
                    end
                end

                if not stacked then
                    bagItems[#bagItems + 1] = {
                        link = itemLink,
                        name = itemName,
                        suffix = Suffix,
                        suffixName = suffixName,
                        itemID = Id,
                        rarity = GBLC:getReadableRarity(itemRarity),
                        minLevel = itemMinLevel,
                        iType = itemType,
                        subType = itemSubType,
                        equipLoc = GBLC:getReadableSlot(itemEquipLoc),
                        count = isStackable and GetItemCount(Id) or count
                    }
                end
            end
        end
    end

    return bagItems
end

function GBLC:DisplayExportString(str,highlight)

	---------------------------------------
	-- Display the main frame with list
	---------------------------------------

	-- Increased width
    local newWidth = 1000

    gblcFrame:SetWidth(newWidth)

	-- Create and set the frame texture for background
    local frameTexture = gblcFrame:CreateTexture()
    frameTexture:SetAllPoints(gblcFrame)
    frameTexture:SetColorTexture(0.1, 0.1, 0.1, 0.5) -- specified dark grey, transparent background

	gblcFrame:Show();
	gblcFrameScroll:Show()
	gblcFrameScrollText:Show()
	gblcFrameScrollText:SetText(str)

	if highlight then
		gblcFrameScrollText:HighlightText()
	end

	gblcFrameScrollText:SetScript('OnEscapePressed', function(self)
		gblcFrame:Hide();
		end
	);

	gblcFrameButton:SetScript("OnClick", function(self)
		gblcFrame:Hide();
		end
	);
end

GBLC = LibStub("AceAddon-3.0"):NewAddon("GBLC", "AceConsole-3.0", "AceEvent-3.0")
FrameText = ''

-- Added all lookup tables
local rarityLookup = {
    [0] = "Poor",
    [1] = "Common",
    [2] = "Uncommon",
    [3] = "Rare",
    [4] = "Epic",
    [5] = "Legendary",
    [6] = "Arifact",
    [7] = "Heirloom"
}

local slotLookup = {
    ["INVTYPE_AMMO"] = "Ammo",
    ["INVTYPE_HEAD"] = "Head",
    ["INVTYPE_NECK"] = "Neck",
    ["INVTYPE_SHOULDER"] = "Shoulder",
    ["INVTYPE_BODY"] = "Shirt",
    ["INVTYPE_CHEST"] = "Chest",
    ["INVTYPE_ROBE"] = "Chest",
    ["INVTYPE_WAIST"] = "Waist",
    ["INVTYPE_LEGS"] = "Legs",
    ["INVTYPE_FEET"] = "Feet",
    ["INVTYPE_WRIST"] = "Wrist",
    ["INVTYPE_HAND"] = "Hands",
    ["INVTYPE_FINGER"] = "Finger",
    ["INVTYPE_TRINKET"] = "Trinket",
    ["INVTYPE_CLOAK"] = "Back",
    ["INVTYPE_WEAPON"] = "One-Hand",
    ["INVTYPE_SHIELD"] = "Off Hand",
    ["INVTYPE_2HWEAPON"] = "Two-Hand",
    ["INVTYPE_WEAPONMAINHAND"] = "Main Hand",
    ["INVTYPE_WEAPONOFFHAND"] = "Off Hand",
    ["INVTYPE_HOLDABLE"] = "Held In Off-hand",
    ["INVTYPE_RANGED"] = "Ranged",
    ["INVTYPE_THROWN"] = "Thrown",
    ["INVTYPE_RANGEDRIGHT"] = "Ranged",
    ["INVTYPE_RELIC"] = "Relic",
    ["INVTYPE_TABARD"] = "Tabard",
    ["INVTYPE_BAG"] = "Bag",
}

local stackableLookup = {
    -- some falses need to look in sub table
    ["Consumable"] = true,
    ["Container"] = false, -- this will be wrong in wotlk
    ["Weapon"] = false,
    ["Gem"] = true, -- ?
    ["Armor"] = false,
    ["Reagent"] = true,
    ["Projectile"] = true,
    ["Trade Goods"] = true,
    ["Item Enhancement"] = false, -- some edge cases, but they're BoP
    ["Recipe"] = false,
    ["Money"] = true, -- probably, not sure if this is obsolete in classic or not, key may be Money(OBSOLETE)
    ["Quiver"] = false,
    ["Quest"] = true,
    ["Key"] = true, -- maybe
    ["Permanent"] = false, -- no idea, may be similar to money aka Permanent(OBSOLETE)
    ["Miscellaneous"] = {
                            ["Junk"] = true,
                            ["Reagent"] = true,
                            ["Companion Pets"] = false,
                            ["Holiday"] = true,
                            ["Other"] = true,
                            ["Mount"] = false,
                            ["Mount Equipment"] = false
                        },
--    ["Glyph"] = false,
--    ["Battle Pets"] = false,
--     ["WoW Token"] = false,
    ["Profession"] = true -- not sure
}

local suffixOfTheBearLookup = {
    [1179] = "+1 STA, +1 STR", [1180] = "+2 STA, +1 STR", [1181] = "+1 STA, +2 STR",
    [1182] = "+2 STA, +2 STR", [1183] = "+3 STA, +2 STR", [1184] = "+2 STA, +3 STR",
    [1185] = "+3 STA, +3 STR", [1186] = "+4 STA, +3 STR", [1187] = "+3 STA, +4 STR",
    [1188] = "+4 STA, +4 STR", [1189] = "+5 STA, +4 STR", [1190] = "+4 STA, +5 STR",
    [1191] = "+5 STA, +5 STR", [1192] = "+6 STA, +5 STR", [1193] = "+5 STA, +6 STR",
    [1194] = "+6 STA, +6 STR", [1195] = "+7 STA, +6 STR", [1196] = "+6 STA, +7 STR",
    [1197] = "+7 STA, +7 STR", [1198] = "+8 STA, +7 STR", [1199] = "+7 STA, +8 STR",
    [1200] = "+8 STA, +8 STR", [1201] = "+9 STA, +8 STR", [1202] = "+8 STA, +9 STR",
    [1203] = "+9 STA, +9 STR", [1204] = "+10 STA, +9 STR", [1205] = "+9 STA, +10 STR",
    [1206] = "+10 STA, +10 STR", [1207] = "+11 STA, +10 STR", [1208] = "+10 STA, +11 STR",
    [1209] = "+11 STA, +11 STR", [1210] = "+12 STA, +11 STR", [1211] = "+11 STA, +12 STR",
    [1212] = "+12 STA, +12 STR", [1213] = "+13 STA, +12 STR", [1214] = "+12 STA, +13 STR",
    [1215] = "+13 STA, +13 STR", [1216] = "+14 STA, +13 STR", [1217] = "+13 STA, +14 STR",
    [1218] = "+14 STA, +14 STR", [1219] = "+15 STA, +14 STR", [1220] = "+14 STA, +15 STR",
    [1221] = "+15 STA, +15 STR", [1222] = "+16 STA, +15 STR", [1223] = "+15 STA, +16 STR",
    [1224] = "+16 STA, +16 STR", [1225] = "+17 STA, +16 STR", [1226] = "+16 STA, +17 STR",
    [1227] = "+17 STA, +17 STR", [1228] = "+18 STA, +17 STR", [1229] = "+17 STA, +18 STR",
    [1230] = "+18 STA, +18 STR", [1231] = "+19 STA, +18 STR", [1232] = "+18 STA, +19 STR",
    [1233] = "+19 STA, +19 STR", [1234] = "+20 STA, +19 STR", [1235] = "+19 STA, +20 STR",
    [1236] = "+20 STA, +20 STR", [1237] = "+21 STA, +20 STR", [1238] = "+20 STA, +21 STR",
    [1239] = "+21 STA, +21 STR", [1240] = "+22 STA, +21 STR", [1241] = "+21 STA, +22 STR",
    [1242] = "+22 STA, +22 STR", [1243] = "+23 STA, +22 STR", [1244] = "+22 STA, +23 STR",
    [1245] = "+23 STA, +23 STR", [1246] = "+24 STA, +23 STR", [1247] = "+23 STA, +24 STR",
    [1248] = "+24 STA, +24 STR", [1249] = "+25 STA, +24 STR", [1250] = "+24 STA, +25 STR",
    [1251] = "+25 STA, +25 STR", [1252] = "+26 STA, +25 STR", [1253] = "+25 STA, +26 STR",
    [1254] = "+26 STA, +26 STR", [1255] = "+27 STA, +26 STR", [1256] = "+26 STA, +27 STR",
    [1257] = "+27 STA, +27 STR", [1258] = "+28 STA, +27 STR", [1259] = "+27 STA, +28 STR",
    [1260] = "+28 STA, +28 STR", [1261] = "+29 STA, +28 STR", [1262] = "+28 STA, +29 STR",
    [1263] = "+29 STA, +29 STR"
}

local suffixOfTheBoarLookup = {
    [1094] = "+1 SPI, +1 STR", [1095] = "+2 SPI, +1 STR", [1096] = "+1 SPI, +2 STR",
    [1097] = "+2 SPI, +2 STR", [1098] = "+3 SPI, +2 STR", [1099] = "+2 SPI, +3 STR",
    [1100] = "+3 SPI, +3 STR", [1101] = "+4 SPI, +3 STR", [1102] = "+3 SPI, +4 STR",
    [1103] = "+4 SPI, +4 STR", [1104] = "+5 SPI, +4 STR", [1105] = "+4 SPI, +5 STR",
    [1106] = "+5 SPI, +5 STR", [1107] = "+6 SPI, +5 STR", [1108] = "+5 SPI, +6 STR",
    [1109] = "+6 SPI, +6 STR", [1110] = "+7 SPI, +6 STR", [1111] = "+6 SPI, +7 STR",
    [1112] = "+7 SPI, +7 STR", [1113] = "+8 SPI, +7 STR", [1114] = "+7 SPI, +8 STR",
    [1115] = "+8 SPI, +8 STR", [1116] = "+9 SPI, +8 STR", [1117] = "+8 SPI, +9 STR",
    [1118] = "+9 SPI, +9 STR", [1119] = "+10 SPI, +9 STR", [1120] = "+9 SPI, +10 STR",
    [1121] = "+10 SPI, +10 STR", [1122] = "+11 SPI, +10 STR", [1123] = "+10 SPI, +11 STR",
    [1124] = "+11 SPI, +11 STR", [1125] = "+12 SPI, +11 STR", [1126] = "+11 SPI, +12 STR",
    [1127] = "+12 SPI, +12 STR", [1128] = "+13 SPI, +12 STR", [1129] = "+12 SPI, +13 STR",
    [1130] = "+13 SPI, +13 STR", [1131] = "+14 SPI, +13 STR", [1132] = "+13 SPI, +14 STR",
    [1133] = "+14 SPI, +14 STR", [1134] = "+15 SPI, +14 STR", [1135] = "+14 SPI, +15 STR",
    [1136] = "+15 SPI, +15 STR", [1137] = "+16 SPI, +15 STR", [1138] = "+15 SPI, +16 STR",
    [1139] = "+16 SPI, +16 STR", [1140] = "+17 SPI, +16 STR", [1141] = "+16 SPI, +17 STR",
    [1142] = "+17 SPI, +17 STR", [1143] = "+18 SPI, +17 STR", [1144] = "+17 SPI, +18 STR",
    [1145] = "+18 SPI, +18 STR", [1146] = "+19 SPI, +18 STR", [1147] = "+18 SPI, +19 STR",
    [1148] = "+19 SPI, +19 STR", [1149] = "+20 SPI, +19 STR", [1150] = "+19 SPI, +20 STR",
    [1151] = "+20 SPI, +20 STR", [1152] = "+21 SPI, +20 STR", [1153] = "+20 SPI, +21 STR",
    [1154] = "+21 SPI, +21 STR", [1155] = "+22 SPI, +21 STR", [1156] = "+21 SPI, +22 STR",
    [1157] = "+22 SPI, +22 STR", [1158] = "+23 SPI, +22 STR", [1159] = "+22 SPI, +23 STR",
    [1160] = "+23 SPI, +23 STR", [1161] = "+24 SPI, +23 STR", [1162] = "+23 SPI, +24 STR",
    [1163] = "+24 SPI, +24 STR", [1164] = "+25 SPI, +24 STR", [1165] = "+24 SPI, +25 STR",
    [1166] = "+25 SPI, +25 STR", [1167] = "+26 SPI, +25 STR", [1168] = "+25 SPI, +26 STR",
    [1169] = "+26 SPI, +26 STR", [1170] = "+27 SPI, +26 STR", [1171] = "+26 SPI, +27 STR",
    [1172] = "+27 SPI, +27 STR", [1173] = "+28 SPI, +27 STR", [1174] = "+27 SPI, +28 STR",
    [1175] = "+28 SPI, +28 STR", [1176] = "+29 SPI, +28 STR", [1177] = "+28 SPI, +29 STR",
    [1178] = "+29 SPI, +29 STR"
}

local suffixOfTheEagleLookup = {
    [839] = "+1 INT, +1 STA", [840] = "+2 INT, +1 STA", [841] = "+1 INT, +2 STA",
    [842] = "+2 INT, +2 STA", [843] = "+3 INT, +2 STA", [844] = "+2 INT, +3 STA",
    [845] = "+3 INT, +3 STA", [846] = "+4 INT, +3 STA", [847] = "+3 INT, +4 STA",
    [848] = "+4 INT, +4 STA", [849] = "+5 INT, +4 STA", [850] = "+4 INT, +5 STA",
    [851] = "+5 INT, +5 STA", [852] = "+6 INT, +5 STA", [853] = "+5 INT, +6 STA",
    [854] = "+6 INT, +6 STA", [855] = "+7 INT, +6 STA", [856] = "+6 INT, +7 STA",
    [857] = "+7 INT, +7 STA", [858] = "+8 INT, +7 STA", [859] = "+7 INT, +8 STA",
    [860] = "+8 INT, +8 STA", [861] = "+9 INT, +8 STA", [862] = "+8 INT, +9 STA",
    [863] = "+9 INT, +9 STA", [864] = "+10 INT, +9 STA", [865] = "+9 INT, +10 STA",
    [866] = "+10 INT, +10 STA", [867] = "+11 INT, +10 STA", [868] = "+10 INT, +11 STA",
    [869] = "+11 INT, +11 STA", [870] = "+12 INT, +11 STA", [871] = "+11 INT, +12 STA",
    [872] = "+12 INT, +12 STA", [873] = "+13 INT, +12 STA", [874] = "+12 INT, +13 STA",
    [875] = "+13 INT, +13 STA", [876] = "+14 INT, +13 STA", [877] = "+13 INT, +14 STA",
    [878] = "+14 INT, +14 STA", [879] = "+15 INT, +14 STA", [880] = "+14 INT, +15 STA",
    [881] = "+15 INT, +15 STA", [882] = "+16 INT, +15 STA", [883] = "+15 INT, +16 STA",
    [884] = "+16 INT, +16 STA", [885] = "+17 INT, +16 STA", [886] = "+16 INT, +17 STA",
    [887] = "+17 INT, +17 STA", [888] = "+18 INT, +17 STA", [889] = "+17 INT, +18 STA",
    [890] = "+18 INT, +18 STA", [891] = "+19 INT, +18 STA", [892] = "+18 INT, +19 STA",
    [893] = "+19 INT, +19 STA", [894] = "+20 INT, +19 STA", [895] = "+19 INT, +20 STA",
    [896] = "+20 INT, +20 STA", [897] = "+21 INT, +20 STA", [898] = "+20 INT, +21 STA",
    [899] = "+21 INT, +21 STA", [900] = "+22 INT, +21 STA", [901] = "+21 INT, +22 STA",
    [902] = "+22 INT, +22 STA", [903] = "+23 INT, +22 STA", [904] = "+22 INT, +23 STA",
    [905] = "+23 INT, +23 STA", [906] = "+24 INT, +23 STA", [907] = "+23 INT, +24 STA",
    [908] = "+24 INT, +24 STA", [909] = "+25 INT, +24 STA", [910] = "+24 INT, +25 STA",
    [911] = "+25 INT, +25 STA", [912] = "+26 INT, +25 STA", [913] = "+25 INT, +26 STA",
    [914] = "+26 INT, +26 STA", [915] = "+27 INT, +26 STA", [916] = "+26 INT, +27 STA",
    [917] = "+27 INT, +27 STA", [918] = "+28 INT, +27 STA", [919] = "+27 INT, +28 STA",
    [920] = "+28 INT, +28 STA", [921] = "+29 INT, +28 STA", [922] = "+28 INT, +29 STA",
    [923] = "+29 INT, +29 STA"
}

local suffixOfTheFalconLookup = {
    [227] = "+1 AGI, +1 INT", [229] = "+2 AGI, +1 INT", [231] = "+1 AGI, +2 INT",
    [232] = "+2 AGI, +2 INT", [233] = "+3 AGI, +2 INT", [234] = "+2 AGI, +3 INT",
    [235] = "+3 AGI, +3 INT", [236] = "+4 AGI, +3 INT", [237] = "+3 AGI, +4 INT",
    [238] = "+4 AGI, +4 INT",
    [247] = "+5 AGI, +4 INT", [248] = "+4 AGI, +5 INT", [249] = "+5 AGI, +5 INT",
    [250] = "+6 AGI, +5 INT", [251] = "+5 AGI, +6 INT", [252] = "+6 AGI, +6 INT",
    [253] = "+7 AGI, +6 INT", [254] = "+6 AGI, +7 INT", [255] = "+7 AGI, +7 INT",
    [435] = "+8 AGI, +7 INT", [436] = "+7 AGI, +8 INT", [437] = "+8 AGI, +8 INT",
    [438] = "+9 AGI, +8 INT", [439] = "+8 AGI, +9 INT", [440] = "+9 AGI, +9 INT",
    [441] = "+10 AGI, +9 INT", [442] = "+9 AGI, +10 INT", [443] = "+10 AGI, +10 INT",
    [444] = "+11 AGI, +10 INT", [445] = "+10 AGI, +11 INT", [446] = "+11 AGI, +11 INT",
    [447] = "+12 AGI, +11 INT", [448] = "+11 AGI, +12 INT", [449] = "+12 AGI, +12 INT",
    [450] = "+13 AGI, +12 INT", [451] = "+12 AGI, +13 INT", [452] = "+13 AGI, +13 INT",
    [453] = "+14 AGI, +13 INT", [454] = "+13 AGI, +14 INT", [455] = "+14 AGI, +14 INT",
    [456] = "+15 AGI, +14 INT", [457] = "+14 AGI, +15 INT", [458] = "+15 AGI, +15 INT",
    [459] = "+16 AGI, +15 INT", [460] = "+15 AGI, +16 INT", [461] = "+16 AGI, +16 INT",
    [462] = "+17 AGI, +16 INT", [463] = "+16 AGI, +17 INT", [464] = "+17 AGI, +17 INT",
    [465] = "+18 AGI, +17 INT", [466] = "+17 AGI, +18 INT", [467] = "+18 AGI, +18 INT",
    [468] = "+19 AGI, +18 INT", [469] = "+18 AGI, +19 INT", [470] = "+19 AGI, +19 INT",
    [471] = "+20 AGI, +19 INT", [472] = "+19 AGI, +20 INT", [473] = "+20 AGI, +20 INT",
    [474] = "+21 AGI, +20 INT", [475] = "+20 AGI, +21 INT", [476] = "+21 AGI, +21 INT",
    [477] = "+22 AGI, +21 INT", [478] = "+21 AGI, +22 INT", [479] = "+22 AGI, +22 INT",
    [480] = "+23 AGI, +22 INT", [481] = "+22 AGI, +23 INT", [482] = "+23 AGI, +23 INT",
    [483] = "+24 AGI, +23 INT", [484] = "+23 AGI, +24 INT", [485] = "+24 AGI, +24 INT",
    [486] = "+25 AGI, +24 INT", [487] = "+24 AGI, +25 INT", [488] = "+25 AGI, +25 INT",
    [489] = "+26 AGI, +25 INT", [490] = "+25 AGI, +26 INT", [491] = "+26 AGI, +26 INT",
    [492] = "+27 AGI, +26 INT", [493] = "+26 AGI, +27 INT", [494] = "+27 AGI, +27 INT",
    [495] = "+28 AGI, +27 INT", [496] = "+27 AGI, +28 INT", [497] = "+28 AGI, +28 INT",
    [498] = "+29 AGI, +28 INT", [499] = "+28 AGI, +29 INT", [500] = "+29 AGI, +29 INT"
}

local suffixOfTheGorillaLookup = {
    [924] = "+1 INT, +1 STR", [925] = "+2 INT, +1 STR", [926] = "+1 INT, +2 STR",
    [927] = "+2 INT, +2 STR", [928] = "+3 INT, +2 STR", [929] = "+2 INT, +3 STR",
    [930] = "+3 INT, +3 STR", [931] = "+4 INT, +3 STR", [932] = "+3 INT, +4 STR",
    [933] = "+4 INT, +4 STR", [934] = "+5 INT, +4 STR", [935] = "+4 INT, +5 STR",
    [936] = "+5 INT, +5 STR", [937] = "+6 INT, +5 STR", [938] = "+5 INT, +6 STR",
    [939] = "+6 INT, +6 STR", [940] = "+7 INT, +6 STR", [941] = "+6 INT, +7 STR",
    [942] = "+7 INT, +7 STR", [943] = "+8 INT, +7 STR", [944] = "+7 INT, +8 STR",
    [945] = "+8 INT, +8 STR", [946] = "+9 INT, +8 STR", [947] = "+8 INT, +9 STR",
    [948] = "+9 INT, +9 STR", [949] = "+10 INT, +9 STR", [950] = "+9 INT, +10 STR",
    [951] = "+10 INT, +10 STR", [952] = "+11 INT, +10 STR", [953] = "+10 INT, +11 STR",
    [954] = "+11 INT, +11 STR", [955] = "+12 INT, +11 STR", [956] = "+11 INT, +12 STR",
    [957] = "+12 INT, +12 STR", [958] = "+13 INT, +12 STR", [959] = "+12 INT, +13 STR",
    [960] = "+13 INT, +13 STR", [961] = "+14 INT, +13 STR", [962] = "+13 INT, +14 STR",
    [963] = "+14 INT, +14 STR", [964] = "+15 INT, +14 STR", [965] = "+14 INT, +15 STR",
    [966] = "+15 INT, +15 STR", [967] = "+16 INT, +15 STR", [968] = "+15 INT, +16 STR",
    [969] = "+16 INT, +16 STR", [970] = "+17 INT, +16 STR", [971] = "+16 INT, +17 STR",
    [972] = "+17 INT, +17 STR", [973] = "+18 INT, +17 STR", [974] = "+17 INT, +18 STR",
    [975] = "+18 INT, +18 STR", [976] = "+19 INT, +18 STR", [977] = "+18 INT, +19 STR",
    [978] = "+19 INT, +19 STR", [979] = "+20 INT, +19 STR", [980] = "+19 INT, +20 STR",
    [981] = "+20 INT, +20 STR", [982] = "+21 INT, +20 STR", [983] = "+20 INT, +21 STR",
    [984] = "+21 INT, +21 STR", [985] = "+22 INT, +21 STR", [986] = "+21 INT, +22 STR",
    [987] = "+22 INT, +22 STR", [988] = "+23 INT, +22 STR", [989] = "+22 INT, +23 STR",
    [990] = "+23 INT, +23 STR", [991] = "+24 INT, +23 STR", [992] = "+23 INT, +24 STR",
    [993] = "+24 INT, +24 STR", [994] = "+25 INT, +24 STR", [995] = "+24 INT, +25 STR",
    [996] = "+25 INT, +25 STR", [997] = "+26 INT, +25 STR", [998] = "+25 INT, +26 STR",
    [999] = "+26 INT, +26 STR", [1000] = "+27 INT, +26 STR", [1001] = "+26 INT, +27 STR",
    [1002] = "+27 INT, +27 STR", [1003] = "+28 INT, +27 STR", [1004] = "+27 INT, +28 STR",
    [1005] = "+28 INT, +28 STR", [1006] = "+29 INT, +28 STR", [1007] = "+28 INT, +29 STR",
    [1008] = "+29 INT, +29 STR"
}

local suffixOfTheMonkeyLookup = {
    [584] = "+1 AGI, +1 STA", [585] = "+2 AGI, +1 STA", [586] = "+1 AGI, +2 STA",
    [587] = "+2 AGI, +2 STA", [588] = "+3 AGI, +2 STA", [589] = "+2 AGI, +3 STA",
    [590] = "+3 AGI, +3 STA", [591] = "+4 AGI, +3 STA", [592] = "+3 AGI, +4 STA",
    [593] = "+4 AGI, +4 STA", [594] = "+5 AGI, +4 STA", [595] = "+4 AGI, +5 STA",
    [596] = "+5 AGI, +5 STA", [597] = "+6 AGI, +5 STA", [598] = "+5 AGI, +6 STA",
    [599] = "+6 AGI, +6 STA", [600] = "+7 AGI, +6 STA", [601] = "+6 AGI, +7 STA",
    [602] = "+7 AGI, +7 STA", [603] = "+8 AGI, +7 STA", [604] = "+7 AGI, +8 STA",
    [605] = "+8 AGI, +8 STA", [606] = "+9 AGI, +8 STA", [607] = "+8 AGI, +9 STA",
    [608] = "+9 AGI, +9 STA", [609] = "+10 AGI, +9 STA", [610] = "+9 AGI, +10 STA",
    [611] = "+10 AGI, +10 STA", [612] = "+11 AGI, +10 STA", [613] = "+10 AGI, +11 STA",
    [614] = "+11 AGI, +11 STA", [615] = "+12 AGI, +11 STA", [616] = "+11 AGI, +12 STA",
    [617] = "+12 AGI, +12 STA", [618] = "+13 AGI, +12 STA", [619] = "+12 AGI, +13 STA",
    [620] = "+13 AGI, +13 STA", [621] = "+14 AGI, +13 STA", [622] = "+13 AGI, +14 STA",
    [623] = "+14 AGI, +14 STA", [624] = "+15 AGI, +14 STA", [625] = "+14 AGI, +15 STA",
    [626] = "+15 AGI, +15 STA", [627] = "+16 AGI, +15 STA", [628] = "+15 AGI, +16 STA",
    [629] = "+16 AGI, +16 STA", [630] = "+17 AGI, +16 STA", [631] = "+16 AGI, +17 STA",
    [632] = "+17 AGI, +17 STA", [633] = "+18 AGI, +17 STA", [634] = "+17 AGI, +18 STA",
    [635] = "+18 AGI, +18 STA", [636] = "+19 AGI, +18 STA", [637] = "+18 AGI, +19 STA",
    [638] = "+19 AGI, +19 STA", [639] = "+20 AGI, +19 STA", [640] = "+19 AGI, +20 STA",
    [641] = "+20 AGI, +20 STA", [642] = "+21 AGI, +20 STA", [643] = "+20 AGI, +21 STA",
    [644] = "+21 AGI, +21 STA", [645] = "+22 AGI, +21 STA", [646] = "+21 AGI, +22 STA",
    [647] = "+22 AGI, +22 STA", [648] = "+23 AGI, +22 STA", [649] = "+22 AGI, +23 STA",
    [650] = "+23 AGI, +23 STA", [651] = "+24 AGI, +23 STA", [652] = "+23 AGI, +24 STA",
    [653] = "+24 AGI, +24 STA", [654] = "+25 AGI, +24 STA", [655] = "+24 AGI, +25 STA",
    [656] = "+25 AGI, +25 STA", [657] = "+26 AGI, +25 STA", [658] = "+25 AGI, +26 STA",
    [659] = "+26 AGI, +26 STA", [660] = "+27 AGI, +26 STA", [661] = "+26 AGI, +27 STA",
    [662] = "+27 AGI, +27 STA", [663] = "+28 AGI, +27 STA", [664] = "+27 AGI, +28 STA",
    [665] = "+28 AGI, +28 STA", [666] = "+29 AGI, +28 STA", [667] = "+28 AGI, +29 STA",
    [668] = "+29 AGI, +29 STA"
}

local suffixOfTheOwlLookup = {
    [754] = "+1 INT, +1 SPI", [755] = "+2 INT, +1 SPI", [756] = "+1 INT, +2 SPI",
    [757] = "+2 INT, +2 SPI", [758] = "+3 INT, +2 SPI", [759] = "+2 INT, +3 SPI",
    [760] = "+3 INT, +3 SPI", [761] = "+4 INT, +3 SPI", [762] = "+3 INT, +4 SPI",
    [763] = "+4 INT, +4 SPI", [764] = "+5 INT, +4 SPI", [765] = "+4 INT, +5 SPI",
    [766] = "+5 INT, +5 SPI", [767] = "+6 INT, +5 SPI", [768] = "+5 INT, +6 SPI",
    [769] = "+6 INT, +6 SPI", [770] = "+7 INT, +6 SPI", [771] = "+6 INT, +7 SPI",
    [772] = "+7 INT, +7 SPI", [773] = "+8 INT, +7 SPI", [774] = "+7 INT, +8 SPI",
    [775] = "+8 INT, +8 SPI", [776] = "+9 INT, +8 SPI", [777] = "+8 INT, +9 SPI",
    [778] = "+9 INT, +9 SPI", [779] = "+10 INT, +9 SPI", [780] = "+9 INT, +10 SPI",
    [781] = "+10 INT, +10 SPI", [782] = "+11 INT, +10 SPI", [783] = "+10 INT, +11 SPI",
    [784] = "+11 INT, +11 SPI", [785] = "+12 INT, +11 SPI", [786] = "+11 INT, +12 SPI",
    [787] = "+12 INT, +12 SPI", [788] = "+13 INT, +12 SPI", [789] = "+12 INT, +13 SPI",
    [790] = "+13 INT, +13 SPI", [791] = "+14 INT, +13 SPI", [792] = "+13 INT, +14 SPI",
    [793] = "+14 INT, +14 SPI", [794] = "+15 INT, +14 SPI", [795] = "+14 INT, +15 SPI",
    [796] = "+15 INT, +15 SPI", [797] = "+16 INT, +15 SPI", [798] = "+15 INT, +16 SPI",
    [799] = "+16 INT, +16 SPI", [800] = "+17 INT, +16 SPI", [801] = "+16 INT, +17 SPI",
    [802] = "+17 INT, +17 SPI", [803] = "+18 INT, +17 SPI", [804] = "+17 INT, +18 SPI",
    [805] = "+18 INT, +18 SPI", [806] = "+19 INT, +18 SPI", [807] = "+18 INT, +19 SPI",
    [808] = "+19 INT, +19 SPI", [809] = "+20 INT, +19 SPI", [810] = "+19 INT, +20 SPI",
    [811] = "+20 INT, +20 SPI", [812] = "+21 INT, +20 SPI", [813] = "+20 INT, +21 SPI",
    [814] = "+21 INT, +21 SPI", [815] = "+22 INT, +21 SPI", [816] = "+21 INT, +22 SPI",
    [817] = "+22 INT, +22 SPI", [818] = "+23 INT, +22 SPI", [819] = "+22 INT, +23 SPI",
    [820] = "+23 INT, +23 SPI", [821] = "+24 INT, +23 SPI", [822] = "+23 INT, +24 SPI",
    [823] = "+24 INT, +24 SPI", [824] = "+25 INT, +24 SPI", [825] = "+24 INT, +25 SPI",
    [826] = "+25 INT, +25 SPI", [827] = "+26 INT, +25 SPI", [828] = "+25 INT, +26 SPI",
    [829] = "+26 INT, +26 SPI", [830] = "+27 INT, +26 SPI", [831] = "+26 INT, +27 SPI",
    [832] = "+27 INT, +27 SPI", [833] = "+28 INT, +27 SPI", [834] = "+27 INT, +28 SPI",
    [835] = "+28 INT, +28 SPI", [836] = "+29 INT, +28 SPI", [837] = "+28 INT, +29 SPI",
    [838] = "+29 INT, +29 SPI"
}

local suffixOfTheTigerLookup = {
    [669] = "+1 AGI, +1 STR", [670] = "+2 AGI, +1 STR", [671] = "+1 AGI, +2 STR",
    [672] = "+2 AGI, +2 STR", [673] = "+3 AGI, +2 STR", [674] = "+2 AGI, +3 STR",
    [675] = "+3 AGI, +3 STR", [676] = "+4 AGI, +3 STR", [677] = "+3 AGI, +4 STR",
    [678] = "+4 AGI, +4 STR", [679] = "+5 AGI, +4 STR", [680] = "+4 AGI, +5 STR",
    [681] = "+5 AGI, +5 STR", [682] = "+6 AGI, +5 STR", [683] = "+5 AGI, +6 STR",
    [684] = "+6 AGI, +6 STR", [685] = "+7 AGI, +6 STR", [686] = "+6 AGI, +7 STR",
    [687] = "+7 AGI, +7 STR", [688] = "+8 AGI, +7 STR", [689] = "+7 AGI, +8 STR",
    [690] = "+8 AGI, +8 STR", [691] = "+9 AGI, +8 STR", [692] = "+8 AGI, +9 STR",
    [693] = "+9 AGI, +9 STR", [694] = "+10 AGI, +9 STR", [695] = "+9 AGI, +10 STR",
    [696] = "+10 AGI, +10 STR", [697] = "+11 AGI, +10 STR", [698] = "+10 AGI, +11 STR",
    [699] = "+11 AGI, +11 STR", [700] = "+12 AGI, +11 STR", [701] = "+11 AGI, +12 STR",
    [702] = "+12 AGI, +12 STR", [703] = "+13 AGI, +12 STR", [704] = "+12 AGI, +13 STR",
    [705] = "+13 AGI, +13 STR", [706] = "+14 AGI, +13 STR", [707] = "+13 AGI, +14 STR",
    [708] = "+14 AGI, +14 STR", [709] = "+15 AGI, +14 STR", [710] = "+14 AGI, +15 STR",
    [711] = "+15 AGI, +15 STR", [712] = "+16 AGI, +15 STR", [713] = "+15 AGI, +16 STR",
    [714] = "+16 AGI, +16 STR", [715] = "+17 AGI, +16 STR", [716] = "+16 AGI, +17 STR",
    [717] = "+17 AGI, +17 STR", [718] = "+18 AGI, +17 STR", [719] = "+17 AGI, +18 STR",
    [720] = "+18 AGI, +18 STR", [721] = "+19 AGI, +18 STR", [722] = "+18 AGI, +19 STR",
    [723] = "+19 AGI, +19 STR", [724] = "+20 AGI, +19 STR", [725] = "+19 AGI, +20 STR",
    [726] = "+20 AGI, +20 STR", [727] = "+21 AGI, +20 STR", [728] = "+20 AGI, +21 STR",
    [729] = "+21 AGI, +21 STR", [730] = "+22 AGI, +21 STR", [731] = "+21 AGI, +22 STR",
    [732] = "+22 AGI, +22 STR", [733] = "+23 AGI, +22 STR", [734] = "+22 AGI, +23 STR",
    [735] = "+23 AGI, +23 STR", [736] = "+24 AGI, +23 STR", [737] = "+23 AGI, +24 STR",
    [738] = "+24 AGI, +24 STR", [739] = "+25 AGI, +24 STR", [740] = "+25 AGI, +25 STR",
    [741] = "+25 AGI, +25 STR", [742] = "+26 AGI, +25 STR", [743] = "+25 AGI, +26 STR",
    [744] = "+26 AGI, +26 STR", [745] = "+27 AGI, +26 STR", [746] = "+26 AGI, +27 STR",
    [747] = "+27 AGI, +27 STR", [748] = "+28 AGI, +27 STR", [749] = "+27 AGI, +28 STR",
    [750] = "+28 AGI, +28 STR", [751] = "+29 AGI, +28 STR", [752] = "+28 AGI, +29 STR",
    [753] = "+29 AGI, +29 STR"
}

local suffixOfTheWhaleLookup = {
    [1009] = "+1 SPI, +1 STA", [1010] = "+2 SPI, +1 STA", [1011] = "+1 SPI, +2 STA",
    [1012] = "+2 SPI, +2 STA", [1013] = "+3 SPI, +2 STA", [1014] = "+2 SPI, +3 STA",
    [1015] = "+3 SPI, +3 STA", [1016] = "+4 SPI, +3 STA", [1017] = "+3 SPI, +4 STA",
    [1018] = "+4 SPI, +4 STA", [1019] = "+5 SPI, +4 STA", [1020] = "+4 SPI, +5 STA",
    [1021] = "+5 SPI, +5 STA", [1022] = "+6 SPI, +5 STA", [1023] = "+5 SPI, +6 STA",
    [1024] = "+6 SPI, +6 STA", [1025] = "+7 SPI, +6 STA", [1026] = "+6 SPI, +7 STA",
    [1027] = "+7 SPI, +7 STA", [1028] = "+8 SPI, +7 STA", [1029] = "+7 SPI, +8 STA",
    [1030] = "+8 SPI, +8 STA", [1031] = "+9 SPI, +8 STA", [1032] = "+8 SPI, +9 STA",
    [1033] = "+9 SPI, +9 STA", [1034] = "+10 SPI, +9 STA", [1035] = "+9 SPI, +10 STA",
    [1036] = "+10 SPI, +10 STA", [1037] = "+11 SPI, +10 STA", [1038] = "+10 SPI, +11 STA",
    [1039] = "+11 SPI, +11 STA", [1040] = "+12 SPI, +11 STA", [1041] = "+11 SPI, +12 STA",
    [1042] = "+12 SPI, +12 STA", [1043] = "+13 SPI, +12 STA", [1044] = "+12 SPI, +13 STA",
    [1045] = "+13 SPI, +13 STA", [1046] = "+14 SPI, +13 STA", [1047] = "+13 SPI, +14 STA",
    [1048] = "+14 SPI, +14 STA", [1049] = "+15 SPI, +14 STA", [1050] = "+14 SPI, +15 STA",
    [1051] = "+15 SPI, +15 STA", [1052] = "+16 SPI, +15 STA", [1053] = "+15 SPI, +16 STA",
    [1054] = "+16 SPI, +16 STA", [1055] = "+17 SPI, +16 STA", [1056] = "+16 SPI, +17 STA",
    [1057] = "+17 SPI, +17 STA", [1058] = "+18 SPI, +17 STA", [1059] = "+17 SPI, +18 STA",
    [1060] = "+18 SPI, +18 STA", [1061] = "+19 SPI, +18 STA", [1062] = "+18 SPI, +19 STA",
    [1063] = "+19 SPI, +19 STA", [1064] = "+20 SPI, +19 STA", [1065] = "+19 SPI, +20 STA",
    [1066] = "+20 SPI, +20 STA", [1067] = "+21 SPI, +20 STA", [1068] = "+20 SPI, +21 STA",
    [1069] = "+21 SPI, +21 STA", [1070] = "+22 SPI, +21 STA", [1071] = "+21 SPI, +22 STA",
    [1072] = "+22 SPI, +22 STA", [1073] = "+23 SPI, +22 STA", [1074] = "+22 SPI, +23 STA",
    [1075] = "+23 SPI, +23 STA", [1076] = "+24 SPI, +23 STA", [1077] = "+23 SPI, +24 STA",
    [1078] = "+24 SPI, +24 STA", [1079] = "+25 SPI, +24 STA", [1080] = "+24 SPI, +25 STA",
    [1081] = "+25 SPI, +25 STA", [1082] = "+26 SPI, +25 STA", [1083] = "+25 SPI, +26 STA",
    [1084] = "+26 SPI, +26 STA", [1085] = "+27 SPI, +26 STA", [1086] = "+26 SPI, +27 STA",
    [1087] = "+27 SPI, +27 STA", [1088] = "+28 SPI, +27 STA", [1089] = "+27 SPI, +28 STA",
    [1090] = "+28 SPI, +28 STA", [1091] = "+29 SPI, +28 STA", [1092] = "+28 SPI, +29 STA",
    [1093] = "+29 SPI, +29 STA"
}

local suffixOfTheWolfLookup = {
    [228] = "+1 AGI, +1 SPI", [256] = "+2 AGI, +1 SPI",
    [501] = "+1 AGI, +2 SPI", [502] = "+2 AGI, +2 SPI", [503] = "+3 AGI, +2 SPI",
    [504] = "+2 AGI, +3 SPI", [505] = "+3 AGI, +3 SPI", [506] = "+4 AGI, +3 SPI",
    [507] = "+3 AGI, +4 SPI", [508] = "+4 AGI, +4 SPI", [509] = "+5 AGI, +4 SPI",
    [510] = "+4 AGI, +5 SPI", [511] = "+5 AGI, +5 SPI", [512] = "+6 AGI, +5 SPI",
    [513] = "+5 AGI, +6 SPI", [514] = "+6 AGI, +6 SPI", [515] = "+7 AGI, +6 SPI",
    [516] = "+6 AGI, +7 SPI", [517] = "+7 AGI, +7 SPI", [518] = "+8 AGI, +7 SPI",
    [519] = "+7 AGI, +8 SPI", [520] = "+8 AGI, +8 SPI", [521] = "+9 AGI, +8 SPI",
    [522] = "+8 AGI, +9 SPI", [523] = "+9 AGI, +9 SPI", [524] = "+10 AGI, +9 SPI",
    [525] = "+9 AGI, +10 SPI", [526] = "+10 AGI, +10 SPI", [527] = "+11 AGI, +10 SPI",
    [528] = "+10 AGI, +11 SPI", [529] = "+11 AGI, +11 SPI", [530] = "+12 AGI, +11 SPI",
    [531] = "+11 AGI, +12 SPI", [532] = "+12 AGI, +12 SPI", [533] = "+13 AGI, +12 SPI",
    [534] = "+12 AGI, +13 SPI", [535] = "+13 AGI, +13 SPI", [536] = "+14 AGI, +13 SPI",
    [537] = "+13 AGI, +14 SPI", [538] = "+14 AGI, +14 SPI", [539] = "+15 AGI, +14 SPI",
    [540] = "+14 AGI, +15 SPI", [541] = "+15 AGI, +15 SPI", [542] = "+16 AGI, +15 SPI",
    [543] = "+15 AGI, +16 SPI", [544] = "+16 AGI, +16 SPI", [545] = "+17 AGI, +16 SPI",
    [546] = "+16 AGI, +17 SPI", [547] = "+17 AGI, +17 SPI", [548] = "+18 AGI, +17 SPI",
    [549] = "+17 AGI, +18 SPI", [550] = "+18 AGI, +18 SPI", [551] = "+19 AGI, +18 SPI",
    [552] = "+18 AGI, +19 SPI", [553] = "+19 AGI, +19 SPI", [554] = "+20 AGI, +19 SPI",
    [555] = "+19 AGI, +20 SPI", [556] = "+20 AGI, +20 SPI", [557] = "+21 AGI, +20 SPI",
    [558] = "+20 AGI, +21 SPI", [559] = "+21 AGI, +21 SPI", [560] = "+22 AGI, +21 SPI",
    [561] = "+21 AGI, +22 SPI", [562] = "+22 AGI, +22 SPI", [563] = "+23 AGI, +22 SPI",
    [564] = "+22 AGI, +23 SPI", [565] = "+23 AGI, +23 SPI", [566] = "+24 AGI, +23 SPI",
    [567] = "+23 AGI, +24 SPI", [568] = "+24 AGI, +24 SPI", [569] = "+25 AGI, +24 SPI",
    [570] = "+24 AGI, +25 SPI", [571] = "+25 AGI, +25 SPI", [572] = "+26 AGI, +25 SPI",
    [573] = "+25 AGI, +26 SPI", [574] = "+26 AGI, +26 SPI", [575] = "+27 AGI, +26 SPI",
    [576] = "+26 AGI, +27 SPI", [577] = "+27 AGI, +27 SPI", [578] = "+28 AGI, +27 SPI",
    [579] = "+27 AGI, +28 SPI", [580] = "+28 AGI, +28 SPI", [581] = "+29 AGI, +28 SPI",
    [582] = "+28 AGI, +29 SPI", [583] = "+29 AGI, +29 SPI"
}

local suffixOfAgilityLookup = {
    [14] = "+1 AGI", [17] = "+2 AGI", [18] = "+3 AGI",
    [93] = "+4 AGI", [111] = "+5 AGI", [132] = "+6 AGI",
    [151] = "+7 AGI", [167] = "+8 AGI", [168] = "+9 AGI",
    [171] = "+10 AGI", [172] = "+11 AGI", [173] = "+12 AGI",
    [211] = "+13 AGI", [212] = "+14 AGI", [267] = "+15 AGI",
    [358] = "+16 AGI", [359] = "+17 AGI", [360] = "+18 AGI",
    [361] = "+19 AGI", [362] = "+20 AGI", [363] = "+21 AGI",
    [364] = "+22 AGI", [365] = "+23 AGI", [366] = "+24 AGI",
    [367] = "+25 AGI", [368] = "+26 AGI", [369] = "+27 AGI",
    [370] = "+28 AGI", [371] = "+29 AGI", [372] = "+30 AGI",
    [373] = "+31 AGI", [374] = "+32 AGI", [375] = "+33 AGI",
    [376] = "+34 AGI", [377] = "+35 AGI", [378] = "+36 AGI",
    [379] = "+37 AGI", [380] = "+38 AGI", [381] = "+39 AGI",
    [382] = "+40 AGI", [1279] = "+41 AGI", [1280] = "+42 AGI",
    [1281] = "+43 AGI", [1282] = "+44 AGI", [1283] = "+45 AGI",
    [1284] = "+46 AGI"
}

local suffixOfDefenseLookup = {
    [48] = "+1 DEF", [62] = "+1 DEF", [74] = "+2 DEF",
    [89] = "+3 DEF", [108] = "+3 DEF", [128] = "+4 DEF",
    [147] = "+5 DEF", [1607] = "+8 DEF", [1608] = "+5 DEF",
    [1609] = "+6 DEF", [1610] = "+7 DEF", [1611] = "+7 DEF",
    [1612] = "+9 DEF", [1613] = "+9 DEF", [1614] = "+10 DEF",
    [1615] = "+11 DEF", [1616] = "+13 DEF", [1617] = "+15 DEF",
    [1618] = "+17 DEF", [1619] = "+21 DEF", [1620] = "+11 DEF",
    [1621] = "+12 DEF", [1622] = "+13 DEF", [1623] = "+14 DEF",
    [1624] = "+15 DEF", [1625] = "+16 DEF", [1626] = "+17 DEF",
    [1627] = "+18 DEF", [1628] = "+19 DEF", [1629] = "+19 DEF",
    [1630] = "+20 DEF", [1631] = "+21 DEF", [1632] = "+22 DEF",
    [1633] = "+23 DEF", [1634] = "+23 DEF", [1635] = "+24 DEF",
    [1636] = "+25 DEF", [1637] = "+25 DEF"
}

local suffixOfIntellectLookup = {
    [5] = "+1 INT", [25] = "+2 INT", [26] = "+3 INT",
    [94] = "+4 INT", [112] = "+5 INT", [133] = "+6 INT",
    [152] = "+7 INT", [174] = "+8 INT", [175] = "+9 INT",
    [176] = "+10 INT", [177] = "+11 INT", [178] = "+12 INT",
    [213] = "+13 INT", [214] = "+14 INT", [383] = "+15 INT",
    [384] = "+16 INT", [385] = "+17 INT", [386] = "+18 INT",
    [387] = "+19 INT", [388] = "+20 INT", [389] = "+21 INT",
    [390] = "+22 INT", [391] = "+23 INT", [392] = "+24 INT",
    [393] = "+25 INT", [394] = "+26 INT", [395] = "+27 INT",
    [396] = "+28 INT", [397] = "+29 INT", [398] = "+30 INT",
    [399] = "+31 INT", [400] = "+32 INT", [401] = "+33 INT",
    [402] = "+34 INT", [403] = "+35 INT", [404] = "+36 INT",
    [405] = "+37 INT", [406] = "+38 INT", [407] = "+39 INT",
    [408] = "+40 INT", [1285] = "+41 INT", [1286] = "+42 INT",
    [1287] = "+43 INT", [1288] = "+44 INT", [1289] = "+45 INT",
    [1290] = "+46 INT"
}

local suffixOfSpiritLookup = {
    [16] = "+1 SPI", [27] = "+2 SPI", [28] = "+3 SPI",
    [95] = "+4 SPI", [113] = "+5 SPI", [134] = "+6 SPI",
    [153] = "+7 SPI", [179] = "+8 SPI", [180] = "+9 SPI",
    [181] = "+10 SPI", [182] = "+11 SPI", [183] = "+12 SPI",
    [215] = "+13 SPI", [216] = "+14 SPI", [409] = "+15 SPI",
    [410] = "+16 SPI", [411] = "+17 SPI", [412] = "+18 SPI",
    [413] = "+19 SPI", [414] = "+20 SPI", [415] = "+21 SPI",
    [416] = "+22 SPI", [417] = "+23 SPI", [418] = "+24 SPI",
    [419] = "+25 SPI", [420] = "+26 SPI", [421] = "+27 SPI",
    [422] = "+28 SPI", [423] = "+29 SPI", [424] = "+30 SPI",
    [425] = "+31 SPI", [426] = "+32 SPI", [427] = "+33 SPI",
    [428] = "+34 SPI", [429] = "+36 SPI", [430] = "+37 SPI",
    [431] = "+38 SPI", [432] = "+39 SPI", [433] = "+40 SPI",
    [434] = "+35 SPI", [1291] = "+41 SPI", [1292] = "+42 SPI",
    [1293] = "+43 SPI", [1294] = "+44 SPI", [1295] = "+45 SPI",
    [1296] = "+46 SPI"
}

local suffixOfStaminaLookup = {
    [15] = "+1 STA", [19] = "+2 STA", [22] = "+3 STA",
    [96] = "+4 STA", [114] = "+5 STA", [135] = "+6 STA",
    [154] = "+7 STA", [184] = "+8 STA", [185] = "+9 STA",
    [186] = "+10 STA", [187] = "+11 STA", [188] = "+12 STA",
    [217] = "+13 STA", [218] = "+14 STA", [287] = "+15 STA",
    [333] = "+16 STA", [334] = "+17 STA", [335] = "+18 STA",
    [336] = "+19 STA", [337] = "+20 STA", [338] = "+21 STA",
    [339] = "+22 STA", [340] = "+23 STA", [341] = "+24 STA",
    [342] = "+25 STA", [343] = "+26 STA", [344] = "+27 STA",
    [345] = "+28 STA", [346] = "+29 STA", [347] = "+30 STA",
    [348] = "+31 STA", [349] = "+32 STA", [350] = "+33 STA",
    [351] = "+34 STA", [352] = "+35 STA", [353] = "+36 STA",
    [354] = "+37 STA", [355] = "+38 STA", [356] = "+39 STA",
    [357] = "+40 STA", [1267] = "+41 STA", [1268] = "+42 STA",
    [1269] = "+43 STA", [1270] = "+44 STA", [1271] = "+45 STA",
    [1272] = "+46 STA"
}

local suffixOfStrengthLookup = {
    [6] = "+1 STR", [23] = "+2 STR", [24] = "+3 STR",
    [97] = "+4 STR", [115] = "+5 STR", [136] = "+6 STR",
    [155] = "+7 STR", [189] = "+8 STR", [190] = "+9 STR",
    [191] = "+10 STR", [192] = "+11 STR", [193] = "+12 STR",
    [219] = "+13 STR", [220] = "+14 STR", [307] = "+15 STR",
    [308] = "+16 STR", [309] = "+17 STR", [310] = "+18 STR",
    [311] = "+19 STR", [312] = "+20 STR", [313] = "+21 STR",
    [314] = "+22 STR", [315] = "+23 STR", [316] = "+24 STR",
    [317] = "+25 STR", [318] = "+26 STR", [319] = "+27 STR",
    [320] = "+28 STR", [321] = "+29 STR", [322] = "+30 STR",
    [323] = "+31 STR", [324] = "+32 STR", [325] = "+33 STR",
    [326] = "+34 STR", [327] = "+35 STR", [328] = "+36 STR",
    [329] = "+37 STR", [330] = "+38 STR", [331] = "+39 STR",
    [332] = "+40 STR", [1273] = "+41 STR", [1274] = "+42 STR",
    [1275] = "+43 STR", [1276] = "+44 STR", [1277] = "+45 STR",
    [1278] = "+46 STR"
}

local suffixOfArcaneResistanceLookup = {
    [1307] = "+1 Arcane Resistance", [1308] = "+2 Arcane Resistance", [1309] = "+3 Arcane Resistance",
    [1310] = "+4 Arcane Resistance", [1311] = "+5 Arcane Resistance", [1312] = "+6 Arcane Resistance",
    [1313] = "+7 Arcane Resistance", [1314] = "+8 Arcane Resistance", [1315] = "+9 Arcane Resistance",
    [1316] = "+10 Arcane Resistance", [1317] = "+11 Arcane Resistance", [1318] = "+12 Arcane Resistance",
    [1319] = "+13 Arcane Resistance", [1320] = "+14 Arcane Resistance", [1321] = "+15 Arcane Resistance",
    [1322] = "+16 Arcane Resistance", [1323] = "+17 Arcane Resistance", [1324] = "+18 Arcane Resistance",
    [1325] = "+19 Arcane Resistance", [1326] = "+20 Arcane Resistance", [1327] = "+21 Arcane Resistance",
    [1328] = "+22 Arcane Resistance", [1329] = "+23 Arcane Resistance", [1330] = "+24 Arcane Resistance",
    [1331] = "+25 Arcane Resistance", [1332] = "+26 Arcane Resistance", [1333] = "+27 Arcane Resistance",
    [1334] = "+28 Arcane Resistance", [1335] = "+29 Arcane Resistance", [1336] = "+30 Arcane Resistance",
    [1337] = "+31 Arcane Resistance", [1338] = "+32 Arcane Resistance", [1339] = "+33 Arcane Resistance",
    [1340] = "+34 Arcane Resistance", [1341] = "+35 Arcane Resistance", [1342] = "+36 Arcane Resistance",
    [1343] = "+37 Arcane Resistance", [1344] = "+38 Arcane Resistance", [1345] = "+39 Arcane Resistance",
    [1346] = "+40 Arcane Resistance", [1347] = "+41 Arcane Resistance", [1348] = "+42 Arcane Resistance",
    [1349] = "+43 Arcane Resistance", [1350] = "+44 Arcane Resistance", [1351] = "+45 Arcane Resistance",
    [1352] = "+46 Arcane Resistance"
}

local suffixOfFireResistanceLookup = {
    [1399] = "+1 Fire Resistance", [1400] = "+2 Fire Resistance", [1401] = "+3 Fire Resistance",
    [1402] = "+4 Fire Resistance", [1403] = "+5 Fire Resistance", [1404] = "+6 Fire Resistance",
    [1405] = "+7 Fire Resistance", [1406] = "+8 Fire Resistance", [1407] = "+9 Fire Resistance",
    [1408] = "+10 Fire Resistance", [1409] = "+11 Fire Resistance", [1410] = "+12 Fire Resistance",
    [1411] = "+13 Fire Resistance", [1412] = "+14 Fire Resistance", [1413] = "+15 Fire Resistance",
    [1414] = "+16 Fire Resistance", [1415] = "+17 Fire Resistance", [1416] = "+18 Fire Resistance",
    [1417] = "+19 Fire Resistance", [1418] = "+20 Fire Resistance", [1419] = "+21 Fire Resistance",
    [1420] = "+22 Fire Resistance", [1421] = "+23 Fire Resistance", [1422] = "+24 Fire Resistance",
    [1423] = "+25 Fire Resistance", [1424] = "+26 Fire Resistance", [1425] = "+27 Fire Resistance",
    [1426] = "+28 Fire Resistance", [1427] = "+29 Fire Resistance", [1428] = "+30 Fire Resistance",
    [1429] = "+31 Fire Resistance", [1430] = "+32 Fire Resistance", [1431] = "+33 Fire Resistance",
    [1432] = "+34 Fire Resistance", [1433] = "+35 Fire Resistance", [1434] = "+36 Fire Resistance",
    [1435] = "+37 Fire Resistance", [1436] = "+38 Fire Resistance", [1437] = "+39 Fire Resistance",
    [1438] = "+40 Fire Resistance", [1439] = "+41 Fire Resistance", [1440] = "+42 Fire Resistance",
    [1441] = "+43 Fire Resistance", [1442] = "+44 Fire Resistance", [1443] = "+45 Fire Resistance",
    [1444] = "+46 Fire Resistance"
}

local suffixOfFrostResistanceLookup = {
    [1353] = "+1 Frost Resistance", [1354] = "+2 Frost Resistance", [1355] = "+3 Frost Resistance",
    [1356] = "+4 Frost Resistance", [1357] = "+5 Frost Resistance", [1358] = "+6 Frost Resistance",
    [1359] = "+7 Frost Resistance", [1360] = "+8 Frost Resistance", [1361] = "+9 Frost Resistance",
    [1362] = "+10 Frost Resistance", [1363] = "+11 Frost Resistance", [1364] = "+12 Frost Resistance",
    [1365] = "+13 Frost Resistance", [1366] = "+14 Frost Resistance", [1367] = "+15 Frost Resistance",
    [1368] = "+16 Frost Resistance", [1369] = "+17 Frost Resistance", [1370] = "+18 Frost Resistance",
    [1371] = "+19 Frost Resistance", [1372] = "+20 Frost Resistance", [1373] = "+21 Frost Resistance",
    [1374] = "+22 Frost Resistance", [1375] = "+23 Frost Resistance", [1376] = "+24 Frost Resistance",
    [1377] = "+25 Frost Resistance", [1378] = "+26 Frost Resistance", [1379] = "+27 Frost Resistance",
    [1380] = "+28 Frost Resistance", [1381] = "+29 Frost Resistance", [1382] = "+30 Frost Resistance",
    [1383] = "+31 Frost Resistance", [1384] = "+32 Frost Resistance", [1385] = "+33 Frost Resistance",
    [1386] = "+34 Frost Resistance", [1387] = "+35 Frost Resistance", [1388] = "+36 Frost Resistance",
    [1389] = "+37 Frost Resistance", [1390] = "+38 Frost Resistance", [1391] = "+39 Frost Resistance",
    [1392] = "+40 Frost Resistance", [1393] = "+41 Frost Resistance", [1394] = "+42 Frost Resistance",
    [1395] = "+43 Frost Resistance", [1396] = "+44 Frost Resistance", [1397] = "+45 Frost Resistance",
    [1398] = "+46 Frost Resistance"
}

local suffixOfNatureResistanceLookup = {
    [1491] = "+1 Nature Resistance", [1492] = "+2 Nature Resistance", [1493] = "+3 Nature Resistance",
    [1494] = "+4 Nature Resistance", [1495] = "+5 Nature Resistance", [1496] = "+6 Nature Resistance",
    [1497] = "+7 Nature Resistance", [1498] = "+8 Nature Resistance", [1499] = "+9 Nature Resistance",
    [1500] = "+10 Nature Resistance", [1501] = "+11 Nature Resistance", [1502] = "+12 Nature Resistance",
    [1503] = "+13 Nature Resistance", [1504] = "+14 Nature Resistance", [1505] = "+15 Nature Resistance",
    [1506] = "+16 Nature Resistance", [1507] = "+17 Nature Resistance", [1508] = "+18 Nature Resistance",
    [1509] = "+19 Nature Resistance", [1510] = "+20 Nature Resistance", [1511] = "+21 Nature Resistance",
    [1512] = "+22 Nature Resistance", [1513] = "+23 Nature Resistance", [1514] = "+24 Nature Resistance",
    [1515] = "+25 Nature Resistance", [1516] = "+26 Nature Resistance", [1517] = "+27 Nature Resistance",
    [1518] = "+28 Nature Resistance", [1519] = "+29 Nature Resistance", [1520] = "+30 Nature Resistance",
    [1521] = "+31 Nature Resistance", [1522] = "+32 Nature Resistance", [1523] = "+33 Nature Resistance",
    [1524] = "+34 Nature Resistance", [1525] = "+35 Nature Resistance", [1526] = "+36 Nature Resistance",
    [1527] = "+37 Nature Resistance", [1528] = "+38 Nature Resistance", [1529] = "+39 Nature Resistance",
    [1530] = "+40 Nature Resistance", [1531] = "+41 Nature Resistance", [1532] = "+42 Nature Resistance",
    [1533] = "+43 Nature Resistance", [1534] = "+44 Nature Resistance", [1535] = "+45 Nature Resistance",
    [1536] = "+46 Nature Resistance"
}

local suffixOfShadowResistanceLookup = {
    [1445] = "+1 Shadow Resistance", [1446] = "+2 Shadow Resistance", [1447] = "+3 Shadow Resistance",
    [1448] = "+4 Shadow Resistance", [1449] = "+5 Shadow Resistance", [1450] = "+6 Shadow Resistance",
    [1451] = "+7 Shadow Resistance", [1452] = "+8 Shadow Resistance", [1453] = "+9 Shadow Resistance",
    [1454] = "+10 Shadow Resistance", [1455] = "+11 Shadow Resistance", [1456] = "+12 Shadow Resistance",
    [1457] = "+13 Shadow Resistance", [1458] = "+14 Shadow Resistance", [1459] = "+15 Shadow Resistance",
    [1460] = "+16 Shadow Resistance", [1461] = "+17 Shadow Resistance", [1462] = "+18 Shadow Resistance",
    [1463] = "+19 Shadow Resistance", [1464] = "+20 Shadow Resistance", [1465] = "+21 Shadow Resistance",
    [1466] = "+22 Shadow Resistance", [1467] = "+23 Shadow Resistance", [1468] = "+24 Shadow Resistance",
    [1469] = "+25 Shadow Resistance", [1470] = "+26 Shadow Resistance", [1471] = "+27 Shadow Resistance",
    [1472] = "+28 Shadow Resistance", [1473] = "+29 Shadow Resistance", [1474] = "+30 Shadow Resistance",
    [1475] = "+31 Shadow Resistance", [1476] = "+32 Shadow Resistance", [1477] = "+33 Shadow Resistance",
    [1478] = "+34 Shadow Resistance", [1479] = "+35 Shadow Resistance", [1480] = "+36 Shadow Resistance",
    [1481] = "+37 Shadow Resistance", [1482] = "+38 Shadow Resistance", [1483] = "+39 Shadow Resistance",
    [1484] = "+40 Shadow Resistance", [1485] = "+41 Shadow Resistance", [1486] = "+42 Shadow Resistance",
    [1487] = "+43 Shadow Resistance", [1488] = "+44 Shadow Resistance", [1489] = "+45 Shadow Resistance",
    [1490] = "+46 Shadow Resistance"
}

local suffixOfArcaneWrathLookup = {
    [1799] = "+1 Arcane DMG", [1800] = "+3 Arcane DMG", [1801] = "+4 Arcane DMG",
    [1802] = "+6 Arcane DMG", [1803] = "+7 Arcane DMG", [1804] = "+9 Arcane DMG",
    [1805] = "+10 Arcane DMG", [1806] = "+11 Arcane DMG", [1807] = "+13 Arcane DMG",
    [1808] = "+14 Arcane DMG", [1809] = "+16 Arcane DMG", [1810] = "+17 Arcane DMG",
    [1811] = "+19 Arcane DMG", [1812] = "+20 Arcane DMG", [1813] = "+21 Arcane DMG",
    [1814] = "+23 Arcane DMG", [1815] = "+24 Arcane DMG", [1816] = "+26 Arcane DMG",
    [1817] = "+27 Arcane DMG", [1818] = "+29 Arcane DMG", [1819] = "+30 Arcane DMG",
    [1820] = "+31 Arcane DMG", [1821] = "+33 Arcane DMG", [1822] = "+34 Arcane DMG",
    [1823] = "+36 Arcane DMG", [1824] = "+37 Arcane DMG", [1825] = "+39 Arcane DMG",
    [1826] = "+40 Arcane DMG", [1827] = "+41 Arcane DMG", [1828] = "+43 Arcane DMG",
    [1829] = "+44 Arcane DMG", [1830] = "+46 Arcane DMG", [1831] = "+47 Arcane DMG",
    [1832] = "+49 Arcane DMG", [1833] = "+50 Arcane DMG", [1834] = "+51 Arcane DMG",
    [1835] = "+53 Arcane DMG", [1836] = "+54 Arcane DMG"
}

local suffixOfFieryWrathLookup = {
    [1875] = "+1 Fire DMG", [1876] = "+3 Fire DMG", [1877] = "+4 Fire DMG",
    [1878] = "+6 Fire DMG", [1879] = "+7 Fire DMG", [1880] = "+9 Fire DMG",
    [1881] = "+10 Fire DMG", [1882] = "+11 Fire DMG", [1883] = "+13 Fire DMG",
    [1884] = "+14 Fire DMG", [1885] = "+16 Fire DMG", [1886] = "+17 Fire DMG",
    [1887] = "+19 Fire DMG", [1888] = "+20 Fire DMG", [1889] = "+21 Fire DMG",
    [1890] = "+23 Fire DMG", [1891] = "+24 Fire DMG", [1892] = "+26 Fire DMG",
    [1893] = "+27 Fire DMG", [1894] = "+29 Fire DMG", [1895] = "+30 Fire DMG",
    [1896] = "+31 Fire DMG", [1897] = "+33 Fire DMG", [1898] = "+34 Fire DMG",
    [1899] = "+36 Fire DMG", [1900] = "+37 Fire DMG", [1901] = "+39 Fire DMG",
    [1902] = "+40 Fire DMG", [1903] = "+41 Fire DMG", [1904] = "+43 Fire DMG",
    [1905] = "+44 Fire DMG", [1906] = "+46 Fire DMG", [1907] = "+47 Fire DMG",
    [1908] = "+49 Fire DMG", [1909] = "+50 Fire DMG", [1910] = "+51 Fire DMG",
    [1911] = "+53 Fire DMG", [1912] = "+54 Fire DMG"
}

local suffixOfFrozenWrathLookup = {
    [1951] = "+1 Frost DMG", [1952] = "+3 Frost DMG", [1953] = "+4 Frost DMG",
    [1954] = "+6 Frost DMG", [1955] = "+7 Frost DMG", [1956] = "+9 Frost DMG",
    [1957] = "+10 Frost DMG", [1958] = "+11 Frost DMG", [1959] = "+13 Frost DMG",
    [1960] = "+14 Frost DMG", [1961] = "+16 Frost DMG", [1962] = "+17 Frost DMG",
    [1963] = "+19 Frost DMG", [1964] = "+20 Frost DMG", [1965] = "+21 Frost DMG",
    [1966] = "+23 Frost DMG", [1967] = "+24 Frost DMG", [1968] = "+26 Frost DMG",
    [1969] = "+27 Frost DMG", [1970] = "+29 Frost DMG", [1971] = "+30 Frost DMG",
    [1972] = "+31 Frost DMG", [1973] = "+33 Frost DMG", [1974] = "+34 Frost DMG",
    [1975] = "+36 Frost DMG", [1976] = "+37 Frost DMG", [1977] = "+39 Frost DMG",
    [1978] = "+40 Frost DMG", [1979] = "+41 Frost DMG", [1980] = "+43 Frost DMG",
    [1981] = "+44 Frost DMG", [1982] = "+46 Frost DMG", [1983] = "+47 Frost DMG",
    [1984] = "+49 Frost DMG", [1985] = "+50 Frost DMG", [1986] = "+51 Frost DMG",
    [1987] = "+53 Frost DMG", [1988] = "+54 Frost DMG"
}

local suffixOfHolyWrathLookup = {
    [1913] = "+1 Holy DMG", [1914] = "+3 Holy DMG", [1915] = "+4 Holy DMG",
    [1916] = "+6 Holy DMG", [1917] = "+7 Holy DMG", [1918] = "+9 Holy DMG",
    [1919] = "+10 Holy DMG", [1920] = "+11 Holy DMG", [1921] = "+13 Holy DMG",
    [1922] = "+14 Holy DMG", [1923] = "+16 Holy DMG", [1924] = "+17 Holy DMG",
    [1925] = "+19 Holy DMG", [1926] = "+20 Holy DMG", [1927] = "+21 Holy DMG",
    [1928] = "+23 Holy DMG", [1929] = "+24 Holy DMG", [1930] = "+26 Holy DMG",
    [1931] = "+27 Holy DMG", [1932] = "+29 Holy DMG", [1933] = "+30 Holy DMG",
    [1934] = "+31 Holy DMG", [1935] = "+33 Holy DMG", [1936] = "+34 Holy DMG",
    [1937] = "+36 Holy DMG", [1938] = "+37 Holy DMG", [1939] = "+39 Holy DMG",
    [1940] = "+40 Holy DMG", [1941] = "+41 Holy DMG", [1942] = "+43 Holy DMG",
    [1943] = "+44 Holy DMG", [1944] = "+46 Holy DMG", [1945] = "+47 Holy DMG",
    [1946] = "+49 Holy DMG", [1947] = "+50 Holy DMG", [1948] = "+51 Holy DMG",
    [1949] = "+53 Holy DMG", [1950] = "+54 Holy DMG"
}

local suffixOfNaturesWrathLookup = {
    [1989] = "+1 Nature DMG", [1990] = "+3 Nature DMG", [1991] = "+4 Nature DMG",
    [1992] = "+6 Nature DMG", [1993] = "+7 Nature DMG", [1994] = "+9 Nature DMG",
    [1995] = "+10 Nature DMG", [1996] = "+11 Nature DMG", [1997] = "+13 Nature DMG",
    [1998] = "+14 Nature DMG", [1999] = "+16 Nature DMG", [2000] = "+17 Nature DMG",
    [2001] = "+19 Nature DMG", [2002] = "+20 Nature DMG", [2003] = "+21 Nature DMG",
    [2004] = "+23 Nature DMG", [2005] = "+24 Nature DMG", [2006] = "+26 Nature DMG",
    [2007] = "+27 Nature DMG", [2008] = "+29 Nature DMG", [2009] = "+30 Nature DMG",
    [2010] = "+31 Nature DMG", [2011] = "+33 Nature DMG", [2012] = "+34 Nature DMG",
    [2013] = "+36 Nature DMG", [2014] = "+37 Nature DMG", [2015] = "+39 Nature DMG",
    [2016] = "+40 Nature DMG", [2017] = "+41 Nature DMG", [2018] = "+43 Nature DMG",
    [2019] = "+44 Nature DMG", [2020] = "+46 Nature DMG", [2021] = "+47 Nature DMG",
    [2022] = "+49 Nature DMG", [2023] = "+50 Nature DMG", [2024] = "+51 Nature DMG",
    [2025] = "+53 Nature DMG", [2026] = "+54 Nature DMG"
}

local suffixOfShadowWrathLookup = {
    [1837] = "+1 Shadow DMG", [1838] = "+3 Shadow DMG", [1839] = "+4 Shadow DMG",
    [1840] = "+6 Shadow DMG", [1841] = "+7 Shadow DMG", [1842] = "+9 Shadow DMG",
    [1843] = "+10 Shadow DMG", [1844] = "+11 Shadow DMG", [1845] = "+13 Shadow DMG",
    [1846] = "+14 Shadow DMG", [1847] = "+16 Shadow DMG", [1848] = "+17 Shadow DMG",
    [1849] = "+19 Shadow DMG", [1850] = "+20 Shadow DMG", [1851] = "+21 Shadow DMG",
    [1852] = "+23 Shadow DMG", [1853] = "+24 Shadow DMG", [1854] = "+26 Shadow DMG",
    [1855] = "+27 Shadow DMG", [1856] = "+29 Shadow DMG", [1857] = "+30 Shadow DMG",
    [1858] = "+31 Shadow DMG", [1859] = "+33 Shadow DMG", [1860] = "+34 Shadow DMG",
    [1861] = "+36 Shadow DMG", [1862] = "+37 Shadow DMG", [1863] = "+39 Shadow DMG",
    [1864] = "+40 Shadow DMG", [1865] = "+41 Shadow DMG", [1866] = "+43 Shadow DMG",
    [1867] = "+44 Shadow DMG", [1868] = "+46 Shadow DMG", [1869] = "+47 Shadow DMG",
    [1870] = "+49 Shadow DMG", [1871] = "+50 Shadow DMG", [1872] = "+51 Shadow DMG",
    [1873] = "+53 Shadow DMG", [1874] = "+54 Shadow DMG"
}

local suffixOfBlockingLookup = {
    [1647] = "+1% Block", [1648] = "+1% Block, +1 STR", [1649] = "+1% Block, +1 STR",
    [1650] = "+1% Block, +2 STR", [1651] = "+1% Block, +2 STR", [1652] = "+1% Block, +3 STR",
    [1653] = "+1% Block, +3 STR", [1654] = "+1% Block, +4 STR", [1655] = "+1% Block, +4 STR",
    [1656] = "+1% Block, +5 STR", [1657] = "+2% Block, +5 STR", [1658] = "+2% Block, +6 STR",
    [1659] = "+2% Block, +6 STR", [1660] = "+2% Block, +7 STR", [1661] = "+2% Block, +7 STR",
    [1662] = "+2% Block, +8 STR", [1663] = "+2% Block, +8 STR", [1664] = "+2% Block, +9 STR",
    [1665] = "+2% Block, +9 STR", [1666] = "+2% Block, +9 STR", [1667] = "+3% Block, +9 STR",
    [1668] = "+3% Block, +10 STR", [1669] = "+3% Block, +10 STR", [1670] = "+3% Block, +10 STR",
    [1671] = "+3% Block, +10 STR", [1672] = "+3% Block, +11 STR", [1673] = "+3% Block, +11 STR",
    [1674] = "+3% Block, +12 STR", [1675] = "+3% Block, +12 STR", [1676] = "+3% Block, +12 STR",
    [1677] = "+4% Block, +12 STR", [1678] = "+4% Block, +12 STR", [1679] = "+4% Block, +12 STR",
    [1680] = "+4% Block, +12 STR", [1681] = "+4% Block, +12 STR", [1682] = "+4% Block, +13 STR",
    [1683] = "+4% Block, +13 STR", [1684] = "+4% Block, +14 STR", [1685] = "+4% Block, +14 STR",
    [1686] = "+4% Block, +14 STR", [1687] = "+4% Block, +14 STR", [1688] = "+4% Block, +15 STR",
    [1689] = "+4% Block, +15 STR", [1690] = "+4% Block, +16 STR", [1691] = "+4% Block, +16 STR",
    [1692] = "+4% Block, +16 STR", [1693] = "+4% Block, +16 STR", [1694] = "+4% Block, +17 STR",
    [1695] = "+4% Block, +17 STR", [1696] = "+4% Block, +18 STR", [1697] = "+4% Block, +18 STR",
    [1698] = "+4% Block, +18 STR", [1699] = "+4% Block, +18 STR", [1700] = "+4% Block, +19 STR",
    [1701] = "+4% Block, +19 STR", [1702] = "+4% Block, +20 STR", [1703] = "+4% Block, +20 STR"
}

local suffixOfBeastSlayingLookup = {
    [49] = "+2 DMG to Beasts", [64] = "+4 DMG to Beasts",
    [76] = "+6 DMG to Beasts", [91] = "+8 DMG to Beasts",
    [110] = "+10 DMG to Beasts", [130] = "+12 DMG to Beasts",
    [149] = "+14 DMG to Beasts"
}

local suffixOfConcentrationLookup = {
    [2067] = "+1 MP5", [2068] = "+1 MP5", [2069] = "+1 MP5",
    [2070] = "+2 MP5", [2071] = "+2 MP5", [2072] = "+2 MP5",
    [2073] = "+3 MP5", [2074] = "+3 MP5", [2075] = "+4 MP5",
    [2076] = "+4 MP5", [2077] = "+4 MP5", [2078] = "+5 MP5",
    [2079] = "+5 MP5", [2080] = "+6 MP5", [2081] = "+6 MP5",
    [2082] = "+6 MP5", [2083] = "+7 MP5", [2084] = "+7 MP5",
    [2085] = "+8 MP5", [2086] = "+8 MP5", [2087] = "+8 MP5",
    [2088] = "+9 MP5", [2089] = "+9 MP5", [2090] = "+10 MP5",
    [2091] = "+10 MP5", [2092] = "+10 MP5", [2093] = "+11 MP5",
    [2094] = "+11 MP5", [2095] = "+12 MP5", [2096] = "+12 MP5",
    [2097] = "+12 MP5", [2098] = "+13 MP5", [2099] = "+13 MP5",
    [2100] = "+14 MP5", [2101] = "+14 MP5", [2102] = "+14 MP5",
    [2103] = "+15 MP5", [2104] = "+15 MP5"
}

local suffixOfEludingLookup = {
    [1742] = "+1% Dodge", [1743] = "+1% Dodge", [1744] = "+1% Dodge",
    [1745] = "+1% Dodge", [1746] = "+1% Dodge", [1747] = "+1% Dodge",
    [1748] = "+1% Dodge, +1 AGI", [1749] = "+1% Dodge, +1 AGI", [1750] = "+1% Dodge, +1 AGI",
    [1751] = "+1% Dodge, +2 AGI", [1752] = "+1% Dodge, +2 AGI", [1753] = "+1% Dodge, +2 AGI",
    [1754] = "+1% Dodge, +3 AGI", [1755] = "+1% Dodge, +3 AGI", [1756] = "+1% Dodge, +3 AGI",
    [1757] = "+1% Dodge, +4 AGI", [1758] = "+1% Dodge, +4 AGI", [1759] = "+1% Dodge, +4 AGI",
    [1760] = "+1% Dodge, +5 AGI", [1761] = "+1% Dodge, +5 AGI", [1762] = "+1% Dodge, +5 AGI",
    [1763] = "+1% Dodge, +6 AGI", [1764] = "+1% Dodge, +6 AGI", [1765] = "+1% Dodge, +6 AGI",
    [1766] = "+1% Dodge, +7 AGI", [1767] = "+1% Dodge, +7 AGI", [1768] = "+1% Dodge, +7 AGI",
    [1769] = "+1% Dodge, +8 AGI", [1770] = "+1% Dodge, +8 AGI", [1771] = "+1% Dodge, +8 AGI",
    [1772] = "+1% Dodge, +9 AGI", [1773] = "+1% Dodge, +9 AGI", [1774] = "+1% Dodge, +9 AGI",
    [1775] = "+1% Dodge, +9 AGI", [1776] = "+1% Dodge, +9 AGI", [1777] = "+1% Dodge, +9 AGI",
    [1778] = "+1% Dodge, +9 AGI", [1779] = "+1% Dodge, +9 AGI", [1780] = "+1% Dodge, +10 AGI",
    [1781] = "+1% Dodge, +10 AGI", [1782] = "+1% Dodge, +10 AGI", [1783] = "+1% Dodge, +11 AGI",
    [1784] = "+1% Dodge, +11 AGI", [1785] = "+1% Dodge, +11 AGI", [1786] = "+1% Dodge, +12 AGI",
    [1787] = "+1% Dodge, +12 AGI", [1788] = "+1% Dodge, +12 AGI", [1789] = "+1% Dodge, +12 AGI",
    [1790] = "+1% Dodge, +13 AGI", [1791] = "+1% Dodge, +13 AGI", [1792] = "+1% Dodge, +13 AGI",
    [1793] = "+1% Dodge, +14 AGI", [1794] = "+1% Dodge, +14 AGI", [1795] = "+1% Dodge, +14 AGI",
    [1796] = "+1% Dodge, +14 AGI", [1797] = "+1% Dodge, +15 AGI", [1798] = "+1% Dodge, +15 AGI"
}

local suffixOfHealingLookup = {
    [2027] = "+2 to Heals", [2028] = "+4 to Heals", [2029] = "+7 to Heals",
    [2030] = "+9 to Heals", [2031] = "+11 to Heals", [2032] = "+13 to Heals",
    [2033] = "+15 to Heals", [2034] = "+18 to Heals", [2035] = "+20 to Heals",
    [2036] = "+22 to Heals", [2037] = "+24 to Heals", [2038] = "+26 to Heals",
    [2039] = "+29 to Heals", [2040] = "+31 to Heals", [2041] = "+33 to Heals",
    [2042] = "+35 to Heals", [2043] = "+37 to Heals", [2044] = "+40 to Heals",
    [2045] = "+42 to Heals", [2046] = "+44 to Heals", [2047] = "+46 to Heals",
    [2048] = "+48 to Heals", [2049] = "+51 to Heals", [2050] = "+53 to Heals",
    [2051] = "+55 to Heals", [2052] = "+57 to Heals", [2053] = "+59 to Heals",
    [2054] = "+62 to Heals", [2055] = "+64 to Heals", [2056] = "+66 to Heals",
    [2057] = "+68 to Heals", [2058] = "+70 to Heals", [2059] = "+73 to Heals",
    [2060] = "+75 to Heals", [2061] = "+77 to Heals", [2062] = "+79 to Heals",
    [2063] = "+81 to Heals", [2064] = "+84 to Heals"
}

local suffixOfMarksmanshipLookup = {
    [1704] = "+2 Ranged AP", [1705] = "+5 Ranged AP", [1706] = "+7 Ranged AP",
    [1707] = "+10 Ranged AP", [1708] = "+12 Ranged AP", [1709] = "+14 Ranged AP",
    [1710] = "+17 Ranged AP", [1711] = "+19 Ranged AP", [1712] = "+22 Ranged AP",
    [1713] = "+24 Ranged AP", [1714] = "+26 Ranged AP", [1715] = "+29 Ranged AP",
    [1716] = "+31 Ranged AP", [1717] = "+34 Ranged AP", [1718] = "+36 Ranged AP",
    [1719] = "+38 Ranged AP", [1720] = "+41 Ranged AP", [1721] = "+43 Ranged AP",
    [1722] = "+46 Ranged AP", [1723] = "+48 Ranged AP", [1724] = "+50 Ranged AP",
    [1725] = "+53 Ranged AP", [1726] = "+55 Ranged AP", [1727] = "+58 Ranged AP",
    [1728] = "+60 Ranged AP", [1729] = "+62 Ranged AP", [1730] = "+65 Ranged AP",
    [1731] = "+67 Ranged AP", [1732] = "+70 Ranged AP", [1733] = "+72 Ranged AP",
    [1734] = "+74 Ranged AP", [1735] = "+77 Ranged AP", [1736] = "+79 Ranged AP",
    [1737] = "+82 Ranged AP", [1738] = "+84 Ranged AP", [1739] = "+86 Ranged AP",
    [1740] = "+89 Ranged AP", [1741] = "+91 Ranged AP"
}

local suffixOfPowerLookup = {
    [1547] = "+2 AP", [1548] = "+4 AP", [1549] = "+6 AP",
    [1550] = "+8 AP", [1551] = "+10 AP", [1552] = "+12 AP",
    [1553] = "+14 AP", [1554] = "+16 AP", [1555] = "+18 AP",
    [1556] = "+20 AP", [1557] = "+22 AP", [1558] = "+24 AP",
    [1559] = "+26 AP", [1560] = "+28 AP", [1561] = "+30 AP",
    [1562] = "+32 AP", [1563] = "+34 AP", [1564] = "+36 AP",
    [1565] = "+38 AP", [1566] = "+40 AP", [1567] = "+42 AP",
    [1568] = "+44 AP", [1569] = "+46 AP", [1570] = "+48 AP",
    [1571] = "+50 AP", [1572] = "+52 AP", [1573] = "+54 AP",
    [1574] = "+56 AP", [1575] = "+58 AP", [1576] = "+60 AP",
    [1577] = "+62 AP", [1578] = "+64 AP", [1579] = "+66 AP",
    [1580] = "+68 AP", [1581] = "+70 AP", [1582] = "+72 AP",
    [1583] = "+74 AP", [1584] = "+76 AP", [1585] = "+78 AP",
    [1586] = "+80 AP", [1587] = "+82 AP", [1588] = "+84 AP",
    [1589] = "+86 AP", [1590] = "+88 AP", [1591] = "+90 AP",
    [1592] = "+92 AP"
}

local suffixOfRegenerationLookup = {
    [2105] = "+1 HP5", [2106] = "+1 HP5", [2107] = "+1 HP5",
    [2108] = "+1 HP5", [2109] = "+1 HP5", [2110] = "+2 HP5",
    [2111] = "+2 HP5", [2112] = "+2 HP5", [2113] = "+2 HP5",
    [2114] = "+3 HP5", [2115] = "+3 HP5", [2116] = "+3 HP5",
    [2117] = "+3 HP5", [2118] = "+4 HP5", [2119] = "+4 HP5",
    [2120] = "+4 HP5", [2121] = "+4 HP5", [2122] = "+5 HP5",
    [2123] = "+5 HP5", [2124] = "+5 HP5", [2125] = "+5 HP5",
    [2126] = "+6 HP5", [2127] = "+6 HP5", [2128] = "+6 HP5",
    [2129] = "+6 HP5", [2130] = "+7 HP5", [2131] = "+7 HP5",
    [2132] = "+7 HP5", [2133] = "+7 HP5", [2134] = "+8 HP5",
    [2135] = "+8 HP5", [2136] = "+8 HP5", [2137] = "+8 HP5",
    [2138] = "+9 HP5", [2139] = "+9 HP5", [2140] = "+9 HP5",
    [2141] = "+9 HP5", [2142] = "+10 HP5"
}

local suffixOfRestorationLookup = {
    [2146] = "+10 STA, +22 to Heals, +4 MP5",
    [2147] = "+11 STA, +22 to Heals, +4 MP5",
    [2148] = "+10 STA, +24 to Heals, +4 MP5",
    [2153] = "+11 STA, +24 to Heals, +4 MP5",
    [2156] = "+15 STA, +33 to Heals, +6 MP5",
    [2160] = "+13 STA, +29 to Heals, +5 MP5",
    [2162] = "+11 STA, +26 to Heals, +4 MP5"
}

local suffixOfSorceryLookup = {
    [2143] = "+11 STA, +10 INT, +12 Damage/Healing SP",
    [2144] = "+11 STA, +10 INT, +12 Damage/Healing SP",
    [2145] = "+10 STA, +10 INT, +13 Damage/Healing SP",
    [2152] = "+11 STA, +11 INT, +13 Damage/Healing SP",
    [2155] = "+15 STA, +15 INT, +18 Damage/Healing SP",
    [2159] = "+13 STA, +13 INT, +15 Damage/Healing SP",
    [2161] = "+11 STA, +11 INT, +14 Damage/Healing SP"
}

local suffixOfStrikingLookup = {
    [2149] = "+11 STR, +10 AGI, +10 STA",
    [2150] = "+10 STR, +11 AGI, +10 STA",
    [2151] = "+10 STR, +10 AGI, +11 STA",
    [2154] = "+11 STR, +11 AGI, +11 STA",
    [2157] = "+15 STR, +15 AGI, +15 STA",
    [2158] = "+13 STR, +13 AGI, +13 STA",
    [2163] = "+11 STR, +11 AGI, +12 STA"
}

local suffixOfCriticalStrikeLookup = {
    [51] = "+1% Crit",
    [78] = "+2% Crit",
    [116] = "+3% Crit",
    [156] = "+4% Crit"
}

function GBLC:OnInitialize()

	---------------------------------------
	-- Global variable initialization
	---------------------------------------

	self.db = LibStub("AceDB-3.0"):New("GuildBankListCreatorDb", defaults)
	GBLC:RegisterChatCommand('gblc', 'HandleChatCommand');

	if (ListLimiter == nil) then
		ListLimiter = 0
	end

	if (ShowLinks == nil) then
		ShowLinks = true
	end

	if (StackItems == nil) then
		StackItems = false
	end

	if (UseCSV == nil) then
		UseCSV = false
	end

	if (ExcludeList == nil) then
		ExcludeList = {}
	end

-- 	--Debug
--         -- Function to get and print item types and subtypes
--     function PrintItemTypesAndSubtypes()
--         local itemTypes = { GetAuctionItemClasses() }
--
--         for i, itemType in ipairs(itemTypes) do
--             print("Item Type:", itemType)
--
--             local itemSubTypes = { GetAuctionItemSubClasses(i) }
--             for j, itemSubType in ipairs(itemSubTypes) do
--                 print("  SubType:", itemSubType)
--             end
--         end
--     end
--
--     -- Call the function to print types and subtypes
--     PrintItemTypesAndSubtypes()

end

function GBLC:BoolText(input)

	---------------------------------------
	-- Make string Title Case
	---------------------------------------

	local booltext = 'False'

	if (input) then
		booltext = 'True'
	end

	return booltext
end

function GBLC:ClearFrameText()
	FrameText = ''
end

function GBLC:AddLine(linetext)
	FrameText = FrameText .. linetext .. '\n'
end

function GBLC:GetSuffixStats(suffix, suffixID)
    local suffixLookup = {
		[" of the Bear"] = suffixOfTheBearLookup,
		[" of the Boar"] = suffixOfTheBoarLookup,
		[" of the Eagle"] = suffixOfTheEagleLookup,
		[" of the Falcon"] = suffixOfTheFalconLookup,
		[" of the Gorilla"] = suffixOfTheGorillaLookup,
        [" of the Monkey"] = suffixOfTheMonkeyLookup,
        [" of the Owl"] = suffixOfTheOwlLookup,
        [" of the Tiger"] = suffixOfTheTigerLookup,
        [" of the Whale"] = suffixOfTheWhaleLookup,
        [" of the Wolf"] = suffixOfTheWolfLookup,
        [" of Agility"] = suffixOfAgilityLookup,
        [" of Defense"] = suffixOfDefenseLookup,
        [" of Intellect"] = suffixOfIntellectLookup,
        [" of Spirit"] = suffixOfSpiritLookup,
        [" of Stamina"] = suffixOfStaminaLookup,
        [" of Strength"] = suffixOfStrengthLookup,
        [" of Arcane Resistance"] = suffixOfArcaneResistanceLookup,
        [" of Fire Resistance"] = suffixOfFireResistanceLookup,
        [" of Frost Resistance"] = suffixOfFrostResistanceLookup,
        [" of Nature Resistance"] = suffixOfNatureResistanceLookup,
        [" of Shadow Resistance"] = suffixOfShadowResistanceLookup,
        [" of Arcane Wrath"] = suffixOfArcaneWrathLookup,
        [" of Fiery Wrath"] = suffixOfFieryWrathLookup,
        [" of Frozen Wrath"] = suffixOfFrozenWrathLookup,
        [" of Holy Wrath"] = suffixOfHolyWrathLookup,
        [" of Nature's Wrath"] = suffixOfNaturesWrathLookup,
        [" of Shadow Wrath"] = suffixOfShadowWrathLookup,
        [" of Blocking"] = suffixOfBlockingLookup,
        [" of Beast Slaying"] = suffixOfBeastSlayingLookup,
        [" of Concentration"] = suffixOfConcentrationLookup,
        [" of Eluding"] = suffixOfEludingLookup,
        [" of Healing"] = suffixOfHealingLookup,
        [" of Marksmanship"] = suffixOfMarksmanshipLookup,
        [" of Power"] = suffixOfPowerLookup,
        [" of Regeneration"] = suffixOfRegenerationLookup,
        [" of Restoration"] = suffixOfRegenerationLookup,
        [" of Sorcery"] = suffixOfSorceryLookup,
        [" of Striking"] = suffixOfStrikingLookup,
        [" of Critical Strike"] = suffixOfCriticalStrikeLookup
    }

    if suffixLookup[suffix] and suffixLookup[suffix][tonumber(suffixID)] then
        return suffixLookup[suffix][tonumber(suffixID)]
    else
        return ""
    end
end

function GBLC:HandleChatCommand(input)

	---------------------------------------
	-- Main chat command handler function
	---------------------------------------

	local lcinput = string.lower(input)
	local gotcommands = false

	---------------------------------------
	-- Display help
	---------------------------------------

	if (string.match(lcinput, "help")) then
		GBLC:ClearFrameText()
--		GBLC:AddLine('OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO')
		GBLC:AddLine('Guild Bank List Creator Help')
		GBLC:AddLine('Usage:')
		GBLC:AddLine('/gblc             -- Creates list of items')
		GBLC:AddLine('/gblc status      -- Shows addon settings and exclusions')
		GBLC:AddLine('/gblc limit (number)')
		GBLC:AddLine('                  -- Sets a character limit on(number) to')
		GBLC:AddLine('                  -- split the list with extra linefeed.')
		GBLC:AddLine('                  -- This is useful when you paste the')
		GBLC:AddLine('                  -- list to Discord which limits post')
		GBLC:AddLine('                  -- lengths to 2000 characters.')
		GBLC:AddLine('                  -- Set limit to 0 if you don\'t')
		GBLC:AddLine('                  -- want to get linefeed splits')
		GBLC:AddLine('/gblc nolimit     -- Same as limit 0')
		GBLC:AddLine('/gblc links true  -- Shows Wowhead links on each item')
		GBLC:AddLine('/gblc links false -- No Wowhead links on any items')
		GBLC:AddLine('/gblc stack true  -- Combines items with same name')
		GBLC:AddLine('/gblc stack false -- Shows individual items')
		GBLC:AddLine('/gblc csv true    -- Output in CSV format')
		GBLC:AddLine('/gblc csv false   -- Output in original format')
		GBLC:AddLine('/gblc exclude item name (count)')
		GBLC:AddLine('                  -- Excludes (count) number of items')
		GBLC:AddLine('                  -- from the list. If no number is')
		GBLC:AddLine('                  -- provided the count is 1.')
		GBLC:AddLine('/gblc exclude id itemID (count)')
		GBLC:AddLine('                  -- Excludes (count) items from the list.')
		GBLC:AddLine('                  -- If there\'s no number, count is 1.')
		GBLC:AddLine('/gblc include item name (count)')
		GBLC:AddLine('                  -- Includes (count) items to the list')
		GBLC:AddLine('                  -- from the exclusion list. If there\'s')
		GBLC:AddLine('                  -- no number, count is 1.')
		GBLC:AddLine('/gblc include id itemID (count)')
		GBLC:AddLine('                  -- Includes (count) items to the list')
		GBLC:AddLine('                  -- from the exclusion list. If no number')
		GBLC:AddLine('                  -- is provided the count is 1.')
		GBLC:AddLine('/gblc clearitem item name')
		GBLC:AddLine('                  -- Clears an item from the exclusion')
		GBLC:AddLine('                  -- list.')
		GBLC:AddLine('/gblc clearitem id itemID')
		GBLC:AddLine('                  -- Clears an item from the exclusion')
		GBLC:AddLine('                  -- list.')
		GBLC:AddLine('/gblc clearlist   -- Clears the exclusion list.')
		GBLC:DisplayExportString(FrameText)
		GBLC:ClearFrameText()
		gotcommands = true
	end

	---------------------------------------
	-- Clear exclusion list
	---------------------------------------

	if (string.match(lcinput, "clearlist")) then
		GBLC:Print('Clearing exclusion list')
		for eitemID, ecount in pairs(ExcludeList) do
			GBLC:RemoveItem(eitemID)
		end
		ExcludeList = nil
		ExcludeList = {}
		GBLC:Print('Exclusion list cleared')
		gotcommands = true
	end

	---------------------------------------
	-- Clear item from exclusion list
	---------------------------------------

	if (string.match(lcinput, "clearitem")) then

		if (string.match(lcinput, "clearitem id ")) then
			local eitemid = tonumber(string.match(lcinput, "clearitem id (%d+)"))
			GBLC:RemoveItem(eitemid)
			GBLC:Print('Removed ' .. GBLC:GetItemLink(eitemid) .. ' from exclusion list.')
		else
			local ename = GBLC:WordCase(string.match(lcinput, "clearitem ([%w%s]+)"))
			ename = string.gsub(ename, "^ ", "")
			local itemID = GBLC:GetItemID(ename)
			local sLink = GBLC:GetItemLink(ename)
			if itemID == nil then
				GBLC:Print( "'" .. ename .. "'" .. ' does not exist.')
			else
				GBLC:RemoveItem(itemID)
			end
		end
		gotcommands = true
	end

	---------------------------------------
	-- Display status
	---------------------------------------

	if (string.match(lcinput, "status")) then

		GBLC:ClearFrameText()
		GBLC:AddLine('Guild Bank List Creator Status\n')
		GBLC:AddLine('Character limit: ' .. ListLimiter)
		GBLC:AddLine('Show Wowhead links: ' .. GBLC:BoolText(ShowLinks))
		GBLC:AddLine('Combine items to stacks: ' .. GBLC:BoolText(StackItems))
		if (not UseCSV) then
			GBLC:AddLine('Output CSV: ' .. GBLC:BoolText(UseCSV))
		else
			GBLC:AddLine('Output CSV: ' .. GBLC:BoolText(UseCSV) .. '. The character limiter is off.')
		end
		if ExcludeList ~= nil then

			GBLC:AddLine('\nExcluded items:')
			local excludeTable = {}
			local eic = 0
			for eitemID, ecount in pairs(ExcludeList) do
				eic = eic + 1
				local sName = GBLC:GetItemName(eitemID)
				excludeTable[eic] = sName .. ' (' .. ecount .. ')'
			end

			table.sort(excludeTable)

			for i=1 , #excludeTable do
				GBLC:AddLine(excludeTable[i])
			end

		end
		GBLC:DisplayExportString(FrameText)
		GBLC:ClearFrameText()

		gotcommands = true
	end

	---------------------------------------
	-- Exclude / include items
	---------------------------------------

	if (string.match(lcinput, "exclude")) then
		local ecount = nil
		local eitemid = nil
		local ename = ''

		if (string.match(lcinput, "exclude id ")) then

			---------------------------------------
			-- Exclude with itemID
			---------------------------------------

			eitemid = tonumber(string.match(lcinput, "exclude id (%d+)"))
			ecount = tonumber(string.match(lcinput, "exclude id %d+ (%d+)"))

			if ecount == nil then
				ecount = 1
			end

			local itemID = GBLC:GetItemID(eitemid)
			local sLink = GBLC:GetItemLink(eitemid)

			if itemID == nil then
				GBLC:Print( "ItemID " .. eitemid .. ' does not exist.')
			else
				GBLC:Print('Adding ' .. ecount .. ' ' .. sLink .. ' to the exclude list.')
				GBLC:ExcludeList(itemID, ecount)
			end
		else

			---------------------------------------
			-- Exclude with itemName
			---------------------------------------

			ecount = tonumber(string.match(lcinput, "exclude [%w%s]+(%d+)"))

			if ecount == nil then
				ecount = 1
			end

			ename = GBLC:WordCase(string.match(lcinput, "exclude ([%w%s]+)"))
			ename = string.gsub(ename, "^ ", "")
			local itemID = GBLC:GetItemID(ename)
			local sLink = GBLC:GetItemLink(ename)
			if itemID == nil then
				GBLC:Print( "'" .. ename .. "'" .. ' does not exist.')
			else
				GBLC:Print('Adding ' .. ecount .. ' ' .. sLink .. ' to the exclude list.')
				GBLC:ExcludeList(itemID, ecount)
			end
		end
		gotcommands = true
	end

	if (string.match(lcinput, "include")) then

		if (string.match(lcinput, "include id ")) then

			---------------------------------------
			-- Include with itemID
			---------------------------------------

			eitemid = tonumber(string.match(lcinput, "include id (%d+)"))
			ecount = tonumber(string.match(lcinput, "include id %d+ (%d+)"))

			if ecount == nil then
				ecount = 1
			end

			local itemID = GBLC:GetItemID(eitemid)
			local sLink = GBLC:GetItemLink(eitemid)

			if itemID == nil then
				GBLC:Print( "ItemID " .. eitemid .. ' does not exist.')
			else
				GBLC:Print('Removing ' .. ecount .. ' ' .. sLink .. ' from the exclude list.')
				GBLC:IncludeList(itemID, ecount)
			end
		else

			---------------------------------------
			-- Include with itemName
			---------------------------------------

			ecount = tonumber(string.match(lcinput, "include [%w%s]+(%d+)"))

			if ecount == nil then
				ecount = 1
			end

			ename = GBLC:WordCase(string.match(lcinput, "include ([%w%s]+)"))
			ename = string.gsub(ename, "^ ", "")
			local itemID = GBLC:GetItemID(ename)
			local sLink = GBLC:GetItemName(ename)
			if itemID == nil then
				GBLC:Print( "'" .. ename .. "'" .. ' does not exist.')
			else
				GBLC:Print('Removing ' .. ecount .. ' ' .. sLink .. ' from the exclude list.')
				GBLC:IncludeList(itemID, ecount)
			end
		end
		gotcommands = true
	end

	---------------------------------------
	-- Set limit
	---------------------------------------

	if (string.match(lcinput, "limit")) then
		local snumbers = tonumber(string.match(lcinput, "limit (%d+)"))

		if (string.match(lcinput, "nolimit")) then
			snumbers = 0
		end

		if ((snumbers > 0) and (snumbers < 150)) then
			GBLC:Print('Limiter number too low. Setting to 500.')
			snumbers = 500
		end
		ListLimiter = snumbers
		GBLC:Print('Setting character limit to ' .. ListLimiter)
		gotcommands = true
	end

	---------------------------------------
	-- Enable or disable Wowhead links
	---------------------------------------

	if (string.match(lcinput, "links true")) then
		GBLC:Print('Showing Wowhead links')
		ShowLinks = true
		gotcommands = true
	end

	if (string.match(lcinput, "links false")) then
		GBLC:Print('Hiding Wowhead links')
		ShowLinks = false
		gotcommands = true
	end

	---------------------------------------
	-- Enable or disable stacking items
	---------------------------------------

	if (string.match(lcinput, "stack true")) then
		GBLC:Print('Combining items of same name to stacks')
		StackItems = true
		gotcommands = true
	end

	if (string.match(lcinput, "stack false")) then
		GBLC:Print('Showing individual items')
		StackItems = false
		gotcommands = true
	end

	---------------------------------------
	-- Enable or disable CSV format
	---------------------------------------

	if (string.match(lcinput, "csv true")) then
		GBLC:Print('Printing list in CSV format. The character limiter is now off.')
		UseCSV = true
		gotcommands = true
	end

	if (string.match(lcinput, "csv false")) then
		GBLC:Print('Printing list in user readable format')
		UseCSV = false
		gotcommands = true
	end

	---------------------------------------
	-- Generate list
	---------------------------------------

	if (not gotcommands) then
		local bags = GBLC:GetBags()
		local bagItems = GBLC:GetBagItems()
		local itemlistsort = {}
		local wowheadlink = ''
		local copper = GetMoney()
		local moneystring = (("%dg %ds %dc"):format(copper / 100 / 100, (copper / 100) % 100, copper % 100));
		local gametimehours, gametimeminutes = GetGameTime()
		local texthours = string.format("%02d", gametimehours)
		local textminutes = string.format("%02d", gametimeminutes)

		---------------------------------------
		-- Generate output normal or CSV format
		-- depending on user settings
		---------------------------------------

		GBLC:ClearFrameText()

        -- Changed datetime formatting to American style, TODO: add formatting options
		if (not UseCSV) then
			GBLC:AddLine('Bank list updated on ' .. date("%m/%d/%Y ") .. texthours .. ':' .. textminutes .. ' server time\nCharacter: ' .. UnitName('player') .. '\nGold: ' .. moneystring .. '\n')
		else
			GBLC:AddLine(date("%m/%d/%Y") .. ',' .. texthours .. ':' .. textminutes .. ',' .. UnitName('player') .. ',' .. moneystring)
		end

		local exportLength = string.len(FrameText)
		local antii = 0

		for i=1, #bagItems do

			local finalCount = 0

			local stats = self:GetSuffixStats(bagItems[i].suffixName, tonumber(bagItems[i].suffix))
			wowheadlink = GBLC:WowheadLink(bagItems[i].itemID)

			if (ExcludeList[bagItems[i].itemID] == nil) then
				finalCount = bagItems[i].count
			else
				finalCount = bagItems[i].count - ExcludeList[bagItems[i].itemID]
			end

		---------------------------------------
		-- Add item to list if finalCount is
		-- larger than zero. In case of nothing
		-- to add, we need to backtrack a step
		-- on the next time we're adding stuff
		---------------------------------------

			if not UseCSV then
				if finalCount > 0 then
                    local statsString = stats and stats ~= "" and ' "' .. stats .. '"' or ''
                    itemlistsort[(i-antii)] = '[' .. bagItems[i].name .. '](' .. wowheadlink .. statsString .. ') (' .. finalCount .. ') - ' .. bagItems[i].minLevel .. ' ' .. bagItems[i].rarity .. ' ' .. bagItems[i].subType .. ' ' .. bagItems[i].equipLoc

-- 					itemlistsort[(i-antii)] = '[' .. bagItems[i].name .. '](' .. wowheadlink .. ' "' .. stats .. '"' .. ') (' .. finalCount .. ') - ' .. bagItems[i].minLevel .. ' ' .. bagItems[i].rarity .. ' ' .. bagItems[i].subType .. ' ' .. bagItems[i].equipLoc
				end
			else
				if finalCount > 0 then
					itemlistsort[(i-antii)] = bagItems[i].itemName .. ',' .. finalCount .. ',' .. wowheadlink
				end
			end

			if finalCount <= 0 then
				antii = antii + 1
			end
		end

		table.sort(itemlistsort);

		for i=1, #itemlistsort do
			if ((ListLimiter > 0) and (not UseCSV)) then
				if ((exportLength + string.len(itemlistsort[i])) > ListLimiter) then
					GBLC:AddLine('\nList continued')
					exportLength = 0
				end
			end
			GBLC:AddLine(itemlistsort[i])
			exportLength = exportLength + string.len(itemlistsort[i])
		end

		local enumber = 0
		for eitemID, ecount in pairs(ExcludeList) do
			if ((eitemID ~= nil) and (eitemID > 0)) then
				enumber = enumber + 1
			end
		end

		if enumber > 0 then

			GBLC:AddLine('\nExcluded items')
			exportLength = 0
			local eic = 0
			local excludeTable = {}

			for eitemID, ecount in pairs(ExcludeList) do

				eic = eic +1
				local excludeString = ''
				local sName = GBLC:GetItemName(eitemID)
				wowheadlink = GBLC:WowheadLink(eitemID)

				if not UseCSV then
					excludeTable[eic] = sName .. ' (' .. ecount .. ')' .. wowheadlink
				else
					excludeTable[eic] = sName .. ',' .. ecount .. ',' .. wowheadlink ..','
				end
			end

			table.sort(excludeTable)

			for i=1 , #excludeTable do

				if ((ListLimiter > 0) and (not UseCSV)) then
					if ((exportLength + string.len(excludeTable[i])) > ListLimiter) then
						GBLC:AddLine('\nList continued')
						exportLength = 0
					end
				end

				GBLC:AddLine(excludeTable[i])

			end

		end

		GBLC:DisplayExportString(FrameText, true)
		GBLC:ClearFrameText()

	end

end

function GBLC:GetItemName(eitemID)

	---------------------------------------
	-- Get Item Name with itemID
	---------------------------------------

	local sName, sLink, iRarity, iLevel, iMinLevel, sType, sSubType, iStackCount, sItemEquipLoc = GetItemInfo(eitemID)
	if sName == nil then
		sName = 'Unseen item with ID ' .. eitemID
	end

	return sName
end

function GBLC:GetItemLink(eitemID)

	---------------------------------------
	-- Get Item Link with itemID
	---------------------------------------

	local sName, sLink, iRarity, iLevel, iMinLevel, sType, sSubType, iStackCount = GetItemInfo(eitemID)
	if sLink == nil then
		sLink = 'Unseen item with ID ' .. eitemID
	end
	return sLink
end

function GBLC:GetItemID(eitemName)

	---------------------------------------
	-- Get ItemID with item name
	---------------------------------------

	local itemID, itemType, itemSubType, itemEquipLoc, icon, itemClassID, itemSubClassID = GetItemInfoInstant(eitemName)
	return itemID
end

function GBLC:WowheadLink(witemID)

	---------------------------------------
	-- Create Wowhead link
	---------------------------------------

	local wowheadlink = ''

	if ((ShowLinks) and (witemID ~= nil)) then
		wowheadlink = 'https://classic.wowhead.com/item=' .. witemID
		if (not UseCSV) then
			wowheadlink = wowheadlink
		end
	end

	return wowheadlink
end

function GBLC:WordCase(instring)

	---------------------------------------
	-- Make String Title Case
	---------------------------------------

	local function tchelper(first, rest)
		return first:upper()..rest:lower()
	end

	local newstring = ' ' .. string.gsub(instring, "(%a)([%w_']*)", tchelper)
	newstring = string.gsub(newstring, "^%s+", "") -- just in case there's extra spaces at the start of the string

	return newstring
end

function GBLC:ExcludeList(eitemID, ecount)

	---------------------------------------
	-- Add item count to exclude list
	---------------------------------------

	if (ExcludeList[eitemID] == nil) then
		ExcludeList[eitemID] = ecount
	else
		ExcludeList[eitemID] = ExcludeList[eitemID] + ecount
	end

	return true
end

function GBLC:RemoveItem(eitemID)

	---------------------------------------
	-- Remove item from exclude list
	---------------------------------------

	GBLC:IncludeList(eitemID, 0, true)
end

function GBLC:IncludeList(eitemID, ecount, etrash)

	---------------------------------------
	-- Remove item count from exclude list
	---------------------------------------

	if (ExcludeList[eitemID] == nil) then
		GBLC:Print('There is no itemID ' .. eitemID .. ' in the exclude list')
		return false
	else
		ExcludeList[eitemID] = ExcludeList[eitemID] - ecount
	end

	if (ExcludeList[eitemID] >= 0) then
		GBLC:Print('Exclusion ' .. GBLC:GetItemLink(eitemID) .. ' count reached zero. Removing entry.')
		ExcludeList[eitemID] = nil
		table.remove(ExcludeList, eitemID)
	end

	if (etrash) then
		if (ExcludeList[eitemID] >= 0) then
			GBLC:Print('Removing ' .. GBLC:GetItemLink(eitemID) .. ' from the exclusion list.')
			ExcludeList[eitemID] = nil
			table.remove(ExcludeList, eitemID)
		end
	end

	return true
end

-- Helper function to get human-readable rarity
function GBLC:getReadableRarity(rarity)
    return rarityLookup[rarity] or ""
end

function GBLC:getReadableSlot(slot)
	return slotLookup[slot] or ""
end

function GBLC:GetBags()

	---------------------------------------
	-- Get list of character bags
	---------------------------------------

	local bags = {}

	for container = -1, 12 do
		bags[#bags + 1] = {
			container = container,
			bagName = C_Container.GetBagName(container)
		}
	end

	return bags;
end

-- Heavily modified
function GBLC:GetBagItems()
    local bagItems = {}

    for container = -1, 12 do
        local numSlots = C_Container.GetContainerNumSlots(container)

        for slot = 1, numSlots do
            local itemLink = C_Container.GetContainerItemLink(container, slot)

            if itemLink then
                local itemName, itemID, itemRarity, _, itemMinLevel, itemType, itemSubType, _, itemEquipLoc = GetItemInfo(itemLink)
                local count = select(2, C_Container.GetContainerItemInfo(container, slot)) or 1

                local isStackable = stackableLookup[itemType] and (type(stackableLookup[itemType]) ~= "table" or stackableLookup[itemType][itemSubType])

                local _, _, Color, Ltype, Id, Enchant, Gem1, Gem2, Gem3, Gem4, Suffix, Unique, LinkLvl, Name = string.find(itemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
                local suffixName = string.match(itemName, " of .+$")

                local stacked = false

                if StackItems and #bagItems > 0 then
                    for stackitem = 1, #bagItems do
                        if bagItems[stackitem].itemID == Id then
                            if isStackable then
                                -- Stackable items (like materials) are combined across all bags
                                count = GetItemCount(Id)
                                bagItems[stackitem].count = count
                                stacked = true
                                break
                            elseif bagItems[stackitem].suffix == Suffix then
                                -- Non-stackable items with the same suffix are combined
                                bagItems[stackitem].count = bagItems[stackitem].count + count
                                stacked = true
                                break
                            end
                        end
                    end
                end

                if not stacked then
                    bagItems[#bagItems + 1] = {
                        link = itemLink,
                        name = itemName,
                        suffix = Suffix,
                        suffixName = suffixName,
                        itemID = Id,
                        rarity = GBLC:getReadableRarity(itemRarity),
                        minLevel = itemMinLevel,
                        iType = itemType,
                        subType = itemSubType,
                        equipLoc = GBLC:getReadableSlot(itemEquipLoc),
                        count = isStackable and GetItemCount(Id) or count
                    }
                end
            end
        end
    end

    return bagItems
end

function GBLC:DisplayExportString(str,highlight)

	---------------------------------------
	-- Display the main frame with list
	---------------------------------------

	-- Increased width
    local newWidth = 1000

    gblcFrame:SetWidth(newWidth)

	-- Create and set the frame texture for background
    local frameTexture = gblcFrame:CreateTexture()
    frameTexture:SetAllPoints(gblcFrame)
    frameTexture:SetColorTexture(0.1, 0.1, 0.1, 0.5) -- specified dark grey, transparent background

	gblcFrame:Show();
	gblcFrameScroll:Show()
	gblcFrameScrollText:Show()
	gblcFrameScrollText:SetText(str)

	if highlight then
		gblcFrameScrollText:HighlightText()
	end

	gblcFrameScrollText:SetScript('OnEscapePressed', function(self)
		gblcFrame:Hide();
		end
	);

	gblcFrameButton:SetScript("OnClick", function(self)
		gblcFrame:Hide();
		end
	);
end
