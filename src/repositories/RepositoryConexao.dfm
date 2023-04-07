object DataModuleConexao: TDataModuleConexao
  OldCreateOrder = False
  Height = 258
  Width = 476
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
  object dsConsulta: TDataSource
    DataSet = qryConsulta
    Left = 264
    Top = 64
  end
  object dsMedico: TDataSource
    Left = 264
    Top = 120
  end
  object dsPaciente: TDataSource
    Left = 264
    Top = 184
  end
  object qryConsulta: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'select * from "consulta"'
      'order by "id"')
    Left = 352
    Top = 64
    object qryConsultaid: TLargeintField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object qryConsultadata: TDateField
      FieldName = 'data'
      Origin = 'data'
    end
    object qryConsultaidMedico: TIntegerField
      FieldName = 'idMedico'
      Origin = '"idMedico"'
      Visible = False
    end
    object qryConsultaidPaciente: TIntegerField
      FieldName = 'idPaciente'
      Origin = '"idPaciente"'
      Visible = False
    end
    object qryConsultastatus: TWideStringField
      FieldName = 'status'
      Origin = 'status'
    end
  end
  object qryMedico: TFDQuery
    IndexFieldNames = 'id'
    MasterSource = dsConsulta
    MasterFields = 'idMedico'
    DetailFields = 'id'
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT distinct "medico".* '
      
        #10'FROM "medico" inner join "consulta" on "medico"."id" = "consult' +
        'a"."idMedico"')
    Left = 352
    Top = 120
    object qryMedicoid: TLargeintField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object qryMediconome: TWideStringField
      FieldName = 'nome'
      Origin = 'nome'
      Size = 100
    end
    object qryMedicocrm: TWideStringField
      FieldName = 'crm'
      Origin = 'crm'
      Size = 10
    end
    object qryMedicoespecialidade: TWideStringField
      FieldName = 'especialidade'
      Origin = 'especialidade'
      Size = 30
    end
  end
  object qryPaciente: TFDQuery
    IndexFieldNames = 'id'
    MasterSource = dsConsulta
    MasterFields = 'idPaciente'
    DetailFields = 'id'
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT distinct "paciente".* '#10
      
        'FROM "paciente" inner join "consulta" on "paciente"."id" = "cons' +
        'ulta"."idPaciente"')
    Left = 352
    Top = 185
    object qryPacienteid: TLargeintField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object qryPacientenome: TWideStringField
      FieldName = 'nome'
      Origin = 'nome'
      Size = 100
    end
    object qryPacientedata_nascimento: TDateField
      FieldName = 'data_nascimento'
      Origin = 'data_nascimento'
    end
    object qryPacientegenero: TWideStringField
      FieldName = 'genero'
      Origin = 'genero'
      Size = 10
    end
  end
end
