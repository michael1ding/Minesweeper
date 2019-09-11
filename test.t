%%%%%%%% VARIABLES %%%%%%%%%%%%%%
var title : int := Pic.FileNew ("title.jpg")
var gamemode : string
var timer, timee, click : int := 0

var easy : array 0 .. 9 of array 0 .. 11 of int
var easyshow : array 1 .. 8 of array 1 .. 10 of string
var display : array 1 .. 8 of array 1 .. 10 of boolean
var flags : array 1 .. 8 of array 1 .. 10 of boolean

var med : array 0 .. 17 of array 0 .. 17 of int
var medshow : array 1 .. 16 of array 1 .. 16 of string
var mdisplay : array 1 .. 16 of array 1 .. 16 of boolean
var mflags : array 1 .. 16 of array 1 .. 16 of boolean

var hard : array 0 .. 17 of array 0 .. 31 of int
var hardshow : array 1 .. 16 of array 1 .. 30 of string
var hdisplay : array 1 .. 16 of array 1 .. 30 of boolean
var hflags : array 1 .. 16 of array 1 .. 30 of boolean

var losee, stream1 : int


var mousex, mousey, dummy1, dummy2, col, row, button : int
var newone := Pic.Scale (Pic.FileNew ("1.bmp"), 40, 40)
var newtwo := Pic.Scale (Pic.FileNew ("2.bmp"), 40, 40)
var newthree := Pic.Scale (Pic.FileNew ("3.bmp"), 40, 40)
var newfour := Pic.Scale (Pic.FileNew ("4.bmp"), 40, 40)
var newfive := Pic.Scale (Pic.FileNew ("5.bmp"), 40, 40)
var newemp := Pic.Scale (Pic.FileNew ("empty.bmp"), 40, 40)
var newPic := Pic.Scale (Pic.FileNew ("Block.bmp"), 40, 40)
var newbomb := Pic.Scale (Pic.FileNew ("Bomb.bmp"), 40, 40)
var flag := Pic.Scale (Pic.FileNew ("flag.jpg"), 40, 40)
var bad := Pic.Scale (Pic.FileNew ("Bad.bmp"), 40, 40)
var flagged := Pic.Scale (Pic.FileNew ("flagged.bmp"), 40, 40)
var difficulty : int

var stream2 : int 
var counter : int := 10
%%%%%%%% FUNCTIONS %%%%%%%%%%%%%%

proc tutorial ()
    var menu : int := Pic.FileNew ("htp11.jpg")
    var menu2 : int := Pic.FileNew ("htp22.jpg")
    var d1, d2, d3, d4 : int
    cls
    View.Set ("graphics:800,600,offscreenonly")
    Pic.Draw (menu, 0, 0, picCopy)
    View.Update
    Mouse.ButtonWait ("down", d1, d2, d3, d4)
    Mouse.ButtonWait ("down", d1, d2, d3, d4)
    cls
    Pic.Draw (menu2, 0, 0, picCopy)
    View.Update
    Mouse.ButtonWait ("down", d1, d2, d3, d4)
    cls
end tutorial


function win () : boolean
    if difficulty = 1 then
	for y : 1 .. 8
	    for x : 1 .. 10
		if easyshow (y) (x) ~= "B" then
		    if display (y) (x) = true then
			result false
		    end if
		end if
	    end for
	end for
    elsif difficulty = 2 then
	for y : 1 .. 16
	    for x : 1 .. 16
		if medshow (y) (x) ~= "B" then
		    if mdisplay (y) (x) = true then
			result false
		    end if
		end if
	    end for
	end for
    elsif difficulty = 3 then
	for y : 1 .. 16
	    for x : 1 .. 30
		if hardshow (y) (x) ~= "B" then
		    if hdisplay (y) (x) = true then
			result false
		    end if
		end if
	    end for
	end for
    end if
    result true
end win

procedure check (row, col : int)
    if difficulty = 1 then
	if row > 0 and col > 0 and row < 9 and col < 11 and display (row) (col) = true then
	    if easyshow (row) (col) = "0" then
		display (row) (col) := false
		check (row - 1, col)
		check (row - 1, col - 1)
		check (row, col - 1)
		check (row + 1, col - 1)
		check (row + 1, col)
		check (row + 1, col + 1)
		check (row, col + 1)
		check (row - 1, col + 1)
	    else
		display (row) (col) := false
	    end if
	end if
    elsif difficulty = 2 then
	if row > 0 and col > 0 and row < 17 and col < 17 and mdisplay (row) (col) = true then
	    if medshow (row) (col) = "0" then
		mdisplay (row) (col) := false
		check (row - 1, col)
		check (row - 1, col - 1)
		check (row, col - 1)
		check (row + 1, col - 1)
		check (row + 1, col)
		check (row + 1, col + 1)
		check (row, col + 1)
		check (row - 1, col + 1)
	    else
		mdisplay (row) (col) := false
	    end if
	end if
    elsif difficulty = 3 then
	if row > 0 and col > 0 and row < 17 and col < 31 and hdisplay (row) (col) = true then
	    if hardshow (row) (col) = "0" then
		hdisplay (row) (col) := false
		check (row - 1, col)
		check (row - 1, col - 1)
		check (row, col - 1)
		check (row + 1, col - 1)
		check (row + 1, col)
		check (row + 1, col + 1)
		check (row, col + 1)
		check (row - 1, col + 1)
	    else
		hdisplay (row) (col) := false
	    end if
	end if
    end if
end check

procedure lose ()
    if difficulty = 1 then
	for x : 1 .. 10
	    for y : 1 .. 8
		if flags (y) (x) = true and easyshow (y) (x) ~= "B" then
		    Pic.Draw (flagged, 40 * (x - 1) + 25, 40 * (y - 1) + 25, picCopy)
		elsif display (y) (x) = true and flags (y) (x) = false and easyshow (y) (x) = "B" then
		    Pic.Draw (newbomb, 40 * (x - 1) + 25, 40 * (y - 1) + 25, picCopy)
		elsif flags (y) (x) = true and easyshow (y) (x) = "B" then
		    Pic.Draw (flag, 40 * (x - 1) + 25, 40 * (y - 1) + 25, picCopy)
		end if
		View.Update
		delay (20)
	    end for
	end for
    elsif difficulty = 2 then
	for x : 1 .. 16
	    for y : 1 .. 16
		if mflags (y) (x) = true and medshow (y) (x) ~= "B" then
		    Pic.Draw (flagged, 40 * (x - 1) + 25, 40 * (y - 1) + 25, picCopy)
		elsif mdisplay (y) (x) = true and mflags (y) (x) = false and medshow (y) (x) = "B" then
		    Pic.Draw (newbomb, 40 * (x - 1) + 25, 40 * (y - 1) + 25, picCopy)
		elsif mflags (y) (x) = true and medshow (y) (x) = "B" then
		    Pic.Draw (flag, 40 * (x - 1) + 25, 40 * (y - 1) + 25, picCopy)
		end if
		View.Update
		delay (20)
	    end for
	end for
    elsif difficulty = 3 then
	for x : 1 .. 20
	    for y : 1 .. 16
		if hflags (y) (x) = true and hardshow (y) (x) ~= "B" then
		    Pic.Draw (flagged, 40 * (x - 1) + 25, 40 * (y - 1) + 25, picCopy)
		elsif hdisplay (y) (x) = true and hflags (y) (x) = false and hardshow (y) (x) = "B" then
		    Pic.Draw (newbomb, 40 * (x - 1) + 25, 40 * (y - 1) + 25, picCopy)
		elsif hflags (y) (x) = true and hardshow (y) (x) = "B" then
		    Pic.Draw (flag, 40 * (x - 1) + 25, 40 * (y - 1) + 25, picCopy)
		end if
		View.Update
		delay (20)
	    end for
	end for
    end if
end lose

proc clicks (n : int)
    if difficulty = 1 then
	if mousex > 25 and mousex < 425 and mousey > 25 and mousey < 345 then
	    if n = 1 and flags (row) (col) = false then
		check (row, col)
	    elsif n = 3 and display (row) (col) = true then
		if flags (row) (col) = false then
		    flags (row) (col) := true
		elsif flags (row) (col) = true then
		    flags (row) (col) := false
		end if
	    end if
	end if

	for x : 1 .. 10
	    for y : 1 .. 8
		if display (y) (x) = true and flags (y) (x) = true then
		    Pic.Draw (flag, 40 * (x - 1) + 25, 40 * (y - 1) + 25, picCopy)
		elsif display (y) (x) = true and flags (y) (x) = false then
		    Pic.Draw (newPic, 40 * (x - 1) + 25, 40 * (y - 1) + 25, picCopy)
		elsif display (y) (x) = false and flags (y) (x) = false then
		    if easyshow (y) (x) = "1" then
			Pic.Draw (newone, 40 * (x - 1) + 25, 40 * (y - 1) + 25, picCopy)
		    elsif easyshow (y) (x) = "2" then
			Pic.Draw (newtwo, 40 * (x - 1) + 25, 40 * (y - 1) + 25, picCopy)
		    elsif easyshow (y) (x) = "3" then
			Pic.Draw (newthree, 40 * (x - 1) + 25, 40 * (y - 1) + 25, picCopy)
		    elsif easyshow (y) (x) = "4" then
			Pic.Draw (newfour, 40 * (x - 1) + 25, 40 * (y - 1) + 25, picCopy)
		    elsif easyshow (y) (x) = "5" then
			Pic.Draw (newfive, 40 * (x - 1) + 25, 40 * (y - 1) + 25, picCopy)
		    elsif easyshow (y) (x) = "0" then
			Pic.Draw (newemp, 40 * (x - 1) + 25, 40 * (y - 1) + 25, picCopy)
		    elsif easyshow (y) (x) = "B" then
			Pic.Draw (bad, 40 * (x - 1) + 25, 40 * (y - 1) + 25, picCopy)
			losee += 1
		    end if
		end if
	    end for
	end for
    elsif difficulty = 2 then
	if mousex > 25 and mousex < 665 and mousey > 25 and mousey < 665 then
	    if n = 1 and mflags (row) (col) = false then
		check (row, col)
	    elsif n = 3 and mdisplay (row) (col) = true then
		if mflags (row) (col) = false then
		    mflags (row) (col) := true
		elsif mflags (row) (col) = true then
		    mflags (row) (col) := false
		end if
	    end if
	end if

	for x : 1 .. 16
	    for y : 1 .. 16
		if mdisplay (y) (x) = true and mflags (y) (x) = true then
		    Pic.Draw (flag, 40 * (x - 1) + 25, 40 * (y - 1) + 25, picCopy)
		elsif mdisplay (y) (x) = true and mflags (y) (x) = false then
		    Pic.Draw (newPic, 40 * (x - 1) + 25, 40 * (y - 1) + 25, picCopy)
		elsif mdisplay (y) (x) = false and mflags (y) (x) = false then

		    if medshow (y) (x) = "1" then
			Pic.Draw (newone, 40 * (x - 1) + 25, 40 * (y - 1) + 25, picCopy)
		    elsif medshow (y) (x) = "2" then
			Pic.Draw (newtwo, 40 * (x - 1) + 25, 40 * (y - 1) + 25, picCopy)
		    elsif medshow (y) (x) = "3" then
			Pic.Draw (newthree, 40 * (x - 1) + 25, 40 * (y - 1) + 25, picCopy)
		    elsif medshow (y) (x) = "4" then
			Pic.Draw (newfour, 40 * (x - 1) + 25, 40 * (y - 1) + 25, picCopy)
		    elsif medshow (y) (x) = "5" then
			Pic.Draw (newfive, 40 * (x - 1) + 25, 40 * (y - 1) + 25, picCopy)
		    elsif medshow (y) (x) = "0" then
			Pic.Draw (newemp, 40 * (x - 1) + 25, 40 * (y - 1) + 25, picCopy)
		    elsif medshow (y) (x) = "B" then
			Pic.Draw (bad, 40 * (x - 1) + 25, 40 * (y - 1) + 25, picCopy)
			losee += 1
		    end if
		end if
	    end for
	end for
    elsif difficulty = 3 then
	if mousex > 25 and mousex < 1225 and mousey > 25 and mousey < 665 then
	    if n = 1 and hflags (row) (col) = false then
		check (row, col)
	    elsif n = 3 and hdisplay (row) (col) = true then
		if hflags (row) (col) = false then
		    hflags (row) (col) := true
		elsif hflags (row) (col) = true then
		    hflags (row) (col) := false
		end if
	    end if
	end if

	for x : 1 .. 30
	    for y : 1 .. 16
		if hdisplay (y) (x) = true and hflags (y) (x) = true then
		    Pic.Draw (flag, 40 * (x - 1) + 25, 40 * (y - 1) + 25, picCopy)
		elsif hdisplay (y) (x) = true and hflags (y) (x) = false then
		    Pic.Draw (newPic, 40 * (x - 1) + 25, 40 * (y - 1) + 25, picCopy)
		elsif hdisplay (y) (x) = false and hflags (y) (x) = false then

		    if hardshow (y) (x) = "1" then
			Pic.Draw (newone, 40 * (x - 1) + 25, 40 * (y - 1) + 25, picCopy)
		    elsif hardshow (y) (x) = "2" then
			Pic.Draw (newtwo, 40 * (x - 1) + 25, 40 * (y - 1) + 25, picCopy)
		    elsif hardshow (y) (x) = "3" then
			Pic.Draw (newthree, 40 * (x - 1) + 25, 40 * (y - 1) + 25, picCopy)
		    elsif hardshow (y) (x) = "4" then
			Pic.Draw (newfour, 40 * (x - 1) + 25, 40 * (y - 1) + 25, picCopy)
		    elsif hardshow (y) (x) = "5" then
			Pic.Draw (newfive, 40 * (x - 1) + 25, 40 * (y - 1) + 25, picCopy)
		    elsif hardshow (y) (x) = "0" then
			Pic.Draw (newemp, 40 * (x - 1) + 25, 40 * (y - 1) + 25, picCopy)
		    elsif hardshow (y) (x) = "B" then
			Pic.Draw (bad, 40 * (x - 1) + 25, 40 * (y - 1) + 25, picCopy)
			losee += 1
		    end if
		end if
	    end for
	end for
    end if
end clicks

process timerting ()
    timer := Time.Elapsed
    timee := timer div 1000
    if timer >= 1 and timee ~= 0 then
	locatexy (maxx - 30, maxy - 30)
	put timee
	View.Update
    end if
end timerting

open : stream2, "test.txt", put


procedure GenerateMap (n : int)
    if n = 1 then
	setscreen ("graphics: 450,420,offscreenonly")
	counter := 10
	for c : 0 .. 9     %Generates Array for data and visuals
	    for r : 0 .. 11
		easy (c) (r) := 0
	    end for
	end for

	loop         %Generates bombs
	    for c : 1 .. 8
		for r : 1 .. 10
		    var random : int := Rand.Int (1, 8)
		    if random = 1 and easy (c) (r) ~= 1 then
			easy (c) (r) := 1
			counter -= 1
			exit when counter = 0
		    end if
		end for
		exit when counter = 0
	    end for
	    exit when counter = 0
	end loop

	for c : 1 .. 8     %Sets coverscreen/blocks on top
	    for r : 1 .. 10
		display (c) (r) := true
		flags (c) (r) := false
	    end for
	end for


	for c : 1 .. 8     %Counting Bomb amount around square and setting bomb
	    for r : 1 .. 10
		if easy (c) (r) = 1 then
		    easyshow (c) (r) := "B"
		else
		    easyshow (c) (r) := intstr (easy (c - 1) (r) + easy (c - 1) (r - 1) + easy (c) (r - 1) + easy (c + 1) (r - 1) + easy (c + 1) (r) + easy (c + 1) (r + 1) + easy (c) (r + 1) +
			easy (c - 1) (r + 1))
		end if
	    end for
	end for
	for x : 1 .. 10
	    for y : 1 .. 8
		Pic.Draw (newPic, 40 * (x - 1) + 25, 40 * (y - 1) + 25, picCopy)
	    end for
	end for

    elsif n = 2 then
	counter := 40
	setscreen ("graphics: 690,740, offscreenonly")
	for c : 0 .. 17     %Generates Array for data and visuals
	    for r : 0 .. 17
		med (c) (r) := 0
	    end for
	end for

	loop         %Generates bombs
	    for c : 1 .. 16
		for r : 1 .. 16
		    medshow(c)(r) := "0"
		    var random : int := Rand.Int (1, 32)
		    if random <= 5 and med (c) (r) ~= 1 then
			med (c) (r) := 1
			counter -= 1
			exit when counter = 0
		    end if
		end for
		exit when counter = 0
	    end for
	    exit when counter = 0
	end loop

	for c : 1 .. 16     %Sets coverscreen/blocks on top
	    for r : 1 .. 16
		mdisplay (c) (r) := true
		mflags (c) (r) := false
	    end for
	end for


	for c : 1 .. 16     %Counting Bomb amount around square and setting bomb
	    for r : 1 .. 16
		if med (c) (r) = 1 then
		    medshow (c) (r) := "B"
		else
		    medshow (c) (r) := intstr (med (c - 1) (r) + med (c - 1) (r - 1) + med (c) (r - 1) + med (c + 1) (r - 1) + med (c + 1) (r) + med (c + 1) (r + 1) + med (c) (r + 1) +
			med (c - 1) (r + 1))
		end if
	    end for
	end for

	for x : 1 .. 16
	    for y : 1 .. 16
		Pic.Draw (newPic, 40 * (x - 1) + 25, 40 * (y - 1) + 25, picCopy)
	    end for
	end for

    elsif n = 3 then
	counter := 99
	setscreen ("graphics:1250,740, offscreenonly")
	for c : 0 .. 17     %Generates Array for data and visuals
	    for r : 0 .. 31
		hard (c) (r) := 0
	    end for
	end for

	loop         %Generates bombs
	    for c : 1 .. 16
		for r : 1 .. 30
		    var random : int := Rand.Int (1, 32)
		    if random <= 5 and hard (c) (r) ~= 1 then
			hard (c) (r) := 1
			counter -= 1
			exit when counter = 0
		    end if
		end for
		exit when counter = 0
	    end for
	    exit when counter = 0
	end loop

	for c : 1 .. 16     %Sets coverscreen/blocks on top
	    for r : 1 .. 30
		hdisplay (c) (r) := true
		hflags (c) (r) := false
	    end for
	end for


	for c : 1 .. 16     %Counting Bomb amount around square and setting bomb
	    for r : 1 .. 30
		if hard (c) (r) = 1 then
		    hardshow (c) (r) := "B"
		else
		    hardshow (c) (r) := intstr (hard (c - 1) (r) + hard (c - 1) (r - 1) + hard (c) (r - 1) + hard (c + 1) (r - 1) + hard (c + 1) (r) + hard (c + 1) (r + 1) + hard (c) (r + 1) +
			hard (c - 1) (r + 1))
		end if
	    end for
	end for

	for x : 1 .. 30
	    for y : 1 .. 16
		Pic.Draw (newPic, 40 * (x - 1) + 25, 40 * (y - 1) + 25, picCopy)
	    end for
	end for
    end if
    View.Update
end GenerateMap

proc nobomb ()
    loop
	if click = 1 and difficulty = 1 and easyshow (row) (col) ~= "0" then
	    GenerateMap (difficulty)
	    if easyshow (row) (col) = "0" then
		exit
	    end if
	elsif click = 1 and difficulty = 2 and medshow (row) (col) ~= "0" then
	    GenerateMap (difficulty)
	    if medshow (row) (col) = "0" then
		put medshow(row)(col)
		exit
	    end if
	elsif click = 1 and difficulty = 3 and hardshow (row) (col) ~= "0" then
	    GenerateMap (difficulty)
	    if hardshow (row) (col) = "0" then
		exit
	    end if
	else
	    exit
	end if
    end loop
end nobomb
%%%%%%%%%%%%%        MENU           %%%%%%%%%%%%%%%%%%%

loop
    loop
	View.Set ("graphics:800;670,offscreenonly")
	losee := 0
	Pic.Draw (title, 0, 0, picCopy)
	Mouse.Where (mousex, mousey, button)
	if mousex >= 210 and mousex <= 257 and mousey <= 225 and mousey >= 200 then
	    Draw.ThickLine (207, 200, 260, 200, 2, 29)
	    View.Update     %Easy
	    if button = 1 then
		difficulty := 1
		exit
	    end if
	end if
	if mousex >= 210 and mousex <= 289 and mousey <= 200 and mousey >= 161 then
	    Draw.ThickLine (205, 166, 292, 166, 2, 29)
	    View.Update     %Medium
	    if button = 1 then
		difficulty := 2
		exit
	    end if
	end if
	if mousex >= 210 and mousex <= 256 and mousey <= 161 and mousey >= 129 then
	    Draw.ThickLine (207, 134, 259, 134, 2, 29)
	    View.Update     %Hard
	    if button = 1 then
		difficulty := 3
		exit
	    end if
	end if
	if mousex >= 194 and mousex <= 272 and mousey <= 129 and mousey >= 95 then
	    Draw.ThickLine (191, 100, 275, 100, 2, 29)
	    View.Update     %Tutorial
	    if button = 1 then
		tutorial
	    end if      
	end if
	View.Update
    end loop
    %%%%% CHANGE SETTING %%%%%


    %%%%%%%%%% MAP %%%%%%%%%%%%
    
    Mouse.ButtonChoose ("multibutton")
    click := 0
    GenerateMap (difficulty)
    loop
	View.Update
	Mouse.ButtonWait ("up", mousex, mousey, dummy1, dummy2)
	Mouse.ButtonWait ("down", mousex, mousey, dummy1, dummy2)
	click += 1
	col := (mousex - 25) div 40 + 1
	row := (mousey + 15) div 40
	cls
	nobomb ()
	clicks (dummy1)
	exit when win ()
	if losee ~= 0 then
	    lose ()
	    exit
	end if
    end loop
    exit when win ()*/   end loop
end loop
/*
 if win () then
 for y : 1 .. 8
 for x : 1 .. 10
 if easyshow (y) (x) = "B" then
 if display (y) (x) = true then
 flags (y) (x) := true
 end if
 end if
 end for
 end for
 end if


 */
