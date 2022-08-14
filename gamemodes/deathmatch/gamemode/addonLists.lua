----OBJECT ATRIBUTES MUST NOT BE OF TYPE FUNC OR ELSE THEY WILL BE READ AS NULL UNTIL FUNC IS CALLED----
weaponList = {
    ---ARs---
    AR = {
        "tfa_ins2_mk18" ,
        "tfa_ins2_ak74_r",
        "tfa_ins2_akm_r",
        "tfa_ins2_aks_r",
        "tfa_ins2_cw_ar15",
        "tfa_ins2_rpk_r" ,
        "tfa_ins2_417" ,
        "tfa_ins2_acr" ,
        "tfa_ins2_minimi" ,
        "tfa_ins2_abakan" ,
        "tfa_ins2_aek971" ,
        "tfa_ins2_ak400" ,
        "tfa_ins2_aug" ,
        "tfa_ins2_cz805" ,
        "tfa_ins2_fn_fal" ,
        "tfa_ins2_moe_akm" ,
        "tfa_ins2_scar_h_ssr" ,
        "tfa_ins2_norinco_qbz97" ,
        "tfa_ins2_ak103" ,
        "tfa_ins2_cq300" ,
        "tfa_ins2_sr25_eft" ,
        "tfa_howa_type_64" ,
        --"tfa_at_mcx" ,
        "tfa_at_hk_416a5" ,
        "tfa_at_galil" ,
        "tfa_at_galil_sar" ,
        "tfa_ww2_mlg_stg44", 
        "tfa_at_hk_416" ,
    },
    SMG = {
        "tfa_ins2_sterling" ,
        "tfa_ins2_warface_bt_mp9" ,
        "tfa_inss2_hk_mp5a5" ,
        "tfa_ins2_imi_uzi" ,
        "tfa_ins2_krissv" ,
        "tfa_ins2_spectre" ,
        "tfa_ww2_mp28" ,
        "tfa_ww2_mp34" ,
        "tfa_ww2_mp38" ,
        "tfa_ww2_mp40" ,
        "tfa_ins2_mp7" ,
        "tfa_ins2_sr2m_veresk" ,
        "tfa_ins2_ump45" ,
        "tfa_ins2_pm9" ,
        "tfa_ww1_mp18" ,
        "tfa_ww2_mors" ,
        "tfa_doi_sten_mk2" ,
        "tfa_doi_thompson" ,
        "tfa_doi_thompson_m1a1" ,
    },
    SHOTGUN = {
        "tfa_ins2_remington_m870" ,
        "tfa_ins2_br99" ,
        "tfa_ins2_ksg" ,
        "tfa_ins2_fort500" ,
        "tfa_ins2_m1014" ,
        "tfa_ins2_toz_194m" ,
        "tfa_ins2_m590o" ,
        "tfa_cold_war_hs10" ,
    },
    SNIPER = {
        "tfa_ins2_k98" ,
        "tfa_ins2_rfb" ,
        "tfa_ins2_mosin_nagant" ,
        "tfa_ins2_sks" ,
        "tfa_ins2_warface_ax308" ,
        "tfa_ins2_warface_orsis_t5000" , 
        "tfa_ins2_g28" ,
        "tfa_ww2_g41" ,
    },
    PISTOL = {
        "tfa_ins2_fnp45" ,
        "tfa_ins2_usp_match" ,
        "tfa_ins2_glock_p80" ,
        "tfa_ins2_m9" ,
        "tfa_ww2_m712" ,
        "tfa_nam_tokarev_tt33" ,
        "tfa_ins2_mk23" ,
        "tfa_ins2_thanez_cobra" ,
        "tfa_ins2_qsz92" ,
        "tfa_ins2_walther_p99" ,
        "tfa_ins2_cz75auto" ,
        "tfa_ins2_ots_33_pernach" ,
        "tfa_ins2_deagle" ,
        "tfa_ins2_pm" ,
    },
    MELEE = {
        "tfa_ins2_kabar" ,
        "tfa_ins2_gurkha" ,
        "tfa_ararebo_bf1" ,
        "tfa_japanese_exclusive_tanto" ,
    },
    GRENADE = {

    }
}

--HAS TO BE FROM VALID PLAYER MODEL LIST--
modelList = {
    "models/coom pm/britbong.mdl" ,
    "models/coom pm 2/britbong.mdl" ,
    "models/deepalley/alley_thug.mdl" ,
    "models/player/lordvipes/rerc_hunk/hunk_cvp.mdl" ,
    "models/kemot44/Models/Joker_PM.mdl" ,
    "models/omgwtfbbq/Quantum_Break/Characters/Operators/MonarchOperator01PlayerModel.mdl" ,
    "models/models/konnie/polishsoldier/polishsoldier.mdl" ,
    "models/bala/rioter_bomber_pm.mdl" ,
    "models/bala/rioter_charger_pm.mdl" ,
    "models/bala/rioter_dare_devil_pm.mdl" ,
    "models/bala/rioter_scout_pm.mdl" ,
    "models/bala/rioter_survivor_pm.mdl" ,
    "models/bala/rioter_thug_pm.mdl" ,
    "models/player/darky_m/rust/nomad.mdl" ,
    "models/kuma96/tetram/tetram_pm.mdl" ,
}

function initializeWeps()
    print("THIS IS A TEST")
    for _, v in pairs(weaponList.AR) do print(weapons.Get(v).PrintName) end
    
end


--ADD NEW WEAPONS TO NAME LIST HERE--
--AR = { "AKM", "AR15", "HK417", "AUG", "MK18" }
--SMG = { "MP5", "MP9" ,"MP40" }
--SHOTGUN = { "M870", "BR99", "KSG", "FORT500", "M1014", "TOZ194", "M590" }
--SNIPER = { "KAR98" , "RFB", "MOSIN", "SKS" }
--PISTOL = { "M9", "GLOCK", "P99", "M712", "TOKAREV", "FNP45", "MK23", "COBRA", "QSZ" }
--MELEE = { "Knife", "Machete" }

PRIMARYCLASSES = { 'AR', 'SMG', 'SHOTGUN', 'SNIPER'}

currentPrimaryClass = PRIMARYCLASSES[1]
currentPrimary = weaponList.AR[1]
currentSecondary = weaponList.PISTOL[1]
currentMelee = weaponList.MELEE[1]

function SetCurrentLoadOut(Player, primary, secondary, melee)
    Player:RemoveAllItems()
    if (primary == nil) then Player:Give(currentPrimary)
    else Player:Give(primary)
    end
    if (secondary == nil) then Player:Give(currentSecondary)
    else Player:Give(secondary)
    end
    if (melee == nil) then Player:Give(currentMelee)
    else Player:Give(melee)
    end
    --Player:Give(currentMelee)
    Player:Give("weapon_frag")
end

function dumbShit()
    print("-----------dumbShiz-------------")
    
end