program proc1;
    var x : integer;
    procedure proc;
        var y : real;
    begin
        readln(y);
        if y < 0 then
            y := -y;
        writeln(y);
    end;
begin
    proc;
end.
