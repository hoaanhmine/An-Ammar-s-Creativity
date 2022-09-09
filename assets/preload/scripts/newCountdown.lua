function onCountdownTick(counter)
   if counter == 1 then  --countdownReady
      setObjectCamera("countdownReady", "other")

      setProperty("countdownReady.y", 500)
      scaleObject("countdownReady", 0.5, 0.5)
      screenCenter("countdownReady", "X")
   end
   if counter == 2 then --countdownSet
      setObjectCamera("countdownSet", "other")

      setProperty("countdownSet.y", 500)
      scaleObject("countdownSet", 0.5, 0.5)
      screenCenter("countdownSet", "X")
   end
   if counter == 3 then --countdownGo
      setObjectCamera("countdownGo", "other")

      setProperty("countdownGo.y", 460)
      scaleObject("countdownGo", 0.6, 0.6)
      screenCenter("countdownGo", "X")
   end
end
