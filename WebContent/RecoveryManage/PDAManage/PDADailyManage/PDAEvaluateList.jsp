<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>

	<%
	String PG_TITLE = " ��ծ�ʲ���ֵ������¼"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;��ծ�ʲ���ֵ������¼&nbsp;&nbsp;";
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";
	
	//����������	
	String sAssetStatus = CurComp.getParameter("AssetStatus");
	String sSerialNo = CurComp.getParameter("SerialNo");
	String sAssetSerialNo = CurComp.getParameter("AssetSerialNo");
	//��ȡ��ͬ�ս�����
    String sFinishType = CurComp.getParameter("FinishType");   
	//����ֵת��Ϊ���ַ���
	if(sSerialNo == null) sSerialNo = "";
	if(sAssetStatus ==  null) sAssetStatus = "";
    if(sFinishType == null) sFinishType = "";

	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "PDAEvaluateList";//ģ�ͱ��
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);  //��������ҳ
	
	dwTemp.genHTMLObjectWindow(sAssetSerialNo);

	String sButtons[][] = {
		{"true","All","Button","����","������ֵ������¼","newRecord()","","","",""},
		{"true","","Button","����","��ֵ������¼����","viewAndEdit()","","","",""},
		{sAssetStatus.equals("03")?"false":"true","All","Button","ɾ��","ɾ��������¼","deleteRecord()","","","",""}
		};
	%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=SerialNo;]~*/
	function newRecord()
	{
		var sAssetSerialNo="<%=sAssetSerialNo%>";
		AsControl.OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDAEvaluateInfo.jsp","AssetSerialNo="+sAssetSerialNo,"right","");
		reloadSelf();
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");
		//var sAssetSerialNo=getItemValue(0,getRow(),"AssetSerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{		
			if(confirm(getHtmlMessage(2))) //�������ɾ������Ϣ��
			{
				as_delete('myiframe0');
			}
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		sSerialNo=getItemValue(0,getRow(),"SerialNo");
		var sAssetSerialNo="<%=sAssetSerialNo%>";
		var sAssetStatus="<%=sAssetStatus%>";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			AsControl.OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDAEvaluateInfo.jsp","SerialNo="+sSerialNo+"&AssetSerialNo="+sAssetSerialNo+"&AssetStatus="+sAssetStatus,"right","");
		}
	}	
	</script>

<%@ include file="/Frame/resources/include/include_end.jspf"%>
