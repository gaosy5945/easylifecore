<%@page import="com.amarsoft.dict.als.manage.CodeManager"%>
<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%	
	String partnerType = CurPage.getParameter("PartnerType");
	if(partnerType == null) partnerType = "";
	
	String templetNo = "PartnerInfo";//ģ���
	ASObjectModel doTemp = new ASObjectModel(templetNo);
	
	String partnerAttribute = CodeManager.getItem("PartnerType", partnerType).getItemAttribute();
	if(partnerAttribute == null ) partnerAttribute = "2";//Ĭ�ϲ������������˺�����
	if(partnerAttribute.equals("2")){
		doTemp.setDDDWJbo("CertType","jbo.sys.CODE_LIBRARY,itemNo,ItemName,Codeno='CertType'  and SortNo like 'Ent%' and IsInuse='1' ");
		doTemp.setDDDWJbo("CustomerType","jbo.sys.CODE_LIBRARY,itemno,itemname,codeno='CustomerType' and itemno in('0110','0120') and isinuse ='1' ");
	}
	doTemp.setDefaultValue("nationCode","CHN"); 
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(CurPage.getParameter(""));
	String sButtons[][] = {
		{"true","All","Button","ȷ��","ȷ��","saveRecord()","","","",""},
		{"true","All","Button","ȡ��","�����б�","returnList()","","","",""}
	};
	sButtonPosition = "south";
%>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	var flag = "APPLY";
	
	function  saveRecord(){
		if(!iV_all("0")) return ;
		if(!checkCertInfo(true)) return ;
		var sReturn=AsCredit.doAction("2030"); 
		var returnValue=sReturn.split("@");
		var result=returnValue[0];
		var message=returnValue[1];
		CHANGE=false;
		if(result=="SUCCESS"){//�ͻ���Ϣ���ͨ�������Խ�������
			customerID=returnValue[2];
        	AsCredit.openFunction("CustomerDetail","CustomerID="+customerID,"");
			//openObject("Customer",customerID,"001");
		}else if(result=="FAIl"){
			alert(message);
			return ;
		}else if(result=="CONFIRM"){
			if(confirm(message)){
				customerId=returnValue[2];
				AsControl.PopComp("/CustomerManage/TransferManage/TransferInApply.jsp","CustomerID="+customerId,"resizable=yes;dialogWidth=850px;dialogHeight=680px;center:yes;status:no;statusbar:no");
				
               // popComp("RoleApplyInfo","/CustomerManage/RoleApplyInfo.jsp","CustomerID="+customerId+"&UserID=<%=CurUser.getUserID()%>&OrgID=<%=CurUser.getOrgID()%>","");
			}
		}
		if(flag == "APPLY"){
			var customerID=returnValue[2];
			var customerName = getItemValue(0,getRow(),"CustomerName");
			top.returnValue=customerID+"@"+customerName;
			top.close();
		}else{
			top.returnValue="true";
			top.close();
		}
		
	}
	
	function returnList(){
		top.returnValue = "_CALCEL_";
		top.close();
	}
	
	function checkCertInfo(flag){
		if(typeof(flag)=="undefined") flag=false;
		var certType=getItemValue(0,getRow(),"CertType");
		var certId=getItemValue(0,getRow(),"CertID");
		var nationCode=getItemValue(0,getRow(),"nationCode");
		var recertId=getItemValue(0,getRow(),"CERTID1");
		setErrorTips("certType","");
		setErrorTips("certId","");
		if(nationCode==""){
			setErrorTips("nationCode","����ѡ��֤������!"); 
			return false;
		}
		if(certType==""){
			setErrorTips("certType","����ѡ��֤������!"); 
			return false;
		}
		//�ж���֯��������Ϸ���
		if(certType =='Ent01' ){
			 if(!CheckORG(certId) ){
				setErrorTips("certId",getBusinessMessage('102')); 
				return false;
			}
		} 
		if(certType == 'Ind01' || certType =='Ind08'){
		 	if (!CheckLicense(certId)){
				setErrorTips("CertID",getBusinessMessage('156'));  
				return false;
			}
		}
		if(certId!=recertId && certId!=""){
			setErrorTips("certId","֤������ȷ����֤�����벻һ��!"); 
			return false;
		}
		return true;
		
	}	
	
	function selectCustomerType(){
		var customerType = getItemValue(0,0,"CustomerType");
		if(customerType == "03"){
			setItemRequired(0,"OrgNature",false);
			hideItem(0,"OrgNature");
			setArea("Ind");
		}else{
			setItemRequired(0,"OrgNature",true);
			showItem(0,"OrgNature");
			setArea("Ent");
		}
	}
	
	//���� ����certType
	function setArea(type){
		var returnValue = RunJavaMethod("com.amarsoft.app.als.customer.partner.action.GetCertType","getCertType","type="+type);
		if(returnValue!=""){
			aCode = returnValue.split(",");
		}
		var oArea = document.getElementById("CERTTYPE");//CERTTYPE��Ҫ��д������firefox����
		var options = oArea.options;
		options.length = 1;
		options[0] = new Option("---��ѡ��---","");
		options[0].selected = true;
		for(var i=0;i<aCode.length -1;i+=2){
			var curOption = new Option(aCode[i+1],aCode[i]);
			//if(aCode[i]==areaValue)curOption.selected = true; ����Ĭ��ֵ
				options[options.length] = curOption;
		}
	}
	
	function setErrorTips(colName,tips){ 
		if(tips==""){
			setItemUnit(0,getRow(),colName,"");
			return ;
		}
		setItemUnit(0,getRow(),colName,"<font color=red>"+tips+"</font>");
	}
	
	setItemRequired(0,"OrgNature",true);
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
