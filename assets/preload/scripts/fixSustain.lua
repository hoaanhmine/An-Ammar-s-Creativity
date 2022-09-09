function onUpdatePost(elapsed)
   
   fixNoteDirection(elapsed)
end

function fixNoteDirection(elapsed)
   
   for note = 0, getProperty("notes.length")-1 do 
      
      local data = getPropertyFromGroup("notes", note, "noteData") + (getPropertyFromGroup("notes", note, "mustPress") and 4 or 0)
      local tail = (string.find( gpfg("notes",note,"animation.curAnim.name"), "end" ))
    
      
      if gpfg("notes",note,"isSustainNote") then
         if not tail then 
            if gpfg("notes",note,"nextNote") ~= nil and gpfg("notes",note,"prevNote") ~= nil then
            
               
               local diffX = 0;
               local diffY = 0;
               local nextNoteX = getMidPoint(gpfg("notes", note, "nextNote.x"), gpfg("notes", note, "nextNote.y"), gpfg("notes", note, "nextNote.width"), gpfg("notes", note, "nextNote.height"))["x"]
               local nextNoteY = getMidPoint(gpfg("notes", note, "nextNote.x"), gpfg("notes", note, "nextNote.y"), gpfg("notes", note, "nextNote.width"), gpfg("notes", note, "nextNote.height"))["y"]
               local prevNoteX = getMidPoint(gpfg("notes", note, "prevNote.x"), gpfg("notes", note, "prevNote.y"), gpfg("notes", note, "prevNote.width"), gpfg("notes", note, "prevNote.height"))["x"]
               local prevNoteY = getMidPoint(gpfg("notes", note, "prevNote.x"), gpfg("notes", note, "prevNote.y"), gpfg("notes", note, "prevNote.width"), gpfg("notes", note, "prevNote.height"))["y"]
               diffX = nextNoteX - prevNoteX
               diffY = nextNoteY - prevNoteY

               local rad = math.atan2(diffY, diffX)
               local deg = rad * (180 / math.pi)

               setPropertyFromGroup("notes", note, "angle", deg - 90)
               
            end
         else 
            if gpfg("notes",note,"prevNote") ~= nil then 
               setPropertyFromGroup("notes", note, "angle", gpfg("notes", note, "prevNote.angle"))
            else 
               setPropertyFromGroup("notes", note, "angle", gpfg("strumLineNotes", data, "direction") - 90)
            end
         end
      else 
         setPropertyFromGroup("notes", note, "angle", gpfg("strumLineNotes", data, "angle"))
       
      end
   end
end

function gpfg(in1, in2, in3)
   return getPropertyFromGroup(in1, in2, in3)
end

function getMidPoint(_x, _y ,_width, _height)
   return {
      ["x"] = _x + _width * 0.5,
      ["y"]  = _y + _height * 0.5
   }
end