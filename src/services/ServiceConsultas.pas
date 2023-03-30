unit ServiceConsultas;

interface

uses Horse, Horse.GBSwagger, System.JSON, System.StrUtils, System.SysUtils, RepositoryConsultas,
  ModelConsultas, Erros;

type
  TServicoConsulta = class
  private
  public
    procedure RetornaConsulta(Req: THorseRequest; Res: THorseResponse);
    procedure ListarConsultas(Req: THorseRequest; Res: THorseResponse);
    procedure CriarConsulta(Req: THorseRequest; Res: THorseResponse);
    procedure AlterarConsulta(Req: THorseRequest; Res: THorseResponse);
    procedure ExcluirConsulta(Req: THorseRequest; Res: THorseResponse);

    procedure GBSwagger;
  end;

implementation

{ TServicoConsulta }

procedure TServicoConsulta.AlterarConsulta(Req: THorseRequest;
  Res: THorseResponse);
begin
  Res.Send('Alterar Consulta');
end;

procedure TServicoConsulta.CriarConsulta(Req: THorseRequest;
  Res: THorseResponse);
begin
  Res.Send('Criar Consulta');
end;

procedure TServicoConsulta.ExcluirConsulta(Req: THorseRequest;
  Res: THorseResponse);
var repositorio: TRepositorioConsultas;
begin
  Res.Send('Excluir Consulta');
end;

procedure TServicoConsulta.ListarConsultas(Req: THorseRequest;
  Res: THorseResponse);
var repositorio: TRepositorioConsultas;
begin
  repositorio := TRepositorioConsultas.Create;
  try
    Res.Send(repositorio.RetornaListaConsultas);
  finally
    repositorio.DisposeOf;
  end;
end;

procedure TServicoConsulta.RetornaConsulta(Req: THorseRequest;
  Res: THorseResponse);
var repositorio: TRepositorioConsultas;
    id: string;
begin
  repositorio := TRepositorioConsultas.Create;
  try
    Req.Params.TryGetValue('id',id);
    Res.Send<TJSONObject>(repositorio.RetornaConsulta(strtoint(id)));
  finally
    repositorio.DisposeOf;
  end;
end;

procedure TServicoConsulta.GBSwagger;
begin
  Swagger
    .BasePath('/api.consultamedica/v1')
    .Path('consultas')
      .Tag('Consulta')
      .GET('Lista todas', 'Lista todas consultas')
        .AddResponse(200, 'successful operation')
          .Schema(TModelConsulta)
          .IsArray(True)
        .&End
        .AddResponse(400, 'Bad Request')
          .Schema(TAPIError)
        .&End
        .AddResponse(500, 'Internal Server Error')
          .Schema(TAPIError)
        .&End
      .&End
      .POST('Cria consulta', 'Cria uma nova consulta')
        .AddParamBody('User data', 'User data')
          .Required(True)
          .Schema(TModelConsulta)
        .&End
        .AddResponse(201, 'Created')
          .Schema(TModelConsulta)
        .&End
        .AddResponse(400, 'Bad Request')
          .Schema(TAPIError)
        .&End
        .AddResponse(500, 'Internal Server Error')
          .Schema(TAPIError)
        .&End
      .&End
    .&End

    .Path('consultas/{id}')
      .Tag('Consulta')
      .GET('Retorna consulta', 'Retorna consulta específica')
        .AddResponse(200, 'successful operation')
          .Schema(TModelConsulta)
          .IsArray(True)
        .&End
        .AddResponse(400, 'Bad Request')
          .Schema(TAPIError)
        .&End
        .AddResponse(500, 'Internal Server Error')
          .Schema(TAPIError)
        .&End
      .&End
      .PUT('Altera consulta', 'Altera uma consulta existente')
        .AddParamBody('Dados da consulta', 'Dados da consulta')
          .Required(True)
          .Schema(TModelConsulta)
        .&End
        .AddResponse(200, 'successful operation')
          .Schema(TModelConsulta)
        .&End
        .AddResponse(400, 'Bad Request')
          .Schema(TAPIError)
        .&End
        .AddResponse(500, 'Internal Server Error')
          .Schema(TAPIError)
        .&End
      .&End
      .DELETE('Exclui consulta', 'Exclui uma consulta existente')
        .AddResponse(204, 'no content')
          .Schema(TModelConsulta)
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
