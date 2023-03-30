unit RepositoryPacientes;

interface

uses System.JSON, System.StrUtils, System.SysUtils;

type
  TRepositorioPaciente = class
  private
  public
    function ListaPacientes: TJSONArray;
    function RetornaPaciente(XId: integer): TJSONObject;
  end;


implementation

{ TRepositorioPaciente }

function TRepositorioPaciente.ListaPacientes: TJSONArray;
var lista: TJSONArray;
    paciente1,paciente2,paciente3: TJSONObject;
begin
  paciente1 := TJSONObject.Create;
  paciente2 := TJSONObject.Create;
  paciente3 := TJSONObject.Create;
  lista   := TJSONArray.Create;
  try
    paciente1.AddPair('id','1');
    paciente1.AddPair('nome','Marcelo Teixeira Peraça');
    paciente1.AddPair('data_nascimento','1974-03-12');
    paciente1.AddPair('genero','Masculino');

    paciente2.AddPair('id','2');
    paciente2.AddPair('nome','Kelly Bazareli');
    paciente2.AddPair('data_nascimento','1984-01-08');
    paciente2.AddPair('genero','Feminino');

    paciente3.AddPair('id','3');
    paciente3.AddPair('nome','Isabela Dutra Peraça');
    paciente3.AddPair('data_nascimento','2013-04-26');
    paciente3.AddPair('genero','Feminino');


    lista.AddElement(paciente1);
    lista.AddElement(paciente2);
    lista.AddElement(paciente3);

    result := lista;
  finally
  end;
end;

function TRepositorioPaciente.RetornaPaciente(XId: Integer): TJSONObject;
var paciente: TJSONObject;
begin
  paciente := TJSONObject.Create;
  try
    paciente.AddPair('id',inttostr(XId));
    paciente.AddPair('nome','Marcelo Teixeira Peraça');
    paciente.AddPair('data_nascimento','1974-03-12');
    paciente.AddPair('genero','Masculino');
    result := paciente;
  finally
  end;
end;

end.
