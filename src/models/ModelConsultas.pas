unit ModelConsultas;

interface

uses ModelMedicos, ModelPacientes;

type
  TModelConsulta = class
  private
    FId: integer;
    FData: TDate;
    FMedico: TModelMedico;
    FPaciente: TModelPaciente;
    FStatus: string;
    procedure SetData(const Value: TDate);
    procedure SetId(const Value: integer);
    procedure SetMedico(const Value: TModelMedico);
    procedure SetPaciente(const Value: TModelPaciente);
    procedure SetStatus(const Value: string);
  public
    constructor Create;
    property id: integer read FId write SetId;
    property data: TDate read FData write SetData;
    property status: string read FStatus write SetStatus;
    property medico: TModelMedico read FMedico write SetMedico;
    property paciente: TModelPaciente read FPaciente write SetPaciente;
  end;

implementation

{ TModelConsulta }

constructor TModelConsulta.Create;
begin
  FMedico   := TModelMedico.Create;
  FPaciente := TModelPaciente.Create;
end;

procedure TModelConsulta.SetData(const Value: TDate);
begin
  FData := Value;
end;

procedure TModelConsulta.SetId(const Value: integer);
begin
  FId := Value;
end;

procedure TModelConsulta.SetMedico(const Value: TModelMedico);
begin
  FMedico := Value;
end;

procedure TModelConsulta.SetPaciente(const Value: TModelPaciente);
begin
  FPaciente := Value;
end;

procedure TModelConsulta.SetStatus(const Value: string);
begin
  FStatus := Value;
end;

end.
