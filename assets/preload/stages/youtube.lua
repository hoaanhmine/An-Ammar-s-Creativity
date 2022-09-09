font = "Roboto-Light.ttf"
folder = "youtube/"
camY = 559 
camX = 877.5
songStart = false
space = 65
textMax = 10
spaceBetweenTextnIcon = 45
beatTimed = 2

haterClone = {}
playerClone = {}
comments = {}
local oldMustHit = false
textParticle = {}
txtparticleRandom = 0 -- ?/100
partTexts = {
   "Hate",
   "Dislike",
   "Low Effort",
   "Stinky",
   "Bad"
}

targetHaterY = 0
targetPlayerY = 0
targetVideosBarX = 1400
targetVideosBarY = 1340;
lightMode = false

haterCaps = false;
videosSide = {}



local hudStuff = {"iconP1", "iconP2", "healthBar", "healthBarBG"}
shaker = 0
shakeAdd = 0;

enemyTextVocal = 
{
   {{"b", "a", "d"}, {"f", "a", "ke"}, {"f", "a", "thead"}},  -- aa
   {{"st", "i", "nky"}, {"terr", "i", "ble"}, {"d", "i", "slike"}}, -- ee
   {{"st", "u", "pid"}, {"w", "o", "rst"}, {"no", "o", "b"}} -- oo
}

playerTextVocal = 
{
   {{"wh", "y", ""}},  -- aa
   {{"pl", "e", "ase"}, {"r", "e", "al"}}, -- ee
   {{"st", "o", "p"}, {"n", "o", ""}} -- oo
}
local mechanic = false
function onCreatePost()

   mechanic = getDataFromSave("ammarc", "mechanic")

   

   precacheImage("NOTE_Low")
   precacheImage(folder .. "HaterMD")
   precacheImage(folder .. "PlayerMD")
   precacheImage(folder .. "commentInfoD")

   setProperty("camGame.zoom", 2)


   setProperty("camZooming", true)
   setProperty("defaultCamZoom", 0.7)

   makeLuaSprite("void", "", -300 , -400)
   makeGraphic("void", 2000,2000, "181818")
   setScrollFactor("void", 0 ,0)
   addLuaSprite("void", true)

   makeLuaSprite("background", folder.."youtubeBG", -50 , 40)
   setScrollFactor("background", 1 ,1)
   addLuaSprite("background", true)
   scaleObject("background", 1, 1)

   makeLuaSprite("firstComment", folder.."HaterComment", 20 , 1250)
   setScrollFactor("firstComment", 1 ,1)
   addLuaSprite("firstComment", true)
   scaleObject("firstComment", 1, 1)

   makeLuaSprite("hater", folder.."HaterM", 90 , 1340)
   setScrollFactor("hater", 1 ,1)
   addLuaSprite("hater", true)
   scaleObject("hater", 0.105, 0.105)

   makeLuaSprite("player", folder.."AmmarM", 90 , 1400)
   setScrollFactor("player", 1 ,1)
   addLuaSprite("player", true)
   scaleObject("player", 0.105, 0.105)

   makeLuaText("haterText", "", 800, 0, 600)
   addLuaText("haterText", true)
   setTextSize("haterText", 16)
   setTextFont("haterText", font)
   setTextBorder("haterText", 0, "FFFFFF")
   setObjectCamera("haterText", "game")
   setScrollFactor("haterText", 0 ,0)
   setTextAlignment("haterText", "left")

   makeLuaText("playerText", "", 800, 0, 600)
   addLuaText("playerText", true)
   setTextSize("playerText", 16)
   setTextFont("playerText", font)
   setTextBorder("playerText", 0, "FFFFFF")
   setObjectCamera("playerText", "game")
   setScrollFactor("playerText", 0 ,0)
   setTextAlignment("playerText", "left")

   makeLuaSprite("redGlow", folder.."redGlow", 0 , 0)
   setScrollFactor("redGlow", 1 ,1)
   addLuaSprite("redGlow", true)
   setObjectCamera("redGlow", "hud")
   screenCenter("redGlow")
   setObjectOrder("redGlow", 0)
   setProperty("redGlow.alpha", 0)

   makeLuaSprite("loading", folder.."loading", 0 , 0)
   setScrollFactor("loading", 0 ,0)
   scaleObject("loading", 0.7, 0.7)
   setObjectCamera("loading", "hud")
   screenCenter("loading")
   addLuaSprite("loading", true)
   setProperty("loading.alpha", 0)

   makeLuaSprite("redFlash", "", 0 , 0)
   makeGraphic("redFlash", 2000,2000, "FF0000")
   setObjectCamera("redFlash", "hud")
   screenCenter("redFlash")
   addLuaSprite("redFlash", true)
   setObjectOrder("redFlash", 100)
   setProperty("redFlash.alpha", 0)

   makeLuaSprite("hackerComment", folder.."HACKER", 0 , 0)
   addLuaSprite("hackerComment", true)
   scaleObject("hackerComment", 0.6, 0.6)
   setObjectCamera("hackerComment", "hud")
   screenCenter("hackerComment")
   setProperty("hackerComment.alpha", 0)

   makeLuaSprite("error", folder.."videoNo", 0 ,0)
   addLuaSprite("error", true)
   setProperty("error.visible", false)
   setObjectCamera("error", "other")
   screenCenter("error")


   for i = 1, 70 do
      createSideVideo()
   end

   for i = 1, #hudStuff do 
      setProperty(hudStuff[i] .. ".visible", false)
   end
   
   changeSkinLow(true)
   changeSkinLow(false)
   setGraphicSize("timeBar", 1280, 20)
   screenCenter("timeBar")
   setProperty("timeBar.y", 700)
   setProperty("timeTxt.visible" , false)
   setProperty("timeBarBG.visible" , false)
   setProperty("timeBar.color", getColorFromHex("FF0000"))
   setProperty("timeBar.numDivisions", 200)
   setProperty("scoreTxt.y", 680)

   if mechanic then
      disNoteIsLow(39651, 56346)
      disNoteIsLow(89738, 106433)
      disNoteIsLow(156520, 173216)
   end

   
end

function changeSkinLow(enable)
   if not mechanic then return end
   if enable then 
      for strum= 0, 7 do 
         setPropertyFromGroup("strumLineNotes", strum, "texture", "NOTE_Low")
      end
   else
      for strum= 0, 7 do 
         setPropertyFromGroup("strumLineNotes", strum, "texture", "NOTE_assets")
      end
   end
end
function onUpdate(elapsed)
   if not oldMustHit and mustHitSection then 
      oldMustHit = true
      send(false)
   end

   if oldMustHit and not mustHitSection then 
      oldMustHit = false
      send(true)
   end

   setProperty("isCameraOnForcedPos", true)
   setProperty("camFollow.y", camY)
   setProperty("camFollow.x", camX)
   local lastCommentY = 1340
   if #comments > 0 then
      lastCommentY = getCommentsY()
   end

   local mustHitSec = mustHitSection
   if curBeat <= 4 then mustHitSec = true end

   local haterY = getProperty("haterText.height") + space
   local playerY = getProperty("playerText.height") + space
   targetHaterY = lastCommentY + (mustHitSec and playerY or 0 )
   targetPlayerY = lastCommentY + ((not mustHitSec) and haterY or 0 )
   setProperty("hater.y", lerp(getProperty("hater.y") , targetHaterY, elapsed* 9))
   setProperty("player.y", lerp(getProperty("player.y") , targetPlayerY, elapsed* 9))
   setProperty("haterText.y", getScreenPositionY("hater") + 15)
   setProperty("haterText.x", getScreenPositionX("hater") + spaceBetweenTextnIcon)
   setProperty("playerText.y", getScreenPositionY("player") + 15 )
   setProperty("playerText.x", getScreenPositionX("player") + spaceBetweenTextnIcon)

   if songStart then 
      if mustHitSec  then 
         camY = getProperty("player.y")
      else 
         camY = getProperty("hater.y")
      end
      
   end

   for i = 1, #comments do 
      local spr = comments[i][1]
      local text = comments[i][2]
      local info = comments[i][3]
      setProperty(text .. ".y", getScreenPositionY(spr) + 15)
      setProperty(text .. ".x", getScreenPositionX(spr) + spaceBetweenTextnIcon)

   end

   if #comments > textMax and false then 
      local index = 1
      local spr = comments[index][1]
      local text = comments[index][2]
      table.remove( comments, index )
      removeLuaSprite(spr)
      removeLuaText(text)
   
   end

   for i = 1, #videosSide do 
      local spr = videosSide[i][1]
      setProperty(spr .. ".x", targetVideosBarX)

   end

   if curStep >= 320 and curStep < 352 then 
      targetVideosBarX = lerp(targetVideosBarX, 1000, elapsed * 5)
   end
end

function doLoad(duration)
   setProperty("loading.alpha", 1)
   runTimer("loadEnd", duration)
end
function onUpdatePost(elapsed)
   shaker = lerp(shaker, 0 ,elapsed * 5)
   local doShake = shaker + shakeAdd
   if mechanic then
      setProperty("camGame.angle", getRandomFloat(-doShake + 0.00, (doShake + 0.00)))
      setProperty("camHUD.angle", getRandomFloat(-doShake + 0.00 / 2, (doShake + 0.00) / 2))
   end

   setProperty("loading.angle", getProperty("loading.angle") + elapsed * 400)
end
function getCommentsY()
   local total = 0
   total = getProperty(comments[#comments][1] .. ".y") + getProperty(comments[#comments][2] .. ".height") + space

   return total
end

function onSongStart()
   
   camY = 1300
   camX = 600
   setProperty("defaultCamZoom", 1)
   songStart = true

   setTextString("playerText", " no u")
end

function send(isOpponent)
   --debugPrint("send " .. (isOpponent and "dad" or "player"))
   local alpha = 1
   
   local lightName = (lightMode and "D" or "")
   if not isOpponent and getProperty("haterText.text.length") > 0 then 
      local text = getTextString("haterText")
      local number = #comments + 1
      local haterX = getProperty("hater.x")
      local haterY = targetHaterY
      local haterTextX = getProperty("haterText.x")
      local haterTextY = getProperty("haterText.y")
      local haterTextHeight = getProperty("haterText.height")

      local spriteTag = "haterF"..number
      local textTag = "haterFText"..number
      local infoTag = "haterFInfo"..number
      makeLuaSprite(spriteTag, folder.."HaterM" .. lightName, haterX , haterY)
      setScrollFactor(spriteTag, 1 ,1)
      scaleObject(spriteTag, 0.105, 0.105)

      makeLuaText(textTag, text, 800, haterTextX, haterTextY)
      setTextSize(textTag, 16)
      setTextFont(textTag, font)
      setTextBorder(textTag, 0, "000000")
      setObjectCamera(textTag, "game")
      setScrollFactor(textTag, 0 ,0)
      setTextAlignment(textTag, "left")


      makeLuaSprite(infoTag, folder.."commentInfo" ..lightName, haterX + 51, haterY + haterTextHeight + 25)
      setScrollFactor(infoTag, 1 ,1)
      scaleObject(infoTag, 0.15, 0.15)

      addLuaSprite(spriteTag, true)
      addLuaText(textTag, true)
      addLuaSprite(infoTag, true)

      setProperty(spriteTag .. ".alpha", alpha)
      setProperty(textTag .. ".alpha", alpha)
      setProperty(infoTag .. ".alpha", alpha)

      table.insert( comments, {spriteTag, textTag, infoTag} )
      setTextString("haterText", "")

      setObjectOrder(spriteTag, getObjectOrder("background") + 5)
      setObjectOrder(textTag, getObjectOrder("background") + 5)
      setObjectOrder(infoTag, getObjectOrder("background") + 10)

      if lightMode then 
         setTextColor(textTag, "000000")
      end

   end
   if isOpponent and getProperty("playerText.text.length") > 0 then 
      local text = getTextString("playerText")
      local number = #comments
      local playerX = getProperty("player.x")
      local playerY = targetPlayerY
      local playerTextX = getProperty("playerText.x")
      local playerTextY = getProperty("playerText.y")
      local playerTextHeight = getProperty("playerText.height")
      
      local spriteTag = "playerF"..number
      local textTag = "playerFText"..number
      local infoTag = "playerFInfo"..number
      makeLuaSprite(spriteTag, folder.."AmmarM" .. lightName, playerX , playerY)
      setScrollFactor(spriteTag, 1 ,1)
      addLuaSprite(spriteTag, true)
      scaleObject(spriteTag, 0.105, 0.105)

      makeLuaText(textTag, text, 800, playerTextX, playerTextY)
      addLuaText(textTag, true)
      setTextSize(textTag, 16)
      setTextFont(textTag, font)
      setTextBorder(textTag, 0, "000000")
      setObjectCamera(textTag, "game")
      setScrollFactor(textTag, 0 ,0)
      setTextAlignment(textTag, "left")

      makeLuaSprite(infoTag, folder.."commentInfo".. lightName, playerX + 51, playerY + playerTextHeight + 25)
      setScrollFactor(infoTag, 1 ,1)
      scaleObject(infoTag, 0.15, 0.15)

      addLuaSprite(spriteTag, true)
      addLuaText(textTag, true)
      addLuaSprite(infoTag, true)

      setProperty(spriteTag .. ".alpha", alpha)
      setProperty(textTag .. ".alpha", alpha)
      setProperty(infoTag .. ".alpha", alpha)

      table.insert( comments, {spriteTag, textTag, infoTag} )
      setTextString("playerText", "")

      setObjectOrder(spriteTag, getObjectOrder("background") + 5)
      setObjectOrder(textTag, getObjectOrder("background") + 5)
      setObjectOrder(infoTag, getObjectOrder("background") + 10)

      if lightMode then 
         setTextColor(textTag, "000000")
      end
   end

   
end

function glowBeat(alpha, duration)
   setProperty("redGlow.alpha", alpha)
   doTweenAlpha("glowBeating", "redGlow", 0, duration)
end

local voiceConvert = {
   ["aaa Sing"] = 1,
   ["eee Sing"] = 2,
   ["ooo Sing"] = 3
}

local playerCurTextArray = {}
local singer = {"aaa Sing", "eee Sing", "ooo Sing"}
function goodNoteHit(id, direction, noteType, isSustainNote)
   local nType = noteType
   if voiceConvert[noteType] == nil then
      nType = singer[getRandomInt(1,3)]
   end
   local text = getTextString("playerText")
   if not isSustainNote then
      
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
   setTextString("playerText", text)

end

local enemyCurTextArray = {}
function opponentNoteHit(id, direction, noteType, isSustainNote)
   local nType = noteType
   if voiceConvert[noteType] == nil then
      nType = singer[getRandomInt(1,3)]
   end

   local text = getTextString("haterText")
   if not isSustainNote then
      
      local vocal = enemyTextVocal[voiceConvert[nType]]
      local randomNum = getRandomInt(1, #enemyTextVocal[voiceConvert[nType]])
      enemyCurTextArray = vocal[randomNum]

      text = text .. " " .. enemyCurTextArray[1]

      if not getPropertyFromGroup("notes", id,"nextNote.isSustainNote") then 
         text = text .. enemyCurTextArray[2] .. enemyCurTextArray[3]
         if haterCaps then 
            if getRandomBool(30) then 
               text = text .. "!!!" .. " "
            end
         end
      end

      if haterCaps then 
         shaker = shaker + 1.5 
         triggerEvent("Add Camera Zoom", 0.015, 0.009)
      end
   else 
      if not (string.find( getPropertyFromGroup("notes",id,"animation.curAnim.name"), "end" )) then 
         text = text .. enemyCurTextArray[2]
         if string.find(getPropertyFromGroup("notes", id,"nextNote.animation.curAnim.name"), "end") then
            text = text .. enemyCurTextArray[3]
            if haterCaps then 
               if getRandomBool(30) then 
                  text = text .. "!!!" .. " "
               end
            end
         end
      end

      if haterCaps then shaker = shaker + 0.3 end
   end
   setTextString("haterText", (haterCaps and string.upper(text) or text))

end

local maxVideoImage = 18
local exludeArray = {}
function createSideVideo()

   local tag = "thumbnail" ..#videosSide
   local theY = targetVideosBarY
   local randomNumber = getRandomInt(1, maxVideoImage, table.concat( exludeArray, ", "))
   local image = folder .. "thumbnails/thumb" .. randomNumber
   local exludeNum = tostring(randomNumber)
   table.insert( exludeArray, exludeNum )
   if #videosSide > 0 then 
      theY = getProperty(videosSide[#videosSide][1] .. ".y") + getProperty(videosSide[#videosSide][1] .. ".height") + 10
   end
   local sizeX = math.floor(168 * 1.3)
   local sizeY = math.floor(94 * 1.3)

   makeLuaSprite(tag, image, targetVideosBarX , theY)
   setGraphicSize(tag, sizeX, sizeY, true)
   setProperty(tag.. '.y', theY)
   setScrollFactor(tag, 1 ,1)
   addLuaSprite(tag, true)

   local offsetX = getProperty(tag .. ".offset.x")

   table.insert( videosSide, {tag, offsetX} )

   if #exludeArray > 4 then 
      table.remove(exludeArray, 1)
   end
end

function onBeatHit()

   --[[
   if curBeat % beatTimed == 0 then
      for i = 1, #videosSide do 
         local beatI = i + (curBeat % (beatTimed*2) == beatTimed and 1 or 0)
         local spr = videosSide[i][1]
         local offsetX = videosSide[i][2]

         local dur = crochet/1000 * beatTimed
         if beatI % 2 == 0 then
            setProperty(spr .. ".offset.x", offsetX + 40)
         else 
            setProperty(spr .. ".offset.x", offsetX - 40)
         end
         doTweenX("bakToScaleX" .. i, spr ..  ".offset", offsetX, dur,"quadOut")
         doTweenY("bakToScaleY" .. i, spr .. ".offset", offsetX, dur,"quadOut")
      end
   end
   ]]

   if curBeat == 152 then 
      beatTimed = 1
      changeSkinLow(true) 
      doLoad(2)
   end
   if curBeat == 216 then 
      changeSkinLow(false)
      doLoad(1)
   end
   if curBeat == 344 then 
      changeSkinLow(true) 
      doLoad(1)
   end
   if curBeat == 408 then 
      beatTimed = 4
      changeSkinLow(false)
      doLoad(0.5)
   end
   if curBeat == 472 then 
      beatTimed = 2
   end
   if curBeat == 532 then 
      doTweenAlpha("comment", "hackerComment", 1, crochet/1000/4)
      shaker = 10
      triggerEvent("Add Camera Zoom", 0.05, 0.04)
      shakeAdd = 0.3
   end
   if curBeat == 534 then 
      doTweenAlpha("comment", "hackerComment", 0, crochet/1000 * 2)
   end
   if curBeat == 536 then 
      beatTimed = 1
      loadGraphic("hater", folder.."HaterMD")
      loadGraphic("player", folder.."AmmarMD")
      makeGraphic("void", 2000,2000, "FFFFFF")
      lightMode = true

      setTextColor("playerText", "000000")
      setTextColor("haterText", "000000")
      for i = 1, #comments do 
         local spr = comments[i][1]
         local text = comments[i][2]
         local info = comments[i][3]
         loadGraphic(info, folder.."commentInfoD")

         setTextBorder(text, 0, "000000")
      end

      setTextBorder("playerText", 0, "000000")
      setTextBorder("haterText", 0, "000000")
      haterCaps = true
      txtparticleRandom = 50
   end
   if curBeat == 600 then 
      changeSkinLow(true)
      doLoad(3)
      txtparticleRandom = 80
   end
   if curBeat == 664 then 
      beatTimed = 2
      changeSkinLow(false)
      doLoad(0.5)
      shakeAdd = 0.5
   end

   if curBeat >= 536 and curBeat < 664 then 
      triggerEvent("Add Camera Zoom", "", "")
      if curBeat >= 600 then 
         setProperty("redFlash.alpha", 0.4)
         doTweenAlpha("redFlash", "redFlash", 0 , crochet/1000)
         for i = 1, #videosSide do 
            local spr = videosSide[i][1]
            doTweenColor("goRed", spr, "FF0000", 0)
            doTweenColor("goBackN", spr, "FFFFFF" , crochet/1000)
         end
      end
   end
   if curBeat == 728 then 
      cameraFlash("other", "FFFFFF", 2, true)
      setProperty("error.visible", true)
   end
end

function disNoteIsLow(min, max)
   for note = 0, getProperty("unspawnNotes.length")-1 do 
      if getPropertyFromGroup("unspawnNotes", note, "strumTime") >= min and getPropertyFromGroup("unspawnNotes", note, "strumTime") <= max then 
         setPropertyFromGroup("unspawnNotes", note, "texture", "NOTE_Low")
      end
   end
end

function createTextParticle(text)

   local tag = "particleTxt" .. #textParticle
   makeLuaText(tag, text, 300, getProperty("redGlow.x"), getProperty("redGlow.y"))
   addLuaText(tag, true)
   setTextSize(tag, 50)
   setTextBorder(tag, 1, "8f0a00") 
   setTextColor(tag, "8f0a00")
   setObjectCamera(tag, "hud")
   setScrollFactor(tag, 0 ,0)
   setTextAlignment(tag, "center")
   setObjectOrder(getObjectOrder("redGlow") + 1)

   setProperty(tag .. ".x" , getRandomFloat(getProperty("redGlow.x") - 100, getProperty("redGlow.x") + getProperty("redGlow.width") - 50))
   setProperty(tag .. ".y" , getProperty("redGlow.y") + getProperty("redGlow.height") - 10)

   table.insert( textParticle, tag )

   local duration = getRandomFloat(1, 5)
   doTweenAlpha(tag, tag, 0, duration)
   doTweenX(tag .. "X", tag, getProperty(tag .. ".x") + getRandomFloat(-20, 20), duration)
   doTweenY(tag .. "Y", tag, getProperty(tag .. ".y") - getRandomFloat(100, 250), duration)
   doTweenAngle(tag .. "A", tag, getRandomFloat(-10, 10), duration)
end

function onStepHit()
   section = math.floor(curStep / 16)
   if (section >= 20 and section < 36) or (section >= 38 and section < 102) or (section >= 134 and section < 166)then 
      if curStep % 4 == 0 then 
         if curBeat >= 536 then 
            glowBeat(0.8, crochet/1000)
         else
            glowBeat(0.4, crochet/1000)
         end
      end
   end

   if getRandomBool(txtparticleRandom) and mechanic then 
      createTextParticle(partTexts[getRandomInt(1, #partTexts)])
   end

   if curStep % 2 == 0 then
      for i = 1, #videosSide do 
         local beatI = i
         local spr = videosSide[i][1]
         local offsetX = videosSide[i][2]

         local dur = crochet/1000 /2 * beatTimed
         if curStep % (4 * beatTimed) == 0 then
            doTweenX("bakToScaleX" .. i, spr ..  ".offset", offsetX, dur,"quadIn")
            local tim = 1
            if i % 2 == 0 then tim = tim * -1 end
            if curStep % (4 * beatTimed * 2) ~= ((2 * beatTimed * 2)) then tim = tim * -1 end
            setProperty(spr.. ".angle", -14*tim)
            doTweenAngle("GoAove" .. i, spr, 0, dur,"quadOut")
         elseif curStep % (4 * beatTimed) == (2 * beatTimed) then -- 8 == 4
            local tim = 1
            if i % 2 == 0 then tim = tim * -1 end
            if curStep % (4 * beatTimed * 2) ~= ((2 * beatTimed * 2) + (2 * beatTimed)) then tim = tim * -1 end
            doTweenX("GoMove" .. i, spr ..  ".offset", offsetX + 30 * tim, dur,"linear")
           
         end


      end
   end
end

function onTimerCompleted(t)
	if t == 'loadEnd' then
      setProperty("loading.alpha", 0)
   end

end

function onTweenCompleted(tag)
	if string.find(tag , "particleTxt" ) then 
      removeLuaText(tag)
   end
end


function lerp(a, b, t) return a + (b - a) * t end
