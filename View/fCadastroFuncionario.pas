unit fCadastroFuncionario;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.Mask,
  Vcl.ComCtrls,
  uFuncionario,
  uFuncionarioDAO,
  uFunctions,
  uquery,
  ucidadedao, System.ImageList, Vcl.ImgList, fCadastroCidade;

type
  TfrmCadastroFuncionario = class(TForm)
    pnlTitulo: TPanel;
    pnlModoAdm: TPanel;
    pnlRodape: TPanel;
    btnSalvar: TButton;
    pnlCentral: TPanel;
    Button1: TButton;
    edtCodigo: TEdit;
    lblCodigo: TLabel;
    Label1: TLabel;
    edtNome: TEdit;
    Label2: TLabel;
    edtEndereco: TEdit;
    Label3: TLabel;
    edtBairro: TEdit;
    Label4: TLabel;
    edtNumero: TEdit;
    Label5: TLabel;
    edtComplemento: TEdit;
    Label6: TLabel;
    edtCEP: TEdit;
    Label7: TLabel;
    edtCPF: TEdit;
    Label8: TLabel;
    edtRG: TEdit;
    Label9: TLabel;
    edtFone: TEdit;
    Label10: TLabel;
    edtCelular: TEdit;
    dtpDataNasc: TDateTimePicker;
    Label11: TLabel;
    Label12: TLabel;
    edtEmail: TEdit;
    Label13: TLabel;
    Label14: TLabel;
    edtCidade: TEdit;
    edtSalario: TEdit;
    imlIconsBlack24dp: TImageList;
    procedure edtCidadeKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnSalvarClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtSalarioKeyPress(Sender: TObject; var Key: Char);
    procedure edtSalarioExit(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    FModalidadeCRUD: Integer;
    { Private declarations }
    procedure Salvar;
    function CadastrarCidade(pCidade: string): boolean;
  public
    { Public declarations }
    property ModalidadeCRUD: Integer read FModalidadeCRUD write FModalidadeCRUD;
  end;

var
  frmCadastroFuncionario: TfrmCadastroFuncionario;

implementation

{$R *.dfm}
{ TForm1 }

procedure TfrmCadastroFuncionario.btnSalvarClick(Sender: TObject);
begin
  Salvar;
end;

procedure TfrmCadastroFuncionario.Button1Click(Sender: TObject);
begin
  Close;
end;

function TfrmCadastroFuncionario.CadastrarCidade(pCidade: string): boolean;
var
  lFormulario: TfrmCadastroCidade;
begin
  try
    lFormulario := TfrmCadastroCidade.Create(nil);
    try
      lFormulario.edtCodigo.Text := TcidadeDAO.GeraProximoCodigo.ToString;
      lFormulario.edtCidade.Text := pCidade;
      lFormulario.ModalidadeCRUD := 0;
      lFormulario.ShowModal;
      result := lFormulario.CidadeSalva;
    finally
      lFormulario.Free;
    end;
  except
    on E: Exception do
    begin
      result := false;
    end;
  end;

end;

procedure TfrmCadastroFuncionario.edtCidadeKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
Var
  Aux: Integer;
  Posicao: Integer;
  lQuery: Tquery;
begin

  Try
    lQuery := Tquery.Create(nil);
    try
      lQuery.Active := false;
      lQuery.SQL.Clear;
      If edtCidade.Text <> '' then
      begin
        lQuery.SQL.Add('SELECT * FROM CIDADE WHERE CIDADE LIKE ' + #39 + edtCidade.Text + #37 + #39 +
          ' ORDER BY CIDADE');
        lQuery.Active := True;
        If lQuery.FieldByName('CIDADE').AsString <> '' then
        begin
          Posicao := length(edtCidade.Text);
          For Aux := length(edtCidade.Text) + 1 to length(lQuery.FieldByName('CIDADE').AsString) do
          begin
            edtCidade.Text := edtCidade.Text + lQuery.FieldByName('CIDADE').AsString[Aux];
          end;
          edtCidade.SelStart := Posicao;
          edtCidade.SelLength := length(edtCidade.Text);
        end;
      end;
    finally
      lQuery.Free;
    end;
  Except
    ShowMessage('Ocorreu um erro ao utilizar o auto complete do campo cidade.');
  end;

end;

procedure TfrmCadastroFuncionario.edtSalarioExit(Sender: TObject);
var
  lValor: Double;
begin
  lValor := 0;
  if edtSalario.Text <> EmptyStr then
  begin
    if (TryStrToFloat(edtSalario.Text, lValor)) then
    begin
      edtSalario.Text := FormatFloat('#0.00', lValor);
    end
    else
    begin
      ShowMessage('Número digitado não é um valor válido.');
      edtSalario.Clear;
      edtSalario.SetFocus;
    end;
  end;
end;

procedure TfrmCadastroFuncionario.edtSalarioKeyPress(Sender: TObject; var Key: Char);
begin
  if not(Key in ['0' .. '9', ',', '.', #8, '''']) then
    Key := #0;
  if Key in ['.'] then
    Key := #44;
end;

procedure TfrmCadastroFuncionario.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
  begin
    Key := #0;
    Perform(WM_NEXTDLGCTL, 0, 0);
  end;
end;

procedure TfrmCadastroFuncionario.FormShow(Sender: TObject);
begin
  WindowState := wsMaximized;
  if FModalidadeCRUD = 0 then
  begin
    dtpDataNasc.DateTime := Now;
  end;
  edtNome.SetFocus;
end;

procedure TfrmCadastroFuncionario.Salvar;
var
  lFuncionario: Tfuncionario;
  lCidade: Integer;
  lCidadeCadastrada: boolean;
begin
  lCidadeCadastrada := True;

  if TcidadeDAO.existeCidade(edtCidade.Text) = 0 then
  begin
    if MessageDlg('Cidade Nao existe, deseja cadastrar? ', mtConfirmation, [mbyes, mbno], 0) = mryes then
    begin
      lCidadeCadastrada := CadastrarCidade(edtCidade.Text);
    end;
  end;

  if lCidadeCadastrada then
  begin
    lFuncionario := Tfuncionario.Create;
    try
      lFuncionario.Nome := edtNome.Text;
      lFuncionario.endereco := edtEndereco.Text;
      lFuncionario.bairro := edtBairro.Text;
      lFuncionario.numero := edtNumero.Text;
      lFuncionario.complemento := edtComplemento.Text;
      lFuncionario.cep := edtCEP.Text;
      lFuncionario.cpf := edtCPF.Text;
      lFuncionario.rg := edtRG.Text;
      lFuncionario.fone := edtFone.Text;
      lFuncionario.celular := edtCelular.Text;
      lFuncionario.data_nasc := dtpDataNasc.date;
      lFuncionario.email := edtEmail.Text;
      lFuncionario.salario := StrToFloatDef(edtSalario.Text, 0);

      lCidade := TcidadeDAO.existeCidade(edtCidade.Text);
      lFuncionario.cidade.codigo := lCidade;
      case ModalidadeCRUD of
        0:
          begin
            tfuncionariodao.incluir(lFuncionario);
          end;
        1:
          begin
            tfuncionariodao.alterar(lFuncionario);
          end;
      end;
    finally
      lFuncionario.Free;
    end;

    Close;
  end;
end;

end.
