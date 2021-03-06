unit uFuncionario;

interface

uses
  System.JSON,
  REST.JSON,
  System.Generics.Collections,
  FireDAC.Comp.Client,
  uConnection,
  System.SysUtils,
  uInterfacesEntity,
  uCidade,
  REST.JSON.Types;

type
  TFuncionario = class;

  TFuncionario = class(TInterfacedObject, iEntidade)
  private
    Fcodigo: integer;
    Fnome: string;
    Fendereco: string;
    Fbairro: string;
    Fnumero: string;
    Fcomplemento: string;
    Fcep: string;
    Fcpf: string;
    Frg: string;
    Ffone: string;
    Fcelular: string;
    Fdata_nasc: tdate;
    Femail: string;
    Fsalario: double;
    Fcidade: tcidade;
  public
    property codigo: integer read Fcodigo write Fcodigo;
    property nome: string read Fnome write Fnome;
    property endereco: string read Fendereco write Fendereco;
    property bairro: string read Fbairro write Fbairro;
    property numero: string read Fnumero write Fnumero;
    property complemento: string read Fcomplemento write Fcomplemento;
    property cep: string read Fcep write Fcep;
    property cpf: string read Fcpf write Fcpf;
    property rg: string read Frg write Frg;
    property fone: string read Ffone write Ffone;
    property celular: string read Fcelular write Fcelular;
    property data_nasc: tdate read Fdata_nasc write Fdata_nasc;
    property email: string read Femail write Femail;
    property salario: double read Fsalario write Fsalario;
    property cidade: tcidade read Fcidade write Fcidade;
    destructor destroy; override;
    constructor create;
    function toJson: string;
  end;

implementation

function TFuncionario.toJson: string;
begin
  result := TJson.ObjectToJsonString(self, [joIgnoreEmptyStrings]);
end;

constructor TFuncionario.create;
begin
  cidade := tcidade.create;
end;

destructor TFuncionario.destroy;
begin
  cidade.Free;
end;

end.
