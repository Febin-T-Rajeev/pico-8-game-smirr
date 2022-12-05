--(game smirr)
--(by febin)

--var
function _init()
  player={
    sp=1,
    x=59,
    y=59,
    w=8,
    h=8,
    flp=false,
    dx=0,
    dy=0,
    max_dx=2,
    max_dy=3,
    acc=0.5,		
    boost=4,
    anim=0,
    running=false,
    jumping=false,
    falling=false,
    sliding=false,
    landed=false,
  }
gravity=0.5
friction=0.85

--cam
cam_x=0
cam_y=0

--map limits
map_starts =0
map_end =1024

end

--update draw
function _update()
  player_update()
  player_animate()
  
  --cam
  cam_x=player.x-64+(player.w/2)
  cam_y=player.y-70
  if cam_x<map_starts then
    cam_x=map_starts
    end
  if cam_x>map_end-128 then
    cam_x=map_end-128
    end  
  camera(cam_x,cam_y)
 
  
end
function _draw()
cls()
map(0,0)
spr(player.sp,player.x,player.y,1,1,player.flp)
end

--collition
function collide_map(obj,aim,flag)
	--obj = table needs x,y,w,h
	--aim = left,right,up,down
	local x=obj.x local y=obj.y
	local w=obj.w local h=obj.h
	local x1=0 local y1=0
	local x2=0 local y2=0
	
	if aim=="left" then
	  x1=x-1 y1=y
	  x2=x   y2=y+h-1
	
	elseif aim=="right" then
	  x1=x+w-1     y1=y
	  x2=x+w       y2=y+h-1
	
	elseif aim=="up" then
	  x1=x+2     y1=y-1
	  x2=x+w-3   y2=y
	elseif aim=="down" then
	  x1=x+2     y1=y+h
	  x2=x+w-3   y2=y+h
	end
	
	--pixels to tiles
	x1/=8 y1/=8
	x2/=8 y2/=8
	
		
		if fget(mget(x1,y1),flag)	
		or fget(mget(x1,y2),flag)	
		or fget(mget(x2,y1),flag)	
		or fget(mget(x2,y2),flag)	then
		 return true
		else
		 return false
		 
		 end
	
end

--player
function player_update()
  if collide_map(player,"down",2)then
   friction=0.05
  elseif collide_map(player,"down",3)then
   player.x=59
   player.y=59
  elseif collide_map(player,"down",4)then
     friction=0.99
     player.max_dx=3
  else
   friction=0.85
   player.max_dx=2
   end
	--physics
	player.dy+=gravity
	player.dx*=friction
	
	--controls
	if btn(⬅️)then
	player.dx-=player.acc
	player.running=true
	player.flp=true
	end
	
	if btn(➡️)then
	player.dx+=player.acc
	player.running=true
	player.flp=false
	end
	
	if player.running
	and not btn(⬅️)
	and not btn(➡️)
	and not player.falling
	and not player.jumping then
	  player.running=false
	  player.sliding=true
	 end
	 
	 
	 if btnp(⬆️)
	 and player.landed then
	   player.dy-=player.boost
	   player.landed=false
	  end
	 ---colli up down cheack
	 if player.dy>0 then
	   player.falling=true
	   player.landed=false
	   player.jumping=false
	   
	   player.dy=limit_speed(player.dy,player.max_dy)
	   
	   if collide_map(player,"down",0) then
	     player.landed=true
	     player.falling=false
	     player.dy=0
	     player.y-=((player.y+player.h+1)%8)-1
	   end
	   elseif player.dy<0 then
	   player.jumping=true
	   if collide_map(player,"up",1) then
	     player.dy=0 
	    end
	   end 
	   
	   --coll left right
	   if player.dx<0 then
	    
	    player.dx=limit_speed(player.dx,player.max_dx)
	    
	      if collide_map(player,"left",1)then
	      player.dx=0
	      end
	      elseif player.dx>0 then
	       
	       player.dx=limit_speed(player.dx,player.max_dx)
	       
	        if collide_map(player,"right",1)then
	        player.dx=0
	        end
	      end
	   --sliding stop
	   if player.sliding then
	      if abs(player.dx)<.2
	      or player.running then
	       player.dx=0
	       player.sliding=false
	   end
	   end
	   
	   
	   
	  player.x+=player.dx
	  player.y+=player.dy
	
	--limit player
	
	if player.x<map_starts then
	  player.x=map_starts
	end
	if player.x>map_end-player.w then
	player.x=map_end-player.w
	end
	
end
function player_animate()
  if player.jumping then
     player.sp=7
  elseif player.falling then
     player.sp=8
  elseif player.sliding then
     player.sp=9
   elseif 
     player.running then  
  				if time()-player.anim>.1 then
  				  player.anim=time()
  				  player.sp+=1
  				  if player.sp>6 then
  				     player.sp=3

  				end     
   end 
   else
  
   if time()-player.anim>.3 then
     player.anim=time()
     player.sp+=1
       if player.sp>2 then
         player.sp=1
   end
   end
end
end
function limit_speed(num,maximum)
return  mid(-maximum,num,maximum)
end




