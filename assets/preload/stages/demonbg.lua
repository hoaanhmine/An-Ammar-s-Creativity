randoShake = 0
timewait = 0
function onCreate()

makeAnimatedLuaSprite('bg','skybg/fatbg',-1417.15,-1041.5)
addAnimationByIndices('bg','still','fatbg','0',24)
addAnimationByPrefix('bg','jive','fatbg',24,true)
addAnimationByIndices('bg','static','fatbg','3',24)
addLuaSprite('bg')


makeAnimatedLuaSprite('speaker','skybg/speaker',879.5,471.7)
addAnimationByPrefix('speaker','speaker','speaker',24,false)
addLuaSprite('speaker')
setScrollFactor('speaker',0.95,0.95)

end

function onCreatePost()
	makeAnimatedLuaSprite('static','skybg/staticbg',-1361.1,-681)
	addAnimationByPrefix('static','static','staticbg',24,true)
	addLuaSprite('static')
	objectPlayAnimation('static','static',true)
	setBlendMode('static','add')
	setObjectCamera("static", "hud")
	setObjectOrder("static", getObjectOrder("notes") + 5)

	
	setProperty('static.alpha',0.01)
end
function onSongStart()
	setProperty('static.visible',false)
	objectPlayAnimation('speaker','speaker',true)
end
function onBeatHit()
	objectPlayAnimation('speaker','speaker',true)
end

function onUpdatePost()
if not inGameOver then
	if getRandomBool(80) then 
		setProperty("static.flipX", getRandomBool(50))
	end
	if getRandomBool(80) then 
		setProperty("static.flipY", getRandomBool(50))
	end
	setProperty("static.animation.frameIndex", getProperty("static.animation.frameIndex") + getRandomInt(-2, 2))

end

end

function onStepHit()

if timewait > 0 then timewait = 0 end
anims = {'still','jive','static'}

if flashingLights then
objectPlayAnimation('bg',anims[getRandomInt(1,3)])
end
end
function opponentHit(id,d,t,s)


objectPlayAnimation('bg','jive')



end

staton = false

function onEvent(n,v,b)

if n == 'Static' then
if timewait == 0 then
	randoShake = 0
	staton = staton == false

	if v == 'off' or  flashingLights then staton = false end
	
	if staton then
		randoShake = 10
		characterPlayAnim('scared','gf')
		characterPlayAnim('scared','bf')
	end
timewait = 1
end
end


end