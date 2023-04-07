program APIConsultaMedica;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Horse,
  System.JSON,
  Horse.Jhonson,
  Horse.Compression,
  Horse.HandleException,
  Horse.GBSwagger,
  Horse.BasicAuthentication,
  System.SysUtils,
  ControllerMedicos in 'src\controllers\ControllerMedicos.pas',
  ServiceMedicos in 'src\services\ServiceMedicos.pas',
  RepositoryMedicos in 'src\repositories\RepositoryMedicos.pas',
  ModelMedicos in 'src\models\ModelMedicos.pas',
  Erros in 'src\models\Erros.pas',
  RepositoryPacientes in 'src\repositories\RepositoryPacientes.pas',
  ServicePacientes in 'src\services\ServicePacientes.pas',
  ControllerPacientes in 'src\controllers\ControllerPacientes.pas',
  ControllerConsultas in 'src\controllers\ControllerConsultas.pas',
  ServiceConsultas in 'src\services\ServiceConsultas.pas',
  RepositoryConsultas in 'src\repositories\RepositoryConsultas.pas',
  ModelPacientes in 'src\models\ModelPacientes.pas',
  ModelConsultas in 'src\models\ModelConsultas.pas',
  RepositoryConexao in 'src\repositories\RepositoryConexao.pas' {DataModuleConexao: TDataModule};

var
    controllerMedico: TControllerMedico;
    controllerPaciente: TControllerPaciente;
    controllerConsulta: TControllerConsulta;

begin

  controllerMedico   := TControllerMedico.Create;
  controllerPaciente := TControllerPaciente.Create;
  controllerConsulta := TControllerConsulta.Create;

  THorse.Use(Compression(512));
  THorse.Use(Jhonson);
  THorse.Use(HorseSwagger);
  THorse.Use(HandleException);

// Verifica Autenticação (Basic Authentication)
  THorse.Use(HorseBasicAuthentication(
    function(const AUsername, APassword: string): Boolean
    begin
      // Here inside you can access your database and validate if username and password are valid
      Result := AUsername.Equals('user') and APassword.Equals('password');
    end));

{   THorse.Get('/ping',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var
      I: Integer;
      LPong: TJSONArray;
    begin
      LPong := TJSONArray.Create;
      for I := 0 to 1000 do
        LPong.Add(TJSONObject.Create(TJSONPair.Create('ping', 'pong')));
      Res.Send(LPong);
    end);}

  controllerMedico.Registro;
  controllerPaciente.Registro;
  controllerConsulta.Registro;

  THorse.Listen(9000);
end.

