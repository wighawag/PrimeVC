package prime.signal;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import prime.signal.Signal2;
import prime.signal.SignalTestBase;
 using prime.utils.Bind;

/**
* Auto generated MassiveUnit Test Class  for prime.signal.Signal0 
*/
class Signal2Test extends SignalTestBase<Signal2<String,Int>>
{
	function handlerInt     (s:String, Int) : Int  return called++
	function handler        (s:String, Int) : Void called++
	function voidHandler    ()              : Void voidCalled++

//	public function new() {}
	
	@Before
	public function setup():Void
	{
		voidCalled = called = 0;
		instance = new Signal2();
	}
	
	override function bind       () { instance.bind(this, handler);  instance.observe(this, voidHandler); }
	override function bindOn     () { handlerInt.on(instance, this); voidHandler.on(instance, this);   }
	override function bindOnce   () { instance.bindOnce(this, handler);  instance.observeOnce(this, voidHandler); }
	override function bindOnOnce () { handlerInt.onceOn(instance, this); voidHandler.onceOn(instance, this);   }
	override function send       () instance.send("message", 1)
}