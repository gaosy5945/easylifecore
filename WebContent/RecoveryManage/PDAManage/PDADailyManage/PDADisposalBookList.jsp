<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "��ծ�ʲ�����̨���б�";
	//���ҳ�����
	String sAssetType = CurComp.getParameter("AssetType");
	String sAssetStatus = CurComp.getParameter("AssetStatus");
	String sObjectType	=CurComp.getParameter("ObjectType");
	String sDASerialNo = CurComp.getParameter("SerialNo");
	String sAssetSerialNo = CurComp.getParameter("AssetSerialNo");
	//����ֵת��Ϊ���ַ���
	if(sDASerialNo == null) sDASerialNo = "";
	if(sAssetSerialNo == null) sAssetSerialNo = "";
	if(sObjectType == null) sObjectType = "";
	if(sAssetStatus == null ) sAssetStatus = "";
	if(sAssetType == null ) sAssetType = "";
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "PDADisposalBookList";//ģ�ͱ��
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
		
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	
	doTemp.setBusinessProcess("com.amarsoft.app.als.awe.ow.ALSBusinessProcess");
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(15);
	dwTemp.genHTMLObjectWindow(sDASerialNo + "," + sObjectType);
	String sButtons[][] = {
			{sAssetStatus.equals("03")?"false":"true","All","Button","����","����","newRecord()","","","",""},
			{"true","","Button","����","��ϸ��Ϣ","viewAndEdit()","","","",""},
			{sAssetStatus.equals("03")?"false":"true","All","Button","ɾ��","ɾ��","deleteRecord()","","","",""},
		};
	%> 
<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	
	//---------------------���尴ť�¼�------------------------------------
	
	/*~[Describe=������¼;InputParam=��;OutPutParam=SerialNo;]~*/
	function newRecord()
	{
		var sDASerialNo="<%=sDASerialNo%>";
		var sObjectType = "<%=sObjectType%>";
		var sAssetSerialNo="<%=sAssetSerialNo%>";
		var sAssetType = "<%=sAssetType%>";
		var sTransactionType = "";
		var sDATSerialNo = getSerialNo("NPA_DEBTASSET_TRANSACTION","SerialNo","");

		//var sURL = "/RecoveryManage/PDAManage/PDADailyManage/PDADisposalBookInfo.jsp";
		var sURL = "/RecoveryManage/PDAManage/PDADailyManage/PDADisposalBookViewInfo.jsp";
		
		if("Lease"==sObjectType){
			sTransactionType = "01";
		} else if ("Cash"==sObjectType) {
			AsControl.PopComp(sURL,"SerialNo="+sDATSerialNo+"&DASerialNo="+sDASerialNo+"&ObjectType="+sObjectType+"","");
		} else {
			sTransactionType = PopPage("/RecoveryManage/PDAManage/PDADailyManage/PDADisposalTypeDialog.jsp","","resizable=yes;dialogWidth=21;dialogHeight=10;center:yes;status:no;statusbar:no");
		}
		if(typeof(sTransactionType) != "undefined" && sTransactionType.length != 0)
		{			
			//��ȡ��ˮ��
			AsControl.PopComp(sURL,"SerialNo="+sDATSerialNo+"&DASerialNo="+sDASerialNo+"&ObjectType="+sObjectType+"&TransactionType="+sTransactionType+"&AssetSerialNo="+sAssetSerialNo+"&AssetType="+sAssetType+"","");
		} 		
		reloadSelf();
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
			as_delete(0);
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//����ʲ�������ˮ��
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		var sDebtAssetSerialNo = getItemValue(0,getRow(),"DebtAssetSerialNo");
		var sObjectType = "<%=sObjectType%>";//��������̨��
		var sAssetSerialNo="<%=sAssetSerialNo%>";
		var sAssetType = "<%=sAssetType%>";
		var sTransCode = getItemValue(0,getRow(),"TRANSACTIONCODE");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		//var sURL = "/RecoveryManage/PDAManage/PDADailyManage/PDADisposalBookInfo.jsp";
		var sURL = "/RecoveryManage/PDAManage/PDADailyManage/PDADisposalBookViewInfo.jsp";
		AsControl.PopComp(sURL,"SerialNo="+sSerialNo+"&ObjectType="+sObjectType+"&DASerialNo="+sDebtAssetSerialNo+"&TransactionType="+sTransCode,"");

		reloadSelf();
	}	
	
	</script>


<%@ include file="/Frame/resources/include/include_end.jspf"%>