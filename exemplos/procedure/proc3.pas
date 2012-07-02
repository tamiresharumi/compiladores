program proc3;
	var a : integer;
	var b : real;
	procedure proc1;
		var w : integer;
	begin end;
	procedure proc2(c : integer; d : real);
		var x : real;
	begin end;
	procedure proc3(e : integer; f : real; g : integer);
		var y : real;
		var z : integer;
	begin
		if e > g then
			y := e + f + g * z
		else
			y := f + f;
	end;
begin
	proc1;
	proc2(a;b);
	proc3(a;b;a);
end.
