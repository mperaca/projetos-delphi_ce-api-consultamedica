object DataModuleConexao: TDataModuleConexao
  OldCreateOrder = False
  Height = 258
  Width = 349
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=API'
      'User_Name=postgres'
      'Password=postgres'
      'Server=192.168.1.200'
      'Port=5433'
      'DriverID=PG')
    Connected = True
    LoginPrompt = False
    Left = 64
    Top = 24
  end
  object FDPhysPgDriverLink1: TFDPhysPgDriverLink
    VendorLib = 'D:\ProDelphiCE\API_ConsultasMedicas\src\resources\libpq.dll'
    Left = 64
    Top = 104
  end
end
