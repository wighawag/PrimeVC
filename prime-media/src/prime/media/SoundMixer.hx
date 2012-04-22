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
 * DAMAGE.s
 *
 *
 * Authors:
 *  Ruben Weijers   <ruben @ prime.vc>
 */
package prime.media;
#if flash9
 import flash.events.Event;
 import flash.media.SoundTransform;
#end
 import prime.bindable.Bindable;
  using prime.utils.IfUtil;
  using prime.utils.NumberUtil;
  using prime.utils.TypeUtil;


#if flash
private typedef Sound = flash.media.SoundMixer;
#end



/**
 * @creation-date   Oct 3, 2011
 * @author          Ruben Weijers
 */
class SoundMixer
{
    private var next        : BaseMediaStream;

    /**
     * Overall volume setting
     */
    public var volume       (default, null)        : Bindable<Float>;
    /**
     * Flag indicating if the sound is muted
     */
    public var isMuted      (default, null)         : Bindable<Bool>;
    /**
     * Flag indicating if all channels are frozem
     */
    public var isFrozen (getIsFrozen, never)        : Bool;
        private inline function getIsFrozen ()      { return numberOfFreezes > 0; }
    
    /**
     * The number of times "pauseAll" is called
     */
    private var numberOfFreezes                     : Int;
    
    
    public function new ()
    {
        volume              = new Bindable<Float>(1.0);
        isMuted             = new Bindable<Bool>(false);
        numberOfFreezes     = 0;
    }


    public function stopAll ()
    {
        var c = next;
        while (c.notNull()) {
            c.stop();
            c = c.next;
        }
        numberOfFreezes = 0;
    }


    public function stopAllExcept (exception:BaseMediaStream = null)
    {
        var c = next;
        while (c.notNull()) {
            if (c != exception)
                c.stop();
            c = c.next;
        }
        numberOfFreezes = 0;
    }


    public function freezeAll ()
    {
        var c = next;
        while (c.notNull()) {
            c.freeze();
            c = c.next;
        }
        numberOfFreezes++;
    }


    public function defrostAll ()
    {
        var c = next;
        numberOfFreezes--;
        while (c.notNull()) {
            c.defrost();
            c = c.next;
        }
    }


    public function add (stream:BaseMediaStream)
    {
        Assert.isNotNull(stream);
        if (isFrozen)
            for (i in 0 ... numberOfFreezes)
                stream.freeze();
        
        (untyped stream).next = next;
        next = stream;
    //    ListUtil.addNode(this, s);
    }


    public function remove (stream:BaseMediaStream)
    {
        Assert.isNotNull(stream);

        //defrost the channel
        if (isFrozen)
            for (i in 0 ... numberOfFreezes)
                stream.defrost();
        
        //remove it
        var prev:BaseMediaStream = null;
        var cur  = next;
        while (cur.notNull()) {
            if (cur == stream) {
                if (prev == null)   next = cur.next;
                else                (untyped prev).next = cur.next;
                break;
            }
            prev = cur;
            cur  = cur.next;
        }
    }


    public inline function mute ()
        if (!isMuted.value) {
            isMuted.value = true;
            applyVolume();
        }


    public inline function unmute ()
        if (isMuted.value) {
            isMuted.value = false;
            applyVolume();
        }

    
    /**
     * Mutes or unmutes all soundClients. If a client is muted, the sound will
     * be paused instead of turning the volume to zero.
     */
    public inline function toggleMute ()
        isMuted.value ? unmute() : mute()


    private function applyVolume ()
    {
#if flash9
        var s    = Sound.soundTransform;
        s.volume = isMuted.value.boolCalc() * volume.value;
        Sound.soundTransform = s;
#end
    }
}