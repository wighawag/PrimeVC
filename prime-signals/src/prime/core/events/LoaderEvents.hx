/*
 * Copyright (c) 2010, The PrimeVC Project Contributors
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *   - Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   - Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE PRIMEVC PROJECT CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE PRIMVC PROJECT CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 *
 *
 * Authors:
 *  Ruben Weijers	<ruben @ onlinetouch.nl>
 */
package prime.core.events;
 import prime.core.events.CommunicationEvents;
 import prime.signal.Signal0;
 import prime.signal.Signal1;
 import prime.signal.Signals;


typedef LoaderEvents = 
	#if		flash9	prime.avm2.events.LoaderEvents;
	#elseif	flash8	prime.avm1.events.LoaderEvents;
	#elseif	js		prime.js  .events.LoaderEvents;
	#elseif neko	LoaderSignals;
	#else	#error	#end


/**
 * @author Ruben Weijers
 * @creation-date Nov 15, 2010
 */
class LoaderSignals extends Signals
{
	public var unloaded			(default, null)		: Signal0;
	public var load				(default, null)		: CommunicationSignals;
	public var httpStatus		(default, null)		: Signal1<Int>;
	
	/**
	 * some stupid, flash specific extra event with data from server after an upload
	 */
	public var uploadComplete	(default, null)		: Signal1<String>;
	
	/**
	 * signal that is dispatched when the upload is canceled by the user
	 */
	public var uploadCanceled	(default, null)		: Signal0;
}