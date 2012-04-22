package prime.signal;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import prime.signal.Signal;
 using prime.utils.Bind;

/**
* General usage test
*/
class SignalTest 
{
	var d1 : Signal1<String>;
	var d2 : Signal1<String>;
	var d3 : Signal0;
	
	@Before
	public function setup():Void
	{
		voidCalled = 0;
		d1Called   = 0;
		d2Called   = 0;
		d3Called   = 0;
		d4Called   = 0;
	
		testCreate();
		d1.observe(this,d4Handler);
		d2.on(d1, this);
		d3.on(d2, this);
		voidHandler.on(d3, this);
		d1Handler.on(d1, this);
		d2Handler.on(d1, this);
		d3Handler.onceOn(d1, this);
		d4Handler.onceOn(d1, this);
	}
	@After
	public function tearDown():Void
	{
		d1.dispose();
		d2.dispose();
		d3.dispose();
	}
	
	
	@Test
	function testCreate () {
		d1 = new Signal1();
		d2 = new Signal1();
		d3 = new Signal0();
	}
	
	@Test
	function testSend() {
		d1.send("one");
		d1.send("two");
	}
	
	@Test
	function testUnbind() : Void {
	//	function(str:String) { trace("anon: "+str); }.on(d2, this);

		// Dispose Bindings to test freelist
		d1.unbind(this);
		d2.unbind(this);
		d3.unbind(this);
	}
	
	var voidCalled : Int;
	function voidHandler() : Int {
		voidCalled++;
	//	trace("void!");
		return 0;
	}
	
	var d1Called : Int;
	function d1Handler(str:String) {
		d1Called++;
	//	trace("d1: "+str);
	}
	
	var d2Called : Int;
	function d2Handler(str:String) : String {
		d2Called++;
	//	trace("d2: "+str);
		return str;
	}
	
	var d3Called : Int;
	function d3Handler(str:String) {
		d3Called++;
	//	trace("d3 once! "+str);
	}
	
	var d4Called : Int;
	function d4Handler() {
		d4Called++;
	//	trace("d4 once!");
	}
}