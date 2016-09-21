var ListObjectWindowFunctions={};


ListObjectWindowFunctions.getResultInfo=function(dwname){
	if(!isNaN(dwname))dwname = "myiframe" + dwname;
	var tableIndex = dwname.substring(8);
	return aDWResultInfo[tableIndex];
};

ListObjectWindowFunctions.getResultError=function(dwname){
	if(!isNaN(dwname))dwname = "myiframe" + dwname;
	var tableIndex = dwname.substring(8);
	return aDWResultError[tableIndex];
};

ListObjectWindowFunctions.getResultStatus=function(dwname){
	if(!isNaN(dwname))dwname = "myiframe" + dwname;
	var tableIndex = dwname.substring(8);
	if(aDWResultError[tableIndex]==null || aDWResultError[tableIndex]==undefined || aDWResultError[tableIndex]=='')
		return "success";
	else
		return "fail";
};

ListObjectWindowFunctions.getItemValue=function(dwname,rowindex,sColName){
	if(rowindex==-1) return undefined;
	
	if(!isNaN(dwname))dwname = "myiframe" + dwname;
	var tableIndex = dwname.substring(8);
	
	var tableId = "myiframe"+tableIndex;
	var iDZColIndex = getColIndex(tableIndex,sColName);
	var iTableColIndex = TableFactory.getTableColIndexFromDZ(tableId,iDZColIndex);
	if(iTableColIndex>-1)
		return	TableBuilder.getFomatedNumber(tableDatas[tableId][rowindex][iTableColIndex],DZ[tableIndex][1][iDZColIndex][12]) ;
	else{
		return TableBuilder.getFomatedNumber(getHiddenItemValue(tableIndex,rowindex,sColName),DZ[tableIndex][1][iDZColIndex][12]);
	}
};

ListObjectWindowFunctions.setItemValue=function(dwname,rowindex,sColName,value){
	if(!isNaN(dwname))dwname = "myiframe" + dwname;
	var tableIndex = dwname.substring(8);
	var tableId = "myiframe"+tableIndex;
	var iDZColIndex = getColIndex(tableIndex,sColName);
	var iTableColIndex = TableFactory.getTableColIndexFromDZ(tableId,iDZColIndex);
	//alert(iTableColIndex);
	if(iTableColIndex>-1){
		tableDatas[tableId][rowindex][iTableColIndex] = value;
		var div = document.getElementById('DIV_Data_'+ tableId + "_" + rowindex + "_" + iTableColIndex);
		if(DZ[tableIndex][0][2]==0 && DZ[tableIndex][1][iDZColIndex][3]=="0"){//可编辑
			var sValue = TableBuilder.convertJS2HTML(value);
			sValue =value;
			var obj = getObj(tableIndex,rowindex,sColName);
			var inputType = TableBuilder.reviseInput(DZ[tableIndex][1][iDZColIndex][11]);
			if(inputType=="select"){
				for(var i=0;i<obj.options.length;i++){
					if(obj.options[i].value==sValue)
						obj.selectedIndex = i;
				}
			}else if(inputType=="radio"){
				obj = getRadios(tableIndex,rowindex,sColName);
				for(var i=0;i<obj.length;i++){
					if(obj[i].value==sValue)
						obj[i].checked = true;
					else
						obj[i].checked = false;
				}
			}else if(inputType=="checkbox"){
				if(sValue=="1")
					obj.checked = true;
				else
					obj.checked = false;
			}else{
				sValue =TableBuilder.getFomatedNumber(sValue,DZ[tableIndex][1][iDZColIndex][12]) ;
				obj.value = sValue;
			}
		}else{
			var sValue = TableBuilder.convertJS2HTML(value);
			//alert(sValue);
			//如果有取值范围要获得从取值范围中找标题
			if(DZ[tableIndex][1][iDZColIndex][20]){
				for(var i=0;i<DZ[tableIndex][1][iDZColIndex][20].length;i+=2){
					if(DZ[tableIndex][1][iDZColIndex][20][i]==sValue){
						sValue= DZ[tableIndex][1][iDZColIndex][20][i+1];
						break;
					}
				}
			}
			
			//alert(document.getElementById("INPUT_" + tableId + "_" + sColName + "_" + rowindex + "_" + iTableColIndex).outerHTML);
			var obj = getObj(tableIndex,rowindex,sColName);
			//格式化值
			sValue =TableBuilder.getFomatedNumber(sValue,DZ[tableIndex][1][iDZColIndex][12]) ;
			obj.innerHTML = sValue;
		}
	}else{
		var sOldValue = getItemValue(dwname,rowindex,sColName);
		//alert(sOldValue + "," +value );
		if(value!=sOldValue){
			var objx = getChangedObj(rowindex,sColName);
			if(objx)
				objx[2] = value;
			else{
				HiddenChangedValues[HiddenChangedValues.length]= [rowindex,sColName,value];
			}
		}
	}
};

ListObjectWindowFunctions.updateSuccess=function(msg,postevents){
	as_dw_sMessage = msg;
	as_dw_sPostEvent = postevents;
	iOverDWHandler = window.setInterval(checkFrameReady, 5);
};

ListObjectWindowFunctions.as_isPageChanged=function(){
	var sData = getChangedValues(0);
	if(sData == '<root></root>')
		return false;
	else
		return true;
};

ListObjectWindowFunctions.as_createFormDatas=function(){
	var result = new Object();
	result.type="list";
	//"&UPDATED_FIELD=" + getChangedValues(tableIndex) + "&SelectedRows="+ getSelRows(tableIndex).toString() +"&SYS_ACTION=" + action)),
	result.serializedJbo=DZ[0][0][9];
	result.serializedAsd=DZ[0][0][8];
	result.updatedFields=getChangedValues(0);
	
	result.selectedRows=getSelRows(0).toString();
	result.curpage=s_c_p[0];
	
	return result;
};


ListObjectWindowFunctions.change_height=function(){	
	if(TableBuilder.noChangeHeight==true)return;
	if(aDWfilterTitles[0].length==0)document.getElementById('TableFilter_DIV_PARENT').style.display='none';
	try {
		document.getElementById("Right_TD_myiframe0").style.width = "";
		document.getElementById("Right_TD_myiframe0").style.width = document.body.offsetWidth - document.getElementById("Left_TD_myiframe0").offsetWidth - 10;
		//以下两行替换上面一行，解决chrome宽度显示问题
		document.getElementById("myiframe0_float").style.width = document.getElementById("Right_TD_myiframe0").style.width;
		document.getElementById("myiframe0_cells").style.width = document.getElementById("Right_TD_myiframe0").style.width;
		var iTurnPageHeight =4;
		
		if(document.getElementById("Page_myiframe0"))
			iTurnPageHeight = document.getElementById("Page_myiframe0").offsetHeight + 16;
		var myNewHeight = document.body.offsetHeight 
			- document.getElementById("DWTD").offsetTop
			- document.getElementById("myiframe0_static").offsetTop;
		/*
		var oFilterArea = document.getElementById("TableFilter_AREA");
		if(oFilterArea.style.display != "none")
			myNewHeight -= oFilterArea.offsetHeight;
		*/
		/*
		var messageBox = document.getElementById("messageBox");
		if(messageBox && messageBox.style.display != "none")
			myNewHeight -= messageBox.offsetHeight+13;
			//- iTurnPageHeight;
		 */
		//alert(document.getElementById("WizardDiv").offsetHeight);
		var adjustHeight = 0;
		if(window.getAdjustHeight)
			adjustHeight = getAdjustHeight();
		else
			adjustHeight = getAdjustHeight2();
		if(document.getElementById("Page_myiframe0")){
			document.getElementById("myiframe0_static").style.height  = myNewHeight -30-adjustHeight-((sButtonPosition=="south"||sButtonPosition=="both")?document.getElementById("ListButtonArea").offsetHeight+2:0);
			document.getElementById("myiframe0_cells").style.height  = myNewHeight-30-adjustHeight-((sButtonPosition=="south"||sButtonPosition=="both")?document.getElementById("ListButtonArea").offsetHeight+2:0);		
		}else{
			document.getElementById("myiframe0_static").style.height  = myNewHeight-adjustHeight-((sButtonPosition=="south"||sButtonPosition=="both")?document.getElementById("ListButtonArea").offsetHeight+2:0);
			document.getElementById("myiframe0_cells").style.height  = myNewHeight-adjustHeight-((sButtonPosition=="south"||sButtonPosition=="both")?document.getElementById("ListButtonArea").offsetHeight+2:0);		
		}
	} catch (e) { 
	}
};

TableBuilder.header_reloadEvents = function(dwname,row){
	//因为重写了html,所以事件需要重新调用
	if(DZ[dwname][0][10]){
		for(var i=0;i<DZ[dwname][0][10].length;i++){
			addListEventListeners(0,row,DZ[dwname][0][10][i][0],DZ[dwname][0][10][i][1],DZ[dwname][0][10][i][2]);
		}
	}
	//change_height();
};