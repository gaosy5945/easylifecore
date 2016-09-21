<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>


	<%
	String PG_TITLE = "��ծ�ʲ���ֵ��������"; // ��������ڱ��� <title> PG_TITLE </title>
	
	//����������
	String sAssetStatus = CurComp.getParameter("AssetStatus");
	//��ȡ��ͬ�ս�����
    String sFinishType = CurComp.getParameter("FinishType");   
	
	//����ֵת��Ϊ���ַ���
	if(sAssetStatus ==  null) sAssetStatus = "";
	if(sFinishType == null) sFinishType = "";
	//���ҳ�����
	String sSerialNo = CurPage.getParameter("SerialNo");			//������¼��ˮ��
	if(sSerialNo == null ) sSerialNo = "";
	String sAssetSerialNo = CurPage.getParameter("AssetSerialNo");			//������¼��ˮ��
	if(sAssetSerialNo == null ) sAssetSerialNo = "";
	String sRightType = CurPage.getParameter("RightType");
	if(sRightType == null) sRightType = "";
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo ="PDAEvaluateInfo1";
	
	BusinessObject inputParameter = BusinessObject.createBusinessObject();

	inputParameter.setAttributeValue("SerialNo", sSerialNo);
	inputParameter.setAttributeValue("AssetSerialNo", sAssetSerialNo);
	
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(sTempletNo,inputParameter,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();	
	
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	//ALSInfoHtmlGenerator.replaceSubObjectWindow(dwTemp);
	doTemp.setBusinessProcess("com.amarsoft.app.als.awe.ow.ALSBusinessProcess");
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			{sAssetStatus.equals("04")?"false":(sFinishType.equals("")?"true":"false"),"","Button","����","���������޸�","saveRecord()","","","",""},
			{"true","","Button","����","���ص��ϼ�ҳ��","goBack()","","","",""}
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script type="text/javascript">

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		beforeUpdate();
		as_save("myiframe0",sPostEvents);					
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script type="text/javascript">

	/*~[Describe=����ǰҳ;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDAEvaluateList.jsp","right");
	}

	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}

	
	/*~[Describe=ҳ��װ��ʱ����OW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0)
		{
			bIsInsert = true;	
			initSerialNo();//��ʼ����ˮ���ֶ�
			setItemValue(0,getRow(),"EvaluateValue","0.00");
			setItemValue(0,getRow(),"AssetSerialNo","<%=sAssetSerialNo%>");
			setItemValue(0,getRow(),"EvaDate","<%=StringFunction.getToday()%>");
			setItemValue(0,getRow(),"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(),"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,getRow(),"InputOrgID","<%=CurOrg.getOrgID()%>");		
			setItemValue(0,getRow(),"InputOrgName","<%=CurOrg.getOrgName()%>");	
			setItemValue(0,getRow(),"InputDate","<%=StringFunction.getToday()%>");
		}
    }
	

	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "Asset_Evaluate";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺

		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	initRow();
</script>	
<%/*~END~*/%>

<%@ include file="/Frame/resources/include/include_end.jspf"%>