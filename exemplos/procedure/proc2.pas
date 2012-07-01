program proc2;
	var a : integer;
	var b : real;
	procedure proc(b,c,d : integer);
		var e : integer;
	begin
		writeln(b);
	end;
	procedure proc2(x : integer; y : real);
	begin
	end;
begin
	{
	a := 10;
	a := b;
	}
	b := (a + -(a + 2 * a));
	{
	b := a / a + a * a;
	a := a + a * b + (b + a);
	proc(a;b;b);
	proc2(b;a);
	}
end.
