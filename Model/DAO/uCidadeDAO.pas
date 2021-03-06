unit uCidadeDAO;

interface

uses
  Data.DB,
  uQuery,
  uCidade,
 uInterfacesEntity, System.SysUtils;

type
  TCidadeDAO = class(TInterfacedObject, iEntidadeDAO)
  private
  public

    class function Carrega(pCidade: TCidade): boolean;
    class function Incluir(pCidade: TCidade): boolean;
    class function Alterar(pCidade: TCidade): boolean;
    class function Excluir(pCodigo: string): boolean;
    class function Limpar(pCidade: TCidade): boolean;
    class function Existe(pCidade: TCidade): boolean;
    class function ExisteCidade(pCidade: string): integer;
    class function GeraProximoCodigo: Integer;

  end;

implementation

{ TCidadeDAO }

class function TCidadeDAO.Existe(pCidade: TCidade): boolean;
var
  lQuery: TQuery;
begin
  Result := false;

  lQuery := TQuery.Create(nil);
  try
    lQuery.SQL.Add('SELECT * FROM CIDADE WHERE CODIGO = :CODIGO');
    lQuery.ParamByName('CODIGO').AsInteger := pCidade.Codigo;
    lQuery.Open;

    if (lQuery.RecordCount > 0) then
    begin
      Result := true;
    end;
  finally
    lQuery.Free;
  end;

end;

class function TCidadeDAO.ExisteCidade(pCidade: string): integer;
var
  lQuery: TQuery;
begin

  lQuery := TQuery.Create(nil);
  try
    lQuery.SQL.Add('SELECT * FROM CIDADE WHERE CIDADE = :CIDADE');
    lQuery.ParamByName('CIDADE').AsString := pCidade;
    lQuery.Open;

    Result := lQuery.FieldByName('CODIGO').AsInteger;
  finally
    lQuery.Free;
  end;

end;

class function TCidadeDAO.GeraProximoCodigo: Integer;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    Result := 1;
    lQuery.close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add(' select gen_id(GEN_CIDADE_ID,0) from rdb$database ');
    lQuery.Open;

    if lQuery.RecordCount > 0 then
    begin
      Result := lQuery.fieldbyname('gen_id').AsInteger + 1;
    end;
  finally
    lQuery.free;
  end;

end;



class function TCidadeDAO.Alterar(pCidade: TCidade): boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add('UPDATE CIDADE SET                  ');
    lQuery.SQL.Add('     CIDADE       =:CIDADE         ');
    lQuery.SQL.Add('   , UF           =:UF             ');
    lQuery.SQL.Add('   , PAIS         =:PAIS           ');
    lQuery.SQL.Add('WHERE CODIGO      =:CODIGO         ');
    lQuery.ParamByName('CODIGO').AsInteger := pCidade.Codigo;
    lQuery.ParamByName('CIDADE').AsString := copy(pCidade.cidade, 1, 30);
    lQuery.ParamByName('UF').AsString := copy(pCidade.Uf, 1, 2);
    lQuery.ParamByName('PAIS').AsString := copy(pCidade.pais, 1, 30);
    lQuery.ExecSQL;
    lQuery.Connection.Commit;
  finally
    lQuery.Free;
  end;
end;

class function TCidadeDAO.Carrega(pCidade: TCidade): boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add('SELECT * FROM CIDADE WHERE CODIGO = :CODIGO ');
    lQuery.ParamByName('CODIGO').AsInteger := pCidade.Codigo;
    lQuery.Open;

    pCidade.cidade := lQuery.FieldByName('CIDADE').AsString;
    pCidade.Uf := lQuery.FieldByName('UF').AsString;
    pCidade.pais := lQuery.FieldByName('PAIS').AsString;
  finally
    lQuery.Free;
  end;
end;

class function TCidadeDAO.Excluir(pCodigo: string): boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add('DELETE FROM CIDADE     ');
    lQuery.SQL.Add('WHERE CODIGO =:CODIGO  ');
    lQuery.ParamByName('CODIGO').AsString := pCodigo;
    lQuery.ExecSQL;
    lQuery.Connection.Commit;
  finally
    lQuery.Free;
  end;
end;

class function TCidadeDAO.Incluir(pCidade: TCidade): boolean;
var
  lQuery: TQuery;
begin
  lQuery := TQuery.Create(nil);
  try
    lQuery.Close;
    lQuery.SQL.Clear;
    lQuery.SQL.Add('INSERT INTO CIDADE(     ');
    lQuery.SQL.Add('     CIDADE             ');
    lQuery.SQL.Add('   , UF                 ');
    lQuery.SQL.Add('   , PAIS               ');
    lQuery.SQL.Add('   ) VALUES (           ');
    lQuery.SQL.Add('     :CIDADE            ');
    lQuery.SQL.Add('   , :UF                ');
    lQuery.SQL.Add('   , :PAIS              ');
    lQuery.SQL.Add('   )                    ');
    lQuery.ParamByName('CIDADE').AsString := copy(pCidade.cidade, 1, 30);
    lQuery.ParamByName('UF').AsString := copy(pCidade.Uf, 1, 2);
    lQuery.ParamByName('PAIS').AsString := copy(pCidade.pais, 1, 30);
    lQuery.ExecSQL;
    lQuery.Connection.Commit;
  finally
    lQuery.Free;
  end;
end;

class function TCidadeDAO.Limpar(pCidade: TCidade): boolean;
begin
  pCidade.cidade := EmptyStr;
  pCidade.Uf := EmptyStr;
  pCidade.pais := EmptyStr;
end;

end.
