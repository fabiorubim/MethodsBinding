unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TClasseBase = class
    private

    public
      function soma(a,b : integer):integer;
      //As diretivas virtual e dynamic s�o semanticamente equivalentes.
      //Enquanto virtual otimiza a velocidade, a diretiva dynamic otimiza o uso da mem�ria.
      function multiplicacao(a,b, c : integer):integer;virtual; //dynamic
      //A diretiva abstract define somente o cabe�alho do m�todo, a sua implementa��o ser� feita
      //nas classes derivadas. Como ser� necess�rio sobreescrever o m�todo nas classes derivadas,
      //este m�todo abstrado deve ser obrigatoriamente virtual ou dynamic.
      //Virtual ou dynamic deve ser declarado antes de abstract
      function subtracao(a, b: integer):integer;virtual;abstract;
      function divisao(a, b: integer):Integer;virtual;

  end;

  TClasseFilha = class(TClasseBase)
    private

    public
      //Caso o m�todo na classe base n�o esteja com a diretiva Virtual ou Dynamic,
      //o seguinte erro ir� aparece ao tentar se utilzar override:
      //[dcc32 Error] Unit1.pas(36): E2170 Cannot override a non-virtual method
      function multiplicacao(a,b, c : integer):integer;override;
      //Mesmo sendo um m�todo abstrato deve-se utilzizar o override
      //[dcc32 Error] Unit1.pas(36): E2170 Cannot override a non-virtual method
      function subtracao(a, b : integer):integer;override;
      //O uso do reintroduce serve para indicar ao compialdor que apesar do m�todo existir
      //na classe base, o mesmo ser� "reintroduzido" na classe filha, assim � poss�vel
      //criar um outro m�todo com par�metros diferentes, por exemplo. Isso � diverente de um overload,
      //pois o m�todo da classe pai n�o ser� mais poss�vel a sua autiliza��o na classe derivada.
      //O erro abaixo acontece caso n�o seja utilizado o reintroduce, pois em um override os
      //par�metros n�o podem ser trocados.
      //[dcc32 Error] Unit1.pas(55): E2037 Declaration of 'divisao' differs from previous declaration
      //function divisao(a, b, c: integer):Integer;override;
      function divisao(a, b, c: integer):Integer;reintroduce;

      //Caso tenhamos dois m�todos com o mesmo nome, o seguinte erro ser� apresentado:
      //[dcc32 Error] Unit1.pas(68): E2254 Overloaded procedure 'OlaMundo' must be marked with the 'overload' directive
      //A diretiva overload permite a sobrecarga de m�todos.
      //Com ele � poss�vel declarar m�todos de mesmo nome, desde que tenham par�metros diferentes.
      procedure OlaMundo(Msg: string); overload;
      procedure OlaMundo(Msg1, Msg2: string);overload;

  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{ TClasseBase }

function TClasseBase.divisao(a, b: integer): Integer;
begin
  Result:= a div b;
end;

function TClasseBase.multiplicacao(a, b, c: integer): integer;
begin
  Result := a * b * c;
end;

function TClasseBase.soma(a, b: integer): integer;
begin
  Result := a + b;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  oBase : TClasseBase;
begin
  oBase := TClasseBase.Create;
  try
    //Caso a linha abaixo fosse executada, o seguinte erro seria exibido:
    //raised exception class EAbstractError with message 'Abstract Error'.
    //obase.subtracao(2,4);
    ShowMessage(oBase.soma(3,2).ToString);
  finally
    oBase.Free;
  end;

end;

procedure TForm1.Button2Click(Sender: TObject);
var
  oFilha : TClasseFilha;
begin
  oFilha := TClasseFilha.Create;
  try
    //Utilizou da heran�a do m�todo soma() de TClasseBase
    ShowMessage(oFilha.multiplicacao(7,5,5).ToString);
  finally
    oFilha.Free;
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  oFilha : TClasseFilha;
begin
  oFilha := TClasseFilha.Create;
  try
    ShowMessage(oFilha.multiplicacao(3,2,2).ToString);
  finally
    oFilha.Free;
  end;

end;

procedure TForm1.Button4Click(Sender: TObject);
var
  oFilha : TClasseFilha;
begin
  oFilha := TClasseFilha.Create;
  try
    ShowMessage(oFilha.subtracao(3,2).ToString);
  finally
    oFilha.Free;
  end;

end;

procedure TForm1.Button5Click(Sender: TObject);
var
  oFilha : TClasseFilha;
begin
  oFilha := TClasseFilha.Create;
  try
    ShowMessage(oFilha.divisao(10,2, 2).ToString);
  finally
    oFilha.Free;
  end;

end;

procedure TForm1.Button6Click(Sender: TObject);
var
  oFilha : TClasseFilha;
begin
  oFilha := TClasseFilha.Create;
  try
    oFilha.OlaMundo('Ol� mundo!');
    oFilha.OlaMundo('Ol� mundo ');
  finally
    oFilha.Free;
  end;

end;

{ TClasseFilha }

function TClasseFilha.divisao(a, b, c: integer): Integer;
begin
  Result := (a div b) * c;
end;

function TClasseFilha.multiplicacao(a, b, c: integer): integer;
begin
  Result:= a * b * c;
end;

procedure TClasseFilha.OlaMundo(Msg1, Msg2: string);
begin
  ShowMessage('Msg1: ' + Msg1 + ' - ' + 'Msg2: ' + Msg2);
end;

procedure TClasseFilha.OlaMundo(Msg: string);
begin
  ShowMessage('Msg1: ' + Msg);
end;

function TClasseFilha.subtracao(a, b: integer): integer;
begin
  Result := a - b;
end;

end.

//Fonte: http://docwiki.embarcadero.com/RADStudio/Rio/en/Methods_(Delphi)#Method_Binding
