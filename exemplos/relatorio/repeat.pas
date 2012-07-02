program p;
var a, b: integer;
begin
	readln(b);
	a := 1;
	repeat
	begin
		a := a + 1;
		writeln(a);
	end;
	until a > b;
	writeln(b);
end.
