 <%@page import="com.amarsoft.app.als.guaranty.model.GuarantyFunctions"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String PG_TITLE = "��߶����ͬ�Ǽ�"; // ��������ڱ��� <title> PG_TITLE </title>
	String contractType = CurPage.getParameter("ContractType");
	if(contractType == null) contractType = "";
	String contractStatus = CurPage.getParameter("ContractStatus");
	if(contractStatus == null) contractStatus = "";
	String sRightType = CurPage.getParameter("sRightType");
	if(sRightType == null) sRightType = "";
	String openType = CurPage.getParameter("OpenType");
	if(openType == null) openType = "1";//1�Ǽǣ�2��ѯ
	
	String templateNo = "CeilingGCManage";//�Ǽ�
	if(openType.equals("2")){
		templateNo = "CeilingGCManage1";//��ѯ
	}
	
	ASObjectModel doTemp = new ASObjectModel(templateNo);
	if(!contractStatus.equals("")){
		doTemp.appendJboWhere(" and ContractStatus = '"+contractStatus+"'");
	}
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.ReadOnly = "1";	 //�༭ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("ContractType", contractType);
	
	if(openType.equals("1")){//��߶�Ǽ�
		dwTemp.setParameter("InputUserID", CurUser.getUserID());
		dwTemp.genHTMLObjectWindow(contractType+","+CurUser.getUserID());
	}
	else{//��߶��ѯ
		dwTemp.setParameter("OrgID", CurUser.getOrgID());
		dwTemp.genHTMLObjectWindow(contractType+","+CurUser.getOrgID());
	}
	
	String sButtons[][] = {
			{"true","All","Button","�Ǽ���߶����ͬ","�Ǽ���߶����ͬ","newRecord()","","","",""},  
			{"true","","Button","����","�鿴������Ϣ����","viewAndEdit()","","","",""},
			{"true","All","Button","ȡ��������ͬ","ȡ��������ͬ","deleteRecord()","","","",""},
			{"false","","Button","�����ͻ�����","�鿴������صĵ����ͻ�����","viewCustomerInfo()","","","",""}, 
			{"false","","Button","�������Ĵ�����Ϣ","�������Ĵ�����Ϣ","viewBusiness()","","","",""}, 
			{"false","All","Button","������ͬ���","������ͬ���","gcBalance()","","","",""},
			{"false","All","Button","ʧЧ","ʧЧ��߶��","inValidate()","","","",""},
			{"true","All","Button","���Ӻ�ͬ","��߶�����Ӻ�ͬ","create()","","","",""}
	};
	if(contractStatus.equals("02") || contractStatus.equals("03")){
		sButtons[0][0] = "false";
		sButtons[2][0] = "false";
		//sButtons[5][0] = "true";
		sButtons[7][0] = "false";
	}
	if("03".equals(contractStatus)){
		sButtons[5][0] = "false";
	}
	if(sRightType.equals("ReadOnly") && "02".equals(contractStatus)){
		sButtons[6][0] = "true";
	}
%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	
	function newRecord(){
		AsControl.PopComp("/BusinessManage/GuarantyManage/CeilingGCInfo.jsp", "ContractType=020", "");
		reloadSelf();
	}
	function create(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");		
		if(typeof(serialNo)=="undefined" || serialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		AsControl.PopView("/CreditManage/CreditContract/EdocContractList.jsp", "ObjectNo="+serialNo+"&ObjectType=jbo.guaranty.GUARANTY_CONTRACT");
	}
	function viewAndEdit(){
		var serialNo=getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		var guarantorID=getItemValue(0,getRow(),"GuarantorID");
		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			guarantorID = "";
		}
		var guarantyType = getItemValue(0,getRow(),"GuarantyType");
		AsCredit.openFunction("CeilingGCTab", "SerialNo="+serialNo+"&GuarantyType="+guarantyType+"&GuarantorID="+guarantorID+"&RightType=<%=sRightType%>");
		reloadSelf();
	}

	function mySelectRow(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");//--��ˮ����
		if(typeof(serialNo)=="undefined" || serialNo.length==0)  return ;
		var guarantyType = getItemValue(0,getRow(),"GuarantyType");		
		if (guarantyType == "01020") {//��Լ��֤����
			AsControl.OpenPage("/BusinessManage/GuarantyManage/InsuranceGuaranty.jsp","ObjectType=jbo.guaranty.GUARANTY_CONTRACT&ObjectNo="+serialNo,"rightdown","");
			return ;
		}
		else if(guarantyType == "01030"){//��������
			AsControl.OpenPage("/Blank.jsp", "", "rightdown", "");
			return;
		}
		else if(guarantyType.substring(0,3) == "020" || guarantyType.substring(0,3) == "040"){//����Ѻ����
			AsControl.OpenPage("/CreditManage/CreditApply/CollateralList.jsp","GCSerialNo="+serialNo+"&VouchType="+guarantyType+"&Mode=<%=sRightType%>","rightdown","");
		}
		else{
			AsControl.OpenPage("/CreditManage/CreditApply/GuarantyCLRInfo.jsp", "ObjectType=jbo.guaranty.GUARANTY_CONTRACT&ObjectNo="+serialNo+"&RightType=<%=sRightType%>", "rightdown", "");
		}
	}

	function viewCustomerInfo(){
		var sCustomerID = getItemValue(0,getRow(),"GuarantorID");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length == 0){
			alert(getBusinessMessage('413'));//ϵͳ�в����ڵ����˵Ŀͻ�������Ϣ�����ܲ鿴��
			return ;		
		}
		var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.action.GetCustInfoFunction", "getFunction", "CustomerID="+sCustomerID);
		returnValue = returnValue.split("@");
		if(returnValue[0] == "false"){
			alert("ȱ���˵����˱�Ҫ��Ϣ��");
			return;
		}
			
		AsCredit.openFunction(returnValue[1],"CustomerID="+sCustomerID,"");
	}
	
	function viewBusiness(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0)  return ;
		AsControl.PopComp("/BusinessManage/GuarantyManage/CeilingGCRelaBusiness.jsp", "SerialNo="+serialNo, "dialogWidth:680px;dialogHeight:540px;resizable:yes;scrollbars:no;status:no;help:no");
	}
	
	function gcBalance(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0)  {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		var balance = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.action.CeilingGCAction", "getBalance", "SerialNo="+serialNo);
		alert("������ͬ��� "+balance+" Ԫ");
	}
	
	function deleteRecord(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0)  {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		if(!confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{
			return ;
		}
		var contractStatus = getItemValue(0,getRow(),"ContractStatus");
		if(contractStatus == "02"){
			alert("����߶������Ч��");
			return;
		}
		var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.GuarantyContractAction", "isCeilingGCInUse", "GCSerialNo="+serialNo);
		if(returnValue == "true"){
			alert("����߶����ͬ���ڱ�ʹ�ã�");
			return;
		}
		as_delete('0');
	}
	
	function inValidate(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0)  {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		if(!confirm("ȷ��ҪʧЧ�ñ���߶����ͬ��")){
			return ;
		}
		var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.GuarantyContractAction", "isCeilingGCInUse", "GCSerialNo="+serialNo);
		if(returnValue == "true"){
			alert("����߶����ͬ������δ����ҵ�񣬲���ʧЧ��");
			return;
		}
		if(returnValue == "false"){//ʧЧ����
			var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.putout.action.CeilingGCAction", "inValidateContract", "SerialNo="+serialNo);
			if(sReturn == "true"){
				alert("ʧЧ��ɣ�");
				self.reloadSelf();
			}
			else{
				alert("ʧЧʧ�ܣ�");
			}
		}
	}
	
	mySelectRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
 