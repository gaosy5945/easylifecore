function setBusinessRate(){
	var businessRate=getItemValue(0,getRow(),"BusinessRate");

	setBaseRate();
   	var baseRate = getItemValue(0,getRow(),"BaseRate");
   	if(typeof(baseRate) == "undefined" || baseRate == "" || baseRate == 0){
   		return;
   	}
   	var rateFloatType = getItemValue(0,getRow(),"RateFloatType");
   	if(typeof(rateFloatType) == "undefined" || rateFloatType.length == 0){
   		return;
   	}
   	var rateFloat = getItemValue(0,getRow(),"RateFloat");
   	if(typeof(rateFloat) == "undefined" || rateFloat.length == 0){
   		return;
   	}
   	var loanRate = getExecuteRate(parseFloat(baseRate)*1.0,rateFloatType+"",parseFloat(rateFloat)*1.0);
   	if(typeof(loanRate) == "undefined" || loanRate.length == 0){
   		alert("δ��ȡ��ִ�����ʣ�");
   		return;
   	}
	if(loanRate<0){
		alert("�����ִ�����ʲ���С��0��");
		return;
	}
   	setItemValue(0,getRow(),"BusinessRate",loanRate.toFixed(14));
}

//�����׼���ʣ���ҳ��¼�뿪ʼʱ�䡢����ʱ�䡢��׼��������
function setBaseRate(){
	var baseRateType = getItemValue(0,getRow(),"BaseRateType");
	var rateUnit = getItemValue(0,getRow(),"RateUnit");
	var baseRateGrade = getItemValue(0,getRow(),"BaseRateGrade");
	if(typeof(baseRateType) == "undefined" || baseRateType == "" || baseRateType == null)return;
	if(typeof(baseRateGrade) == "undefined" || baseRateGrade == "" || baseRateGrade == null)return;
	var baseRate = AsControl.RunJavaMethod("com.amarsoft.app.base.util.RateHelper","getBaseRate","currency="+currency+",yearDays="+yearDays+",baseRateType="+baseRateType+",RateUnit="+rateUnit+",putoutDate="+putoutDate+",maturityDate="+maturityDate+",effectDate="+businessDate);
	if(typeof(baseRate) == "undefined" || baseRate.length == 0 || baseRate == null){
		alert("�����Ƿ��Ѿ�ά����׼���ʣ�");
		return;
	}
	setItemValue(0,getRow(),"BaseRate",baseRate);
}

function getExecuteRate(baseRate,rateFloatType,rateFloat){
	if(rateFloatType == "0" || rateFloatType == 0){
		return baseRate*(1.0+rateFloat/100.0);
	}else if(rateFloatType == "1" || rateFloatType == 1){
		return baseRate+rateFloat/100.0;
	}else{
		return baseRate;
	}
}

//��̬��ʾ��׼���ʵ���ѡ��
function setBaseRateGrade()
{
	var baseRateType = getItemValue(0,getRow(),"BaseRateType");
	if(typeof(baseRateType) == "undefined" || baseRateType == "" || baseRateType == null)return;
	var baseRateGrade = AsControl.RunJavaMethod("com.amarsoft.app.base.util.RateHelper","getBaseRateGrade","currency="+currency+",baseRateType="+baseRateType+",putoutDate="+putoutDate+",maturityDate="+maturityDate+",effectDate="+businessDate);
	if(typeof(baseRateGrade) == "undefined" || baseRateGrade.length == 0 || baseRateGrade == null) return;
	setItemValue(0,getRow(),"BaseRateGrade",baseRateGrade);
	 setBusinessRate();
}

/*~[Describe=��ѯ���ʵ�����ʽ;InputParam=��;OutPutParam=��;]~*/
function setRepriceInfo(){
	var sResult = getItemValue(0,getRow(),"RepriceType");
	if("8"!=sResult){
		setItemValue(0,getRow(),"RepriceTerm","");
		setItemValue(0,getRow(),"DefaultRepriceDate","");
		setItemValue(0,getRow(),"RepriceTermUnit","");
		hideItem(0,"RepriceTerm");
		hideItem(0,"DefaultRepriceDate");
		hideItem(0,"RepriceTermUnit");
		setItemRequired(0,"RepriceTerm",false);
		setItemRequired(0,"DefaultRepriceDate",false);
		setItemRequired(0,"RepriceTermUnit",false);
		//setItemUnit(0,getRow(),"RepriceDate","");
		return;
	}else{
		showItem(0,"RepriceTerm");
		showItem(0,"DefaultRepriceDate");
		showItem(0,"RepriceTermUnit");
		setItemRequired(0,"RepriceTerm",true);
		setItemRequired(0,"DefaultRepriceDate",true);
		setItemRequired(0,"RepriceTermUnit",true);
		//setItemUnit(0,getRow(),"RepriceDate","<input class=inputdate type=button value=... onClick=parent.selectDate(\"RepriceDate\");>");
		return;
	}
}