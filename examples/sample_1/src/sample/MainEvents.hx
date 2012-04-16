package sample;
 import prime.signal.Signal1;
 import prime.signal.Signals;

/**
 * Defines and groups together application events
 * and provides an access point for them.
 */
class MainEvents extends MVCEvents
{
    public var loadImage:Signal1 < String >;

    public function new ()
    {
        super();
        
        loadImage = new Signal1();
    }
}