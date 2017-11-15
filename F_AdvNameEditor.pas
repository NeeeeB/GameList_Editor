unit F_AdvNameEditor;

interface

uses
   Winapi.Windows, Winapi.Messages,
   System.SysUtils, System.Variants, System.Classes,
   Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
   U_Resources, U_gnugettext, Vcl.ExtCtrls;

type
   TFrm_AdvNameEditor = class(TForm)
      Btn_Apply: TButton;
      Btn_Cancel: TButton;
      Chk_DeleteChars: TCheckBox;
      Edt_NbChars: TEdit;
      Lbl_Characters: TLabel;
      Edt_NbCharsEnd: TEdit;
      Lbl_EndChars: TLabel;
      Chk_Add: TCheckBox;
      Edt_StartString: TEdit;
      Lbl_Beginning: TLabel;
      Edt_EndString: TEdit;
      Lbl_End: TLabel;
      Edt_Preview: TEdit;
      Lbl_Preview: TLabel;
      Rdg_Case: TRadioGroup;
      Chk_Case: TCheckBox;
      procedure Chk_DeleteCharsClick(Sender: TObject);
      procedure Chk_AddClick(Sender: TObject);
      procedure Chk_CaseClick(Sender: TObject);
      procedure Edt_NbCharsChange(Sender: TObject);
      procedure Edt_NbCharsEndChange(Sender: TObject);
      procedure Edt_StartStringChange(Sender: TObject);
      procedure Edt_EndStringChange(Sender: TObject);
      procedure Rdg_CaseClick(Sender: TObject);
      procedure FormCreate(Sender: TObject);

   private
      FPreviewStr: string;
      procedure ProcessPreview;
   public
      function Execute( out aRemChars, aAddChars, aChangeCase: Boolean;
                        out aNbStart, aNbEnd, aCaseIndex: Integer;
                        out aStringStart, aStringEnd: string; const aPreview: string ): Boolean;
   end;

implementation

{$R *.dfm}

procedure TFrm_AdvNameEditor.Edt_EndStringChange(Sender: TObject);
begin
   ProcessPreview;
end;

procedure TFrm_AdvNameEditor.Edt_NbCharsChange(Sender: TObject);
begin
   ProcessPreview;
end;

procedure TFrm_AdvNameEditor.Edt_NbCharsEndChange(Sender: TObject);
begin
   ProcessPreview;
end;

procedure TFrm_AdvNameEditor.Edt_StartStringChange(Sender: TObject);
begin
   ProcessPreview;
end;

procedure TFrm_AdvNameEditor.Rdg_CaseClick(Sender: TObject);
begin
   ProcessPreview;
end;

function TFrm_AdvNameEditor.Execute( out aRemChars, aAddChars, aChangeCase: Boolean;
                                     out aNbStart, aNbEnd, aCaseIndex: Integer;
                                     out aStringStart, aStringEnd: string; const aPreview: string ): Boolean;
begin
   FPreviewStr:= aPreview;
   Edt_Preview.Text:= FPreviewStr;
   ShowModal;
   Result:= ( ModalResult = mrOk );
   if ( ModalResult = mrOk ) then begin
      aRemChars:= Chk_DeleteChars.Checked;
      aAddChars:= Chk_Add.Checked;
      aChangeCase:= Chk_Case.Checked;
      aCaseIndex:= Rdg_Case.ItemIndex;
      aStringStart:= Edt_StartString.Text;
      aStringEnd:= Edt_EndString.Text;
      if ( Edt_NbChars.Text = '' ) then aNbStart:= 0
      else aNbStart:= StrToInt( Edt_NbChars.Text );
      if ( Edt_NbCharsEnd.Text = '' ) then aNbEnd:= 0
      else aNbEnd:= StrToInt( Edt_NbCharsEnd.Text );
   end;
end;

procedure TFrm_AdvNameEditor.FormCreate(Sender: TObject);
begin
   TranslateComponent( Self );
end;

procedure TFrm_AdvNameEditor.Chk_AddClick(Sender: TObject);
begin
   Edt_StartString.Enabled:= Chk_Add.Checked;
   Edt_EndString.Enabled:= Chk_Add.Checked;
   Lbl_Beginning.Enabled:= Chk_Add.Checked;
   Lbl_End.Enabled:= Chk_Add.Checked;
   ProcessPreview;
end;

procedure TFrm_AdvNameEditor.Chk_CaseClick(Sender: TObject);
begin
   Rdg_Case.Enabled:= Chk_Case.Checked;
   Rdg_Case.ItemIndex:= -1;
   ProcessPreview;
end;

procedure TFrm_AdvNameEditor.Chk_DeleteCharsClick(Sender: TObject);
begin
   Edt_NbChars.Enabled:= Chk_DeleteChars.Checked;
   Edt_NbCharsEnd.Enabled:= Chk_DeleteChars.Checked;
   Lbl_Characters.Enabled:= Chk_DeleteChars.Checked;
   Lbl_EndChars.Enabled:= Chk_DeleteChars.Checked;
   ProcessPreview;
end;

procedure TFrm_AdvNameEditor.ProcessPreview;
var
   NbStart, NbEnd: Integer;
   TmpStr: string;
begin
   Edt_Preview.Text:= FPreviewStr;
   TmpStr:= FPreviewStr;

   if Chk_DeleteChars.Checked then begin
      if ( Edt_NbChars.Text <> '' ) then begin
         NbStart:= StrToInt( Edt_NbChars.Text );
         TmpStr:= Copy( TmpStr, Succ( NbStart ), ( TmpStr.Length - NbStart ) );
      end;
      if ( Edt_NbCharsEnd.Text <> '' ) then begin
         NbEnd:= StrToInt( Edt_NbCharsEnd.Text );
         SetLength( TmpStr, TmpStr.Length - NbEnd );
      end;
   end;

   if Chk_Case.Checked then begin
      case Rdg_Case.ItemIndex of
         0: begin
            TmpStr[1]:= UpCase( TmpStr[1] );
         end;
         1: begin
            TmpStr:= UpperCase( TmpStr );
         end;
         2: begin
            TmpStr:= LowerCase( TmpStr );
         end;
      end;
   end;

   if Chk_Add.Checked then begin
      if ( Edt_StartString.Text <> '' ) then begin
         TmpStr:= Edt_StartString.Text + TmpStr;
      end;
      if ( Edt_EndString.Text <> '' ) then begin
         TmpStr:= TmpStr + Edt_EndString.Text;
      end;

   end;

   Edt_Preview.Text:= TmpStr;
end;

end.
