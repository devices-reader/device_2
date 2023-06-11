unit setup2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, yesno, StdCtrls, Buttons, ExtCtrls, Mask;

type
  TfrmSetup2 = class(TfrmYesNo)
    lblInfo: TLabel;
    rgrInfo: TRadioGroup;
    imgInfo: TImage;
    medSetTime: TMaskEdit;
    chbNow: TCheckBox;
    timNow: TTimer;
    procedure FormShow(Sender: TObject);
    procedure btbOKClick(Sender: TObject);
    procedure timNowTimer(Sender: TObject);
    procedure chbNowClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSetup2: TfrmSetup2;
  
  bSeason:   byte = 0;

implementation

uses box, get_open2;

{$R *.dfm}

procedure TfrmSetup2.FormShow(Sender: TObject);
begin
  inherited;
  rgrInfo.ItemIndex := bSeason;
end;

procedure TfrmSetup2.btbOKClick(Sender: TObject);
begin
  inherited;
  bSeason := rgrInfo.ItemIndex;
  BoxGetOpen2(acGetSetup2);
end;

procedure TfrmSetup2.timNowTimer(Sender: TObject);
begin
  inherited;
  medSetTime.Text := FormatDateTime('hh:mm:ss dd.mm.yy',Now);
end;

procedure TfrmSetup2.chbNowClick(Sender: TObject);
begin
  inherited;
  with chbNow do begin
    if Checked = False then begin
      timNow.Enabled := False;
      medSetTime.Text := '';
    end
    else 
      timNow.Enabled := True;
  end;
end;

end.
