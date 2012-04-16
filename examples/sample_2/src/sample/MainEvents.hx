package sample;
 import prime.signal.Signal1;
 import prime.signal.Signals;

/**
 * MainEvents defines and groups together the events used 
 * in the application and provides a main access point for them. 
 */
class MainEvents extends Signals
{
    public var loadImage:Signal1 < String >;

    public function new ()
    {
        super();
		
		// Instantiate Signal1 that accepts a String as a parameter.
        loadImage = new Signal1();
    }
}