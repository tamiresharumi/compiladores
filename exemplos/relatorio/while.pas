program whileprog;
    var x,y : integer;
begin
    {calcula o resto da
	divisao de x por y}
    readln(x,y);
    if x < 0 then
        x := -x;
    if y < 0 then
        y := -y;
    while x > y do
    begin
        x :=  x - y;
    end;
    writeln(x);
end.
