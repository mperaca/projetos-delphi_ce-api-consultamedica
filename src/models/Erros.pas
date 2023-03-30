unit Erros;

interface

type
  TAPIError = class
  private
    FError: string;
    procedure SetError(const Value: string);
  public
    property error: string read FError write SetError;

  end;

implementation

{ TAPIError }

procedure TAPIError.SetError(const Value: string);
begin
  FError := Value;
end;

end.
