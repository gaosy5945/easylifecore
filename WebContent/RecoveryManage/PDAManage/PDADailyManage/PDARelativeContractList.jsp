<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "��Ӧ��ͬ�����Ϣ�б�";
	//���ҳ�����
	//String sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	//if(sInputUser==null) sInputUser="";
	
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));	//��ծ�ʲ���ˮ��
	String sAssetStatus = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("AssetStatus"));
	if(sSerialNo == null) sSerialNo = "";	
	if(sAssetStatus == null ) sAssetStatus = "";
	String sRightType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RightType"));
	if(sRightType == null) sRightType = "";	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "PDARelativeContractList";//ģ�ͱ��
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
		{sAssetStatus.equals("04")?"false":"true","All","Button","����","����һ����ͬ��Ϣ","newRecord()","","","",""},
		{"true","","Button","��ծ����","�鿴/�޸�����","viewAndEdit()","","","",""},
		{"true","","Button","��ͬ����","�쿴��ͬ����","my_Contract()","","","",""}	,
		{sAssetStatus.equals("04")?"false":"true","All","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()","","","",""}		
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
		var sRelativeContractNo = "";	
		//��ȡ��ծ�ʲ������ĺ�ͬ��ˮ��	
		<%-- var sContractInfo  = AsDialog.OpenSelector("SelectRelativeContract","orgID,<%=CurUser.getOrgID()%>",""); --%>
		var sContractInfo = AsDialog.SelectGridValue('RelativeContractChooseList',"<%=CurUser.getOrgID()%>",'SERIALNO','',"false","","","1");
		//var sContractInfo = setObjectValue("SelectRelativeContract","","@RelativeContract@0",0,0,"");
		if(typeof(sContractInfo) != "undefined" && sContractInfo != "" && sContractInfo != "_NONE_" && sContractInfo != "_CLEAR_" && sContractInfo != "_CANCEL_")  
		{
			sContractInfo = sContractInfo.split('@');
			sRelativeContractNo = sContractInfo[0];
		}		
		if(sRelativeContractNo == "" || typeof(sRelativeContractNo) == "undefined"){
			alert("δѡ�к�ͬ��");
			return;
		} else {	
			var sObjectType = "Business_Contract";//��������
			var sDASerialNo = "<%=sSerialNo%>";	//��ծ�ʲ���ˮ��
			var sSerialNo = initSerialNo();	//��ծ�ʲ���ծ��Ϣ��ˮ��  ��DAO��������һ�� ��ծ�ʲ�����������Ϣ ������ˮ��
			var sReturn=PopPageAjax("/RecoveryManage/PDAManage/PDADailyManage/AddNPABCActionAjax.jsp?SerialNo="+sSerialNo+"&DASerialNo="+sDASerialNo+"&ObjectType="+sObjectType+"&RelativeContractNo="+sRelativeContractNo+"","","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");
			if(typeof(sReturn)!="undefined" && sReturn=="true"){
				//self.close();
				AsControl.PopComp("/RecoveryManage/PDAManage/PDADailyManage/PDARelativeContractInfo.jsp","ContractSerialNo="+sRelativeContractNo+"&DASerialNo="+sDASerialNo+"&SerialNo="+sSerialNo);
				reloadSelf();
			}else{
				alert("�����������ѡ���������롣");
				return ;
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
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{				
		var sContractSerialNo = getItemValue(0,getRow(),"OBJECTNO");  
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");		
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��	
			return;		
		}
		
		AsControl.PopComp("/RecoveryManage/PDAManage/PDADailyManage/PDARelativeContractInfo.jsp","ContractSerialNo="+sContractSerialNo+"&SerialNo="+sSerialNo + "&RightType=<%=sRightType%>");
	}	
	
	/*~[Describe=�鿴��ͬ����;InputParam=��;OutPutParam=SerialNo;]~*/
	function my_Contract()
	{  
		//��ú�ͬ��ˮ��
		var sContractNo = getItemValue(0,getRow(),"OBJECTNO");  //��ͬ��ˮ�Ż������
		if (typeof(sContractNo) == "undefined" || sContractNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		AsCredit.openFunction("ContractInfo","ObjectType=jbo.app.BUSINESS_CONTRACT&ObjectNo="+sContractNo+"&RightType=ReadOnly");
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
