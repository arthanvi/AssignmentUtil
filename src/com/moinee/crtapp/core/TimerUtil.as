package com.moinee.crtapp.core
{
	import flash.events.StatusEvent;
	import flash.events.TimerEvent;
	import flash.utils.*;
	import flash.utils.Timer;
	
	public class TimerUtil
	{
		private const TIMER_INTERVAL:int = 1000;	
		public var baseTimer:int;
		public var t:Timer;
		private var _quizTimeTaken:String;
		public var testDuration:int;
		[Bindable] public var dateObj:Date;
		[Bindable] public var minutesLapsed:int;
		
		public function TimerUtil()
		{
		}
		
		public function initTimer():void {
			t = new Timer(TIMER_INTERVAL);
			t.addEventListener(TimerEvent.TIMER, updateTimer);
			t.reset();
			//dateObj = new Date(0, 0, 0, 0, 0, 0, getTimer() - baseTimer);
			startTimer();
		}
		
		public function updateTimer(evt:TimerEvent):void {
			//var d:Date = new Date(0, 0, 0, 0, 0, 0, getTimer() - baseTimer);
			var total:int = baseTimer + (this.testDuration*60*1000);
			var d:Date = new Date(0, 0, 0, 0, 0, 0, total - getTimer());
			dateObj = d;
			//minutesLapsed = dateObj.hours*60 + dateObj.minutes;
			//return d;
		}
		
		
		public function startTimer():void {
			baseTimer = getTimer();
			t.start();
		}
		
		public function stopTimer():void {
			t.stop();
		}
		
		public function get quizTimeTaken():String
		{
			return _quizTimeTaken;
		}
		
		public function set quizTimeTaken(value:String):void
		{
			_quizTimeTaken = value;
		}
	}
}