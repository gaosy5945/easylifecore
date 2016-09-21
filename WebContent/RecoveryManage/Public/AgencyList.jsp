<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("LawCaseAgencyList");
	
	String role [] = {"PLBS0052"};
	if(CurUser.hasRole(role)){
		doTemp.appendJboWhere(" and exists(select 1 from jbo.sys.ORG_BELONG OB where OB.OrgID = '" 
				+ CurUser.getOrgID() + "' and  OB.BelongOrgID = O.InputOrgID) ");
	}else{
		doTemp.appendJboWhere(" and O.InputUserID='"+CurUser.getUserID()+"' ");
	}

	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			{"true","","Button","����","�����������","newRecord()","","","",""},
			{"true","","Button","����","�鿴�������","viewAndEdit()","","","",""},
			
			{"true","","Button","����������","�鿴����������","my_agent()","","","",""},
			{"true","","Button","�Ѵ�����","�鿴�Ѵ�����","my_lawcase()","","","",""},
			{"true","","Button","ɾ��","ɾ���������","deleteRecord()","","","",""}
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		AsControl.PopComp("/RecoveryManage/Public/AgencyInfo.jsp","","");
		reloadSelf();
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{
			as_delete(0);

			//as_del('myiframe0');
			//as_save('myiframe0');  //�������ɾ������Ҫ���ô����
		}
		reloadSelf();
	}
	
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var inputUserID = getItemValue(0,getRow(),"InputUserID");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		var rightType = "<%=CurPage.getParameter("RightType")%>";
		if(inputUserID!="<%=CurUser.getUserID()%>"){
			rightType = "ReadOnly";
		}
		AsControl.PopComp("/RecoveryManage/Public/AgencyInfo.jsp","SerialNo="+sSerialNo+"&RightType="+rightType, "","");
		reloadSelf();
	}
	
	/*~[Describe=������������Ϣ;InputParam=��;OutPutParam=��;]~*/
	function my_agent()
	{
		//��ô��������ˮ��
		sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		AsControl.PopComp("/RecoveryManage/Public/AgentList.jsp","BelongNo="+sSerialNo+"&Flag=Y&rand="+randomNumber(),"","");
		reloadSelf();
	}
	
	/*~[Describe=�Ѵ�������Ϣ;InputParam=��;OutPutParam=��;]~*/
	function my_lawcase()
	{
		//��÷�Ժ��ˮ��
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		AsControl.PopComp("/RecoveryManage/Public/SupplyLawCase.jsp","QuaryName=OrgNo&QuaryValue="+sSerialNo+"&Back=1&rand="+randomNumber(),"","");
		reloadSelf();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
