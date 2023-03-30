unit ControllerPacientes;

interface

uses Horse, Horse.GBSwagger, System.JSON, System.StrUtils, System.SysUtils, ServicePacientes;

type
  TControllerPaciente = class
  private
  public
    procedure Registro;
  end;

implementation

{ TControllerPaciente }

procedure TControllerPaciente.Registro;
var servico: TServicoPaciente;
begin
  try
    servico := TServicoPaciente.Create;

    THorse.Get('/api.consultamedica/v1/pacientes',servico.ListarPacientes);
    THorse.Get('/api.consultamedica/v1/pacientes/:id',servico.RetornaPaciente);

    THorse.Post('/api.consultamedica/v1/pacientes',servico.CriarPaciente);

    THorse.Put('/api.consultamedica/v1/pacientes/:id',servico.AlterarPaciente);

    THorse.Delete('/api.consultamedica/v1/pacientes/:id',servico.ExcluirPaciente);

    servico.GBSwagger;

  finally
    servico.DisposeOf;
  end;
end;

end.
