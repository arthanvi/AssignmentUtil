package com.moinee.crtapp.core
{
	import mx.formatters.DateFormatter;

	public class SqlConstants4RBSE9
	{
		public static var createTbl_updateCounter:String = "CREATE TABLE IF NOT EXISTS updateCounterTable (QUIZTYPE VARCHAR NOT NULL , COUNTER_TO_SYNC INTEGER NOT NULL , TOTAL_COUNTER INTEGER NOT NULL)";
		
		//public static var createTbl_quizStats:String = "CREATE TABLE IF NOT EXISTS quizStats (QUIZTYPE VARCHAR NOT NULL , COUNTER_TO_SYNC INTEGER NOT NULL , TOTAL_COUNTER INTEGER NOT NULL)";
		//public static var createTbl_quizStats:String = "CREATE TABLE IF NOT EXISTS quizStats (ID INTEGER PRIMARY KEY AUTOINCREMENT,NAME VARCHAR NOT NULL, QUIZ_TYPE VARCHAR NOT NULL, USER_ID VARCHAR NOT NULL, SESSION_ID VARCHAR NOT NULL)";
		public static var createTbl_quizStats:String = "CREATE TABLE IF NOT EXISTS quizStats (ID INTEGER PRIMARY KEY AUTOINCREMENT,NAME VARCHAR NOT NULL, QUIZ_TYPE VARCHAR NOT NULL, USER_ID VARCHAR NOT NULL, SESSION_ID VARCHAR NOT NULL, QUESTION_IDS VARCHAR NOT NULL, RESPONSES VARCHAR NOT NULL, RIGHT_OR_WRONG VARCHAR NOT NULL, TIME_PER_QUESTION VARCHAR NOT NULL, QUIZ_SIZE INTEGER NOT NULL, CORRECT_ANSWERS INTEGER NOT NULL, COURSE_ID INTEGER, TOPIC_NAME VARCHAR NOT NULL, SUBTOPIC_IDS VARCHAR NOT NULL, START_TIME VARCHAR NOT NULL, END_TIME VARCHAR NOT NULL, TIME_TAKEN VARCHAR NOT NULL, REFERENCE_QUIZ_ID VARCHAR, IS_SYNC VARCHAR NOT NULL, SYNC_TIME VARCHAR)"; //AT - Added new field SYNC_TIME
		public static var createTbl_userTable:String = "CREATE TABLE IF NOT EXISTS userTable (ID INTEGER PRIMARY KEY AUTOINCREMENT,USER_ID VARCHAR NOT NULL, PASSWORD VARCHAR NOT NULL, IS_VERIFIED VARCHAR NOT NULL)";
		public static var createTbl_AssignmentTable:String = "CREATE TABLE IF NOT EXISTS assignmentTable (ID INTEGER PRIMARY KEY AUTOINCREMENT,  ONLINE_ASSIGNMENT_ID INTEGER NOT NULL, ACTIVITY_NAME TEXT NOT NULL, ACTIVITY_TYPE TEXT NOT NULL, QUESTION_IDS VARCHAR NOT NULL, START_TIME VARCHAR, END_TIME_OR_DURATION VARCHAR, EXPIRE_ON VARCHAR, TRACK_CLOSURE VARCHAR, QUESTION_SET_SIZE VARCHAR, QUESTION_ORDER VARCHAR NOT NULL)"; //TODO OFFA
		//in use...workinG
		public static function insertNewQuizTypeRecord(counterType:String):String 
			{
				var queryText:String;
				queryText = "INSERT INTO updateCounterTable (QUIZTYPE, COUNTER_TO_SYNC, TOTAL_COUNTER) VALUES ('"+counterType+"',0,0)";
				return queryText;
			}
		
		
		public static function insertNewUserRecord(userId:String):String 
		{
			var queryText:String;
			queryText = "INSERT INTO userTable (USER_ID, PASSWORD, IS_VERIFIED) VALUES ('"+userId+"','','P')";
			return queryText;
		}
		public static function updateSyncCountertoZero():String
			{
				var queryText:String;
				queryText = "UPDATE updateCounterTable SET COUNTER_TO_SYNC = 0 ";
				return queryText;
			}
		public static function updateSyncCounters(appName:String, counterToSync:int, counterTotal:int):String
		{
			var queryText:String;
			queryText = "UPDATE updateCounterTable SET COUNTER_TO_SYNC = "+counterToSync+", TOTAL_COUNTER = "+counterTotal+" WHERE QUIZTYPE = '"+appName+"'";
			return queryText;
		}
		//in use..testing
		public static function getExistingCounters(appName:String):String
		{
			var queryText:String;
			queryText = "SELECT COUNTER_TO_SYNC,TOTAL_COUNTER  FROM updateCounterTable WHERE QUIZTYPE = '"+appName+"'";
			
			return queryText;
		} 
		public static function getCountersToSync():String
		{
			var queryText:String;
			queryText = "SELECT QUIZTYPE, COUNTER_TO_SYNC  FROM updateCounterTable WHERE COUNTER_TO_SYNC > 0";
			
			return queryText;
		} 
		public static function getUsersFromDatabase():String
		{
			var queryText:String;
			queryText = "SELECT USER_ID  FROM userTable";
			return queryText;
		}
		public static function getAllUsersForOnlineValidationFromDatabase():String
		{
			var queryText:String;
			queryText = "SELECT USER_ID  FROM userTable WHERE IS_VERIFIED != 'Y'";
			return queryText;
		}
		//HERE THE FIRST METHOD TO MAKE A QUERY TO INSERT NEW RECORDS IN QUIZ STATS
		public static function insertNewQuizStatsRecord(name:String,quizType:String,userId:String,sessionId:String,questionIds:String,responses:String,rightOrWrong:String,timePerQuestion:String,quizSize:int,correctAnswers:int,courseId:int,topicName:String,subTopicIds:String,sTime:String,eTime:String,timeTaken:String,rQuizId:String,isSync:String):String 
		{
			var queryText:String;
			queryText = "INSERT INTO quizStats (NAME, QUIZ_TYPE, USER_ID, SESSION_ID, QUESTION_IDS, RESPONSES, RIGHT_OR_WRONG, TIME_PER_QUESTION, QUIZ_SIZE, CORRECT_ANSWERS, COURSE_ID, TOPIC_NAME, SUBTOPIC_IDS, START_TIME, END_TIME, TIME_TAKEN, REFERENCE_QUIZ_ID, IS_SYNC) VALUES ('"+name+"','"+quizType+"','"+userId+"','"+sessionId+"','"+questionIds+"','"+responses+"','"+rightOrWrong+"','"+timePerQuestion+"',"+quizSize+","+correctAnswers+","+courseId+",'"+topicName+"','"+subTopicIds+"','"+sTime+"','"+eTime+"','"+timeTaken+"','"+rQuizId+"','"+isSync+"')";
			return queryText;
		}
		//(onlineAssignmentId:int,assignmentName:String,assignmentType:String,qIds:String,sTime:String,eTime:String,expiryTime:String,trackClosureC:String,qSetSize:String,qOrder:String)
		public static function insertNewAssignmentRecord(onlineAssignmentId:int,assignmentName:String,assignmentType:String,qIds:String,sTime:String,eTime:String,expiryTime:String,trackClosureC:String,qSetSize:String,qOrder:String):String 
		{
			var queryText:String;
			queryText = "INSERT INTO assignmentTable (ONLINE_ASSIGNMENT_ID, ACTIVITY_NAME, ACTIVITY_TYPE, QUESTION_IDS, START_TIME, END_TIME_OR_DURATION, EXPIRE_ON, TRACK_CLOSURE, QUESTION_SET_SIZE, QUESTION_ORDER) VALUES ('"+onlineAssignmentId+"','"+assignmentName+"','"+assignmentType+"','"+qIds+"','"+sTime+"','"+eTime+"','"+expiryTime+"','"+trackClosureC+"','"+qSetSize+"','"+qOrder+"');";
			return queryText;
		}
		public static function getStatsToSync():String
		{
			var queryText:String;
			queryText = "SELECT ID, NAME, QUIZ_TYPE, USER_ID, SESSION_ID, QUESTION_IDS, RESPONSES, RIGHT_OR_WRONG, TIME_PER_QUESTION, QUIZ_SIZE, CORRECT_ANSWERS, COURSE_ID, TOPIC_NAME, SUBTOPIC_IDS, START_TIME, END_TIME, TIME_TAKEN, REFERENCE_QUIZ_ID, IS_SYNC  FROM quizStats WHERE IS_SYNC='n'";
			trace(queryText);
			return queryText;
		}
		public static function getAllStats(userId:String):String
		{
			var queryText:String;
			if(userId == "projectutkarsh@quizacademy.org")
				queryText = "SELECT ID, NAME, QUIZ_TYPE, USER_ID, SESSION_ID, QUESTION_IDS, RESPONSES, RIGHT_OR_WRONG, TIME_PER_QUESTION, QUIZ_SIZE, CORRECT_ANSWERS, COURSE_ID, TOPIC_NAME, SUBTOPIC_IDS, START_TIME, END_TIME, TIME_TAKEN, REFERENCE_QUIZ_ID, IS_SYNC, SYNC_TIME  FROM quizStats";
			else
				queryText = "SELECT ID, NAME, QUIZ_TYPE, USER_ID, SESSION_ID, QUESTION_IDS, RESPONSES, RIGHT_OR_WRONG, TIME_PER_QUESTION, QUIZ_SIZE, CORRECT_ANSWERS, COURSE_ID, TOPIC_NAME, SUBTOPIC_IDS, START_TIME, END_TIME, TIME_TAKEN, REFERENCE_QUIZ_ID, IS_SYNC, SYNC_TIME  FROM quizStats WHERE USER_ID='"+userId+"'";
			trace(queryText);
			return queryText;
		}
		public static function getAllStats4SpecificAssignments():String
		{
			var queryText:String;
			queryText = "SELECT ID, NAME, QUIZ_TYPE, USER_ID, SESSION_ID, QUESTION_IDS, RESPONSES, RIGHT_OR_WRONG, TIME_PER_QUESTION, QUIZ_SIZE, CORRECT_ANSWERS, COURSE_ID, TOPIC_NAME, SUBTOPIC_IDS, START_TIME, END_TIME, TIME_TAKEN, REFERENCE_QUIZ_ID, IS_SYNC, SYNC_TIME  FROM quizStats WHERE REFERENCE_QUIZ_ID != ''";
			trace(queryText);
			return queryText;
		}
		public static function getAllAssignments(userId:String,filterCriteria:String):String //filterCriteria can ALL, COMPLETED, ACTIVE etc.
		{
			var queryText:String;
			/*if(userId == "projectutkarsh@quizacademy.org")
				queryText = "SELECT ID, NAME, QUIZ_TYPE, USER_ID, SESSION_ID, QUESTION_IDS, RESPONSES, RIGHT_OR_WRONG, TIME_PER_QUESTION, QUIZ_SIZE, CORRECT_ANSWERS, COURSE_ID, TOPIC_NAME, SUBTOPIC_IDS, START_TIME, END_TIME, TIME_TAKEN, REFERENCE_QUIZ_ID, IS_SYNC, SYNC_TIME  FROM quizStats";
			else*/
			//currentDateString>>>>
			var CurrentDateTime:Date = new Date();
			var CurrentDF:DateFormatter=new DateFormatter();
			CurrentDF.formatString = "YYYY-MM-DD JJ:NN:SS";
			var CurrentDateTimeString:String = CurrentDF.format(CurrentDateTime);
			
			if(filterCriteria == "ALL")	
				queryText = "SELECT *  FROM assignmentTable;";
			else if(filterCriteria == "UPCOMING")
				queryText = "SELECT *  FROM assignmentTable where START_TIME > '"+CurrentDateTimeString+"';";
			else if(filterCriteria == "EXPIRED")
				queryText = "SELECT *  FROM assignmentTable where EXPIRE_ON < '"+CurrentDateTimeString+"';";
			else if(filterCriteria == "ACTIVE")
				queryText = "SELECT *  FROM assignmentTable where START_TIME < '"+CurrentDateTimeString+"' and EXPIRE_ON > '"+CurrentDateTimeString+"';";
			else if(filterCriteria == "COMPLETED")
				queryText = "SELECT assignmentTable.ID,max(quizStats.ID) as QuizStatID,ONLINE_ASSIGNMENT_ID,ACTIVITY_NAME,ACTIVITY_TYPE,assignmentTable.START_TIME,END_TIME_OR_DURATION,EXPIRE_ON,assignmentTable.QUESTION_IDS,TRACK_CLOSURE,QUESTION_SET_SIZE,QUESTION_ORDER FROM assignmentTable INNER JOIN quizStats on assignmentTable.ONLINE_ASSIGNMENT_ID=quizStats.REFERENCE_QUIZ_ID WHERE quizStats.USER_ID='"+userId+"'  GROUP BY quizStats.REFERENCE_QUIZ_ID";//"SELECT *  FROM assignmentTable;"; //query to be changed for user's completed assignment
			else if(filterCriteria == "ALLCOMPLETED")
				queryText = "SELECT assignmentTable.ID,max(quizStats.ID) as QuizStatID,ONLINE_ASSIGNMENT_ID,ACTIVITY_NAME,ACTIVITY_TYPE,assignmentTable.START_TIME,END_TIME_OR_DURATION,EXPIRE_ON,assignmentTable.QUESTION_IDS,TRACK_CLOSURE,QUESTION_SET_SIZE,QUESTION_ORDER,COUNT(quizStats.ID) AS C_COUNT FROM assignmentTable LEFT JOIN quizStats on assignmentTable.ONLINE_ASSIGNMENT_ID=quizStats.REFERENCE_QUIZ_ID GROUP BY assignmentTable.ONLINE_ASSIGNMENT_ID";			trace(queryText);
			return queryText;
		}
		public static function isAssignmentExisting(assignmentId:int):String
		{
			var queryText:String;
			queryText = "SELECT COUNT() AS mycount FROM assignmentTable where ONLINE_ASSIGNMENT_ID = "+assignmentId+";";
			return queryText;
		}
		public static function getAllUserRecords(userId:String):String
		{
			var queryText:String;
			if(userId == "projectutkarsh@quizacademy.org")
				queryText = "SELECT USER_ID, IS_VERIFIED FROM userTable";
			else
				queryText = "SELECT USER_ID, IS_VERIFIED FROM userTable WHERE USER_ID = '"+userId+"'";
			trace(queryText);
			return queryText;
		}
		public static function getLastQuizStatSyncTime():String
		{
			var queryText:String;
			queryText = "SELECT MAX(SYNC_TIME) AS LAST_SYNC_TIME FROM quizStats"; //working - tested in lita
			//trace(queryText);
			return queryText;
		}
		public static function getLastOnlineAssignmentIdQuery():String
		{
			var queryText:String;
			queryText = "SELECT MAX(ONLINE_ASSIGNMENT_ID) AS LAST_ASSIGNMENT_ID FROM assignmentTable"; //working - tested in lita
			//trace(queryText);
			return queryText;
		}
		public static function updateSyncOfQuizStat(id:String):String
		{
			//to get current system date time string to pass in as extra value in old query
			var CurrentDateTime:Date = new Date();
			var CurrentDF:DateFormatter=new DateFormatter();
			CurrentDF.formatString = "YYYY-MM-DD JJ:NN:SS";
			var CurrentDateTimeString:String = CurrentDF.format(CurrentDateTime);
			
			var queryText:String;
			queryText ="UPDATE quizStats SET IS_SYNC = 'y', SYNC_TIME = '"+ CurrentDateTimeString +"'  WHERE ID="+id;
			return queryText;
		}
		
		public static function updateOnlineUserValidationConfirmation(responseString:String):String
		{
			// TODO Auto Generated method stub
			var queryText:String;
			queryText ="UPDATE userTable SET IS_VERIFIED = 'Y' WHERE USER_ID IN ("+responseString+")";
			return queryText;
		}
		public static function updateOnlineUserValidationFails():String
		{
			// TODO Auto Generated method stub
			var queryText:String;
			queryText ="UPDATE userTable SET IS_VERIFIED = 'N' WHERE IS_VERIFIED = 'P'";
			return queryText;
		}
	}
	//public class SqlConstants
//	{
//			public static var createTbl_mockTestTable:String = "CREATE TABLE IF NOT EXISTS mockTestTable (TestID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL , TemplateID INTEGER NOT NULL , TemplateName VARCHAR NOT NULL, StartTime DATETIME NOT NULL , SubmitTime DATETIME, ScoreMethod VARCHAR NOT NULL, DefaultScore INTEGER, TestDuration INTEGER NOT NULL )";
//			//todo - add columns in mockTestTable - template name, timelimit
//			//public static var query4:String = "CREATE TABLE IF NOT EXISTS templateMasterTable (TemplateID VARCHAR PRIMARY KEY  NOT NULL , TemplateText VARCHAR NOT NULL )";
//			public static var createTbl_testQuestionTable:String = "CREATE TABLE IF NOT EXISTS testQuestionTable (ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, TestID INTEGER NOT NULL , QuestionID INTEGER NOT NULL , CorrectAnswer VARCHAR NOT NULL, UserAnswer VARCHAR, Topic VARCHAR NOT NULL, SubTopic VARCHAR NOT NULL, KbcLevel INTEGER NOT NULL)";
//			
//			public static function insertNewMockTestRecord(myMockTest:MockTestObj):String 
//			{
//				var queryText:String;
//				queryText = "INSERT INTO mockTestTable (TemplateID, TemplateName, StartTime, ScoreMethod, TestDuration) VALUES ("+
//					myMockTest.templateId+", '"+myMockTest.templateName+"', 'now','"+
//					myMockTest.scoringMethod +"', '"+myMockTest.testDuration+"')";
//				return queryText;
//			}
//			public static function insertQuestionRecord(myQuestion:QuestionObj, testId:int):String
//			{
//				var queryText:String;
//				queryText = "INSERT INTO testQuestionTable (TestID, QuestionID, CorrectAnswer, UserAnswer, Topic, SubTopic, KbcLevel) " +
//					"VALUES ("+testId+","+myQuestion.questionId+",'"+myQuestion.correctAnswer+"','"+myQuestion.selectedAnswer+"','"+myQuestion.topic+"','"+myQuestion.subTopic+"',"+myQuestion.kbcLevel+")";
//				return queryText;
//			}
//			public static function updateMockTestRecord(testId:int, defaultScore:int):String
//			{
//				var queryText:String;
//				queryText = "UPDATE mockTestTable SET SubmitTime = 'now', DefaultScore = "+defaultScore+" WHERE TestID = "+testId;
//				return queryText;
//			}
//			public static function getMockTestRecord(testId:int):String
//			{
//				var queryText:String;
//				queryText = "SELECT TestID, TemplateID, TemplateName, StartTime, datetime(StartTime,'localtime') as StartTimeLocal ,SubmitTime, datetime(SubmitTime,'localtime') as SubmitTimeLocal, ScoreMethod, DefaultScore, TestDuration FROM mockTestTable WHERE TestID = "+testId;
//				
//				return queryText;
//			} 
//			public static function getAllMockTestRecords():String
//			{
//				var queryText:String;
//				queryText = "SELECT TestID, TemplateID, TemplateName, StartTime, datetime(StartTime,'localtime') as StartTimeLocal, SubmitTime, datetime(SubmitTime,'localtime') as SubmitTimeLocal, ScoreMethod, DefaultScore, TestDuration FROM mockTestTable";
//				return queryText;
//			} 
//			public static function getQuestionRecords(testId:int):String
//			{
//				var queryText:String;
//				queryText = "SELECT * FROM testQuestionTable WHERE TestID = "+testId;
//				return queryText;
//			}
//			public function SqlConstants()
//			{
//			}
//		
//	}
}