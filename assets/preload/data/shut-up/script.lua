defaultNotes = {}

opponentText = "";
playerText = "";
font = "OpenSans-Semibold.ttf"
fontSide = 20;

oldRating = 0;
oldCombos = {};

lightMode = false;
oldLight = false;

dancingBar = false;


membersX = 1000;
channelsX = -80;

lightColor = {"left", "down", "up", "right"}
lightColorHex = {"c800ff", "00c3ff", "0ef50a", "f50000"}

membsY = {-1000, 20} -- up , down
chansY = {-650, 20} -- up , down

boomspeed = 4
bam = 1
oldWiggle = false
wigglefreq = 0
wiggleamp = 0
wiggleampLerp = 0
susOffset = 0

enemyTextVocal = 
{
   {{"a", "a", ""}},  -- aa
   {{"e", "e", ""}}, -- ee
   {{"o", "o", ""}} -- oo
}

playerTextVocal = 
{
   {{"a", "a", ""}},  -- aa
   {{"e", "e", ""}}, -- ee
   {{"o", "o", ""}} -- oo
}
opponentShake = 0
shakeAdd = 0

defColor = {}
discordStuff = {"background", "opponent", "opText", "opTextType", "player", "plText", "channels", "members", "message", "topBar"}

opponentDefY = 0;
local mechanic = false
function onCreate()
   setProperty("skipArrowStartTween", true)
end
function onCreatePost()
   mechanic = getDataFromSave("ammarc", "mechanic")

   setProperty("defaultCamZoom", 0.9)
   setProperty("camGame.zoom", 0.9)
   precacheImage("buffer/MembersList2B")
   precacheImage("buffer/MembersList2B-Light")
   precacheImage("buffer/Boy")
   precacheImage("buffer/MembersList2-Light")
   precacheImage("buffer/messageBar-Light")
   precacheImage("buffer/topBar-Light")

   makeLuaSprite("background", "", -400 , -400)
   makeGraphic("background", 2000,2000, "FFFFFF")
   setScrollFactor("background", 0 ,0)
   addLuaSprite("background", true)
   setProperty("background.color", getColorFromHex("36393F"))

   makeLuaSprite("opponent", "buffer/Girl", 0 , 800)
   setScrollFactor("opponent", 0 ,0)
   addLuaSprite("opponent", true)
   setGraphicSize("opponent", 0, 100)

   makeLuaText("opText", "", 500, 100, 255)
   setScrollFactor("opText", 0 ,0)
   addLuaText("opText")
   setTextFont("opText", font)
   setTextAlignment("opText", 'left')
   setTextBorder("opText", 0, "36393F")
   setObjectCamera("opText", "game")
   setTextSize("opText", fontSide)
   setProperty("opText.antialiasing", getPropertyFromClass("ClientPrefs", globalAntialiasing))

   makeLuaText("opTextType", "(Random Girl is Typing...)", 500, 100, 255)
   setScrollFactor("opTextType", 0 ,0)
   addLuaText("opTextType")
   setTextFont("opTextType", font)
   setTextAlignment("opTextType", 'left')
   setTextBorder("opTextType", 0, "36393F")
   setObjectCamera("opTextType", "game")
   setTextSize("opTextType", fontSide)
   setProperty("opTextType.alpha", 0)
   setProperty("opTextType.antialiasing", getPropertyFromClass("ClientPrefs", globalAntialiasing))

   makeLuaSprite("player", "buffer/Annoying User", 0 , 800)
   setScrollFactor("player", 0 ,0)
   addLuaSprite("player", true)
   setGraphicSize("player", 0, 88)
   setProperty("player.offset.x", getProperty("player.offset.x") - 11)

   makeLuaText("plText", "", 500, 100, 255)
   setScrollFactor("plText", 0 ,0)
   addLuaText("plText")
   setTextFont("plText", font)
   setTextAlignment("plText", 'left')
   setTextBorder("plText", 0, "36393F")
   setObjectCamera("plText", "game")
   setTextSize("plText", fontSide)
   setProperty("plText.antialiasing", getPropertyFromClass("ClientPrefs", globalAntialiasing))

   makeLuaSprite("channels", "buffer/ChannelsList", -80 , chansY[1])
   setScrollFactor("channels", 0 ,0)
   addLuaSprite("channels", true)

   makeLuaSprite("members", "buffer/MembersList2", 1000 , membsY[2])
   setScrollFactor("members", 0 ,0)
   addLuaSprite("members", true)

   makeLuaSprite("message", "buffer/messageBar", 48 , 640)
   setScrollFactor("message", 0 ,0)
   addLuaSprite("message", true)
   scaleObject("message", 1, 1)
   setObjectCamera("message", "hud")
   screenCenter("message", "x")
   setObjectOrder("message", getObjectOrder("timeBarBG") - 1)

   makeLuaSprite("topBar", "buffer/topBar", -70 , 0)
   setScrollFactor("topBar", 0 ,0)
   addLuaSprite("topBar", true)
   setGraphicSize("topBar", 1280)
   setObjectCamera("topBar", "hud")
   screenCenter("topBar", "x")
   setObjectOrder("topBar", getObjectOrder("timeBarBG") - 2)

   makeLuaSprite("glow", "buffer/GLOWLIGHT", -130 , -360)
   setScrollFactor("glow", 0 ,0)
   scaleObject("glow", 1.2, 1.2)
   addLuaSprite("glow", true)
   setProperty("glow.alpha", 0)
   setObjectCamera("glow", "hud")
   screenCenter("glow")

   makeLuaSprite("red", "", 0 , 0)
   makeGraphic("red", 2000,2000, "FF0000")
   addLuaSprite("red", true)
   setObjectCamera("red", "hud")
   screenCenter("red")
   setProperty("red.alpha", 0)
   setBlendMode("red", "multiply")
   setObjectOrder("red", getObjectOrder("message") + 1)

   makeLuaSprite("warningRed", "buffer/redVignette", 0 , 0)
   addLuaSprite("warningRed", true)
   setObjectCamera("warningRed", "hud")
   screenCenter("warningRed")
   setProperty("warningRed.alpha", 0)
   setObjectOrder("warningRed", getObjectOrder("notes") + 1)

   setProperty("healthBar.visible", false)
   setProperty("healthBarBG.visible", false)
   setProperty("iconP1.visible", false)
   setProperty("iconP2.visible", false)

   setTextFont("scoreTxt", font)


   setProperty("timeBar.color", getColorFromHex("FF0000"))

   for note = 0, getProperty("unspawnNotes.length") do 
      if not getPropertyFromGroup("unspawnNotes", note, "mustPress") then
         setPropertyFromGroup("unspawnNotes", note, "color", getColorFromHex("FF0000"))
      end
   end
   for note = 0, getProperty("unspawnNotes.length") do 
      if getPropertyFromGroup("unspawnNotes", note, "isSustainNote") then
         susOffset = getPropertyFromGroup("unspawnNotes", note, "offsetX")
         break;
      end
   end
   
end

songStart = false
function onSongStart()
   
   for note = 0, 7 do 
      local _x = getPropertyFromGroup("strumLineNotes", note, "x")
      local _y = getPropertyFromGroup("strumLineNotes", note, "y")
      local _s = getPropertyFromGroup("strumLineNotes", note, "scale")
      table.insert( defaultNotes, {_x , _y, _x})
   end

   opponentDefY = getProperty("dad.y")
   songStart = true

   if not mechanic then
      setObjectCamera("static", "hud")
      setObjectOrder("static", getObjectOrder("red") + 1)
   end
end


bfSing = false;
oldSing = false;

chatX = 320;
topY = 160;
bottomY = 400;

playerMove = false;
opponentMove = false;
goodPart = false;

notMoving = false;

tElap = 0;
function onUpdate(elapsed)
   if curStep <= 10 then
      for strum = 0,3 do 
         setPropertyFromGroup("strumLineNotes", strum, "color", getColorFromHex("FF0000"))
      end
   end
   tElap = tElap + elapsed
   local percent = elapsed * 5;
   if not notMoving then
      local belowP = topY + getProperty("player.height") + (#playerText < 2 and 0 or getProperty("plText.height")) + 10
      local belowO = topY + getProperty("opponent.height") + (#opponentText < 2 and 0 or getProperty("opText.height")) + 10
      --debugPrint(#opponentText < 2 )
      if bfSing and not chaosSing then
         if opponentMove then  
            setProperty("opponent.y", lerp(getProperty("opponent.y"), topY, percent ))
         end
         if playerMove then
            setProperty("player.y", lerp(getProperty("player.y"), belowO, percent ))
         end
      else 
         if opponentMove then  
            setProperty("opponent.y", lerp(getProperty("opponent.y"), belowP, percent ))
         end
         if playerMove then
            setProperty("player.y", lerp(getProperty("player.y"), topY, percent ))
         end
      end
   end
   
   if songStart then 
      setProperty("dad.y", opponentDefY + math.sin(tElap * 1.8) * 80)
   end
   chatPos()

   setTextString("opText", opponentText)
   setTextString("plText", playerText)
   setProperty("glow.angle", getProperty("glow.angle") + (elapsed*4))

   

   if #opponentText < 1 then 
      if checkForNote(false) then 
         setProperty("opTextType.alpha", 1)
      else 
         setProperty("opTextType.alpha", 0)
      end
   else 
      setProperty("opTextType.alpha", 0)
   end

   if lightMode then
      if mechanic then
         for note = 0, getProperty("notes.length")-1 do 
            if getPropertyFromGroup("notes", note, "mustPress") then
               setPropertyFromGroup("notes", note, "colorSwap.brightness", 0)
               setPropertyFromGroup("notes", note, "colorSwap.saturation", -1)

               setPropertyFromGroup("notes", note, "noteSplashBrt", 0)
               setPropertyFromGroup("notes", note, "noteSplashSat", -1)
            end
         end
      end
      if not oldLight then 
         setProperty("background.color", getColorFromHex("FFFFFF"))
         setProperty("opTextType.color", getColorFromHex("36393F"))
         setTextColor("opText", "36393F")
         setTextColor("plText", "36393F")
   
         loadGraphic("channels", "buffer/ChannelsList-Light")
         if curStep >= 1600 then 
            loadGraphic("members", "buffer/MembersList2B-Light")
         else
            loadGraphic("members", "buffer/MembersList2-Light")
         end
         loadGraphic("message", "buffer/messageBar-Light")
         loadGraphic("topBar", "buffer/topBar-Light")
   
         setProperty("glow.alpha", 0.3)
         cameraFlash("game", "0xCCFFFFFF", 2, false)
         cameraFlash("hud", "0xCCFFFFFF", 1, false)

         if curStep >= 2752 then 
            setTextColor("opText", "FFFFFF")
            setTextColor("plText", "FFFFFF")
         end
   
      end
      oldLight = true
   else 
      if oldLight then 
         if mechanic then
            for note = 0, getProperty("notes.length")-1 do 
               local noteData = getPropertyFromGroup("notes", note, "noteData") + (getPropertyFromGroup("notes", note, "mustPress") and 4 or 0)
               setPropertyFromGroup("notes", note, "colorSwap.brightness", getPropertyFromClass("ClientPrefs", "arrowHSV")[(noteData%4) + 1][3])
               setPropertyFromGroup("notes", note, "colorSwap.saturation", getPropertyFromClass("ClientPrefs", "arrowHSV")[(noteData%4) + 1][2])
      
               setPropertyFromGroup("notes", note, "noteSplashBrt", getPropertyFromClass("ClientPrefs", "arrowHSV")[(noteData%4) + 1][3])
               setPropertyFromGroup("notes", note, "noteSplashSat", getPropertyFromClass("ClientPrefs", "arrowHSV")[(noteData%4) + 1][2])
            end
         end

         setProperty("background.color", getColorFromHex("36393F"))
         loadGraphic("channels", "buffer/ChannelsList")
         if curStep >= 1600 then 
            loadGraphic("members", "buffer/MembersList2B")
         else
            loadGraphic("members", "buffer/MembersList2")
         end
         loadGraphic("message", "buffer/messageBar")
         loadGraphic("topBar", "buffer/topBar")
   
         setProperty("glow.alpha", 0)
         cameraFlash("game", "0xCCFFFFFF", 2, false)
         cameraFlash("hud", "0xCCFFFFFF", 1, false)
   
         setTextColor("opText", "FFFFFF")
         setTextColor("plText", "FFFFFF")
      end
      oldLight = false
   end

end

function chatPos()
   setProperty("opponent.x", chatX)
   --setProperty("opponent.y", 200)
   setProperty("player.x", chatX)
   --setProperty("player.y", 400)
   setProperty("opText.x", getProperty("opponent.x") + 110)
   setProperty("opText.y", getProperty("opponent.y") + 48)
   setProperty("plText.x", getProperty("player.x") + 110)
   setProperty("plText.y", getProperty("player.y") + 48)
   setProperty("opTextType.x", getProperty("opponent.x") + 110)
   setProperty("opTextType.y", getProperty("opponent.y") + 48)
end

function strumShake()
   local shake = (opponentShake + shakeAdd) * 5
   for i =0,7 do 
      setPropertyFromGroup("strumLineNotes", i, "y", defaultNotes[1 + i][2] + getRandomFloat(-shake, shake))
      setPropertyFromGroup("strumLineNotes", i, "x", defaultNotes[1 + i][1] + getRandomFloat(-shake, shake))
   end

end

oppTimer = 0;
plaTimer = 0;

playerTweening = false;
opponentTweening = false;
opponentFade = true;
opponentCaps = true

function onUpdatePost(elapsed)
   opponentShake = lerp(opponentShake, 0 ,elapsed * 5)
   local doShake = opponentShake + shakeAdd
   if mechanic then
      setProperty("camGame.angle", getRandomFloat(-doShake + 0.00, (doShake + 0.00)))
      setProperty("camHUD.angle", lerp(getProperty("camHUD.angle") ,getRandomFloat(-doShake + 0.00 / 2, (doShake + 0.00) / 2), elapsed*11))
      strumShake()
   end

   bfSing = mustHitSection
   if oppTimer > 0 then 
      oppTimer = oppTimer - elapsed
   end
   if plaTimer > 0 then 
      plaTimer = plaTimer - elapsed
   end

   if oppTimer <= 0 and opponentFade then 
      if (bfSing and not oldSing) then 
         removeWordsFromOpp(chaosSing)
         oldSing = true;
      end
   end
   if plaTimer <= 0 then 
      if (not bfSing and oldSing) then 
         removeWordsFromPla(chaosSing)
         oldSing = false;
      end
   end

   if #opponentText > 200 then 
      removeWordsFromOpp(true, true)
   end
   if #playerText > 200 then 
      removeWordsFromPla(true, true)
   end

   wiggleampLerp = math.floor(lerp(wiggleampLerp, wiggleamp, elapsed * 10))
   if not inGameOver and mechanic then
      for i=0,getProperty('notes.length') do
         local strum = getPropertyFromGroup('notes',i,'strumTime')
         local woom = (strum-getSongPosition())
         local sus = getPropertyFromGroup('notes',i,'isSustainNote')
         local strength = wiggleampLerp
         if getPropertyFromGroup("notes", i, "mustPress") then strength = -strength end
         if wiggleamp > 0 then
            woom = (strum-getSongPosition())/wigglefreq
         end
         if oldWiggle then 
            setPropertyFromGroup('notes',i,'angle',strength *math.sin(woom))
         else 
            setPropertyFromGroup('notes',i,'offsetX', (strength *math.sin(woom/2)) + ((sus) and susOffset or 0))
         end
      
      end
   end

   
end

local noteXCenter = {412,524,636,748} -- Notes center : 0 , 1 , 2 , 3
local noteYPlace = {50,570} -- Up , Down
function onStepHit()

   if curStep == 56 then 
      opponentMove = true;
      playerMove = true;
      dancingBar = true
   end
   if curStep == 320 then 
      dancingBar = false
      shakeAdd = 1
      doTweenAlpha("red", "red", 0.5, crochet/1000*4*6)
      setProperty('static.visible', true)
      setProperty('static.alpha', 0)
      doTweenAlpha("static", "static", 0.2, crochet/1000*4*6)
   end
   if curStep == 576 then 
      dancingBar = true
      shakeAdd = 0
      setProperty('static.visible', false)
      doTweenAlpha("red", "red", 0, 1)
      lightMode = true
   end
   if curStep == 883 then 
      removeWordsFromOpp(true, true)
   end
   if curStep == 884 or curStep == 886 then 
      opponentText = opponentText .. " HEE"
      triggerEvent("Add Camera Zoom",0.03,0.03)
   end
   if curStep == 2112 then 
      dancingBar = false
      shakeAdd = 1
      doTweenAlpha("red", "red", 0.5, crochet/1000*4*10)
      setProperty('static.visible', true)
      setProperty('static.alpha', 0)
      doTweenAlpha("static", "static", 0.3, crochet/1000*4*10)
   end
   if curStep == 2368 then 
      dancingBar = true
      shakeAdd = 0
      setProperty('static.visible', false)
      doTweenAlpha("red", "red", 0, 1)
   end
   if curStep == 1088 or curStep == 2368 or curStep == 2752 then 
      lightMode = true

   end
   if curStep == 832 or curStep == 1344 or curStep == 2624 or curStep == 2880 then 
      lightMode = false
   end
   if curStep == 1600 or curStep == 2624 or curStep == 2880 then 
      setProperty('static.visible', true)
      setProperty('static.alpha', 0.2)
      
      if curStep <= 1600 then
         loadGraphic("player", "buffer/Boy")
         loadGraphic("members", "buffer/MembersList2B")
      end
      for i = 1, #discordStuff do 
         local index = i
         setProperty(discordStuff[index] .. ".visible", false)
        
      end
      cameraFlash("hud", "FFFFFF", 2, false)
      setProperty("defaultCamZoom", 0.6)

      setProperty("healthBar.visible", true)
      setProperty("healthBarBG.visible", true)
      setProperty("iconP1.visible", true)
      setProperty("iconP2.visible", true)
   end
   if curStep == 1856 then 
      setProperty('static.visible', false)
      for i = 1, #discordStuff do 
         local index = i
         setProperty(discordStuff[index] .. ".visible", true)
        
      end
      cameraFlash("hud", "FFFFFF", 2, false)
      setProperty("defaultCamZoom", 0.9)

      setProperty("healthBar.visible", false)
      setProperty("healthBarBG.visible", false)
      setProperty("iconP1.visible", false)
      setProperty("iconP2.visible", false)
   end
   if curStep == 2752 then 
      setProperty('static.visible', true)
      setProperty('static.alpha', 0.3)
      for i = 2, #discordStuff do 
         local index = i
         setProperty(discordStuff[index] .. ".visible", true)
        
      end
      setProperty("members.visible", false)
      setProperty("channels.visible", false)
      

      cameraFlash("hud", "FFFFFF", 1, false)
   end
   if curStep == 2880 then 
      setProperty('static.visible', true)
      setProperty('static.alpha', 0.1)
      shakeAdd = 0.1
   end

   if curStep >= 2624 and curStep < 2880 then
      if curStep % 4 == 0 then 
         setProperty("warningRed.alpha", 0.6)
         doTweenAlpha("warningRed", "warningRed", 0 , crochet/1000*0.8)
      end
   end
   if curStep == 2624 then 
      shakeAdd = 1.2
   end
   if curStep == 3136 then 
      setProperty('static.visible', true)
      doTweenAlpha("static", "static", 0.8, crochet/1000*4*9)
   end

   if dancingBar then
      if curStep % 8 == 7 then 
         doTweenX("moveMemsX", "members", membersX + 70, crochet/1000/4, "circIn")
      end
    

      if curStep % 8 == 3 then 
         doTweenX("moveChannelsX", "channels", channelsX - 70, crochet/1000/4, "circIn")
      end
     
   end
   if curStep % 8 == 4 then 
      doTweenX("moveChannelsX", "channels", channelsX, crochet/1000*2, "quadOut")
   end
   if curStep % 8 == 0 then 
      doTweenX("moveMemsX", "members", membersX, crochet/1000*2, "quadOut")
   end
   
end

function onBeatHit()
   if curBeat % 32 == 0 then 
      doTweenY("moveMemsY", "members", membsY[2], crochet/1000*14, "sineOut")
      doTweenY("moveChannelsY", "channels", chansY[1], crochet/1000*14, "sineOut")
   end
   if curBeat % 32 == 16 then 
      doTweenY("moveMemsY", "members", membsY[1], crochet/1000*14, "sineOut")
      doTweenY("moveChannelsY", "channels", chansY[2], crochet/1000*14, "sineOut")
   end
   if curBeat % boomspeed == 0 and not songEnded then
		triggerEvent("Add Camera Zoom",0.015*bam,0.03*bam)
		if getProperty('camGame.zoom') >= 1.35 then
			
			setProperty('camGame.zoom',getProperty('camGame.zoom')+0.025*bam);
			setProperty('camHUD.zoom',getProperty('camHUD.zoom')+0.03*bam);
		end
	end
   
end

chaosSing = false;
local randomWords = {"aah", "ooh", "eee", "eeh", "aai"}
local words = {
   ["aaa"] = {["sus"] = {"a "}, [""] = {"aa ", "aah "}},
   ["eee"] = {["sus"] = {"e "}, [""] = {"eee ", "ee "}},
   ["ooo"] = {["sus"] = {"o "}, [""] = {"ooo ", "oo "}}
}


function findWordsToSing(susNote, noteType)
   susText = (susNote and "sus" or "")
   text = "";
   if string.lower(noteType)=="aaa sing" then 
      text = words["aaa"][susText][getRandomInt(1, #words["aaa"][susText])];
   elseif string.lower(noteType)=="eee sing" then 
      text = words["eee"][susText][getRandomInt(1, #words["eee"][susText])];
   elseif string.lower(noteType)=="ooo sing" then 
      text = words["ooo"][susText][getRandomInt(1, #words["ooo"][susText])];
   end

   randomWord = {"aaa", "eee", "ooo"}
   
   if text == "" then 
      local aeo = randomWord[getRandomInt(1, 3)]
      text = words[aeo][susText][getRandomInt(1, #words[aeo][susText])]
   end

   if string.lower(noteType)=="no sing" then 
      text = "";
   end



   return text;
end
local playerCurTextArray = {}
local enemyCurTextArray = {}
local singer = {"aaa Sing", "eee Sing", "ooo Sing"}
local voiceConvert = {
   ["aaa Sing"] = 1,
   ["eee Sing"] = 2,
   ["ooo Sing"] = 3
}
function goodNoteHit(id, direction, noteType, isSustainNote)
   if noteType == "no Sing" then return end
   local nType = noteType
  
   if voiceConvert[noteType] == nil then
      nType = singer[getRandomInt(1,3)]
   end
   
   local text = playerText
   if not isSustainNote then

      plaTimer = 1;

      if playerTweening then
         cancelTween("removeTextPla");
         playerTweening = false;
         playerText = "";
         text = ""
         setProperty("plText.alpha", 1)
      end
      
      local vocal = playerTextVocal[voiceConvert[nType]]
      local randomNum = getRandomInt(1, #playerTextVocal[voiceConvert[nType]])
      playerCurTextArray = vocal[randomNum]

      text = text .. " " .. playerCurTextArray[1]

      if not getPropertyFromGroup("notes", id,"nextNote.isSustainNote") then 
         text = text .. playerCurTextArray[2] .. playerCurTextArray[3]

      end
   else 
      if not (string.find( getPropertyFromGroup("notes",id,"animation.curAnim.name"), "end" )) then 
         text = text .. playerCurTextArray[2]
         if string.find(getPropertyFromGroup("notes", id,"nextNote.animation.curAnim.name"), "end") then
            text = text .. playerCurTextArray[3]
         end
      end
   end
   playerText = text
end

local enemyCurTextArray = {}
function opponentNoteHit(id, direction, noteType, isSustainNote)
   if noteType == "no Sing" then return end
   local groupText = enemyTextVocal
   local nType = noteType
   
   if voiceConvert[noteType] == nil then
      nType = singer[getRandomInt(1,3)]
   end

   local text = opponentText
   if not isSustainNote then
      local vocal = groupText[voiceConvert[nType]]
      local randomNum = getRandomInt(1, #groupText[voiceConvert[nType]])
      enemyCurTextArray = vocal[randomNum]

      text = text .. " " .. (opponentCaps and string.upper(enemyCurTextArray[1]) or enemyCurTextArray[1])

      if not getPropertyFromGroup("notes", id,"nextNote.isSustainNote") then 
         text = text .. (opponentCaps and string.upper(enemyCurTextArray[2]) or enemyCurTextArray[2]) .. (opponentCaps and string.upper(enemyCurTextArray[3]) or enemyCurTextArray[3])
      end

      if opponentCaps then
         opponentShake = opponentShake + 1
         triggerEvent("Add Camera Zoom", 0.018, 0.01)
      end

      oppTimer = 1;

      if opponentTweening then
         opponentTweening = false;
         cancelTween("removeTextOpp");
         opponentText = "";
         setProperty("opText.alpha", 1)
         text = ""
      end
      loseHealthCarefull(0.02)
   else 
      if not (string.find( getPropertyFromGroup("notes",id,"animation.curAnim.name"), "end" )) then 
         text = text .. (opponentCaps and string.upper(enemyCurTextArray[2]) or enemyCurTextArray[2])
         if string.find(getPropertyFromGroup("notes", id,"nextNote.animation.curAnim.name"), "end") then
            text = text .. (opponentCaps and string.upper(enemyCurTextArray[3]) or enemyCurTextArray[3])
         end
      end

      loseHealthCarefull(0.01)
      if opponentCaps then
         opponentShake = opponentShake + 0.5
      end
   end
   opponentText = (haterCaps and string.upper(text) or text)

end

function loseHealthCarefull(amount)
   if not mechanic then return end
   health = getProperty("health")
   health = health - amount
   if health < 0.1 then 
      health = 0.1
   end
   setHealth(health)
end


function removeWordsFromOpp(force, quick)
   if quick then 
      opponentText = "";
      setProperty("opText.alpha", 1)
   else 
      opponentTweening = true;
      doTweenAlpha("removeTextOpp", "opText", 0.5, crochet/1000, "quadOut")
   end
end

function removeWordsFromPla(force, quick)

   if quick then 
      playerText = "";
      setProperty("plText.alpha", 1)
   else
      playerTweening = true;
      doTweenAlpha("removeTextPla", "plText", 0.5, crochet/1000, "quadOut")
   end
end




function onTweenCompleted(tag)
	if tag == "removeTextOpp" then 
      opponentTweening = false;
      opponentText = "";
      setProperty("opText.alpha", 1)
      setTextString("opText", "")
   end
   if tag == "removeTextPla" then 
      playerTweening = false;
      playerText = "";
      setProperty("plText.alpha", 1)
      setTextString("plText", "")
   end
end

local spaceRange = 200;
function checkForNote(_player)
   player = (_player or false)
	
	for i = 0, getProperty('notes.length')-1 do
	   dis = -0.45 * (getSongPosition() - getPropertyFromGroup('notes', i, 'strumTime'));
		noteType = getPropertyFromGroup('notes', i, 'noteType')
      mustPress = getPropertyFromGroup('notes', i, 'mustPress')
		range = dis <= spaceRange
      correctNote = false

      if (player and mustPress) or (not player and not mustPress) then 
         correctNote = true;
      end
		
		if range and correctNote then
		   return true;
		end
	end
	
   return false;
end

function onEvent(n,v1,v2)

   if n == "Cam Boom Speed" then
   
      boomspeed = tonumber(v1)
      bam = tonumber(v2)
   
   end
   if n == 'WiggleNotes' then
		wigglefreq = tonumber(v1)
		wiggleamp = tonumber(v2)
	end
   
end

function lerp(a, b, t)
	return a + (b - a) * t
end