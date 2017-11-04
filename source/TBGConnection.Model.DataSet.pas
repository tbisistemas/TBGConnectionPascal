unit TBGConnection.Model.DataSet;

interface

uses
  TBGConnection.Model.DataSet.Interfaces, Data.DB, TBGConnection.Model.DataSet.Observer;

Type
  TConnectionModelDataSet = class(TInterfacedObject, iDataSet, ICacheDataSetObserver)
    private
      FDataSet : TDataSet;
      FGUUID : String;
      FSQL : String;
    public
      constructor Create;
      destructor Destroy; override;
      class function New : iDataSet;
      function DataSet : TDataSet; overload;
      function DataSet (Value : TDataSet) : iDataSet; overload;
      function GUUID : String;
      function SQL : String; overload;
      function SQL (Value : String) : iDataSet; overload;
      function Update(Value : String) : ICacheDataSetObserver;
  end;

implementation

uses
  System.SysUtils;

{ TConnectionModelDataSet }

constructor TConnectionModelDataSet.Create;
begin
  FDataSet := TDataSet.Create(nil);
  FGUUID :=  TGUID.NewGuid.ToString;
  FDataSetObserver.AddObserver(Self);
end;

function TConnectionModelDataSet.DataSet: TDataSet;
begin
  Result := FDataSet;
end;

function TConnectionModelDataSet.DataSet(Value: TDataSet): iDataSet;
begin
  Result := Self;
  if Assigned(FDataSet) then
    FreeAndNil(FDataSet);
  FDataSet := Value;
end;

destructor TConnectionModelDataSet.Destroy;
begin
  FDataSetObserver.RemoveObserver(Self);
  FreeAndNil(FDataSet);
  inherited;
end;

function TConnectionModelDataSet.GUUID: String;
begin
  Result := FGUUID;
end;

class function TConnectionModelDataSet.New: iDataSet;
begin
  Result := Self.Create;
end;

function TConnectionModelDataSet.SQL: String;
begin
  Result := FSQL;
end;

function TConnectionModelDataSet.SQL(Value: String): iDataSet;
begin
  Result := Self;
  FSQL := Value;
end;

function TConnectionModelDataSet.Update(Value: String): ICacheDataSetObserver;
begin
  Result := Self;
  if FGUUID <> Value then
    FDataSet.Refresh;
end;

end.
