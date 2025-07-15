term.clear()
print("Welcome to LoveDownload! Here you can download apps from the internet!")
print()
print("REQUIREMENTS:")
print()
print("- Have internet connected with love!")
print("- Be careful, not everyone is nice in the world. Don't download every app you see.")
print("- Be respectful with others!")
print()
print("Press ENTER to continue with love.")
read()

term.clear()
print("Please enter the link of the app! (Raw URL only please!)")
print()
local url = read()

-- Ask for filename
print("\nEnter a name for the app (e.g. MyApp.lua):")
local filename = read()

-- Full path
local filepath = "/apps/" .. filename

-- Download
print("\nDownloading app with love...")
local ok, err = pcall(function()
  shell.run("wget", url, filepath)
end)

-- Result
if ok and fs.exists(filepath) then
  print("\nApp downloaded successfully as " .. filepath)
else
  print("\nDownload failed: " .. tostring(err))
end

print("\nPress ENTER to return.")
read()
