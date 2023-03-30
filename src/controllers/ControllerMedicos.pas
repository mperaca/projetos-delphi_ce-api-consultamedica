unit ControllerMedicos;

interface

uses Horse, System.JSON, System.StrUtils, System.SysUtils, ServiceMedicos;


procedure Registro;

implementation

procedure Registro;
var servico: TServicoMedico;
begin
  try
    servico := TServicoMedico.Create;

    THorse.Get('/apiconsulta/v1/medicos',servico.ListarMedicos);

    THorse.Post('/apiconsulta/v1/medicos',servico.CriarMedico);

    THorse.Put('/apiconsulta/v1/medicos/:id',servico.AlterarMedico);

    THorse.Delete('/apiconsulta/v1/medicos/:id',servico.ExcluirMedico);

  finally
    servico.DisposeOf;
  end;
end;



end.
