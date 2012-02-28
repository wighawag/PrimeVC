package cases;


/**
 * Test case to find out why haxe build r4200 fails to call the constructor of a super-class
 */


class GenericSuperClassConstructorTest
{
	public static function main () {
		var b = new GenericClass<String>();
		if (b.val == null)	throw "no value for b";
		trace(b.val);
	}
}


class BasicClass {
	public var val : String;
	public function new ()	val = "test"
}


class GenericClass<T> extends BasicClass, implements haxe.rtti.Generic {
	private var prop : T;
//	public function new () {super(); }
}