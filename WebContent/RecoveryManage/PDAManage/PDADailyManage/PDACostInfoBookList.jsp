<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "��ծ�ʲ�������ط���̨���б�";
	//���ҳ�����
	//String sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	//if(sInputUser==null) sInputUser="";
	String sAssetStatus = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AssetStatus"));
	String sObjectType	=DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sObjectNo	=DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AssetSerialNo"));
	String sSerialNo	=DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sRightType	=DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RightType"));
	//����ֵת��Ϊ���ַ���
	if(sRightType == null) sRightType = "";
	//����ֵת��Ϊ���ַ���
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(sAssetStatus == null ) sAssetStatus = "";
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "PDACostInfoBookList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	 
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectType+","+sObjectNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	String sButtons[][] = {
			{sAssetStatus.equals("03")?"false":"true","All","Button","����","����","newRecord()","","","",""},
			{"true","","Button","����","��ϸ��Ϣ","viewAndEdit()","","","",""},
			{sAssetStatus.equals("03")?"false":"true","All","Button","ɾ��","ɾ��","deleteRecord()","","","",""}
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	
	//---------------------���尴ť�¼�------------------------------------
	
	/*~[Describe=������¼;InputParam=��;OutPutParam=SerialNo;]~*/
	function newRecord()
	{
		OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDACostInfoBookInfo.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo=","right");
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		if(confirm(getHtmlMessage(2))) //�������ɾ������Ϣ��
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//��÷�����ˮ��
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		var sAssetStatus="<%=sAssetStatus%>";
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDACostInfoBookInfo.jsp?SerialNo="+sSerialNo
				+"&ObjectType="+"<%=sObjectType%>"+"&ObjectNo="+"<%=sObjectNo%>"+"&AssetStatus="+sAssetStatus,"right");
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


<%@ include file="/IncludeEnd.jsp"%>