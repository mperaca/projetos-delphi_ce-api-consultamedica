unit ServiceMedicos;

interface

uses Horse, Horse.Jhonson, System.JSON, System.SysUtils, System.StrUtils;

type
  TServicoMedico = class
    private
    public
      procedure ListarMedicos(Req: THorseRequest; Res: THorseResponse);
      procedure CriarMedico(Req: THorseRequest; Res: THorseResponse);
      procedure AlterarMedico(Req: THorseRequest; Res: THorseResponse);
      procedure ExcluirMedico(Req: THorseRequest; Res: THorseResponse);
  end;


implementation

{ TServicoMedico }

procedure TServicoMedico.CriarMedico(Req: THorseRequest; Res: THorseResponse);
begin
  Res.Send('Cria M�dico');
end;

procedure TServicoMedico.ListarMedicos(Req: THorseRequest; Res: THorseResponse);
begin
  Res.Send('Lista M�dicos');
end;

procedure TServicoMedico.AlterarMedico(Req: THorseRequest; Res: THorseResponse);
var id: string;
begin
  Req.Params.TryGetValue('id',id);
  Res.Send('Altera M�dico '+id);
end;

procedure TServicoMedico.ExcluirMedico(Req: THorseRequest; Res: THorseResponse);
var id: string;
begin
  Req.Params.TryGetValue('id',id);
  Res.Send('Exclui M�dico '+id);
end;

end.
