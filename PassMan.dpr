program PassMan;
{$WEAKLINKRTTI ON}
{$RTTI EXPLICIT METHODS([]) PROPERTIES([]) FIELDS([])}
uses
  System.StartUpCopy,
  FMX.Forms,
  TabbedTemplate in 'TabbedTemplate.pas' {TabbedForm},
  PMDB in 'PMDB.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TTabbedForm, TabbedForm);
  Application.Run;
end.
