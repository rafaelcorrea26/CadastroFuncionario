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

  TCidade = class(TInterfacedObject, iCidade)
  private
    Fcodigo: string;
    Fnome: string;
    Fuf: string;
    Fcep: string;
    Faliquota: double;

  public
    property Codigo: string read Fcodigo write Fcodigo;
    property nome: string read Fnome write Fnome;
    property uf: string read Fuf write Fuf;
    property cep: string read Fcep write Fcep;
    property aliquota: double read Faliquota write Faliquota;

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
