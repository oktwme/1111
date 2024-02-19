local spell_db_attacks = 
{
    Aatrox = { "Passive", "AatroxPassiveAttack", 63 },
    Camille = { { "Q", "CamilleQAttackEmpowered", 0 } },
    Darius = { { "W", "DariusNoxianTacticsONHAttack", 1 } },
    Garen = { { "Q", "GarenQAttack", 0 } },
    MonkeyKing = { { "Q", "MonkeyKingQAttack", 0 } },
    Renekton = 
    { 
        { "W", "RenektonExecute", 1 }, 
        { "Empowered W", "RenektonSuperExecute", 1 }
    },
    Volibear = { { "Q", "VolibearQAttack", 0 } },
    TwistedFate = { { "Gold card", "GoldCardPreAttack", 1 } },
    Warwick = { { "Q", "WarwickQ", 0 } },
    Leona = { { "Q", "LeonaShieldOfDaybreakAttack", 0 } },
    Trundle = { { "Q", "TrundleQ", 0 } },
    Udyr = { { "E", "UdyrEAttack", 2 } },
    Alistar = 
    { 
        --incorrect
        { "E", "AlistarBasicAttack2", 2 }, 
        { "E", "AlistarBasicAttack", 2 } 
    },
    Blitzcrank = { { "E", "PowerFistAttack", 2 } },
    Sona = { { "E", "SonaEPassiveAttack", 2 } },
    Zac = { { "Q", "ZacQAttack", 0 } },
    XinZhao = { { "Q3", "XinZhaoQThrust3", 0 } },
    Briar = { { "W2", "BriarWAttackSpell", 1 } },
    Hecarim = { { "E", "HecarimRampAttack", 2 } },
    Illaoi = { { "W", "IllaoiWAttack", 1 } },
    Rengar = 
    { 
        { "Q", "RengarQAttack", 0 }, 
        { "Q2", "RengarQEmpAttack", 0 }
    },
    Caitlyn = { { "Passive", "CaitlynPassiveMissile", 63 } },
}

return spell_db_attacks