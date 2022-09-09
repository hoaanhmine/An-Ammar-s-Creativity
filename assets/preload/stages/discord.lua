opponentText = "";
playerText = "";
font = "OpenSans-Semibold.ttf"
fontSide = 20;

oldRating = 0;
oldCombos = {};

lightMode = false;

dancingBar = true;


membersX = 1000;
channelsX = -80;

lightColor = {"left", "down", "up", "right"}
lightColorHex = {"c800ff", "00c3ff", "0ef50a", "f50000"}

membsY = {-650, 20} -- up , down
chansY = {-650, 20} -- up , down

local mechanic = false
function onCreate()
   
   setProperty("skipArrowStartTween", true)
end
function onCreatePost()
   mechanic = getDataFromSave("ammarc", "mechanic")
   precacheImage("buffer/ChannelsList-Light")
   precacheImage("buffer/MembersList-Light")
   precacheImage("buffer/messageBar-Light")
   precacheImage("buffer/topBar-Light")

   for i = 1, #lightColor do 
      precacheImage("light/" .. lightColor[i])
   end

   makeLuaSprite("background", "", -600 , -400)
   makeGraphic("background", 2000,2000, "FFFFFF")
   setScrollFactor("background", 0 ,0)
   addLuaSprite("background", true)
   setProperty("background.color", getColorFromHex("36393F"))

   makeLuaSprite("opponent", "buffer/Ammar", 0 , 800)
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

   makeLuaText("opTextType", "(An Ammar is Typing...)", 500, 100, 255)
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
   setGraphicSize("player", 0, 100)

   makeLuaText("plText", "", 500, 100, 255)
   setScrollFactor("plText", 0 ,0)
   addLuaText("plText")
   setTextFont("plText", font)
   setTextAlignment("plText", 'left')
   setTextBorder("plText", 0, "36393F")
   setObjectCamera("plText", "game")
   setTextSize("plText", fontSide)
   setProperty("plText.antialiasing", getPropertyFromClass("ClientPrefs", globalAntialiasing))

   makeLuaSprite("bot", "buffer/AnCom", 320 , 800)
   setScrollFactor("bot", 0 ,0)
   addLuaSprite("bot", true)
   setGraphicSize("bot", 0, 100)


   makeLuaSprite("channels", "buffer/ChannelsList", -80 , chansY[1])
   setScrollFactor("channels", 0 ,0)
   addLuaSprite("channels", true)

   makeLuaSprite("members", "buffer/MembersList", 1000 , membsY[2])
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

   makeLuaSprite("blackFade", "", 0 , 0)
   makeGraphic("blackFade", 2000,2000, "000000")
   setScrollFactor("blackFade", 0 ,0)
   addLuaSprite("blackFade", true)
   screenCenter("blackFade")
   setObjectCamera("blackFade", "hud")
   setProperty('blackFade.alpha', 0);

   makeLuaSprite('glowNote', 'light/down', 0,0); -- -74 x , y
   setScrollFactor('glowNote', 0, 0);
   scaleObject('glowNote', 0.82, 0.82);
   setObjectCamera("glowNote", "other")
   screenCenter("glowNote")
   addLuaSprite('glowNote' , false);
   setProperty('glowNote'..".alpha", 0);

   setProperty("healthBar.visible", false)
   setProperty("healthBarBG.visible", false)
   setProperty("iconP1.visible", false)
   setProperty("iconP2.visible", false)

   setTextFont("scoreTxt", font)
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
   tElap = tElap + elapsed
   local percent = elapsed * 5;
   if not notMoving then
      if bfSing and not chaosSing then
         if opponentMove then  
            setProperty("opponent.y", lerp(getProperty("opponent.y"), topY, percent ))
         end
         if playerMove then
            setProperty("player.y", lerp(getProperty("player.y"), bottomY, percent ))
         end
      else 
         if opponentMove then  
            setProperty("opponent.y", lerp(getProperty("opponent.y"), bottomY, percent ))
         end
         if playerMove then
            setProperty("player.y", lerp(getProperty("player.y"), topY, percent ))
         end
      end
   end
   
   chatPos()

   setProperty("glow.angle", getProperty("glow.angle") + (elapsed*4))

   setTextString("opText", opponentText)
   setTextString("plText", playerText)

   if #opponentText < 1 then 
      if checkForNote(false) then 
         setProperty("opTextType.alpha", 1)
      else 
         setProperty("opTextType.alpha", 0)
      end
   else 
      setProperty("opTextType.alpha", 0)
   end

   if lightMode and mechanic then
      for note = 0, getProperty("notes.length")-1 do 
         setPropertyFromGroup("notes", note, "colorSwap.brightness", 0)
         setPropertyFromGroup("notes", note, "colorSwap.saturation", -1)

         setPropertyFromGroup("notes", note, "noteSplashBrt", 0)
         setPropertyFromGroup("notes", note, "noteSplashSat", -1)
      end
   end

   if goodPart then 
      setProperty("camHUD.angle", math.sin(tElap) * 4)
      setProperty("camGame.angle", math.sin(tElap) * 2)
   end

   if curStep >= 1220 and curStep < 1248 then 
      notMoving = true;
      setProperty("opponent.y", lerp(getProperty("opponent.y"), -80, percent ))
      setProperty("player.y", lerp(getProperty("player.y"), 160, percent ))

      setProperty("bot.y", lerp(getProperty("bot.y"), 400, percent ))
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

oppTimer = 0;
plaTimer = 0;

playerTweening = false;
opponentTweening = false;
opponentFade = true;

function onUpdatePost(elapsed)
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

   fixDirection()
end

local noteXCenter = {412,524,636,748} -- Notes center : 0 , 1 , 2 , 3
local noteYPlace = {50,570} -- Up , Down
function onStepHit()
   if curStep == 4 then 
      opponentMove = true;
   end
   if curStep == 48 then 
      playerMove = true;
   end
   if curStep == 1075 or curStep == 1488 or curStep == 1535 then 
      chaosSing = true;
   end
   if curStep == 1167 or curStep == 1519 then 
      chaosSing = false;
   end

   if curStep == 1168 or curStep == 1536 then 
      removeWordsFromOpp(true)
   end
   if curStep == 1192 or curStep == 1520 then 
      removeWordsFromPla(true)
   end
   if curStep == 1056 or curStep == 1232 or curStep == 1678 or curStep == 1759 then 
      removeWordsFromOpp(true)
      removeWordsFromPla(true)
   end
   if curStep == 1216 then 
      dancingBar = false;
      doTweenX("lB", "channels", -600, crochet/1000*3, "quadIn")
      doTweenX("rB", "members", 1500, crochet/1000*3, "quadIn")
   end
   if curStep == 1248 then 
      notMoving = false;
      doTweenY("botShoo", "bot", -500, 1, "quadIn")
      setProperty("background.color", getColorFromHex("FFFFFF"))
      setProperty("opTextType.color", getColorFromHex("36393F"))
      setTextColor("opText", "36393F")
      setTextColor("plText", "36393F")

      loadGraphic("channels", "buffer/ChannelsList-Light")
      loadGraphic("members", "buffer/MembersList-Light")
      loadGraphic("message", "buffer/messageBar-Light")
      loadGraphic("topBar", "buffer/topBar-Light")

      setProperty("glow.alpha", 0.3)
      cameraFlash("camHUD", "FFFFFF", 2, false)

      lightMode = true;
      
      membersX = 950;
      channelsX = -30;
      setObjectCamera("channels", "hud")
      setObjectCamera("members", "hud")
      setObjectOrder("channels", getObjectOrder("topBar") - 2)
      setObjectOrder("members", getObjectOrder("topBar") - 2)
      doTweenX("lB", "channels", -100, crochet/1000*4, "backOut")
      doTweenX("rB", "members", 1000, crochet/1000*4, "backOut")
      setProperty("defaultCamZoom", 1)

      for note = 0,7 do 
         noteTweenX("noteX"..note, note, noteXCenter[(note % 4) +1], crochet/1000*3, "quadInOut")

         if note < 4 then 
            noteTweenAlpha("noteEnemyA"..note, note, 0.2, crochet/1000*3, "quadInOut")
            noteTweenY("noteEnemyY"..note, note, noteYPlace[(downscroll and 1 or 2)], crochet/1000*3, "quadInOut")
            noteTweenDirection("noteEnemyDir" ..note, note, -90, crochet/1000*3, "quadInOut")
         end
      end
   end
   if curStep == 1264 then 
      dancingBar = true;
   end 
   if curStep == 1376 then 
      doTweenAlpha("blackFade", "blackFade", 1, crochet/1000)
   end
   if curStep == 1386 then 
      doTweenAlpha("blackFade", "blackFade", 0, crochet/1000)
   end
   if curStep == 1520 then 
      cameraFlash("camHUD", "FFFFFF", 2, false)
      setProperty("glow.alpha", 0.5)
      goodPart = true;
   end

   if dancingBar then
      if curStep % 8 == 7 then 
         doTweenX("moveMemsX", "members", membersX + 20, crochet/1000/4, "sineIn")
      end
      if curStep % 8 == 0 then 
         doTweenX("moveMemsX", "members", membersX, crochet/1000*2, "quadOut")
      end

      if curStep % 8 == 3 then 
         doTweenX("moveChannelsX", "channels", channelsX - 20, crochet/1000/4, "sineIn")
      end
      if curStep % 8 == 4 then 
         doTweenX("moveChannelsX", "channels", channelsX, crochet/1000*2, "quadOut")
      end
   end

   if curStep == 660 then 
      opponentFade = false;
      opponentTweening = false;
      cancelTween("removeTextOpp");
      opponentText = "!?!?!???!??";
      setProperty("opText.alpha", 1)
   end
   if curStep == 671 then 
      opponentFade = true;
      opponentText = ""
   end
   if curStep == 1380 then 
      opponentFade = false;
      opponentTweening = false;
      cancelTween("removeTextOpp");
      opponentText = "Done";
      setProperty("opText.alpha", 1)
   end
   if curStep == 1392 then 
      opponentText = "!!!!!";
   end
   if curStep == 1392 then 
      opponentText = "!?!?!?!?!";
   end
   if curStep == 1407 then 
      opponentFade = true;
      opponentText = ""
   end

   if curStep == 1776 then 
      setProperty("background.color", getColorFromHex("36393F"))
      loadGraphic("channels", "buffer/ChannelsList")
      loadGraphic("members", "buffer/MembersList")
      loadGraphic("message", "buffer/messageBar")
      loadGraphic("topBar", "buffer/topBar")

      setProperty("glow.alpha", 0)
      cameraFlash("camHUD", "FFFFFF", 2, false)

      setTextColor("opText", "FFFFFF")
      setTextColor("plText", "FFFFFF")

      lightMode = false;
   end
   if curStep == 1808 then 
      doTweenAlpha("blackFade", "blackFade", 1, crochet/1000*6)
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
   
end

chaosSing = false;
local randomWords = {"aah", "ooh", "eee", "eeh", "aai"}
local words = {
   ["aaa"] = {["sus"] = {"a "}, [""] = {"aa ", "aah "}},
   ["eee"] = {["sus"] = {"e "}, [""] = {"eee ", "ee "}},
   ["ooo"] = {["sus"] = {"o "}, [""] = {"ooo ", "oo "}}
}
function opponentNoteHit(id, direction, noteType, isSustainNote)
   if not isSustainNote then
      bfSing = false;
      oppTimer = 1;

      if opponentTweening then
         opponentTweening = false;
         cancelTween("removeTextOpp");
         opponentText = "";
         setProperty("opText.alpha", 1)
      end
   end

   opponentText = opponentText .. findWordsToSing(isSustainNote, noteType)

end

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

function goodNoteHit(id, direction, noteType, isSustainNote) -- noteData: 0 = Left, 1 = Down, 2 = Up, 3 = Right
   if not isSustainNote then
      bfSing = true;
      plaTimer = 1;

      if playerTweening then
         cancelTween("removeTextPla");
         playerTweening = false;
         playerText = "";
         setProperty("plText.alpha", 1)
      end
   end
   
   playerText = playerText .. findWordsToSing(isSustainNote, noteType)
   
   if goodPart then 
      loadGraphic("glowNote",  "light/" .. lightColor[direction + 1])
      setProperty("glowNote.alpha",1)
      doTweenAlpha("glowwww", "glowNote", 0 , 1)

      setProperty("timeBar.color", getColorFromHex(lightColorHex[direction + 1]))
      doTweenColor("timeGlow", "timeBar", "0xFFFFFFFF" , 1)
   end
end

function removeWordsFromOpp(force)

   opponentTweening = true;
   doTweenAlpha("removeTextOpp", "opText", 0, crochet/1000, "quadOut")

end

function removeWordsFromPla(force)

   playerTweening = true;
   doTweenAlpha("removeTextPla", "plText", 0, crochet/1000, "quadOut")
end




function onTweenCompleted(tag)
	if tag == "removeTextOpp" then 
      opponentTweening = false;
      opponentText = "";
      setProperty("opText.alpha", 1)
   end
   if tag == "removeTextPla" then 
      playerTweening = false;
      playerText = "";
      setProperty("plText.alpha", 1)
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

function lerp(a, b, t)
	return a + (b - a) * t
end

function fixDirection()
   noteCount = getProperty('notes.length');

	for i = 0, noteCount-1 do

		noteData = getPropertyFromGroup('notes', i, 'noteData')
		if getPropertyFromGroup('notes', i, 'isSustainNote') then
            if (getPropertyFromGroup('notes', i, 'mustPress')) then
                setPropertyFromGroup('notes', i, 'angle', getPropertyFromGroup("playerStrums", noteData, 'direction') - 90)
            else
				
                setPropertyFromGroup('notes', i, 'angle', getPropertyFromGroup("opponentStrums", noteData, 'direction') - 90)
            end	
		else
            if (noteData >= 4) then
                setPropertyFromGroup('notes', i, 'angle', getPropertyFromGroup("playerStrums", noteData, 'angle'))
            else
                setPropertyFromGroup('notes', i, 'angle', getPropertyFromGroup("opponentStrums", noteData, 'angle'))
            end	
		end
	end
end