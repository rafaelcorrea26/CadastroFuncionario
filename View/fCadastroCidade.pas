unit fCadastroCidade;

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
  uFunctions,
  uquery,
  ucidadedao,
  System.ImageList,
  Vcl.ImgList,
  Vcl.DBCtrls,
  uCidade;

type
  TfrmCadastroCidade = class(TForm)
    pnlTitulo: TPanel;
    pnlModoAdm: TPanel;
    pnlRodape: TPanel;
    btnSalvar: TButton;
    pnlCentral: TPanel;
    Button1: TButton;
    edtCodigo: TEdit;
    lblCodigo: TLabel;
    Label1: TLabel;
    edtCidade: TEdit;
    Label12: TLabel;
    edtPais: TEdit;
    imlIconsBlack24dp: TImageList;
    Label2: TLabel;
    cbxUF: TComboBox;
    procedure btnSalvarClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    FModalidadeCRUD: Integer;
    FCidadeSalva: Boolean;
    { Private declarations }
    procedure Salvar;
  public
    { Public declarations }
    property ModalidadeCRUD: Integer read FModalidadeCRUD write FModalidadeCRUD;
    property CidadeSalva: Boolean read FCidadeSalva write FCidadeSalva;
  end;

var
  frmCadastroCidade: TfrmCadastroCidade;

implementation

{$R *.dfm}
{ TForm1 }

procedure TfrmCadastroCidade.btnSalvarClick(Sender: TObject);
begin
  Salvar;
end;

procedure TfrmCadastroCidade.Button1Click(Sender: TObject);
begin
  FCidadeSalva := false;
  Close;
end;

procedure TfrmCadastroCidade.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
  begin
    Key := #0;
    Perform(WM_NEXTDLGCTL, 0, 0);
  end;
end;

procedure TfrmCadastroCidade.FormShow(Sender: TObject);
begin
  WindowState := wsMaximized;
  if FModalidadeCRUD = 0 then
  begin
    edtPais.SetFocus;
  end
  else
  begin
    edtCidade.SetFocus;
  end;
end;

procedure TfrmCadastroCidade.Salvar;
var
  lCidade: TCidade;
begin
  if Trim(edtCidade.Text) = EmptyStr then
  begin
    ShowMessage('Cidade nao pode ficar em branco');
  end
  else if Trim(edtPais.Text) = EmptyStr then
  begin
    ShowMessage('Pais nao pode ficar em branco');
  end
  else if Trim(cbxUF.Text) = EmptyStr then
  begin
    ShowMessage('UF nao pode ficar em branco');
  end
  else
  begin
    lCidade := TCidade.create;
    try
      lCidade.cidade := edtCidade.Text;
      lCidade.uf := cbxUF.Text;
      lCidade.pais := edtPais.Text;

      case ModalidadeCRUD of
        0:
          begin
            tCidadedao.incluir(lCidade);
          end;
        1:
          begin
            tCidadedao.alterar(lCidade);
          end;
      end;

      FCidadeSalva := True;
      Close;
    finally
      lCidade.Free;
    end;
  end;
end;

end.
