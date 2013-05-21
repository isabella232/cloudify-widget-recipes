/*******************************************************************************
* Copyright (c) 2012 GigaSpaces Technologies Ltd. All rights reserved
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*       http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*******************************************************************************/
import org.cloudifysource.dsl.utils.ServiceUtils;
import org.cloudifysource.dsl.context.ServiceContextFactory

/* 
   This file enables users to convert the on-disk SSTable representation of a column family into a JSON formatted document.
   Usage :  invoke cassandra sstable2json OUTPUT_FILE(optional) SSTABLE_PATH
   Example: invoke cassandra sstable2json C:\myjsonfile.txt C:\default_cassandra_1\lib\cassandra\data\system\data-table.db
*/

	println "INVOKING Tbl2Json!!!!!!!!!!!!!!";
	context = ServiceContextFactory.getServiceContext();
	config = new ConfigSlurper().parse(new File(context.serviceDirectory + "/cassandra.properties").toURL());
	execFile = ServiceUtils.isWindows() ? "sstable2json.bat" : "sstable2json"
	homedir = "${context.serviceDirectory}/${config.unzipFolder}";
	//println "home dir is : "+ homedir
	argList = "";
	if (args.length > 1)
		argList = args[0] + " " + args[1];
	else if (args.length == 1)
		argList = args[0];
	command = "${homedir}" + "/bin/" + execFile + " " + argList;
	
	println "###command is :" + command
	try{
		def proc = command.execute();
	}catch(e)
	{
		assert e in ExecuteCommandException;
		println e.StackTraceElement;
	}
	                 
	
	                           

	return;
				
