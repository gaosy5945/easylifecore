<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	//������������������ˮ�š��������ͣ�
	String sSerialNo = (String)CurComp.getParameter("SerialNo");
	if(sSerialNo == null ) sSerialNo = "";
	String sLawCaseType = (String)CurComp.getParameter("LawCaseType");
	if(sLawCaseType == null ) sLawCaseType = "";
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";
	String sTempletNo = "";
	String sTempletFilter = "1=1";
	if (sLawCaseType.equals("01"))
		sTempletNo="LawCaseInfo1";	//һ�㰸��
	else if (sLawCaseType.equals("02"))
		sTempletNo="LawCaseInfo2";	//����/�ٲ�ִ�а���
		
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//doTemp.setColTips("", "����");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.genHTMLObjectWindow(CurPage.getParameter("SerialNo"));
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","as_save(0)","","","",""},
		{String.valueOf(!com.amarsoft.are.lang.StringX.isSpace(sPrevUrl)),"All","Button","����","�����б�","returnList()","","","",""}
	};
	sButtonPosition = "north";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function returnList(){
		OpenPage("<%=sPrevUrl%>", "_self");
	}
	//---------------------���尴ť�¼�------------------------------------
	
	/*~[Describe=ѡ�������������;InputParam=��;OutPutParam=��;]~*/
	function getAgencyName()
	{		
		//sParaString = "AgencyType"+",01";
		//setObjectValue("SelectAgency",sParaString,"@CourtStatus@1",0,0,"");		
		sParaString = "AgencyType,01,DepartType,01";
		setObjectValue("SelectAgencyForDepartType",sParaString,"@CourtStatus@1",0,0,"");
	}
	/*~[Describe=ѡ�������������;InputParam=��;OutPutParam=��;]~*/
	function getAgencyName2()
	{		
		//sParaString = "AgencyType"+",01";
		//setObjectValue("SelectAgency",sParaString,"@CourtStatus@1",0,0,"");		
		sParaString = "AgencyType,01,DepartType,02";
		setObjectValue("SelectAgencyForDepartType2",sParaString,"@Claim@1",0,0,"");
	}
	

	//������������У����𣬱�����Ϣ��������Ϣ��������������ܱ��	
	function getAimSum()
 	{ 
       var sPrincipal = getItemValue(0,getRow(),"Principal");
       var sInDebtInterest = getItemValue(0,getRow(),"InDebtInterest");
       var sOutDebtInterest = getItemValue(0,getRow(),"OutDebtInterest");
       var sOtherCost = getItemValue(0,getRow(),"OtherCost");
       var sCurrency = getItemValue(0,getRow(),"Currency");
       if(typeof(sPrincipal)=="undefined" || sPrincipal.length==0) sPrincipal=0.00; 
       if(typeof(sInDebtInterest)=="undefined" || sInDebtInterest.length==0) sInDebtInterest=0.00;
       if(typeof(sOutDebtInterest)=="undefined" || sOutDebtInterest.length==0) sOutDebtInterest=0.00; 
       if(typeof(sOtherCost)=="undefined" || sOtherCost.length==0) sOtherCost=0.00; 
		  
       //�����ܱ��=���У�����+������Ϣ+������Ϣ+����
       var sAimSum = (parseFloat(sPrincipal)+parseFloat(sInDebtInterest)+parseFloat(sOutDebtInterest)+parseFloat(sOtherCost)).toFixed(2);
	   setItemValue(0,getRow(),"AimSum",sAimSum);       
    }
     	
    /*~[Describe=�����û�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectUser(type)
	{	
    	if(type==1){
			sParaString = "BelongOrg"+","+"<%=CurUser.getOrgID()%>";
			setObjectValue("SelectUserBelongOrg",sParaString,"@ManageUserId@0@ManageUserName@1@ManageOrgID@2@ManageOrgName@3",0,0,"");
		}
	}
		
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0)
		{
			//as_add("myiframe0");//������¼ SerialNo
			setItemValue(0,0,"SerialNo","<%=sSerialNo%>");
			setItemValue(0,0,"CasePhase","010");
			setItemValue(0,0,"LawCaseType","<%=sLawCaseType%>");
			setItemValue(0,0,"ManageUserId","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"ManageOrgId","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"ManageUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"ManageOrgName","<%=CurUser.getOrgName()%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgName","<%=CurUser.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");

		}
		setItemValue(0,0,"Currency","CNY");
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		setItemValue(0,0,"PigeonholeDate","<%=StringFunction.getToday()%>");
    }
	
	/*~[Describe=����/���� ������Ϣ�����߷�Ժ;InputParam=��;OutPutParam=��;]~*/
	function getAgencyName(){
		sParaString = "AgencyType"+",01,DepartType,01";  //AGENCYTYPE='01' DepartType='01'
		//modified by qjliang ��ӷ���CourtNo ��Ժ���
		setObjectValue("SelectAgency",sParaString,"@CourtStatus@0@CourtStatusName@1",0,0,"");	
	}
	
	initRow();	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
