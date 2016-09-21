var ALSObjectWindowFunctions={};//存放所有的重写或修改的数据
var enableFolding=false;//分组是否可折叠

/************JS常量定义开始***********/
ALSObjectWindowFunctions.objectWindowMetaData_DWNAME="DWNAME";
ALSObjectWindowFunctions.objectWindowMetaData_DWCOLUMNS="DWCOLUMNS";
ALSObjectWindowFunctions.objectWindowMetaData_DONO="DONO";
ALSObjectWindowFunctions.objectWindowMetaData_SERIALIZED_ASD="SERIALIZED_ASDFULL";
ALSObjectWindowFunctions.objectWindowMetaData_BIZOBJECTCLASS="JBOCLASS";

ALSObjectWindowFunctions.objectWindowMetaData_DWPARAMETERS="DWPARAMETERS";
ALSObjectWindowFunctions.ObjectWindowStyle_List="1";
ALSObjectWindowFunctions.ObjectWindowStyle_Info="2";
/************JS常量定义结束***********/

/************ObjectWindow客户端数据结构定义开始**************/
ALSObjectWindowFunctions.objectWindowMetaData=[];//存放界面上所有的objectwindow的结构定义
ALSObjectWindowFunctions.ObjectWindowData=[];//存放所有ObjectWindow的数据序列化之后的字符串
ALSObjectWindowFunctions.ObjectWindowOutputData=[];//存放所有ObjectWindow的输出数据，区别于界面录入数据，因为存在一些场景，需要获取OW字段之外的输出值
/************ObjectWindow客户端数据结构定义结束**************/


/************ObjectWindow客户端函数定义开始**************/
/*
 * 获得ObjectWindow的返回参数值
 */
ALSObjectWindowFunctions.getOutputParameter=function(dwname,parameterName){
	var parameterObject = ALSObjectWindowFunctions.ObjectWindowOutputData[dwname];
	if(parameterObject){
		return AsCredit.getBusinessObjectAtrribute(parameterObject,parameterName);
	}
};

/*
 * 获得ObjectWindow的返回参数值
 */
ALSObjectWindowFunctions.getOutputParameterObject=function(dwname){
	return ALSObjectWindowFunctions.ObjectWindowOutputData[dwname];
};

/*
 * 获得ObjectWindow的返回参数值
 */
ALSObjectWindowFunctions.getOutputParameters=function(dwname){
	return AsCredit.getBusinessObjectAtrributes(ALSObjectWindowFunctions.getOutputParameterObject(dwname));
};

/*
 * 获取objectwindow对象
 */
ALSObjectWindowFunctions.getObjectWindowMetaObject=function(dwname){
	if(ALSObjectWindowFunctions.objectWindowMetaData){
		return ALSObjectWindowFunctions.objectWindowMetaData[dwname];
	}
};

/*
 * 获取objectwindow对象
 */
ALSObjectWindowFunctions.getObjectWindowFieldIndex=function(dwname,fieldName){
	var columnString = ALSObjectWindowFunctions.getObjectWindowMetaAttribute(dwname,ALSObjectWindowFunctions.objectWindowMetaData_DWCOLUMNS);
	columnString= columnString.split(",");
	for(var i=0;i<columnString.length;i++){
		if(fieldName.toUpperCase()==columnString[i].toUpperCase())return i;
	}
	return -1;
};

/*
 * 获取objectwindow对象
 */
ALSObjectWindowFunctions.getObjectWindowFieldName=function(dwname,fieldIndex){
	var columnString = ALSObjectWindowFunctions.getObjectWindowMetaAttribute(dwname,ALSObjectWindowFunctions.objectWindowMetaData_DWCOLUMNS);
	columnString= columnString.split(",");
	return columnString[fieldIndex];
};

/*
 * 获取objectwindow对象
 */
ALSObjectWindowFunctions.getObjectWindowColIndex=function(dwname,colName){
	return ALSObjectWindowFunctions.getObjectWindowColAttribute(dwname,colName,"COLUMNINDEX");
};

/*
 * 获取objectwindow对象
 */
ALSObjectWindowFunctions.getObjectWindowColAttribute=function(dwname,colName,attributeID){
	var objectWindowMetaObject = ALSObjectWindowFunctions.getObjectWindowMetaObject(dwname);
	if(!objectWindowMetaObject) return ;

	var id="COLUMN_ARRAY_"+colName.toUpperCase();
	var obj=AsCredit.getBusinessObjectAtrribute(objectWindowMetaObject,id);
	if(!obj) return;
	obj=obj[0];
	return AsCredit.getBusinessObjectAtrribute(obj,attributeID);
};

/*
 * 获取objectwindow的某个属性
 */
ALSObjectWindowFunctions.getObjectWindowMetaAttribute=function(dwname,attributeid){
	var objectWindowMetaObject = ALSObjectWindowFunctions.getObjectWindowMetaObject(dwname);
	if(!objectWindowMetaObject) return ;
	return AsCredit.getBusinessObjectAtrribute(objectWindowMetaObject,attributeid);
};

//选择合作项目账号
ALSObjectWindowFunctions.setObjectValuePretreat=function(selector,parameter,fieldMap,windowStyle,multiFlag,subdwid,rownum,manualQueryFlag){
	var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,subdwid);
	AsCredit.setGridValue(selector,parameter,
			fieldMap,windowStyle,multiFlag,subdwname,rownum,manualQueryFlag);
};

ALSObjectWindowFunctions.setTreeValue=function(selector,inputParameters,windowStyle,subdwid,rownum,returnColumnID,returnColumnName,folderSelectFlag){
	var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,subdwid);
	AsCredit.setTreeValue(selector,inputParameters,windowStyle,subdwname,rownum,returnColumnID,returnColumnName,folderSelectFlag);
};

ALSObjectWindowFunctions.getListChangedData=function(dwname){
	var result = new Array();
	var changedRowNum="";
	var tableId = "myiframe" + dwname;
	for(var i=0;i<tableDatas[tableId].length;i++){
		var rowObject = ALSObjectWindowFunctions.ObjectWindowData[dwname][i];
		var objectStatus = rowObject["ClientStatus"];
		var changed = false;
		if(objectStatus!="1")//如果不为同步状态，则直接视为变更过
			changed=true;
		else{
			for(var j=0;j<tableDatas[tableId][i].length;j++){
				var iDZColIndex = TableFactory.getDZColIndexFromTalbe(tableId,j);
				var fieldName = ALSObjectWindowFunctions.getObjectWindowFieldName(dwname,iDZColIndex);
				var newValue = tableDatas[tableId][i][j];
				var oldValue = AsCredit.getBusinessObjectAtrribute(rowObject,fieldName);
				if(newValue!=oldValue){
					changed = true;
					break;
				}
			}
		}
		if(changed) changedRowNum+=","+i;
	}
	if(changedRowNum!=""){
		changedRowNum=changedRowNum.substring(1).split(",");
		for(var j=0;j<changedRowNum.length;j++){
			result[j]=ALSObjectWindowFunctions.getJSONBusinessObject(dwname,changedRowNum[j]);
		}
	}
	return result;
};

ALSObjectWindowFunctions.tempSaveClientData=function(dwname){
	var tableId = "myiframe" + dwname;
	for(var i=0;i<tableDatas[tableId].length;i++){
		var rowObject = ALSObjectWindowFunctions.ObjectWindowData[dwname][i];
		var objectStatus = rowObject["ClientStatus"];
		for(var j=0;j<tableDatas[tableId][i].length;j++){
			var iDZColIndex = TableFactory.getDZColIndexFromTalbe(tableId,j);
			var fieldName = ALSObjectWindowFunctions.getObjectWindowFieldName(dwname,iDZColIndex);
			var newValue = tableDatas[tableId][i][j];
			if(newValue==undefined||typeof(newValue)=="undefined" || newValue.length==0) newValue="";
			
			var oldValue = AsCredit.getBusinessObjectAtrribute(rowObject,fieldName);
			if(oldValue==undefined||typeof(oldValue)=="undefined" || oldValue.length==0) oldValue="";
			
			if(newValue!=oldValue){
				var changedFields=rowObject["ChangedFields"];
				if(!changedFields) changedFields={};
				changedFields[fieldName]=newValue;
				AsCredit.setBusinessObjectPropety(rowObject,"ChangedFields",changedFields);
				if(objectStatus=="1") AsCredit.setBusinessObjectPropety(rowObject,"ClientStatus","0");//同步状态下更新为变更，其他情况下保持不变
			}
		}
	}
};


/*
 * 获取objectwindow变更过的数据
 */
ALSObjectWindowFunctions.getChangedData=function(dwname){
	var objectWindowStyle=ALSObjectWindowFunctions.getObjectWindowStyle(dwname);
	if(objectWindowStyle==ALSObjectWindowFunctions.ObjectWindowStyle_List){
		return ALSObjectWindowFunctions.getListChangedData(dwname);
	}
	else if(objectWindowStyle==ALSObjectWindowFunctions.ObjectWindowStyle_Info){//Info时，与List使用同一格式
		var result = new Array();
		result[0]=ALSObjectWindowFunctions.getJSONBusinessObject(dwname,0);
		return result;
	}
};

/*
 * 
 */
ALSObjectWindowFunctions.insertRowData=function(dwname,position,newRowObjectArray){
	var newdata = new Array();
	for(var i=0;i< ALSObjectWindowFunctions.ObjectWindowData[dwname].length;i++){
		if(i<position)newdata[i]= ALSObjectWindowFunctions.ObjectWindowData[dwname][i];
		else{
			var newPosition = newRowObjectArray.length+i;
			newdata[newPosition]=ALSObjectWindowFunctions.ObjectWindowData[dwname][i];
		}
	}
	
	for(var i=0;i< newRowObjectArray.length;i++){
		newdata[position+i]=newRowObjectArray[i];
	}
	ALSObjectWindowFunctions.ObjectWindowData[dwname]=newdata;
};

ALSObjectWindowFunctions.getAllData=function(dwname){
	var data=new Array();
	var objectWindowStyle=ALSObjectWindowFunctions.getObjectWindowStyle(dwname);
	if(objectWindowStyle==ALSObjectWindowFunctions.ObjectWindowStyle_List){
		var rptCount = getRowCount(dwname);
		for(var i=0;i<rptCount;i++){
			data[i]=ALSObjectWindowFunctions.getJSONBusinessObject(dwname,i);
		}
	}
	else if(objectWindowStyle==ALSObjectWindowFunctions.ObjectWindowStyle_Info){
		data[0]=ALSObjectWindowFunctions.getJSONBusinessObject(dwname,0);
	}
	return data;
};

/*
 * 获取data grid中的一条记录，封装成json形式的BO
 */
ALSObjectWindowFunctions.getJSONBusinessObject=function(dwname,row){
	var rowObject = {};
	var bizObjectClass = ALSObjectWindowFunctions.objectWindowMetaData_BIZOBJECTCLASS;
	rowObject["ObjectType"]=ALSObjectWindowFunctions.getObjectWindowMetaAttribute(dwname,bizObjectClass);
	if(row<ALSObjectWindowFunctions.ObjectWindowData[dwname].length){
		rowObject["SerialedString"]=ALSObjectWindowFunctions.ObjectWindowData[dwname][row]["SerialedString"];
	}
	else rowObject["SerialedString"]="";
	rowObject["RowNum"]=row;
	rowObject["Attributes"]={};
	var columnString = ALSObjectWindowFunctions.getObjectWindowMetaAttribute(dwname,ALSObjectWindowFunctions.objectWindowMetaData_DWCOLUMNS);
	var columnArray = columnString.split(",");
	for(var i=0;i<columnArray.length;i++){
		var value=getItemValue(dwname,row,columnArray[i]);
		rowObject["Attributes"][columnArray[i]]= value ;
	}
	return rowObject;
};

ALSObjectWindowFunctions.clientReloadObjectWindow=function(dwname,postevents){
	var rowObjectArray = ALSObjectWindowFunctions.ObjectWindowData[dwname];
	DZ[dwname][2] = ALSObjectWindowFunctions.getDZArray(dwname, rowObjectArray);
	document.getElementById("Table_Content_"+dwname).innerHTML = TableFactory.createTableHTML(dwname);
};

ALSObjectWindowFunctions.getSubObjectWindowName=function(dwname,colName){
	var subdwname="-1";
	if(typeof(subPageMap) == "undefined" || subPageMap == null) return subdwname;
	var subpage = subPageMap[dwname];
	for(var colIndex in subpage){
		subColName = subpage[colIndex]["ColName"];
		if(subColName==colName){
			subdwname = subpage[colIndex]["SubDWName"];
			break;
		}
	}
	return subdwname;
};

/**
 * 一次性保存界面中的所有ObjectWindow
 */
ALSObjectWindowFunctions.refreshSubOW=function(dwname,colName,parameters,postevents){
	var divObject;
	var subdwname="";
	var owparamterstring="";
	if(typeof(subPageMap) == "undefined" || subPageMap.length == 0) return;
	var subpage = subPageMap[dwname];
	for(var colIndex in subpage){
		subColName = subpage[colIndex]["ColName"];
		if(subColName!=colName) continue;

		var divID = subpage[colIndex]["DivID"];
		divObject = document.getElementById(divID);
		subdwname = subpage[colIndex]["SubDWName"];
		owparamterstring = subpage[colIndex]["OWParamterString"];
	}

	parameters["OWParameterString"]=owparamterstring.replace(/\&/g, "%26");
	parameters["DWName"]=subdwname;
	parameters["ColName"]=colName;
	var paramterString=JSON.stringify(parameters);
	//ALSObjectWindowFunctions.showOverTopDiv();
	$.ajax({//后台提交数据
		   type: "POST",
		   url: sWebRootPath+"/Frame/page/ow/SubObjectWindowChange.jsp",
		   processData: false,
		   data: encodeURI("CompClientID="+sCompClientID+"&SYS_DATA=" + paramterString),
		   success: function(msg){
			var result = "";
			ALSObjectWindowFunctions.clearInfoValidator(subdwname);
			eval(msg);
			if(result.status=="success"){
				try{
					msg = "操作成功";
					divObject.innerHTML="";
					divObject.innerHTML=htmlstring;
					
					if(ALSObjectWindowFunctions.getObjectWindowStyle(subdwname)=="1"){
						document.getElementById("Table_Content_"+subdwname+"").innerHTML = TableFactory.createTableHTML(subdwname);
						if(DZ[subdwname]&&DZ[subdwname][0]&&DZ[subdwname][0][10]){
							for(var i=0;i<DZ[subdwname][0][10].length;i++){
								for(var r = 0; r < DZ[subdwname][2].length; r ++)
								{
									addListEventListeners(subdwname,r,DZ[subdwname][0][10][i][0],DZ[subdwname][0][10][i][1],DZ[subdwname][0][10][i][2],DZ[subdwname][0][10][i][3]);
								}
							}
						}
					}
					resetDWDialog(msg,true);
					if(postevents.length>0)eval(postevents);
					ALSObjectWindowFunctions.addInfoValidator(subdwname);
				}catch(e){
					msg = "操作成功，但是页面刷新失败："+e.toString();
				}
				
			}else{
				aDWResultError[0] = result.errors;
				resetDWDialog(result.errors,false);
			}
		   }
		});
};

ALSObjectWindowFunctions.clearInfoValidator=function(dwname){
	for(colName in _user_validator[dwname].rules){
		if(dwname!="0") colName=dwname+"_"+colName;
		try{
			if(document.getElementById(colName)){
				$("#"+colName).rules("remove");
			}
			else{
				$(document.getElementsByName(colName)).rules("remove");
			}
		}catch(e){}
	}
};

ALSObjectWindowFunctions.addInfoValidator=function(dwname){
	var objectWindowStyle=ALSObjectWindowFunctions.getObjectWindowStyle(dwname);
	if(objectWindowStyle!=ALSObjectWindowFunctions.ObjectWindowStyle_Info) return ;
	for(colName in _user_validator[dwname].rules){
		var actualColName=colName;
		if(dwname!="0") actualColName=dwname+"_"+colName;
		try{
			var rules=_user_validator[dwname].rules[colName];
			rules.messages=_user_validator[dwname].messages[colName];
			if(document.getElementById(actualColName)){
				$("#"+actualColName).rules("add",rules);
			}
			else{
				$(document.getElementsByName(actualColName)).rules("add",rules);
			}
		}catch(e){}
	}
};

ALSObjectWindowFunctions.isGroupVisible=function(groupID){
	var tableID="@SysSub@";
	if(groupID.length>0) tableID = "@SysSub"+groupID;
	var tableDiv = document.getElementById(tableID);
	if(tableDiv){
		if(tableDiv.style.display=="none")
			return false;
		else return true;
	}
	else return false;
};

ALSObjectWindowFunctions.showErrors=function(){
	var errorcount=0;
	var iExtCount = 8;
	document.getElementById("messageBox").style.display='block';
	
	for(var i=0;i<ALSObjectWindowFunctions.objectWindowMetaData.length;i++){
		var dwstyle = ALSObjectWindowFunctions.getObjectWindowStyle(i);
		if(dwstyle=="1"){
			if(_user_valid_errors[i]==undefined) continue;
			for(var ii=0;ii<_user_valid_errors[i].length;ii++){
				errorcount++;
				var ele_error = document.createElement("li");
				ele_error.innerHTML = "<a href='javascript:void(0)'>" + _user_valid_errors[i][ii] + "</a>";
				if(errorcount>=iExtCount){
					document.getElementById("ul_error_1").appendChild(ele_error);
				}
				else{
					document.getElementById("ul_error_0").appendChild(ele_error);
				}
			}
			
			for(var ii=0;ii<TableFactory.ColValidInfo[i].length;ii++){
				var iColIndex = getColIndex(i,TableFactory.ColValidInfo[i][ii][1]);
				var iColIndexForTable = TableFactory.getTableColIndexFromDZ("myiframe"+i,iColIndex);
				var inputs = null;
				inputs = document.getElementsByName("INPUT_" + "myiframe"+i + "_" + TableFactory.ColValidInfo[i][ii][1] + "_" + TableFactory.ColValidInfo[i][ii][0] + "_" + iColIndexForTable);
				if(inputs){
					for(var j=0;j<inputs.length;j++){
						inputs[j].style.backgroundColor='red';
					}
				}
			}
		}
		else if(i==0){
			var list = $("#myiframe0").validate().errorList;
			for(var ii=0;ii<list.length;ii++){
				errorcount++;
				var ele_error = document.createElement("li");
				var errmsg = getErrorLabel(list[ii].element.getAttribute('name'));
				if(errmsg==undefined)
					errmsg = list[ii].message;
				else
					errmsg = errmsg.innerHTML;
				ele_error.innerHTML = "<a href='javascript:void(0)' target='_self' element_name='"+list[ii].element.getAttribute('name')+"'>" + errmsg + "</a>";
				if(errorcount>=iExtCount){
					document.getElementById("ul_error_1").appendChild(ele_error);
				}else{
					document.getElementById("ul_error_0").appendChild(ele_error);
				}
			}
		}
	}
	if(errorcount<=iExtCount){
		$("#showpart").hide();
		$("#mobtn").hide();
		$("#hidbtn").hide();
	}else{
		$("#showpart").hide();
		$("#hidbtn").hide();
	}
};

/**
 * 一次性保存界面中的所有ObjectWindow
 */
ALSObjectWindowFunctions.saveAllObjectWindow=function(postevents,tempSaveFlag){
	if(!ALSObjectWindowFunctions.objectWindowMetaData||ALSObjectWindowFunctions.objectWindowMetaData.length<=0){
		return;
	}
	var sys_data = [];//用于存放所有的datawindow中变更过的数据
	if(!tempSaveFlag||tempSaveFlag==false){
		var checkResult = ALSObjectWindowFunctions.validate();
		if(!checkResult){
			ALSObjectWindowFunctions.showErrors();
			return;
		}
	}
	for(var i=0;i<ALSObjectWindowFunctions.objectWindowMetaData.length;i++){
		sys_data[i]=ALSObjectWindowFunctions.createSubmitData(i,ALSObjectWindowFunctions.getChangedData(i));
	}

	sys_data=JSON.stringify(sys_data);
	
	var action="save";
	if(tempSaveFlag==true)action="saveTmp";
	//覆盖界面不允许操作
	ALSObjectWindowFunctions.showOverTopDiv();
	$.ajax({//后台提交数据
		   type: "POST",
		   url: sWebRootPath+"/Frame/page/ow/MultipleObjectWindowAction.jsp",
		   processData: false,
		   data: encodeURI("SYS_DATA=" + sys_data + "&SYS_ACTION=" + action),
		   success: function(msg){
			var result = "";
			eval( msg );
			if(result.status=="success"){
				try{
					//aDWResultInfo[0] = result.resultInfo;
					msg = "操作成功";
					if(postevents==undefined) postevents="";
					resetDWDialog(msg,true);
					if(postevents.length>0){
						eval(postevents);
					}
				}catch(e){
					msg = "操作成功，但是页面刷新失败："+e.toString();
				}
				
			}else{
				aDWResultError[0] = result.errors;
				resetDWDialog(result.errors,false);
			}
		   }
		});
};

/**
 * 获取objectwindow的样式
 */
ALSObjectWindowFunctions.getObjectWindowStyle=function(dwname){
	return ALSObjectWindowFunctions.getObjectWindowMetaAttribute(dwname,"DWSTYLE");
};


ALSObjectWindowFunctions.showOverTopDiv=function(initTitle){
	if(initTitle==undefined) initTitle = "正在处理中...";
	var topDiv = document.getElementById("DWOverLayoutDiv");
	var dwDiv = document.getElementById("div_my0");
	if(dwDiv){
		var newheight=dwDiv.offsetHeight;
		topDiv.style.height=newheight;//修改高度
	}
	
	topDiv.style.display='block';
	var obj = $("#DWOverLayoutSubDiv");
	obj.children(".datawindow_overdiv_info").html(initTitle);
	obj.show();
	var iLeft = document.body.clientWidth/2-obj.width()/2+document.body.scrollLeft;
	var iTop = document.body.clientHeight/2-obj.height()/2+100;
	obj.css({left:iLeft,top:iTop});
	document.getElementById('sp_datawindow_overdiv_top').style.display= 'inline';
};

ALSObjectWindowFunctions.createSubmitData=function(dwname,actionData){
	var data = {};
	data["DATA"]=actionData;
	var objectmodel_serialized_string=ALSObjectWindowFunctions.getObjectWindowMetaAttribute(dwname,ALSObjectWindowFunctions.objectWindowMetaData_SERIALIZED_ASD);
	data["SERIALIZED_ASD"]=objectmodel_serialized_string;
	return data;
};

ALSObjectWindowFunctions.deleteSelectRow=function(dwname,postevents){
	var rownum = getRow(dwname);
	ALSObjectWindowFunctions.deleteListRows(dwname,rownum,postevents);
};

ALSObjectWindowFunctions.removeObjectWindow=function(dwname){
};

ALSObjectWindowFunctions.hideObjectWindow=function(dwname){
	
};

ALSObjectWindowFunctions.showObjectWindow=function(dwname){
	
};

ALSObjectWindowFunctions.getDZArray=function(dwname,rowObjectArray){
	var DZ_T=new Array();
	for(var i=0;i<rowObjectArray.length;i++){
		DZ_T[i]=ALSObjectWindowFunctions.getDZRow(dwname,rowObjectArray[i]);
	}
	return DZ_T;
};

ALSObjectWindowFunctions.getDZRow=function(dwname,rowObject){
	var rowDZ = new Array();
	var columnString = ALSObjectWindowFunctions.getObjectWindowMetaAttribute(dwname,ALSObjectWindowFunctions.objectWindowMetaData_DWCOLUMNS);
	columnString= columnString.split(",");
	
	var changedcolumns = rowObject["ChangedFields"];
	for(var i=0;i<columnString.length;i++){
		if(changedcolumns&&changedcolumns[columnString[i]]) rowDZ[i]=changedcolumns[columnString[i]];
		else rowDZ[i]=AsCredit.getBusinessObjectAtrribute(rowObject,columnString[i]);
	}
	return rowDZ;
};

ALSObjectWindowFunctions.addRows=function(dwname,position,rowcount,parameters,postevents){
	var action="new";
	var actionData={};
	if(position<0){
		position=ListObjectWindowFunctions.getRowCount(dwname);
	}

	if(parameters=="")parameters={};
	actionData["SYS_POSITION"]=position;
	if(!rowcount)rowcount=1;
	actionData["SYS_ROWCOUNT"]=rowcount;
	actionData["SYS_PARAMETERS"]={};
	actionData["SYS_PARAMETERS"]["Attributes"]=parameters;
	var sys_data=[];
	sys_data[0]=ALSObjectWindowFunctions.createSubmitData(dwname,actionData);
	sys_data=JSON.stringify(sys_data);
	//覆盖界面不允许操作
	//ALSObjectWindowFunctions.showOverTopDiv();
	$.ajax({//后台提交数据
		   type: "POST",
		   url: sWebRootPath+"/Frame/page/ow/MultipleObjectWindowAction.jsp",
		   processData: false,
		   data: encodeURI("SERIALIZED_JBO=&SYS_DATA=" + sys_data + "&SYS_ACTION=" + action),
		   success: function(msg){
			var result = "";
			
			eval(msg);
			if(result.status=="success"){
				//try{ 
					ALSObjectWindowFunctions.tempSaveClientData(dwname);//把所有的变更数据记录下来
					for(var i = 0; i < rowcount; i ++)
					{
						ALSObjectWindowFunctions.insertRowData(dwname,position+i,newrows);//调整数据数组
					}
					ALSObjectWindowFunctions.clientReloadObjectWindow(dwname);//重画界面
					msg = "操作成功";
					lightRow(dwname,position);
					if(postevents==undefined) postevents="";
					
					if(DZ[dwname]&&DZ[dwname][0]&&DZ[dwname][0][10]){
						for(var i=0;i<DZ[dwname][0][10].length;i++){
							for(var r=0;r < getRowCount(dwname); r++)
							{
								addListEventListeners(dwname,r,DZ[dwname][0][10][i][0],DZ[dwname][0][10][i][1],DZ[dwname][0][10][i][2],DZ[dwname][0][10][i][3]);
							}
						}
					}
					resetDWDialog(msg,true);
					if(postevents.length>0)eval("("+postevents+")");
					change_height();
				//}catch(e){
				//	msg = "操作成功，但是页面刷新失败："+e.toString();
				//	resetDWDialog(msg,false);
				//}
			}else{
				aDWResultError[0] = result.errors;
				resetDWDialog(result.errors,false);
			}
		   }
	});
};

ALSObjectWindowFunctions.addRow=function(dwname,parameters,postevents){
	var position=getRow(dwname);
	if(position<0) position= getRowCount(dwname);
	else position = position+1;
	ALSObjectWindowFunctions.addRows(dwname,position,1,parameters,postevents);
	return position;
};

/**
 *删除List中的指定行，rowNum以逗号分隔
 */
ALSObjectWindowFunctions.deleteListRows=function(dwname,rowNum,postevents,splitchar){
	if(!ALSObjectWindowFunctions.objectWindowMetaData||ALSObjectWindowFunctions.objectWindowMetaData.length<=0){
		return;
	}
	var actionData = [];//用于存放所有的datawindow中变更过的数据
	if(!splitchar) splitchar=",";
	rowNum=rowNum+"";
	rowNum=rowNum.split(",");
	for(var i=0;i<rowNum.length;i++){
		actionData[i]=ALSObjectWindowFunctions.getJSONBusinessObject(dwname,rowNum[i]);
	}
	
	var sys_data=[];
	sys_data[0]=ALSObjectWindowFunctions.createSubmitData(dwname,actionData);
	sys_data=JSON.stringify(sys_data);
	
	var action="delete";
	//覆盖界面不允许操作
	ALSObjectWindowFunctions.showOverTopDiv();
	$.ajax({//后台提交数据
		   type: "POST",
		   url: sWebRootPath+"/Frame/page/ow/MultipleObjectWindowAction.jsp",
		   processData: false,
		   data: encodeURI("SERIALIZED_JBO=&SYS_DATA=" + sys_data + "&SYS_ACTION=" + action),
		   success: function(msg){
			var result = "";
			eval(msg);
			if(result.status=="success"){
				try{
					ALSObjectWindowFunctions.tempSaveClientData(dwname);//把所有的变更数据记录下来,避免删除后刷新造成数据丢失
					var newData = new Array();
					for(var c=0;c<DZ[dwname][2].length;c++){
						var deleteFlag=false;
						for(var j=0;j<rowNum.length;j++){
							if(c==rowNum[j])deleteFlag=true;
						}
						if(!deleteFlag){
							newData[newData.length]=ALSObjectWindowFunctions.ObjectWindowData[dwname][c];
						}
					}
					ALSObjectWindowFunctions.ObjectWindowData[dwname]=newData;//更新数据
				
					ALSObjectWindowFunctions.clientReloadObjectWindow(dwname);//重画界面
					
					if(DZ[dwname]&&DZ[dwname][0]&&DZ[dwname][0][10]){
						for(var i=0;i<DZ[dwname][0][10].length;i++){
							for(var r=0;r < getRowCount(dwname); r++)
							{
								addListEventListeners(dwname,r,DZ[dwname][0][10][i][0],DZ[dwname][0][10][i][1],DZ[dwname][0][10][i][2],DZ[dwname][0][10][i][3]);
							}
						}
					}
					msg = "操作成功";
					if(postevents==undefined) postevents="";
					resetDWDialog(msg,true);
					if(postevents.length>0)eval("("+postevents+")");
				}catch(e){
					msg = "操作成功，但是页面刷新失败："+e.toString();
					resetDWDialog(msg,false);
				}
				
			}else{
				aDWResultError[0] = result.errors;
				resetDWDialog(result.errors,false);
			}
		   }
		});
};

/**
 *显示分组
 */
ALSObjectWindowFunctions.showGroup = function (groupID){
	var obj = document.getElementById('imgexpand'+groupID);
	var groupBody = document.getElementById("GroupBody_"+groupID);
	if(obj.expand=="1"){
		obj.expand = "0";
		obj.className = "info_group_collapse";
		if(groupBody)
			groupBody.style.display = "none";
	}
	else{
		obj.expand = "1";
		obj.className = "info_group_expand";
		if(groupBody)
			groupBody.style.display = "block";
	}
};

ALSObjectWindowFunctions.showItems=function(dwname,colNames){
	colNames=colNames.split(",");
	for(var i=0;i<colNames.length;i++){
		ALSObjectWindowFunctions.showItem(dwname,colNames[i],true);
	}
};

ALSObjectWindowFunctions.hideItems=function(dwname,colNames){
	colNames=colNames.split(",");
	for(var i=0;i<colNames.length;i++){
		ALSObjectWindowFunctions.showItem(dwname,colNames[i],false);
	}
};

ALSObjectWindowFunctions.showItem=function(dwname,colName,display){
	if(display==undefined) display = true; // 考虑该函数可能反复调用及Firefox的兼容性，这里将display属性由block改为‘’
	var colIndex = ALSObjectWindowFunctions.getObjectWindowColIndex(dwname,colName);
	if(colIndex!=""){
		var coldivname="#A_div_" + colIndex;
		if(dwname!="0")coldivname="#A_div_"+dwname+"_" + colIndex;
		var owdiv=$("div[name='div_my" + dwname+"']");
		var obj=owdiv.find(coldivname);//.css("display","none");
		if(obj){
			if(display)
				obj.show();
			else
				obj.hide();
			return true;
		}
		else return false;
	}else
		return false;
};


ALSObjectWindowFunctions.setItemHeader=function(dwname,colName,title){

	var dwdiv=$("div[name='div_my" + dwname+"']");
	var colIndex = ALSObjectWindowFunctions.getObjectWindowColIndex(dwname,colName);
	var obj;
	if(dwname!="0") obj = dwdiv.find("span#div_" + dwname + "_" + colIndex+"");
	else obj = dwdiv.find("span#div_" + colIndex+"");
		
	if(obj){
		var spanhtml = "<span id=\"Title_"+colIndex+"\" title=\"\">"+title+"</span>";
		obj.html(spanhtml);
	}
};

ALSObjectWindowFunctions.setItemUnit=function(dwname,colName,unit){

	var dwdiv=$("div[name='div_my" + dwname+"']");
	var colIndex = ALSObjectWindowFunctions.getObjectWindowColIndex(dwname,colName);
	var obj;
	if(dwname!="0") obj = dwdiv.find("span#Unit_" + dwname + "_" + colIndex+"");
	else obj = dwdiv.find("span#Unit_" + colIndex+"");
	if(obj){
		obj.html(unit);
	}
};

ALSObjectWindowFunctions.setItemDisabled=function(dwname,iRow,colNameString,bDisable){
	var colNameArray = colNameString.split(",");
	for(var i = 0; i < colNameArray.length; i ++){
		var obj = getObj(dwname,iRow,colNameArray[i]);
		setReadOnly(obj,bDisable);
	}
};

ALSObjectWindowFunctions.drawSubList=function(subdwname){
	document.getElementById("Table_Content_"+subdwname+"").innerHTML = TableFactory.createTableHTML(subdwname);
	$("#myiframe"+subdwname+"_float,#myiframe"+subdwname+"_static,#myiframe"+subdwname+"_cells").css({
		"overflow-x":"hidden",
		"overflow-y":"hidden"
	});
	//事件
	if(!DZ[subdwname]||!DZ[subdwname][0]||!DZ[subdwname][0][10]) return ;
	for(var i=0;i<DZ[subdwname][0][10].length;i++){
		addListEventListeners(subdwname,undefined,DZ[subdwname][0][10][i][0],DZ[subdwname][0][10][i][1],DZ[subdwname][0][10][i][2],DZ[subdwname][0][10][i][3]);
	}
};

ALSObjectWindowFunctions.setClientItemsRequired=function(dwname,colNameString,required){
	var colNameArray = colNameString.split(",");
	var objectWindowStyle=ALSObjectWindowFunctions.getObjectWindowStyle(dwname);
	if(objectWindowStyle==ALSObjectWindowFunctions.ObjectWindowStyle_Info){
		var dwdiv=$("div[name='div_my" + dwname+"']");
		for(var i = 0; i < colNameArray.length; i ++){
			var colName = colNameArray[i];
			var colIndex = ALSObjectWindowFunctions.getObjectWindowColIndex(dwname,colName);
			var coldivname="span#div_" + colIndex;
			if(dwname!="0")coldivname="span#div_"+dwname+"_" + colIndex;
			
			var obj=dwdiv.find(coldivname);
			var header = ALSObjectWindowFunctions.getObjectWindowColAttribute(dwname,colName,"COLUMNHEADER");
			if(obj){
				var spanhtml = "<span id=\"Title_"+colIndex+"\" title=\"\">"+header+"</span>";
				if(required){
					spanhtml+="<span style=\"COLOR: #ff0000\">  <DELETED>*</DELETED></span>";
				}
				obj.html(spanhtml);
			}
		}
	}
	for(var i = 0; i < colNameArray.length; i ++){
		
		var colName = colNameArray[i].toUpperCase();
		var header = ALSObjectWindowFunctions.getObjectWindowColAttribute(dwname,colName,"COLUMNHEADER");
		var sColName=colName;
		if(dwname!="0")sColName=dwname+"_"+colName;
		
		if(required){
			try{
				if(document.getElementById(sColName))
					$("#"+sColName).rules("add",{required0 : true,messages:{required0:header}});
				else
					$(document.getElementsByName(sColName)).rules("add",{required0 : true,messages:{required0:header}});
			}
			catch(e){
				var rules = _user_validator[dwname].rules;
				var messages = _user_validator[dwname].messages;
				if(!rules[colName])rules[colName] = new Object();
				if(!rules[colName].required0){
					rules[colName].required0 = true;
					if(!messages[colName]) messages[colName] = new Object();
					messages[colName].required0="请输入"+header;
				}
			}
		}
		else{
			try{
				if(document.getElementById(sColName))
					$("#"+sColName).rules("remove","required0");
				else
					$(document.getElementsByName(sColName)).rules("remove","required0");
			}
			catch(e){
				var rules = _user_validator[dwname].rules;
				var messages = _user_validator[dwname].messages;
				if(rules[colName]&&rules[colName].required0){
					rules[colName].required0 = undefined;
					messages[colName].required0=undefined;
				}
			}
		}
	}
};

ALSObjectWindowFunctions.setItemsRequired=function(dwname,colNameString,required){
	 ALSObjectWindowFunctions.setClientItemsRequired(dwname,colNameString,required);
	var serialized_ow=ALSObjectWindowFunctions.getObjectWindowMetaAttribute(dwname,"SERIALIZED_ASDFULL");

	var requiredFlag="1";
	if(!required) requiredFlag="0";
	//更新校验
	$.ajax({
		   type: "POST",
		   url: sDWResourcePath + "/RequiredRuleUpdator.jsp",
		   processData: false,
		   async:false,
		   data: "DataObject=" +serialized_ow+ "&ColName="+ colNameString + "&Required="+requiredFlag,
		   success: function(msg){
			   if(msg.substring(0,5)=="fail:"){
					  alert('校验更新失败:' +msg.substring(5));
					  return;
			   }
			   else{
				  
			   }
		   }
		});
};

ALSObjectWindowFunctions.getObjs=function(dwname,row,fieldName){
	var objectWindowStyle=ALSObjectWindowFunctions.getObjectWindowStyle(dwname);
	if(objectWindowStyle==ALSObjectWindowFunctions.ObjectWindowStyle_List){
		return ALSObjectWindowFunctions.getListObjs(dwname,row,fieldName);
	}
	else if(objectWindowStyle==ALSObjectWindowFunctions.ObjectWindowStyle_Info){
		if(fieldName==undefined||fieldName==null)fieldName=row;
		return ALSObjectWindowFunctions.getInfoObjs(dwname,fieldName);
	}
};

ALSObjectWindowFunctions.getInfoObjs=function(dwname,fieldName){
	fieldName=fieldName.toUpperCase();
	var formid = "myiframe0";//只能有一个form
	var form = document.getElementById(formid);
	if(form==null)alert(formid);
	if(dwname!="0")fieldName=dwname+"_"+fieldName;
	var objs = document.getElementsByName(fieldName);
	return objs;
};

ALSObjectWindowFunctions.getListObjs=function(dwname,row,fieldName){
	var tableId = "myiframe" + dwname;
	var colIndex = ALSObjectWindowFunctions.getObjectWindowFieldIndex(dwname, fieldName);
	var tableColIndex = TableFactory.getTableColIndexFromDZ(tableId,colIndex);
	var obj = document.getElementById("INPUT_" + tableId + "_" + fieldName + "_" + row + "_" + tableColIndex);
	if(!obj)obj = document.getElementById("INPUT_" + tableId + "_" + fieldName.toUpperCase() + "_" + row + "_" + tableColIndex);
	var objs=new Array();
	objs[0]=obj;
	return objs;
};

ALSObjectWindowFunctions.infoValidate=function(){
	var infodw_validator = {rules: {},messages:{},onsubmit:true,errorPlacement: function (error, element) {
		ALSObjectWindowFunctions.errorPlaceRule(error,element);}
	};
	var checkFlag=false;
	var result=true;
	for(var i=0;i<ALSObjectWindowFunctions.objectWindowMetaData.length;i++){
		var objectWindowStyle=ALSObjectWindowFunctions.getObjectWindowStyle(i);
		if(objectWindowStyle!=ALSObjectWindowFunctions.ObjectWindowStyle_Info) continue;
		for(colName in _user_validator[i].rules){
			var colValidators = _user_validator[i].rules[colName];
			if(i!="0") colName=i+"_"+colName;
			infodw_validator.rules[colName]=colValidators;
			checkFlag=true;
		}
		
		for(colName in _user_validator[i].messages){
			var colValidators = _user_validator[i].messages[colName];
			if(i!="0") colName=i+"_"+colName;
			infodw_validator.messages[colName]=colValidators;
		}
	}
	if(checkFlag) result = $("#myiframe0").validate(infodw_validator).form();
	return result;
};

ALSObjectWindowFunctions.errorPlaceRule=function(error, element){
	var name = element.attr('name');
	var tlabel = undefined;
	if(frames['myiframe0'] && DisplayDONO==undefined)
		tlabel = $('#' + eid + '_label',frames['myiframe0'].document);
	//alert("DisplayDONO="+ DisplayDONO + "|" + (tlabel?tlabel:element));
	if (element.is(':radio') || element.is(':checkbox')) {
		if (G_FromFormatDoc) {
			error.appendTo(tlabel?tlabel:element.parent());return;
		}
		error.appendTo(tlabel?tlabel:element.parent().parent());
	} else {
		//error.insertAfter(tlabel?tlabel:element);
		error.appendTo(element.parent());
	}
};

ALSObjectWindowFunctions.listValidate=function(){
	var form = $("#listvalid");
	var element = document.getElementById("element_listvalid");
	var result = true;
	for(var dwname=0;dwname<ALSObjectWindowFunctions.objectWindowMetaData.length;dwname++){
		var objectWindowStyle=ALSObjectWindowFunctions.getObjectWindowStyle(dwname);
		if(objectWindowStyle!=ALSObjectWindowFunctions.ObjectWindowStyle_List) continue;
		var validator = _user_validator[dwname];
		if(validator==undefined)return true;
		TableFactory.ColValidInfo[dwname] = new Array();
		_user_valid_errors[dwname] = new Array();
		if(form==undefined || form==null||form.length==0){
			form = $("#listvalid"+dwname);
			element = document.getElementById("element_listvalid"+dwname);
		}
		
		
		for(var colName in validator.rules){//sColName为字段名
			var colValidators = validator.rules[colName];
			
			for(method in colValidators){
				var rule = { method: method, parameters: colValidators[method] };
				//逐行获得数据值
				var rowCount = DZ[dwname][2].length;
				for(var i=0;i<rowCount;i++){
					element.setAttribute("errorInfo",undefined);
					var colValue = getItemValue(dwname,i,colName);//获得字段值
					if(colValue==undefined || colValue==null)colValue="";
					//sColValue = sColValue.replace(/\r/g, "");
					element.value = colValue;
					var bValid = false;
					if(rule.parameters.length==2 && rule.parameters[0].substring(0,1)=="#"){
						var colIndex = getColIndex(dwname,rule.parameters[0].substring(1));
						var myruleparams = ["#INPUT_"+dwname+"_"+rule.parameters[0].substring(1)+"_"+i+"_" + colIndex,rule.parameters[1]];
						bValid = jQuery.validator.methods[method].call( form.validate(), colValue, element, myruleparams,i );
					}
					else
						bValid = jQuery.validator.methods[method].call( form.validate(), colValue, element, rule.parameters,i );
					if(bValid==false){
						result = false;
						var title = ALSObjectWindowFunctions.getObjectWindowColAttribute(dwname, colName, "COLUMNHEADER");//DZ[dwname][1][colIndex][0];
						if(element.getAttribute("errorInfo")==undefined || element.getAttribute("errorInfo")=='undefined')
							_user_valid_errors[dwname][_user_valid_errors[dwname].length]=title + ":" + validator.messages[colName.toUpperCase()][method] + "[第" + (i+1) +"行]";
						else
							_user_valid_errors[dwname][_user_valid_errors[dwname].length]=title + ":" + element.getAttribute("errorInfo") + "[第" + (i+1) +"行]";
						TableFactory.ColValidInfo[dwname][TableFactory.ColValidInfo[dwname].length] = [i,colName];
					}
				}
			}
		}
	}
	return result;
};

ALSObjectWindowFunctions.validate=function(){
	document.getElementById("ul_error_0").innerHTML='';
	document.getElementById("ul_error_1").innerHTML='';
	document.getElementById("messageBox").style.display='none';
	
	var result=ALSObjectWindowFunctions.infoValidate()&&ALSObjectWindowFunctions.listValidate();
	return result;
};

ALSObjectWindowFunctions.setSelectOptions=function(dwname,rownum,colName,optionValues){
	var selectObj = getObj(dwname,rownum,colName);
	var options = selectObj.options;
	options.length = 1;
	for(var id in optionValues){
		var curOption = new Option(id,optionValues[id]);
		options[options.length] = curOption;
	}
	colName=colName.toUpperCase();
	selectObj.value=getItemValue(dwname,rownum,colName);
	var displayIndex=TableFactory.getTableColIndexFromDZ("myiframe"+dwname,getColIndex(dwname,colName));
	inputID = "INPUT_myiframe"+dwname+"_"+colName+"_"+rownum+"_"+displayIndex;
	AsForm.FlatSelect("#"+inputID, options, 200);
};

/***********以下所有函数均为重写，避免Info和List互相覆盖****************/

function as_save(postevent){
	ALSObjectWindowFunctions.saveAllObjectWindow(postevent);
}

function as_saveTmp(postevent){
	ALSObjectWindowFunctions.saveAllObjectWindow(postevent,true);
}

function getColIndex(dwname,fieldName){
	return ALSObjectWindowFunctions.getObjectWindowFieldIndex(dwname, fieldName);
}

function getColLabel(dwname,fieldName){
	return ALSObjectWindowFunctions.getObjectWindowColAttribute(dwname, fieldName, "COLHEADER");
}

function iV_all(dwname){
	return ALSObjectWindowFunctions.validate();
}

function showErrors(){
	ALSObjectWindowFunctions.showErrors();
}

function getResultInfo(dwname){
	var objectWindowStyle=ALSObjectWindowFunctions.getObjectWindowStyle(dwname);
	if(objectWindowStyle==ALSObjectWindowFunctions.ObjectWindowStyle_List){
		return ListObjectWindowFunctions.getResultInfo(dwname);
	}
	else if(objectWindowStyle==ALSObjectWindowFunctions.ObjectWindowStyle_Info){
		return InfoObjectWindowFunctions.getResultInfo(dwname);
	}
}

function getResultError(dwname){
	var objectWindowStyle=ALSObjectWindowFunctions.getObjectWindowStyle(dwname);
	if(objectWindowStyle==ALSObjectWindowFunctions.ObjectWindowStyle_List){
		return ListObjectWindowFunctions.getResultError(dwname);
	}
	else if(objectWindowStyle==ALSObjectWindowFunctions.ObjectWindowStyle_Info){
		return InfoObjectWindowFunctions.getResultError(dwname);
	}
}

function getResultStatus(dwname){
	var objectWindowStyle=ALSObjectWindowFunctions.getObjectWindowStyle(dwname);
	if(objectWindowStyle==ALSObjectWindowFunctions.ObjectWindowStyle_List){
		return ListObjectWindowFunctions.getResultStatus(dwname);
	}
	else if(objectWindowStyle==ALSObjectWindowFunctions.ObjectWindowStyle_Info){
		return InfoObjectWindowFunctions.getResultStatus(dwname);
	}
}

function getHiddenItemValue(dwname,rowindex,colName){
	var fieldName = colName.toUpperCase();
	if(isNaN(dwname)) dwname = dwname.substring(8);
	var rowObject = ALSObjectWindowFunctions.ObjectWindowData[dwname][rowindex];
	if(rowObject==null) return;
	var changedFields=rowObject["ChangedFields"];
	
	var value="";
	if(!changedFields||!changedFields[fieldName] && changedFields[fieldName] != "")
		value= AsCredit.getBusinessObjectAtrribute(rowObject,fieldName);
	else value= changedFields[fieldName];
	return value;
}

function getItemValue(dwname,row,fieldName){
	if(isNaN(dwname)) dwname = dwname.substring(8);
	var objectWindowStyle=ALSObjectWindowFunctions.getObjectWindowStyle(dwname);
	if(objectWindowStyle==ALSObjectWindowFunctions.ObjectWindowStyle_List){
		return ListObjectWindowFunctions.getItemValue(dwname,row,fieldName);
	}
	else if(objectWindowStyle==ALSObjectWindowFunctions.ObjectWindowStyle_Info){
		return InfoObjectWindowFunctions.getItemValue(dwname,row,fieldName);
	}
}

function setItemValue(dwname,rownum,fieldName,value){
	//需要记录所有的变更，原始List编辑存在问题，无法支持新增情况下的变更，因此变换了结构，效率不高。
	var rowObject = ALSObjectWindowFunctions.ObjectWindowData[dwname][rownum];
	var objectStatus = rowObject["ClientStatus"];
	var oldValue = AsCredit.getBusinessObjectAtrribute(rowObject,fieldName);
	
	if(value!=oldValue){
		var changedFields=rowObject["ChangedFields"];
		if(!changedFields) changedFields={};
		changedFields[fieldName.toUpperCase()]=value;
		AsCredit.setBusinessObjectPropety(rowObject,"ChangedFields",changedFields);
		if(objectStatus=="1") AsCredit.setBusinessObjectPropety(rowObject,"ClientStatus","0");//同步状态下更新为变更，其他情况下保持不变
	}
	//原有的逻辑
	var objectWindowStyle = ALSObjectWindowFunctions.getObjectWindowStyle(dwname);
	if(objectWindowStyle==ALSObjectWindowFunctions.ObjectWindowStyle_List){
		return ListObjectWindowFunctions.setItemValue(dwname,rownum,fieldName,value);
	}
	else if(objectWindowStyle==ALSObjectWindowFunctions.ObjectWindowStyle_Info){
		return InfoObjectWindowFunctions.setItemValue(dwname,rownum,fieldName,value);
	}
}

function getRowCount(dwname){
	var objectWindowStyle=ALSObjectWindowFunctions.getObjectWindowStyle(dwname);
	if(objectWindowStyle==ALSObjectWindowFunctions.ObjectWindowStyle_List){
		var tableId = "myiframe" + dwname;
		if(tableDatas[tableId])
			return tableDatas[tableId].length;
		else
			return 0;
	}
	else if(objectWindowStyle==ALSObjectWindowFunctions.ObjectWindowStyle_Info){
		var rowObject=ALSObjectWindowFunctions.ObjectWindowData[dwname][0];
		var objectStatus = rowObject["State"];
		if(objectStatus=="2") return 0;
		else return 1;
	}
}

function getRow(dwname){
	if(!dwname) dwname="0";
	var objectWindowStyle=ALSObjectWindowFunctions.getObjectWindowStyle(dwname);
	if(objectWindowStyle==ALSObjectWindowFunctions.ObjectWindowStyle_List){
		if(!isNaN(dwname)) dwname="myiframe"+dwname;
		return TableBuilder.iCurrentRow[dwname];	
	}
	else if(objectWindowStyle==ALSObjectWindowFunctions.ObjectWindowStyle_Info){
		return 0;
	}
}

function getObjs(dwname,row,fieldName){
	return ALSObjectWindowFunctions.getObjs(dwname,row,fieldName);
}

function getObj(dwname,row,fieldName){
	var objs = ALSObjectWindowFunctions.getObjs(dwname, row, fieldName);
	if(objs)
		return objs[0];
	else
		return undefined;
}

function lightRow(dwname,rowIndex,evt){
	if(!isNaN(dwname))dwname = "myiframe" + dwname;
	if(!tableDatas[dwname]) return;
	if(tableDatas[dwname].length==0)return;
	var rowCount = getRowCount(dwname);
	if(rowIndex<0) rowIndex =0;
	else if(rowIndex >=rowCount)  rowIndex = rowCount-1;
	TableBuilder.TRClick(rowIndex,undefined,"TR_Right_" + dwname + "_" + rowIndex,sWDColors[3]);
}

function setReadOnly(obj, value) {  
    if (obj) {  
    	if (obj.type == 'radio' || obj.type == 'checkbox') {  
    		if (obj.name) {  
                var arr = document.getElementsByName(obj.name);  
                var len = arr.length;  
                var tmp = null;  
                for (var i = 0; i < len; i++){
                	if(value){
            			arr[i].setAttribute("disabled","disabeld");
            		}else{
            			arr[i].removeAttribute("disabled");
            		}
                }
    		}else{
    			if(value){
        			obj.setAttribute("disabled","disabeld");
        		}else{
        			obj.removeAttribute("disabled");
        		}
    		}
    	}else if (obj.getAttribute("alstype")=="KNumber" || obj.getAttribute("alstype")=="Text" || obj.type == 'textarea') {
    		if(value){
    			obj.setAttribute("readOnly","true");
    			if(obj.className.indexOf("info_text_readonly_color")==-1)
    				obj.className+= " info_text_readonly_color";
    		}else{
    			obj.removeAttribute("readOnly");
    			obj.className = obj.className.replace('info_text_readonly_color','');
    		}
    	}else if(obj.getAttribute("alstype")=="FlatSelect"){
    		var flatSelect = $(obj).data("FlatSelect");
    		if(value){
    			$(obj).addClass("info_text_readonly_color").prop("readOnly", true);
    			if(flatSelect) $(flatSelect["input"]).addClass("info_text_readonly_color").prop("readOnly", true);
    		}else{
    			$(obj).removeClass("info_text_readonly_color").removeProp("readOnly");
    			if(flatSelect) $(flatSelect["input"]).removeClass("info_text_readonly_color").removeProp("readOnly");
    		}
    	}else{
    		if(value){
    			obj.setAttribute("disabled","disabeld");
    		}else{
    			obj.removeAttribute("disabled");
    		}
    	}
    }  
}



//控制显示模板分组信息
function showHideFields(obj,tableid){
	if(!enableFolding) return;
	if(tableid=="@SysSubNOGROUPSYS@")
		tableid = "@SysSub@";
	if(obj.expand=="1"){
		obj.expand = "0";
		obj.className = "info_group_collapse";
		if(document.getElementById(tableid))
			document.getElementById(tableid).style.display = "none";
	}
	else{
		obj.expand = "1";
		obj.className = "info_group_expand";
		if(document.getElementById(tableid))
			document.getElementById(tableid).style.display = "block";
	}
}

/*function setItemRequired(dwname,colNameString,required){
	ALSObjectWindowFunctions.setItemsRequired(dwname, colNameString, required);
}*/
