﻿unit TBGRestDWDriver.Model.Conexao;

interface

uses
  {$ifndef FPC}
  System.Classes,
  Data.DB,
  System.SysUtils,
  {$else}
  Classes,
  DB,
  SysUtils,
  {$endif}
  uRESTDWPoolerDB,
  TBGConnection.Model.Interfaces,
  TBGConnection.Model.DataSet.Interfaces;

Type

  { TRestDWDriverModelConexao }

  TRestDWDriverModelConexao = class(TInterfacedObject, iConexao)
    private
      FConnection : TRESTDWDataBase;
    public
      constructor Create(Connection : TRestDWDataBase);
      destructor Destroy; override;
      class function New(Connection : TRestDWDataBase) : iConexao;
      function ThisAs: TObject;
      //iConexao
      function Conectar : iConexao;
      function &End: TComponent;
      function Connection : TComponent;
      function StartTransaction : iConexao;
      function RollbackTransaction : iConexao;
      function Commit : iConexao;
  end;

implementation

uses
  TBGConnection.Model.DataSet.Proxy;

{ TRestDWDriverModelConexao }

function TRestDWDriverModelConexao.Commit: iConexao;
begin
  Result := Self;
  raise Exception.Create('Função não suportada por este driver');
end;

function TRestDWDriverModelConexao.Conectar: iConexao;
begin
  Result := Self;
  FConnection.Connected := true;
end;

function TRestDWDriverModelConexao.&End: TComponent;
begin
  Result := FConnection;
end;

function TRestDWDriverModelConexao.Connection: TComponent;
begin
  Result := FConnection;
end;

constructor TRestDWDriverModelConexao.Create(Connection : TRestDWDataBase);
begin
  FConnection := Connection;
end;

destructor TRestDWDriverModelConexao.Destroy;
begin

  inherited;
end;

class function TRestDWDriverModelConexao.New(Connection : TRestDWDataBase) : iConexao;
begin
  Result := Self.Create(Connection);
end;

function TRestDWDriverModelConexao.ThisAs: TObject;
begin
  Result := Self;
end;

function TRestDWDriverModelConexao.RollbackTransaction: iConexao;
begin
  Result := Self;
  raise Exception.Create('Função não suportada por este driver');
end;

function TRestDWDriverModelConexao.StartTransaction: iConexao;
begin
  Result := Self;
  raise Exception.Create('Função não suportada por este driver');
end;

end.
