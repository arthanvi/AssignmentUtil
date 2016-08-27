package com.moinee.crtapp.core
{
	import air.net.URLMonitor;
	
	import flash.events.StatusEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.utils.*;
	import flash.utils.Timer;
	
	import flashx.textLayout.formats.Float;
	
	import mx.collections.ArrayCollection;

	public class AppSessionObj
	{
		public static var currentDbName:String = "appUsageC10a";//"appUsageC9.db";
		public static var isDbExisting:Boolean = false;
		public static var userInSession:String="";
		public static var appDbId:String = "9FlexApp";
		
		/*	Key Attributes of session */
		//capture action choice
		private var _actionChoice:String; //should be set a default?
		//Topic value
		private var _topicSelected:String;
		private var _topicFileName:String;
		//Subtopic value
		private var _subTopicSelected:String;
		
		public var promotionMsgData:ArrayCollection;
		public var paidAppURLLink:String;
		public var MockTestMsg:String;
		public static var currentVersion:Number; //comes from meta data
		public static var onlineVersion:Number; //comes from online xml
		
		public var useOnlineDataSet:Boolean = false;
		public var monitor:URLMonitor;
		
		public var correctAnswer:int;
		public var totalQuestions:int;
		
		public var errorLoop:int = 0; //this is to ignore error of question data not getting set for one or two times in a loop
		public var errorMsg:String = "Unexpected Error"
		
		//public var kbcScore:KbcScoreObj = new KbcScoreObj();
		//public var timeStarted:Timer = new Timer(0);
		//public var mytimer:Date = new Date();
		//public var loadingDataMsg:String = "Loading....\n\n(If you have selected online option than it may take longer or timeout due to slow network connectivity. Go back and load again in case of any issue)";
		public var loadingDataMsg:String = "Loading Images Data....\n\n\n(It may take few extra seconds to load)";
		
		//for image Base Data - to hold the arraycollection to avoid reload at each quiz.
		public static var masterImgBaseListData:ArrayCollection;
		
		//variables for user score management //ATT
		public var userId:String=""; //D//D
		public var responses:String="NOT REQUIRED"; //D//D
		public var rightOrWrong:String=""; //D//D?? P check...write the logic at the quizView on response to each answer
		public var sessionID:String="OFFLINE APP"; //??should have a default ??? check data type
		public var questionIds:String=""; //D //D
		public var timePerQuestion:String="NOT REQUIRED"; //D//D
		public var courseId:int=14; //for 10th = 14 and for 9th = 1
		public var sTime:String=""; //D//D
		public var eTime:String=""; //??
		public var referenceId:String=""; //??
		public var password:String=""; //??
		public var isverified:String="n"; //??
		public var isSync:String="n"; //?? check
		public var quizType:String="QUIZ"; //?? D check
		public var userArray:Array=[]; //??
		
		//for test related variables
		public var testDuration:int=0;
		public var testName:String = "";

		
		public function AppSessionObj()
		{
			//put any code that needs to run at the creation of this object at the start
			this._actionChoice = "freshquiz"; //default value
			//this.initTimer();
		}
		
		
		public function get topicFileName():String
		{
			return _topicFileName;
		}

		public function set topicFileName(value:String):void
		{
			_topicFileName = value;
		}

		public function get actionChoice():String
		{
			return _actionChoice;
		}

		public function set actionChoice(value:String):void
		{
			_actionChoice = value;
		}

		public function get topicSelected():String
		{
			return _topicSelected;
		}

		public function set topicSelected(value:String):void
		{
			_topicSelected = value;
		}

		public function get subTopicSelected():String
		{
			return _subTopicSelected;
		}

		public function set subTopicSelected(value:String):void
		{
			_subTopicSelected = value;
		}

		
		
		private const TIMER_INTERVAL:int = 10;	
		private var baseTimer:int;
		private var t:Timer;
		private var _quizTimeTaken:String;
		[Bindable] public var dateObj:Date;
	
		public function initTimer():void {
			t = new Timer(TIMER_INTERVAL);
			t.addEventListener(TimerEvent.TIMER, updateTimer);
			t.reset();
			//dateObj = new Date(0, 0, 0, 0, 0, 0, getTimer() - baseTimer);
			startTimer();
		}
		
		public function updateTimer(evt:TimerEvent):void {
			var d:Date = new Date(0, 0, 0, 0, 0, 0, getTimer() - baseTimer);
			dateObj = d;
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
		
		public function initConnectivityMonitor():void
		{
			monitor = new URLMonitor(new URLRequest('https://www.google.com'));
			//monitor.addEventListener(StatusEvent.STATUS, announceStatus);
			monitor.start();
		}

	}
}