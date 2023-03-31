unit RepositoryMedicos;

interface

uses System.JSON, System.StrUtils, System.SysUtils, RepositoryConexao, DataSet.Serialize,
     FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.DApt,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.PG,
     FireDAC.Phys.PGDef, FireDAC.ConsoleUI.Wait, Data.DB, FireDAC.Comp.Client;


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
    conexao: TDataModuleConexao;
    erro: string;
    query: TFDQuery;
begin
  conexao := TDataModuleConexao.Create(nil);
  query   := TFDQuery.Create(nil);
  try
    conexao.ConectarBancoDados(erro);
    query.Connection := conexao.FDConnection1;
    with query do
    begin
      DisableControls;
      Close;
      SQL.Clear;
      Params.Clear;
      SQL.Add('Select * from "medico" ');
      Open;
      EnableControls;
    end;
    lista := query.ToJSONArray();
    result := lista;
  finally
    query.Free;
    conexao.DesconectarBancoDados(erro);
    conexao.Free;
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
