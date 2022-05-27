program CadastroFuncionarios;

uses
  Vcl.Forms,
  fPrincipal in 'View\fPrincipal.pas' {frmPrincipal},
  uInterfacesEntity in 'Interfaces\uInterfacesEntity.pas',
  uFunctions in 'Shared\uFunctions.pas',
  uMessages in 'Shared\uMessages.pas',
  uQuery in 'Model\uQuery.pas',
  uConnection in 'Model\uConnection.pas',
  uCidadeDAO in 'Model\DAO\uCidadeDAO.pas',
  uFuncionarioDAO in 'Model\DAO\uFuncionarioDAO.pas',
  uCidade in 'Model\Entity\uCidade.pas',
  uFuncionario in 'Model\Entity\uFuncionario.pas',
  fCadastroFuncionario in 'View\fCadastroFuncionario.pas' {frmCadastroFuncionario},
  fCadastroCidade in 'View\fCadastroCidade.pas' {frmCadastroCidade};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TfrmCadastroFuncionario, frmCadastroFuncionario);
  Application.CreateForm(TfrmCadastroCidade, frmCadastroCidade);
  Application.Run;
end.
