unit ControllerMedicos;

interface

uses Horse, Horse.GBSwagger, System.JSON, System.StrUtils, System.SysUtils, ServiceMedicos,
  ModelMedicos, Erros;

type
  TControllerMedico = class
  private
  public
    procedure Registro;
  end;

implementation

{ TControllerMedico }

procedure TControllerMedico.Registro;
var servico: TServicoMedico;
begin
  try
    servico := TServicoMedico.Create;

    THorse.Get('/api.consultamedica/v1/medicos',servico.ListarMedicos);
    THorse.Get('/api.consultamedica/v1/medicos/:id',servico.RetornaMedico);

    THorse.Post('/api.consultamedica/v1/medicos',servico.CriarMedico);

    THorse.Put('/api.consultamedica/v1/medicos/:id',servico.AlterarMedico);

    THorse.Delete('/api.consultamedica/v1/medicos/:id',servico.ExcluirMedico);

    servico.GBSwagger;

{     Swagger
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

      .Path('medicos/id')
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


    .&End;}


  finally
    servico.DisposeOf;
  end;
end;

end.
