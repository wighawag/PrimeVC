package prime.signal;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import prime.signal.Signal0;
import prime.signal.SignalTestBase;
 using prime.utils.Bind;

/**
* Auto generated MassiveUnit Test Class  for prime.signal.Signal0 
*/
class Signal0Test extends SignalTestBase<Signal0>
{
	function handlerInt     () : Int  return called++
	function handler        () : Void called++
	function voidHandler    () : Void voidCalled++

//	public function new() {}
	
	@Before
	public function setup():Void
	{
		voidCalled = called = 0;
		instance = new Signal0();
	}
	
	override function bind       () { instance.bind(this, handler);      instance.observe(this, voidHandler);     }
	override function bindOn     () { handlerInt.on(instance, this);     voidHandler.on(instance, this);          }
	override function bindOnce   () { instance.bindOnce(this, handler);  instance.observeOnce(this, voidHandler); }
	override function bindOnOnce () { handlerInt.onceOn(instance, this); voidHandler.onceOn(instance, this);      }
	override function send       () instance.send()
}