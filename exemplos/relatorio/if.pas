program ifprog;
    var x : integer;
    var y : integer;
begin
    readln(x,y);
    if x > y then 
        x := -y * -y
    else begin
        readln(y);
        x := -y;
    end;
    writeln(x);
end.
