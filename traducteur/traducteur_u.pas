unit traducteur_u;

{$mode objfpc}{$H+}

interface

(* https://github.com/gcarreno/TestGoogleTranslate.git *)

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ActnList, Menus,
  StdActns, StdCtrls, ExtCtrls, fphttpclient, fpjson, jsonparser,
  opensslsockets, HTTPDefs;

type

  { TfrmMain }
  TfrmMain = class(TForm)
    AL_List: TActionList;
    BT_PTC: TButton;
    BT_Quit: TButton;
    CB_V2: TCheckBox;
    ED_SL: TEdit;
    ED_TL: TEdit;
    FE_Close: TFileExit;
    AC_Translate: TAction;
    AC_Translate2: TAction;
    BT_Translate: TButton;
    BT_Paste: TButton;
    BT_Copy: TButton;
    MM_Source: TMemo;
    MM_Target: TMemo;
    MI_Trad: TMenuItem;
    MI_Close: TMenuItem;
    MM_Menu: TMainMenu;
    procedure AC_TranslateExecute(Sender: TObject);
    procedure AC_Translate2Execute(Sender: TObject);
    procedure BT_PasteClick(Sender: TObject);
    procedure BT_CopyClick(Sender: TObject);
    procedure BT_PTCClick(Sender: TObject);
    procedure CB_V2Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    function CallGoogleTranslate(AURL: string): TJSONStringType;
  public
  end;

var
  frmMain: TfrmMain;

implementation

uses
  LCLType, Clipbrd, LazLogger;

{$R *.lfm}

  { TfrmMain }

(*
const
  CSL = 'de'; // Allemand
  CTL = 'fr'; // Français
*)

function TfrmMain.CallGoogleTranslate(AURL: string): TJSONStringType;
var
  client: TFPHTTPClient;
  doc: TStringList;
begin
  Result := EmptyStr;
  doc := TStringList.Create;
  client := TFPHTTPClient.Create(nil);
  try
    client.Get(AURL, doc);
    Result := doc.Text;
  finally
    doc.Free;
    client.Free;
  end;
end;

procedure TfrmMain.AC_TranslateExecute(Sender: TObject);
var
  URL: string;
  strResponse: TJSONStringType;
  jdResponse, jdTranslation, jdTranslationArray: TJSONData;
  jaTranslation, jaTranslationArray: TJSONArray;
  i: integer;
begin
  AC_Translate.Enabled := FALSE;
  MM_Target.Lines.BeginUpdate;
  MM_Target.Clear;
  try
    URL := Concat(
      'https://translate.googleapis.com/translate_a/single?client=gtx',
      '&q=', HTTPEncode(MM_Source.Text),
      '&sl=', ED_SL.Text,
      '&tl=', ED_TL.Text,
      '&dt=t',
      '&ie=UTF-8&oe=UTF-8'
    );
    strResponse := CallGoogleTranslate(URL);
    try
      jdResponse := GetJSON(strResponse);

      jdTranslation := jdResponse.FindPath('[0]');
      if (jdTranslation <> nil) and (jdTranslation.JSONType = jtArray) then
      begin
        jaTranslation := TJSONArray(jdTranslation);
        for i := 0 to Pred(jaTranslation.Count) do
        begin
          jdTranslationArray := jaTranslation[i];
          if (jdTranslationArray <> nil) and (jdTranslationArray.JSONType = jtArray) then
          begin
            jaTranslationArray := TJSONArray(jdTranslationArray);
            MM_Target.Append(Trim(jaTranslationArray[0].AsString));
          end;
        end;
      end;
    finally
      jdResponse.Free;
    end;
  finally
    AC_Translate.Enabled := TRUE;
  end;
  MM_Target.Lines.EndUpdate;
end;

procedure TfrmMain.AC_Translate2Execute(Sender: TObject);
const
  cJSONSentences = 'sentences';
  cJSONTranslation = 'trans';
var
  URL: string;
  strResponse: TJSONStringType;
  jdResponse: TJSONData;
  joTranslation, joSentence: TJSONObject;
  jaSentencesArray: TJSONArray;
  i: integer;
begin
  AC_Translate2.Enabled := FALSE;
  MM_Target.Lines.BeginUpdate;
  MM_Target.Clear;
  try
    URL := Concat(
      'https://translate.googleapis.com/translate_a/single?client=gtx',
      '&q=', HTTPEncode(MM_Source.Text),
      '&sl=', ED_SL.Text,
      '&tl=', ED_TL.Text,
      '&dt=t&dj=1',
      '&ie=UTF-8&oe=UTF-8'
    );
    strResponse := CallGoogleTranslate(URL);
    try
      jdResponse := GetJSON(strResponse);

      if (jdResponse <> nil) and (jdResponse.JSONType = jtObject) then
      begin
        joTranslation := TJSONObject(jdResponse);
        jaSentencesArray := TJSONArray(joTranslation.FindPath(cJSONSentences));
        for i := 0 to Pred(jaSentencesArray.Count) do
        begin
          joSentence := TJSONObject(jaSentencesArray[i]);
          MM_Target.Append(Trim(joSentence.Get(cJSONTranslation, '')));
        end;
      end;
    finally
      jdResponse.Free;
    end;
  finally
    AC_Translate2.Enabled := TRUE;
  end;
  MM_Target.Lines.EndUpdate;
end;

procedure TfrmMain.BT_PasteClick(Sender: TObject);
begin
  MM_Source.Text := Clipboard.AsText;
end;

procedure TfrmMain.BT_CopyClick(Sender: TObject);
begin
  Clipboard.AsText := Trim(MM_Target.Text);
end;

procedure TfrmMain.BT_PTCClick(Sender: TObject);
begin
  BT_Paste.Click;
  BT_Translate.Click;
  BT_Copy.Click;
end;

function IfThen(const ACondition: boolean; const AAction1, AAction2: TBasicAction): TBasicAction;
begin
  if ACondition then
    result := AAction1
  else
    result := AAction2;
end;

procedure TfrmMain.CB_V2Change(Sender: TObject);
begin
  (*
  if CB_V2.Checked then
    BT_Translate.Action := AC_Translate2
  else
    BT_Translate.Action := AC_Translate;
  *)
  BT_Translate.Action := IfThen(CB_V2.Checked, AC_Translate2, AC_Translate);
  DebugLn(Format('DEBUG Select action %s', [BT_Translate.Action.Name]))
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  {$IFDEF LINUX}
  FE_Close.ShortCut := KeyToShortCut(VK_Q, [ssCtrl]);
  {$ENDIF}
  {$IFDEF WINDOWS}
  FE_Close.ShortCut := KeyToShortCut(VK_X, [ssAlt]);
  {$ENDIF}
end;

end.
