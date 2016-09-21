	/*~[Describe=计算到期日;InputParam=无;OutPutParam=无;]~*/
	function CalcMaturity(){
		var sMaturity ="";
		var sLoanTermFlag ="";
		var sTermMonth = getItemValue(0,getRow(),"TermMonth");
		var sTermDay = getItemValue(0,getRow(),"TermDay");
		var sPutOutDate = getItemValue(0,getRow(),"PutOutDate");
		if(typeof(sTermMonth)== "undefined" || sTermMonth.length == 0 || typeof(sPutOutDate)=="undefined" || sPutOutDate.length == 0 || typeof(sTermDay)== "undefined" || sTermDay.length == 0) {
			return ;
		}
		if(sTermMonth !=0){
		   sLoanTermFlag ="020";
		   sMaturity = RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.CalcMaturity","calcMaturity","loanTermFlag="+sLoanTermFlag+",loanTerm="+sTermMonth+",putOutDate="+sPutOutDate);
		   setItemValue(0,getRow(),"Maturity",sMaturity);
		}
		if(sTermDay !=0){
		   sLoanTermFlag ="010";
		   sBusinessDate = getItemValue(0,getRow(),"Maturity");
		   sMaturity = RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.CalcMaturity","calcMaturity","loanTermFlag="+sLoanTermFlag+",loanTerm="+sTermDay+",putOutDate="+sBusinessDate);
		}
        setItemValue(0,getRow(),"Maturity",sMaturity);
	}
	
	//------来源于acct_js--2015年11月24日
	
	function setTransactionCodeValue(sParaString,sValueString,iArgDW,iArgRow,sStyle){
		if(typeof(sStyle)=="undefined" || sStyle=="")
			sStyle = "dialogWidth:700px;dialogHeight:540px;resizable:yes;scrollbars:no;status:no;help:no";
		var iDW = iArgDW;
		if(isNaN(iDW)) iDW=0;
		var iRow = iArgRow;
		if(isNaN(iRow)) iRow=0;
		var sValues = sValueString.split("@");
		var i=sValues.length;
	 	i=i-1;
	 	if (i%2!=0){
	 		alert("setTransactionCodeValue()返回参数设定有误!\r\n格式为:@ID列名@ID在返回串中的位置...");
	 		return;
	 	}else{
			var j=i/2,m,sColumn,iID;
			var sObjectNoString = selectTransactionCodeValue(sParaString,sStyle);
			if(typeof(sObjectNoString)=="undefined" || sObjectNoString=="null" || sObjectNoString==null || sObjectNoString=="_CANCEL_" ){
				return;	
			}else if(sObjectNoString=="_CLEAR_"){
				for(m=1;m<=j;m++){
					sColumn = sValues[2*m-1];
					if(sColumn!="")
						setItemValue(iDW,iRow,sColumn,"");
				}
			}else if(sObjectNoString!="_NONE_" && sObjectNoString!="undefined"){
				sObjectNos = sObjectNoString.split("@");
				for(m=1;m<=j;m++){
					sColumn = sValues[2*m-1];
					iID = parseInt(sValues[2*m],10);
					
					if(sColumn!="")
						setItemValue(iDW,iRow,sColumn,sObjectNos[iID]);
				}	
			}else{
				//alert("选取对象编号失败！对象类型："+sObjectType);
				return;
			}
			return sObjectNoString;
		}
	}



	function selectTransactionCodeValue(sParaString,sStyle){
		if(typeof(sStyle)=="undefined" || sStyle=="") sStyle = "dialogWidth:680px;dialogHeight:540px;resizable:yes;scrollbars:no;status:no;help:no";
		sObjectNoString = PopPage("/Accounting/Transaction/TransactionCodeSelect.jsp?ParaString="+sParaString,"",sStyle);
		return sObjectNoString;
	}



	function acct_vI_all(objpname){
		if(!beforeVIAll(objpname)) return false;
		if(SAVE_TMP)return true;
		var isIE6 =/MSIE 6.0/.test(navigator.userAgent);
		if(isIE6==false && _user_validator.length>1){
			if($("#form1",frames[objpname].document).validate(_user_validator[1])==undefined)return true;
			try{
				var result=$("#form1",frames[objpname].document).validate(_user_validator[1]).form();
			}catch(e){
				return true;
			}
			return result;
		}
		
		else{//list模式
			var tableIndex = 0;
			var form;
			if(!document.getElementById("listvalid0")){
				var formobj = document.createElement("form");
				formobj.setAttribute("id","listvalid0");
				document.body.appendChild(formobj);
			}
			form = $("#listvalid" +tableIndex );
			var element = document.createElement("input");//document.getElementById("element_listvalid" + tableIndex);
			element.setAttribute("type","hidden");
			var errmsgs = new Array();
			var rules = _user_validator[0].rules;
			for(sColName in rules){//sColName为字段名
				var colValidators = rules[sColName];
				for(method in colValidators){
					rule = { method: method, parameters: colValidators[method] };
					//逐行获得数据值
					var iDataSize = DZ[tableIndex][2].length;
					for(var i=0;i<iDataSize;i++){
						element.setAttribute("errorInfo",undefined);
						var iColIndex = getColIndexIngoreCase(tableIndex,sColName);
						var sColValue = getItemValueByIndex(tableIndex,i,iColIndex);//获得字段值
						if(typeof(sColValue)=='string')
						sColValue = sColValue.replace(/\r/g, "");
						element.name = getColName(tableIndex,iColIndex);
						element.value = sColValue;
						var bValid = false;
						bValid = jQuery.validator.methods[method].call( form.validate(), sColValue, element, rule.parameters,i );
						if(bValid==false){
							bResult = false;
							var title = DZ[tableIndex][1][iColIndex][0];
							if(element.getAttribute("errorInfo")==undefined || element.getAttribute("errorInfo")=='undefined')
								errmsgs[errmsgs.length]=title + ":" + _user_validator[0].messages[sColName.toUpperCase()][method] + (_user_validator.length>1?"":"[第" + (i+1) +"行]");
							else
								errmsgs[errmsgs.length]=title + ":" + element.getAttribute("errorInfo") + (_user_validator.length>1?"":"[第" + (i+1) +"行]");
						}
					}
				}
			}
			if(errmsgs.length>0){
				alert(errmsgs.join('\n'));
				return false;
			}
			else
				return true;
		}
	}