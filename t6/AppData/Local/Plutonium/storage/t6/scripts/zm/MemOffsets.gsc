WriteString(string,animation)
{
    if(string != "")
        iPrintLn(string);

    if(animation != "")
        iPrintLn(animation);
}

Gunlock()
{
    // snipers
    Weap = self getcurrentweapon();
    if(issubstr(Weap, "dsr50"))
    {
        if(self.DSRGunlock == 0)
        {
            WriteString(0x1D882A38, "");
            self iprintln("Gunlock ^2Set For DSR");
            self.DSRGunlock = 1;
        } 
        else
        {
            WriteString(0x1D882A38, "viewmodel_dsr50_idle");
            self iprintln("Gunlock ^1Taken From DSR");
            self.DSRGunlock = 0;
        }
    }
    else if(issubstr(Weap, "ballista"))
    {
        if(self.BalGunlock == 0)
        {
            WriteString(0x1D87CB94, "");
            self iprintln("Gunlock ^2Set For Ballista");
            self.BalGunlock = 1;
        } 
        else
        {
            WriteString(0x1D87CB94, "viewmodel_ballista_idle");
            self iprintln("Gunlock ^1Taken From Ballista");
            self.BalGunlock = 0;
        }
    }
    else if(issubstr(Weap, "as50"))
    {
        if(self.XPRGunlock == 0)
        {
            WriteString(0x1D8801C0, "");
            self iprintln("Gunlock ^2Set For XPR-50");
            self.XPRGunlock = 1;
        } 
        else
        {
            WriteString(0x1D8801C0, "viewmodel_xpr50_idle");
            self iprintln("Gunlock ^1Taken From XPR-50");
            self.XPRGunlock = 0;
        }
    }
    else if(issubstr(Weap, "svu"))
    {
        if(self.SVUGunlock == 0)
        {
            WriteString(0x1D8851D0, "");
            self iprintln("Gunlock ^2Set For SVU-AS");
            self.SVUGunlock = 1;
        } 
        else
        {
            WriteString(0x1D8851D0, "viewmodel_svu_as_idle");
            self iprintln("Gunlock ^1Taken From SVU-AS");
            self.SVUGunlock = 0;
        }
    }
    
    // SMGs
    else if(issubstr(Weap, "mp7"))
    {
        if(self.MP7Gunlock == 0)
        {
            WriteString(0x1D810538, "");
            WriteString(0x1D812016, "");
            self iprintln("Gunlock ^2Set For MP7");
            self.MP7Gunlock = 1;
        } 
        else
        {
            WriteString(0x1D810538, "viewmodel_mp7_idle");
            WriteString(0x1D812016, "viewmodel_mp7_grip_idle");
            self iprintln("Gunlock ^1Taken From MP7");
            self.MP7Gunlock = 0;
        }
    }
    else if(issubstr(Weap, "pdw57"))
    {
        if(self.PDWGunlock == 0)
        {
            WriteString(0x1D808DE8, "");
            self iprintln("Gunlock ^2Set For PDW-57");
            self.PDWGunlock = 1;
        } 
        else
        {
            WriteString(0x1D808DE8, "viewmodel_pdw57_idle");
            self iprintln("Gunlock ^1Taken From PDW-57");
            self.PDWGunlock = 0;
        }
    }
    else if(issubstr(Weap, "vector"))
    {
        if(self.VectorGunlock == 0)
        {
            WriteString(0x1D804988, "");
            WriteString(0x1D804E0B, "");
            self iprintln("Gunlock ^2Set For Vector K10");
            self.VectorGunlock = 1;
        } 
        else
        {
            WriteString(0x1D804988, "viewmodel_vector_idle");
            WriteString(0x1D804E0B, "viewmodel_vector_grip_idle");
            self iprintln("Gunlock ^1Taken From Vector K10");
            self.VectorGunlock = 0;
        }
    }
    else if(issubstr(Weap, "evoskorpion"))
    {
        if(self.EVOGunlock == 0)
        {
            WriteString(0x1D80D4B4, "");
            WriteString(0x1D80D9AC, "");
            self iprintln("Gunlock ^2Set For Skorpion EVO");
            self.EVOGunlock = 1;
        } 
        else
        {
            WriteString(0x1D80D4B4, "viewmodel_skorpion_evo_idle");
            WriteString(0x1D80D9AC, "viewmodel_skorpion_evo_grip_idle");
            self iprintln("Gunlock ^1Taken From Skorpion EVO");
            self.EVOGunlock = 0;
        }
    }
    else if(issubstr(Weap, "qcw05"))
    {
        if(self.ChicGunlock == 0)
        {
            WriteString(0x1D816178, "");
            WriteString(0x1D81655C, "");
            self iprintln("Gunlock ^2Set For Chicom CQB");
            self.ChicGunlock = 1;
        } 
        else
        {
            WriteString(0x1D816178, "viewmodel_qcw05_idle");
            WriteString(0x1D81655C, "viewmodel_qcw05_grip_idle");
            self iprintln("Gunlock ^1Taken From Chicom CQB");
            self.ChicGunlock = 0;
        }
    }
    else if(issubstr(Weap, "insas"))
    {
        if(self.MSMCGunlock == 0)
        {
            WriteString(0x1D81A754, "");
            WriteString(0x1D81AAF1, "");
            self iprintln("Gunlock ^2Set For MSMC");
            self.MSMCGunlock = 1;
        } 
        else
        {
            WriteString(0x1D81A754, "viewmodel_msmc_idle");
            WriteString(0x1D81AAF1, "viewmodel_msmc_grip_idle");
            self iprintln("Gunlock ^1Taken From MSMC");
            self.MSMCGunlock = 0;
        }
    }
    else if(issubstr(Weap, "peacekeeper"))
    {
        if(self.PeaceGunlock == 0)
        {
            WriteString(0x1D9570A0, "");
            WriteString(0x1D97E3F4, "");
            self iprintln("Gunlock ^2Set For Peacekeeper");
            self.PeaceGunlock = 1;
        } 
        else
        {
            WriteString(0x1D9570A0, "viewmodel_peacekeeper_idle");
            WriteString(0x1D97E3F4, "viewmodel_peacekeeper_grip_idle");
            self iprintln("Gunlock ^1Taken From Peacekeeper");
            self.PeaceGunlock = 0;
        }
    }
    
    // ARs
    else if(issubstr(Weap, "xm8"))
    {
        if(self.M8A1Gunlock == 0)
        {
            WriteString(0x1D85044C, "");
            WriteString(0x1D8538E5, "");
            self iprintln("Gunlock ^2Set For M8A1");
            self.M8A1Gunlock = 1;
        } 
        else
        {
            WriteString(0x1D85044C, "viewmodel_xm8_idle");
            WriteString(0x1D8538E5, "viewmodel_xm8_grip_idle");
            self iprintln("Gunlock ^1Taken From M8A1");
            self.M8A1Gunlock = 0;
        }
    }
    else if(issubstr(Weap, "an94"))
    {
        if(self.ANGunlock == 0)
        {
            WriteString(0x1D840510, "");
            WriteString(0x1D843501, "");
            self iprintln("Gunlock ^2Set For AN-94");
            self.ANGunlock = 1;
        } 
        else
        {
            WriteString(0x1D840510, "viewmodel_an94_idle");
            WriteString(0x1D843501, "viewmodel_an94_grip_idle");
            self iprintln("Gunlock ^1Taken From AN-94");
            self.ANGunlock = 0;
        }
    }
    else if(issubstr(Weap, "hk416"))
    {
        if(self.M27Gunlock == 0)
        {
            WriteString(0x1D821A98, "");
            WriteString(0x1D821EC4, "");
            self iprintln("Gunlock ^2Set For M27");
            self.M27Gunlock = 1;
        } 
        else
        {
            WriteString(0x1D821A98, "viewmodel_hk416_idle");
            WriteString(0x1D821EC4, "viewmodel_hk416_grip_idle");
            self iprintln("Gunlock ^1Taken From M27");
            self.M27Gunlock = 0;
        }
    }
    else if(issubstr(Weap, "scar"))
    {
        if(self.SCARGunlock == 0)
        {
            WriteString(0x1D82A374, "");
            WriteString(0x1D82A97B, "");
            self iprintln("Gunlock ^2Set For SCAR-H");
            self.SCARGunlock = 1;
        } 
        else
        {
            WriteString(0x1D82A374, "viewmodel_scar_h_idle");
            WriteString(0x1D82A97B, "viewmodel_scar_h_grip_idle");
            self iprintln("Gunlock ^1Taken From SCAR-H");
            self.SCARGunlock = 0;
        }
    }
    else if(issubstr(Weap, "sig556"))
    {
        if(self.SWATGunlock == 0)
        {
            WriteString(0x1D83AD64, "");
            WriteString(0x1D83B36E, "");
            self iprintln("Gunlock ^2Set For SWAT-556");
            self.SWATGunlock = 1;
        } 
        else
        {
            WriteString(0x1D83AD64, "viewmodel_sig556_idle");
            WriteString(0x1D83B36E, "viewmodel_sig556_grip_idle");
            self iprintln("Gunlock ^1Taken From SWAT-556");
            self.SWATGunlock = 0;
        }
    }
    else if(issubstr(Weap, "sa58"))
    {
        if(self.FALGunlock == 0)
        {
            WriteString(0x1D8630C8, "");
            WriteString(0x1D86346D, "");
            self iprintln("Gunlock ^2Set For FAL OSW");
            self.FALGunlock = 1;
        } 
        else
        {
            WriteString(0x1D8630C8, "viewmodel_sa58_idle");
            WriteString(0x1D86346D, "viewmodel_sa58_grip_idle");
            self iprintln("Gunlock ^1Taken From FAL OSW");
            self.FALGunlock = 0;
        }
    }
    else if(issubstr(Weap, "saritch"))
    {
        if(self.SMRGunlock == 0)
        {
            WriteString(0x1D85B588, "");
            WriteString(0x1D85B98F, "");
            self iprintln("Gunlock ^2Set For SMR");
            self.SMRGunlock = 1;
        } 
        else
        {
            WriteString(0x1D85B588, "viewmodel_saritch_idle");
            WriteString(0x1D85B98F, "viewmodel_saritch_grip_idle");
            self iprintln("Gunlock ^1Taken From SMR");
            self.SMRGunlock = 0;
        }
    }
    else if(issubstr(Weap, "type95"))
    {
        if(self.TypeGunlock == 0)
        {
            WriteString(0x1D84AE68, "");
            WriteString(0x1D84B2AC, "");
            self iprintln("Gunlock ^2Set For Type 25");
            self.TypeGunlock = 1;
        } 
        else
        {
            WriteString(0x1D84AE68, "viewmodel_type95_ar_idle");
            WriteString(0x1D84B2AC, "viewmodel_type95_ar_grip_idle");
            self iprintln("Gunlock ^1Taken From Type 25");
            self.TypeGunlock = 0;
        }
    }
    else if(issubstr(Weap, "tar21"))
    {
        if(self.MTARGunlock == 0)
        {
            WriteString(0x1D832938, "");
            WriteString(0x1D832D01, "");
            self iprintln("Gunlock ^2Set For MTAR");
            self.MTARGunlock = 1;
        } 
        else
        {
            WriteString(0x1D832938, "viewmodel_tavor_idle");
            WriteString(0x1D832D01, "viewmodel_tavor_grip_idle");
            self iprintln("Gunlock ^1Taken From MTAR");
            self.MTARGunlock = 0;
        }
    }
    
    // Shotguns
    else if(issubstr(Weap, "870"))
    {
        if(self.R870Gunlock == 0)
        {
            WriteString(0x1D887C20, "");
            self iprintln("Gunlock ^2Set For R870 MCS");
            self.R870Gunlock = 1;
        } 
        else
        {
            WriteString(0x1D887C20, "viewmodel_870mcs_idle");
            self iprintln("Gunlock ^1Taken From R870 MCS");
            self.R870Gunlock = 0;
        }
    }
    else if(issubstr(Weap, "saiga12"))
    {
        if(self.S12Gunlock == 0)
        {
            WriteString(0x1D88A7BC, "");
            self iprintln("Gunlock ^2Set For S12");
            self.S12Gunlock = 1;
        } 
        else
        {
            WriteString(0x1D88A7BC, "viewmodel_saiga12_idle");
            self iprintln("Gunlock ^1Taken From S12");
            self.S12Gunlock = 0;
        }
    }
    else if(issubstr(Weap, "srm1216"))
    {
        if(self.M1216Gunlock == 0)
        {
            WriteString(0x1D88D224, "");
            self iprintln("Gunlock ^2Set For M1216");
            self.M1216Gunlock = 1;
        } 
        else
        {
            WriteString(0x1D88D224, "viewmodel_srm1216_idle");
            self iprintln("Gunlock ^1Taken From M1216");
            self.M1216Gunlock = 0;
        }
    }
    else if(issubstr(Weap, "ksg"))
    {
        if(self.KSGGunlock == 0)
        {
            WriteString(0x1D88F978, "");
            self iprintln("Gunlock ^2Set For KSG");
            self.KSGGunlock = 1;
        } 
        else
        {
            WriteString(0x1D88F978, "viewmodel_ksg_idle");
            self iprintln("Gunlock ^1Taken From KSG");
            self.KSGGunlock = 0;
        }
    }
    
    //LMGs
    else if(issubstr(Weap, "hamr"))
    {
        if(self.HAMRGunlock == 0)
        {
            WriteString(0x1D879734, "");
            WriteString(0x1D879A95, "");
            self iprintln("Gunlock ^2Set For HAMR");
            self.HAMRGunlock = 1;
        } 
        else
        {
            WriteString(0x1D879734, "viewmodel_hamr_idle");
            WriteString(0x1D879A95, "viewmodel_hamr_grip_idle");
            self iprintln("Gunlock ^1Taken From HAMR");
            self.HAMRGunlock = 0;
        }
    }
    else if(issubstr(Weap, "qbb95"))
    {
        if(self.LSWGunlock == 0)
        {
            WriteString(0x1D8749EC, "");
            WriteString(0x1D874D79, "");
            self iprintln("Gunlock ^2Set For QBB LSW");
            self.LSWGunlock = 1;
        } 
        else
        {
            WriteString(0x1D8749EC, "viewmodel_type95_lmg_idle");
            WriteString(0x1D874D79, "viewmodel_type95_lmg_grip_idle");
            self iprintln("Gunlock ^1Taken From QBB LSW");
            self.LSWGunlock = 0;
        }
    }
    else if(issubstr(Weap, "lsat"))
    {
        if(self.LSATGunlock == 0)
        {
            WriteString(0x1D86FDF4, "");
            WriteString(0x1D87008D, "");
            self iprintln("Gunlock ^2Set For LSAT");
            self.LSATGunlock = 1;
        } 
        else
        {
            WriteString(0x1D86FDF4, "viewmodel_lsat_idle");
            WriteString(0x1D87008D, "viewmodel_lsat_grip_idle");
            self iprintln("Gunlock ^1Taken From LSAT");
            self.LSATGunlock = 0;
        }
    }
    else if(issubstr(Weap, "mk48"))
    {
        if(self.MkGunlock == 0)
        {
            WriteString(0x1D86B418, "");
            WriteString(0x1D86B708, "");
            self iprintln("Gunlock ^2Set For Mk 48");
            self.MkGunlock = 1;
        } 
        else
        {
            WriteString(0x1D86B418, "viewmodel_mark48_idle");
            WriteString(0x1D86B708, "viewmodel_mark48_grip_idle");
            self iprintln("Gunlock ^1Taken From Mk 48");
            self.MkGunlock = 0;
        }
    }
    
    // Specials
    else if(issubstr(Weap, "riotshield"))
    {
        if(self.ShieldGunlock == 0)
        {
            WriteString(0x14A1A418, "");
            self iprintln("Gunlock ^2Set For Assault Shield");
            self.ShieldGunlock = 1;
        } 
        else
        {
            WriteString(0x14A1A418, "viewmodel_riotshield_idle");
            self iprintln("Gunlock ^1Taken From Assault Shield");
            self.ShieldGunlock = 0;
        }
    }
    else if(issubstr(Weap, "knife_ballistic"))
    {
        if(self.BallisticGunlock == 0)
        {
            WriteString(0x1D8AB124, "");
            self iprintln("Gunlock ^2Set For Ballistic Knife");
            self.BallisticGunlock = 1;
        } 
        else
        {
            WriteString(0x1D8AB124, "viewmodel_ballistic_knife_t6_idle");
            self iprintln("Gunlock ^1Taken From Ballistic Knife");
            self.BallisticGunlock = 0;
        }
    }
    else if(issubstr(Weap, "crossbow"))
    {
        if(self.CrossbowGunlock == 0)
        {
            WriteString(0x1D8A8F44, "");
            self iprintln("Gunlock ^2Set For Crossbow");
            self.CrossbowGunlock = 1;
        } 
        else
        {
            WriteString(0x1D8A8F44, "viewmodel_crossbow_t6_idle");
            self iprintln("Gunlock ^1Taken From Crossbow");
            self.CrossbowGunlock = 0;
        }
    }
    else if(Weap == "knife_held_mp") // does both csgo knife and hand held
    {
        if(self.KnifeGunlock == 0)
        {
            WriteString(0x1D8AD3C8, "");
            WriteString(0x14B7FDB8, "");
            self iprintln("Gunlock ^2Set For Knife");
            self.KnifeGunlock = 1;
        } 
        else
        {
            WriteString(0x1D8AD3C8, "viewmodel_sog_knife_idle_loop");
            WriteString(0x14B7FDB8, "viewmodel_strider_idle");
            self iprintln("Gunlock ^1Taken From Knife");
            self.KnifeGunlock = 0;
        }
    }
    else if(Weap == "briefcase_bomb_mp")
    {
        if(self.BombGunlock == 0)
        {
            WriteString(0x15247C5C, "");
            self iprintln("Gunlock ^2Set For Hunter Killer");
            self.BombGunlock = 1;
        } 
        else
        {
            WriteString(0x15247C5C, "viewmodel_briefcase_bomb_t6_idle");
            self iprintln("Gunlock ^1Taken From Hunter Killer");
            self.BombGunlock = 0;
        }
    }
    else if(Weap == "missile_drone_mp")
    {
        if(self.KillerGunlock == 0)
        {
            WriteString(0x14E19260, "");
            self iprintln("Gunlock ^2Set For Hunter Killer");
            self.KillerGunlock = 1;
        } 
        else
        {
            WriteString(0x14E19260, "viewmodel_hunterkiller_idle");
            self iprintln("Gunlock ^1Taken From Hunter Killer");
            self.KillerGunlock = 0;
        }
    }
    else if(Weap == "minigun_mp")
    {
        if(self.miniGunGunlock == 0)
        {
            WriteString(0x13BC400C, "");
            self iprintln("Gunlock ^2Set For Death Machine");
            self.miniGunGunlock = 1;
        } 
        else
        {
            WriteString(0x13BC400C, "viewmodel_minigun_t6_idle");
            self iprintln("Gunlock ^1Taken From Death Machine");
            self.miniGunGunlock = 0;
        }
    }
    else if(Weap == "claymore_mp")
    {
        if(self.ClaymoreGunlock == 0)
        {
            WriteString(0x14E97FDC, "");
            self iprintln("Gunlock ^2Set For Claymore");
            self.ClaymoreGunlock = 1;
        } 
        else
        {
            WriteString(0x14E97FDC, "viewmodel_claymore_idle");
            self iprintln("Gunlock ^1Taken From Claymore");
            self.ClaymoreGunlock = 0;
        }
    }
    else if(Weap == "pda_hack_mp")
    {
        if(self.BlackGunlock == 0)
        {
            WriteString(0x14EF4A00, "");
            self iprintln("Gunlock ^2Set For Black Hat");
            self.BlackGunlock = 1;
        } 
        else
        {
            WriteString(0x14EF4A00, "viewmodel_pda_hacker_idle");
            self iprintln("Gunlock ^1Taken From Black Hat");
            self.BlackGunlock = 0;
        }
    }
    else if(Weap == "m32_mp")
    {
        if(self.BlackGunlock == 0)
        {
            WriteString(0x1485533C, "");
            self iprintln("Gunlock ^2Set For War Machine");
            self.BlackGunlock = 1;
        } 
        else
        {
            WriteString(0x1485533C, "viewmodel_m32_idle");
            self iprintln("Gunlock ^1Taken From War Machine");
            self.BlackGunlock = 0;
        }
    }
    
    // Launchers
    else if(issubstr(Weap, "smaw"))
    {
        if(self.SMAWGunlock == 0)
        {
            WriteString(0x1D8A48C0, "");
            self iprintln("Gunlock ^2Set For SMAW");
            self.SMAWGunlock = 1;
        } 
        else
        {
            WriteString(0x1D8A48C0, "viewmodel_smaw_idle");
            self iprintln("Gunlock ^1Taken From SMAW");
            self.SMAWGunlock = 0;
        }
    }
    else if(issubstr(Weap, "fhj18"))
    {
        if(self.FHJGunlock == 0)
        {
            WriteString(0x1D8A6508, "");
            self iprintln("Gunlock ^2Set For FHJ-18");
            self.FHJGunlock = 1;
        } 
        else
        {
            WriteString(0x1D8A6508, "viewmodel_fhj18_idle");
            self iprintln("Gunlock ^1Taken From FHJ-18");
            self.FHJGunlock = 0;
        }
    }
    else if(issubstr(Weap, "usrpg"))
    {
        if(self.RPGGunlock == 0)
        {
            WriteString(0x147A57C4, "");
            self iprintln("Gunlock ^2Set For RPG");
            self.RPGGunlock = 1;
        } 
        else
        {
            WriteString(0x147A57C4, "viewmodel_usrpg_idle");
            self iprintln("Gunlock ^1Taken From RPG");
            self.RPGGunlock = 0;
        }
    }
    
    // Pistols
    else if(issubstr(Weap, "kard"))
    {
        if(self.KapGunlock == 0)
        {
            WriteString(0x1D8A018C, "");
            WriteString(0x1D8A0426, "");
            self iprintln("Gunlock ^2Set For Kap-40");
            self.KapGunlock = 1;
        } 
        else
        {
            WriteString(0x1D8A018C, "viewmodel_kard_idle");
            WriteString(0x1D8A0426, "viewmodel_kard_tactical_idle");
            self iprintln("Gunlock ^1Taken From Kap-40");
            self.KapGunlock = 0;
        }
    }
    else if(issubstr(Weap, "fnp45"))
    {
        if(self.TacGunlock == 0)
        {
            WriteString(0x1D89C314, "");
            WriteString(0x1D89CBD4, "");
            self iprintln("Gunlock ^2Set For Tac-45");
            self.TacGunlock = 1;
        } 
        else
        {
            WriteString(0x1D89C314, "viewmodel_fnp45_idle");
            WriteString(0x1D89CBD4, "viewmodel_fnp45_tactical_idle");
            self iprintln("Gunlock ^1Taken From Tac-45");
            self.TacGunlock = 0;
        }
    }
    else if(issubstr(Weap, "judge"))
    {
        if(self.ExecutionerGunlock == 0)
        {
            WriteString(0x1D899E40, "");
            WriteString(0x1D89A15D, "");
            self iprintln("Gunlock ^2Set For Executioner");
            self.ExecutionerGunlock = 1;
        } 
        else
        {
            WriteString(0x1D899E40, "viewmodel_judge_idle");
            WriteString(0x1D89A15D, "viewmodel_judge_tactical_idle");
            self iprintln("Gunlock ^1Taken From Executioner");
            self.ExecutionerGunlock = 0;
        }
    }
    else if(issubstr(Weap, "beretta93r"))
    {
        if(self.B23RGunlock == 0)
        {
            WriteString(0x1D896570, "");
            WriteString(0x1D896B72, "");
            self iprintln("Gunlock ^2Set For B23R");
            self.B23RGunlock = 1;
        } 
        else
        {
            WriteString(0x1D896570, "viewmodel_beretta2023r_idle");
            WriteString(0x1D896B72, "viewmodel_beretta2023r_tactical_idle");
            self iprintln("Gunlock ^1Taken From B23R");
            self.B23RGunlock = 0;
        }
    }
    else if(issubstr(Weap, "fiveseven"))
    {
        if(self.fivesevenGunlock == 0)
        {
            WriteString(0x1D892BDC, "");
            WriteString(0x1D89306E, "");
            self iprintln("Gunlock ^2Set For Five-seven");
            self.fivesevenGunlock = 1;
        } 
        else
        {
            WriteString(0x1D892BDC, "viewmodel_fn57_idle");
            WriteString(0x1D89306E, "viewmodel_fn57_tactical_idle");
            self iprintln("Gunlock ^1Taken From Five-seven");
            self.fivesevenGunlock = 0;
        }
    }
}

ResetOnGameEnd()
{
    level waittill("game_ended");
    self thread UndoMem();
    
}

UndoMem()
{
    // Snipers
    WriteString(0x1D882A38, "viewmodel_dsr50_idle");
    WriteString(0x1D87CB94, "viewmodel_ballista_idle");
    WriteString(0x1D8801C0, "viewmodel_xpr50_idle");
    WriteString(0x1D8851D0, "viewmodel_svu_as_idle");
    // SMGs
    WriteString(0x1D810538, "viewmodel_mp7_idle");
    WriteString(0x1D812016, "viewmodel_mp7_grip_idle");
    WriteString(0x1D808DE8, "viewmodel_pdw57_idle");
    WriteString(0x1D804988, "viewmodel_vector_idle");
    WriteString(0x1D804E0B, "viewmodel_vector_grip_idle");
    WriteString(0x1D80D4B4, "viewmodel_skorpion_evo_idle");
    WriteString(0x1D80D9AC, "viewmodel_skorpion_evo_grip_idle");
    WriteString(0x1D816178, "viewmodel_qcw05_idle");
    WriteString(0x1D81655C, "viewmodel_qcw05_grip_idle");
    WriteString(0x1D81A754, "viewmodel_msmc_idle");
    WriteString(0x1D81AAF1, "viewmodel_msmc_grip_idle");
    WriteString(0x1D9570A0, "viewmodel_peacekeeper_idle");
    WriteString(0x1D97E3F4, "viewmodel_peacekeeper_grip_idle");
    // ARS
    WriteString(0x1D85044C, "viewmodel_xm8_idle");
    WriteString(0x1D8538E5, "viewmodel_xm8_grip_idle");
    WriteString(0x1D840510, "viewmodel_an94_idle");
    WriteString(0x1D843501, "viewmodel_an94_grip_idle");
    WriteString(0x1D821A98, "viewmodel_hk416_idle");
    WriteString(0x1D821EC4, "viewmodel_hk416_grip_idle");
    WriteString(0x1D82A374, "viewmodel_scar_h_idle");
    WriteString(0x1D82A97B, "viewmodel_scar_h_grip_idle");
    WriteString(0x1D83AD64, "viewmodel_sig556_idle");
    WriteString(0x1D83B36E, "viewmodel_sig556_grip_idle");
    WriteString(0x1D8630C8, "viewmodel_sa58_idle");
    WriteString(0x1D86346D, "viewmodel_sa58_grip_idle");
    WriteString(0x1D85B588, "viewmodel_saritch_idle");
    WriteString(0x1D85B98F, "viewmodel_saritch_grip_idle");
    WriteString(0x1D84AE68, "viewmodel_type95_ar_idle");
    WriteString(0x1D84B2AC, "viewmodel_type95_ar_grip_idle");
    WriteString(0x1D832938, "viewmodel_tavor_idle");
    WriteString(0x1D832D01, "viewmodel_tavor_grip_idle");
    // Shotguns
    WriteString(0x1D887C20, "viewmodel_870mcs_idle");
    WriteString(0x1D88A7BC, "viewmodel_saiga12_idle");
    WriteString(0x1D88D224, "viewmodel_srm1216_idle");
    WriteString(0x1D88F978, "viewmodel_ksg_idle");
    //LMGs
    WriteString(0x1D879734, "viewmodel_hamr_idle");
    WriteString(0x1D879A95, "viewmodel_hamr_grip_idle");
    WriteString(0x1D8749EC, "viewmodel_type95_lmg_idle");
    WriteString(0x1D874D79, "viewmodel_type95_lmg_grip_idle");
    WriteString(0x1D86FDF4, "viewmodel_lsat_idle");
    WriteString(0x1D87008D, "viewmodel_lsat_grip_idle");
    WriteString(0x1D86B418, "viewmodel_mark48_idle");
    WriteString(0x1D86B708, "viewmodel_mark48_grip_idle");
    // Specials
    WriteString(0x14A1A418, "viewmodel_riotshield_idle");
    WriteString(0x1D8AB124, "viewmodel_ballistic_knife_t6_idle");
    WriteString(0x1D8A8F44, "viewmodel_crossbow_t6_idle");
    WriteString(0x1D8AD3C8, "viewmodel_sog_knife_idle_loop");
    WriteString(0x14B7FDB8, "viewmodel_strider_idle");
    WriteString(0x15247C5C, "viewmodel_briefcase_bomb_t6_idle");
    WriteString(0x13BC400C, "viewmodel_minigun_t6_idle");
    WriteString(0x14E19260, "viewmodel_hunterkiller_idle");
    WriteString(0x14EF4A00, "viewmodel_pda_hacker_idle");
    WriteString(0x14E97FDC, "viewmodel_claymore_idle");
    WriteString(0x1485533C, "viewmodel_m32_idle");
    WriteString(0x1D8AC77E, "viewmodel_m4m203_knife_melee_1");
    WriteString(0x1D8AD3E6, "viewmodel_M4m203_knife_melee_1");
    // Launchers
    WriteString(0x1D8A48C0, "viewmodel_smaw_idle");
    WriteString(0x1D8A6508, "viewmodel_fhj18_idle");
    WriteString(0x147A57C4, "viewmodel_usrpg_idle");
    // Pistols
    WriteString(0x1D8A018C, "viewmodel_kard_idle");
    WriteString(0x1D8A0426, "viewmodel_kard_tactical_idle");
    WriteString(0x1D89C314, "viewmodel_fnp45_idle");
    WriteString(0x1D89CBD4, "viewmodel_fnp45_tactical_idle");
    WriteString(0x1D899E40, "viewmodel_judge_idle");
    WriteString(0x1D89A15D, "viewmodel_judge_tactical_idle");
    WriteString(0x1D896570, "viewmodel_beretta2023r_idle");
    WriteString(0x1D896B72, "viewmodel_beretta2023r_tactical_idle");
    WriteString(0x1D892BDC, "viewmodel_fn57_idle");
    WriteString(0x1D89306E, "viewmodel_fn57_tactical_idle");
}

AnimKnifeLunge()
{
    self endon("disconnect");
    self endon("death");
    if(!isDefined(self.KnifeAnim))
    {
        WriteString(0x1D8AC77E, "viewmodel_m4m203_knife_melee_2");
        WriteString(0x1D8AD3E6, "viewmodel_M4m203_knife_melee_2");
        self.KnifeAnim = true;
        self iprintln("Knife Lunge Animation ^2On");
    }
    else
    {
        WriteString(0x1D8AC77E, "viewmodel_m4m203_knife_melee_1");
        WriteString(0x1D8AD3E6, "viewmodel_M4m203_knife_melee_1");
        self.KnifeAnim = undefined;
        self iprintln("Knife Lunge Animation ^1Off");
    }
}


