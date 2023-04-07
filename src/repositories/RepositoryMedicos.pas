{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N-,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$WARN SYMBOL_DEPRECATED ON}
{$WARN SYMBOL_LIBRARY ON}
{$WARN SYMBOL_PLATFORM ON}
{$WARN SYMBOL_EXPERIMENTAL ON}
{$WARN UNIT_LIBRARY ON}
{$WARN UNIT_PLATFORM ON}
{$WARN UNIT_DEPRECATED ON}
{$WARN UNIT_EXPERIMENTAL ON}
{$WARN HRESULT_COMPAT ON}
{$WARN HIDING_MEMBER ON}
{$WARN HIDDEN_VIRTUAL ON}
{$WARN GARBAGE ON}
{$WARN BOUNDS_ERROR ON}
{$WARN ZERO_NIL_COMPAT ON}
{$WARN STRING_CONST_TRUNCED ON}
{$WARN FOR_LOOP_VAR_VARPAR ON}
{$WARN TYPED_CONST_VARPAR ON}
{$WARN ASG_TO_TYPED_CONST ON}
{$WARN CASE_LABEL_RANGE ON}
{$WARN FOR_VARIABLE ON}
{$WARN CONSTRUCTING_ABSTRACT ON}
{$WARN COMPARISON_FALSE ON}
{$WARN COMPARISON_TRUE ON}
{$WARN COMPARING_SIGNED_UNSIGNED ON}
{$WARN COMBINING_SIGNED_UNSIGNED ON}
{$WARN UNSUPPORTED_CONSTRUCT ON}
{$WARN FILE_OPEN ON}
{$WARN FILE_OPEN_UNITSRC ON}
{$WARN BAD_GLOBAL_SYMBOL ON}
{$WARN DUPLICATE_CTOR_DTOR ON}
{$WARN INVALID_DIRECTIVE ON}
{$WARN PACKAGE_NO_LINK ON}
{$WARN PACKAGED_THREADVAR ON}
{$WARN IMPLICIT_IMPORT ON}
{$WARN HPPEMIT_IGNORED ON}
{$WARN NO_RETVAL ON}
{$WARN USE_BEFORE_DEF ON}
{$WARN FOR_LOOP_VAR_UNDEF ON}
{$WARN UNIT_NAME_MISMATCH ON}
{$WARN NO_CFG_FILE_FOUND ON}
{$WARN IMPLICIT_VARIANTS ON}
{$WARN UNICODE_TO_LOCALE ON}
{$WARN LOCALE_TO_UNICODE ON}
{$WARN IMAGEBASE_MULTIPLE ON}
{$WARN SUSPICIOUS_TYPECAST ON}
{$WARN PRIVATE_PROPACCESSOR ON}
{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_CAST OFF}
{$WARN OPTION_TRUNCATED ON}
{$WARN WIDECHAR_REDUCED ON}
{$WARN DUPLICATES_IGNORED ON}
{$WARN UNIT_INIT_SEQ ON}
{$WARN LOCAL_PINVOKE ON}
{$WARN MESSAGE_DIRECTIVE ON}
{$WARN TYPEINFO_IMPLICITLY_ADDED ON}
{$WARN RLINK_WARNING ON}
{$WARN IMPLICIT_STRING_CAST ON}
{$WARN IMPLICIT_STRING_CAST_LOSS ON}
{$WARN EXPLICIT_STRING_CAST OFF}
{$WARN EXPLICIT_STRING_CAST_LOSS OFF}
{$WARN CVT_WCHAR_TO_ACHAR ON}
{$WARN CVT_NARROWING_STRING_LOST ON}
{$WARN CVT_ACHAR_TO_WCHAR ON}
{$WARN CVT_WIDENING_STRING_LOST ON}
{$WARN NON_PORTABLE_TYPECAST ON}
{$WARN XML_WHITESPACE_NOT_ALLOWED ON}
{$WARN XML_UNKNOWN_ENTITY ON}
{$WARN XML_INVALID_NAME_START ON}
{$WARN XML_INVALID_NAME ON}
{$WARN XML_EXPECTED_CHARACTER ON}
{$WARN XML_CREF_NO_RESOLVE ON}
{$WARN XML_NO_PARM ON}
{$WARN XML_NO_MATCHING_PARM ON}
{$WARN IMMUTABLE_STRINGS OFF}
unit RepositoryMedicos;

interface

uses Horse, System.JSON, System.StrUtils, System.SysUtils, RepositoryConexao, DataSet.Serialize,
     FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.DApt,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.PG,
     FireDAC.Phys.PGDef, FireDAC.ConsoleUI.Wait, Data.DB, FireDAC.Comp.Client,
  ModelMedicos;


type
  TRepositorioMedico = class
  private
    FModelMedico: TModelMedico;
    function ValidaMedico(XMedico: TJSONObject): boolean;
  public
    function ListaMedicos(XQuery: THorseCoreParam) : TJSONArray;
    function RetornaMedico(XId: integer): TJSONObject;
    function IncluiMedico(XMedico: TJSONObject): TJSONObject;
    function AlteraMedico(XMedico: TJSONObject; XId: integer): TJSONObject;
    function ExcluiMedico(XId: integer): boolean;
  end;


implementation

{ TRepositorioMedico }

function TRepositorioMedico.AlteraMedico(XMedico: TJSONObject;  XId: integer): TJSONObject;
var conexao: TDataModuleConexao;
    erro: string;
    query,queryretorno: TFDQuery;
    numreg: integer;
begin
  if not ValidaMedico(XMedico) then
    exit;
  conexao := TDataModuleConexao.Create(nil);
  try
    conexao.ConectarBancoDados(erro);
  except
    On E: Exception do
    begin
      raise Exception.Create('Erro ao conectar o banco de dados '+E.Message);
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
      SQL.Add('update "medico" set "nome"=:xnome, "crm"=:xcrm, "especialidade"=:xespecialidade ');
      SQL.Add('where "id"=:xid ');
      ParamByName('xid').AsInteger := XId;
      ParamByName('xnome').AsString := FModelMedico.nome;
      ParamByName('xcrm').AsString  := FModelMedico.crm;
      ParamByName('xespecialidade').AsString := FModelMedico.especialidade;
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
         SQL.Add('select * from "medico" ');
         SQL.Add('where "id"=:xid ');
         ParamByName('xid').AsInteger := XId;
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

function TRepositorioMedico.ExcluiMedico(XId: integer): boolean;
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
      SQL.Add('delete from "medico" where "id"=:xid ');
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

function TRepositorioMedico.IncluiMedico(XMedico: TJSONObject): TJSONObject;
var medico: TJSONObject;
    conexao: TDataModuleConexao;
    query,queryretorno: TFDQuery;
    erro: string;
    num: integer;
begin
  if not ValidaMedico(XMedico) then
     exit;

  conexao := TDataModuleConexao.Create(nil);
  query   := TFDQuery.Create(nil);
  queryretorno := TFDQuery.Create(nil);
  try
    conexao.ConectarBancoDados(erro);
    query.Connection := conexao.FDConnection1;
    queryretorno.Connection := conexao.FDConnection1;
    with query do
    begin
      DisableControls;
      Close;
      SQL.Clear;
      Params.Clear;
      SQL.Add('insert into "medico" ("nome","crm","especialidade") ');
      SQL.Add('values(:xnome,:xcrm,:xespecialidade) ');
      ParamByName('xnome').AsString          := FModelMedico.nome;
      ParamByName('xcrm').AsString           := FModelMedico.crm;
      ParamByName('xespecialidade').AsString := FModelMedico.especialidade;
      ExecSQL;
      num := RowsAffected;
    end;

    with queryretorno do
    begin
      DisableControls;
      Close;
      SQL.Clear;
      Params.Clear;
      SQL.Add('select * from "medico" where "nome"=:xnome ');
      SQL.Add('order by "id" DESC limit 1 ');
      ParamByName('xnome').AsString := IfThen(num>0,FModelMedico.nome,'');
      Open;
      EnableControls;
    end;

    Result := queryretorno.ToJSONObject();
  finally
    query.Free;
    queryretorno.Free;
    conexao.Free;
  end;
end;

function TRepositorioMedico.ListaMedicos(XQuery: THorseCoreParam): TJSONArray;
var lista: TJSONArray;
    conexao: TDataModuleConexao;
    erro,sort,order,filtro: string;
    query: TFDQuery;
begin
  // Recupera campo de ordenação
  XQuery.TryGetValue('sort',sort);
  XQuery.TryGetValue('order',order);

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
      SQL.Add('Select * from "medico" where 1=1 ');
      if XQuery.TryGetValue('id',filtro) then   // filtro por id
         begin
           SQL.Add('and "id"=:xid ');
           ParamByName('xid').AsInteger := filtro.ToInteger();
         end;
      if XQuery.TryGetValue('nome',filtro) then // filtro por nome
         begin
           SQL.Add('and lower("nome") like lower(:xnome) ');
           ParamByName('xnome').AsString := '%'+filtro+'%';
         end;
      if XQuery.TryGetValue('crm',filtro) then // filtro por crm
         begin
           SQL.Add('and "crm"=:xcrm ');
           ParamByName('xcrm').AsString := filtro;
         end;
      if XQuery.TryGetValue('especialidade',filtro) then // filtro por especialidade
         begin
           SQL.Add('and lower("especialidade") like lower(:xespecialidade) ');
           ParamByName('xespecialidade').AsString := '%'+filtro+'%';
         end;
      if Length(sort)>0 then
         SQL.Add('Order by '+sort+' '+ifthen(order.IsEmpty,'ASC',order))
      else
         SQL.Add('Order by "id" ');
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
      SQL.Add('select * from "medico" where "id"=:xid ');
      ParamByName('xid').AsInteger := XId;
      Open;
      EnableControls;
    end;
    medico := query.ToJSONObject();
    result := medico;
  finally
    query.Free;
    conexao.DesconectarBancoDados(erro);
    conexao.Free;
  end;
end;

function TRepositorioMedico.ValidaMedico(XMedico: TJSONObject): boolean;
var nome,crm,especialidade: string;
    retorno: boolean;

begin
  if not XMedico.TryGetValue('nome',nome) then
     begin
       Result := false;
       raise Exception.Create('Campo "nome" não está presente na requisição');
     end;
  if not XMedico.TryGetValue('crm',crm) then
     begin
       Result := false;
       raise Exception.Create('Campo "crm" não está presente na requisição');
     end;
  if not XMedico.TryGetValue('especialidade',especialidade) then
     begin
       Result := false;
       raise Exception.Create('Campo "especialidade" não está presente na requisição');
     end;

  try
    FModelMedico := TModelMedico.Create;
    FModelMedico.nome := nome;
    FModelMedico.crm  := crm;
    FModelMedico.especialidade := especialidade;

    Result := true;
  except
    Result := false;
  end;

end;

end.
