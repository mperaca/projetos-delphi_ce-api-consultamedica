unit ModelMedicos;

interface

type
  TModelMedico = class
  private
    FId: integer;
    FNome: string;
    FCrm: string;
    FEspecialidade: string;
    procedure SetId(const Value: integer);
    procedure SetNome(const Value: string);
    procedure SetCrm(const Value: string);
    procedure SetEspecialidade(const Value: string);
  public
    property id: integer read FId write SetId;
    property nome: string read FNome write SetNome;
    property crm: string read FCrm write SetCrm;
    property especialidade: string read FEspecialidade write SetEspecialidade;
  end;

implementation

{ TModelMedico }

procedure TModelMedico.SetCrm(const Value: string);
begin
  FCrm := Value;
end;

procedure TModelMedico.SetEspecialidade(const Value: string);
begin
  FEspecialidade := Value;
end;

procedure TModelMedico.SetId(const Value: integer);
begin
  FId := Value;
end;

procedure TModelMedico.SetNome(const Value: string);
begin
  FNome := Value;
end;

end.
