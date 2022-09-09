hudStuff = {"iconP1", "iconP2", "healthBar", "healthBarBG", "timeBar", "timeBarBG", "timeTxt", "scoreTxt"}
songs = {
{"Discord Annoyer", "Social Media Songs", 4, "Discord"}, 
{"Shut Up", "Social Media Songs", 7, "Discord"}, 
{"Hate Comment", "Social Media Songs", 10, "Youtube"}, 
{"Twitter Argument", "Social Media Songs", 13, "Twitter"}
}

menus = {
   {"Social Media Songs", "Social Media"},
   {"Options", ""}
}
options = {
   {"Mechanic", "bool", true, "mechanic", ""}
}
selectionMenu = "Menu"

background = {
   "Discord",
   "Discord",
   "Youtube",
   "Twitter",
   "Social Media"
}
texts = {}
curSelect = 1

local ySpace = 120
local fontSize = 64

bgX = 0
bgY = 0

local blockEnd = true

songScores = 0
songDiff = 0
songDiffLerp = 0

goingInASong = false

loadBack = {}

songBPM = 102
local songTime = 0;
local aBeat = 0;
local aStep = 0;
local thisCrochet = 0;
local thisStepCrochet = 0;
local oldBeat = 0;
local oldStep = 0;
defaultZoom = 1
beatZoom = true
function onCreate()
  -- setProperty("luaDebugMode", true)
   setProperty("skipCountdown", true)
   
end

function onCreatePost()
   setProperty("botplayTxt.visible", false)

   createMenu()
   changeSong(0)

   setProperty("gf.visible", false)
   setProperty("dad.visible", false)
   setProperty("boyfriend.visible", false)

   loadSave()

   
end

function onSongStart()

   for i = 1, #hudStuff do 
      setProperty(hudStuff[i] .. ".visible", false)
   end
   for i = 0, 7 do 
      setPropertyFromGroup("strumLineNotes", i, "visible", false)
   end

   endSong()
   playMusic("freakyMenu", 0.8, true)
   
end
function onEndSong()

   if blockEnd then
      return Function_Stop
   else 
      return Function_Continue
   end
end

function onTimerCompleted(tag, loops, loopsLeft)
   if tag == "song" then 
      local song = songs[curSelect][1]
      
      goingInASong = true
      loadSong(song, 0)
     
   end
   if tag == "fade" then 
      doTweenAlpha("fading", "fading", 1, 0.5, "quadIn")
      doTweenAlpha("load", "loadTxt", 0.2, 0.5, "quadIn")

      doTweenAlpha("load2", "loadTxt2", 0.2, 0.5, "quadIn")

   end
end

function functionSong(elapsed)
   local time = getPropertyFromClass('flixel.FlxG', 'sound.music.time')
   songTime = time / 1000

   thisCrochet = ((60 / songBPM) * 1000);
   thisStepCrochet = thisCrochet / 4;
   
   aBeat = math.ceil(songTime / (thisCrochet / 1000)) - 1;
   aStep = (math.ceil(songTime / (thisStepCrochet / 1000)) - 1);

   if oldBeat ~= aBeat then 
      oldBeat = aBeat
      hitBeat()
   end

   if oldStep ~= aStep then 
      oldStep = aStep
      --hitStep()
   end
end

function hitBeat()
   if beatZoom then 
      if aBeat % 2 == 0  then
         for i = 1, #loadBack do 
            local tag = loadBack[i][1]
            setProperty(tag .. ".scale.x", getProperty(tag .. ".scale.x") + 0.025)
            setProperty(tag .. ".scale.y", getProperty(tag .. ".scale.y") + 0.025)
         end
      else 
         for i = 1, #loadBack do 
            local tag = loadBack[i][1]
            setProperty(tag .. ".scale.x", getProperty(tag .. ".scale.x") + 0.01)
            setProperty(tag .. ".scale.y", getProperty(tag .. ".scale.y") + 0.01)
         end
      end
   end
end

function loadSave()
  -- initSaveData("ammarc")
   --flushSaveData("ammarc")
   --setDataFromSave("ammarc", "mechanic", true)
   --debugPrint(getDataFromSave("ammarc", "mechanic"))

   for i = 1, #options do 
      options[i][3] = getDataFromSave("ammarc", options[i][4])
   end
end

allElap = 0
selectSong = false
function onUpdate(elapsed)
   if not goingInASong then
      functionSong(elapsed)

      setPropertyFromClass("FlxTransitionableState", "skipNextTransIn", true)
      setPropertyFromClass("FlxTransitionableState", "skipNextTransOut", true)
      setPropertyFromClass("CustomFadeTransition", "nextCamera", nil)

      if beatZoom then
         for i = 1, #loadBack do 
            local tag = loadBack[i][1]
            local defaultScale = 0.72
            setProperty(tag .. ".scale.x", lerp(getProperty(tag .. ".scale.x"), defaultScale, elapsed * 4))
            setProperty(tag .. ".scale.y", lerp(getProperty(tag .. ".scale.y"), defaultScale, elapsed * 4))
         end
      end
   
       setProperty("camHUD.zoom", lerp(getProperty("camHUD.zoom"), defaultZoom, elapsed * 7))
      if not selectSong then
         setProperty("textBlack.alpha",  lerp(getProperty("textBlack.alpha"), 1, elapsed * 4))
      end
      

      allElap = allElap + elapsed
      control(elapsed)

      for i = 1, #texts do 
         local tag = texts[i]
         local targetY = ((720/2) - fontSize/2 - 10) + (i - curSelect) * (ySpace * math.abs(1 - (math.abs(i - curSelect) * 0.1)))
         local targetAlpha = 1 - (math.abs(i - curSelect) * 0.2)
         local targetSize = 1 - (math.abs(i - curSelect) * 0.2)
         if not isSongSelection() then 
            targetAlpha = 1
         end
      
         setProperty(tag .. ".y", lerp(getProperty(tag .. ".y"), targetY, elapsed * 9))
         setProperty(tag .. ".alpha", lerp(getProperty(tag .. ".alpha"), targetAlpha, elapsed * 9))
   
         
         setProperty(tag .. ".scale.x", lerp(getProperty(tag..".scale.x"), targetSize, elapsed * 8))
         setProperty(tag .. ".scale.y", lerp(getProperty(tag..".scale.y"), targetSize, elapsed * 8))
      end

      songDiff = songs[curSelect][3]
      songDiffLerp = lerp(songDiffLerp, songDiff, elapsed * 7)
      setTextString("diffTxt", "DIFFICULTY : " .. math.floor(songDiffLerp))   
      setProperty("diffTxt.visible", isSongSelection())

      local red = string.format("%x", (math.floor(songDiffLerp) / 20 * 255))
      local green = string.format("%x", ((1 - (math.floor(songDiffLerp) / 20)) * 255))
      setTextColor("diffTxt", tostring(red)..tostring(green).. "00")

      for i = 1, #loadBack do 
         local tag = loadBack[i][1]
         chosen = false
         local arrayThing = songs
         local arrayIndex = 4

         if selectionMenu == "Menu" then 
            arrayThing = menus
            arrayIndex = 2
         end
         if selectionMenu == "Options" then 
            arrayThing = options
            arrayIndex = 5
         end

         
         if tag == string.lower(arrayThing[curSelect][arrayIndex]:gsub( " ", "_")) then 
            chosen = true
         end
         
         setProperty(tag .. ".y", loadBack[i][2] + math.sin( allElap * 1.2) * 10)
         setProperty(tag .. ".x", loadBack[i][3] + math.cos( allElap * 1.25) * 20)
         setProperty(tag .. ".angle", math.sin( allElap * 0.8) * 0.5)

         local alphaTarget = ((chosen) and 1 or 0)
         setProperty(tag .. ".alpha", lerp(getProperty(tag .. ".alpha"), alphaTarget, elapsed * 7))
      end

      setProperty("bg.visible", not isSongSelection())
      setProperty("bg.y", bgY + math.sin( allElap * 1.2) * 10)
      setProperty("bg.x", bgX + math.cos( allElap * 1.25) * 20)
      setProperty("bg.angle", math.sin( allElap * 0.8) * 0.5)

      setProperty("overlay.x", lerp(getProperty("overlay.x"),1240 - (#getProperty(texts[curSelect] ..".text") * 38), elapsed*9))

      if selectionMenu == "Options" then
         for i = 1, #texts do 
            local tag = texts[i]
            local text = getTextString(tag)
            if string.find( string.lower( text ), "mechanic" ) then 
               setTextString(tag, "Mechanic : ".. ((getDataFromSave("ammarc", options[curSelect][4])) and "ON" or "OFF"))
            end

         end


      end
   end
end


function control(elapsed)
   if (getPropertyFromClass('flixel.FlxG', 'keys.justPressed.ESCAPE') or keyJustPressed("left")) and not selectSong and blockEnd then 
      setProperty("textBlack.alpha", 0)
      if selectionMenu == "Menu" then
         blockEnd = false
         exitSong()
      else 
         setProperty("camHUD.zoom", getProperty("camHUD.zoom") - 0.05)
         selectionMenu = "Menu"
         makeText(menus)
         playSound("cancelMenu", 0.6, "back")
      end
   end
   if keyJustPressed("down") and not selectSong then 
      changeSong(1)
   elseif keyJustPressed("up") and not selectSong then 
      changeSong(-1)
   end

   if (keyJustPressed("space") or keyJustPressed("accept") or keyJustPressed("right")) and not selectSong then 
      setProperty("camHUD.zoom", getProperty("camHUD.zoom") + 0.1)
      setProperty("textBlack.alpha", 0)
      if selectionMenu == "Menu" then 
         if texts[curSelect] == "Social_Media_Songs" then 
            selectionMenu = "Social Media Songs"
            makeText(songs)
            playSound("scrollMenu", 0.6, "select")
         elseif texts[curSelect] == "Options" then 
            selectionMenu = "Options"
            makeText(options)
            playSound("scrollMenu", 0.6, "select")
         end
         
      else
         if selectionMenu == "Options" then 
            options[curSelect][3] = options[curSelect][3] == false 
            setDataFromSave("ammarc", options[curSelect][4], options[curSelect][3])
            
           -- debugPrint(options[curSelect][3])
         else
           chooseSong()
         end
      
      end
      
   end
end
function isSongSelection()
   return (selectionMenu ~= "Options" and selectionMenu ~= "Menu")
end
function chooseSong()
   playSound("confirmMenu", 0.6, "confirm")
   selectSong = true
   runTimer("song", 2)
   runTimer("fade", 2)
   cameraFlash("hud", "0x7FFFFFFF", 1)
   local bg = string.lower(background[curSelect])
   doTweenX("zoomInX", bg .. ".scale", 2, 2.5, "quintIn")
   doTweenY("zoomInY", bg .. ".scale", 2, 2.5, "quintIn")
   doTweenAlpha("goneGradient", "textBlack", 0, 0.5)
   beatZoom = false
   musicFadeOut(2.5, 0.2)

   for i = 1, #texts do 
      local tag = texts[i]
      if tag ~= texts[curSelect] then
         doTweenX("texts" .. tag, tag, getProperty(tag .. ".x") + 700, 1.5, "quadIn")
      end
   end
end
function changeSong(amount)
   curSelect = curSelect + amount
   if amount ~= 0 and #texts > 1 then
      playSound("scrollMenu", 0.6, "select")
   end

   if curSelect < 1 then curSelect = #texts 
   elseif curSelect > #texts then curSelect = 1 end

   local song = texts[curSelect]

   songScores = 0
end

function createMenu()
   
   makeLuaSprite("bg", "ammarBG", 0, 0)
   setObjectCamera("bg", 'hud')
   screenCenter("bg")
   setProperty("bg.color", getColorFromHex("37dea1"))
   addLuaSprite("bg", true)

   for i = 1, #background do 
      local tag = string.lower(background[i]:gsub( " ", "_"))
      local alreadyLoad = false;

      for a = 1, #loadBack do 
         if loadBack[a][1] == tag then 
            alreadyLoad = true
            break;
         end
      end

      if not alreadyLoad then
         makeLuaSprite(tag, "menu/" .. background[i] ,0,0)
         scaleObject(tag, 0.72, 0.72)
         screenCenter(tag)
         setObjectCamera(tag, 'hud')
         addLuaSprite(tag)
         setProperty(tag.. ".alpha", 0)
         setObjectOrder(tag, getObjectOrder("bg") + 1)

         table.insert( loadBack, {tag, getProperty(tag.. ".y"), getProperty(tag.. ".x")} )
      end
   end

   makeLuaSprite("textBlack", "menu/gradient", 0, 0)
   setObjectCamera("textBlack", 'hud')
   screenCenter("textBlack")
   addLuaSprite("textBlack", true)


   
   bgX= getProperty("bg.x")
   bgY= getProperty("bg.y")
   makeLuaSprite("overlay", "", 0, 0)
   makeGraphic("overlay", 1000, 80, "000000")
   setObjectCamera("overlay", 'hud')
   screenCenter("overlay")
   setProperty("overlay.alpha", 0.5)
   setProperty("overlay.x", 1280)
   
   addLuaSprite("overlay", true)

   makeText(menus)

   makeLuaText("diffTxt", "DIFF : " , 900 ,20, 20)
   setTextSize("diffTxt", 32)
   setObjectCamera("diffTxt", 'hud')
   setTextFont("diffTxt", "1_Minecraft-Regular.otf")
   setTextAlignment("diffTxt", "left")
   addLuaText("diffTxt")

   makeLuaSprite("fading", "", 0, 0)
   makeGraphic("fading", 1400, 8000, "000000")
   setObjectCamera("fading", 'other')
   screenCenter("fading")
   setProperty("fading.alpha", 0)
   addLuaSprite("fading", true)

   makeLuaText("loadTxt", "loading" , 1200 ,20, 20)
   setTextSize("loadTxt", 16)
   setObjectCamera("loadTxt", 'other')
   setTextFont("loadTxt", "1_Minecraft-Regular.otf")
   setTextAlignment("loadTxt", "center")
   addLuaText("loadTxt")
   screenCenter("loadTxt")
   setProperty("loadTxt.alpha", 0)

   makeLuaText("loadTxt2", "(If it take 1 min longer, please restart the game)" , 1200 ,0, 690)
   setTextSize("loadTxt2", 16)
   setObjectCamera("loadTxt2", 'other')
   setTextFont("loadTxt2", "1_Minecraft-Regular.otf")
   setTextAlignment("loadTxt2", "center")
   addLuaText("loadTxt2")
   screenCenter("loadTxt2", "X")
   setProperty("loadTxt2.alpha", 0)

end

function makeText(array)
   
   for i = 1, #texts do 
      removeLuaText(texts[i])
     cancelTween(texts[i])
   end
   texts = {}
   for i = 1, #array do 
      local tag = array[i][1]:gsub( " ", "_")
      makeLuaText(tag, array[i][1] , 1280 ,400, i * ySpace)
      setTextSize(tag, fontSize)
      setObjectCamera(tag, 'hud')
      setTextFont(tag, "1_Minecraft-Regular.otf")
      setTextAlignment(tag, "right")
      addLuaText(tag)
      setProperty(tag .. ".origin.x", getProperty(tag.. ".width"))

      table.insert(texts, tag)

      doTweenX(tag, tag, -40, 0.8, "backOut")
   end
   changeSong(0)
end

function lerp(a, b, t) return a + (b - a) * t end