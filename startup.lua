--  LOVEOS  (BETA)  ──────────────────────────────────────────────
local term, fs, shell, os = term, fs, shell, os

-- ───────────────────────── 1) Boot animation ───────────────────
local function bootAnimation()
  local frames = {".", ". .", ". . ."}
  for cycle = 1, 3 do
    for _, dots in ipairs(frames) do
      term.clear()
      term.setCursorPos(1, 1)
      print("LoveOS")
      print("(BETA)\n")
      print(dots)
      os.sleep(1)
    end
  end
  term.clear()
  os.sleep(0.5)
end

-- ───────────────────────── 2) Main menu loop ───────────────────
local function appMenu()
  while true do
    term.clear()
    print("LoveOS")
    print("(BETA)\n")

    shell.run("ls", "/apps/")
    print("\nType the name of an app to run (or 'reboot'):")
    io.write("> ")
    local app = read()

    if app == "reboot" then
      error("RebootRequested")
    end

    local path = "/apps/" .. app
    if fs.exists(path) then
      local ok, err = pcall(function() shell.run(path) end)
      if not ok then
        print("\nApp crashed with love: " .. tostring(err))
      end
    else
      print("\nApp '" .. app .. "' not found.")
    end

    print("\nPress Enter to return to menu…")
    read()
  end
end

-- ───────────────────────── 3) Reboot control loop ──────────────
while true do
  bootAnimation()

  local ok, err = pcall(function()
    while true do
      local event = os.pullEventRaw()
      if event == "terminate" then
        error("RebootRequested")
      else
        os.queueEvent(event)
      end
      appMenu()
    end
  end)

  if not ok and err == "RebootRequested" then
    term.clear()
    os.sleep(1)
  else
    if not ok then
      term.clear()
      print('ERROR! AN CRASH OCURRED!')
      print("An error ocurred with love:" .. tostring(err))
      print('PLEASE PRESS ENTER TO TURN OFF YOUR COMPUTER.')
      read()
      print('God bless you.')
      print('God follow you.')
      os.sleep(0.5)
      shell.run('shutdown')
    end
    break
  end
end

