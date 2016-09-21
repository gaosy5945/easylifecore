<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String sSerialNo = (String)CurComp.getParameter("SerialNo");	//�ʲ���ˮ��
	String sAssetStatus =  (String)CurComp.getParameter("AssetStatus");
	if(sSerialNo == null) sSerialNo = "";	
	if(sAssetStatus == null ) sAssetStatus = "";

	ASObjectModel doTemp = new ASObjectModel("PDALawCaseList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow(sSerialNo);

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"03".equals(sAssetStatus)?"false":"true","All","Button","����","����һ����ͬ��Ϣ","newRecord()","","","",""},
			{"true","","Button","��ծ����","�鿴/�޸�����","viewAndEdit()","","","",""},
			{"true","","Button","��������","�쿴��ͬ����","my_LawCase()","","","",""}	,
			{"03".equals(sAssetStatus)?"false":"true","All","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()","","","",""}		
	};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
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
			var sObjectType = "jbo.preservation.LAWCASE_INFO";//��������  ��ծ�ʲ�����������Ϣ
			var sDASerialNo = "<%=sSerialNo%>";	//��ծ�ʲ���ˮ��
			var sSerialNo = initSerialNo();	//��ծ�ʲ���ծ��Ϣ��ˮ��  ��DAO��������һ�� ��ծ�ʲ�����������Ϣ ������ˮ��
			var sReturn=PopPageAjax("/RecoveryManage/PDAManage/PDADailyManage/AddNPABCActionAjax.jsp?SerialNo="+sSerialNo+"&DASerialNo="+sDASerialNo+"&ObjectType="+sObjectType+"&RelativeContractNo="+sLawCaseSerialNo+"","","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");
			if(typeof(sReturn)!="undefined" && sReturn=="true"){
				popComp("PDAAssetLawCaseInfo","/RecoveryManage/PDAManage/PDADailyManage/PDARelativeLawCaseInfo.jsp","LawCaseSerialNo="+sLawCaseSerialNo+"&DASerialNo="+sDASerialNo+"&SerialNo="+sSerialNo);
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
			var sSql = "delete npa_debtasset_object where serialno ='"+sSerialNo+"'";
			var sReturnValue =  RunMethod("PublicMethod","RunSql",sSql);
			if(sReturnValue > -1){ 
				sMsg = "ɾ���ɹ���";
			}else {
				sMsg = "ɾ��ʧ�ܣ�";
			}  
			alert(sMsg);
		}
		reloadSelf();
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
		//��ð�����ˮ��
		var sSerialNo=getItemValue(0,getRow(),"OBJECTNO");	
		var sLawCaseType=getItemValue(0,getRow(),"LawCaseType");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			sObjectType = "LawCase";
			sObjectNo = sSerialNo;			
			var sFunctionID="";
			if(sLawCaseType == "01" ){
				sFunctionID = "CaseInfoList1";
			}else{
				sFunctionID = "CaseInfoList2";
			}
			
			AsCredit.openFunction(sFunctionID,"SerialNo="+sObjectNo+"&LawCaseType="+sLawCaseType+"&RightType=ReadOnly");	
		}	
		reloadSelf();	
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
<%@ include file="/Frame/resources/include/include_end.jspf"%>
