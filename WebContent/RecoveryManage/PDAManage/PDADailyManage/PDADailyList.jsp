<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "��ծ�ʲ��ճ������б�";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp AppNoDisposalListģ���ΪPDADailyList
	String sTempletNo = "PDADailyList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(16);
	
	//ɾ����ծ�ʲ���ɾ��������Ϣ
    dwTemp.setEvent("AfterDelete","!WorkFlowEngine.DeleteTask(AssetInfo,#SerialNo,DeleteBusiness)");

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(CurUser.getUserID());
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));	
	String sButtons[][] = {
			{"true","","Button","����","����һ����¼","newRecord()","","","",""},
			{"true","","Button","�ʲ�����","�鿴/�޸��ʲ�����","viewAndEdit()","","","",""},
			{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()","","","",""},
			{"true","","Button","�����ս�","�ս���ѡ�еļ�¼","finishRecord()","","","",""}
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
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		//popComp("PDABasicView","/RecoveryManage/PDAManage/PDADailyManage/PDABasicView.jsp","SerialNo="+sSerialNo+"&AssetSerialNo="+sAssetSerialNo,"");
		var sFunctionID="PDAInfoList";
		AsCredit.openFunction(sFunctionID,"SerialNo="+sSerialNo+"&AssetSerialNo="+sAssetSerialNo+"&AssetType="+sAssetType);	
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
		//type=1 ��ζ�Ŵ�AppDisposingList��ִ�д����սᲢ�һ��ܡ�
		//type=2 ��ζ�Ŵ�PDADisposalEndList�в쿴���ܡ�
		//type=3 ��ζ�Ŵ�PDADisposalBookList�в쿴���ܡ�
        sReturn = popComp("PDADisposalEndInfo","/RecoveryManage/PDAManage/PDADailyManage/PDADisposalEndInfo.jsp","SerialNo="+sSerialNo+"&AssetSerialNo="+sAssetSerialNo+"&Type=1","dialogWidth:720px;dialogheight:580px","");
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

<%@ include file="/IncludeEnd.jsp"%>
