var filterOperatorMap={};
filterOperatorMap["Equals"]="等于";
filterOperatorMap["In"]="等于";//单选下的In
filterOperatorMap["OrgIn"]="等于";//机构及其下属机构
filterOperatorMap["MultiIn"]="包含";//多选下的In
filterOperatorMap["BeginsWith"]="以…开始";
filterOperatorMap["NotBeginsWith"]="不以…开始";
filterOperatorMap["Not"]="不等于";
filterOperatorMap["BigThan"]="大于";
filterOperatorMap["BigEqualsThan"]="大于等于";
filterOperatorMap["LessThan"]="小于";
filterOperatorMap["LessEqualsThan"]="小于等于";
filterOperatorMap["Area"]="在…之间";
filterOperatorMap["Like"]="包含";



TableFactory.search = function(dwIndex,params,isSerializJbo,lightRowIndex,from){
	if(params==undefined)params="";
	var tableId = "myiframe" + dwIndex;
	if(!filterValues[tableId]) return;
	
	for(var i=0;i<aDWfilterTitles[dwIndex].length;i++){
		if(aDWfilterTitles[dwIndex][i]==undefined || aDWfilterTitles[dwIndex][i]=='')continue;
		var filterColID = filterNames[dwIndex][i];//查询字段ID
		var filterColID_UpperName = filterColID.toUpperCase();//查询字段大写名称
		var colIndex = getColIndex(dwIndex,filterColID);
		filterColID=DZ[dwIndex][1][colIndex][15];
		var filterValue1=filterValues["myiframe"+dwIndex][filterColID];
		var filterValue2=filterValues2["myiframe"+dwIndex][filterColID];
		if(filterValue1==undefined)filterValue1 = "";
		if(filterValue2==undefined)filterValue2 = "";
		if(filterValue1==""&&filterValue2=="") continue;
		var operator = document.getElementById("DOFILTER_DF_"+ filterColID_UpperName +"_1_OP").value;

		params += "&DOFILTER_DF_"+ filterColID_UpperName +"_1_OP=" + operator;
		params += "&DOFILTER_DF_"+ filterColID_UpperName +"_1_VALUE=" +encodeURI(filterValue1);
		params += "&DOFILTER_DF_"+ filterColID_UpperName +"_2_VALUE=" +encodeURI(filterValue2);
	}
	if(lightRowIndex!=undefined)
		TableFactory.DO2(sDWResourcePath + "/ListSearch.jsp",dwIndex,"search",undefined,undefined,params,isSerializJbo,lightRowIndex);
	else
		TableFactory.DO(sDWResourcePath + "/ListSearch.jsp",dwIndex,"search",undefined,undefined,params,isSerializJbo);
};

//清空过滤输入项
function clearFilter(dwIndex){
	var tableId = "myiframe"+dwIndex;
	for(var i=0;i<aDWfilterTitles[dwIndex].length;i++){
		var filterColID = filterNames[dwIndex][i];//查询字段ID
		if(aDWfilterTitles[dwIndex][i]==undefined || aDWfilterTitles[dwIndex][i]=='')continue;
		var colIndex = getColIndex(dwIndex,filterColID);
		filterColID=DZ[dwIndex][1][colIndex][15];
		filterValues[tableId][filterColID] = "";
		filterValues2[tableId][filterColID] = "";
		DZ[dwIndex][1][colIndex][22]="";
		var value1obj=document.getElementsByName("DOFILTER_DF_"+filterColID+"_1_VALUE");
		var value2obj=document.getElementsByName("DOFILTER_DF_"+filterColID+"_2_VALUE");
		if(value1obj&&value1obj[0]){
			value1obj[0].value="";
		}
		if(value2obj&&value2obj[0]){
			value2obj[0].value="";
		}
	}	
};

function selectFilterValues(dwIndex,filterColID){
	
	var tableId = "myiframe"+dwIndex;
	var filterColID_UpperName = filterColID.toUpperCase();//查询字段大写名称
	var colIndex = getColIndex(dwIndex,filterColID);
	var result={};
	if(DZ[dwIndex][1][colIndex][21] && DZ[dwIndex][1][colIndex][21]!=""){//自定义弹出框
		result = eval(DZ[dwIndex][1][colIndex][21]);
	}
	else{//根据选项自动生成弹出框
		var dono=DisplayDONO;
		var style = "dialogWidth:680px;dialogHeight:540px;resizable:yes;scrollbars:no;status:no;help:no";
		result = PopPage("/Common/OW/fitler/OWColumnCodeSelector.jsp?DoNo="+dono+"&ColName="+filterColID,"",style);
		if(result==undefined) return;
	}
	if(result["ID"]=="_CANCEL_"){
		result["ID"]="";
		result["Name"]="";
	}
	document.getElementById("DOFILTER_DF_"+ filterColID_UpperName +"_1_VALUE").value=result["ID"];
	document.getElementById("DOFILTER_DF_"+ filterColID_UpperName +"_2_VALUE").value=result["Name"];
	filterValues[tableId][filterColID] = result["ID"];
	filterValues2[tableId][filterColID] = result["Name"];
}

//生成输入框
function getFilterColHTML(dwIndex,filterColID,operator,value1,value2){
	var colInput1HTML="";
	var colInput2HTML="";
	var colIndex = getColIndex(dwIndex,filterColID);
	var filterColID_UpperName = filterColID.toUpperCase();//查询字段大写名称
	
	var inputLength = DZ[dwIndex][1][colIndex][7];//长度限制
	if(inputLength==0) inputLength=120;
	//alert(filterColID+DZ[dwIndex][1][colIndex][20].length);
	if(DZ[dwIndex][1][colIndex][21] && DZ[dwIndex][1][colIndex][21]!=""
		||DZ[dwIndex][1][colIndex][20]&&DZ[dwIndex][1][colIndex][20].length>40){//自定义弹出选项
		colInput1HTML="<input readonly=true class='filter_input_text' type='text' name='DOFILTER_DF_"+ filterColID_UpperName +"_2_VALUE' listfilter='true' tablecolindex='"+dwIndex+"' value='"+ value2 +"'>";
		colInput1HTML+="<input class='info_unit_button' value='..' type=button onClick=selectFilterValues('"+dwIndex+"','"+filterColID+"')>";
		colInput2HTML="<input class='filter_input_text' type='text' name='DOFILTER_DF_"+ filterColID_UpperName +"_1_VALUE' listfilter='true' tablecolindex='"+dwIndex+"' value='"+ value1 +"'>";
		
	}
	else if(DZ[dwIndex][1][colIndex][11]=="Text"&&DZ[dwIndex][1][colIndex][12]=="1"){//文本
		colInput1HTML="<input maxlength="+inputLength+" class='filter_input_text' type='text' name='DOFILTER_DF_"+ filterColID_UpperName +"_1_VALUE' listfilter='true' tablecolindex='"+dwIndex+"' value='"+ value1 +"'"
				+ " onChange=setFitlerValue('"+dwIndex+"','"+filterColID+"',1,this.value)>";
	}
	else if(DZ[dwIndex][1][colIndex][11]=="Date"){//日期
		var minDate = "1900/01/01";
		var maxDate = "2100/12/31";
		var dateString = " onblur=\"MRCheckDate(this);TableFactory.fireEvent(this,'onchange')\" onclick=\"SelectDate(this,'yyyy\/MM\/dd','"+minDate+"','"+maxDate+"',undefined,undefined,undefined,false)\"";

		colInput1HTML="<input maxlength=10 class='filter_input_text' type='text' name='DOFILTER_DF_"+ filterColID_UpperName +"_1_VALUE' listfilter='true' tablecolindex='"+dwIndex+"' value='"+ value1 +"'"
						+ " onChange=setFitlerValue('"+dwIndex+"','"+filterColID+"',1,this.value) "+dateString+">";
		
		colInput2HTML="<input maxlength=10 class='filter_input_text' type='text' name='DOFILTER_DF_"+ filterColID_UpperName +"_2_VALUE' listfilter='true' tablecolindex='"+dwIndex+"' value='"+ value2 +"'"
					+ " onChange=setFitlerValue('"+dwIndex+"','"+filterColID+"',2,this.value) "+dateString+">";
	}
	else if(DZ[dwIndex][1][colIndex][11]=="Text"//数字
		&&(DZ[dwIndex][1][colIndex][12]==2 ||DZ[dwIndex][1][colIndex][12]==5||DZ[dwIndex][1][colIndex][12]==6|| DZ[dwIndex][1][colIndex][12]==7|| DZ[dwIndex][1][colIndex][12]==10)){//数字
		colInput1HTML="<input maxlength=10 class='filter_input_text' type='text' name='DOFILTER_DF_"+ filterColID_UpperName +"_1_VALUE' listfilter='true' tablecolindex='"+dwIndex+"' value='"+ value1 +"'"
			+ " onChange=setFitlerValue('"+dwIndex+"','"+filterColID+"',1,this.value)>";

		colInput2HTML="<input maxlength=10 class='filter_input_text' type='text' name='DOFILTER_DF_"+ filterColID_UpperName +"_2_VALUE' listfilter='true' tablecolindex='"+dwIndex+"' value='"+ value2 +"'"
			+ " onChange=setFitlerValue('"+dwIndex+"','"+filterColID+"',2,this.value)>";
	}
	else if(DZ[dwIndex][1][colIndex][11]=="Select"||DZ[dwIndex][1][colIndex][11]=="Radiobox"
		||DZ[dwIndex][1][colIndex][11]=="RadioboxV"||DZ[dwIndex][1][colIndex][11]=="FlatSelect"
			||DZ[dwIndex][1][colIndex][11]=="Checkbox"||DZ[dwIndex][1][colIndex][11]=="Checkbox2"
				||DZ[dwIndex][1][colIndex][11]=="MultiSelect"){//选项
		colInput1HTML=getCodeSelectHtml(dwIndex, colIndex,filterColID);
	}
	else{
		colInput1HTML="<input maxlength="+inputLength+" class='filter_input_text' type='text' name='DOFILTER_DF_"+ filterColID_UpperName +"_1_VALUE' listfilter='true' tablecolindex='"+dwIndex+"' value='"+ value1 +"'"
				+ " onChange=setFitlerValue('"+dwIndex+"','"+filterColID+"',1,this.value)>";
	}
	//生成完整HTML
	var spvaldisplay = "none";
	if(operator=="Area") spvaldisplay="inline";
	var colInputHTML=colInput1HTML+"<span id='AREA_SPAN_"+dwIndex+"_"+colIndex+"' style='display:"+spvaldisplay+"'>-"+colInput2HTML+"</span>";
	return colInputHTML;
}

function setFitlerValue(dwIndex,filterColID,valueType,value){
	if(valueType==1)
		filterValues["myiframe"+dwIndex][filterColID]=value;
	if(valueType==2)
		filterValues2["myiframe"+dwIndex][filterColID]=value;
}

function showAreaInput(dwIndex,colindex,operator,colname,value){
	filterOptions["myiframe"+dwIndex][colname]=value;
	colname=colname.toUpperCase();
	var objval2 = document.getElementById('AREA_SPAN_'+dwIndex+'_'+colindex+'');
	if(operator=="Area"){
		objval2.style.display='inline';
	}else{
		objval2.style.display='none';
	}
}

function openFilterArea(divid,dwIndex,evt){
	var filterobj = document.getElementById(divid);
	var fitlerHtml = new StringBuffer();
	fitlerHtml.append('<div id="TableFilter_WhereClause">');
	fitlerHtml.append('<table width="100%" border="0" cellspacing="0" cellpadding="0">');
	for(var i=0;i<aDWfilterTitles[dwIndex].length;i++){
		if(aDWfilterTitles[dwIndex][i]==undefined || aDWfilterTitles[dwIndex][i]=='')continue;
		var filterColID = filterNames[dwIndex][i];//查询字段ID
		var colIndex = getColIndex(dwIndex,filterColID);
		filterColID=DZ[dwIndex][1][colIndex][15];
		var filterColName = aDWfilterTitles[dwIndex][i];//查询字段名称
		var filterColID_UpperName = filterColID.toUpperCase();//查询字段大写名称
		var fitlerOperatorValue = filterOptions["myiframe"+dwIndex][filterColID];
		var filterValue1 = filterValues["myiframe"+dwIndex][filterColID];
		var filterValue2 = filterValues2["myiframe"+dwIndex][filterColID];
		if(filterValue1==undefined)filterValue1 = "";
		if(filterValue2==undefined)filterValue2 = "";
		var filterOperator=new Array();
		if(DZ[dwIndex][1][colIndex][22] && DZ[dwIndex][1][colIndex][22]!=""){//自定义了运算符
			var filterOperator_T=DZ[dwIndex][1][colIndex][22].split(",");
			for(var j=0;j<filterOperator_T.length;j++){
				if(filterOperator_T[j].indexOf("=")>0){
					var t=filterOperator_T[j].split("=");
					filterOperatorMap[t[0]]=t[1];
					filterOperator[j]=t[0];
				}
				else{
					filterOperator[j]=filterOperator_T[j];
				}
			}
		}
		else{//未指定运算符的则根据类型自动判断
			//1.日期控件和数字控件
			if(DZ[dwIndex][1][colIndex][11]=="Date" 
				|| DZ[dwIndex][1][colIndex][11]=="Text" && (DZ[dwIndex][1][colIndex][12]==2 ||DZ[dwIndex][1][colIndex][12]==5||DZ[dwIndex][1][colIndex][12]==6|| DZ[dwIndex][1][colIndex][12]==7|| DZ[dwIndex][1][colIndex][12]==10)){
				filterOperator[0]="Equals";
				filterOperator[1]="BigThan";
				filterOperator[2]="LessThan";
				filterOperator[3]="Area";
			}
			else if(DZ[dwIndex][1][colIndex][11]=="Select"||DZ[dwIndex][1][colIndex][11]=="Radiobox"
				||DZ[dwIndex][1][colIndex][11]=="RadioboxV"||DZ[dwIndex][1][colIndex][11]=="FlatSelect"){//单选
				filterOperator[0]="In";
			}
			else if(DZ[dwIndex][1][colIndex][11]=="Checkbox"||DZ[dwIndex][1][colIndex][11]=="Checkbox2"
				||DZ[dwIndex][1][colIndex][11]=="MultiSelect"){//多选
				filterOperator[0]="MultiIn";
			}
			else if(DZ[dwIndex][1][colIndex][11]=="Text"){//文本
				filterOperator[0]="Equals";
				filterOperator[1]="BeginsWith";
				filterOperator[2]="Like";
			}
		}
		
		//生成HTML
		//1.名称
		var filterNameHTML="<span style='white-space: nowrap;display:block;width:100%;'>" + filterColName + "：</span>";
		//2.运算符
		var operatorHTML="<span id='DOFILTER_MAIN0_"+filterColName+"'><select style='width:92px;' name='DOFILTER_DF_"+ filterColID_UpperName +"_1_OP' id='DOFILTER_DF_"+ filterColID_UpperName +"_1_OP'  onchange=showAreaInput('"+dwIndex+"',"+colIndex+",this.value,'"+filterColID+"',this.value)>";
		for(var m=0;m<filterOperator.length;m++){
			var selected="";
			if(filterOperator[m]==fitlerOperatorValue){
				selected="selected";
			}
			operatorHTML+="<option value='"+filterOperator[m]+"' "+selected+">"+filterOperatorMap[filterOperator[m]]+"</option>";		
		}
		operatorHTML+="</select></span>";
		//3.数据输入框
		var dataHTML=getFilterColHTML(dwIndex,filterColID,fitlerOperatorValue,filterValue1,filterValue2);
		
		fitlerHtml.append("<tr><td width='10' style='text-align: right;' nowrap valign='middle'>"+filterNameHTML+"</td>");
		fitlerHtml.append("<td width='60'>" +operatorHTML+"</td>");
		fitlerHtml.append("<td><span id='DOFILTER_MAIN1_"+filterColName+"'>"+dataHTML+"</span></td></tr>");
	}
	fitlerHtml.append('</table>');
	fitlerHtml.append('</div>');
	//生成按钮
	fitlerHtml.append('<div style="padding-top:10px;border-top:2px solid #fff;">' + DWFullFiterButtons2 + '</div>');
	filterobj.innerHTML = fitlerHtml.toString();
	if(window.afterOpenFilterArea)afterOpenFilterArea();
}

function getCodeSelectHtml(dwIndex, colIndex,filterColID){
	var id = "filter_btsel_"+dwIndex+"_"+colIndex;
	setTimeout(function(){
		var time = null, aValue = new Array();
		var input = $("#"+id).focus(function(){focus();}).blur(blur).keyup(keyup).keydown(keydown);
		var shower = input.parent().prev().click(function(e){
			var a = e.target;
			if(a.tagName.toUpperCase()!="A") return;
			removeValue(a.parentNode);
		});
		shower.parent().click(function(){
			input.focus();
		});
		var editor = input.prev();
		editor.click(function(e){
			var a = e.target;
			if(a.tagName.toUpperCase()!="A") return;
			clearTimeout(time);
			addValue(a);
			editor.hide().parent().css("position", "");
			AsLink.stopEvent(e);
		});
		focus(true);
		
		function keyup(){
			var value = input.val();
			editor.find("a").each(function(){
				var a = this;
				var flag = true;
				if($(a).text().indexOf(value) > -1){
					shower.find(">span").each(function(){
						if($(this).data("a")[0] == a)
							return flag = false;
					});
				}else{
					flag = false;
				}
				if(flag){
					$(a).show();
				}else{
					$(a).hide();
				}
			});
		}
		
		function keydown(e){
			if(e.keyCode != 8) return;
			if(input.val()) return;
			var span = shower.find(">span:last");
			if(span.length < 1) return;
			removeValue(span);
		}
		
		function saveValue(){
			var valueCode = "";
			for(var i = 0; i < aValue.length; i++){
				if(i != 0) valueCode += "|";
				valueCode += aValue[i];
			}
			filterValues["myiframe"+dwIndex][filterColID] = valueCode;
		}
		
		function removeValue(span){
			span = $(span);
			var ra = span.data("a");
			span.remove();
			aValue.splice(aValue.indexOf(ra.attr("value")), 1);
			saveValue();
			ra.show();
		}
		
		function addValue(a){
			a = $(a);
			shower.append($("<span><a href='javascript:void(0)' onclick='return false'>&nbsp;</a>"+a.text()+"</span>").data("a",a));
			aValue.push(a.attr("value"));
			saveValue();
			a.hide();
			input.val("");
		}
		
		function focus(init){
			if(init){
				var valueCode = filterValues["myiframe"+dwIndex][filterColID];
				var valueName = filterValues2["myiframe"+dwIndex][filterColID];
				if(valueCode==undefined) valueCode = "";
				if(valueName==undefined) valueName = "";
				
				for(var ii = 0; ii < DZ[dwIndex][1][colIndex][20].length; ii+=2){
					if(!DZ[dwIndex][1][colIndex][20][ii]) continue;
					var a = $("<a href='javascript' onclick='return false;' value='"+DZ[dwIndex][1][colIndex][20][ii]+"' >"+DZ[dwIndex][1][colIndex][20][ii+1]+"</a>");
					if(TableBuilder.isStrInArray(valueCode.split("|"),DZ[dwIndex][1][colIndex][20][ii])>-1){
						addValue(a[0]);
					}
					editor.append(a);
				}
			}else{
				keyup();
				editor.show().parent().css("position", "relative");
			}
		}
		
		function blur(e){
			time = setTimeout(function(){
				editor.hide().parent().css("position", "");
			}, 500);
		}
	}, 100);
	return "<span class='filter_btsel' ><span class='shower' onclick='AsLink.stopEvent(event);' ></span><span class='editor' ><span></span><input id='"+id+"' /></span></span>";
}