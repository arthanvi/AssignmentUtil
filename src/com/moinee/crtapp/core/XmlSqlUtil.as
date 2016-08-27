package com.moinee.crtapp.core
{
	import mx.charts.CategoryAxis;
	

	public class XmlSqlUtil
	{
		import flash.data.*;
		import flash.events.*;
		import flash.filesystem.*;
		import com.moinee.crtapp.core.AppSessionObj;
		[Bindable] private var mySessionObj:AppSessionObj = new AppSessionObj();
		// sqlc is a variable we need to define the connection to our database
		private static var sqlc:SQLConnection = new SQLConnection();
		
		//sqlc.addEventListener(SQLErrorEvent.ERROR, error);
		// sqlc is an SQLStatment which we need to execute our sql commands
		private static var sqls:SQLStatement = new SQLStatement();
		//private static var sqls1:SQLStatement = new SQLStatement();
		public static var dbName:String = AppSessionObj.currentDbName; //"appUsageC9.db"; //"appUsageC9.db";
		private static var mockDb:File;
		
		public function XmlSqlUtil()
		{
		}
		
		public static function prepareConnectionStatement():void
		{
			mockDb = File.documentsDirectory.resolvePath(dbName); //working for mobile

			if(sqlc.connected)
				sqlc.close();
			sqlc.open(mockDb);
				//create tables
			sqls.sqlConnection = sqlc;
		}
		
		public static function checkIfDbExists():Boolean
		{
			mockDb = File.documentsDirectory.resolvePath(dbName); //working for mobile
			
			try
			{
				if(sqlc.connected)
					sqlc.close();
				sqlc.open(mockDb);
				//create tables
				sqls.sqlConnection = sqlc;
				
				sqls.text = "SELECT * from assignmentTable"; //SqlConstants4RBSE9.createTbl_AssignmentTable;;
				sqls.execute();
				AppSessionObj.isDbExisting = true;
				
			}
			catch (e:Error)
			{
				AppSessionObj.isDbExisting = false;//do nothing which means user is already existning.
				//delete the created db file during the resolve.
				if(sqlc.connected)
					sqlc.close();
				
				mockDb.deleteFile();
			}
			
			return AppSessionObj.isDbExisting;
		}
		
		public static function isDbExists():Boolean
		{
			mockDb = File.documentsDirectory.resolvePath(dbName); //working for mobile
			//File.applicationStorageDirectory.resolvePath(dbName); // probably for window ???to be checked
			//File.applicationDirectory.resolvePath(dbName); //for ???
			
			var returnV:Boolean = false;
			try
			{
				if(sqlc.connected)
					sqlc.close();
				sqlc.open(mockDb,SQLMode.READ);
				
				//check if firstTimeSetup was run sussessfully
				returnV = true;
			}catch(e:Error)
			{
				returnV = false;
			}catch(e:SQLErrorEvent)
			{
				returnV = false;
			}
			return returnV;
		}
		public static function firstTimeSetup():void
		{
			try{
				prepareConnectionStatement();
				//create first table
				sqls.text = SqlConstants4RBSE9.createTbl_updateCounter;
				sqls.execute();
				sqls.text = SqlConstants4RBSE9.createTbl_quizStats;
				sqls.execute();
				sqls.text = SqlConstants4RBSE9.createTbl_userTable;
				sqls.execute();
				//TODO OFFA - create query for assignment table and add here for first time creation/execution
				sqls.text = SqlConstants4RBSE9.createTbl_AssignmentTable;
				sqls.execute();
				trace("...done...");
				sqls.text = SqlConstants4RBSE9.insertNewQuizTypeRecord(AppSessionObj.appDbId); //not synced online in this version
				// sqls.text += SqlConstants4RBSE9.insertNewQuizTypeRecord('RBSE9QUIZ');
				sqls.execute();
				
				sqls.text = SqlConstants4RBSE9.insertNewQuizTypeRecord('RBSE9QUIZ'); //not synced online in this version
				sqls.execute();
				
				sqls.text = SqlConstants4RBSE9.insertNewQuizTypeRecord('RBSE9KBC'); //not synced online in this version
				sqls.execute();
				
				//sqls.text = SqlConstants4RBSE9.insertNewQuizTypeRecord('RBSE9FLIP');
				//sqls.execute();
			}
			catch(e:Error) //WORKING TO DO NOTHING
			{}
		}
		public static function addAssignmentTableIfNotExisting():void
		{
			prepareConnectionStatement();
			//create first table
			try
			{
				sqls.text = SqlConstants4RBSE9.createTbl_AssignmentTable;;
				sqls.execute();
			}
			catch (e:Error)
			{
				//do nothing which means user is already existning.
			}
		}
		public static function addNewUser(userId:String):void
		{
			prepareConnectionStatement();
			//create first table
			try
			{
				sqls.text = SqlConstants4RBSE9.insertNewUserRecord(userId);
				sqls.execute();
			}
			catch (e:Error)
			{
				//do nothing which means user is already existning.
			}
		}
		public static function updateCounter(appName:String):void
		{
			prepareConnectionStatement();
			//get existing counters
			sqls.text = SqlConstants4RBSE9.getExistingCounters(appName);
			sqls.execute();
			var myObj1:Object = sqls.getResult().data;
			//trace(sqls.getResult().data[0].COUNTER_TO_SYNC);
			var counterToSync:int = myObj1[0].COUNTER_TO_SYNC;
			var counterTotal:int = myObj1[0].TOTAL_COUNTER;
			counterToSync++;
			counterTotal++;
			sqls.text = SqlConstants4RBSE9.updateSyncCounters(appName,counterToSync,counterTotal);
			sqls.execute();
		}
		public static function updatequizStatsCounter(id:String):void
		{
			prepareConnectionStatement();
			sqls.text = SqlConstants4RBSE9.updateSyncOfQuizStat(id);
			sqls.execute();
		}
		
		public static function getUsersToFillDropdown():Array
		{
			prepareConnectionStatement();
			sqls.text = SqlConstants4RBSE9.getUsersFromDatabase();
			sqls.execute();
			return sqls.getResult().data;
		}
		
		public static function getAllUserList():Array
		{
			prepareConnectionStatement();
			sqls.text = SqlConstants4RBSE9.getUsersFromDatabase();
			sqls.execute();
			return sqls.getResult().data;
		}
		
		public static function getUserIdsToValidate():Array
		{
			prepareConnectionStatement();
			sqls.text = SqlConstants4RBSE9.getAllUsersForOnlineValidationFromDatabase();
			sqls.execute();
			return sqls.getResult().data;
		}
		public static function updateOnlineUserValidation(responseString:String):void
		{
			// TODO Auto Generated method stub
			prepareConnectionStatement();
			if(responseString != "No_Data")
			{
				sqls.text = SqlConstants4RBSE9.updateOnlineUserValidationConfirmation(responseString);
				sqls.execute();
			}
			//also update to all pendings (P) to N
			sqls.text = SqlConstants4RBSE9.updateOnlineUserValidationFails();
			sqls.execute();
			
		}
		public static function getCountersToSync():Array
		{
			prepareConnectionStatement();
			sqls.text = SqlConstants4RBSE9.getCountersToSync();
			sqls.execute();
			
			return sqls.getResult().data;
		}
		public static function resetSyncCounter():void
		{
			prepareConnectionStatement();
			sqls.text = SqlConstants4RBSE9.updateSyncCountertoZero();
			sqls.execute();
			
		}
		
		//here will be method to call the insert query method and execute this
		
		public static function insertQuizStats(name:String,quizType:String,userId:String,sessionId:String,questionIds:String,responses:String,rightOrWrong:String,timePerQuestion:String,quizSize:int,correctAnswers:int,courseId:int,topicName:String,subTopicIds:String,sTime:String,eTime:String,timeTaken:String,rQuizId:String,isSync:String):void
		{
			prepareConnectionStatement();
			sqls.text = SqlConstants4RBSE9.insertNewQuizStatsRecord(name,quizType,userId,sessionId,questionIds,responses,rightOrWrong,timePerQuestion,quizSize,correctAnswers,courseId,topicName,subTopicIds,sTime,eTime,timeTaken,rQuizId,isSync);
			sqls.execute();
		
		}
		public static function insertAssignmentStatsRecordInLocalDb(onlineAssignmentId:int,assignmentName:String,assignmentType:String,qIds:String,sTime:String,eTime:String,expiryTime:String,trackClosureC:String,qSetSize:String,qOrder:String):void
		{
			prepareConnectionStatement();
			sqls.text = SqlConstants4RBSE9.insertNewAssignmentRecord(onlineAssignmentId,assignmentName,assignmentType,qIds,sTime,eTime,expiryTime,trackClosureC,qSetSize,qOrder);
			sqls.execute();
			
		}
		/*public static function insertUserData(userId:String):void
		{
			prepareConnectionStatement();
			sqls.text = SqlConstants4RBSE9.insertNewUser(name,quizType,userId,sessionId,questionIds,responses,rightOrWrong,timePerQuestion,quizSize,correctAnswers,courseId,topicName,subTopicIds,sTime,eTime,timeTaken,rQuizId,isSync);
			sqls.execute();
			
		}*/
		public static function getStatsRecordToSync():Array
		{
			
				prepareConnectionStatement();
				sqls.text = SqlConstants4RBSE9.getStatsToSync();
				sqls.execute();
				return sqls.getResult().data;
		}
		
		public static function getStatsRecordAll(userId:String):Array //AT added for all or all for a user special user is projectutkarsh@quizacademy.org
		{
			
			prepareConnectionStatement();
			sqls.text = SqlConstants4RBSE9.getAllStats(userId); //AT changed
			sqls.execute();
			return sqls.getResult().data;
		}
		public static function getStatsRecordsAll4Assignments():Array //AT added for all or all for a user special user is projectutkarsh@quizacademy.org
		{
			
			prepareConnectionStatement();
			sqls.text = SqlConstants4RBSE9.getAllStats4SpecificAssignments(); //AT changed
			sqls.execute();
			return sqls.getResult().data;
		}
		public static function getAssignmentRecordsAll(userId:String,filterCriteria:String):Array //AT added for all or all for a user special user is projectutkarsh@quizacademy.org
		{
			
			prepareConnectionStatement();
			sqls.text = SqlConstants4RBSE9.getAllAssignments(userId, filterCriteria); //AT changed
			sqls.execute();
			return sqls.getResult().data;
		}
		public static function isAssignmentRecordExisting(assignmentId:int):int
		{
			prepareConnectionStatement();
			sqls.text = SqlConstants4RBSE9.isAssignmentExisting(assignmentId); //AT changed
			sqls.execute();
			var resultObj:SQLResult = sqls.getResult();
			var resultCount:int = 0;
			resultCount = resultObj.data[0].mycount;
			return resultCount; //sqls.getResult().data[0]; //returning first element from the result 
		}
		
		public static function getUserListRecords(userId:String):Array //AT added for all or all for a user special user is projectutkarsh@quizacademy.org
		{
			
			prepareConnectionStatement();
			sqls.text = SqlConstants4RBSE9.getAllUserRecords(userId); //AT changed
			sqls.execute();
			return sqls.getResult().data;
		}
		
		public static function getLastQuizStatsSyncDateTime():Array
		{
			prepareConnectionStatement();
			sqls.text = SqlConstants4RBSE9.getLastQuizStatSyncTime(); //AT changed
			sqls.execute();
			return sqls.getResult().data;
		}
		
		public static function getLastOnlineAssignmentId():Array
		{
			prepareConnectionStatement();
			sqls.text = SqlConstants4RBSE9.getLastOnlineAssignmentIdQuery(); //AT changed
			sqls.execute();
			return sqls.getResult().data;
		}
/*		public static function isFirstTimeLoad():Boolean
		{
			mockDb = File.documentsDirectory.resolvePath(dbName);//File.applicationStorageDirectory.resolvePath(dbName);
			
			var returnV:Boolean = false;
			try
			{
				sqlc.open(mockDb,SQLMode.READ);
				//check if firstTimeSetup was run sussessfully
				returnV = true;
			}catch(e:Error)
			{
				returnV = false;
			}catch(e:SQLErrorEvent)
			{
				returnV = false;
			}
			return returnV;
		}
		public static function error(e:SQLErrorEvent):Boolean
		{
			return false;
		}
		public static function firstTimeSetup():void
		{

			prepareConnectionStatement();
				//create first table
			sqls.text = SqlConstants.createTbl_mockTestTable;
			sqls.execute();
			sqls.text = SqlConstants.createTbl_testQuestionTable;
			sqls.execute();
			//trace("...done...");
			//AppSessionObjTest.testString1 = "done...";
			//populate data
				//read from xml
				//write in tables
			//final record to confirm completion.
		}
		
		public static function creatMockTest(myMockTest:MockTestObj):MockTestObj
		{
			prepareConnectionStatement();
			//get insert query
			sqls.text = SqlConstants.insertNewMockTestRecord(myMockTest);
			sqls.execute();
			myMockTest.mockTestId = sqls.getResult().lastInsertRowID;
			return myMockTest;
		}
		
		public static function insertQuestionDetails(myQuestion:QuestionObj, testId:int):int
		{
			prepareConnectionStatement();
			sqls.text = SqlConstants.insertQuestionRecord(myQuestion,testId);
			//use parameters for avoiding special characters
			// todo ... statement.parameters[":username"] = username;
			//  "VALUES ("+testId+","+myQuestion.questionId+",'"+myQuestion.correctAnswer+"','"+myQuestion.selectedAnswer+"','"+
				//myQuestion.topic+"','"+myQuestion.subTopic+"',"+myQuestion.kbcLevel+")";
			//"VALUES (:testId,:questionId, :correctAnswer,:selectedAnswer,:topic,:subTopic,:kbcLevel)";
			
			//...add rest of the parameters...
			sqls.execute();
			return sqls.getResult().lastInsertRowID;
		}
		
		public static function updateMocktestRecord(testId:int, defaultScore:int):void
		{
			prepareConnectionStatement();
			sqls.text = SqlConstants.updateMockTestRecord(testId,defaultScore);
			sqls.execute();
		}
		public static function getMockTestRecord(testId:int):Array
		{
			prepareConnectionStatement();
			sqls.text = SqlConstants.getMockTestRecord(testId);
			sqls.execute();
			return sqls.getResult().data;
		} 
		public static function getQuestionRecords(testId:int):Array
		{
			prepareConnectionStatement();
			sqls.text = SqlConstants.getQuestionRecords(testId);
			sqls.execute();
			return sqls.getResult().data;
		}
		public static function getAllMockTestRecords():Array
		{
			prepareConnectionStatement();
			sqls.text = SqlConstants.getAllMockTestRecords();
			sqls.execute();
			return sqls.getResult().data;
		} 
	}*/
		
		
	}
}