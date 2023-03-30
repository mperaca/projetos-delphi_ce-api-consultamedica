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
  Res.Send('Cria M�dico');
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
  Res.Send('Altera M�dico '+id);
end;

procedure TServicoMedico.ExcluirMedico(Req: THorseRequest; Res: THorseResponse);
var id: string;
begin
  Req.Params.TryGetValue('id',id);
  Res.Send('Exclui M�dico '+id);
end;

procedure TServicoMedico.GBSwagger;
begin
  Swagger
    .BasePath('/api.consultamedica/v1')
    .Path('medicos')
      .Tag('M�dico')
      .GET('Lista todos', 'Lista todos m�dicos')
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
      .POST('Cria m�dico', 'Cria um novo m�dico')
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
      .Tag('M�dico')
      .GET('Retorna m�dico', 'Retorna m�dico espec�fico')
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
      .PUT('Altera m�dico', 'Altera um m�dico existente')
        .AddParamBody('Dados do m�dico', 'Dados do m�dico')
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
      .DELETE('Exclui m�dico', 'Exclui um m�dico existente')
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
