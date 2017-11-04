unit TBGZeosDriver.Model.Query;

interface

uses
  TBGConnection.Model.Interfaces, Data.DB, System.Classes,
  System.SysUtils, ZConnection, ZDataset;

Type
  TZeosModelQuery = class(TInterfacedObject, iQuery)
    private
      FConexao : TZConnection;
      FQuery : TZQuery;
      FDataSource : TDataSource;
      FDataSet : TDataSet;
    public
      constructor Create(Conexao : TZConnection);
      destructor Destroy; override;
      class function New(Conexao : TZConnection) : iQuery;
      //iQuery
      function Open(aSQL: String): iQuery;
      function ExecSQL(aSQL : String) : iQuery;
      function DataSet : TDataSet; overload;
      function DataSet(Value : TDataSet) : iQuery; overload;
      function DataSource(Value : TDataSource) : iQuery;
      function Fields : TFields;
      function &End: TComponent;
      function Tag(Value : Integer) : iQuery;
      function LocalSQL(Value : TComponent) : iQuery;
  end;

implementation

{ TZeosModelQuery }

function TZeosModelQuery.&End: TComponent;
begin
  Result := FQuery;
end;

function TZeosModelQuery.ExecSQL(aSQL: String): iQuery;
begin
  FQuery.SQL.Clear;
  FQuery.SQL.Add(aSQL);
  FQuery.ExecSQL;
end;

function TZeosModelQuery.Fields: TFields;
begin
  Result := FQuery.Fields;
end;

function TZeosModelQuery.LocalSQL(Value: TComponent): iQuery;
begin
  Result := Self;
  raise Exception.Create('Fun��o n�o suportada por este driver');
end;

constructor TZeosModelQuery.Create(Conexao : TZConnection);
begin
  FConexao := Conexao;
  FQuery := TZQuery.Create(nil);
  FQuery.Connection := FConexao;
end;

function TZeosModelQuery.DataSet: TDataSet;
begin
  Result := TDataSet(FQuery);
end;

function TZeosModelQuery.DataSet(Value: TDataSet): iQuery;
begin
  Result := Self;
  FDataSet := Value;
end;

function TZeosModelQuery.DataSource(Value : TDataSource) : iQuery;
begin
  Result := Self;
  FDataSource := Value;
end;

destructor TZeosModelQuery.Destroy;
begin
  FreeAndNil(FQuery);
  inherited;
end;

class function TZeosModelQuery.New(Conexao : TZConnection) : iQuery;
begin
  Result := Self.Create(Conexao);
end;

function TZeosModelQuery.Open(aSQL: String): iQuery;
begin

  if not (Assigned(FDataSource) or Assigned(FDataSet))then
    raise Exception.Create('N�o Foi Instanciado um Container DataSet/DataSource');

  if Assigned(FDataSource) then
    FDataSource.DataSet := FQuery;

  if Assigned(FDataSet) then
    FDataSet := FQuery;

  Result := Self;
  FQuery.Close;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(aSQL);
  FQuery.Open;


end;

function TZeosModelQuery.Tag(Value: Integer): iQuery;
begin
  Result := Self;
  FQuery.Tag := Value;
end;

end.
