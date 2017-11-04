unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DataModule, Data.DB, Vcl.StdCtrls,
  TBGQuery.View.Principal, Vcl.Grids, Vcl.DBGrids, Vcl.DBCtrls;

type
  TForm1 = class(TForm)
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    TBGQuery1: TTBGQuery;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  TBGQuery1.Query.Open('SELECT RUA, NOME FROM ENDERECO INNER JOIN CLIENTE ON CLIENTE.ID = ENDERECO.IDCLIENTE');
  TBGQuery1.Query.Fields.FieldByName('RUA').DisplayWidth := 50;
  TBGQuery1.Query.Fields.FieldByName('NOME').DisplayWidth := 50;
end;

end.
