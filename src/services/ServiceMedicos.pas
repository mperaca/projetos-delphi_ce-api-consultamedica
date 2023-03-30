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
begin
  Res.Send('Cria Médico');
end;

procedure TServicoMedico.RetornaMedico(Req: THorseRequest; Res: THorseResponse);
var repositorio: TRepositorioMedico;
    id: string;
begin
  repositorio := TRepositorioMedico.Create;
  try
    Req.Params.TryGetValue('id',id);
    Res.Send<TJSONObject>(repositorio.RetornaMedico(StrToInt(id)));
  finally
    repositorio.DisposeOf;
  end;
end;

procedure TServicoMedico.ListarMedicos(Req: THorseRequest; Res: THorseResponse);
var repositorio: TRepositorioMedico;
begin
  repositorio := TRepositorioMedico.Create;
  try
    Res.Send<TJSONArray>(repositorio.ListaMedicos);
  finally
    repositorio.DisposeOf;
  end;
end;

procedure TServicoMedico.AlterarMedico(Req: THorseRequest; Res: THorseResponse);
var id: string;
begin
  Req.Params.TryGetValue('id',id);
  Res.Send('Altera Médico '+id);
end;

procedure TServicoMedico.ExcluirMedico(Req: THorseRequest; Res: THorseResponse);
var id: string;
begin
  Req.Params.TryGetValue('id',id);
  Res.Send('Exclui Médico '+id);
end;

procedure TServicoMedico.GBSwagger;
begin
  Swagger
    .BasePath('/api.consultamedica/v1')
    .Path('medicos')
      .Tag('Médico')
      .GET('Lista todos', 'Lista todos médicos')
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
