unit ModelConsultas;

interface

type
  TModelConsulta = class
  private
    FId: integer;
    FData: TDate;
    procedure SetData(const Value: TDate);
    procedure SetId(const Value: integer);
  public
    property id: integer read FId write SetId;
    property data: TDate read FData write SetData;
  end;

implementation

{ TModelConsulta }

procedure TModelConsulta.SetData(const Value: TDate);
begin
  FData := Value;
end;

procedure TModelConsulta.SetId(const Value: integer);
begin
  FId := Value;
end;

end.
