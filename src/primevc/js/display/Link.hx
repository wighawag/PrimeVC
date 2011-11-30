package primevc.js.display;
 import js.Lib;
 import nl.onlinetouch.viewer.events.BookletEvents;
 import nl.onlinetouch.vo.publication.ISpreadVO;
 
/**
 * @since	June 15, 2011
 * @author	Stanislav Sopov 
 */
class Link extends DOMElem
{	
    public var bookletEvents    (default, null):BookletEvents;
	public var href				(default, setHref):String;
    public var spreadId         (default, setSpreadId):String;

	public function new() {
		super("a");
        bookletEvents = new BookletEvents();
	}
	
	private function setSpreadId(v:String):String {
		spreadId = v;
        elem.addEventListener("click", function() { 
            bookletEvents.gotoSpread.send(spreadId);
        }, false);
		return v;
	}
	
	private function setHref(v:String):String {
		href = v;
		elem.href = href;
		elem.target = "_blank";
		return v;
	}
}