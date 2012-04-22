package prime.signal;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import prime.signal.Signal;

/**
* Auto generated MassiveUnit Test Class  for prime.signal.Signal0 
*/
class SignalTestBase<T : Signal<Dynamic>>
{
	var instance   : T;
	var called     : Int;
	var voidCalled : Int;
	
	public function new() {}
	
	@After
	public function tearDown():Void
	{
		instance.dispose();
	}
	
	private function bind       () {}
	private function bindOn     () {}
	private function bindOnce   () {}
	private function bindOnOnce () {}
	private function send       () {}

	@Test
	public function testBindSend():Void
	{
		bind();
		send();
		Assert.areEqual(called, 1);

		send();
		Assert.areEqual(called, 2);
	}

	@Test
	public function testBindOnSend():Void
	{
		bindOn();
		send();
		Assert.areEqual(called, 1);
		Assert.areEqual(voidCalled, 1);

		send();
		Assert.areEqual(called, 2);
		Assert.areEqual(voidCalled, 2);
	}

	@Test
	public function testBindOnceSend():Void
	{
		bindOnce();
		send();
		Assert.areEqual(called, 1);
		Assert.areEqual(voidCalled, 1);

		send();
		Assert.areEqual(called, 1);
		Assert.areEqual(voidCalled, 1);
	}

	@Test
	public function testBindOnOnceSend():Void
	{
		bindOnOnce();
		send();
		Assert.areEqual(called, 1);
		Assert.areEqual(voidCalled, 1);

		send();
		Assert.areEqual(called, 1);
		Assert.areEqual(voidCalled, 1);
	}
}