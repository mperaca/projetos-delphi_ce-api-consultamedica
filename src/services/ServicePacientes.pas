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
begin
  Res.Send('Cria Paciente');
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
    Res.Send<TJSONArray>(repositorio.ListaPacientes);
  finally
    repositorio.DisposeOf;
  end;
end;

procedure TServicoPaciente.AlterarPaciente(Req: THorseRequest; Res: THorseResponse);
var id: string;
begin
  Req.Params.TryGetValue('id',id);
  Res.Send('Altera Paciente '+id);
end;

procedure TServicoPaciente.ExcluirPaciente(Req: THorseRequest; Res: THorseResponse);
var id: string;
begin
  Req.Params.TryGetValue('id',id);
  Res.Send('Exclui Paciente '+id);
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
