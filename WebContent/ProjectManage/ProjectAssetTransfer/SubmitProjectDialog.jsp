<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
 <%@ page import="com.amarsoft.app.als.assetTransfer.util.AssetProjectCodeConstant"%>

<% 
	String serialNo = CurComp.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";
	String status = CurComp.getParameter("Status");
	if(status == null) status = "";

	String sTempletNo = "SubmitProjectDialog";//ģ���
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//doTemp.setVisible("*", false);
	//doTemp.setVisible("APPROVEUSERID,APPROVEORGID", true);
	//doTemp.setJboWhere("O.SerialNo = :serialNo");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.genHTMLObjectWindow(status+","+serialNo);
	String sButtons[][] = {
		{"true","All","Button","ȷ��","ȷ��","saveRecord(0)","","","",""}, 
		{"true","All","Button","ȡ��","ȡ��","goBack(0)","","","",""}, 
	};
	sButtonPosition = "south";
%>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>

<%@page import="com.amarsoft.app.als.customer.model.CustomerConst"%><script type="text/javascript">
	function goBack(){ 
		self.close();
	}

	function saveRecord(){ 
		
		submit();
		self.close();
	}
	
  	function submit(){
		var sProjectNo = getItemValue(0,getRow(),"SERIALNO");
		var sProjectType = getItemValue(0,getRow(),"PROJECTTYPE");
		var status = '<%=AssetProjectCodeConstant.AssetProjectStatus_020%>';
		var approveOrgId = getItemValue(0,getRow(),"APPROVEORGID");
		var approveUserId = getItemValue(0,getRow(),"APPROVEUSERID");
		if(typeof(approveOrgId) == 'undefined' || approveOrgId.length == 0){
			alert("�������ύ��λ��");
			return;
		}
		else if(typeof(approveUserId) == 'undefined' || approveUserId.length == 0){
			alert("�������ύ�ˣ�");
			return;
		}
		else if(confirm('ȷ��Ҫ���д˲�����?')){
			RunJavaMethodTrans("com.amarsoft.app.als.assetTransfer.action.AssetTransferAction","changeProjectStatus","projectNo="+sProjectNo+",status="+status+",assetProjectType="+sProjectType);
			reloadSelf();
		}
	}  
	
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
 