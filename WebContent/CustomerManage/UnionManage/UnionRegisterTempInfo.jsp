<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%	
	String customerType = CurPage.getParameter("CustomerType");
	String sTempletNo = "UnionCustomerAddInfo";//ģ���
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	doTemp.setReadOnly("UnionType", true);
	doTemp.setDefaultValue("UnionType", customerType);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow("");
	dwTemp.replaceColumn("CustomerList", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"420\" frameborder=\"0\" src=\""+sWebRootPath+"/CustomerManage/UnionManage/UnionMemberImpList.jsp?CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","saveRecord()","","","",""},
		{"true","All","Button","����","�����б�","top.close()","","","",""}
	};
	//sButtonPosition = "south";
	
%>
<%@include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function saveRecord(){
		if(!iV_all("0")) return; 
		var unionID = getItemValue(0,getRow(),"CUSTOMERID");
		var unionName = getItemValue(0,getRow(),"CustomerName");
		//���ͻ�Ⱥ�����Ƿ��Ѿ�����
		var vReturn = RunJavaMethod("com.amarsoft.app.als.customer.union.action.UnionCustomerAction","checkUnionName","unionID="+unionID+",unionName="+unionName);
		if(vReturn == "true"){
			alert("�ͻ�Ⱥ�����Ѵ���,������¼�룡");
			return;
		}
		
		var vMember = window.frames["frame_list"].vParaCust;//��Ա���
		if(typeof(vMember)!="undefined" && vMember.length > 0){
			//�����Ա
			var vResult = RunJavaMethodTrans("com.amarsoft.app.als.customer.union.action.UnionCustomerAction","saveUnionMember","unionID="+unionID+",customerID="+vMember+",userID=<%=CurUser.getUserID()%>,orgID=<%=CurUser.getOrgID()%>");
			if(vResult == "false"){
				alert("����ʧ��!");
				return;
			}
		}
		as_save(0,'returnValue();');
		
	}	
	function returnValue(){
		var unionID = getItemValue(0,getRow(),"CUSTOMERID");
		parent.returnValue = unionID;	
		top.close();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
