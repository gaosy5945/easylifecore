 <%@page import="com.amarsoft.app.als.guaranty.model.GuarantyFunctions"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String PG_TITLE = "ѺƷ����Ȩ����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	String assetSerialNo = CurPage.getParameter("AssetSerialNo");
	if(assetSerialNo == null) assetSerialNo = "";
	String mode = CurPage.getParameter("Mode");
	if(mode == null) mode = "";
	String grSerialNo = CurPage.getParameter("GRSerialNo");
	if(grSerialNo == null) grSerialNo = "";
	
	ASObjectModel doTemp = new ASObjectModel("AssetOwnerList");
	String docFlag = CurPage.getParameter("DocFlag");if(docFlag == null)docFlag = "";
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.ReadOnly = "1";	 //�༭ģʽ
	dwTemp.setPageSize(10);
	
	//�����һ�����ϳ��������в鿴ѺƷ���鲻������,����ɾ�� ����Ȩ��
	String sDocRightType = "";
	if("DocType".equals(docFlag)){
		 dwTemp.ReadOnly="true";
		 sDocRightType = "&RightType=ReadOnly";
	}
	
	dwTemp.setParameter("AssetSerialNo", assetSerialNo);
	dwTemp.genHTMLObjectWindow(assetSerialNo);
	
	String sButtons[][] = {
			{"true","All","Button","����","��������Ȩ��","addOwner()","","","",""},
			{"true","","Button","����","����","viewOwn()","","","",""},
			{"true","All","Button","ɾ��","ɾ������Ȩ��","deleteOwner()","","","",""},
			{"true","","Button","����Ȩ����Ϣ","����Ȩ������","view()","","","",""}
	};
	
	//�����һ�����ϳ��������в鿴ѺƷ���鲻������,����ɾ�� ����Ȩ��
	if("DocType".equals(docFlag)){
			 sButtons[0][0] = "false";
			 sButtons[1][0] = "false";
			 sButtons[2][0] = "false";
	} 
%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function addOwner(){
		var clrSerialNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.dwhandler.QueryAssetSerialNo", "queryAssetSerialNo", "AssetSerialNo="+"<%=assetSerialNo%>");
		if(clrSerialNo == "No"){
			alert("���ȱ���ѺƷ��Ϣ��");
			return;
		}
		PopPage("/BusinessManage/GuarantyManage/AddAssetOwner.jsp", "AssetSerialNo=<%=assetSerialNo%>&GRSerialNo=<%=grSerialNo%>"+"<%=sDocRightType%>", "dialogHeight=300px;dialogWidth=400px;");
		reloadSelf();
	}
	
	function view(){
		var serialNo = getItemValue(0,getRow(),"SerialNo"); 
		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		var customerID=getItemValue(0,getRow(),"CustomerID");
		if(customerID == null || customerID.length == 0 || typeof(customerID) == "undefined"){
			alert("��Ȩ�����޶�����ϸ��Ϣ��");
			return;
		}
		var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.action.GetCustInfoFunction", "getFunction", "CustomerID="+customerID);
		returnValue = returnValue.split("@");
		if(returnValue[0] == "false"){
			alert("ȱ���˵����˱�Ҫ��Ϣ��");
			return;
		}
		AsCredit.openFunction(returnValue[1],"CustomerID="+customerID+"&RightType=ReadOnly","");
	}

	function viewOwn(){
		var aoSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(aoSerialNo)=="undefined" || aoSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		PopPage("/BusinessManage/GuarantyManage/AddAssetOwner.jsp?AssetOwnerSerialNo="+aoSerialNo+"&AssetSerialNo=<%=assetSerialNo%>&GRSerialNo=<%=grSerialNo%>"+"<%=sDocRightType%>&RightType=<%=CurPage.getParameter("RightType")%>","","dialogHeight=300px;dialogWidth=400px;");
		self.reloadSelf();
	}
	
	function deleteOwner(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		if(confirm("ȷ��ɾ������Ϣ��")){
			var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.contract.action.DeletePersonInfo", "deletePerson",  "SerialNo="+serialNo);
			if(sReturn=="true"){
				alert("ɾ���ɹ���");
				self.reloadSelf();
			}else{
				alert(sReturn);
			}
			//as_delete('0','');
		}
	}
	
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
 