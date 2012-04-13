package;
 import prime.signal.ISender1;
 import prime.signal.INotifier;
 import prime.signal.Signal1;
 import prime.signal.Signals;

 import prime.mvc.Facade;
 import prime.mvc.Model;
 import prime.mvc.Mediator;
 import prime.mvc.View;
 import prime.mvc.Proxy;
 import prime.mvc.EditProxy;

 import prime.core.traits.IValueObject;
 import prime.core.traits.IEditableValueObject;
 import prime.core.traits.IEditEnabledValueObject;


interface IUserVO implements IValueObject
{
	var name (default,null) : String;
}

interface IUserEVO implements IEditEnabledValueObject
{
	public var name (default,default) : String;
}

class UserVO implements IUserVO, implements IUserEVO, implements IEditableValueObject<IUserEVO>
{ // normaal gesproken gegenereerd.
	public var name (default,default) : String;
	
	public function asEditable() : IUserEVO {return this;}
	public function commitEdit() : Void;
	public function cancelEdit() : Void;
}



typedef UserProxyEvents = {
	var loggedIn (default,null) : ISender1<UserVO>;
}

class UserSignals extends Signals
{
	var loggedIn : Signal1<UserVO>;
}

class UserProxy extends EditProxy<IUserVO, UserVO, IUserEVO, UserProxyEvents>
{
	
	public function login(name:String, pass:String) {
		f.events.loggedIn.send( null );
	}
}

typedef UserMediatorEvents = {//>Signals,  stupid whining haxe-compiler
	var user (default,null) : {//>Signals,
		var loggedIn (default,null) : INotifier<UserVO->Void>;
	};
}

typedef UserMediatorModel = {//>Model,
	var userProxy (default,null) : UserProxy;
}

class UserMediator extends Mediator<UserMediatorEvents, UserMediatorModel>
{
	
}

class EditorView extends View
{
	var user : UserMediator;
	
/*	override*/ function setupMediators(facade:EditorFacade)
	{
		user = new UserMediator(facade);
	}
}

class EditorFacade extends Facade<EditorEvents, EditorModel, EditorView> {
	override function setupModel()	model = new EditorModel(this)
	override function setupView()	view  = new EditorView(null)
	
}

class EditorEvents extends Signals
{
	var user : UserSignals;
}

class EditorModel extends Model
{
	var userProxy (default, null) : UserProxy;
	
	public function new(facade:EditorFacade)
	{
		userProxy = new UserProxy(facade.events.user);
	}
}

class MVC
{
	static function main() trace("MVC framework compiled with no errors. yay.")
}