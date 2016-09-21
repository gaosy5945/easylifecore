<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	//�������
	String sSql = "";
	//����������
	boolean bIsBelong = false; //�Ƿ��ǵ���������������
	//���ҳ�����
	String sBelongNo = CurPage.getParameter("BelongNo");
	//Flag=Y��ʾ�����������Ϣ�б�����
	String sFlag = CurPage.getParameter("Flag");
	//����ֵת��Ϊ���ַ���
	if(sBelongNo == null) sBelongNo = "";
	if(sFlag == null) sFlag = "";
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "",doWhereSql="";
	if(sBelongNo.equals(""))
	{
		sTempletNo = "CourtPersonList";//ģ�ͱ��
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
		 sTempletNo = "CourtPersonList1";//ģ�ͱ��
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
			
			{"true","","Button","��������","�鿴��������","my_lawcase()","","","",""},
			{"true","","Button","����","�����б�ҳ��","goBack()","","","",""},
			{"true","","Button","ɾ��","ɾ��������","deleteRecord()","","","",""}
			//{"true","","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0,'alert(getRowCount(0))')","","","","btn_icon_delete",""},
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
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		AsControl.PopComp("/RecoveryManage/Public/CourtPersonInfo.jsp","","");
		reloadSelf();
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{
			as_delete(0);
			//as_del('myiframe0');
			//as_save('myiframe0');  //�������ɾ������Ҫ���ô����
		}
	}
	
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
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
		AsControl.PopComp("/RecoveryManage/Public/CourtPersonInfo.jsp","SerialNo="+sSerialNo+"&RightType="+rightType,"","");
		reloadSelf();
	}
	
	/*~[Describe=�����б�;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{     	
		self.close();
		/* OpenPage("/RecoveryManage/Public/CourtList.jsp?rand="+randomNumber(),"_self",""); */
	}
	
	/*~[Describe=�Ѵ�������Ϣ;InputParam=��;OutPutParam=��;]~*/
	function my_lawcase()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			AsControl.PopComp("/RecoveryManage/Public/SupplyLawCase.jsp","QuaryName=PersonNo&QuaryValue="+sSerialNo+"&Back=4&rand="+randomNumber(),"","");           	
		}		
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
