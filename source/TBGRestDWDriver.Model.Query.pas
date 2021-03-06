﻿unit TBGRestDWDriver.Model.Query;

interface

{$ifdef FPC}
  {Necessário para uso do package rtl-generics:->  Generics.Collections}
  {$MODE DELPHI}{$H+}
{$endif}

uses
  {$ifndef FPC}
  Data.DB,
  System.Classes,
  System.SysUtils,
  System.Generics.Collections,
  FireDAC.Comp.Client,
  {$else}
  DB,
  Classes,
  SysUtils,
  Generics.Collections,
  {$endif}
  uRESTDWPoolerDB,
  TBGConnection.Model.Interfaces,
  TBGConnection.Model.DataSet.Interfaces,
  TBGConnection.Model.DataSet.Proxy,
  TBGConnection.Model.DataSet.Observer,
  TBGConnection.Model.Helper;

Type

  { TRestDWModelQuery }

  TRestDWModelQuery = class(TInterfacedObject, iQuery)
  private
    FConexao: TRESTDWDataBase;
    vUpdateTableName : String;
    FKey : Integer;
    FDriver : iDriver;
    FQuery: TList<TRESTDWClientSQL>;
    FDataSource: TDataSource;
    FDataSet: TDictionary<integer, iDataSet>;
    FChangeDataSet: TChangeDataSet;
    FSQL : String;
    procedure InstanciaQuery;
    function GetDataSet : iDataSet;
    function GetQuery : TRESTDWClientSQL;
  public
    constructor Create(Conexao: TRESTDWDataBase; Driver : iDriver);
    destructor Destroy; override;
    class function New(Conexao: TRESTDWDataBase; Driver : iDriver): iQuery;
    function ThisAs: TObject;
    //iObserver
    procedure ApplyUpdates(DataSet : TDataSet);
    // iQuery
    function Open(aSQL: String): iQuery;
    function ExecSQL(aSQL: String): iQuery; overload;
    function DataSet(Value: TDataset): iQuery; overload;
    function DataSet: Tdataset; overload;
    function DataSource(Value: TDataSource): iQuery;
    function Fields: TFields;
    function ChangeDataSet(Value: TChangeDataSet): iQuery;
    function &End: TComponent;
    function Tag(Value: Integer): iQuery;
    function LocalSQL(Value: TComponent): iQuery;
    function Close : iQuery;
    function SQL : TStrings;
    function Params : TParams;
    function ExecSQL : iQuery; overload;
    function ParamByName(Value : String) : TParam;
    function UpdateTableName(Tabela : String) : iQuery;
  end;

implementation

{ TRestDWModelQuery }

function TRestDWModelQuery.&End: TComponent;
begin
  Result := GetQuery;
end;

function TRestDWModelQuery.ExecSQL: iQuery;
var
VError : String;
begin
  Result := Self;
  if not GetQuery.ExecSQL(VError) Then
     raise Exception.Create('Erro: ' + vError + sLineBreak +
	 'Ao executar o comando: ' + GetQuery.SQL.Text);
  FDriver.Cache.ReloadCache('');
//  ApplyUpdates(nil);
end;


function TRestDWModelQuery.ExecSQL(aSQL: String): iQuery;
var
  VError : String;
begin
  Result := Self;
  FSQL := UpperCase(Trim(aSQL));
  GetQuery.SQL.Text := FSQL;
  if not GetQuery.ExecSQL(VError) Then
     raise Exception.Create('Erro: ' + vError + sLineBreak +
	 'Ao executar o comando: ' + GetQuery.SQL.Text);
   FDriver.Cache.ReloadCache('');

//  ApplyUpdates(nil);
end;

function TRestDWModelQuery.Fields: TFields;
begin
  Result := GetQuery.Fields;
end;

function TRestDWModelQuery.GetDataSet : iDataSet;
begin
  Result := FDataSet.Items[FKey];
end;

function TRestDWModelQuery.GetQuery: TRESTDWClientSQL;
begin
  Result := FQuery.Items[Pred(FQuery.Count)];
end;

procedure TRestDWModelQuery.InstanciaQuery;
var
  Query : TRESTDWClientSQL;
begin
  Query := TRESTDWClientSQL.Create(nil);
  Query.DataBase := FConexao;
  Query.AfterPost := ApplyUpdates;
  Query.AfterDelete := ApplyUpdates;
  Query.AutoCommitData := False;
  Query.AutoRefreshAfterCommit := True;
  FQuery.Add(Query);
end;

function TRestDWModelQuery.LocalSQL(Value: TComponent): iQuery;
begin
  Result := Self;
  {$ifdef FPC}
  raise Exception.Create('Função não suportada por este driver');
  {$else}
  {$IFDEF RESTFDMEMTABLE}
  GetQuery.LocalSQL := TFDCustomLocalSQL(Value);
  {$ENDIF}
  {$endif}
end;

procedure TRestDWModelQuery.ApplyUpdates(DataSet: TDataSet);
var
vError : String;
begin
 if Not GetQuery.ApplyUpdates(vError) then
    raise Exception.Create(vError);
  FDriver.Cache.ReloadCache('');
end;

function TRestDWModelQuery.ChangeDataSet(Value: TChangeDataSet): iQuery;
begin
  Result := Self;
  FChangeDataSet := Value;
end;

function TRestDWModelQuery.Close: iQuery;
var
  DataSet: iDataSet;
begin
  Result := Self;
  GetQuery.Close;
  if FDriver.Cache.CacheDataSet(FSQL, DataSet) then
    DataSet.DataSet.Close;
end;

constructor TRestDWModelQuery.Create(Conexao: TRESTDWDataBase; Driver : iDriver);
begin
  FDriver := Driver;
  FConexao := Conexao;
  FQuery := TList<TRESTDWClientSQL>.Create;
  FDataSet := TDictionary<integer, iDataSet>.Create;
  InstanciaQuery;
end;

function TRestDWModelQuery.DataSet: Tdataset;
begin
  Result := GetQuery;
end;

function TRestDWModelQuery.DataSet(Value: TDataset): iQuery;
begin
  Result := Self;
  GetDataSet.DataSet(TRESTDWClientSQL(Value));
end;

function TRestDWModelQuery.DataSource(Value: TDataSource): iQuery;
begin
  Result := Self;
  FDataSource := Value;
end;

destructor TRestDWModelQuery.Destroy;
var
  vQuery: TRESTDWClientSQL;
begin
  if Assigned(FQuery) then
  begin
    for vQuery in FQuery do
    begin
      vQuery.Close;
      vQuery.Free;
    end;
  end;
  FreeAndNil(FQuery);
  FreeAndNil(FDataSet);
  inherited;
end;

class function TRestDWModelQuery.New(Conexao: TRESTDWDataBase; Driver : iDriver): iQuery;
begin
  Result := Self.Create(Conexao, Driver);
end;

function TRestDWModelQuery.ThisAs: TObject;
begin
  Result := Self;
end;

function TRestDWModelQuery.Open(aSQL: String): iQuery;
var
  DataSet : iDataSet;
begin
  Result := Self;
  FSQL := UpperCase(Trim(aSQL));
  if not FDriver.Cache.CacheDataSet(FSQL, DataSet) then
  begin
    InstanciaQuery;
    DataSet.SQL(FSQL);
    DataSet.DataSet(GetQuery);
    GetQuery.Close;
    GetQuery.UpdateTableName := vUpdateTableName;
    GetQuery.SQL.Text := FSQL;
    GetQuery.Open;
    FDriver.Cache.AddCacheDataSet(DataSet.GUUID, DataSet);
  end;
  if not DataSet.DataSet.Active then
    DataSet.DataSet.Open;
  FDataSource.DataSet := DataSet.DataSet;
  Inc(FKey);
  FDataSet.Add(FKey, DataSet);
end;

function TRestDWModelQuery.ParamByName(Value: String): TParam;
begin
  Result := GetQuery.ParamByName(Value);
end;

function TRestDWModelQuery.Params: TParams;
begin
  Result := GetQuery.Params;
end;

function TRestDWModelQuery.SQL: TStrings;
begin
  Result := GetQuery.SQL;
end;

function TRestDWModelQuery.Tag(Value: Integer): iQuery;
begin
  Result := Self;
  GetQuery.Tag := Value;
end;


function TRestDWModelQuery.UpdateTableName(Tabela : String) : iQuery;
begin
  Result := Self;
  vUpdateTableName := Tabela;
end;

end.
