unit ModelPacientes;

interface

type
  TModelPaciente = class
  private
    FGenero: string;
    FId: integer;
    FDataNascimento: TDate;
    FNome: string;
    procedure SetDataNascimento(const Value: TDate);
    procedure SetGenero(const Value: string);
    procedure SetId(const Value: integer);
    procedure SetNome(const Value: string);
  public
    property id: integer read FId write SetId;
    property nome: string read FNome write SetNome;
    property data_nascimento: TDate read FDataNascimento write SetDataNascimento;
    property genero: string read FGenero write SetGenero;
  end;
implementation

{ TModelPaciente }

procedure TModelPaciente.SetDataNascimento(const Value: TDate);
begin
  FDataNascimento := Value;
end;

procedure TModelPaciente.SetGenero(const Value: string);
begin
  FGenero := Value;
end;

procedure TModelPaciente.SetId(const Value: integer);
begin
  FId := Value;
end;

procedure TModelPaciente.SetNome(const Value: string);
begin
  FNome := Value;
end;

end.
