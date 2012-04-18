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
 import prime.bindable.Bindable;

/**
 * Singleton which collects all playing sound-objects and adds an API to apply 
 * actions on them.
 *
 * @creation-date   Oct 3, 2011
 * @author          Ruben Weijers
 */
class GlobalSoundMixer
{
    private function new () {}
    
    private static var instance (getInstance, null) : SoundMixer;
    private static inline function getInstance ()
        return instance.isNull() ? instance = new SoundMixer() : instance


    public static inline function stopAll ()                        { instance.stopAll(); }
    public static inline function stopAllExcept (s:BaseMediaStream) { instance.stopAllExcept(s); }
    public static inline function freezeAll ()                      { instance.freezeAll(); }
    public static inline function defrostAll ()                     { instance.defrostAll(); }


    public static inline function add (s:BaseMediaStream)           { instance.add(s); }
    public static inline function remove (s:BaseMediaStream)        { instance.remove(s); }


    public static inline function mute ()                           { instance.mute(); }
    public static inline function unmute ()                         { instance.unmute(); }
    public static inline function toggleMute ()                     { instance.toggleMute(); }




    public static var volume    (getVolume, never)                  : Bindable<Float>;
        private static inline function getVolume ()                 { return instance.volume; }
    
    public static var isMuted   (getIsMuted, never)                 : Bindable<Bool>;
        private inline static function getIsMuted()                 { return instance.isMuted; }
    
    public static var isFrozen  (getIsFrozen, never)                : Bool;
        private inline static function getIsFrozen()                { return instance.isFrozen; }
}