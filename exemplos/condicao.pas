program condicao;
	var a : integer;
	var b : integer;
	procedure proc1;
		var x : integer;
	begin end;
	procedure proc2(c : integer; d : real);
		var y : real;
	begin end;
begin
	readln(a,b);
	if a = b then
		writeln(a);
	if a > b then
		writeln(a);
	if a < b then
		writeln(a);
	if a >= b then
		writeln(a);
	if a <= b then
		writeln(a);
	if a <> b then
		writeln(a);
	proc1;
end.
