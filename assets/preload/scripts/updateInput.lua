sick = 0
good = 0
bad = 0
worst = 0

function onUpdatePost(elapsed)
   if sick ~= getProperty("sicks") then
      sick = getProperty("sicks")
      combo("sick")
   end
   if good ~= getProperty("goods") then
      good = getProperty("goods")
      combo("good")
   end
   if bad ~= getProperty("bads") then
      bad = getProperty("bads")
      combo("bad")
   end
   if worst ~= getProperty("shits") then
      worst = getProperty("shits")
      combo("worst")
   end
end

function combo(comboName)
   if comboName == "bad" then 
      addHealth(-0.024)
   end
   if comboName == "worst" then 
      addHealth(-0.035)
      addMisses(1)
   end
end