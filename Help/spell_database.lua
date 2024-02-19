
local database = {
    ["Aatrox"] = {
        { Spell = "Q1", slot = 0, name = "AatroxQ1", target = false, skillshot = true, cc = "Knockup", menu = 35, delay = 0.6, math.huge },
        { Spell = "Q2", slot = 0, name = "AatroxQ2", target = false, skillshot = true, cc = "Knockup", menu = 35, delay = 0.6, math.huge },
        { Spell = "Q3", slot = 0, name = "AatroxQ3", target = false, skillshot = true, cc = "Knockup", menu = 60, delay = 0.6, math.huge },
        { Spell = "W", slot = 1, name = "AatroxW", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, 1800 },
        { Spell = "W2", slot = 1, name = "AatroxW2", target = false, skillshot = false, menu = 60, delay = 0.25, 1800 },
    },
    ["Ahri"] = {
        { Spell = "Q", slot = 0, name = "AhriQ", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, 1550 },
        { Spell = "W", slot = 1, name = "AhriW", target = true, skillshot = false, missile = true, menu = 0, delay = 0.0, 1400 },
        { Spell = "E", slot = 2, name = "AhriE", target = false, skillshot = true, missile = true, cc = "Charm", menu = 100, delay = 0.25, 1550 },
    },
    ["Akali"] = {
        { Spell = "Q", slot = 0, name = "AkaliQ", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, math.huge },
        { Spell = "E1", slot = 2, name = "AkaliE", target = false, skillshot = true, missile = true, menu = 0, delay = 0.4, 1800.0 },
        { Spell = "E2", slot = 2, name = "AkaliEb", target = true, skillshot = false, menu = 60, delay = 0.25, 1500.0 },
        { Spell = "R1", slot = 3, name = "AkaliR", target = true, skillshot = false, menu = 0, delay = 0.0, 1500.0 },
        { Spell = "R2", slot = 3, name = "AkaliRb", target = false, skillshot = true, menu = 35, delay = 0.0, 3000.0 },
    },
    ["Akshan"] = {
        { Spell = "Q", slot = 0, name = "AkshanQ", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, 1500.0 },
        { Spell = "E", slot = 2, name = "AkshanE", target = true, skillshot = false, missile = true, menu = 0, delay = 0.0, 3000.0 },
        { Spell = "R", slot = 3, name = "AkshanR", target = true, skillshot = false, missile = true, menu = 35, delay = 0.0, 3200.0 },
    },
    ["Alistar"] = {
        { Spell = "Q", slot = 0, name = "Pulverize", target = false, skillshot = true, cc = "Knockup", menu = 60, delay = 0.25, math.huge },
        { Spell = "W", slot = 1, name = "Headbutt", target = true, skillshot = false, cc = "Knockup", menu = 60, delay = 0.0, 1544.0 },
    },
    ["Amumu"] = {
        { Spell = "Q", slot = 0, name = "BandageToss", target = false, skillshot = true, missile = true, cc = "Stun", menu = 100, delay = 0.25, 2000.0 },
        { Spell = "R", slot = 3, name = "CurseoftheSadMummy", target = false, skillshot = true, cc = "Stun", menu = 100, delay = 0.25, math.huge },
    },
    ["Anivia"] = {
        { Spell = "Q", slot = 0, name = "FlashFrost", target = false, skillshot = true, missile = true, cc = "Stun", menu = 100, delay = 0.25, 950.0 },
        { Spell = "E", slot = 2, name = "Frostbite", target = true, skillshot = false, missile = true, menu = 0, delay = 0.25, 1600.0 },
        { Spell = "R", slot = 3, name = "GlacialStorm", target = false, skillshot = true, menu = 0, delay = 0.0, math.huge },
    },
    ["Annie"] = {
        { Spell = "Q Stun", slot = 0, name = "AnnieQ", target = true, skillshot = false, missile = true, menu = 100, delay = 0.25, 3000.0 },
        { Spell = "W Stun", slot = 1, name = "AnnieW", target = false, skillshot = true, menu = 100, delay = 0.25, math.huge },
        { Spell = "R Stun", slot = 3, name = "AnnieR", target = false, skillshot = true, menu = 100, delay = 0.25, math.huge },
    },
    ["Aphelios"] = {
        { Spell = "R", slot = 3, name = "ApheliosR", target = false, skillshot = true, missile = true, menu = 60, delay = 0.6, 1000.0 },
    },
    ["Ashe"] = {
        { Spell = "W", slot = 1, name = "Volley", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, 2000.0 },
        { Spell = "R", slot = 3, name = "EnchantedCrystalArrow", target = false, skillshot = true, missile = true, cc = "Stun", menu = 100, delay = 0.25, 1800.0 },
    },
    ["AurelionSol"] = {
        { Spell = "E", slot = 2, name = "AurelionSolE", target = false, skillshot = true, menu = 0, delay = 0.35, 4500.0 },
        { Spell = "R", slot = 3, name = "AurelionSolR", target = false, skillshot = true, cc = "Knockup", menu = 60, delay = 0.35, 4500.0 },
    },
    ["Azir"] = {
        { Spell = "Q", slot = 0, name = "AzirQWrapper", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, 3000.0 },
        { Spell = "W", slot = 1, name = "AzirW", target = false, skillshot = true, menu = 0, delay = 0.25, math.huge },
        { Spell = "R", slot = 3, name = "AzirR", target = false, skillshot = true, missile = true, cc = "Knockup", menu = 100, delay = 0.5, 1400.0 },
    },
    ["Bard"] = {
        { Spell = "Q", slot = 0, name = "BardQ", target = false, skillshot = true, missile = true, cc = "Stun", menu = 60, delay = 0.25, 1500.0 },
        { Spell = "R", slot = 3, name = "BardR", target = false, skillshot = true, cc = "Stun", menu = 60, delay = 0.5, 2000.0 },
    },
    ["Belveth"] = {
        { Spell = "Q", slot = 0, name = "BelVethQ", target = false, skillshot = true, menu = 0, delay = 0.0, 1000.0 },
        { Spell = "W", slot = 1, name = "BelVethW", target = false, skillshot = true, cc = "Knockup", menu = 100, delay = 0.5, math.huge },
        { Spell = "E", slot = 2, name = "BelVethE", target = true, skillshot = false, menu = 0, delay = 0.0, math.huge },
        { Spell = "R", slot = 3, name = "BelVethR", target = false, skillshot = true, menu = 0, delay = 1.0, math.huge },
    },
    ["Blitzcrank"] = {
        { Spell = "Q", slot = 0, name = "RocketGrab", target = false, skillshot = true, missile = true, menu = 100, delay = 0.25, 1800.0 },
        { Spell = "E", slot = 2, name = "PowerFistAttack", target = true, skillshot = false, cc = "Knockup", menu = 100, delay = 0.25, math.huge },
        { Spell = "R", slot = 3, name = "StaticField", target = false, skillshot = true, menu = 0, delay = 0.25, math.huge },
    },
    ["Brand"] = {
        { Spell = "Stun Q", slot = 0, name = "BrandQ", target = false, skillshot = true, missile = true, cc = "Stun", menu = 100, delay = 0.25, 1600.0 },
        { Spell = "W", slot = 1, name = "BrandW", target = false, skillshot = true, menu = 0, delay = 0.25, 0.627 },
        { Spell = "E", slot = 2, name = "BrandE", target = true, skillshot = false, menu = 0, delay = 0.25, 3000.0 },
        { Spell = "R", slot = 3, name = "BrandR", target = true, skillshot = false, missile = true, cc = "Stun", menu = 60, delay = 0.25, 3000.0 }
    },
    ["Braum"] = {
        { Spell = "Q", slot = 0, name = "BraumQ", target = false, skillshot = true, missile = true, menu = 60, delay = 0.25, 1700.0 },
        { Spell = "R", slot = 3, name = "BraumR", target = false, skillshot = true, missile = true, cc = "Knockup", menu = 100, delay = 0.5, 1400.0 },
    },
    ["Caitlyn"] = {
        { Spell = "Q", slot = 0, name = "CaitlynQ", target = false, skillshot = true, missile = true, menu = 0, delay = 0.625, 2200.0 },
        { Spell = "W", slot = 1, name = "CaitlynW", target = false, skillshot = true, cc = "Snare", menu = 35, delay = 1.0, math.huge },
        { Spell = "E", slot = 2, name = "CaitlynE", target = false, skillshot = true, missile = true, menu = 35, delay = 0.15, 1600.0 },
        { Spell = "R", slot = 3, name = "CaitlynR", target = true, skillshot = false, missile = true, menu = 35, delay = 0.375, 3500.0 },
    },
    ["Camille"] = {
        { Spell = "Q", slot = 0, name = "CamilleQ2", target = true, skillshot = false, menu = 0, delay = 0.0, math.huge },
        { Spell = "W", slot = 1, name = "CamilleW", target = false, skillshot = true, menu = 0, delay = 1.1, math.huge },
        { Spell = "E", slot = 2, name = "CamilleEDash2", target = false, skillshot = true, cc = "Stun", menu = 60, delay = 0.0, 1350.0 },
        { Spell = "R", slot = 3, name = "CamilleR", target = true, skillshot = false, menu = 80, delay = 0.5, math.huge },
    },
    ["Cassiopeia"] = {
        { Spell = "Q", slot = 0, name = "CassiopeiaQ", target = false, skillshot = true, menu = 0, delay = 0.625, math.huge },
        { Spell = "W", slot = 1, name = "CassiopeiaW", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, 3000.0 },
        { Spell = "E", slot = 2, name = "CassiopeiaE", target = true, skillshot = false, missile = true, menu = 10, delay = 0.125, 2500.0 },
        { Spell = "R", slot = 3, name = "CassiopeiaR", target = false, skillshot = true, cc = "Stun", menu = 80, delay = 0.5, math.huge },
    },
    ["Chogath"] = {
        { Spell = "Q", slot = 0, name = "Rupture", target = false, skillshot = true, cc = "Knockup", menu = 0, delay = 1.127, math.huge },
        --{ Spell = "W", slot = 1, name = "FeralScream", target = false, skillshot = true, menu = 100, delay = 0.5, math.huge },
        { Spell = "E", slot = 2, name = "ChogathEAttack", target = true, skillshot = false, missile = true, menu = 0, delay = 0.1, math.huge },
        { Spell = "R", slot = 3, name = "Feast", target = true, skillshot = false, menu = 60, delay = 0.25, math.huge },
    },
    ["Corki"] = {
        { Spell = "Q", slot = 0, name = "PhosphorusBomb", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, 1000.0 },
        { Spell = "W", slot = 1, name = "CarpetBombMega", target = false, skillshot = true, cc = "Knockup", menu = 0, delay = 0.0, 1500.0 },
        { Spell = "R", slot = 3, name = "skillshotBarrage", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, math.huge },
    },
    ["Darius"] = {
        { Spell = "Q", slot = 0, name = "DariusCleave", target = false, skillshot = true, menu = 60, delay = 0.75, math.huge },
        { Spell = "W", slot = 1, name = "DariusNoxianTacticsONHAttack", target = true, skillshot = false, menu = 100, delay = 0.1, math.huge },
        { Spell = "E", slot = 2, name = "DariusAxeGrabCone", target = false, skillshot = true, cc = "Knockup", menu = 100, delay = 0.25, math.huge },
        { Spell = "R", slot = 3, name = "DariusExecute", target = true, skillshot = false, menu = 60, delay = 0.3667, math.huge },
    },
    ["Diana"] = {
        { Spell = "Q", slot = 0, name = "DianaQ", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, 2000.0 },
        { Spell = "E", slot = 2, name = "DianaTeleport", target = true, skillshot = false, menu = 100, delay = 0.0, 3000.0 },
        { Spell = "R", slot = 3, name = "DianaR", target = false, skillshot = true, cc = "Knockup", menu = 100, delay = 0.25, math.huge },
    },
    ["DrMundo"] = {
        { Spell = "Q", slot = 0, name = "DrMundoQ", target = false, skillshot = true, missile = true, menu = 30, delay = 0.25, 2000.0 },
        { Spell = "E", slot = 2, name = "DrMundoEAttack", target = true, skillshot = false, menu = 0, delay = 0.1, math.huge },
    },
    ["Draven"] = {
        { Spell = "E", slot = 2, name = "DravenDoubleShot", target = false, skillshot = true, missile = true, cc = "Knockup", menu = 60, delay = 0.25, 1100.0 },
        { Spell = "R", slot = 3, name = "DravenRCast", target = false, skillshot = true, missile = true, menu = 35, delay = 0.5, 2000.0 },
        { Spell = "R return", slot = 3, name = "DravenRDoublecast", target = false, skillshot = true, missile = true, menu = 35, delay = 0.5, 2000.0 },
    },
    ["Ekko"] = {
        { Spell = "Q", slot = 0, name = "EkkoQ", target = false, skillshot = true, missile = true, menu = 35, delay = 0.25, 2000.0 },
        { Spell = "W", slot = 1, name = "EkkoW", target = false, skillshot = true, cc = "Stun", menu = 60, delay = 2.25, math.huge },
        { Spell = "E", slot = 2, name = "EkkoEAttack", target = true, skillshot = false, menu = 60, delay = 0.1, math.huge },
        { Spell = "R", slot = 3, name = "EkkoR", target = false, skillshot = true, menu = 70, delay = 0.5, 3000.0 },
    },
    ["Elise"] = {
        { Spell = "Q", slot = 0, name = "EliseHumanQ", target = true, skillshot = false, missile = true, menu = 0, delay = 0.25, 3000.0 },
        { Spell = "SpiderQ", slot = 0, name = "EliseSpiderQCast", target = true, skillshot = false, menu = 35, delay = 0.125, math.huge },
        { Spell = "W", slot = 1, name = "EliseHumanW", target = false, skillshot = true, menu = 35, delay = 0.25, 400.0 },
        { Spell = "E", slot = 2, name = "EliseHumanE", target = false, skillshot = true, missile = true, cc = "Stun", menu = 80, delay = 0.25, 1600.0 },
    },
    ["Evelynn"] = {
        { Spell = "Q Charm", slot = 0, name = "EvelynnQ", target = false, skillshot = true, missile = true, menu = 80, delay = 0.3, 2400.0 },
        { Spell = "E Charm", slot = 2, name = "EvelynnE2", target = true, skillshot = false, menu = 80, delay = 0.25, math.huge },
        { Spell = "R", slot = 3, name = "EvelynnR", target = false, skillshot = true, menu = 50, delay = 0.35, math.huge },
    },
    ["Ezreal"] = {
        { Spell = "Q", slot = 0, name = "EzrealQ", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, 2000.0 },
        { Spell = "W", slot = 1, name = "EzrealW", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, 1700.0 },
        { Spell = "R", slot = 3, name = "EzrealR", target = false, skillshot = true, missile = true, menu = 30, delay = 1.0, 2000.0 },
    },
    ["FiddleSticks"] = {
        { Spell = "Q", slot = 0, name = "FiddleSticksQ", target = true, skillshot = false, missile = true, cc = "Fear", menu = 100, delay = 0.35, math.huge },
        { Spell = "E", slot = 2, name = "FiddleSticksE", target = false, skillshot = true, cc = "Fear", menu = 100, delay = 0.4, math.huge },
        { Spell = "R", slot = 3, name = "FiddleSticksR", target = false, skillshot = true, cc = "Fear", menu = 100, delay = 1.5, math.huge },
    },
    ["Fiora"] = {
        { Spell = "Q", slot = 0, name = "FioraQ", target = true, skillshot = false, menu = 60, delay = 0.25, 2000.0 },
        { Spell = "W", slot = 1, name = "FioraW", target = false, skillshot = true, missile = true, menu = 90, delay = 0.75, 3200.0 },
    },
    ["Fizz"] = {
        { Spell = "Q", slot = 0, name = "FizzQ", target = true, skillshot = false, menu = 60, delay = 0.0, 3000.0 },
        { Spell = "E", slot = 2, name = "FizzEtwo", target = false, skillshot = true, menu = 60, delay = 0.1, math.huge },
        { Spell = "R", slot = 3, name = "FizzR", target = false, skillshot = true, missile = true, cc = "Knockup", menu = 100, delay = 0.25, math.huge },
    },
    ["Galio"] = {
        { Spell = "Q", slot = 0, name = "GalioQ", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, 1400.0 },
        { Spell = "E", slot = 2, name = "GalioE", target = false, skillshot = true, cc = "Knockup", menu = 100, delay = 0.4, 2300.0 },
        { Spell = "R", slot = 3, name = "GalioR", target = false, skillshot = true, cc = "Knockup", menu = 100, delay = 2.75, math.huge },
    },
    ["Gangplank"] = {
        { Spell = "Q", slot = 0, name = "GangplankQProceed", target = true, skillshot = false, missile = true, menu = 50, delay = 0.5, 2600.0 },
        { Spell = "R", slot = 3, name = "GangplankR", target = false, skillshot = true, menu = 30, delay = 0.25, math.huge },
    },
    ["Garen"] = {
        { Spell = "Q", slot = 0, name = "GarenQAttack", target = true, skillshot = false, menu = 80, delay = 0.1, math.huge },
        { Spell = "R", slot = 3, name = "GarenR", target = true, skillshot = false, menu = 44, delay = 0.435, math.huge },
    },
    ["Gnar"] = {
        { Spell = "Q", slot = 0, name = "GnarQ", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, 2500.0 },
        { Spell = "E", slot = 2, name = "GnarE", target = false, skillshot = true, menu = 0, delay = 0.0, 1000.0 },
        { Spell = "Big Q", slot = 0, name = "GnarBigQ", target = false, skillshot = true, menu = 0, delay = 0.5, 2100.0 },
        { Spell = "Big W", slot = 1, name = "GnarBigW", target = false, skillshot = true, cc = "Stun", menu = 100, delay = 0.6, math.huge },
        { Spell = "Big E", slot = 2, name = "GnarBigE", target = false, skillshot = true, menu = 0, delay = 0.0, 1000.0 },
        { Spell = "Big R", slot = 3, name = "GnarR", target = false, skillshot = true, cc = "Knockup", menu = 100, delay = 0.25, math.huge },
    },
    ["Gragas"] = {
        { Spell = "Q", slot = 0, name = "GragasQ", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, 1000.0 },
        { Spell = "W", slot = 1, name = "GragasWAttack", target = true, skillshot = false, menu = 30, delay = 0.25, math.huge },
        { Spell = "E", slot = 2, name = "GragasE", target = false, skillshot = true, cc = "Knockup", menu = 100, delay = 0.0, 900.0 },
        { Spell = "R", slot = 3, name = "GragasR", target = false, skillshot = true, missile = true, cc = "Knockup", menu = 100, delay = 0.8, math.huge },
    },
    ["Graves"] = {
        { Spell = "W", slot = 1, name = "GravesSmokeGrenade", target = false, skillshot = true, missile = true, menu = 30, delay = 0.25, 1500.0 },
        { Spell = "R", slot = 3, name = "GravesChargeShot", target = false, skillshot = true, missile = true, menu = 100, delay = 0.25, 2100.0 },
    },
    ["Gwen"] = {
        { Spell = "Q", slot = 0, name = "GwenQ", target = false, skillshot = true, menu = 0, delay = 0.0, math.huge },
        { Spell = "R", slot = 3, name = "GwenR", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, 1800.0 },
        { Spell = "R2", slot = 3, name = "GwenRRecast", target = false, skillshot = true, missile = true, menu = 50, delay = 0.25, 1800.0 },
    },
    ["Hecarim"] = {
        { Spell = "E", slot = 2, name = "HecarimRampAttack", target = true, skillshot = false, cc = "Stun", menu = 100, delay = 0.0, math.huge },
        { Spell = "R", slot = 3, name = "HecarimULT", target = false, skillshot = true, cc = "Fear", menu = 100, delay = 0.0, 1100.0 },
    },
    ["Heimerdinger"] = {
        { Spell = "E", slot = 2, name = "HeimerdingerE", target = false, skillshot = true, missile = true, cc = "Stun", menu = 0, delay = 0.25, 1200.0 },
        { Spell = "E", slot = 2, name = "HeimerdingerEUlt", target = false, skillshot = true, missile = true, cc = "Stun", menu = 50, delay = 0.25, 1200.0 },
    },
    ["Illaoi"] = {
        { Spell = "Q", slot = 0, name = "IllaoiQ", target = false, skillshot = true, menu = 35, delay = 0.75, math.huge },
        { Spell = "W", slot = 1, name = "IllaoiWAttack", target = true, skillshot = false, menu = 35, delay = 0.0, math.huge },
        { Spell = "E", slot = 2, name = "IllaoiE", target = false, skillshot = true, missile = true, menu = 100, delay = 0.25, 1900.0 },
        { Spell = "R", slot = 3, name = "IllaoiR", target = false, skillshot = true, menu = 60, delay = 0.5, math.huge },
    },
    ["Irelia"] = {
        { Spell = "Q", slot = 0, name = "IreliaQ", target = true, skillshot = false, menu = 0, delay = 0.0, 1400.0 },
        { Spell = "W", slot = 1, name = "IreliaW2", target = false, skillshot = true, menu = 0, delay = 0.25, math.huge },
        { Spell = "E", slot = 2, name = "IreliaE2", target = false, skillshot = true, missile = true, cc = "Stun", menu = 100, delay = 0.0, 2000.0 },
        { Spell = "R", slot = 3, name = "IreliaR", target = false, skillshot = true, missile = true, menu = 100, delay = 0.4, 2000.0 },
    },
    ["Ivern"] = {
        { Spell = "Q", slot = 0, name = "IvernQ", target = false, skillshot = true, missile = true, cc = "Snare", menu = 80, delay = 0.25, 1300.0 },
    },
    ["Janna"] = {
        { Spell = "Q", slot = 0, name = "HowlingGale", target = false, skillshot = true, missile = true, cc = "Knockup", menu = 0, delay = 0.0, 1408.0 },
        { Spell = "W", slot = 1, name = "SowTheWind", target = true, skillshot = false, missile = true, menu = 60, delay = 0.245, 1000.0 },
        { Spell = "R", slot = 3, name = "ReapTheWhirlWind", target = false, skillshot = true, cc = "Knockup", menu = 0, delay = 0.0, math.huge },
    },
    ["JarvanIV"] = {
        { Spell = "Q", slot = 0, name = "JarvanIVDragonStrike", target = false, skillshot = true, cc = "Knockup", menu = 100, delay = 0.4, math.huge },
        { Spell = "R", slot = 3, name = "JarvanIVCataclysm", target = true, skillshot = false, menu = 100, delay = 0.0, math.huge },
    },
    ["Jax"] = {
        { Spell = "Q", slot = 0, name = "JaxLeapStrike", target = true, skillshot = false, menu = 30, delay = 0.0, 2000.0 },
        { Spell = "E", slot = 2, name = "JaxCounterStrike", target = false, skillshot = true, cc = "Stun", menu = 100, delay = 0.0, math.huge },
    },
    ["Jayce"] = {
        { Spell = "Melee Q", slot = 0, name = "JayceToTheSkies", target = true, skillshot = false, menu = 60, delay = 0.0, 2000.0 },
        { Spell = "Melee E", slot = 2, name = "JayceThunderingBlow", target = true, skillshot = false, cc = "Knockup", menu = 100, delay = 0.25, math.huge },
        { Spell = "Ranged Q", slot = 0, name = "JayceShockBlast", target = false, skillshot = true, missile = true, menu = 35, delay = 0.2143, 2000.0 },
    },
    ["Jhin"] = {
        { Spell = "Q", slot = 0, name = "JhinQ", target = true, skillshot = false, missile = true, menu = 35, delay = 0.25, 1600.0 },
        { Spell = "W", slot = 1, name = "JhinW", target = false, skillshot = true, missile = true, cc = "Snare", menu = 100, delay = 0.75, math.huge },
        { Spell = "R", slot = 3, name = "JhinRShot", target = false, skillshot = true, missile = true, menu = 100, delay = 1.0, 5000.0 },
    },
    ["Jinx"] = {
        { Spell = "W", slot = 1, name = "JinxW", target = false, skillshot = true, missile = true, menu = 35, delay = 0.4, 3300.0 },
        { Spell = "E", slot = 2, name = "JinxE", target = false, skillshot = true, missile = true, menu = 100, delay = 0.8, math.huge },
        { Spell = "R", slot = 3, name = "JinxR", target = false, skillshot = true, missile = true, cc = "Snare", menu = 44, delay = 0.6, 2000.0 },
    },
    ["Kaisa"] = {
        { Spell = "Q", slot = 0, name = "KaisaQ", target = true, skillshot = false, missile = true, menu = 0, delay = 0.0, math.huge },
        { Spell = "W", slot = 1, name = "KaisaW", target = false, skillshot = true, missile = true, menu = 35, delay = 0.4, 1750.0 },
    },
    ["Kalista"] = {
        { Spell = "Q", slot = 0, name = "KalistaMysticShot", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, 2400.0 },
        { Spell = "R", slot = 3, name = "KalistaRx", target = false, skillshot = true, cc = "Knockup", menu = 100, delay = 0.0, 3000.0 },
    },
    ["Karma"] = {
        { Spell = "Q", slot = 0, name = "KarmaQ", target = false, skillshot = true, missile = true, menu = 35, delay = 0.25, 1700.0 },
        { Spell = "W", slot = 1, name = "KarmaSpiritBind", target = true, skillshot = false, cc = "Snare", menu = 100, delay = 0.25, math.huge },
    },
    ["Karthus"] = {
        { Spell = "R", slot = 3, name = "KarthusFallenOne", target = true, skillshot = false, menu = 35, delay = 3.25, math.huge },
    },
    ["Kassadin"] = {
        { Spell = "Q", slot = 0, name = "NullLance", target = true, skillshot = false, missile = true, menu = 35, delay = 0.25, 1400.0 },
        { Spell = "R", slot = 3, name = "RiftWalk", target = false, skillshot = true, menu = 35, delay = 0.25, math.huge },
    },
    ["Katarina"] = {
        { Spell = "Q", slot = 0, name = "KatarinaQ", target = true, skillshot = false, missile = true, menu = 80, delay = 0.25, 2000.0 },
        { Spell = "E", slot = 2, name = "KatarinaE", target = true, skillshot = false, menu = 70, delay = 0.0, math.huge },
        { Spell = "R", slot = 3, name = "KatarinaR", target = false, skillshot = true, missile = true, menu = 100, delay = 0.0, 2400.0 },
    },
    ["Kayle"] = {
        { Spell = "Q", slot = 0, name = "KayleQ", target = false, skillshot = true, menu = 35, delay = 0.25, 1600.0 },
        { Spell = "E", slot = 2, name = "KayleEAttack", target = true, skillshot = false, missile = true, menu = 35, delay = 0.0, 2000.0 },
    },
    ["Kayn"] = {
        { Spell = "Q", slot = 0, name = "KaynQ", target = false, skillshot = true, menu = 0, delay = 0.0, 500.0 },
        { Spell = "W", slot = 1, name = "KaynW", target = false, skillshot = true, cc = "Knockup", menu = 35, delay = 0.55, math.huge },
        { Spell = "OP Q", slot = 0, name = "KaynQLong", target = false, skillshot = true, menu = 0, delay = 0.25, math.huge },
        { Spell = "OP W", slot = 1, name = "KaynWLong", target = false, skillshot = true, cc = "Knockup", menu = 100, delay = 0.25, math.huge },
    },
    ["Kennen"] = {
        { Spell = "Q", slot = 0, name = "KennenShurikenHurlskillshotl", target = false, skillshot = true, missile = true, menu = 70, delay = 0.175, 1700.0 },
        { Spell = "W", slot = 1, name = "KennenBringTheLight", target = true, skillshot = false, menu = 70, delay = 0.25, math.huge },
        { Spell = "R", slot = 3, name = "KennenShurikenStorm", target = false, skillshot = true, menu = 100, delay = 0.25, math.huge },
    },
    ["Khazix"] = {
        { Spell = "Q", slot = 0, name = "KhazixQ", target = true, skillshot = false, menu = 60, delay = 0.25, math.huge },
        { Spell = "W", slot = 1, name = "KhazixW", target = false, skillshot = true, missile = true, menu = 50, delay = 0.25, 1700.0 },
        { Spell = "E", slot = 2, name = "KhazixE", target = false, skillshot = true, menu = 0, delay = 0.0, 2000.0 },
        { Spell = "OP Q", slot = 0, name = "KhazixQLong", target = true, skillshot = false, menu = 60, delay = 0.25, math.huge },
        { Spell = "OP W", slot = 1, name = "KhazixWLong", target = false, skillshot = true, missile = true, menu = 50, delay = 0.25, 1700.0 },
        { Spell = "OP E", slot = 2, name = "KhazixELong", target = false, skillshot = true, menu = 0, delay = 0.0, 2000.0 },
    },
    ["Kindred"] = {
        { Spell = "Q", slot = 0, name = "KindredQ", target = true, skillshot = false, missile = true, menu = 0, delay = 0.0, math.huge },
        { Spell = "E", slot = 2, name = "KindredE", target = true, skillshot = false, missile = true, menu = 100, delay = 0.25, 3000.0 },
    },
    ["Kled"] = {
        { Spell = "Q", slot = 0, name = "KledQ", target = false, skillshot = true, missile = true, cc = "Knockup", menu = 0, delay = 0.25, 1000.0 },
        { Spell = "Q2", slot = 0, name = "KledQ2", target = false, skillshot = true, cc = "Knockup", menu = 100, delay = 0.25, 1000.0 },
        { Spell = "Rider Q", slot = 0, name = "KledRiderQ", target = false, skillshot = true, missile = true, menu = 50, delay = 0.25, 1000.0 },
        { Spell = "W", slot = 1, name = "KledWAttack4", target = true, skillshot = false, menu = 100, delay = 0.0, math.huge },
        { Spell = "E", slot = 2, name = "KledEDash", target = false, skillshot = true, menu = 0, delay = 0.0, 3000.0 },
    },
    ["KogMaw"] = {
        { Spell = "Q", slot = 0, name = "KogMawQ", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, 1650.0 },
        { Spell = "E", slot = 2, name = "KogMawVoidOoze", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, 1900 },
        { Spell = "R", slot = 3, name = "KogMawLivingArtillery", target = false, skillshot = true, menu = 0, delay = 0.85, math.huge },
    },
    ["Leblanc"] = {
        { Spell = "Q", slot = 0, name = "LeblancQ", target = true, skillshot = false, missile = true, menu = 100, delay = 0.25, 2000.0 },
        { Spell = "W", slot = 1, name = "LeblancW", target = false, skillshot = true, menu = 0, delay = 0.0, 1450.0 },
        { Spell = "E", slot = 2, name = "LeblancE", target = false, skillshot = true, missile = true, cc = "Snare", menu = 70, delay = 0.25, 1750.0 },
        { Spell = "RQ", slot = 0, name = "LeblancRQ", target = true, skillshot = false, missile = true, menu = 0, delay = 0.25, 2000.0 },
        { Spell = "RW", slot = 1, name = "LeblancRW", target = false, skillshot = true, menu = 0, delay = 0.0, 1450.0 },
        { Spell = "RE", slot = 2, name = "LeblancRE", target = false, skillshot = true, missile = true, cc = "Snare", menu = 70, delay = 0.25, 1750.0 },
    },
    ["LeeSin"] = {
        { Spell = "Q", slot = 0, name = "BlindMonkQOne", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, 1800.0 },
        { Spell = "Q2", slot = 0, name = "BlindMonkQTwo", target = true, skillshot = false, menu = 100, delay = 0.0, 1350.0 },
        { Spell = "W", slot = 1, name = "BlindMonkWOne", target = true, skillshot = false, menu = 0, delay = 0.0, 1350.0 },
        { Spell = "E", slot = 2, name = "BlindMonkEOne", target = false, skillshot = true, menu = 0, delay = 0.25, math.huge },
        { Spell = "E", slot = 2, name = "BlindMonkETwo", target = false, skillshot = true, menu = 0, delay = 0.0, 1600.0 },
        { Spell = "R", slot = 3, name = "BlindMonkRKick", target = true, skillshot = false, cc = "Knockup", menu = 100, delay = 0.005, math.huge },
    },
    ["Leona"] = {
        { Spell = "Q", slot = 0, name = "LeonaShieldOfDaybreakAttack", target = true, skillshot = false, cc = "Stun", menu = 100, delay = 0.0, math.huge },
        { Spell = "E", slot = 2, name = "LeonaZenithBlade", target = false, skillshot = true, missile = true, cc = "Snare", menu = 100, delay = 0.25, 2000.0 },
        { Spell = "R", slot = 3, name = "LeonaSolarFlare", target = false, skillshot = true, cc = "Stun", menu = 100, delay = 0.875, math.huge },
    },
    ["Lillia"] = {
        { Spell = "Q", slot = 0, name = "LilliaQ", target = false, skillshot = true, menu = 0, delay = 0.25, math.huge },
        { Spell = "W", slot = 1, name = "LilliaW", target = false, skillshot = true, menu = 70, delay = 0.759, math.huge },
        { Spell = "E", slot = 2, name = "LilliaE", target = false, skillshot = true, missile = true, menu = 0, delay = 0.4, 1400.0 },
        { Spell = "R", slot = 3, name = "LilliaR", target = true, skillshot = false, cc = "Asleep", menu = 100, delay = 2.0, math.huge },
    },
    ["Lissandra"] = {
        { Spell = "Q", slot = 0, name = "LissandraQskillshot", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, 2200.0 },
        { Spell = "W", slot = 1, name = "LissandraW", target = false, skillshot = true, menu = 100, delay = 0.0, math.huge },
        { Spell = "E", slot = 2, name = "LissandraEskillshot", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, 640.0 },
        { Spell = "R", slot = 3, name = "LissandraREnemy", target = true, skillshot = false, menu = 100, delay = 0.375, math.huge },
    },
    ["Lucian"] = {
        { Spell = "Q", slot = 0, name = "LucianQ", target = true, skillshot = false, menu = 35, delay = 0.25, math.huge },
        { Spell = "W", slot = 1, name = "LucianW", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, 1600.0 },
        { Spell = "R", slot = 3, name = "LucianR", target = false, skillshot = true, missile = true, menu = 0, delay = 0.0, 3000.0 },
    },
    ["Lulu"] = {
        { Spell = "Q", slot = 0, name = "LuluQskillshot", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, 1450.0 },
        { Spell = "W", slot = 1, name = "LuluWTwo", target = true, skillshot = false, missile = true, cc = "Stun", menu = 100, delay = 0.2419, math.huge },
        { Spell = "E", slot = 2, name = "LuluE", target = true, skillshot = false, menu = 0, delay = 0.0, math.huge },
        { Spell = "R", slot = 3, name = "LuluR", target = false, skillshot = true, cc = "Knockup", menu = 100, delay = 0.0, math.huge },
    },
    ["Lux"] = {
        { Spell = "Q", slot = 0, name = "LuxLightBinding", target = false, skillshot = true, missile = true, cc = "Snare", menu = 35, delay = 0.25, 1200.0 },
        { Spell = "E", slot = 2, name = "LexLightStrikeKugel", target = false, skillshot = true, missile = true, menu = 35, delay = 0.25, 1200.0 },
        { Spell = "R", slot = 3, name = "LuxR", target = false, skillshot = true, menu = 35, delay = 1.0, math.huge },
    },
    ["Malphite"] = {
        { Spell = "Q", slot = 0, name = "SeismicShard", target = true, skillshot = false, missile = true, menu = 35, delay = 0.25, 1200.0 },
        { Spell = "E", slot = 2, name = "Landslide", target = false, skillshot = true, menu = 0, delay = 0.2419, math.huge },
        { Spell = "R", slot = 3, name = "UFSlash", target = false, skillshot = true, cc = "Knockup", menu = 100, delay = 0.0, 1500.0 },
    },
    ["Malzahar"] = {
        { Spell = "Q", slot = 0, name = "MalzaharQ", target = false, skillshot = true, menu = 0, delay = 0.65, math.huge },
        { Spell = "E", slot = 2, name = "MalzaharE", target = true, skillshot = false, menu = 50, delay = 0.25, math.huge },
        { Spell = "R", slot = 3, name = "MalzaharR", target = true, skillshot = false, cc = "Suppression", menu = 100, delay = 0.005, math.huge },
    },
    ["Maokai"] = {
        { Spell = "Q", slot = 0, name = "MaokaiQ", target = false, skillshot = true, missile = true, cc = "Knockup", menu = 0, delay = 0.3889, math.huge },
        { Spell = "W", slot = 1, name = "MaokaiW", target = true, skillshot = false, cc = "Snare", menu = 100, delay = 0.0, 1300.0 },
        { Spell = "R", slot = 3, name = "MaokaiR", target = false, skillshot = true, missile = true, cc = "Snare", menu = 100, delay = 0.5, 700.0 },
    },
    ["MissFortune"] = {
        { Spell = "Q", slot = 0, name = "MissFortuneRicochetShot", target = true, skillshot = false, missile = true, menu = 35, delay = 0.1, 1400.0 },
        { Spell = "E", slot = 2, name = "MissFortuneScattershot", target = false, skillshot = true, menu = 0, delay = 0.25, math.huge },
        { Spell = "R", slot = 3, name = "MissFortuneBulletTime", target = false, skillshot = true, missile = true, menu = 0, delay = 0.0, math.huge },
    },
    ["Mordekaiser"] = {
        { Spell = "Q", slot = 0, name = "MordekaiserQ", target = false, skillshot = true, menu = 0, delay = 0.5, math.huge },
        { Spell = "E", slot = 2, name = "MordekaiserE", target = false, skillshot = true, cc = "Knockup", menu = 70, delay = 0.25, 3000.0 },
        { Spell = "R", slot = 3, name = "MordekaiserR", target = true, skillshot = false, cc = "Suppression", menu = 100, delay = 0.5, math.huge },
    },
    ["Morgana"] = {
        { Spell = "Q", slot = 0, name = "MorganaQ", target = false, skillshot = true, missile = true, cc = "Snare", menu = 70, delay = 0.25, 1200.0 },
        { Spell = "R", slot = 3, name = "MorganaR", target = true, skillshot = false, cc = "Stun", menu = 100, delay = 0.35, math.huge },
    },
    ["Nami"] = {
        { Spell = "Q", slot = 0, name = "NamiQ", target = false, skillshot = true, missile = true, cc = "Snare", menu = 70, delay = 0.976, math.huge },
        { Spell = "R", slot = 3, name = "NamiR", target = false, skillshot = true, missile = true, cc = "Knockup", menu = 0, delay = 0.5, 850.0 },
    },
    ["Nasus"] = {
        { Spell = "Q", slot = 0, name = "NasusQAttack", target = true, skillshot = false, menu = 35, delay = 0.0, math.huge },
        { Spell = "W", slot = 1, name = "NasusW", target = true, skillshot = false, menu = 60, delay = 0.25, math.huge },
    },
    ["Nautilus"] = {
        { Spell = "Q", slot = 0, name = "NautilusAnchorDrag", target = false, skillshot = true, missile = true, cc = "Stun", menu = 50, delay = 0.25, 2000.0 },
        { Spell = "R", slot = 3, name = "NautilusGrandLine", target = false, skillshot = true, missile = true, cc = "Knockup", menu = 100, delay = 0.25, math.huge },
    },
    ["Neeko"] = {
        { Spell = "Q", slot = 0, name = "NeekoQ", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, 2000.0 },
        { Spell = "E", slot = 2, name = "NeekoE", target = false, skillshot = true, missile = true, cc = "Snare", menu = 70, delay = 0.25, 1300.0 },
        { Spell = "R", slot = 3, name = "NeekoR", target = false, skillshot = true, cc = "Stun", menu = 100, delay = 1.85, math.huge },
    },
    ["Nidalee"] = {
        { Spell = "Person Q", slot = 0, name = "JavelinToss", target = false, skillshot = true, missile = true, menu = 50, delay = 0.25, 1300.0 },
        { Spell = "Person W", slot = 1, name = "Bushwhack", target = false, skillshot = true, menu = 0, delay = 0.25, math.huge },
        { Spell = "Q", slot = 0, name = "NidaleeTakedownAttack", target = true, skillshot = false, menu = 35, delay = 0.1, math.huge },
        { Spell = "W", slot = 1, name = "Pounce", target = false, skillshot = true, menu = 0, delay = 0.0, 2000.0 },
        { Spell = "E", slot = 2, name = "Swipe", target = false, skillshot = true, menu = 0, delay = 0.25, math.huge },
    },
    ["Nilah"] = {
        { Spell = "Q", slot = 0, name = "NilahQ", target = false, skillshot = true, menu = 0, delay = 0.25, math.huge },
        { Spell = "E", slot = 2, name = "NilahE", target = true, skillshot = false, menu = 0, delay = 0.25, math.huge },
        { Spell = "R", slot = 3, name = "NilahR", target = false, skillshot = true, menu = 100, delay = 0.25, math.huge },
    },
    ["Nocturne"] = {
        { Spell = "Q", slot = 0, name = "Nocturne", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, 1600.0 },
        { Spell = "E", slot = 2, name = "NocturneUnspeakableHorror", target = true, skillshot = false, cc = "Fear", menu = 100, delay = 2.0, math.huge },
        { Spell = "R", slot = 3, name = "NocturneParanoia2", target = true, skillshot = false, menu = 100, delay = 0.0, 1800.0 },
    },
    ["Nunu"] = {
        { Spell = "Q", slot = 0, name = "NunuQ", target = true, skillshot = false, menu = 30, delay = 0.3, math.huge },
        { Spell = "W", slot = 1, name = "NunuW", target = false, skillshot = true, cc = "Knockup", menu = 80, delay = 0.0, math.huge },
        { Spell = "E", slot = 2, name = "NunuE", target = false, skillshot = true, missile = true, menu = 0, delay = 0.0, math.huge },
        { Spell = "R", slot = 3, name = "NunuR", target = false, skillshot = true, menu = 50, delay = 3.0, math.huge },
    },
    ["Olaf"] = {
        { Spell = "Q", slot = 0, name = "OlafAxeThrowCast", target = false, skillshot = true, missile = true, menu = 60, delay = 0.25, 1600.0 },
        { Spell = "E", slot = 2, name = "OlafRecklessStrike", target = true, skillshot = false, menu = 30, delay = 0.25, math.huge },
    },
    ["Orianna"] = {
        { Spell = "Q", slot = 0, name = "OrianalzunaCommnd", target = false, skillshot = true, missile = true, menu = 0, delay = 0.0, 1400.0 },
        { Spell = "W", slot = 1, name = "OrianaDissonanceCommand", target = false, skillshot = true, menu = 0, delay = 0.0, math.huge },
        { Spell = "R", slot = 3, name = "OrianaDetonateCommand", target = false, skillshot = true, cc = "Knockup", menu = 100, delay = 0.5, math.huge },
    },
    ["Ornn"] = {
        { Spell = "Q", slot = 0, name = "OrnnQ", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, 1800.0 },
        { Spell = "E", slot = 2, name = "OrnnE", target = false, skillshot = true, cc = "Knockup", menu = 100, delay = 0.35, 1600.0 },
        { Spell = "R2", slot = 3, name = "OrnnR", target = false, skillshot = true, missile = true, menu = 0, delay = 0.5, 1200.0 }, 
        { Spell = "R2", slot = 3, name = "OrnnRCharge", target = false, skillshot = true, missile = true, cc = "Knockup", menu = 100, delay = 0.5, 1200.0 },
    },
    ["Pantheon"] = {
        { Spell = "Q", slot = 0, name = "PantheonQ", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, math.huge },
        { Spell = "W", slot = 1, name = "PantheonW", target = true, skillshot = false, cc = "Stun", menu = 100, delay = 0.25, 2500.0 },
        { Spell = "R", slot = 3, name = "PantheonR", target = false, skillshot = true, menu = 0, delay = 0.1, math.huge },
    },
    ["Poppy"] = {
        { Spell = "Q", slot = 0, name = "PoppyQ", target = false, skillshot = true, menu = 0, delay = 0.25, math.huge },
        { Spell = "E", slot = 2, name = "PoppyE", target = true, skillshot = false, cc = "Stun", menu = 100, delay = 0.0, 2000.0 },
        { Spell = "R", slot = 3, name = "PoppyR", target = false, skillshot = true, missile = true, cc = "Knockup", menu = 100, delay = 0.35, 2500.0 },
    },
    ["Pyke"] = {
        { Spell = "Q", slot = 0, name = "PykeQ", target = false, skillshot = true, missile = true, cc = "Knockup", menu = 80, delay = 0.25, 2000.0 },
        { Spell = "E", slot = 2, name = "PykeE", target = false, skillshot = true, menu = 80, delay = 1.0, 3000.0 },
        { Spell = "R", slot = 3, name = "PykeR", target = false, skillshot = true, menu = 44, delay = 0.5, math.huge },
    },
    ["Qiyana"] = {
        { Spell = "Q_Water", slot = 0, name = "QiyanaQ_Water", target = false, skillshot = true, missile = true, cc = "Stun", menu = 100, delay = 0.25, math.huge },
        { Spell = "Q_Rock", slot = 0, name = "QiyanaQ_Rock", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, math.huge },
        { Spell = "Q_Grass", slot = 0, name = "QiyanaQ_Grass", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, math.huge },
        { Spell = "E", slot = 2, name = "QiyanaE", target = true, skillshot = false, menu = 0, delay = 0.0, 1000 },
        { Spell = "R", slot = 3, name = "QiyanaR", target = false, skillshot = true, missile = true, cc = "Stun", menu = 100, delay = 0.25, 2000 },
    },
    ["Quinn"] = {
        { Spell = "Q", slot = 0, name = "QuinnQ", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, 1550 },
        { Spell = "E", slot = 2, name = "QuinnE", target = true, skillshot = false, cc = "Stun", menu = 80, delay = 0.0, 2500 },
    },
    ["Rakan"] = {
        { Spell = "Q", slot = 0, name = "RakanQ", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, 2000 },
        { Spell = "W", slot = 1, name = "RakanW", target = false, skillshot = true, cc = "Knockup", menu = 80, delay = 0.35, 1800 },
        { Spell = "R", slot = 3, name = "RakanR", target = false, skillshot = true, cc = "Charm", menu = 100, delay = 0.5, math.huge },
    },
    ["Rammus"] = {
        { Spell = "Q", slot = 0, name = "PowerBall", target = false, skillshot = true, cc = "Knockup", menu = 100, delay = 0.0, math.huge },
        { Spell = "E", slot = 2, name = "PuncturingTaunt", target = true, skillshot = false, cc = "Taunt", menu = 100, delay = 0.25, math.huge },
        },
    ["RekSai"] = {
        { Spell = "Q1", slot = 0, name = "RekSaiQ", target = false, skillshot = true, menu = 0, delay = 0.0, math.huge },
        { Spell = "E1", slot = 2, name = "RekSaiE", target = true, skillshot = false, menu = 35, delay = 0.25, math.huge },
        { Spell = "R1", slot = 3, name = "RekSaiRWrapper", target = true, skillshot = false, menu = 40, delay = 0.25, 1400.0 },
        { Spell = "Q2", slot = 0, name = "RekSaiQBurrowed", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, math.huge },
        { Spell = "W2", slot = 1, name = "RekSaiWUnburrowLockout", target = false, skillshot = true, cc = "Knockup", menu = 100, delay = 0.25, math.huge },
    },
    ["Rell"] = {
        { Spell = "Q", slot = 0, name = "RellQ", target = false, skillshot = true, menu = 0, delay = 0.35, math.huge },
        { Spell = "W", slot = 1, name = "RellW_Dismount", target = false, skillshot = true, cc = "Knockup", menu = 100, delay = 0.625, 1000 },
        { Spell = "R", slot = 3, name = "RellR", target = false, skillshot = true, cc = "Charm", menu = 100, delay = 0.25, math.huge },
    },
    ["Renata"] = {
        { Spell = "Q", slot = 0, name = "", target = false, skillshot = true, missile = true, cc = "Stun", menu = 80, delay = 0.25, 1450 },
        { Spell = "E", slot = 2, name = "", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, 1500 },
        { Spell = "R", slot = 3, name = "", target = false, skillshot = true, missile = true, cc = "Taunt", menu = 100, delay = 0.75, 800 },
    },
    ["Renekton"] = {
        { Spell = "Q", slot = 0, name = "RenektonCleave", target = false, skillshot = true, menu = 0, delay = 0.0, math.huge },
        { Spell = "W", slot = 2, name = "RenektonPreExecute", target = true, skillshot = false, cc = "Stun", menu = 100, delay = 0.1, math.huge },
        { Spell = "Angry W", slot = 2, name = "RenektonSuperExecute", target = true, skillshot = false, cc = "Stun", menu = 100, delay = 0.1, math.huge },
        { Spell = "E", slot = 3, name = "RenektonSliceAndDice", target = false, skillshot = true, menu = 0, delay = 0.0, 1000 },
    },
    ["Rengar"] = {
        { Spell = "Q", slot = 0, name = "RengarQ", target = true, skillshot = false, menu = 70, delay = 0.1, math.huge },
        { Spell = "W", slot = 1, name = "RengarW", target = false, skillshot = true, menu = 0, delay = 0.0, math.huge },
        { Spell = "E", slot = 2, name = "RengarE", target = false, skillshot = true, missile = true, cc = "Snare", menu = 80, delay = 0.0, 1500 },
    },
    ["Riven"] = {
        { Spell = "Q3", slot = 0, name = "RivenTriCleave", target = false, skillshot = true, cc = "Knockup", menu = 100, delay = 0.25, 500 },
        { Spell = "R", slot = 3, name = "rivenizunablade", target = false, skillshot = true, missile = true, menu = 40, delay = 0.25, 1600 },
    },
    ["Rumble"] = {
        { Spell = "E", slot = 2, name = "RumbleGrenade", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, 2000 },
        { Spell = "R", slot = 3, name = "RumbleCarpetBomb", target = false, skillshot = true, menu = 0, delay = 0.5833, 1600 },
    },
    ["Ryze"] = {
        { Spell = "Q", slot = 0, name = "RyzeQWrapper", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, 1700 },
        { Spell = "W", slot = 1, name = "RyzeW", target = true, skillshot = false, cc = "Snare", menu = 70, delay = 0.25, math.huge },
        { Spell = "E", slot = 2, name = "RyzeE", target = true, skillshot = false, missile = true, menu = 0, delay = 0.25, 3000 },
    },
    ["Samira"] = {
        { Spell = "Q", slot = 0, name = "SamiraQ", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, 2600 },
        { Spell = "W", slot = 1, name = "SamiraW", target = false, skillshot = true, menu = 0, delay = 0.1, math.huge },
        { Spell = "E", slot = 2, name = "SamiraE", target = true, skillshot = false, menu = 100, delay = 0.0, 1600 },
        { Spell = "R", slot = 3, name = "SamiraR", target = false, skillshot = true, missile = true, menu = 0, delay = 0.0, math.huge },
    },
    ["Sejuani"] = {
        { Spell = "Q", slot = 0, name = "SejuaniQ", target = false, skillshot = true, cc = "Knockup", menu = 80, delay = 0.0, 1000 },
        { Spell = "W", slot = 1, name = "SejuaniW", target = false, skillshot = true, menu = 0, delay = 1.0, math.huge },
        { Spell = "E", slot = 2, name = "SejuaniE", target = true, skillshot = false, missile = true, cc = "Stun", menu = 100, delay = 0.25, math.huge },
        { Spell = "R", slot = 3, name = "SejuaniR", target = false, skillshot = true, missile = true, cc = "Stun", menu = 80, delay = 0.25, 1600 },
    },
    ["Senna"] = {
        { Spell = "Q", slot = 0, name = "SennaQ", target = false, skillshot = true, menu = 0, delay = 0.25, math.huge },
        { Spell = "W", slot = 1, name = "SennaW", target = false, skillshot = true, missile = true, cc = "Snare", menu = 80, delay = 0.25, 1200 },
        { Spell = "R", slot = 3, name = "SennaR", target = false, skillshot = true, missile = true, menu = 0, delay = 1.0, 20000 },
    },
    ["Seraphine"] = {
        { Spell = "Q", slot = 0, name = "SeraphineQ", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, 1200 },
        { Spell = "E", slot = 2, name = "SeraphineE", target = false, skillshot = true, missile = true, cc = "Stun", menu = 0, delay = 0.25, 1200 },
        { Spell = "R", slot = 3, name = "SeraphineR", target = false, skillshot = true, missile = true, cc = "Charm", menu = 80, delay = 0.5, 1600 },
    },
    ["Sett"] = {
        { Spell = "Q1", slot = 0, name = "SettQAttack", target = true, skillshot = false, menu = 0, delay = 0.0, math.huge },
        { Spell = "Q2", slot = 0, name = "SettQAttack2", target = true, skillshot = false, menu = 0, delay = 0.0, math.huge },
        { Spell = "W", slot = 1, name = "SettW", target = false, skillshot = true, menu = 40, delay = 0.75, math.huge },
        { Spell = "E", slot = 2, name = "SettE", target = false, skillshot = true, cc = "Stun", menu = 100, delay = 0.25, math.huge },
        { Spell = "R", slot = 3, name = "SettR", target = true, skillshot = false, cc = "Stun", menu = 100, delay = 0.0, math.huge },
    },
    ["Shaco"] = {
        { Spell = "E", slot = 2, name = "TwoShivPoison", target = true, skillshot = false, missile = true, menu = 0, delay = 0.25, 2000 },
    },
    ["Shen"] = {
        { Spell = "Q", slot = 0, name = "ShenQ", target = false, skillshot = true, menu = 0, delay = 0.0, 3500 },
        { Spell = "E", slot = 2, name = "ShenE", target = false, skillshot = true, cc = "Taunt", menu = 0, delay = 0.0, 2000 },
    },
    ["Shyvana"] = {
        { Spell = "Q", slot = 0, name = "ShyvanaDoubleAttack", target = true, skillshot = false, menu = 0, delay = 0.1, math.huge },
        { Spell = "E", slot = 2, name = "ShyvanaFireball", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, 1600 },
        { Spell = "R", slot = 3, name = "ShyvanaTransformCast", target = false, skillshot = true, cc = "Knockup", menu = 40, delay = 0.25, 1000 },
        { Spell = "Dragon Q", slot = 0, name = "ShyvanaDoubleAttackDragon", target = true, skillshot = false, menu = 40, delay = 0.0, math.huge },
        { Spell = "Dragon E", slot = 2, name = "ShyvanaFireballDragon2", target = false, skillshot = true, missile = true, menu = 0, delay = 0.3333, 1575 },
    },
    ["Singed"] = {
        { Spell = "W", slot = 1, name = "MegaAdhesive", target = false, skillshot = true, menu = 0, delay = 0.25, math.huge },
        { Spell = "E", slot = 2, name = "Fling", target = true, skillshot = false, cc = "Knockup", menu = 100, delay = 0.25, math.huge },
    },
    ["Sion"] = {
        { Spell = "Q", slot = 0, name = "SionQ", target = false, skillshot = true, cc = "Knockup", menu = 0, delay = 2.0, math.huge },
        { Spell = "E", slot = 2, name = "SionE", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, 1800 },
        { Spell = "R", slot = 3, name = "SionR", target = false, skillshot = true, cc = "Knockup", menu = 70, delay = 0.0, math.huge },
    },
    ["Sivir"] = {
        { Spell = "Q", slot = 0, name = "SivirQ", target = false, skillshot = true, missile = true, menu = 0, delay = 0.1, 1450 },
    },
    ["Skarner"] = {
        { Spell = "E", slot = 2, name = "SkarnerFracture", target = false, skillshot = true, missile = true, cc = "Stun", menu = 80, delay = 0.25, 1500 },
        { Spell = "R", slot = 3, name = "SkarnerImpale", target = true, skillshot = false, cc = "Suppression", menu = 100, delay = 0.25, math.huge },
    },
    ["Sona"] = {
        { Spell = "Q", slot = 0, name = "SonaQ", target = true, skillshot = false, missile = true, menu = 00, delay = 0.0, 1300 },
        { Spell = "R", slot = 3, name = "SonaR", target = false, skillshot = true, missile = true, cc = "Stun", menu = 80, delay = 0.25, 2400 },
    },
    ["Soraka"] = {
        { Spell = "Q", slot = 0, name = "SorakaQ", target = false, skillshot = true, missile = true, menu = 0 , delay = 0.25, 800 },
        { Spell = "E", slot = 2, name = "SorakaE", target = false, skillshot = true, cc = "Snare", menu = 0, delay = 0.25, math.huge },
    },
    ["Swain"] = {
        { Spell = "Q", slot = 0, name = "SwainQ", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, math.huge },
        { Spell = "W", slot = 1, name = "SwainW", target = false, skillshot = true, menu = 0, delay = 1.5, math.huge },
        { Spell = "E", slot = 2, name = "SwainE", target = false, skillshot = true, missile = true, cc = "Snare", menu = 0, delay = 0.25, 935 },
    },
    ["Sylas"] = {
        { Spell = "Q", slot = 0, name = "SylasQ", target = false, skillshot = true, missile = true, menu = 0, delay = 0.4, math.huge },
        { Spell = "W", slot = 1, name = "SylasW", target = true, skillshot = false, menu = 0, delay = 0.0, math.huge },
        { Spell = "E", slot = 2, name = "SylasE", target = false, skillshot = true, menu = 100, delay = 0.25, 1600 },
        { Spell = "R", slot = 3, name = "SylasR", target = true, skillshot = false, missile = true, menu = 80, delay = 0.25, 2200 },
    },
    ["Syndra"] = {
        { Spell = "Q", slot = 0, name = "SyndraQ", target = false, skillshot = true, menu = 0, delay = 0.6, math.huge },
        { Spell = "W", slot = 1, name = "SyndraW", target = false, skillshot = true, menu = 0, delay = 0.0, 1000 },
        { Spell = "E", slot = 2, name = "SyndraE", target = false, skillshot = true, cc = "Stun", menu = 0, delay = 0.25, 2500 },
        { Spell = "R", slot = 3, name = "SyndraR", target = true, skillshot = false, missile = true, menu = 80, delay = 0.264, 1000 },
    },
    ["TahmKench"] = {
        { Spell = "Q", slot = 0, name = "TahmKenchQ", target = false, skillshot = true, missile = true, cc = "Stun", menu = 30, delay = 0.25, 2800 },
        { Spell = "W", slot = 1, name = "TahmKenchW", target = false, skillshot = true, cc = "Knockup", menu = 0, delay = 1.5, math.huge },
        { Spell = "R", slot = 3, name = "TahmKenchR", target = true, skillshot = false, cc = "Stun", menu = 100, delay = 0.25, math.huge },
    },
    ["Taliyah"] = {
        { Spell = "Q", slot = 0, name = "TaliyahQ", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, 2000 },
        { Spell = "W", slot = 1, name = "TaliyahWVC", target = false, skillshot = true, cc = "Knockup", menu = 100, delay = 0.759, math.huge },
        { Spell = "E", slot = 2, name = "TaliyahE", target = false, skillshot = true, cc = "Stun", menu = 0, delay = 0.25, 1700 },
    },
    ["Talon"] = {
        { Spell = "Q", slot = 0, name = "TalonQ", target = true, skillshot = false, menu = 40, delay = 0.25, 1400 },
        { Spell = "W", slot = 1, name = "TalonW", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, 2357 },
        { Spell = "R", slot = 3, name = "TalonR", target = false, skillshot = true, menu = 0, delay = 0.0, 7000 },
    },
    ["Taric"] = {
        { Spell = "E", slot = 2, name = "TaricE", target = false, skillshot = true, cc = "Stun", menu = 60, delay = 1.0, math.huge },
    },
    ["Teemo"] = {
        { Spell = "Q", slot = 0, name = "BlindingDart", target = true, skillshot = false, missile = true, menu = 80, delay = 0.25, math.huge },
    },
    ["Thresh"] = {
        { Spell = "Q", slot = 0, name = "ThreshQ", target = false, skillshot = true, missile = true, cc = "Stun", menu = 30, delay = 0.25, 1900 },
        { Spell = "E", slot = 2, name = "ThreshEFlay", target = false, skillshot = true, cc = "Knockup", menu = 70, delay = 0.25, 2000 },
        --{ Spell = "R", slot = 3, name = "ThreshR", target = false, skillshot = true, menu = 0, delay = 0.45, math.huge },
    },
    ["Tristana"] = {
        { Spell = "E", slot = 2, name = "TristanaE", target = true, skillshot = false, missile = true, menu = 40, delay = 0.25, 2400 },
        { Spell = "R", slot = 3, name = "TristanaR", target = true, skillshot = false, missile = true, menu = 100, delay = 0.25, 2000 },
    },
    ["Trundle"] = {
        { Spell = "Q", slot = 0, name = "TrundleQ", target = true, skillshot = false, menu = 0, delay = 0.25, math.huge },
        { Spell = "R", slot = 3, name = "TrundlePain", target = true, skillshot = false, menu = 0, delay = 0.25, math.huge },
    },
    ["Tryndamere"] = {
        { Spell = "W", slot = 1, name = "TryndamereW", target = true, skillshot = false, menu = 0, delay = 0.3, math.huge },
        { Spell = "E", slot = 2, name = "TryndamereE", target = false, skillshot = true, menu = 0, delay = 0.0, 2000.0 },
    },
    ["TwistedFate"] = {
        { Spell = "Q", slot = 0, name = "WildCards", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, 1000.0 },
        { Spell = "Gold card", slot = 1, name = "GoldCardPreAttack", target = true, skillshot = false, missile = true, menu = 70, cc = "Stun", delay = 0.0, 1500.0 },
    },
    ["Twitch"] = {
        { Spell = "W", slot = 1, name = "TwitchVenomCask", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, 1400.0 },
        { Spell = "E", slot = 2, name = "TwitchVenomCaskskillshot", target = true, skillshot = false, missile = true, menu = 0, delay = 0.0, 3000.0 },
        { Spell = "R", slot = 3, name = "TwitchSprayAndPrayAttack", target = false, skillshot = true, missile = true, menu = 0, delay = 0.0, 4000.0 },
    },
    ["Udyr"] = {
        { Spell = "E", slot = 2, name = "UdyrEAttack", target = true, skillshot = false, menu = 100, cc = "Stun", delay = 0.25, math.huge },
    },
    ["Urgot"] = {
        { Spell = "Q", slot = 0, name = "UrgotQ", target = false, skillshot = true, menu = 0, delay = 0.55, math.huge },
        { Spell = "E", slot = 2, name = "UrgotE", target = false, skillshot = true, menu = 70, cc = "Knockup", delay = 0.45, 1200.0 },
        { Spell = "R", slot = 3, name = "UrgotR", target = false, skillshot = true, missile = true, menu = 50, cc = "Stun", delay = 0.5, 3200.0 },
    },
    ["Varus"] = {
        { Spell = "Q", slot = 0, name = "VarusQ", target = false, skillshot = true, missile = true, menu = 0, delay = 0.0, 1900.0 },
        { Spell = "E", slot = 1, name = "VarusE", target = false, skillshot = true, missile = true, menu = 0, delay = 0.2419, 1600.0 },
        { Spell = "R", slot = 3, name = "VarusR", target = false, skillshot = true, missile = true, menu = 80, cc = "Snare", delay = 0.25, 1500.0 },
    },
    ["Vayne"] = {
        { Spell = "E", slot = 2, name = "VayneCondemn", target = true, skillshot = false, missile = true, menu = 100, delay = 0.25, 2200.0 },
    },
    ["Veigar"] = {
        { Spell = "Q", slot = 0, name = "VeigarQ", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, math.huge },
        { Spell = "W", slot = 1, name = "VeigarW", target = false, skillshot = true, menu = 0, delay = 0.25, math.huge },
        { Spell = "E", slot = 2, name = "VeigarE", target = false, skillshot = true, menu = 0, delay = 0.25, math.huge },
        { Spell = "R", slot = 3, name = "VeigarR", target = true, skillshot = false, missile = true, menu = 100, delay = 0.25, math.huge },
    },
    ["Velkoz"] = {
        { Spell = "Q", slot = 0, name = "VelkozQ", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, 1300.0 },
        { Spell = "W", slot = 1, name = "VelkozW", target = false, skillshot = true, missile = true, menu = 0, delay = 0.0, 1700.0 },
        { Spell = "E", slot = 2, name = "VelkozE", target = false, skillshot = true, missile = true, menu = 70, cc = "Knockup", delay = 0.75, math.huge },
        { Spell = "R", slot = 3, name = "VelkozR", target = false, skillshot = true, menu = 0, delay = 0.0, math.huge },
    },
    ["Vex"] = {
        { Spell = "Q1 Fear", slot = 0, name = "VexQ", target = false, skillshot = true, missile = true, menu = 80, delay = 0.15, 3200.0 },
        { Spell = "Q2 Fear", slot = 0, name = "VexQ2", target = false, skillshot = true, menu = 0, delay = 0.15, 3200.0 },
        { Spell = "E Fear", slot = 2, name = "VexE", target = false, skillshot = true, menu = 80, delay = 0.25, 1300.0 },
        { Spell = "R1", slot = 3, name = "VexR", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, 1600.0 },
        { Spell = "R2", slot = 3, name = "VexR2", target = true, skillshot = false, menu = 70, delay = 0.0, 2200.0 },
    },
    ["Vi"] = {
        { Spell = "Q", slot = 0, name = "ViQ", target = false, skillshot = true, cc = "Knockup", menu = 100, delay = 0.0, 1400 },
        { Spell = "R", slot = 3, name = "ViR", target = true, skillshot = false, cc = "Knockup", menu = 100, delay = 0.25, 800 },
    },
    ["Viego"] = {
        { Spell = "Q", slot = 0, name = "ViegoQ", target = false, skillshot = true, menu = 0, delay = 0.25, math.huge },
        { Spell = "W", slot = 1, name = "ViegoW", target = false, skillshot = true, cc = "Stun", menu = 80, delay = 0.25, 1300 },
        { Spell = "R", slot = 3, name = "ViegoR", target = false, skillshot = true, menu = 100, delay = 0.5, math.huge },
    },
    ["Viktor"] = {
        { Spell = "Q", slot = 0, name = "ViktorPowerTransfer", target = true, skillshot = false, missile = true, menu = 0, delay = 0.0, 2000 },
        { Spell = "W", slot = 1, name = "ViktorGravitonField", target = false, skillshot = true, cc = "Stun", menu = 0, delay = 0.75, math.huge },
        { Spell = "E", slot = 2, name = "ViktorDeathRay", target = false, skillshot = true, missile = true, menu = 0, delay = 0.0, 1050 },
        { Spell = "R", slot = 3, name = "ViktorChaosStorm", target = false, skillshot = true, menu = 0, delay = 0.25, math.huge },
    },
    ["Vladimir"] = {
        { Spell = "Q", slot = 0, name = "VladimirQ", target = true, skillshot = false, menu = 0, delay = 0.25, math.huge },
        { Spell = "E", slot = 2, name = "VladimirE", target = false, skillshot = true, missile = true, menu = 0, delay = 1.0, 4000 },
        { Spell = "R", slot = 3, name = "VladmirHemoplague", target = false, skillshot = true, menu = 0, delay = 0.0, math.huge },
    },
    ["Volibear"] = {
        { Spell = "Q", slot = 0, name = "VolibearQ", target = true, skillshot = false, cc = "Stun", menu = 80, delay = 0.0, math.huge },
        { Spell = "W", slot = 1, name = "VolibearW", target = true, skillshot = false, menu = 30, delay = 0.25, math.huge },
        { Spell = "E", slot = 2, name = "VolibearE", target = false, skillshot = true, menu = 0, delay = 2.0, math.huge },
        { Spell = "R", slot = 3, name = "VolibearR", target = false, skillshot = true, menu = 80, delay = 0.25, 750 },
    },
    ["Warwick"] = {
        { Spell = "Q", slot = 0, name = "WarwickQ", target = true, skillshot = false, menu = 0, delay = 0.1, math.huge },
        { Spell = "E", slot = 2, name = "WarwickE", target = false, skillshot = true, cc = "Fear", menu = 0, delay = 0.0, math.huge },
        { Spell = "R", slot = 3, name = "WarwickR", target = false, skillshot = true, cc = "Suppression", menu = 100, delay = 0.1, 1000 },
    },
    ["MonkeyKing"] = {
        { Spell = "Q", slot = 0, name = "MonkeyKingQAttack", target = true, skillshot = false, menu = 0, delay = 0.1, math.huge },
        { Spell = "E", slot = 2, name = "MonkeyKingNimbus", target = false, skillshot = true, menu = 50, delay = 0.0, 1000 },
        { Spell = "R", slot = 3, name = "MonkeyKingSpinToWin", target = false, skillshot = true, cc = "Knockup", menu = 100, delay = 0.0, math.huge },
    },
    ["Xayah"] = {
        { Spell = "Q", slot = 0, name = "XayahQ", target = false, skillshot = true, missile = true, menu = 0, delay = 0.1, 4000 },
        { Spell = "E", slot = 2, name = "XayahE", target = false, skillshot = true, missile = true, cc = "Snare", menu = 100, delay = 0.25, 4000 },
        { Spell = "R", slot = 3, name = "XayahR", target = false, skillshot = true, missile = true, menu = 0, delay = 1.5, 3000 },
    },
    ["Xerath"] = {
        { Spell = "Q", slot = 0, name = "XerathArcanopulse2", target = false, skillshot = true, menu = 0, delay = 0.0, math.huge },
        { Spell = "W", slot = 1, name = "XerathArcaneBarrage2", target = false, skillshot = true, menu = 0, delay = 0.528, math.huge },
        { Spell = "E", slot = 2, name = "XerathMageSpear", target = false, skillshot = true, missile = true, cc = "Stun", menu = 70, delay = 0.25, 1400 },
        { Spell = "R", slot = 3, name = "XerathRskillshotWrapper", target = false, skillshot = true, menu = 0, delay = 0.25, 1700 },
    },
    ["XinZhao"] = {
        { Spell = "Q3", slot = 0, name = "XinZhaoQThrust3", target = true, skillshot = false, cc = "Knockup", menu = 100, delay = 0.1, math.huge },
        { Spell = "W", slot = 1, name = "XinZhaoW", target = false, skillshot = true, menu = 0, delay = 0.5, math.huge },
        { Spell = "E", slot = 2, name = "XinZhaoE", target = true, skillshot = false, menu = 40, delay = 0.0, 2500 },
        { Spell = "R", slot = 3, name = "XinZhaoR", target = false, skillshot = true, menu = 0, delay = 0.25, math.huge },
    },
    ["Yasuo"] = {
        { Spell = "Q3", slot = 0, name = "YasuoQ3", target = false, skillshot = true, missile = true, cc = "Knockup", menu = 100, delay = 0.175, 1200 },
    },
    ["Yone"] = {
        { Spell = "Q3", slot = 0, name = "YoneQ3", target = false, skillshot = true, missile = true, cc = "Knockup", menu = 100, delay = 0.175, 1200 },
        { Spell = "W", slot = 1, name = "YoneW", target = false, skillshot = true, menu = 0, delay = 0.19, math.huge },
        { Spell = "R", slot = 3, name = "YoneR", target = false, skillshot = true, cc = "Knockup", menu = 100, delay = 0.75, math.huge },
    },
    ["Yorick"] = {
        { Spell = "Q", slot = 0, name = "YorickQAttack", target = true, skillshot = false, menu = 0, delay = 0.1, math.huge },
        { Spell = "E", slot = 2, name = "YorickE", target = false, skillshot = true, missile = true, menu = 0, delay = 0.33, math.huge },
    },
    ["Yuumi"] = {
        { Spell = "R", slot = 3, name = "YuumiR", target = false, skillshot = true, missile = true, cc = "Snare", menu = 0, delay = 0.0, 3000 },
    },
    ["Zac"] = {
        { Spell = "Q", slot = 0, name = "ZacQ", target = false, skillshot = true, missile = true, cc = "Knockup", menu = 0, delay = 0.25, 2800 },
        { Spell = "E", slot = 2, name = "ZacE", target = false, skillshot = true, cc = "Knockup", menu = 100, delay = 0.0, 1000 },
        { Spell = "R", slot = 3, name = "ZacR", target = false, skillshot = true, cc = "Knockup", menu = 100, delay = 0.3, math.huge },
    },
    ["Zed"] = {
        { Spell = "Q", slot = 0, name = "ZedQ", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, 1700 },
        { Spell = "R", slot = 3, name = "ZedR", target = true, skillshot = false, menu = 80, delay = 0.25, math.huge },
    },
    ["Zeri"] = {
        { Spell = "W", slot = 1, name = "ZeriW", target = false, skillshot = true, missile = true, menu = 50, delay = 0.75, math.huge },
    },
    ["Ziggs"] = {
        { Spell = "Q", slot = 0, name = "ZiggsQ", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, 1700 },
        { Spell = "W", slot = 1, name = "ZiggsW", target = false, skillshot = true, missile = true, cc = "Knockup", menu = 0, delay = 0.25, 1750 },
        { Spell = "E", slot = 2, name = "ZiggsE", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, 1550 },
        { Spell = "R", slot = 3, name = "ZiggsR", target = false, skillshot = true, menu = 0, delay = 0.375, 2250 },
    },
    ["Zilean"] = {
        { Spell = "Q", slot = 0, name = "ZileanQ", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, 848 },
        { Spell = "E", slot = 2, name = "TimeWarp", target = true, skillshot = false, menu = 100, delay = 0.25, math.huge },
    },
    ["Zoe"] = {
        { Spell = "Q", slot = 0, name = "ZoeQ", target = false, skillshot = true, missile = true, menu = 0, delay = 0.25, 1200 },
        { Spell = "E", slot = 2, name = "ZoeE", target = false, skillshot = true, missile = true, cc = "Asleep", menu = 100, delay = 0.25, 1850 },
    },
    ["Zyra"] = {
        { Spell = "Q", slot = 0, name = "ZyraQ", target = false, skillshot = true, menu = 0, delay = 0.25, math.huge },
        { Spell = "E", slot = 2, name = "ZyraE", target = false, skillshot = true, missile = true, cc = "Stun", menu = 100, delay = 0.25, 1150 },
        { Spell = "R", slot = 3, name = "ZyraR", target = false, skillshot = true, cc = "Knockup", menu = 40, delay = 2.0, math.huge },
    },
}
return database