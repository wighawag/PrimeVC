package cases;

import prime.signal.Signal4;

class SendCallSpeedTest
{
	static function main()
	{
		Test.main();
	}
}


class Test {
	static public function main(){
		trace("TEST");
		for (i in 0 ... 3) baseline();
		for (i in 0 ... 3) dynamic_();
		for (i in 0 ... 3) dispatcher();
	}
	
	static function baseline() {
		trace("baseline");
		var obj = new Test();
		var start = flash.Lib.getTimer();

		for (i in 0...2000000) {
			obj.call(obj, obj, obj, obj);//, 1.337, start);
		}
		
		var end = flash.Lib.getTimer();
		trace(end - start);
	}
	
	static function dynamic_() {
		trace("dynamic");
		var obj = new Test();
		var start = flash.Lib.getTimer();
		
		for (i in 0...2000000) {
			obj.calld(obj, obj, obj, obj);
		}
		
		var end = flash.Lib.getTimer();
		trace(end - start);
	}
	
	static function dispatcher() {
		trace("dispatcher");
		var dp = new Signal4<Test,Test,Test,Test>();
		var obj = new Test();
		var start = flash.Lib.getTimer();
		
		for (i in 0...2000000) {
			dp.send(obj, obj, obj, obj);
		}
		
		var end = flash.Lib.getTimer();
		trace(end - start);
	}
	
	
	
	
	function new() {
		calld = call_dynamic;
	}
	function call(x:Test, a:Test, b:Test, c:Test);//, d:Dynamic);
	
	var calld : Test -> Test -> Test -> Test -> Void;
	
	function call_dynamic(a:String, b:Int, c:Float, d:Dynamic);
}