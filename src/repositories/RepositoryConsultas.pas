unit RepositoryConsultas;

interface

uses Horse, Horse.Jhonson, System.JSON, System.SysUtils, System.StrUtils;

type
  TRepositorioConsultas = class
  private
  public
    function RetornaConsulta(XId: integer): TJSONObject;
    function RetornaListaConsultas: TJSONArray;
  end;

implementation

{ RepositorioConsultas }

function TRepositorioConsultas.RetornaConsulta(XId: integer): TJSONObject;
var consulta: TJSONObject;
begin
  consulta := TJSONObject.Create;
  consulta.AddPair('id',IntToStr(XId));
  consulta.AddPair('data','2023-03-30');

  result := consulta;
end;



function TRepositorioConsultas.RetornaListaConsultas: TJSONArray;
var consulta1,consulta2,consulta3: TJSONObject;
    lista: TJSONArray;
begin
  consulta1 := TJSONObject.Create;
  consulta2 := TJSONObject.Create;
  consulta3 := TJSONObject.Create;
  lista     := TJSONArray.Create;
  try
    consulta1.AddPair('id','1');
    consulta1.AddPair('data','2023-03-30');

    consulta2.AddPair('id','2');
    consulta2.AddPair('data','2023-03-31');

    consulta3.AddPair('id','3');
    consulta3.AddPair('data','2023-04-01');

    lista.AddElement(consulta1);
    lista.AddElement(consulta2);
    lista.AddElement(consulta3);

    result := lista;

  finally

  end;

end;

end.
