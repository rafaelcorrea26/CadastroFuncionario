unit uCidade;

interface

uses
  System.JSON,
  REST.JSON,
  System.Generics.Collections,
  FireDAC.Comp.Client,
  uConnection,
  System.SysUtils,
  uInterfacesEntity,
  REST.JSON.Types;

type
  TCidade = class;

  TCidade = class(TInterfacedObject, iEntidade)
  private
    Fcodigo: integer;
    Fcidade: string;
    Fuf: string;
    Fpais: string;

  public
    property codigo: integer read Fcodigo write Fcodigo;
    property cidade: string read Fcidade write Fcidade;
    property uf: string read Fuf write Fuf;
    property pais: string read Fpais write Fpais;

    destructor Destroy; override;
    constructor Create;

    function ToJson: string;
  end;

implementation

destructor TCidade.Destroy;
begin

  inherited;
end;

function TCidade.ToJson: string;
begin
  result := TJson.ObjectToJsonString(self, [joIgnoreEmptyStrings]);
end;

constructor TCidade.Create;
begin

end;

end.
