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
  ServiceMedicos in 'src\services\ServiceMedicos.pas';

var usuarios: TJSONArray;

begin

  usuarios := TJSONArray.Create;

  THorse.Use(Compression());
  THorse.Use(Jhonson);

  THorse.Use(HorseBasicAuthentication(
    function(const AUsername, APassword: string): Boolean
    begin
      // Here inside you can access your database and validate if username and password are valid
      Result := AUsername.Equals('user') and APassword.Equals('password');
    end));

  ControllerMedicos.Registro;

  THorse.Listen(9000);
end.

