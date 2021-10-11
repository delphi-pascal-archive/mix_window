unit Mw;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    Image1: TImage;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  DesktopBitmap   : TBitmap;
  gx, gy          : Integer;
  redRect         : TBitmap;
  rW, rH          : Integer;

const
  Delta=8;//число квадратов на которые будет разбито окно (должно быть 2*n)

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);

procedure InitScreen;
var
 i:integer;
begin
//получаем битмап десктопа
 DesktopBitmap:=TBitmap.Create;
 with DesktopBitmap do
  begin
   Width:=Screen.Width;
   Height:=Screen.Height;
  end;
 BitBlt(DesktopBitmap.Canvas.Handle,
                 0,0,Screen.Width,Screen.Height,
                            GetDC(GetDesktopWindow),0,0,SrcCopy);
 Form1.Image1.Picture.Bitmap:=DesktopBitmap;
 //изначальные координаты redRect
 Randomize;
 gx:=Trunc(Random*Delta);
 gy:=Trunc(Random*Delta);
 Form1.Image1.Canvas.CopyRect(
            Rect(rW*gx, rH*gy, rW*gx+rW, rH*gy+rH),
                                 redRect.Canvas, Rect(0,0,rW,rH));
 //рисуем сетку
 for i:=0 to DELTA-1 do
  begin
   Form1.Image1.Canvas.MoveTo(rW*i,0);
   Form1.Image1.Canvas.LineTo(rW*i,Screen.Height);
   Form1.Image1.Canvas.MoveTo(0, rH*i);
   Form1.Image1.Canvas.LineTo(Screen.Width, rH*i);
  end;
end;

begin
 ShowCursor(False);
 SystemParametersInfo(SPI_SCREENSAVERRUNNING,1,0,0); 
 //SystemParametersInfo(spi_ScreenSaverRunning,1,@Dummy,0);
 Button1.Cancel:=true;//выход на "Esc"
 //Panel1.Left:=Button1.Left-10;
 //Panel1.Top:=Button1.Top-10;
 rW:=Screen.Width div Delta;
 rH:=Screen.Height div Delta;
 redRect:=TBitmap.Create;
 with redRect do
  begin
   Width:=rW;
   Height:=rH;
   Canvas.Brush.Color:=clRed;
   Canvas.Brush.Style:=bssolid;
   Canvas.Rectangle(0,0,rW,rH);
   Canvas.Font.Color:=clNavy;
   Canvas.Font.Style:=Canvas.Font.Style+[fsBold];
   Canvas.TextOut(2,2,'About');
   Canvas.Font.Style:=Canvas.Font.Style-[fsBold];
   Canvas.TextOut(2,17,'Delphi');
   Canvas.TextOut(2,32,'Programming');
  end;
 Timer1.Enabled:=False;
 Image1.Align:=alClient;
 Visible:=False;
 BorderStyle:=bsNone;
 Top:=0;
 Left:=0;
 Width:=Screen.Width;
 Height:=Screen.Height;
 InitScreen;
 Visible:=True;
 Timer1.Interval:=10; // меньше-быстрее
 Timer1.Enabled:=True; // Запускаем вызов DrawScreen
end;

procedure TForm1.Timer1Timer(Sender: TObject);

procedure DrawScreen;
var
 r1,r2:TRect;
 Direction:integer;
begin
 r1:=Rect(rW*gx , rH*gy,  rW*gx+rW  , rH*gy+rH);
 Direction:=Trunc(Random*4);
  case Direction of
   0: gx:=Abs((gx+1) mod Delta);    //право
   1: gx:=Abs((gx-1) mod Delta);    //лево
   2: gy:=Abs((gy+1) mod Delta);    //низ
   3: gy:=Abs((gy-1) mod Delta);    //верх
  end; //case
 r2:=Rect(rW*gx , rH*gy,  rW*gx+rW  , rH*gy+rH);
 with Form1.Image1.Canvas do
  begin
   CopyRect(r1, Form1.Image1.Canvas, r2);
   CopyRect(r2, redRect.Canvas, redRect.Canvas.ClipRect);
  end;
end;

begin
 DrawScreen;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 ShowCursor(True);
 Close;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 SystemParametersInfo(SPI_SCREENSAVERRUNNING,0,0,0);
end;

end.
