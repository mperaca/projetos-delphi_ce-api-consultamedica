unit ControllerConsultas;

interface

uses Horse, ServiceConsultas;

type
  TControllerConsulta = class
    private
    public
      procedure Registro;
  end;

implementation

{ TControllerConsulta }

procedure TControllerConsulta.Registro;
var servico: TServicoConsulta;
begin
  try
    servico := TServicoConsulta.Create;

    THorse.Get('/api.consultamedica/v1/consultas',servico.ListarConsultas);
    THorse.Get('/api.consultamedica/v1/consultas/:id',servico.RetornaConsulta);

    THorse.Post('/api.consultamedica/v1/consultas',servico.CriarConsulta);

    THorse.Put('/api.consultamedica/v1/consultas/:id',servico.AlterarConsulta);

    THorse.Delete('/api.consultamedica/v1/consultas/:id',servico.ExcluirConsulta);

    servico.GBSwagger;

  finally
    servico.DisposeOf;
  end;
end;

end.
