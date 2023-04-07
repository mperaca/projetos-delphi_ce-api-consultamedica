unit ServiceMedicos;

interface

uses Horse, Horse.Jhonson, Horse.GBSwagger, System.JSON, System.SysUtils, System.StrUtils,
  RepositoryMedicos, ModelMedicos, Erros;

type
  TServicoMedico = class(TObject)
    private
    public
      procedure RetornaMedico(Req: THorseRequest; Res: THorseResponse);
      procedure ListarMedicos(Req: THorseRequest; Res: THorseResponse);
      procedure CriarMedico(Req: THorseRequest; Res: THorseResponse);
      procedure AlterarMedico(Req: THorseRequest; Res: THorseResponse);
      procedure ExcluirMedico(Req: THorseRequest; Res: THorseResponse);

      procedure GBSwagger;
  end;


implementation

{ TServicoMedico }

procedure TServicoMedico.CriarMedico(Req: THorseRequest; Res: THorseResponse);
var newmedico,medico: TJSONObject;
    repositorio: TRepositorioMedico;

begin
  medico := Req.Body<TJSONObject>;
  repositorio := TRepositorioMedico.Create;
  try
    newmedico := repositorio.IncluiMedico(medico);
    if newmedico.Count>0 then
       Res.Send<TJSONObject>(newmedico).Status(THTTPStatus.Created)
    else
       Res.Send<TJSONObject>(newmedico).Status(THTTPStatus.InternalServerError);
  finally
    repositorio.DisposeOf;
  end;


  Res.Send('Cria Médico '+medico.GetValue('nome').ToString);
end;

procedure TServicoMedico.RetornaMedico(Req: THorseRequest; Res: THorseResponse);
var repositorio: TRepositorioMedico;
    id: string;
    medico: TJSONObject;
begin
  repositorio := TRepositorioMedico.Create;
  try
    Req.Params.TryGetValue('id',id);
    medico := repositorio.RetornaMedico(StrToInt(id));
    if medico.Count>0 then
       Res.Send<TJSONObject>(medico)
    else
       Res.Send<TJSONObject>(medico).Status(THTTPStatus.NotFound);
  finally
    repositorio.DisposeOf;
  end;
end;

procedure TServicoMedico.ListarMedicos(Req: THorseRequest; Res: THorseResponse);
var repositorio: TRepositorioMedico;
    value: string;
    listamedicos: TJSONArray;
begin
  repositorio := TRepositorioMedico.Create;
  try
    listamedicos := repositorio.ListaMedicos(Req.Query);
    if listamedicos.Count>0 then
       Res.Send<TJSONArray>(listamedicos)
    else
       Res.Send<TJSONArray>(listamedicos).Status(THTTPStatus.NotFound);
  finally
    repositorio.DisposeOf;
  end;
end;

procedure TServicoMedico.AlterarMedico(Req: THorseRequest; Res: THorseResponse);
var id: string;
    repositorio: TRepositorioMedico;
    retorno: TJSONObject;
begin
  Req.Params.TryGetValue('id',id);
  repositorio := TRepositorioMedico.Create;
  try
    retorno := repositorio.AlteraMedico(Req.Body<TJSONObject>,StrToInt(id));
    if retorno.Count>0 then
       Res.Send<TJSONObject>(retorno).Status(THTTPStatus.OK)
    else
       Res.Send<TJSONObject>(retorno).Status(THTTPStatus.BadRequest);
  finally
    repositorio.DisposeOf;
  end;
end;

procedure TServicoMedico.ExcluirMedico(Req: THorseRequest; Res: THorseResponse);
var id: string;
    repositorio: TRepositorioMedico;
begin
  Req.Params.TryGetValue('id',id);
  repositorio := TRepositorioMedico.Create;
  try
    if repositorio.ExcluiMedico(StrToInt(id)) then
       Res.Send('').Status(THTTPStatus.NoContent)
    else
       Res.Send('').Status(THTTPStatus.NotFound);
  finally
    repositorio.DisposeOf;
  end;
end;

procedure TServicoMedico.GBSwagger;
begin
  Swagger
    .BasePath('/api.consultamedica/v1')
    .Path('medicos')
      .Tag('Médico')
      .GET('Lista todos', 'Lista todos médicos')
        .AddParamQuery('id','Filtro pelo campo "id"')
          .Required(False)
        .&End
        .AddParamQuery('nome','Filtro pelo campo "nome"')
          .Required(False)
        .&End
        .AddParamQuery('crm','Filtro pelo campo "crm"')
          .Required(False)
        .&End
        .AddParamQuery('crm','Filtro pelo campo "especialidade"')
          .Required(False)
        .&End
        .AddParamQuery('sort','Campo para ordenação')
          .Required(False)
        .&End
        .AddParamQuery('order','Ordem da pesquisa (ASC/DESC)')
          .Required(False)
        .&End
        .AddResponse(200, 'successful operation')
          .Schema(TModelMedico)
          .IsArray(True)
        .&End
        .AddResponse(400, 'Bad Request')
          .Schema(TAPIError)
        .&End
        .AddResponse(500, 'Internal Server Error')
          .Schema(TAPIError)
        .&End
      .&End
      .POST('Cria médico', 'Cria um novo médico')
        .AddParamBody('User data', 'User data')
          .Required(True)
          .Schema(TModelMedico)
        .&End
        .AddResponse(201, 'Created')
          .Schema(TModelMedico)
        .&End
        .AddResponse(400, 'Bad Request')
          .Schema(TAPIError)
        .&End
        .AddResponse(500, 'Internal Server Error')
          .Schema(TAPIError)
        .&End
      .&End
    .&End

    .Path('medicos/{id}')
      .Tag('Médico')
      .GET('Retorna médico', 'Retorna médico específico')
        .AddParamQuery('id','Filtro pelo campo "id"')
          .Required(False)
        .&End
        .AddParamQuery('nome','Filtro pelo campo "nome"')
          .Required(False)
        .&End
        .AddParamQuery('crm','Filtro pelo campo "crm"')
          .Required(False)
        .&End
        .AddParamQuery('crm','Filtro pelo campo "especialidade"')
          .Required(False)
        .&End
        .AddParamQuery('sort','Campo para ordenação')
          .Required(False)
        .&End
        .AddParamQuery('order','Ordem da pesquisa (ASC/DESC)')
          .Required(False)
        .&End
        .AddResponse(200, 'successful operation')
          .Schema(TModelMedico)
          .IsArray(True)
        .&End
        .AddResponse(400, 'Bad Request')
          .Schema(TAPIError)
        .&End
        .AddResponse(500, 'Internal Server Error')
          .Schema(TAPIError)
        .&End
      .&End
      .PUT('Altera médico', 'Altera um médico existente')
        .AddParamBody('Dados do médico', 'Dados do médico')
          .Required(True)
          .Schema(TModelMedico)
        .&End
        .AddResponse(200, 'successful operation')
          .Schema(TModelMedico)
        .&End
        .AddResponse(400, 'Bad Request')
          .Schema(TAPIError)
        .&End
        .AddResponse(500, 'Internal Server Error')
          .Schema(TAPIError)
        .&End
      .&End
      .DELETE('Exclui médico', 'Exclui um médico existente')
        .AddResponse(204, 'no content')
          .Schema(TModelMedico)
        .&End
        .AddResponse(400, 'Bad Request')
          .Schema(TAPIError)
        .&End
        .AddResponse(500, 'Internal Server Error')
          .Schema(TAPIError)
        .&End
      .&End
    .&End
  .&End;
end;

end.
