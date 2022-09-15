font = "Roboto-Light.ttf"
folder = "twitter/"
camY = 367.5 
camX = 485
songStart = false
space = 100
textMax = 10
spaceBetweenTextnIcon = 75

beginningReply = 510;

opponentTargetY = 0
playerTargetY = 0

replies = {}

defaultNotes = {}

local noteArray = {
   ["1"] = {1, -1, 1, -1},
   ["2"] = {1, -1, -1, 1}
}

opponentCaps = true
enemyTextVocal = 
{
   {{"b", "a", "d"}},  -- aa
   {{"cr", "i", "nge"}}, -- ee
   {{"w", "o", "rst"}} -- oo
}
ratioTextVocal = 
{
   {{"r", "a", "tio'd +"}, {"don't c", "a", "re +"}, {"cr", "y", " about it +"}},  -- aa
   {{"d", "i", "dn't ask +"}, {"", "L", " +"}}, -- ee
   {{"l", "o", "g off +"}, {"t", "o", "uch grass +"}, {"wh", "o"," ask +"}} -- oo
}

playerTextVocal = 
{
   {{"", "a", ""}},  -- aa
   {{"", "e", ""}}, -- ee
   {{"", "o", ""}} -- oo
}

fallingComment = {}
local barsX = {}
local hudStuff = {"iconP1", "iconP2"}

opponentShake = 0
shakeAdd = 0


isVerifyAge = false;
age = 0
ageLimit = 13

defaultMiddle = false

mechanic = false
function onCreate()
   defaultMiddle = getPropertyFromClass("ClientPrefs", "middleScroll")
   setPropertyFromClass("ClientPrefs", "middleScroll", false)
end
function onDestroy()
   setPropertyFromClass("ClientPrefs", "middleScroll", defaultMiddle)
end

function onCreatePost()
   mechanic = getDataFromSave("ammarc", "mechanic")

   
   makeLuaSprite("void", "", -300 , -400)
   makeGraphic("void", 2000,2000, "000000")
   setScrollFactor("void", 0 ,0)
   addLuaSprite("void", true)

   makeLuaSprite("status", folder.."status", 250 - 70 , 40)
   setScrollFactor("status", 1 ,1)
   addLuaSprite("status", true)
   scaleObject("status", 1, 1)

   makeLuaSprite("opponentP", folder.."opponentReply", 178 , beginningReply)
   setScrollFactor("opponentP", 1 ,1)
   addLuaSprite("opponentP", true)
   scaleObject("opponentP", 1, 1)

   makeLuaText("opponentText", "", 480, 180 + spaceBetweenTextnIcon, beginningReply + 60)
   addLuaText("opponentText", true)
   setTextSize("opponentText", 16)
   setTextFont("opponentText", font)
   setTextBorder("opponentText", 0, "FFFFFF")
   setObjectCamera("opponentText", "game")
   setScrollFactor("opponentText", 0 ,0)
   setTextAlignment("opponentText", "left")

   makeLuaSprite("playerP", folder.."AmmarReply", 178 , beginningReply)
   setScrollFactor("playerP", 1 ,1)
   addLuaSprite("playerP", true)
   scaleObject("playerP", 1, 1)

   makeLuaText("playerText", "", 480, 180 + spaceBetweenTextnIcon, beginningReply + 60)
   addLuaText("playerText", true)
   setTextSize("playerText", 16)
   setTextFont("playerText", font)
   setTextBorder("playerText", 0, "FFFFFF")
   setObjectCamera("playerText", "game")
   setScrollFactor("playerText", 0 ,0)
   setTextAlignment("playerText", "left")

   barsX = {-328 - 70, 850 - 70}

   makeLuaSprite("profileBar", folder.."profileBar", barsX[1] , -40)
   setScrollFactor("profileBar", 1 ,0)
   addLuaSprite("profileBar", true)
   scaleObject("profileBar", 1, 1)

   makeLuaSprite("rightBar", folder.."rightBar", barsX[2] , -40)
   setScrollFactor("rightBar", 1 ,0)
   addLuaSprite("rightBar", true)
   scaleObject("rightBar", 1, 1)

   makeLuaSprite("redVig", folder.."redVignette", 0 , 0)
   setScrollFactor("redVig", 0 ,0)
   addLuaSprite("redVig", true)
   setObjectCamera("redVig", "hud")
   setObjectOrder("redVig", getObjectOrder("timeBarBG") - 1)
   screenCenter("redVig")
   setProperty("redVig.alpha", 0)

   makeLuaSprite("message", folder.."Message", 750 , 720) -- open 200 , close 655
   addLuaSprite("message", true)
   setObjectCamera("message", "hud")
   setObjectOrder("message", 100)
   if not mechanic then 
      setProperty('message.visible', false)
   end
  
   makeLuaSprite("ageVerify", folder.."verifyAge", 0 , 0)
   setScrollFactor("ageVerify", 0 ,0)
   addLuaSprite("ageVerify", true)
   setObjectCamera("ageVerify", "other")
   screenCenter("ageVerify")
   setProperty("ageVerify.alpha", 0)

   makeLuaText("ageText", "test", 800, 0, 0)
   addLuaText("ageText", true)
   setTextSize("ageText", 40)
   setTextBorder("ageText", 0, "000000")
   setObjectCamera("ageText", "other")
   setTextAlignment("ageText", "center")
   screenCenter("ageText")
   setProperty("ageText.y", getProperty("ageText.y") + 100)
   setProperty('ageText.alpha', 0)

   makeLuaSprite("black", "", -300 , -400)
   makeGraphic("black", 2000,2000, "000000")
   addLuaSprite("black", true)
   setObjectCamera("black", "other")
   screenCenter("black")
   setProperty("black.alpha", 0)

   setProperty("camFollowPos.y", camY)
   setProperty("camFollowPos.x", camX)

   for i = 1, #hudStuff do 
      setProperty(hudStuff[i] .. ".visible", false)
   end
  
   if mechanic then
      for a = 0, getProperty('unspawnNotes.length') - 1 do
         local strumTime = getPropertyFromGroup('unspawnNotes', a, 'strumTime');
         local noteData = getPropertyFromGroup('unspawnNotes', a, 'noteData');
         if strumTime >= 50086.94 and strumTime < 108521 and getPropertyFromGroup("unspawnNotes", a, "noteType") ~= "Hurt Note" then
            setPropertyFromGroup("unspawnNotes", a, "offsetY", -700)
            setPropertyFromGroup("unspawnNotes", a, "multAlpha", 0.1)
            if getPropertyFromGroup("unspawnNotes", a, "isSustainNote") then 
               setPropertyFromGroup("unspawnNotes", a, "offsetY", -700 + 10)
               setPropertyFromGroup("unspawnNotes", a, "multAlpha", 0.05)
            end
         end
      end
   else 
      for a = getProperty('unspawnNotes.length')-1, 0, -1  do
         if getPropertyFromGroup("unspawnNotes", a, "noteType") == "Hurt Note" then
            removeFromGroup("unspawnNotes", a, true)
         end
      end
      
   end

   setProperty("camGame.alpha", 0)

   setHealthBarColors("FF0000", "00ff00")
end

function redFlash(duration)
   setProperty("redVig.alpha", 1)
   doTweenAlpha("redFlashing", "redVig", 0, duration)
end
function onSongStart()
   for note = 0, 7 do 
      local _x = getPropertyFromGroup("strumLineNotes", note, "x")
      local _y = getPropertyFromGroup("strumLineNotes", note, "y")
      local _s = getPropertyFromGroup("strumLineNotes", note, "scale")
      table.insert( defaultNotes, {_x , _y, _x})
   end
   songStart = true

   setProperty("camGame.alpha", 1)
   ageVerify(crochet/1000*4*14, 1)
end

function getCommentsY()
   local total = 0
   total = getProperty(replies[#replies][1] .. ".y") + getProperty(replies[#replies][2] .. ".height") + space

   return total
end

function sideBarBeat(duration)
   setProperty("profileBar.x", barsX[1] + 50)
   setProperty("rightBar.x", barsX[2] - 50)

   doTweenX("SprofMove", "profileBar", barsX[1], duration, "quadOut")
   doTweenX("SrightMove", "rightBar", barsX[2], duration, "quadOut")
end


local oldMustHit = false
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

   local mustHitSec = mustHitSection
   if curBeat <= 4 then mustHitSec = false end

   local lastCommentY = beginningReply
   if #replies > 0 then
      lastCommentY = getCommentsY()
   end

   local haterY = getProperty("opponentText.height") + space
   local playerY = getProperty("playerText.height") + space
   opponentTargetY = lastCommentY + (mustHitSec and playerY or 0 )
   playerTargetY = lastCommentY + ((not mustHitSec) and haterY or 0 )
   
   setProperty("opponentP.y", lerp(getProperty("opponentP.y") , opponentTargetY, elapsed* 9))
   setProperty("playerP.y", lerp(getProperty("playerP.y") , playerTargetY, elapsed* 9))
   
   setProperty("opponentText.y", getScreenPositionY("opponentP") + 60)
   setProperty("opponentText.x", getScreenPositionX("opponentP") + spaceBetweenTextnIcon)
   setProperty("playerText.y", getScreenPositionY("playerP") + 60 )
   setProperty("playerText.x", getScreenPositionX("playerP") + spaceBetweenTextnIcon)

   if songStart then 
      if mustHitSec  then 
         camY = getProperty("playerP.y") + getProperty("playerText.height")
      else 
         camY = getProperty("opponentP.y") + getProperty("opponentText.height")
      end
      
   end

   for i = 1, #replies do 
      local spr = replies[i][1]
      local text = replies[i][2]
      setProperty(text .. ".y", getScreenPositionY(spr) + 60)
      setProperty(text .. ".x", getScreenPositionX(spr) + spaceBetweenTextnIcon)

   end

   if isVerifyAge then 
      for a = 0, getProperty('notes.length') - 1 do
         setPropertyFromGroup("notes", a, "tooLate", true)

      end
   else 
      
   end
end

function onUpdatePost(elapsed)
   opponentShake = lerp(opponentShake, 0 ,elapsed * 5)
   local doShake = opponentShake + shakeAdd
   if mechanic then
      setProperty("camGame.angle", getRandomFloat(-doShake + 0.00, (doShake + 0.00)))
      setProperty("camHUD.angle", getRandomFloat(-doShake + 0.00 / 2, (doShake + 0.00) / 2))
   end

   if mechanic then
      for a = 0, getProperty('notes.length') - 1 do
         local strumTime = getPropertyFromGroup('notes', a, 'strumTime');
         local noteData = getPropertyFromGroup('notes', a, 'noteData');
         local sus = getPropertyFromGroup('notes', a, 'isSustainNote');
         if getPropertyFromGroup("notes", a, "noteType") ~= "Hurt Note" and strumTime >= 50086.94 and strumTime < 108521 then
            if (strumTime - getSongPosition()) < 2000 / scrollSpeed then
               setPropertyFromGroup("notes", a, "offsetY", lerp(getPropertyFromGroup("notes", a, "offsetY"), 0 , elapsed * (3 * scrollSpeed)))
               setPropertyFromGroup("notes", a, "multAlpha", lerp(getPropertyFromGroup("notes", a, "multAlpha"), (sus and 0.6 or 1) , elapsed * (8 * scrollSpeed)))
            end

         end
      end
   end

   if isVerifyAge then 
      if keyJustPressed("left") then 
         age = age - 1
      elseif keyJustPressed("right") then 
         age = age + 1
      end
      if keyJustPressed("accept") then 
         verifyDone()
      end
      setTextString("ageText", "< " .. age .. " >")
   end
end

local playerCurTextArray = {}
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
   if noteType == "no Sing" then return end
   local groupText = enemyTextVocal
   if not opponentCaps then groupText = ratioTextVocal end
   local nType = noteType
   
   if voiceConvert[noteType] == nil then
      nType = singer[getRandomInt(1,3)]
   end

   local text = getTextString("opponentText")
   if not isSustainNote then
      loseHealthCarefull(0.015)
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
   else 
      loseHealthCarefull(0.015)
      if not (string.find( getPropertyFromGroup("notes",id,"animation.curAnim.name"), "end" )) then 
         text = text .. (opponentCaps and string.upper(enemyCurTextArray[2]) or enemyCurTextArray[2])
         if string.find(getPropertyFromGroup("notes", id,"nextNote.animation.curAnim.name"), "end") then
            text = text .. (opponentCaps and string.upper(enemyCurTextArray[3]) or enemyCurTextArray[3])
         end
      end

      if opponentCaps then
         opponentShake = opponentShake + 0.5
      end
   end
   setTextString("opponentText", (haterCaps and string.upper(text) or text))

end

function loseHealthCarefull(amount)
   if not mechanic then return end
   health = getProperty("health")
   health = health - amount
   if health < 0.01 then 
      health = 0.01
   end
   setHealth(health)
end

function onBeatHit()
   if curBeat == 56 then 
      doTweenAlpha("black", "black", 1, crochet/1000*6)
   end
   if curBeat == 64 then 
      shakeAdd = 1
      doTweenAlpha("black", "black", 0, 0.2)
   end
   if curBeat == 128 then 
      ageVerify(crochet/1000*4*4, 0)
   end
   if curBeat == 256 then 
      ageVerify(crochet/1000*4*4, 5)
   end
   if curBeat == 192 then 
      opponentCaps = false
      shakeAdd = 0
   end
   if curBeat == 352 then 
      ageVerify(crochet/1000*4*7, -20)
   end
   if curBeat == 416 then 
      opponentCaps = true
      shakeAdd = 0.5
      doTweenAlpha("black", "black", 1, 0.1)
   end
   if curBeat == 417 then 
      doTweenAlpha("black", "black", 0, 0.5)
   end
   if curBeat == 480 then 
      shakeAdd = 2
      setObjectOrder("redVig", getObjectOrder("message") + 5)
      ageVerify(crochet/1000*4*4, 0)
   end
   if curBeat >= 416 then 
      if curBeat % 8 == 0 then 
         doTweenY("message", "message", 400, crochet/1000*4, "bounceOut")
         doTweenAlpha("messageAA", "message", 0.8, crochet/1000*2)
      end
      if curBeat % 8 == 4 then 
         doTweenY("message", "message", 655, crochet/1000*4, "bounceOut")
         doTweenAlpha("messageAA", "message", 1, crochet/1000*2)
      end
   end
   if curBeat >= 128 and curBeat < 192 and mechanic then 
      if curBeat % 4 == 0 then 
         for note = 0, 7 do 
            setPropertyFromGroup("strumLineNotes", note, "y", defaultNotes[note + 1][2] + (noteArray["1"][(note % 4) + 1] * 40))
            setPropertyFromGroup("strumLineNotes", note, "angle", -20)
            noteTweenY("goBackY" .. note, note, defaultNotes[note + 1][2], crochet/1000*2, "quadOut")
            noteTweenAngle("goBackAngle" .. note, note, 0, crochet/1000*2, "quadOut")
         end
      end
      if curBeat % 4 == 2 then 
         for note = 0, 7 do 
            setPropertyFromGroup("strumLineNotes", note, "y", defaultNotes[note + 1][2] + (noteArray["1"][(note % 4) + 1] * -40))
            setPropertyFromGroup("strumLineNotes", note, "angle", 20)
            noteTweenY("goBackY" .. note, note, defaultNotes[note + 1][2], crochet/1000*2, "quadOut")
            noteTweenAngle("goBackAngle" .. note, note, 0, crochet/1000*2, "quadOut")
         end
      end
   end
   if (curBeat >= 64 and curBeat < 192) or (curBeat >= 256 and curBeat < 352) or (curBeat >= 416) then 
      if curBeat % 2 == 0 then
         sideBarBeat(crochet/1000*2)
         redFlash(crochet/1000*2)
      end
   end

   if (curBeat >= 192 and curBeat < 256) or (curBeat >= 352 and curBeat < 416) then 
      if curBeat % 4 == 0 then
         sideBarBeat(crochet/1000*4)
         redFlash(crochet/1000*2)
      end
   end
   if curBeat == 552 then 
      doTweenAlpha("black", "black", 1, 0.05)
   end
end

local beatMove = { -- x , y 
   {{-10, 0, 0, 10}, {0, -10, 10, 0}} ,
   {{2, 5, 10, 20}, {0, 0, 0, 0}} ,
   {{-20, -10, -5, -2}, {0, 0, 0, 0}} ,
   {{-5, 0, 0, 5}, {-20, -10, 10, 20}} ,
   {{-5, 0, 0, 5}, {20, 10, -10, -20}} ,
   {{-20, -10, 10, 20}, {0, 0, 0, 0}} ,
   {{20, 10, -10, -20}, {0, 0, 0, 0}} ,
   {{10, 0, 0, -10}, {0, 10, -10, 0}} ,
}
function onStepHit()
   if curBeat >= 250 and curBeat < 400 then -- 256 
      if curStep % 8 == 0 then 
         spawnFalling()
      end
   end

   if botPlay and isVerifyAge then 
      age = age + 1
      if age > ageLimit then 
         verifyDone()
      end
   end

   if (curStep >= 512 and curStep < 768) or (curStep >= 1024 and curStep < 1408) or (curStep >= 1920) then 
      spawnParticle()
   end

   if curStep >= 896 and curStep < 1408 and mechanic then 
      if curStep % 4 == 0 or curStep % 64 == 26 or curStep % 64 == 27 or curStep % 64 == 26 or curStep % 64 == 30 or curStep % 64 == (48 + 2) or curStep % 64 == (48 + 6)
      or curStep % 64 == (48 + 7) or curStep % 64 == (48 + 14)
       then
         triggerEvent('Add Camera Zoom', "0.05", "0.025")
         for note = 0,7 do 
            local _xP = beatMove[(curStep%8) + 1][1][(note % 4) + 1] * 4
            local _yP = beatMove[(curStep%8) + 1][2][(note % 4) + 1] * 4
            setPropertyFromGroup("strumLineNotes", note, "x", defaultNotes[note + 1][1] + _xP)
            setPropertyFromGroup("strumLineNotes", note, "y", defaultNotes[note + 1][2] + _yP)

            noteTweenX("goBackX"..note, note, defaultNotes[note + 1][1], crochet/1000, "quadOut")
            noteTweenY("goBackY"..note, note, defaultNotes[note + 1][2], crochet/1000, "quadOut")
         end
      end
   end
   if curStep >= 1920 and curStep < 2176 and mechanic then 
      if curStep % 16 == 0 or curStep % 64 == 4 or curStep % 64 == 10 or curStep % 64 == 12 or curStep % 64 == (16 + 2) or curStep % 64 == (16 + 4) or curStep % 64 == (16 + 6) or curStep % 64 == (16 + 7)
      or curStep % 64 == (16 + 8) or curStep % 64 == (16 + 10) or curStep % 64 == (16 + 12) or curStep % 64 == (16 + 14) or curStep % 64 == (32 + 2) or curStep % 64 == (32 + 3) or curStep % 64 == (32 + 4)
      or curStep % 64 == (32 + 6) or curStep % 64 == (32 + 8) or curStep % 64 == (32 + 10) or curStep % 64 == (32 + 12) or curStep % 64 == (32 + 14) or curStep % 64 == (48 + 2) or curStep % 64 == (48 + 4)
      or curStep % 64 == (48 + 6) or curStep % 64 == (48 + 7) or curStep % 64 == (48 + 8) or curStep % 64 == (48 + 10) or curStep % 64 == (48 + 12) or curStep % 64 == (48 + 14) or curStep % 64 == (48 + 15)
      then
         triggerEvent('Add Camera Zoom', "0.06", "0.025")
         for note = 0,7 do 
            local _xP = beatMove[(curStep%8) + 1][1][(note % 4) + 1] * 4
            local _yP = beatMove[(curStep%8) + 1][2][(note % 4) + 1] * 4
            setPropertyFromGroup("strumLineNotes", note, "x", defaultNotes[note + 1][1] + _xP)
            setPropertyFromGroup("strumLineNotes", note, "y", defaultNotes[note + 1][2] + _yP)
            setPropertyFromGroup("strumLineNotes", note, "angle", 10 * (((curStep%4) <= 1) and -1 or 1))

            noteTweenX("goBackX"..note, note, defaultNotes[note + 1][1], crochet/1000*0.7, "quadOut")
            noteTweenY("goBackY"..note, note, defaultNotes[note + 1][2], crochet/1000*0.7, "quadOut")
            noteTweenAngle("goBackAb"..note, note, 0, crochet/1000*0.7, "quadOut")
         end
      end
   end
end

local maxNum = 5
function spawnFalling()
   if not mechanic then return end
   local tag = "fallingOpponent".. #fallingComment
   local image = folder.."fallingComment/".. getRandomInt(1, maxNum)

   local randomX = math.sin(getSongPosition() * 10)*800 + 720
   makeLuaSprite(tag, image, randomX , -200)
   setObjectCamera(tag, "hud")
   addLuaSprite(tag, true)
   local scale = getRandomFloat(0.8, 1.2)
   scaleObject(tag, scale, scale)
   setProperty(tag .. ".angle", getRandomFloat(-40, 40))
   setProperty(tag .. ".alpha", getRandomFloat(0.60, 1.00))

   local dur = getRandomFloat(5, 12) * scale
   doTweenY(tag, tag, 900, dur)
   doTweenAngle("spin"..tag, tag, getRandomFloat(-40, 40), dur)
   table.insert( fallingComment, tag )
end


local parti = 0
function spawnParticle()
   parti = parti + 1
   local tag = "redParticle"..parti

   makeLuaSprite(tag, folder.."redParticle", getRandomFloat(-100, 1380) ,720)
   setObjectCamera(tag, "hud")
   addLuaSprite(tag, true)
   local scale = getRandomFloat(1, 1.2)
   scaleObject(tag, scale, scale)
   
   local dur = getRandomFloat(3, 8)
   doTweenY(tag, tag, getRandomFloat(780, 500), dur)
   doTweenAlpha("alphating"..parti, tag, 0, dur)
end

function onTweenCompleted(tag)
	if string.find( tag,  "falling") and not string.find( tag,  "spin") then 
      removeLuaSprite(tag)
   end
   if string.find( tag,  "redParticle") then 
      removeLuaSprite(tag)
   end
end

function onTimerCompleted(tag, loops, loopsLeft)
   if tag == "verifyEnd" then verifyDone() end
end


function ageVerify(timer, _age)
   if not mechanic then return end
   runTimer("verifyEnd", timer)
   isVerifyAge = true
   age = _age

   setProperty('canPause', false)
   doTweenAlpha("verify", "ageVerify", 0.8, 1, "bounceOut")
   doTweenAlpha("verify2", "ageText", 1, 1, "bounceOut")
end

function verifyDone()
   if isVerifyAge then 
      isVerifyAge = false
      cancelTimer("verifyEnd")
      setProperty('canPause', true)
      if age < ageLimit then 
         opponentShake = opponentShake + 3
         cameraFlash("hud", "FF0000", 2, true)
         addHealth(-1.5)
      else 
         --cameraFlash("hud", "00FF00", 0.5, true)
      end
      for a = 0, getProperty('notes.length') - 1 do
         setPropertyFromGroup("notes", a, "tooLate", false)
      end
      doTweenAlpha("verify", "ageVerify", 0, 0.2, "bounceIn")
      doTweenAlpha("verify2", "ageText", 0, 0.2, "bounceIn")
   end
end

function send(isOpponent)
   --debugPrint("send " .. (isOpponent and "dad" or "player"))
   local alpha = 1
   
   if not isOpponent and getProperty("opponentText.text.length") > 1 then 
      local text = getTextString("opponentText")
      local number = #replies + 1
      local _x = getProperty("opponentP.x")
      local _y = opponentTargetY
      local tx = getProperty("opponentText.x")
      local ty = getProperty("opponentText.y")
      local theight = getProperty("opponentText.height")

      local spriteTag = "opponentF"..number
      local textTag = "opponentFText"..number
      local infoTag = "opponentFInfo"..number

      makeLuaSprite(spriteTag, folder.."opponentReply", _x , _y)
      setScrollFactor(spriteTag, 1 ,1)
      addLuaSprite(spriteTag, true)
      scaleObject(spriteTag, 1, 1)
   
      makeLuaText(textTag, text, 480, tx, ty)
      addLuaText(textTag, true)
      setTextSize(textTag, 16)
      setTextFont(textTag, font)
      setTextBorder(textTag, 0, "FFFFFF")
      setObjectCamera(textTag, "game")
      setScrollFactor(textTag, 0 ,0)
      setTextAlignment(textTag, "left")

      makeLuaSprite(infoTag, folder.."infoBar", _x + 70, _y + theight + 62)
      setScrollFactor(infoTag, 1 ,1)
      addLuaSprite(infoTag, true)
      scaleObject(infoTag, 1, 1)


      table.insert( replies, {spriteTag, textTag, infoTag} )
      setTextString("opponentText", "")

      setObjectOrder(spriteTag, getObjectOrder("status") + 1)
      setObjectOrder(textTag, getObjectOrder("status") + 1)
      setObjectOrder(infoTag, getObjectOrder("status") + 1)

      
   end
   if isOpponent and getProperty("playerText.text.length") > 1 then 
      local text = getTextString("playerText")
      local number = #replies + 1
      local _x = getProperty("playerP.x")
      local _y = playerTargetY
      local tx = getProperty("playerText.x")
      local ty = getProperty("playerText.y")
      local theight = getProperty("playerText.height")

      local spriteTag = "playerF"..number
      local textTag = "playerFText"..number
      local infoTag = "playerFInfo"..number

      makeLuaSprite(spriteTag, folder.."AmmarReply", _x , _y)
      setScrollFactor(spriteTag, 1 ,1)
      addLuaSprite(spriteTag, true)
      scaleObject(spriteTag, 1, 1)
   
      makeLuaText(textTag, text, 480, tx, ty)
      addLuaText(textTag, true)
      setTextSize(textTag, 16)
      setTextFont(textTag, font)
      setTextBorder(textTag, 0, "FFFFFF")
      setObjectCamera(textTag, "game")
      setScrollFactor(textTag, 0 ,0)
      setTextAlignment(textTag, "left")

      makeLuaSprite(infoTag, folder.."infoBar", _x + 70, _y + theight + 62)
      setScrollFactor(infoTag, 1 ,1)
      addLuaSprite(infoTag, true)
      scaleObject(infoTag, 1, 1)

      table.insert( replies, {spriteTag, textTag, infoTag} )
      setTextString("playerText", "")

      setObjectOrder(spriteTag, getObjectOrder("status") + 1)
      setObjectOrder(textTag, getObjectOrder("status") + 1)
      setObjectOrder(infoTag, getObjectOrder("status") + 1)
   end

   
end

function lerp(a, b, t) return a + (b - a) * t end