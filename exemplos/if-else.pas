program ifelse;
	var a,b : integer;
begin
	if a <> b then
	begin
		if a < b then
		begin
			a := b + b;
			if a > b then
			begin
				b := a + a;
				if a < b then
					writeln(a,b);
			end;
			if a < b then
				a := 1;
		end;
	end;
end.
