# AnonymousEvent
 Delphi Anonymous Event

### Features

Enable the use of anonymous methods as events in Delphi

### Example

	procedure TfrmPrincipal.FormCreate(Sender: TObject);
	type
	   TKeyPressEventRef = reference to procedure(Sender: TObject; var Key: Char);
	begin
	   btn1.OnClick := TAnonymousEvent < TNotifyEvent, TProc < TObject >> (
		  procedure(Sender: TObject)
		  begin
			 ShowMessage(Self.ClassName + '.' + Sender.ClassName);
		  end);

	   edt1.OnKeyPress := TAnonymousEvent<TKeyPressEvent, TKeyPressEventRef>.Create(Self,
		  procedure(Sender: TObject; var Key: Char)
		  begin
			 Key := 'A';
		  end);
	end;
