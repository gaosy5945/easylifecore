<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	

	//�������
	String sSql = "";
	
	//����������
	
	//���ҳ�����	    
	String sQuaryName = CurPage.getParameter("QuaryName");
	String sQuaryValue = CurPage.getParameter("QuaryValue");
	String sBack = CurPage.getParameter("Back");
	//����ֵת��Ϊ���ַ���
	if(sQuaryName == null) sQuaryName = "";
	if(sQuaryValue == null) sQuaryValue = "";
	if(sBack == null) sBack = "";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
    String sTempletNo = "";
	
	if(sQuaryName.equals("OrgNo"))
	{
		sTempletNo = "SupplyLawCaseList";//ģ�ͱ��
	}
	
	if(sQuaryName.equals("PersonNo"))
	{
		sTempletNo = "SupplyLawCaseList1";//ģ�ͱ��
	}
	
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//��ѯ��������ʱ���ӻ������û����ƣ������ϰ����ճ�������һ��  
	doTemp.setJboWhere(doTemp.getJboWhere() + " and O.MANAGEORGID = '"+CurOrg.getOrgID()+"' AND O.MANAGEUSERID = '"+CurUser.getUserID()+"'");
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow(sQuaryValue+","+sQuaryName+","+sBack);

	String sButtons[][] = {
			{"true","","Button","����","����","viewAndEdit()","","","",""},
			{"true","","Button","����","����","goBack()","","","",""}
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	
	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		//��ð�����ˮ��
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");	
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
			reloadSelf();	
		}
	}
	
	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{		
		self.close();
	}

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
