<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";

	String sTempletNo = "NewApplyInfo";//ģ���
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	doTemp.setVisible("CustomerType",true);
	doTemp.setUnit("CustomerID","<input class='inputdate' value='���������ͻ�' type='button' onClick=newCustomer()>");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(CurPage.getParameter(""));
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","saveRecord(0)","","","",""},
		{"true","All","Button","����","�����б�","top.close()","","","",""}
	};
	sButtonPosition = "south";
	String today=StringFunction.getToday();
	String curOrgName=CurUser.getOrgName();
	String curUserName=CurUser.getUserName();

	
%>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	var mapValue = {};
	function test(){
	 	
	}

	function saveRecord(){
		if(!iV_all("0")) return ;
/* 		var barCode = getItemValue(0,getRow(),"BarCode");
	    var isExist = RunJavaMethodTrans("com.amarsoft.app.als.image.BarCodeSevice", "isExistBarCode", "BarCode=" + barCode);
	    if (isExist == "true"){
	    	alert("�������Ѵ��ڣ�");
	    	return;
	    } */

		sReturn=AsCredit.doAction("0010");
		var sParamString = "ObjectType=CreditApply&ObjectNo="+sReturn;
		AsControl.OpenObjectTab(sParamString);
		top.close();
	}
	/*~[Describe=�����Ϣ;InputParam=��;OutPutParam=��;]~*/
	function clearData(){
		setItemValue(0,0,"CustomerID","");
		setItemValue(0,0,"CustomerName","");
		setItemValue(0,0,"BusinessType","");
		setItemValue(0,0,"BusinessTypeName","");
		setItemValue(0,0,"RelativeAgreement","");
		setItemValue(0,0,"RelativeObjectType","");
		setItemValue(0,0,"OperateType","");
		setItemValue(0,0,"isHostBank","");
	}

	/*~[Describe=��ȡ�ͻ���ź�����;InputParam=�������ͣ�������λ��;OutPutParam=��;]~*/
	function subSelectCustomer(selectName,sParaString){
		try{
			o = setObjectValue(selectName,sParaString,"",0,0,"");
			oArray = o.split("@");
			if(oArray[0]=="_CLEAR_"){
				setItemValue(0,0,"CustomerID","");
				setItemValue(0,0,"CustomerName","");
				return;
			}
			setItemValue(0,0,"CustomerID",oArray[0]);
			setItemValue(0,0,"CustomerName",oArray[1]);
			//�ı�ͻ�����ʱ���ҵ��Ʒ�֡�������ݺ͹������鷽��
			setItemValue(0,0,"BusinessType","");
			setItemValue(0,0,"BusinessTypeName","");
			setItemValue(0,0,"RelativeObjectType","");
		}catch(e){
			return;
		}
	}	



	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCustomer(){
		var sCustomerType= getItemValue(0,getRow(),"CustomerType");
		if(typeof(sCustomerType) == "undefined" || sCustomerType == ""){
			alert(getBusinessMessage('225'));//����ѡ��ͻ����ͣ�
			return;
		}
		//����ҵ�����Ȩ�Ŀͻ���Ϣ
		var sParaString = "UserID"+","+"<%=CurUser.getUserID()%>"+","+"CustomerType"+","+sCustomerType;
		if(sCustomerType.substring(0,2) == "01")//��˾�ͻ�����С��ҵ
			subSelectCustomer("SelectApplyCustomerM",sParaString);
		if(sCustomerType.substring(0,2) == "02")//��������
			subSelectCustomer("SelectApplyCustomer2",sParaString);
		if(sCustomerType.substring(0,2) == "03")//���˿ͻ�
			subSelectCustomer("SelectApplyCustomer1",sParaString);
	}
	/*~[Describe=����������ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectUGCustomer(){
		var sParaString = "UserID"+","+"<%=CurUser.getUserID()%>";
		subSelectCustomer("SelectUGCustomer",sParaString);
	}
 
	/*~[Describe=����ҵ��Ʒ��ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectBusinessType(sType){
		var sCustomerType = getItemValue(0,getRow(),"CustomerType");
		if(typeof(sCustomerType) == "undefined" || sCustomerType == ""){
			alert(getBusinessMessage('225'));//����ѡ��ͻ����ͣ�
			return;
		}
		
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if(typeof(sCustomerID) == "undefined" || sCustomerID == ""){
			alert(getBusinessMessage('226'));//����ѡ�����ſͻ���
			return;
		}
		if(sType == "ALL"){
			//���Ϊ���˿ͻ�
			if(sCustomerType.substring(0,2) == "03"){
				subSelectBusinessType("SelectIndivBusinessType");
			}	
			//���Ϊ��˾�ͻ�		
			else if(sCustomerType.substring(0,2) == "01"){
				subSelectBusinessType("SelectEntBusinessType");
			}
		}else if(sType == "CL"){ //���Ŷ�ȵ�ҵ��Ʒ��
			//��01������˾�ͻ�����02�������ſͻ������ѡ����ǹ�˾�ͻ����򵯳����Ŷ��ҵ��Ʒ�֣����ѡ����Ǽ��ſͻ�����Ĭ��Ϊ�������Ŷ��
			if(sCustomerType.substring(0,2) =="01")
				setObjectValue("SelectCLBusinessType","","@BusinessType@0@BusinessTypeName@1",0,0,"");	
			if(sCustomerType.substring(0,2) =="02"){
				//������������ʾ��䣬��ֹ�������飡
				alert("���ſͻ�ֻ�����뼯�����Ŷ�ȣ�");
				return;
			}		
		}
	}

	/*~[Describe=��ȡҵ��Ʒ��;InputParam=�������ͣ�������λ��;OutPutParam=��;]~*/
	function subSelectBusinessType(selectName){
		try{
			o = setObjectValue(selectName,"","",0,0,"");
			oArray = o.split("@");
			if(oArray[0]=="_CLEAR_"){
				setItemValue(0,0,"BusinessType","");
				setItemValue(0,0,"BusinessTypeName","");
				return;
			}
			setItemValue(0,0,"BusinessType",oArray[0]);
			setItemValue(0,0,"BusinessTypeName",oArray[1]);
		}catch(e){
			return;
		}
	}
	/*~[Describe=�����ʲ�����ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectNPARefrom(){
		try{				
			o = setObjectValue("SelectNPARefrom","","",0,0,"");	
			oArray = o.split("@");
			if(oArray[0]=="_CLEAR_"){
				setItemValue(0,0,"RelativeAgreement","");
				return;
			}
			setItemValue(0,0,"RelativeAgreement",oArray[0]);
		}catch(e){
			return;
		}
	}
	/*~[Describe=������չ�ڵĺ�ͬ/���ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectExtendContract(){
		var sCustomerID =  getItemValue(0,getRow(),"CustomerID");
		if(typeof(sCustomerID) == "undefined" || sCustomerID == ""){
			alert(getBusinessMessage('226'));//����ѡ��ͻ���
			return;
		}
		//���պ�ͬչ��
		//sParaString = "CustomerID"+","+sCustomerID+","+"ManageUserID"+","+"<%=CurUser.getUserID()%>";
		//���ս��չ��
		sParaString = "CustomerID"+","+sCustomerID+","+"OperateUserID"+","+"<%=CurUser.getUserID()%>";
		subSelectExtContract("SelectExtendDueBill",sParaString);
	}
	/*~[Describe=��ȡչ�ڽ��;InputParam=�������ͣ�������λ��;OutPutParam=��;]~*/
	function subSelectExtContract(selectName,sParaString){
		try{
			o = setObjectValue(selectName,sParaString,"",0,0,"");
			oArray = o.split("@");
			if(oArray[0]=="_CLEAR_"){
				setItemValue(0,0,"RelativeObjectType","");
				return;
			}
			setItemValue(0,0,"RelativeObjectType",oArray[0]);
			setItemValue(0,0,"BusinessTypeName",oArray[1]);
		}catch(e){
			return;
		}
	}
	function initRow(){
		setItemValue(0,0,"OccurType","010");
		setItemValue(0,0,"OccurDate","<%=today%>");
		setItemValue(0,0,"InputOrgName","<%=curOrgName%>");
		setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
		setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"InputUserName","<%=curUserName%>");
		setItemValue(0,0,"OperateUserID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"OperateOrgID","<%=CurUser.getOrgID()%>");
		setItemValue(0,0,"InputDate","<%=today%>");
		setItemValue(0,0,"OperateDate","<%=today%>");
		setItemValue(0,0,"CustomerType","01");
		setItemValue(0,0,"OperateType","01");
		setItemValue(0,0,"isHostBank","2");
		setItemValue(0,0,"Flag5","010");
		hideItem(0,'IsHostBank');
		hideItem(0,'RelativeAgreement');
		hideItem(0,'RelativeObjectType');
		setItemRequired(0,"RelativeAgreement",false);
		setItemRequired(0,"RelativeObjectType",false);
		occurTypeChange();
	}
	function occurTypeChange(){
		var currentType=getItemValue(0,getRow(),"OccurType");
		if(currentType=="010"){
			setItemRequired(0,"BusinessTypeName",true);
			showItem(0,'BusinessTypeName');
			hideItem(0,'RelativeAgreement');
			hideItem(0,'RelativeObjectType');
			setItemRequired(0,"RelativeAgreement",false);
			setItemRequired(0,"RelativeObjectType",false);
			showItem(0,'OperateType');
			showItem(0,'isHostBank');
		}else if(currentType=="015"){
			setItemRequired(0,"BusinessTypeName",false);
			setItemRequired(0,"RelativeAgreement",false);
			setItemRequired(0,"RelativeObjectType",true);
			hideItem(0,'BusinessTypeName');
			hideItem(0,'RelativeAgreement');
			showItem(0,'RelativeObjectType');
			hideItem(0,'OperateType');
			hideItem(0,'isHostBank');
		}else if(currentType=="020"){
			showItem(0,'BusinessTypeName');
			setItemRequired(0,"BusinessTypeName",true);
			setItemRequired(0,"RelativeAgreement",false);
			setItemRequired(0,"RelativeObjectType",true);
			hideItem(0,'RelativeAgreement');
			showItem(0,'RelativeObjectType');
			showItem(0,'OperateType');
			showItem(0,'isHostBank');
		}else if(currentType=="030"){
			showItem(0,'BusinessTypeName');
			showItem(0,'RelativeAgreement');
			setItemRequired(0,"BusinessTypeName",true);
			setItemRequired(0,"RelativeObjectType",false);
			setItemRequired(0,"RelativeAgreement",true);
			hideItem(0,'RelativeObjectType');
			showItem(0,'OperateType');
			showItem(0,'isHostBank');
		}
	}
	function customTypeChange(){
		clearData();
		var sCurrentCustomType=getItemValue(0,getRow(),"CustomerType");
		if(sCurrentCustomType.substring(0,2)=="03"){
			setItemValue(0,0,"OperateType","");
			setItemValue(0,0,"isHostBank","");
			hideItem(0,'OperateType');
			hideItem(0,'isHostBank');
		}else{
			showItem(0,'OperateType');
			showItem(0,'isHostBank');
		}
	}
	function operateTypeChange(){
		var sCurrentOperateType=getItemValue(0,getRow(),"OperateType");
		if(sCurrentOperateType=="02" || sCurrentOperateType=="03"){//������֯��ʽΪ�����Ŵ���
			showItem(0,'isHostBank');//���Ŵ��������Ƿ�������
		}else{
			setItemValue(0,0,"isHostBank","2");
			hideItem(0,'isHostBank');
		}
	}
	
	function printBarCode(){
		var barCode = getItemValue(0,getRow(),"BarCode");
		if(typeof(barCode) == "undefined" || barCode == ""){
			alert("������������ֵ��");
			return;
		}
		
		AsCredit.printBarCode(barCode);
	    	
	}
	
	function newCustomer(){
	    var customerType=getItemValue(0,getRow(),"CustomerType"); //--�ͻ�����
	    if(!customerType){
		   alert(getBusinessMessage('225'));//����ѡ��ͻ����ͣ�
		   return;
	    }
        var returnValue = AsControl.PopComp("/CustomerManage/NewCustomerDialog.jsp","CustomerType="+customerType+"&SourceType=APPLY","resizable=yes;dialogWidth=500px;dialogHeight=400px;center:yes;status:no;statusbar:no");
        if(!returnValue) return;
        if(returnValue.indexOf("@")>0){
        	setItemValue(0,getRow(),"CustomerID",returnValue.split("@")[0]);
        	setItemValue(0,getRow(),"CustomerName",returnValue.split("@")[1]);
        }   
	}
	initRow();

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
