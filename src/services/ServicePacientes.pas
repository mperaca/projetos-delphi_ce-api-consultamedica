unit ServicePacientes;

interface

uses Horse, Horse.Jhonson, Horse.GBSwagger, System.JSON, System.SysUtils, System.StrUtils,
   Erros, RepositoryPacientes, ModelPacientes;

type
  TServicoPaciente = class(TObject)
    private
    public
      procedure RetornaPaciente(Req: THorseRequest; Res: THorseResponse);
      procedure ListarPacientes(Req: THorseRequest; Res: THorseResponse);
      procedure CriarPaciente(Req: THorseRequest; Res: THorseResponse);
      procedure AlterarPaciente(Req: THorseRequest; Res: THorseResponse);
      procedure ExcluirPaciente(Req: THorseRequest; Res: THorseResponse);

      procedure GBSwagger;
  end;


implementation

{ TServicoPaciente }

procedure TServicoPaciente.CriarPaciente(Req: THorseRequest; Res: THorseResponse);
var repositorio: TRepositorioPaciente;
    retorno: TJSONObject;
begin
  repositorio := TRepositorioPaciente.Create;
  try
    retorno   := repositorio.CriaPaciente(Req.Body<TJSONObject>);
    if retorno.Count>0 then
       Res.Send<TJSONObject>(retorno).Status(THTTPStatus.Created)
    else
       Res.Send<TJSONObject>(retorno).Status(THTTPStatus.BadRequest);
  finally
    repositorio.DisposeOf;
  end;
end;

procedure TServicoPaciente.RetornaPaciente(Req: THorseRequest; Res: THorseResponse);
var repositorio: TRepositorioPaciente;
    id: string;
begin
  repositorio := TRepositorioPaciente.Create;
  try
    Req.Params.TryGetValue('id',id);
    Res.Send<TJSONObject>(repositorio.RetornaPaciente(StrToInt(id)));
  finally
    repositorio.DisposeOf;
  end;
end;

procedure TServicoPaciente.ListarPacientes(Req: THorseRequest; Res: THorseResponse);
var repositorio: TRepositorioPaciente;
begin
  repositorio := TRepositorioPaciente.Create;
  try
    Res.Send<TJSONArray>(repositorio.ListaPacientes(Req.Query));
  finally
    repositorio.DisposeOf;
  end;
end;

procedure TServicoPaciente.AlterarPaciente(Req: THorseRequest; Res: THorseResponse);
var id: string;
    repositorio: TRepositorioPaciente;
    retorno: TJSONObject;
begin
  Req.Params.TryGetValue('id',id);
  repositorio := TRepositorioPaciente.Create;
  try
    retorno := repositorio.AlteraPaciente(Req.Body<TJSONObject>,StrToInt(id));
    if retorno.Count>0 then
       Res.Send<TJSONObject>(retorno).Status(THTTPStatus.OK)
    else
       Res.Send<TJSONObject>(retorno).Status(THTTPStatus.BadRequest);
  finally
    repositorio.DisposeOf;
  end;
end;

procedure TServicoPaciente.ExcluirPaciente(Req: THorseRequest; Res: THorseResponse);
var id: string;
    repositorio: TRepositorioPaciente;
    retorno: boolean;
begin
  repositorio := TRepositorioPaciente.Create;
  try
    Req.Params.TryGetValue('id',id);
    if repositorio.ExcluiPaciente(StrToInt(id)) then
       Res.Send('').Status(THTTPStatus.NoContent)
    else
       Res.Send('').Status(THTTPStatus.NotFound);
  finally
    repositorio.DisposeOf;
  end;
end;

procedure TServicoPaciente.GBSwagger;
begin
  Swagger
    .BasePath('/api.consultamedica/v1')
    .Path('pacientes')
      .Tag('Paciente')
      .GET('Lista todos', 'Lista todos pacientes')
        .AddResponse(200, 'successful operation')
          .Schema(TModelPaciente)
          .IsArray(True)
        .&End
        .AddResponse(400, 'Bad Request')
          .Schema(TAPIError)
        .&End
        .AddResponse(500, 'Internal Server Error')
          .Schema(TAPIError)
        .&End
      .&End
      .POST('Cria paciente', 'Cria um novo paciente')
        .AddParamBody('User data', 'User data')
          .Required(True)
          .Schema(TModelPaciente)
        .&End
        .AddResponse(201, 'Created')
          .Schema(TModelPaciente)
        .&End
        .AddResponse(400, 'Bad Request')
          .Schema(TAPIError)
        .&End
        .AddResponse(500, 'Internal Server Error')
          .Schema(TAPIError)
        .&End
      .&End
    .&End

    .Path('pacientes/{id}')
      .Tag('Paciente')
      .GET('Retorna paciente', 'Retorna paciente específico')
        .AddResponse(200, 'successful operation')
          .Schema(TModelPaciente)
          .IsArray(True)
        .&End
        .AddResponse(400, 'Bad Request')
          .Schema(TAPIError)
        .&End
        .AddResponse(500, 'Internal Server Error')
          .Schema(TAPIError)
        .&End
      .&End
      .PUT('Altera paciente', 'Altera um paciente existente')
        .AddParamBody('Dados do paciente', 'Dados do paciente')
          .Required(True)
          .Schema(TModelPaciente)
        .&End
        .AddResponse(200, 'successful operation')
          .Schema(TModelPaciente)
        .&End
        .AddResponse(400, 'Bad Request')
          .Schema(TAPIError)
        .&End
        .AddResponse(500, 'Internal Server Error')
          .Schema(TAPIError)
        .&End
      .&End
      .DELETE('Exclui paciente', 'Exclui um paciente existente')
        .AddResponse(204, 'no content')
          .Schema(TModelPaciente)
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
