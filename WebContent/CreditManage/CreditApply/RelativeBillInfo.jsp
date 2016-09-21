<%@page import="com.amarsoft.are.jbo.BizObject"%>
<%@page import="com.amarsoft.app.als.credit.model.CreditObjectAction"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
 <script>
 var cityArray = new Array();
 var areaArray = new Array();
 </script>
<%
	String PG_TITLE = "���Ʊ����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	//�������
	ASResultSet rs =null ;
	String contractSerialNo="";
	
	//����������
	String sObjectType = CurPage.getParameter("ObjectType");
	String sObjectNo = CurPage.getParameter("ObjectNo");
	contractSerialNo = CurPage.getParameter("ContractSerialNo");
	String sBusinessType = CurPage.getParameter("BusinessType");
	String sSerialNo    = CurPage.getParameter("SerialNo");

	if(sObjectType==null) sObjectType="";
	if(sObjectNo==null) sObjectNo="";
	if(contractSerialNo==null) contractSerialNo="";
	if(sBusinessType==null) sBusinessType="";
	if(sSerialNo == null ) sSerialNo = "";
	
	if(sObjectType.equals("AfterLoan")) sObjectType = "BusinessContract";

	//ͨ����ʾģ�����ASDataObject����doTemp
	ASObjectModel doTemp = new ASObjectModel("BillInfo","");
	
	if("1020020".equals(sBusinessType)) //��ҵ�жһ�Ʊ���� - ������ҵ�жһ�Ʊ����
	{
		doTemp.setVisible("IsLocalBill",false);
		doTemp.setRequired("IsLocalBill",false);
		doTemp.setDefaultValue("IsLocalBill","2");
		doTemp.setVisible("IsSafeGuard,SafeGuardProtocol,Acceptor",true);
		doTemp.setRequired("IsSafeGuard,Acceptor",true);
		doTemp.setHeader("AcceptorID", "�ж��˿������к�");
		doTemp.setHeader("AcceptorBankID", "�ж��˿�����������");
	}
	
	if(!sBusinessType.equals("1020020")) //���гжһ�Ʊ/Э�鸶ϢƱ������
	{
		//����ʵ����ʵ����Ϣ
		doTemp.appendHTMLStyle("BillSum,Maturity,FinishDate,EndorseTimes,Rate"," onChange=\"javascript:parent.getSum()\" ");
		doTemp.setReadOnly("actualSum,actualint",true);
	}else{
	    doTemp.appendHTMLStyle("BillSum,Maturity,FinishDate"," onChange=\"javascript:parent.getSum()\" ");
	}
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);   
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	dwTemp.genHTMLObjectWindow(sObjectType+","+sObjectNo+","+sSerialNo);

	String sButtons[][] = {
		{"PutOutApply".equals(sObjectType)?"false":"true","","Button","����","���������޸�","saveRecord()","","","",""},
		{"true","","Button","����","�����б�ҳ��","goBack()","","","",""}
	};
%><%@include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents){
	    //���ҵ��Ʒ��
		sBusinessType = "<%=sBusinessType%>";
        //������ҵ��Ʒ��Ϊ�жһ�Ʊ���ֵ�Ʊ����Ϣʱ���������Ʊ�ݺŽ���Ψһ�Լ�顣add by cbsu 2009-11-10
        //1020010�����гжһ�Ʊ���� 1020020����ҵ�жһ�Ʊ���� 1020030��Э�鸶ϢƱ������ 1020040����ҵ�жһ�Ʊ����
        if (bIsInsert) {
			if (sBusinessType == "1020010" || sBusinessType == "1020020" || sBusinessType == "1020030" || sBusinessType == "1020040") {
				if (!validateCheck()) {
				    return;
				} 
			}
        }
		getSum();
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}
	
	function setCity(provValue,cityValue){
		var aCode = [];
		if(cityArray[provValue]){
			aCode = cityArray[provValue];
		}
		else{
			var sReturn = RunJavaMethod("com.amarsoft.awe.dw.ui.control.address.CityFetcher","getCities","prov="+provValue);
			if(sReturn!=""){
				aCode = sReturn.split(",");
			}
		}
		var oCity = document.getElementById("ACCEPTORCITY");
		var options = oCity.options;
		options.length = 1;
		options[0] = new Option("��ѡ�����","");
		options[0].selected = true;
		for(var i=0;i<aCode.length;i+=2){
			var curOption = new Option(aCode[i+1],aCode[i]);
			if(aCode[i]==cityValue)curOption.selected = true;
			options[options.length] = curOption;
		}
	}
	
	setCity(getItemValue(0,0,'AcceptorRegion'),getItemValue(0,0,'AcceptorCity'));
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack(){
		OpenPage("/CreditManage/CreditApply/RelativeBillList.jsp","_self","");
	}
	//����ʵ������ʵ����Ϣ
	function roundOff(number,digit){
		var sNumstr = 1;
    	for (i=0;i<digit;i++){
       		sNumstr=sNumstr*10;
        }
    	sNumstr = Math.round(parseFloat(number)*sNumstr)/sNumstr;
    	return sNumstr;
	}
	function getSum(){
		//Ʊ�ݽ�Ʊ�ݵ����ա�Ʊ����������
		sBillSum = getItemValue(0,getRow(),"BillSum");
		sMaturity = getItemValue(0,getRow(),"Maturity");
		sFinishDate = getItemValue(0,getRow(),"FinishDate");
				
		//����������������
		sEndorseTimes = getItemValue(0,getRow(),"EndorseTimes");
		sRate = getItemValue(0,getRow(),"Rate");
				
		//��ʼ��ʵ����ʵ����Ϣ
		setItemValue(0,0,"actualSum",sBillSum);
		setItemValue(0,0,"actualint",0.00);
		
		if(typeof(sRate)=="undefined" || sRate.length==0) sRate=0; 
		if(typeof(sEndorseTimes)=="undefined" || sEndorseTimes.length==0) sEndorseTimes=0;
		if(typeof(sMaturity)=="undefined" || sMaturity.length==0) return;
		if(typeof(sFinishDate)=="undefined" || sFinishDate.length==0) return;
		
		sTerms = PopPageAjax("/CreditManage/CreditApply/getDayActionAjax.jsp?Maturity="+sMaturity+"&FinishDate="+sFinishDate,"","");
				
		if(typeof(sTerms)=="undefined" || sTerms.length==0) sTerms=0; 
				
		//����ʵ����Ϣ=(������ - ��������+��������)*������/30*Ʊ�ݽ��
		sActualint = sTerms*sRate*sBillSum/30000+sEndorseTimes*sRate*sBillSum/30000;
				
		//����ʵ�����=Ʊ�ݽ�� - ʵ����Ϣ
		sActualSum =  sBillSum - sActualint;
		//����ʵ����ʵ����Ϣ
		if(roundOff(sActualSum,2)<0){
			setItemValue(0,0,"actualSum","0");
			setItemValue(0,0,"actualint",roundOff(sActualint,2));
		}else{
			setItemValue(0,0,"actualSum",roundOff(sActualSum,2));
			setItemValue(0,0,"actualint",roundOff(sActualint,2));
		}
	}

	/*~[Describe=�����������Ʊ�ݺ��Ƿ��Ѿ�����;InputParam=��;OutPutParam=��;]~*/
	//add by cbsu 2009-11-10
    function validateCheck() {
        var sBillNo = getItemValue(0,getRow(),"BillNo");
        var sContractSerialNo = "<%=sObjectNo%>";
        var sObjectType = getItemValue(0,getRow(),"ObjectType");
        if (typeof(sBillNo) != "undefined" && sBillNo.length != 0) {
            var sParaString = sObjectType + "," + sContractSerialNo + "," + sBillNo;
            sReturn = RunMethod("BusinessManage","CheckApplyDupilicateBill",sParaString);
            //��������Ʊ�ݺ��Ѿ����ڣ��������������������
            if (sReturn != 0) {
                 alert("Ʊ�ݺ�:" + sBillNo + "�Ѵ��ڣ������¼�������Ʊ�ݺ��Ƿ���ȷ��");
                 return false;
            } else {
                return true;
            }
        }else{
        	alert("������Ʊ�ݱ�ţ�")
        	return false;
        }
    }
	
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert(){
		initSerialNo();
		bIsInsert = false;
	}
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow(){
		if (getRowCount(0)==0){
			//as_add("myiframe0");//������¼
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgName","<%=CurUser.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"FinishDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo(){
		var sTableName = "BILL_INFO";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺
		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>