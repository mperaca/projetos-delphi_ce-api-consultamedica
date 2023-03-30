unit RepositoryMedicos;

interface

uses System.JSON, System.StrUtils, System.SysUtils;

type
  TRepositorioMedico = class
  private
  public
    function ListaMedicos: TJSONArray;
    function RetornaMedico(XId: integer): TJSONObject;
  end;


implementation

{ TRepositorioMedico }

function TRepositorioMedico.ListaMedicos: TJSONArray;
var lista: TJSONArray;
    medico1,medico2: TJSONObject;
begin
  medico1 := TJSONObject.Create;
  medico2 := TJSONObject.Create;
  lista   := TJSONArray.Create;
  try
    medico1.AddPair('id','1');
    medico1.AddPair('nome','Dr Pedro Araujo');
    medico1.AddPair('crm','6622150');
    medico1.AddPair('especialidade','Neurologista');

    medico2.AddPair('id','2');
    medico2.AddPair('nome','Dr Ricardo Prestes');
    medico2.AddPair('crm','1132250');
    medico2.AddPair('especialidade','Cardiologista');


    lista.AddElement(medico1);
    lista.AddElement(medico2);

    result := lista;
  finally
  end;
end;

function TRepositorioMedico.RetornaMedico(XId: Integer): TJSONObject;
var medico: TJSONObject;
begin
  medico := TJSONObject.Create;
  try
    medico.AddPair('id',inttostr(XId));
    medico.AddPair('nome','Dr Pedro Araujo');
    medico.AddPair('crm','6622150');
    medico.AddPair('especialidade','Neurologista');
    result := medico;
  finally
  end;
end;

end.
