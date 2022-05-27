unit uFuncionarioDAO;

interface

uses

  uCidadeDAO,
  uQuery,
  System.SysUtils,
  Vcl.Dialogs,
  Data.DB,
  uFunctions,
  uCidade,
  uFuncionario,
  REST.JSON.Types,
  uInterfacesEntity;

type
  TFuncionarioDAO = class(TInterfacedObject, iEntidadeDAO)
  public
    class function Limpar(pFuncionario: TFuncionario): Boolean;
    class function Carrega(pFuncionario: TFuncionario): Boolean;
    class function Incluir(pFuncionario: TFuncionario): Boolean;
    class function Alterar(pFuncionario: TFuncionario): Boolean;
    class function Excluir(pCodigo: Integer): Boolean;

    class function Existe(pCodigo: Integer): Boolean;
    class function ExisteCPF(pCPF: string): Integer;
    class function GeraProximoCodigo: Integer;

  end;

implementation

{ TFuncionarioDAO }
class function TFuncionarioDAO.Alterar(pFuncionario: TFuncionario): Boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' UPDATE FUNCIONARIO set                            ');
    lQuery.SQL.Add('   NOME = :NOME,                                   ');
    lQuery.SQL.Add('   ENDERECO = :ENDERECO,                           ');
    lQuery.SQL.Add('   BAIRRO = :BAIRRO,                               ');
    lQuery.SQL.Add('   NUMERO = :NUMERO,                               ');
    lQuery.SQL.Add('   COMPLEMENTO = :COMPLEMENTO,                     ');
    lQuery.SQL.Add('   CEP = :CEP,                                     ');
    lQuery.SQL.Add('   CPF = :CPF,                                     ');
    lQuery.SQL.Add('   RG = :RG,                                       ');
    lQuery.SQL.Add('   FONE = :FONE,                                   ');
    lQuery.SQL.Add('   CELULAR = :CELULAR,                             ');
    lQuery.SQL.Add('   DATA_NASC = :DATA_NASC,                         ');
    lQuery.SQL.Add('   EMAIL = :EMAIL,                                 ');
    lQuery.SQL.Add('   SALARIO = :SALARIO,                             ');
    lQuery.SQL.Add('   CIDADE = :CIDADE                                ');
    lQuery.SQL.Add('   where (CODIGO = :CODIGO)                        ');

    lQuery.ParamByName('CODIGO').AsInteger := pFuncionario.Codigo;
    lQuery.ParamByName('NOME').AsString := Copy(pFuncionario.Nome, 1, 50);
    lQuery.ParamByName('ENDERECO').AsString := Copy(pFuncionario.endereco, 1, 30);
    lQuery.ParamByName('BAIRRO').AsString := Copy(pFuncionario.bairro, 1, 30);
    lQuery.ParamByName('NUMERO').AsString := Copy(pFuncionario.numero, 1, 15);
    lQuery.ParamByName('COMPLEMENTO').AsString := Copy(pFuncionario.complemento, 1, 30);
    lQuery.ParamByName('CEP').AsString := Copy(pFuncionario.cep, 1, 10);
    lQuery.ParamByName('CPF').AsString := Copy(pFuncionario.cpf, 1, 11);
    lQuery.ParamByName('RG').AsString := Copy(pFuncionario.rg, 1, 10);
    lQuery.ParamByName('FONE').AsString := Copy(pFuncionario.fone, 1, 15);
    lQuery.ParamByName('CELULAR').AsString := Copy(pFuncionario.celular, 1, 15);
    lQuery.ParamByName('DATA_NASC').asdate := pFuncionario.data_nasc;
    lQuery.ParamByName('EMAIL').AsString := Copy(pFuncionario.email, 1, 50);
    lQuery.ParamByName('SALARIO').asfloat := pFuncionario.salario;
    lQuery.ParamByName('CIDADE').AsInteger := pFuncionario.cidade.Codigo;
    lQuery.ExecSql;
    lQuery.connection.commit;
  finally
    lQuery.free;
  end;

end;

class function TFuncionarioDAO.Carrega(pFuncionario: TFuncionario): Boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' SELECT * FROM FUNCIONARIO WHERE CODIGO = :CODIGO ');
    lQuery.ParamByName('CODIGO').AsInteger := pFuncionario.Codigo;
    lQuery.Open;

    if lQuery.RecordCount > 0 then
    begin
      pFuncionario.Nome := lQuery.fieldbyname('NOME').AsString;
      pFuncionario.endereco := lQuery.fieldbyname('ENDERECO').AsString;
      pFuncionario.bairro := lQuery.fieldbyname('BAIRRO').AsString;
      pFuncionario.numero := lQuery.fieldbyname('NUMERO').AsString;
      pFuncionario.complemento := lQuery.fieldbyname('COMPLEMENTO').AsString;
      pFuncionario.cep := lQuery.fieldbyname('CEP').AsString;
      pFuncionario.cpf := lQuery.fieldbyname('CPF').AsString;
      pFuncionario.rg := lQuery.fieldbyname('RG').AsString;
      pFuncionario.fone := lQuery.fieldbyname('FONE').AsString;
      pFuncionario.celular := lQuery.fieldbyname('CELULAR').AsString;
      pFuncionario.data_nasc := lQuery.fieldbyname('DATA_NASC').asdatetime;
      pFuncionario.email := lQuery.fieldbyname('EMAIL').AsString;
      pFuncionario.salario := lQuery.fieldbyname('SALARIO').asfloat;
      pFuncionario.cidade.Codigo := lQuery.fieldbyname('CIDADE').AsInteger;

      if (pFuncionario.cidade.Codigo > 0) then
      begin
        TCidadeDAO.Carrega(pFuncionario.cidade);
      end;
    end;

    Result := (lQuery.RecordCount > 0);

  finally
    lQuery.free;
  end;

end;

class function TFuncionarioDAO.Excluir(pCodigo: Integer): Boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add('DELETE FROM FUNCIONARIO          ');
    lQuery.SQL.Add('  WHERE CODIGO = :CODIGO ');
    lQuery.ParamByName('CODIGO').AsInteger := pCodigo;
    lQuery.ExecSql;
    lQuery.connection.commit;
  finally
    lQuery.free;
  end;
end;

class function TFuncionarioDAO.Existe(pCodigo: Integer): Boolean;
var
  lQuery: TQuery;
begin
  Result := false;
  lQuery := TQuery.Create(nil);
  try
    lQuery.SQL.Add('SELECT * FROM FUNCIONARIO WHERE CODIGO = :CODIGO');
    lQuery.ParamByName('CODIGO').AsInteger := pCodigo;
    lQuery.Open;

    if (lQuery.RecordCount > 0) then
    begin
      Result := true;
    end;
  finally
    lQuery.free;
  end;
end;

class function TFuncionarioDAO.ExisteCPF(pCPF: string): Integer;
var
  lQuery: TQuery;
begin
  Result := 0;

  lQuery := TQuery.Create(nil);
  try
    lQuery.SQL.Add('SELECT * FROM FUNCIONARIO WHERE CPF = :CPF');
    lQuery.ParamByName('CPF').AsString := pCPF;
    lQuery.Open;

    if (lQuery.RecordCount > 0) then
    begin
      Result := lQuery.fieldbyname('CODIGO').AsInteger;
    end;
  finally
    lQuery.free;
  end;

end;

class function TFuncionarioDAO.GeraProximoCodigo: Integer;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    Result := 1;
    lQuery.close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' select gen_id(GEN_FUNCIONARIO_ID,0) from rdb$database ');
    lQuery.Open;

    if lQuery.RecordCount > 0 then
    begin
      Result := lQuery.fieldbyname('gen_id').AsInteger + 1;
    end;
  finally
    lQuery.free;
  end;

end;

class function TFuncionarioDAO.Incluir(pFuncionario: TFuncionario): Boolean;
var
  lQuery: TQuery;
begin

  lQuery := TQuery.Create(nil);
  try
    lQuery.close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' INSERT INTO FUNCIONARIO (              ');
    lQuery.SQL.Add('   NOME                                 ');
    lQuery.SQL.Add(' , ENDERECO                             ');
    lQuery.SQL.Add(' , BAIRRO                               ');
    lQuery.SQL.Add(' , NUMERO                               ');
    lQuery.SQL.Add(' , COMPLEMENTO                          ');
    lQuery.SQL.Add(' , CEP                                  ');
    lQuery.SQL.Add(' , CPF                                  ');
    lQuery.SQL.Add(' , RG                                   ');
    lQuery.SQL.Add(' , FONE                                 ');
    lQuery.SQL.Add(' , CELULAR                              ');
    lQuery.SQL.Add(' , DATA_NASC                            ');
    lQuery.SQL.Add(' , EMAIL                                ');
    lQuery.SQL.Add(' , SALARIO                              ');
    lQuery.SQL.Add(' , CIDADE                               ');
    lQuery.SQL.Add(' )                                      ');
    lQuery.SQL.Add(' values (                               ');
    lQuery.SQL.Add('   :NOME                                ');
    lQuery.SQL.Add(' , :ENDERECO                            ');
    lQuery.SQL.Add(' , :BAIRRO                              ');
    lQuery.SQL.Add(' , :NUMERO                              ');
    lQuery.SQL.Add(' , :COMPLEMENTO                         ');
    lQuery.SQL.Add(' , :CEP                                 ');
    lQuery.SQL.Add(' , :CPF                                 ');
    lQuery.SQL.Add(' , :RG                                  ');
    lQuery.SQL.Add(' , :FONE                                ');
    lQuery.SQL.Add(' , :CELULAR                             ');
    lQuery.SQL.Add(' , :DATA_NASC                           ');
    lQuery.SQL.Add(' , :EMAIL                               ');
    lQuery.SQL.Add(' , :SALARIO                             ');
    lQuery.SQL.Add(' , :CIDADE                              ');
    lQuery.SQL.Add(' )                                      ');
    lQuery.ParamByName('NOME').AsString := Copy(pFuncionario.Nome, 1, 50);
    lQuery.ParamByName('ENDERECO').AsString := Copy(pFuncionario.endereco, 1, 30);
    lQuery.ParamByName('BAIRRO').AsString := Copy(pFuncionario.bairro, 1, 30);
    lQuery.ParamByName('NUMERO').AsString := Copy(pFuncionario.numero, 1, 15);
    lQuery.ParamByName('COMPLEMENTO').AsString := Copy(pFuncionario.complemento, 1, 30);
    lQuery.ParamByName('CEP').AsString := Copy(pFuncionario.cep, 1, 10);
    lQuery.ParamByName('CPF').AsString := Copy(pFuncionario.cpf, 1, 11);
    lQuery.ParamByName('RG').AsString := Copy(pFuncionario.rg, 1, 10);
    lQuery.ParamByName('FONE').AsString := Copy(pFuncionario.fone, 1, 15);
    lQuery.ParamByName('CELULAR').AsString := Copy(pFuncionario.celular, 1, 15);
    lQuery.ParamByName('DATA_NASC').asdate := pFuncionario.data_nasc;
    lQuery.ParamByName('EMAIL').AsString := Copy(pFuncionario.email, 1, 50);
    lQuery.ParamByName('SALARIO').asfloat := pFuncionario.salario;
    lQuery.ParamByName('CIDADE').AsInteger := pFuncionario.cidade.Codigo;
    lQuery.ExecSql;
    lQuery.connection.commit;
  finally
    lQuery.free;
  end;
end;

class function TFuncionarioDAO.Limpar(pFuncionario: TFuncionario): Boolean;
begin

end;

end.
