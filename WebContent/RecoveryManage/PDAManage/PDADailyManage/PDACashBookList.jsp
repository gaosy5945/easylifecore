<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "��ծ�ʲ�����̨���б�";
	//���ҳ�����
	String sObjectNo	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	//����ֵת��Ϊ���ַ���
	if(sObjectNo == null) sObjectNo = "";
	String sObjectType = "Cash";//���� sObjectType="Cash"
	String sDASerialNo = CurPage.getParameter("SerialNo");
	if(sDASerialNo == null) sDASerialNo = "";
	String sAISerialNo = CurPage.getParameter("AssetSerialNo");
	if(sAISerialNo == null) sAISerialNo = "";
	String sRightType = CurPage.getParameter("RightType");
	if(sRightType == null) sRightType = "";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "PDACashBookList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(16);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sDASerialNo+","+sObjectType);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
			{"true","All","Button","����","������ծ�ʲ����ּ�¼","newRecord()","","","",""},
			{"true","","Button","����","�鿴��ծ�ʲ�������ϸ��Ϣ","viewAndEdit()","","","",""},
			{"true","All","Button","ɾ��","ɾ����ծ�ʲ�������Ϣ","deleteRecord()","","","",""},
		};
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{		
		var sDATSerialNo = getSerialNo("npa_debtasset_transaction","SerialNo","");
		var sDAOSerialNo = getSerialNo("npa_debtasset_object","SerialNo","");
		AsControl.PopComp("/RecoveryManage/PDAManage/PDADailyManage/PDACashBookInfo.jsp","DASerialNo=<%=sDASerialNo%>&ObjectType=Cash"+"&DATSerialNo="+sDATSerialNo+"&DAOSerialNo="+sDAOSerialNo,"");
		reloadSelf();
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{	
			as_del('myiframe0');
			as_save('myiframe0');  //�������ɾ������Ҫ���ô����
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		var sDAOSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sDASerialNo = getItemValue(0,getRow(),"DASerialNo");
		var sDATSerialNo = getItemValue(0,getRow(),"DATSerialNo");
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		if (typeof(sDAOSerialNo) == "undefined" || sDAOSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		AsControl.PopComp("/RecoveryManage/PDAManage/PDADailyManage/PDACashBookInfo.jsp","DAOSerialNo="+sDAOSerialNo
				+"&DASerialNo="+sDASerialNo+"&ObjectType="+sObjectType+"&DATSerialNo="+sDATSerialNo+"&RightType=<%=sRightType%>","");
		reloadSelf();
	}
	
</script>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>


<%@include file="/IncludeEnd.jsp"%>
