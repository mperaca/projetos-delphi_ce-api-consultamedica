unit RepositoryConsultas;

interface

uses Horse, Horse.Jhonson, System.JSON, System.SysUtils, System.StrUtils,
  RepositoryConexao,  FireDAC.Comp.Client, DataSet.Serialize, Data.DB,
  ModelConsultas;

type
  TRepositorioConsultas = class
  private
    FConsulta: TModelConsulta;
    function ValidaConsulta(XConsulta: TJSONObject): boolean;
    function RetornaData(XData: string): TDate;
  public
    function RetornaConsulta(XId: integer): TJSONObject;
    function RetornaListaConsultas: TJSONArray;
    function AlteraConsulta(XConsulta: TJSONObject; XId: integer): TJSONObject;
    function IncluiConsulta(XConsulta: TJSONObject): TJSONObject;
    function ExcluiConsulta(XId: integer): boolean;
  end;

implementation


{ RepositorioConsultas }

// Consultas Privadas
function TRepositorioConsultas.ValidaConsulta(XConsulta: TJSONObject): boolean;
var data,status,idmedico,idpaciente: string;
    medico,paciente: TJSONObject;
    retorno: boolean;

begin
  if not XConsulta.TryGetValue('data',data) then
     begin
       Result := false;
       raise Exception.Create('Campo "data" não está presente no body requisição');
     end;
  if not XConsulta.TryGetValue('status',status) then
     begin
       Result := false;
       raise Exception.Create('Campo "status" não está presente no body requisição');
     end;
  if not XConsulta.TryGetValue('medico',medico) then
     begin
       Result := false;
       raise Exception.Create('Campo "medico" não está presente no body requisição');
     end;
  if not XConsulta.TryGetValue('paciente',paciente) then
     begin
       Result := false;
       raise Exception.Create('Campo "paciente" não está presente no body requisição');
     end;
  try
    medico.TryGetValue('id',idmedico);
    paciente.TryGetValue('id',idpaciente);

    FConsulta             := TModelConsulta.Create;
    FConsulta.data        := RetornaData(data);
    FConsulta.status      := status;
    FConsulta.medico.id   := StrToInt(idmedico);
    FConsulta.paciente.id := StrToInt(idpaciente);

    Result := true;
  except
    Result := false;
  end;
end;

function TRepositorioConsultas.RetornaData(XData: string): TDate;
var ano,mes,dia: word;
begin
  ano    := strtoint(copy(XData,1,4));
  mes    := strtoint(copy(XData,6,2));
  dia    := strtoint(copy(XData,9,2));
  Result := EncodeDate(ano,mes,dia);
end;


// Consultas Públicas
function TRepositorioConsultas.AlteraConsulta(XConsulta: TJSONObject;  XId: integer): TJSONObject;
var conexao: TDataModuleConexao;
    erro: string;
    query: TFDQuery;
    numreg: integer;
begin
  if not ValidaConsulta(XConsulta) then
     exit;

  conexao      := TDataModuleConexao.Create(nil);
  query        := TFDQuery.Create(nil);
  try
    conexao.ConectarBancoDados(erro);
  except
    On E: Exception do
    begin
      raise Exception.Create('Erro ao conectar banco de dados: '+E.Message);
    end;
  end;
  try
     with query do
     begin
       Connection := conexao.FDConnection1;
       DisableControls;
       Close;
       SQL.Clear;
       Params.Clear;
       SQL.Add('update "consulta" set "data"=:xdata, "status"=:xstatus, ');
       SQL.Add('       "idMedico"=:xidmedico, "idPaciente"=:xidpaciente ');
       SQL.Add('where  "id"=:xidconsulta ');
       ParamByName('xidconsulta').AsInteger := XId;
       ParamByName('xdata').AsDate          := FConsulta.data;
       ParamByName('xstatus').AsString      := FConsulta.status;
       ParamByName('xidmedico').AsInteger   := FConsulta.medico.id;
       ParamByName('xidpaciente').AsInteger := FConsulta.paciente.id;
       ExecSQL;
       EnableControls;
       numreg := RowsAffected;
     end;
     if numreg>0 then
        with conexao do
        begin
          qryConsulta.close;
          qryConsulta.SQL.Clear;
          qryConsulta.SQL.Add('select * from "consulta" where "id"=:xid ');
          qryConsulta.ParamByName('xid').AsInteger := XId;
          qryConsulta.Open;

          qryMedico.Close;
          qryMedico.SQL.Clear;
          qryMedico.SQL.Add('SELECT "medico".* FROM "medico" ');
          qryMedico.SQL.Add('       inner join "consulta" on "medico"."id" = "consulta"."idMedico" ');
          qryMedico.SQL.Add('WHERE "consulta"."id"=:xid ');
          qryMedico.ParamByName('xid').AsInteger := XId;
          qryMedico.Open;

          qryPaciente.Close;
          qryPaciente.SQL.Clear;
          qryPaciente.SQL.Add('SELECT "paciente".* FROM "paciente" ');
          qryPaciente.SQL.Add('       inner join "consulta" on "paciente"."id" = "consulta"."idPaciente" ');
          qryPaciente.SQL.Add('WHERE "consulta"."id"=:xid ');
          qryPaciente.ParamByName('xid').AsInteger := XId;
          qryPaciente.Open;
        end;
     Result := conexao.qryConsulta.ToJSONObject();
  finally
     conexao.DesconectarBancoDados(erro);
     query.DisposeOf;
     conexao.DisposeOf;
  end;
end;

function TRepositorioConsultas.ExcluiConsulta(XId: integer): boolean;
var conexao: TDataModuleConexao;
    erro: string;
    query: TFDQuery;
    numregistro: integer;
begin
  conexao := TDataModuleConexao.Create(nil);
  query   := TFDQuery.Create(nil);
  try
    conexao.ConectarBancoDados(erro);
  except
    On E: Exception do
    begin
      raise Exception.Create('Erro ao conectar banco de dados: '+E.Message);
    end;
  end;
  try
    with query do
    begin
      Connection := conexao.FDConnection1;
      DisableControls;
      Close;
      SQL.Clear;
      Params.Clear;
      SQL.Add('delete from "consulta" where "id"=:xid ');
      ParamByName('xid').AsInteger := XId;
      ExecSQL;
      EnableControls;
      numregistro := RowsAffected;
    end;
    Result := numregistro>0;
  finally
    conexao.DesconectarBancoDados(erro);
    conexao.DisposeOf;
    query.DisposeOf;
  end;
end;

function TRepositorioConsultas.IncluiConsulta(
  XConsulta: TJSONObject): TJSONObject;
var conexao: TDataModuleConexao;
    erro: string;
    query: TFDQuery;
    numregistro: integer;
begin
  if not ValidaConsulta(XConsulta) then
     exit;
  conexao      := TDataModuleConexao.Create(nil);
  query        := TFDQuery.Create(nil);
  try
    conexao.ConectarBancoDados(erro);
  except
    On E: Exception do
    begin
      raise Exception.Create('Erro ao conectar banco de dados: '+E.Message);
    end;
  end;
  try
    with query do
    begin
      Connection := conexao.FDConnection1;
      DisableControls;
      Close;
      SQL.Clear;
      Params.Clear;
      SQL.Add('insert into "consulta" ("data","status","idMedico","idPaciente") ');
      SQL.Add('values(:xdata,:xstatus,:xidmedico,:xidpaciente) ');
      ParamByName('xdata').AsDate          := FConsulta.data;
      ParamByName('xstatus').AsString      := FConsulta.status;
      ParamByName('xidmedico').AsInteger   := FConsulta.medico.id;
      ParamByName('xidpaciente').AsInteger := FConsulta.paciente.id;
      ExecSQL;
      EnableControls;
      numregistro := RowsAffected;
    end;
    if numregistro>0 then
       with conexao do
       begin
         qryConsulta.close;
         qryConsulta.SQL.Clear;
         qryConsulta.SQL.Add('select * from "consulta" order by "id" DESC limit 1 ');
         qryConsulta.Open;

         qryMedico.Close;
         qryMedico.SQL.Clear;
         qryMedico.SQL.Add('SELECT "medico".* FROM "medico" ');
         qryMedico.SQL.Add('       inner join "consulta" on "medico"."id" = "consulta"."idMedico" ');
         qryMedico.SQL.Add('WHERE "consulta"."id"=:xid ');
         qryMedico.ParamByName('xid').AsInteger := qryConsulta.FieldByName('id').AsInteger;
         qryMedico.Open;

         qryPaciente.Close;
         qryPaciente.SQL.Clear;
         qryPaciente.SQL.Add('SELECT "paciente".* FROM "paciente" ');
         qryPaciente.SQL.Add('       inner join "consulta" on "paciente"."id" = "consulta"."idPaciente" ');
         qryPaciente.SQL.Add('WHERE "consulta"."id"=:xid ');
         qryPaciente.ParamByName('xid').AsInteger := qryConsulta.FieldByName('id').AsInteger;
         qryPaciente.Open;
       end;
     Result := conexao.qryConsulta.ToJSONObject();
  finally
     conexao.DesconectarBancoDados(erro);
     query.DisposeOf;
     conexao.DisposeOf;
  end;
end;

function TRepositorioConsultas.RetornaConsulta(XId: integer): TJSONObject;
var conexao: TDataModuleConexao;
    erro: string;
begin
  conexao := TDataModuleConexao.Create(nil);
  try
    conexao.ConectarBancoDados(erro);
  except
    On E: Exception do
    begin
      raise Exception.Create('Erro ao conectar banco de dados: '+E.Message);
    end;
  end;
  try
    with conexao do
    begin
      qryConsulta.close;
      qryConsulta.SQL.Clear;
      qryConsulta.SQL.Add('select * from "consulta" where "id"=:xid ');
      qryConsulta.ParamByName('xid').AsInteger := XId;
      qryConsulta.Open;

      qryMedico.Close;
      qryMedico.SQL.Clear;
      qryMedico.SQL.Add('SELECT "medico".* FROM "medico" ');
      qryMedico.SQL.Add('       inner join "consulta" on "medico"."id" = "consulta"."idMedico" ');
      qryMedico.SQL.Add('WHERE "consulta"."id"=:xid ');
      qryMedico.ParamByName('xid').AsInteger := XId;
      qryMedico.Open;

      qryPaciente.Close;
      qryPaciente.SQL.Clear;
      qryPaciente.SQL.Add('SELECT "paciente".* FROM "paciente" ');
      qryPaciente.SQL.Add('       inner join "consulta" on "paciente"."id" = "consulta"."idPaciente" ');
      qryPaciente.SQL.Add('WHERE "consulta"."id"=:xid ');
      qryPaciente.ParamByName('xid').AsInteger := XId;
      qryPaciente.Open;
    end;
    result := conexao.qryConsulta.ToJSONObject();
  finally
    conexao.DesconectarBancoDados(erro);
    conexao.DisposeOf;
  end;
end;

function TRepositorioConsultas.RetornaListaConsultas: TJSONArray;
var conexao: TDataModuleConexao;
    erro: string;
begin
  conexao := TDataModuleConexao.Create(nil);
  try
    try
      conexao.ConectarBancoDados(erro);
    except
      On E: Exception do
      begin
        raise Exception.Create('Erro ao conectar banco de dados: '+E.Message);
      end;
    end;

  // Relacionamento 1 para 1
    TDataSetSerializeConfig.GetInstance.Export.ExportChildDataSetAsJsonObject := true;

    with conexao do
    begin
      qryConsulta.close;
      qryConsulta.SQL.Clear;
      qryConsulta.SQL.Add('select * from "consulta" order by id ');
      qryConsulta.Open;

      qryMedico.Close;
      qryMedico.SQL.Clear;
      qryMedico.SQL.Add('SELECT distinct "medico".* FROM "medico" ');
      qryMedico.SQL.Add('       inner join "consulta" on "medico"."id" = "consulta"."idMedico" ');
      qryMedico.Open;

      qryPaciente.Close;
      qryPaciente.SQL.Clear;
      qryPaciente.SQL.Add('SELECT distinct "paciente".* FROM "paciente" ');
      qryPaciente.SQL.Add('       inner join "consulta" on "paciente"."id" = "consulta"."idPaciente" ');
      qryPaciente.Open;
    end;
    result := conexao.qryConsulta.ToJSONArray();
  finally
    conexao.DesconectarBancoDados(erro);
    conexao.DisposeOf;
  end;
end;
end.
