unit ControllerMedicos;

interface

uses Horse, System.JSON, System.StrUtils, System.SysUtils, ServiceMedicos;

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

    THorse.Get('/apiconsulta/v1/medicos',servico.ListarMedicos);
    THorse.Get('/apiconsulta/v1/medicos/:id',servico.RetornaMedico);

    THorse.Post('/apiconsulta/v1/medicos',servico.CriarMedico);

    THorse.Put('/apiconsulta/v1/medicos/:id',servico.AlterarMedico);

    THorse.Delete('/apiconsulta/v1/medicos/:id',servico.ExcluirMedico);

  finally
    servico.DisposeOf;
  end;
end;

end.
