package sample;
 import prime.mvc.MVCActor;
 import prime.mvc.IMVCCoreActor;
  using primevc.utils.Bind;

/**
 * Receives and dispatches global events.
 */
class MainController extends MVCActor<MainFacade>, implements IMVCCoreActor
{	
    public function new (facade:MainFacade)		{ super(facade); }
}