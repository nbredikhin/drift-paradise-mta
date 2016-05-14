local function a(b,c,d)
	if type(b)~="table"then 
		error("Error at 'Check'. Bad argument description for argument #"..tostring(c)..". Expected table, got "..type(b),3)
	end;
	if#b==0 then 
		error("Error at 'Check'. Empty argument description for argument #"..tostring(c),3)
	end;
	if type(b[2]) ~= "string" then 
		error("Error at 'Check'. Bad type description for argument #"..tostring(c),3)
	end;

	if type(b[1])~=b[2]then 
		error("Bad argument at '"..tostring(d).."' [Expected "..tostring(b[2]).." at argument "..tostring(c)..", got "..type(b[1]).."]",3)
	end;
	return true 
end;

function check(d,e)
	if type(d)~="string"then 
		error("Argument type mismatch at 'check' ('funcname'). Expected 'string', got '"..type(d).."'.",2)
	end;

	if type(e) ~= "table" then 
		error("Argument number mismatch at 'Check'. Expected arguments table, got '"..type(e).."'",2)
	end;

	if not next(e)then 
		error("Argument number mismatch at 'Check'. Arguments table is empty",2)
	end;
	if #e == 2 and type(e[2]) == "string" then 
		return a(e,1,d)
	end;

	for c,b in ipairs(e)do 
		a(b,c,d)
	end;

	return true 
end
