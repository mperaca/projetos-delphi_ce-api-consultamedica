program APIConsultaMedica;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Horse,
  System.JSON,
  Horse.Jhonson,
  Horse.Compression,
  Horse.BasicAuthentication,
  System.SysUtils,
  ControllerMedicos in 'src\controllers\ControllerMedicos.pas',
  ServiceMedicos in 'src\services\ServiceMedicos.pas',
  RepositoryMedicos in 'src\repositories\RepositoryMedicos.pas';

var usuarios: TJSONArray;
    controllerMedico: TControllerMedico;

begin

  usuarios         := TJSONArray.Create;
  controllerMedico := TControllerMedico.Create;

  THorse.Use(Compression());
  THorse.Use(Jhonson);

// Verifica Autenticação (Basic Authentication)
  THorse.Use(HorseBasicAuthentication(
    function(const AUsername, APassword: string): Boolean
    begin
      // Here inside you can access your database and validate if username and password are valid
      Result := AUsername.Equals('user') and APassword.Equals('password');
    end));

  controllerMedico.Registro;

  THorse.Listen(9000);
end.

