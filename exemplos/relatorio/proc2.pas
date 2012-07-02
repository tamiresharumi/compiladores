program proc2;
    const meuconst := 5;
    var x,y : integer;
    procedure meuproc1(a : integer);
    begin
        a := 2 * a + a / 2;
        writeln(a);
    end;
    procedure meuproc2(a : integer; b : integer);
        var z : integer;
    begin
        z := a + b;
        z := z * 10 + z / 10;
        writeln(z);
    end;
begin
    readln(x);
    meuproc1(x);
    readln(y);
    meuproc2(x;y);
end.

