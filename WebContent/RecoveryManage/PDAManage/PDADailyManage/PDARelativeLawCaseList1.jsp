<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "��Ӧ���������Ϣ�б�";
	//���ҳ�����
	//String sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	//if(sInputUser==null) sInputUser="";
	
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));	//�ʲ���ˮ��
	String sAssetStatus = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("AssetStatus"));
	if(sSerialNo == null) sSerialNo = "";	
	if(sAssetStatus == null ) sAssetStatus = "";
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "PDALawCaseList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	String sButtons[][] = {
		{sAssetStatus.equals("03")?"false":"true","","Button","����","����һ����ͬ��Ϣ","newRecord()","","","",""},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()","","","",""},
		{"false","","Button","��������","�쿴��ͬ����","my_LawCase()","","","",""}	,
		{sAssetStatus.equals("03")?"false":"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()","","","",""}		
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
		var sLawCaseSerialNo = "";	
		//��ȡ��ծ�ʲ������ĺ�ͬ��ˮ��	
		var sLawCaseInfo  = AsDialog.OpenSelector("SelectRelativeLawCase","","");
		if(typeof(sLawCaseInfo) != "undefined" && sLawCaseInfo != "" && sLawCaseInfo != "_NONE_" 
		&& sLawCaseInfo != "_CLEAR_" && sLawCaseInfo != "_CANCEL_")  
		{
			sLawCaseInfo = sLawCaseInfo.split('@');
			sLawCaseSerialNo = sLawCaseInfo[0];
		}		
		if(sLawCaseSerialNo == "" || typeof(sLawCaseSerialNo) == "undefined") return;
		{	
			var sObjectType = "LawCase_Info";//��������  ��ծ�ʲ�����������Ϣ
			var sDASerialNo = "<%=sSerialNo%>";	//��ծ�ʲ���ˮ��
			var sSerialNo = initSerialNo();	//��ծ�ʲ���ծ��Ϣ��ˮ��  ��DAO��������һ�� ��ծ�ʲ�����������Ϣ ������ˮ��
			var sReturn=PopPageAjax("/RecoveryManage/PDAManage/PDADailyManage/AddNPABCActionAjax.jsp?SerialNo="+sSerialNo+"&DASerialNo="+sDASerialNo+"&ObjectType="+sObjectType+"&RelativeContractNo="+sLawCaseSerialNo+"","","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");
			if(typeof(sReturn)!="undefined" && sReturn=="true"){
				popComp("PDAAssetLawCaseInfo","/RecoveryManage/PDAManage/PDADailyManage/PDARelativeLawCaseInfo.jsp","LawCaseSerialNo="+sLawCaseSerialNo+"&DASerialNo="+sDASerialNo+"&SerialNo="+sSerialNo);
				reloadSelf();
			}
		}
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		if(confirm(getHtmlMessage(2))) //�������ɾ������Ϣ��
		{
			var sSql = "delete npa_debtasset_object where serialno ='"+sSerialNo+"'";
			var sReturnValue =  RunMethod("PublicMethod","RunSql",sSql);
			if(sReturnValue > -1){ 
				sMsg = "ɾ���ɹ���";
			}else {
				sMsg = "ɾ��ʧ�ܣ�";
			}  
			alert(sMsg);
			//as_del("myiframe0");
			//as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{				
		sLawCaseSerialNo = getItemValue(0,getRow(),"OBJECTNO");  
		sSerialNo = getItemValue(0,getRow(),"SERIALNO");		
		var sAssetStatus="<%=sAssetStatus%>";
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��	
			return;		
		}
		
		popComp("PDAAssetLawCaseInfo","/RecoveryManage/PDAManage/PDADailyManage/PDARelativeLawCaseInfo.jsp","LawCaseSerialNo="+sLawCaseSerialNo+"&SerialNo="+sSerialNo);
		reloadSelf();
	}	
	
	/*~[Describe=�鿴��ͬ����;InputParam=��;OutPutParam=SerialNo;]~*/
	function my_LawCase()
	{  
		//��ú�ͬ��ˮ��
		var sContractNo = getItemValue(0,getRow(),"ContractSerialNo");  //��ͬ��ˮ�Ż������
		if (typeof(sContractNo) == "undefined" || sContractNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		sObjectType = "AfterLoan";
		sObjectNo = sContractNo;				
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
	}	
	
	/*  ������ˮ�� */
	function initSerialNo()
	{
		 //����һ���µļ�¼����NPA_DebtAsset_Object�����кš�
		var sTableName = "NPA_DEBTASSET_OBJECT";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺
		var  sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		return sSerialNo;
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
