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

  finally
    servico.DisposeOf;
  end;
end;

end.
