pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

player = {}
options = {}
classes = {}

state = 0
selected = 1
function _init( ... )
    printh("initialising", "log.txt", true)
    create_character()
    setup_classes()
    
end

function _update()
    if (btnp(1)) create_character()
    if (btnp(4) and state != 1) then 
      state = 1
      set_classes()
    end
    if (state == 1) then
      select_options()
    end

end

function select_cleric()
    player.class = "cleric"
    player.hp = flr(rnd(5))+1 + calc_bonus(player.con)
    player.max_hp = player.hp
end

function select_fighter()
    player.class = "fighter"
    player.hp = flr(rnd(7))+1 + calc_bonus(player.con)
    player.max_hp = player.hp
end

function select_magic_user()
    player.class = "magic-user"
    player.hp = flr(rnd(3))+1 + calc_bonus(player.con)
    player.max_hp = player.hp
end

function select_thief()
    player.class = "thief"
    player.hp = flr(rnd(3))+1 + calc_bonus(player.con)
    player.max_hp = player.hp
end

function select_elf()
    player.class = "elf"
    player.hp = flr(rnd(5))+1 + calc_bonus(player.con)
    player.max_hp = player.hp
end

function select_dwarf()
    player.class = "dwarf"
    player.hp = flr(rnd(7))+1 + calc_bonus(player.con)
    player.max_hp = player.hp
end

function select_halfling()
    player.class = "halfling"
    player.hp = flr(rnd(5))+1 + calc_bonus(player.con)
    player.max_hp = player.hp
end

function set_classes()

    setup_classes()
    options = classes
    log(#options)

    if (player.str >8 and player.int >8 ) then
      elf = { 
        display = "elf",
        func = select_elf
      }
      add (options, elf)
    end
    if(player.con > 8) then
      dwarf = 
      {
        display = "dwarf",
        func = select_dwarf
      }
      add(options, dwarf)
    end

    if (player.dex > 8 and player.con > 9) then
      halfing = 
      {
        display = "halfling",
        func = select_halfling
      }
      add(options,halfing)
    end
    
end



function _draw()
    cls()
    sheet_draw()
    if (state == 1) draw_options()

end

function sheet_draw()
    ty = 2
    iy = 7
    tx = 22
    color(11)
    rect(0,0,127,127,11)

    print ("name ", 2,ty)
    print (player.name, tx,ty)
    ty +=iy
    print ("clss ", 2,ty)
    print (player.class, tx,ty)
    ty +=iy
    print ("hp ", 2,ty)
    print (player.hp.."/"..player.max_hp, tx,ty)
    ty +=iy
    print ("ac ", 2,ty)
    print (player.ac, tx,ty)
    ty +=iy
    print ("str ", 2,ty)
    print (player.str.." "..string_bonus(player.str).." to hit/damage", tx,ty)
    ty +=iy
    print ("int ", 2,ty)
    print (player.int.." "..string_bonus(player.int).." languages", tx,ty)
    ty +=iy
    print ("wis ", 2,ty)
    print (player.wis.." "..string_bonus(player.wis).." save vs spells", tx,ty)
    ty +=iy
    print ("dex ", 2,ty)
    print (player.dex.." "..string_bonus(player.dex).." to shoot/ac", tx,ty)
    ty +=iy
    print ("con ", 2,ty)
    print (player.con.." "..string_bonus(player.con).." hit points", tx,ty)
    ty +=iy
    print ("chr ", 2,ty)
    print (player.chr.." "..string_bonus(player.chr).." reaction adjustment", tx,ty)
    ty +=iy
    print ("gold ", 2,ty)
    print (player.gold, tx,ty)
    ty +=iy
    print ("arm ", 2,ty)
    print (player.armour, tx,ty)
    ty +=iy
    print ("wep ", 2,ty)
    print (player.weapon, tx,ty)
    ty +=iy
end

function create_character()

    player.str = roll3d6()
    player.int = roll3d6()
    player.wis = roll3d6()
    player.dex = roll3d6()
    player.con = roll3d6()
    player.chr = roll3d6()
    player.name ="-"
    player.class = "none"
    player.armour = "none"
    player.weapon = "none"
    player.hp = 0
    player.max_hp = 0
    player.ac = 9
    player.gold = roll3d6() * 10
    player.name = random_name()
end

function string_bonus(stat) 
    bonus = calc_bonus(stat)
    s_bonus = "-"
    if (bonus < 0) s_bonus = bonus
    if (bonus > 0) s_bonus = "+"..bonus 
    return s_bonus
end

function calc_bonus(stat)
    bonus = 0
    if (stat < 4) bonus = -3
    if (stat > 3 and stat < 6) bonus = -2
    if (stat > 5 and stat < 9) bonus = -1
    if (stat > 12 and stat < 16) bonus = 1
    if (stat > 15 and stat < 18) bonus = 2
    if (stat > 17) bonus = 3
    return bonus
end


function roll3d6()
    r = 0
    for i=1,3 do
      r +=1
      r +=flr(rnd(5))
    end
    return r
end
--
-- options code
--
function draw_options()
 
    if (#options>0) then
     
      oy = (64 - (#options * 6)/2)
      ox = 32
      rectfill(ox-7,oy-1,ox+65,65+((#options * 6)/2),0)
      rect(ox-7,oy-1,ox+65,65+((#options * 6)/2),2)
      for n= 1,#options do
        if (selected == n) then
          print(">"..options[n].display,ox-6,oy,9)
        else 
          print(options[n].display,ox,oy,12)
        end
        oy += 6
      end
    end
end
  
  function select_options()
  
    if (btnp(2)) selected -=1 
    if (btnp(3)) selected +=1 
  
    if (selected < 1) then  
      selected =1
    elseif (selected > #options) then 
      selected = #options 
    end
      
    if (btnp(5)) then
      options[selected].func()
      clear_options()
    end
    -- flush_btn4 used to debounce btnp(4) as the first press is still in buffer  
    if (btnp(4) and flush_btn4 == 0) clear_options() -- cancel
    if (btnp(4) and flush_btn4 == 1) flush_btn4 = 0
   
  end
  
  function clear_options()
    state = 0
    options={}
  end

  function setup_classes() 
    classes = {
      { 
        display = "cleric",
        func = select_cleric
      },
      { 
        display = "fighter",
        func = select_fighter
      },
      { 
        display = "magic-user",
        func = select_magic_user
      },
      { 
        display = "thief",
        func = select_thief
      }
    }
  end

  function log(msg)
    printh(time()..":"..msg, "log.txt")
  end

  function random_name()
    local a = {"cug", "ara", "gan", "myra","cral","dorn","faf", "nar", "voth", "kha", "ez", "xyzal", "oso", "quan"}
    local b = {"", "","el", "go", "du", "kar", "vog", "hurn", "id","hi", "ick", "gor", "um","os"}
    local c = {" the clever","rn","lf"," of shadows", " the marvellous", " stormspear", "es", "", " deadlord", " the thirster", " havocbringer" }
    local i1 = flr(rnd(#a-1))+1
    local i2 = flr(rnd(#b-1))+1
    local i3 = flr(rnd(#c-1))+1
    local s = a[i1]..b[i2]..c[i3]
    return s
  end