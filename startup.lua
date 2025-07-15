--  LOVEOS  (BETA)  ──────────────────────────────────────────────
local term, fs, shell, os = term, fs, shell, os
local speaker = nil

-- ─────────────── Detect speaker (if exists)
for _, side in ipairs(peripheral.getNames()) do
  if peripheral.getType(side) == "speaker" then
    speaker = peripheral.wrap(side)
    break
  end
end

local function playSound(name, volume, pitch)
  if speaker then
    speaker.playSound(name, volume or 1, pitch or 1)
  end
end

-- ─────────────── 1) Boot animation with sound ────────────────
local function bootAnimation()
  local frames = {".", ". .", ". . ."}
  playSound("block.note_block.pling", 1, 1)  -- startup sound

  for cycle = 1, 3 do
    for _, dots in ipairs(frames) do
      term.clear()
      term.setCursorPos(1, 1)
      print("LoveOS")
      print("(BETA)\n")
      print(dots)
      playSound("entity.experience_orb.pickup", 0.7 + math.random() * 0.3, 1 + math.random())
      os.sleep(0.5)
    end
  end

  term.clear()
  os.sleep(0.5)
end

-- ─────────────── 2) Main menu loop ───────────────────────────
local function appMenu()
  while true do
    term.clear()
    print("LoveOS")
    print("(BETA)\n")

    shell.run("ls", "/apps/")
    print("\nType the name of an app to run (or 'reboot'):")
    io.write("> ")
    local app = read()

    playSound("ui.button.click", 0.5, 1)

    if app == "reboot" then
      playSound("entity.arrow.hit_player", 1, 0.8)
      error("RebootRequested")
    end

    local path = "/apps/" .. app
    if fs.exists(path) then
      local ok, err = pcall(function() shell.run(path) end)
      if not ok then
        print("\nApp crashed with love: " .. tostring(err))
        playSound("block.anvil.land", 1, 0.8)
      end
    else
      print("\nApp '" .. app .. "' not found.")
      playSound("block.note_block.bass", 1, 0.7)
    end

    print("\nPress Enter to return to menu…")
    read()
  end
end

-- ─────────────── 3) Reboot control loop ──────────────────────
while true do
  bootAnimation()

  local ok, err = pcall(function()
    while true do
      local event = os.pullEventRaw()
      if event == "terminate" then
        playSound("block.note_block.basedrum", 1, 0.5)
        error("RebootRequested")
      else
        os.queueEvent(event)
      end
      appMenu()
    end
  end)

  if not ok and err == "RebootRequested" then
    term.clear()
    playSound("entity.player.levelup", 1, 1.2)
    print("Rebooting with love...")
    os.sleep(1)
  else
    if not ok then
      term.clear()
      playSound("entity.wither.death", 1, 0.5)
      print("ERROR! A CRASH OCCURRED!")
      print("An error occurred with love: " .. tostring(err))
      print("PLEASE PRESS ENTER TO TURN OFF YOUR COMPUTER.")
      read()
      print("God bless you.")
      print("God follow you.")
      os.sleep(0.5)
      shell.run("shutdown")
    end
    break
  end
end
