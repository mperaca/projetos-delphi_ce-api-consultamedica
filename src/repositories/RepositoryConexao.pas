unit RepositoryConexao;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.PG,
  FireDAC.Phys.PGDef, FireDAC.ConsoleUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
  FireDAC.DApt;

type
  TDataModuleConexao = class(TDataModule)
    FDConnection1: TFDConnection;
    FDPhysPgDriverLink1: TFDPhysPgDriverLink;
    dsConsulta: TDataSource;
    dsMedico: TDataSource;
    dsPaciente: TDataSource;
    qryConsulta: TFDQuery;
    qryMedico: TFDQuery;
    qryMedicoid: TLargeintField;
    qryMediconome: TWideStringField;
    qryMedicocrm: TWideStringField;
    qryMedicoespecialidade: TWideStringField;
    qryConsultaid: TLargeintField;
    qryConsultadata: TDateField;
    qryConsultaidMedico: TIntegerField;
    qryConsultaidPaciente: TIntegerField;
    qryConsultastatus: TWideStringField;
    qryPaciente: TFDQuery;
    qryPacienteid: TLargeintField;
    qryPacientenome: TWideStringField;
    qryPacientedata_nascimento: TDateField;
    qryPacientegenero: TWideStringField;
  private
    { Private declarations }
  public
    function ConectarBancoDados(out erro: string): boolean;
    function DesconectarBancoDados(out erro: string): boolean;
    { Public declarations }
  end;

var
  DataModuleConexao: TDataModuleConexao;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

{ TDataModuleConexao }

function TDataModuleConexao.ConectarBancoDados(out erro: string): boolean;
begin
  try
    FDConnection1.Connected := true;
    Result := true;
  except
    On E: Exception do
    begin
      erro := 'Erro ao conectar banco de dados: '+E.Message;
      Result := false;
    end;
  end;
end;

function TDataModuleConexao.DesconectarBancoDados(out erro: string): boolean;
begin
  try
    FDConnection1.Connected := false;
    Result := true;
  except
    On E: Exception do
    begin
      erro := 'Erro ao desconectar banco de dados: '+E.Message;
      Result := false;
    end;
  end;
end;

end.
