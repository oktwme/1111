local supported_champions = {
  ["Kaisa"] = true,
  ["Yasuo"] = true,
  ["Briar"] = true,
  ["Ezreal"] = true,
  ["Tristana"] = true,
  ["Twitch"] = true,
  ["Samira"] = true,
  ["Jinx"] = true,
  ["KSante"] = true,
  --["MasterYi"] = true,

  ["Nilah"] = true,
  ["Blitzcrank"] = true,
  ["Viktor"] = true,
  --["Xerath"] = true,

  --WIP
  -- ["Zeri"] = true,

  -- 
}

return
{
  id = "Klee_AIO2",
  name = "Klee AIO",
  author = "Klee, Luna",
  description = "Klee AIO",
  load = function()
    return supported_champions[player.charName]
  end,
  flag = {
    text = "Klee AIO",
    color = {
      text = 0xff2c3e50,
      background1 = 0x78FFEAA7, --0x78e17055,
      background2 = 0x78FFEAA7, --0x78e17055 --0x22e17055,
    }
  },
  lib = true,
  shard =
  {
    'main',

    'Help/anti_gapcloser',
    'Help/dmg_lib',
    'Help/interrupter',
    'Help/spell_database',
    'Help/spell_database_attacks',
    'Help/utils',

    'target_selector/target_selector',
    'target_selector/ts_mode_preset',

    'Champion/Kaisa',
    'Champion/Yasuo',
    'Champion/Briar',
    'Champion/Ezreal',
    'Champion/Tristana',
    'Champion/Twitch',
    'Champion/Samira',
    'Champion/Jinx',
    'Champion/KSante',
    'Champion/Viktor',

    'Champion/Nilah',
    'Champion/Blitzcrank',
  },

  resources =
  {
    "Resource/klee.png",
    "Resource/klee_pic.png",
    "Resource/update_en.png",
    "Resource/update_cn.png",
    --'SPRITE_NAME.png', ??developer/SHARD_NAME/SPRITE_NAME.png
    --'SUB_FOLDER/SPRITE_NAME.png', ??developer/SHARD_NAME/SUB_FOLDER/SPRITE_NAME.png
  }
}
