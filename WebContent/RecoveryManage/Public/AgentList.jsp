<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	//�������
	boolean bIsBelong = false; //�Ƿ��ǵ���������������
		
	//���ҳ�����
	String sBelongNo = CurPage.getParameter("BelongNo");
	String sFlag = CurPage.getParameter("Flag");
	if(sBelongNo == null) sBelongNo = "";
	if(sFlag == null) sFlag = ""; //Flag=Y��ʾ�Ӵ�������б�����
	

	String sTempletNo = "",doWhereSql="";
	if(sBelongNo.equals(""))
	{
		sTempletNo = "AgentList";//ģ�ͱ��
		String role [] = {"PLBS0052"};
		if(CurUser.hasRole(role)){
			doWhereSql = " and exists (select 1 from jbo.sys.ORG_BELONG OB where OB.OrgID = '" 
					+ CurUser.getOrgID() + "' and  OB.BelongOrgID = O.InputOrgID) ";
		}else{
			doWhereSql = " and O.InputUserID='"+CurUser.getUserID()+"' ";
		}
	}else
	{
	 	bIsBelong = true;
	 	sTempletNo = "AgentList1";//ģ�ͱ��
	 }      


	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	doTemp.appendJboWhere(doWhereSql);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(15);
	if(bIsBelong)
	{
		dwTemp.setParameter("BelongNo",sBelongNo);
		dwTemp.setParameter("Flag",sFlag);
	}
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			{"true","","Button","����","����������","newRecord()","","","",""},
			{"true","","Button","����","�鿴������","viewAndEdit()","","","",""},
			
			{"true","","Button","�Ѵ�����","�鿴�Ѵ�����","my_lawcase()","","","",""},
			{"true","","Button","����","�����б�ҳ��","goBack()","","","",""},
			{"true","","Button","ɾ��","ɾ��������","deleteRecord()","","","",""}
		};
	
	
	if(sFlag.equals("Y")) //�ӻ�����Ϣ�б����
	{
		sButtons[0][0]="false";		
		sButtons[4][0]="false";
	}else
	{
		sButtons[3][0]="false";
	}
	
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		AsControl.PopComp("/RecoveryManage/Public/AgentInfo.jsp","","");
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
		AsControl.PopComp("/RecoveryManage/Public/AgentInfo.jsp","SerialNo="+sSerialNo+"&RightType="+rightType, "","");
		reloadSelf();
	}
	
	/*~[Describe=���ص���������б�;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{     	
		self.close();
		/* OpenPage("/RecoveryManage/Public/AgencyList.jsp?rand="+randomNumber(),"_self",""); */
	}
	
	/*~[Describe=�Ѵ�������Ϣ;InputParam=��;OutPutParam=��;]~*/
	function my_lawcase()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		AsControl.PopComp("/RecoveryManage/Public/SupplyLawCase.jsp","QuaryName=PersonNo&QuaryValue="+sSerialNo+"&Back=2&rand="+randomNumber(),"","");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
