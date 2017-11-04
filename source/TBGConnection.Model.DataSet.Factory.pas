unit TBGConnection.Model.DataSet.Factory;

interface

uses
  TBGConnection.Model.DataSet.Interfaces, TBGConnection.Model.DataSet.Proxy;

Type
  TConnectionModelDataSetFactory = class(TInterfacedObject, iDataSetFactory)
    private
    public
      constructor Create;
      destructor Destroy; override;
      class function New : iDataSetFactory;
      function DataSet : iDataSet;
  end;

implementation

uses
  TBGConnection.Model.DataSet;

{ TConnectionModelDataSetFactory }

constructor TConnectionModelDataSetFactory.Create;
begin

end;

function TConnectionModelDataSetFactory.DataSet: iDataSet;
begin
  Result := TConnectionModelDataSet.New;
  FDataSetProxy.AddCacheDataSet(Result.GUUID, Result);
end;

destructor TConnectionModelDataSetFactory.Destroy;
begin

  inherited;
end;

class function TConnectionModelDataSetFactory.New: iDataSetFactory;
begin
  Result := Self.Create;
end;

end.
