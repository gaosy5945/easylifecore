<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("PDADailyList");

	String role = "PLBS0052";
	if(CurUser.hasRole(role)){
		doTemp.appendJboWhere(" and exists (select 1 from jbo.sys.ORG_BELONG OB where OB.OrgID = '" 
				+ CurUser.getOrgID() + "' and  OB.BelongOrgID = O.ManageOrgID) ");
	}else{
		doTemp.appendJboWhere(" AND O.ManageUserID ='"+CurUser.getUserID()+"' ");
	}
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");

	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(15);
	dwTemp.genHTMLObjectWindow("");

	//ɾ����ծ�ʲ���ɾ��������Ϣ
    //dwTemp.setEvent("AfterDelete","!WorkFlowEngine.DeleteTask(AssetInfo,#SerialNo,DeleteBusiness)");
	
	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","","Button","����","����һ����¼","newRecord()","","","",""},
			{"true","","Button","�ʲ�����","�鿴/�޸��ʲ�����","viewAndEdit()","","","",""},
			{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()","","","",""},
			{"true","","Button","�����ս�","�ս���ѡ�еļ�¼","finishRecord()","","","",""},
			{"true","","Button","��������","������excel","exportExcel()","","","",""},
			//{"true","","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0,'alert(getRowCount(0))')","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function exportExcel(){
		if(confirm("�Ƿ񵼳���ǰ���ε�ծ�ʲ�������Ϣ��")){
			exportPage('<%=sWebRootPath%>',0,'excel','<%=dwTemp.getArgsValue()%>'); 
		}
	}
	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=SerialNo;]~*/
	function newRecord()
	{
		var sAssetInfo =PopPage("/RecoveryManage/PDAManage/PDADailyManage/PDATypeDialog.jsp","","resizable=yes;dialogWidth=28;dialogHeight=10;center:yes;status:no;statusbar:no");
		sAssetInfo = sAssetInfo.split("@");
		var sAISerialNo=sAssetInfo[1];
		var sDASerialNo=sAssetInfo[2];
		if(typeof(sAISerialNo) != "undefined" && sAISerialNo.length != 0)
		{			
			//popComp("PDABasicView","/RecoveryManage/PDAManage/PDADailyManage/PDABasicView.jsp","SerialNo="+sSerialNo+"AssetSerialNo="+sAssetSerialNo,"");
			var sFunctionID="PDAInfoList";
			AsCredit.openFunction(sFunctionID,"SerialNo="+sDASerialNo+"&AssetSerialNo="+sAISerialNo+"&AssetType="+sAssetInfo[0]);	
			reloadSelf();
		} 		
	}
			
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		 var sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		 var sAssetSerialNo = getItemValue(0,getRow(),"AssetSerialNo");	
		 var sDebtAssetStatus = getItemValue(0,getRow(),"Status");
		 if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		} else {
			 if(sDebtAssetStatus!="01"){
				 alert("��ѡ����״̬Ϊ�����õ���Ϣ����ɾ��������");
				 return;
			 }
			if(confirm("ȷ��Ҫɾ����")){
				//����ող��������кż�¼������ȱʡֵ��
				PopPageAjax("/RecoveryManage/PDAManage/PDADailyManage/PDADeleteActionAjax.jsp?SerialNo="+sSerialNo+"&AssetSerialNo="+sAssetSerialNo,"","");
			}
		}
		reloadSelf();
	}
	
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//��õ�ծ�ʲ���ˮ��
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		var sAssetSerialNo = getItemValue(0,getRow(),"AssetSerialNo");	
		var sAssetType = getItemValue(0,getRow(),"AssetType");
		var manageUserID = getItemValue(0,getRow(),"ManageUserID");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		//popComp("PDABasicView","/RecoveryManage/PDAManage/PDADailyManage/PDABasicView.jsp","SerialNo="+sSerialNo+"&AssetSerialNo="+sAssetSerialNo,"");
		var sFunctionID="PDAInfoList";
		var sDAStatus = getItemValue(0,getRow(),"Status");
		var rightType = "<%=CurPage.getParameter("RightType")%>";
		if(manageUserID!="<%=CurUser.getUserID()%>"||sDAStatus == "03"){
			rightType = "ReadOnly";
		}
		AsCredit.openFunction(sFunctionID,"SerialNo="+sSerialNo+"&AssetSerialNo="+sAssetSerialNo+"&AssetType="+sAssetType + "&AssetStatus=" + sDAStatus + "&RightType=" + rightType);	
		reloadSelf();	
	}	
		
	/*~[Describe=�ս��ʲ��������ս�״̬���ս�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function finishRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		var sAssetSerialNo = getItemValue(0,getRow(),"AssetSerialNo");	
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		var RightType = "All";
		var sDAStatus = getItemValue(0,getRow(),"Status");
		if(sDAStatus == "03") RightType = "ReadOnly";
		AsControl.PopComp("/RecoveryManage/PDAManage/PDADailyManage/PDADisposalEndInfo.jsp", "SerialNo="+sSerialNo+"&AssetSerialNo="+sAssetSerialNo+"&Type=1&RightType=" + RightType, "dialogWidth:720px;dialogheight:580px", "");
		reloadSelf();
	
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
