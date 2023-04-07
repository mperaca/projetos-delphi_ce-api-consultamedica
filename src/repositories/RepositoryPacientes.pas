unit RepositoryPacientes;

interface

uses Horse, System.JSON, System.StrUtils, System.SysUtils, RepositoryConexao, FireDAC.Comp.Client, DataSet.Serialize,
  ModelPacientes;


type
  TRepositorioPaciente = class
  private
    FPaciente: TModelPaciente;
    function ValidaPaciente(XPaciente: TJSONObject): boolean;
    function RetornaData(XData: string): TDate;
  public
    function ListaPacientes(XQuery: THorseCoreParam): TJSONArray;
    function RetornaPaciente(XId: integer): TJSONObject;
    function CriaPaciente(XPaciente: TJSONObject): TJSONObject;
    function AlteraPaciente(XPaciente: TJSONObject; XId: integer): TJSONObject;
    function ExcluiPaciente(XId: integer): boolean;
  end;


implementation

{ TRepositorioPaciente }

function TRepositorioPaciente.RetornaData(XData: string): TDate;
var ano,mes,dia: word;
begin
  ano    := strtoint(copy(XData,1,4));
  mes    := strtoint(copy(XData,6,2));
  dia    := strtoint(copy(XData,9,2));
  Result := EncodeDate(ano,mes,dia);
end;

function TRepositorioPaciente.ValidaPaciente(XPaciente: TJSONObject): boolean;
var nome,genero,datanascimento: string;
begin
  if not XPaciente.TryGetValue('nome',nome) then
     begin
       Result := false;
       raise Exception.Create('Campo "nome" não está presente na requisição');
     end;
  if not XPaciente.TryGetValue('genero',genero) then
     begin
       Result := false;
       raise Exception.Create('Campo "genero" não está presente na requisição');
     end;
  if not XPaciente.TryGetValue('dataNascimento',datanascimento) then
     begin
       Result := false;
       raise Exception.Create('Campo "dataNascimento" não está presente na requisição');
     end;
  FPaciente                 := TModelPaciente.Create;
  FPaciente.nome            := nome;
  FPaciente.genero          := genero;
  FPaciente.data_nascimento := RetornaData(datanascimento);

  Result := true;
end;

function TRepositorioPaciente.AlteraPaciente(XPaciente: TJSONObject;
  XId: integer): TJSONObject;
var conexao: TDataModuleConexao;
    query,queryretorno: TFDQuery;
    erro: string;
    numreg: integer;
begin
  if not ValidaPaciente(XPaciente) then
     exit;
  conexao := TDataModuleConexao.Create(nil);
  try
    conexao.ConectarBancoDados(erro);
  except
    On E: Exception do
    begin
      raise Exception.Create('Erro ao conectar banco de dados '+E.Message);
    end;
  end;
  query := TFDQuery.Create(nil);
  queryretorno := TFDQuery.Create(nil);
  try
    with query do
    begin
      Connection := conexao.FDConnection1;
      DisableControls;
      Close;
      SQL.Clear;
      Params.Clear;
      SQL.Add('update "paciente" set "nome"=:xnome, "genero"=:xgenero, "data_nascimento"=:xdatanascimento ');
      SQL.Add('where "id"=:xid ');
      ParamByName('xid').AsInteger    := XId;
      ParamByName('xnome').AsString   := FPaciente.nome;
      ParamByName('xgenero').AsString := FPaciente.genero;
      ParamByName('xdatanascimento').AsDate := FPaciente.data_nascimento;
      ExecSQL;
      EnableControls;
      numreg := RowsAffected;
    end;
    if numreg>0 then
       with queryretorno do
       begin
         Connection := conexao.FDConnection1;
         DisableControls;
         Close;
         SQL.Clear;
         Params.Clear;
         SQL.Add('select * from "paciente" where "id"=:xid ');
         ParamByName('xid').AsInteger  := XId;
         Open;
         EnableControls;
       end;
    Result := queryretorno.ToJSONObject();
  finally
    conexao.DesconectarBancoDados(erro);
    conexao.DisposeOf;
    query.DisposeOf;
    queryretorno.DisposeOf;
  end;
end;

function TRepositorioPaciente.CriaPaciente(XPaciente: TJSONObject): TJSONObject;
var conexao: TDataModuleConexao;
    query,queryretorno: TFDQuery;
    erro: string;
    numreg: integer;
begin
  if not ValidaPaciente(XPaciente) then
     exit;
  conexao := TDataModuleConexao.Create(nil);
  try
    conexao.ConectarBancoDados(erro);
  except
    on E: Exception do
    begin
      raise Exception.Create('Problema ao conectar banco de dados '+E.Message);
    end;
  end;
  query := TFDQuery.Create(nil);
  queryretorno := TFDQuery.Create(nil);
  try
    with query do
    begin
      Connection := conexao.FDConnection1;
      DisableControls;
      Close;
      SQL.Clear;
      SQL.Add('insert into "paciente" ("nome","genero","data_nascimento") ');
      SQL.Add('values (:xnome,:xgenero,:xdatanascimento) ');
      ParamByName('xnome').AsString   := FPaciente.nome;
      ParamByName('xgenero').AsString := FPaciente.genero;
      ParamByName('xdatanascimento').AsDate := FPaciente.data_nascimento;
      ExecSQL;
      EnableControls;
      numreg := RowsAffected;
    end;
    if numreg>0 then
       with queryretorno do
       begin
         Connection := conexao.FDConnection1;
         DisableControls;
         Close;
         SQL.Clear;
         SQL.Add('select * from "paciente" ');
         SQL.Add('order by "id" DESC limit 1 ');
         Open;
         EnableControls;
       end;

    Result := queryretorno.ToJSONObject();
  finally
    conexao.DesconectarBancoDados(erro);
    conexao.DisposeOf;
    query.DisposeOf;
    queryretorno.DisposeOf;
  end;
end;

function TRepositorioPaciente.ExcluiPaciente(XId: integer): boolean;
var conexao: TDataModuleConexao;
    query: TFDQuery;
    erro: string;
    numreg: integer;
begin
  conexao := TDataModuleConexao.Create(nil);
  try
    conexao.ConectarBancoDados(erro);
  except
    On E: Exception do
    begin
      raise Exception.Create('Erro ao conectar banco de dados '+E.Message);
    end;
  end;
  query := TFDQuery.Create(nil);
  try
    with query do
    begin
      Connection := conexao.FDConnection1;
      DisableControls;
      Close;
      SQL.Clear;
      Params.Clear;
      SQL.Add('delete from "paciente" where "id"=:xid ');
      ParamByName('xid').AsInteger := XId;
      ExecSQL;
      EnableControls;
      numreg := RowsAffected;
    end;
    Result := numreg>0;
  finally
    conexao.DesconectarBancoDados(erro);
    conexao.DisposeOf;
    query.DisposeOf;
  end;
end;

function TRepositorioPaciente.ListaPacientes(XQuery: THorseCoreParam): TJSONArray;
var conexao: TDataModuleConexao;
    query: TFDQuery;
    erro,sort,order,filtro: string;
begin
  // Recupera campos de ordenação
  XQuery.TryGetValue('sort',sort);
  XQuery.TryGetValue('order',order);

  conexao := TDataModuleConexao.Create(nil);
  try
    conexao.ConectarBancoDados(erro);
  except
    on E: Exception do
    begin
      raise Exception.Create('Problema ao conectar no banco de dados');
    end;
  end;
  query := TFDQuery.Create(nil);
  try
    with query do
    begin
      Connection := conexao.FDConnection1;
      DisableControls;
      Close;
      SQL.Clear;
      SQL.Add('select * from "paciente" where 1=1 ');
      if XQuery.TryGetValue('id',filtro) then   // filtro por id
         begin
           SQL.Add('and "id"=:xid ');
           ParamByName('xid').AsInteger := filtro.ToInteger();
         end;
      if XQuery.TryGetValue('nome',filtro) then   // filtro por nome
         begin
           SQL.Add('and lower("nome") like lower(:xnome) ');
           ParamByName('xnome').AsString := '%'+filtro+'%';
         end;
      if XQuery.TryGetValue('genero',filtro) then   // filtro por genero
         begin
           SQL.Add('and lower("genero") like lower(:xgenero) ');
           ParamByName('xgenero').AsString := '%'+filtro+'%';
         end;
      if XQuery.TryGetValue('data_nascimento',filtro) then   // filtro por data nascimento
         begin
           SQL.Add('and "data_nascimento" =:xdatanascimento ');
           ParamByName('xdatanascimento').AsDate := StrToDate(filtro);
         end;
      if Length(sort)>0 then
         SQL.Add('Order by '+sort+' '+ifthen(order.IsEmpty,'ASC',order))
      else
         SQL.Add('Order by "id" ');
      Open;
      EnableControls;
    end;

    result := query.ToJSONArray();
  finally
    conexao.DesconectarBancoDados(erro);
    conexao.DisposeOf;
  end;
end;

function TRepositorioPaciente.RetornaPaciente(XId: Integer): TJSONObject;
var conexao: TDataModuleConexao;
    query: TFDQuery;
    erro: string;
begin
  conexao := TDataModuleConexao.Create(nil);
  query   := TFDQuery.Create(nil);
  try
    with query do
    begin
      Connection := conexao.FDConnection1;
      DisableControls;
      Close;
      SQL.Clear;
      Params.Clear;
      SQL.Add('select * from "paciente" where "id"=:xid ');
      ParamByName('xid').AsInteger := XId;
      Open;
      EnableControls;
    end;
    result := query.ToJSONObject();
  finally
    conexao.DesconectarBancoDados(erro);
    conexao.DisposeOf;
    query.DisposeOf;
  end;
end;
end.
