local textTargetPosX = 0
local logoTargetPosX = 0

local folder = "intro/"

logoName = ""
songs = {
   ["discord annoyer"] = "discord",
   ["shut up"] = "discord",
   ["hate comment"] = "youtube",
   ["twitter argument"] = "twitter"
}

function onCreatePost()
   if string.lower(songName:gsub( "-", " ")) == "ammar menu" then return end
  
   logoName = songs[string.lower(songName:gsub( "-", " "))]
   
   makeLuaSprite("logo", folder .. logoName ,0,0)
   scaleObject("logo", 0.6, 0.6)
   setObjectCamera("logo", 'hud')
   addLuaSprite("logo")
   screenCenter("logo")
   

   makeLuaText("title", songName:gsub( "-", " ") , 500 ,0,0)
   setTextSize("title", 64)
   setObjectCamera("title", 'hud')
   setTextFont("title", "1_Minecraft-Regular.otf")
   setTextAlignment("title", "center")
   addLuaText("title")
   setTextBorder("title", 4, "000000")
   screenCenter("title")

   setProperty("logo.alpha", 0)
   setProperty("title.alpha", 0)
   
   textTargetPosX = getProperty("title.x")
   logoTargetPosX = getProperty("logo.x")

   setProperty("title.x", 1600)
   setProperty("title.angle", 90)
   setProperty("logo.x", 1600)
   
end

eaaa = 0
function onUpdatePost(elapsed)
   eaaa = eaaa + elapsed
   setProperty("logo.angle", math.sin(eaaa*3) * 10)
end

function onCountdownTick(counter)
   if counter == 0 then 
      if string.lower(songName:gsub( "-", " ")) ~= "ammar menu" then
         local dur = 0.7
         doTweenX("introT", "title", textTargetPosX, dur, "quadOut")
         doTweenX("introL", "logo", logoTargetPosX, dur, "quadOut")
         doTweenAlpha("introTA", "title", 1, dur)
         doTweenAlpha("introLA", "logo", 1, dur)
         doTweenAngle("introTR", "title", 0, dur, "quadOut")
         runTimer("endIntro", 2)
         
      end
   end
end


function onTimerCompleted(tag, loops, loopsLeft)
   if tag == "endIntro" then
      local dur = 0.7
      doTweenX("introT", "title", -500, dur, "quadIn")
      doTweenX("introL", "logo", -500, dur, "quadIn")
      doTweenAlpha("introTA", "title", 0, dur)
      doTweenAlpha("introLA", "logo", 0, dur)
      doTweenAngle("introTR", "title", -30, dur, "quadIn")
   end
end
