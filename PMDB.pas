unit PMDB;

interface

uses
  System.SysUtils, System.Classes,
  uTPLb_CryptographicLibrary,
  uTPLb_BaseNonVisualComponent,
  uTPLb_Codec, System.inifiles, System.hash;

type
  TPassInfo = record
    Name, ID, Password: string;
  end;

type
  TPMDBFile = class(TObject)
  private
    Stream1, Stream2: TMemorystream;
    Codec1: TCodec;
    lib: TCryptographicLibrary;
    MP: string;
    MemINI: TMeminifile;
    FStream:TStream;
  public
    constructor Create(MasterPassword: string; Instream: TStream;
      new: boolean); { overload; }
  {  constructor Create(MasterPassword: string; Filename: string;
      new: boolean); overload; }
    function LoadPass(Name: string): TPassInfo;
    procedure Add(NewPassInfo: TPassInfo);
    procedure Delete(Name: string);
    function Exists(Name: string): boolean;
    procedure List(Blanklist: TStrings);
    procedure Finalize;
  //  procedure FinalizetoFile(Filename: string);
    destructor Destroy;
    property MasterPassword: string read MP write MP;
  end;

implementation

function StreamToStream(hStream1, hStream2: TStream; BufferSize: integer;
  Size: int64): int64;
var
  I: integer;
  Buff: Pointer;
  SizeIn: int64;
begin
  Result := 0;
  if Size = 0 then
    exit;
  SizeIn := 0;
  getmem(Buff, BufferSize);
  if SizeIn + BufferSize > Size then
    I := hStream1.Read(Buff^, Size - SizeIn)
  else
    I := hStream1.Read(Buff^, BufferSize);
  while I > 0 do
  begin
    hStream2.writebuffer(Buff^, I);
    Inc(SizeIn, I);
    if SizeIn >= Size then
      break;
    if SizeIn + BufferSize > Size then
      I := hStream1.Read(Buff^, Size - SizeIn)
    else
      I := hStream1.Read(Buff^, BufferSize);
  end;
  freemem(Buff);
  Result := SizeIn;
end;

procedure WriteStreamHeader(Header: string; Stream: TStream);
var
  Bytes: TBytes;
begin
  SetLength(Bytes, Length(Header));
  Bytes := Bytesof(Header);
  Stream.writebuffer(Bytes[0], Length(Bytes));
end;

function CheckStreamHeader(Header: string; Stream: TStream): boolean;
var
  Bytes: TBytes;
begin
  SetLength(Bytes, Length(Header));
  Stream.ReadBuffer(Bytes[0], Length(Bytes));
  if StringOf(Bytes) <> Header then
    Result := False
  else
    Result := True;
end;

procedure WriteInt(Int: integer; Stream: TStream);
var
  I: integer;
begin
  I := Int;
  Stream.writebuffer(I, sizeof(I));
end;

constructor TPMDBFile.Create(MasterPassword: string; Instream: TStream;
  new: boolean);
var
 // Bytes: TBytes;
  I: integer;
begin
  inherited Create;
  Stream1 := TMemorystream.Create;
  Stream2 := TMemorystream.Create;
  // Stream1.CopyFrom(Instream, 0);
  // Stream1.Position := 0;
  MP := MasterPassword;
  Fstream:=Instream;
  Codec1 := TCodec.Create(nil);
  lib := TCryptographicLibrary.Create(Nil);
  Codec1.CryptoLibrary := lib;
  Codec1.StreamCipherId := 'native.StreamToBlock';
  Codec1.BlockCipherId := 'native.AES-256';
  Codec1.ChainModeId := 'native.CBC';
  if not new then
  begin
    if not CheckStreamHeader('PMDB-RUDRA', instream) then
      raise Exception.Create('Corrupted database');
   (* SetLength(Bytes, 32);
    Instream.ReadBuffer(Bytes[0], Length(Bytes));
    if StringOf(Bytes) <> THashmd5.GetHashString(MasterPassword) then
      raise Exception.Create('Invalid password'); *)
    Instream.ReadBuffer(I, sizeof(I));
    StreamToStream(Instream, Stream2, 65536, I);
    // Stream1.Clear;
    Stream2.Position := 0;
    Codec1.Password:=MP;
    Codec1.DecryptStream(Stream1, Stream2);
    Stream2.Clear;
    Stream1.Position := 0;
  end;
  MemINI := TMeminifile.Create(Stream1);
end;

(*constructor TPMDBFile.Create(MasterPassword: string; Filename: string;
  new: boolean);
var
  FS: TFilestream;
begin
if not new then
  FS := TFilestream.Create(Filename, fmopenread)
  else
  FS := TFilestream.Create(Filename, fmcreate);
  Create(MasterPassword, FS, new);
  fs.Free;
end;     *)

procedure TPMDBFile.Add(NewPassInfo: TPassInfo);
begin
  MemINI.WriteString(NewPassInfo.Name, 'ID', NewPassInfo.ID);
  MemINI.WriteString(NewPassInfo.Name, 'Password', NewPassInfo.Password);
end;

procedure TPMDBFile.Delete(Name: string);
begin
  MemINI.EraseSection(name);
end;

function TPMDBFile.Exists(Name: string): boolean;
begin
  if MemINI.SectionExists(name) then
    Result := True
  else
    Result := False;
end;

function TPMDBFile.LoadPass(Name: string): TPassInfo;
begin
  Result.ID := MemINI.ReadString(Name, 'ID', '');
  Result.Password := MemINI.ReadString(Name, 'Password', '');
  Result.Name := Name;
end;

procedure TPMDBFile.List(Blanklist: TStrings);
begin
  MemINI.ReadSections(Blanklist);
end;

procedure TPMDBFile.Finalize;
begin
  fstream.Size:=0;
  WriteStreamHeader('PMDB-RUDRA', fstream);
//  WriteStreamHeader(THashmd5.GetHashString(MP), Outstream);
  Codec1.Reset;
  Codec1.Password:=MP;
  MemINI.UpdateFile;
  Codec1.EncryptStream(Stream1, Stream2);
  WriteInt(Stream2.Size, fstream);
  Stream2.Position := 0;
  StreamToStream(Stream2, fstream, 65536, Stream2.Size);
 // Stream2.Position:=0;
  stream2.Clear;
end;
(*
procedure TPMDBFile.FinalizetoFile(Filename: string);
var
  FS: TFilestream;
begin
  FS := TFilestream.Create(Filename, fmopenreadwrite or fmcreate);
  FinalizetoStream(FS);
  FS.Free;
end;    *)

destructor TPMDBFile.Destroy;
begin
  inherited Destroy;
  Stream1.Free;
  Stream2.Free;
  Codec1.Free;
  lib.Free;
  MemINI.Free;
end;

end.
