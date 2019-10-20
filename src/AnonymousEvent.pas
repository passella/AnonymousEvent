{
   Copyright:
   (c) 2019, Paulo Henrique de Freitas Passella
   (passella@gmail.com)

   All credits go to:
   Barry Kelly (http://blog.barrkel.com/2010/01/using-anonymous-methods-in-method.html)
}
unit AnonymousEvent;

interface

uses
   System.Classes, IdDayTime;

type
   TAnonymousEvent<T, P> = record
   private
      event: P;
      owner: TComponent;
   public type
      TAnonymousEvent = class(TComponent)
      private
         class var root: TComponent;
      private
         event: P;
         function GetEvent(): T;
      public
         class constructor Create();
         class destructor Destroy;
         constructor Create(const owner: TComponent; const event: P); reintroduce;
      end;
   public
      constructor Create(const owner: TComponent; const event: P); overload;
      constructor Create(const event: P); overload;

      class operator Implicit(Event: TAnonymousEvent<T, P>): T;
      class operator Implicit(Event: P): TAnonymousEvent<T, P>;
   end;

implementation

uses
   System.SysUtils;

{ TAnonymousEvent<T, P>.TAnonymousEvent }

constructor TAnonymousEvent<T, P>.TAnonymousEvent.Create(const owner: TComponent; const event: P);
begin
   inherited Create(owner);
   Self.event := event;
end;

class constructor TAnonymousEvent<T, P>.TAnonymousEvent.Create;
begin
   TAnonymousEvent<T, P>.TAnonymousEvent.root := TComponent.Create(nil);
end;

class destructor TAnonymousEvent<T, P>.TAnonymousEvent.Destroy;
begin
   if Assigned(TAnonymousEvent<T, P>.TAnonymousEvent.root) then
      FreeAndNil(TAnonymousEvent<T, P>.TAnonymousEvent.root);
end;

function TAnonymousEvent<T, P>.TAnonymousEvent.GetEvent: T;
type
   TVtable = array [0 .. 3] of Pointer;
   PVtable = ^TVtable;
   PPVtable = ^PVtable;
begin
   Result := Default (T);
   var ptrResult := @Result;
   TMethod(ptrResult^).Data := Pointer((@event)^);
   TMethod(ptrResult^).Code := PPVtable((@event)^)^^[3];
end;

{ TAnonymousEvent<T, P> }

constructor TAnonymousEvent<T, P>.Create(const owner: TComponent; const event: P);
begin
   Self.owner := owner;
   Self.event := event;
end;

constructor TAnonymousEvent<T, P>.Create(const event: P);
begin
   Create(TAnonymousEvent<T, P>.TAnonymousEvent.root, event);
end;

class operator TAnonymousEvent<T, P>.Implicit(Event: P): TAnonymousEvent<T, P>;
begin
   Result := TAnonymousEvent<T, P>.Create(Event);
end;

class operator TAnonymousEvent<T, P>.Implicit(Event: TAnonymousEvent<T, P>): T;
begin
   Result := TAnonymousEvent.Create(Event.owner, Event.event).GetEvent();
end;

end.
