 <%@page import="com.amarsoft.app.als.guaranty.model.GuarantyFunctions"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String PG_TITLE = "ѺƷ������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	String objectNo = CurPage.getParameter("AssetSerialNo");
	if(objectNo == null) objectNo = "";
	
	ASObjectModel doTemp = new ASObjectModel("AssetInsuranceList");
	String docFlag = CurPage.getParameter("DocFlag");if(docFlag == null)docFlag = "";
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.ReadOnly = "1";	 //�༭ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("ObjectNo", objectNo);
	dwTemp.genHTMLObjectWindow(objectNo);
	
	String sButtons[][] = {
			{"true","All","Button","����","����","newInsurance()","","","",""},
			{"true","","Button","����","����","viewInsurance()","","","",""},
			{"true","All","Button","ɾ��","ɾ��","deleteInsurance()","","","",""}
	};
	//�����һ�����ϳ��������в鿴ѺƷ���鲻��������ɾ��ѺƷ������Ϣ
	String sDocRightType = "";
	if("DocType".equals(docFlag)){
		sButtons[0][0] = "false";
		sButtons[2][0] = "false";
		sDocRightType = "&RightType=ReadOnly";//modify by lzq 2010330
	}
%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function newInsurance(){
		var clrSerialNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.dwhandler.QueryAssetSerialNo", "queryAssetSerialNo", "AssetSerialNo="+"<%=objectNo%>");
		if(clrSerialNo == "No"){
			alert("���ȱ���ѺƷ��Ϣ��");
			return;
		}
		AsControl.PopComp("/BusinessManage/GuarantyManage/InsuranceGuarantyInfo.jsp", "SerialNo=&ObjectType=jbo.app.ASSET_INFO&ObjectNo=<%=objectNo%>"+"<%=sDocRightType%>", "resizable:no;dialogWidth:850px;dialogHeight:450px;center:yes;status:no;statusbar:no");
		reloadSelf();
	}
	
	function viewInsurance(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		AsControl.PopComp("/BusinessManage/GuarantyManage/InsuranceGuarantyInfo.jsp", "SerialNo="+serialNo+"<%=sDocRightType%>", "resizable:no;dialogWidth:850px;dialogHeight:400px;center:yes;status:no;statusbar:no");
	}

	function deleteInsurance(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		if(confirm("ȷ��ɾ������Ϣ��")){
			var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.contract.action.DeleteInsuranceInfo", "deleteInsurance",  "SerialNo="+serialNo);
			//as_delete("0");
			if(sReturn == "true"){
				alert("ɾ���ɹ���");
				self.reloadSelf();
			}else{
				alert(sReturn);
			}
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
 