<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%><%
	/*
		Content: �������Ŷ������
		Input Param:
			ObjectType����������
			ApplyType����������
			PhaseType���׶�����
			FlowNo�����̺�
			PhaseNo���׶κ�		
		Output param:
		History Log: zywei 2005/07/28
					 zywei 2005/07/28 �����Ŷ������ҳ�浥������
					 jgao1 2009/10/21 ���Ӽ������Ŷ�ȣ��Լ�ѡ��ͻ����ͱ仯ʱ���Data����
	 */
	String PG_TITLE = "���ŷ���������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	//����������	���������͡��������͡��׶����͡����̱�š��׶α��
	String sObjectType = CurPage.getParameter("ObjectType");
	String sApplyType =  CurPage.getParameter("ApplyType");
	String sPhaseType = CurPage.getParameter("PhaseType");
	String sFlowNo =  CurPage.getParameter("FlowNo");
	String sPhaseNo =  CurPage.getParameter("PhaseNo");
	
	//����ֵת���ɿ��ַ���
	if(sObjectType == null) sObjectType = "";	
	if(sApplyType == null) sApplyType = "";
	if(sPhaseType == null) sPhaseType = "";	
	if(sFlowNo == null) sFlowNo = "";
	if(sPhaseNo == null) sPhaseNo = "";
		
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "CreditLineApplyCreationInfo";
	//����ģ�����������ݶ���	
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//���ñ��䱳��ɫ
	doTemp.setHTMLStyle("CustomerType","style={background=\"#EEEEff\"} ");
	//���ͻ����ͷ����ı�ʱ��ϵͳ�Զ������¼�����Ϣ
	doTemp.appendHTMLStyle("CustomerType"," onClick=\"javascript:parent.clearData()\" ");
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//���ñ���ʱ�����������ݱ��Ķ���
	dwTemp.setEvent("AfterInsert","!WorkFlowEngine.InitializeFlowNew("+sObjectType+",#SerialNo,"+sApplyType+","+sFlowNo+","+sPhaseNo+","+CurUser.getUserID()+","+CurOrg.getOrgID()+") + !WorkFlowEngine.InitializeCLInfo(#SerialNo,#BusinessType,#CustomerID,#CustomerName,#InputUserID,#InputOrgID)");
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
		
	String sButtons[][] = {
		{"true","","Button","ȷ��","ȷ���������Ŷ������","doCreation()","","","",""},
		{"true","","Button","ȡ��","ȡ���������Ŷ������","doCancel()","","","",""}	
	};
%><%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<script type="text/javascript">
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents){
		setItemValue(0,0,"ContractFlag","2");//��ռ�ö��
		initSerialNo();
		as_save("myiframe0",sPostEvents);		
	}
		   
    /*~[Describe=ȡ���������ŷ���;InputParam=��;OutPutParam=ȡ����־;]~*/
	function doCancel(){
		top.returnValue = "_CANCEL_";
		top.close();
	}

	/*~[Describe=����һ�����������¼;InputParam=��;OutPutParam=��;]~*/
	function doCreation(){
		saveRecord("doReturn()");
	}
	
	/*~[Describe=ȷ��������������;InputParam=��;OutPutParam=������ˮ��;]~*/
	function doReturn(){
		sObjectNo = getItemValue(0,0,"SerialNo");
		sObjectType = "<%=sObjectType%>";		
		top.returnValue = sObjectNo+"@"+sObjectType;
		top.close();
	}
		
	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCustomer(){
		sCustomerType = getItemValue(0,0,"CustomerType");
		if(typeof(sCustomerType) == "undefined" || sCustomerType == ""){
			alert("����ѡ��ͻ�����!");
			return;
		}
		//����ҵ�����Ȩ�Ŀͻ���Ϣ
		sParaString = "UserID"+","+"<%=CurUser.getUserID()%>"+","+"CustomerType"+","+sCustomerType;
		if(sCustomerType == "02")
			//ѡ���ſͻ�
			setObjectValue("SelectApplyCustomer2",sParaString,"@CustomerID@0@CustomerName@1",0,0,"");
		else
			//ѡ��˾��ͻ�(����������ҵ�����϶�����С��ҵ)
			setObjectValue("SelectApplyCustomer3",sParaString,"@CustomerID@0@CustomerName@1",0,0,"");
	}
	
	/*~[Describe=����ҵ��Ʒ��ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectBusinessType(sType){
		if(sType == "CL"){ //���Ŷ�ȵ�ҵ��Ʒ��
			sCustomerType = getItemValue(0,0,"CustomerType");
			if(typeof(sCustomerType) == "undefined" || sCustomerType == ""){
				alert("����ѡ��ͻ�����!");
				return;
			}
			//��01��������˾�ͻ�����02���������ſͻ������ѡ����ǹ�˾�ͻ����򵯳����Ŷ��ҵ��Ʒ�֣����ѡ����Ǽ��ſͻ�����Ĭ��Ϊ�������Ŷ��
			if(sCustomerType=="01")
				setObjectValue("SelectCLBusinessType","","@BusinessType@0@BusinessTypeName@1",0,0,"");	
			if(sCustomerType=="02"){
				//������������ʾ��䣬��ֹ�������飡
				alert("���ſͻ�ֻ�����뼯�����Ŷ�ȣ�");
				return;
			}		
		}
	}
							
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");//����һ���ռ�¼			
			//��������
			setItemValue(0,0,"OccurType","010");
			//��������
			setItemValue(0,0,"OccurDate","<%=StringFunction.getToday()%>");
			//��������
			setItemValue(0,0,"ApplyType","<%=sApplyType%>");
			//��Ʒ����
			setItemValue(0,0,"BusinessType","3010");
			//��Ʒ��������
			setItemValue(0,0,"BusinessTypeName","�ڲ����Ŷ��");
			//�������
			setItemValue(0,0,"OperateOrgID","<%=CurUser.getOrgID()%>");
			//������
			setItemValue(0,0,"OperateUserID","<%=CurUser.getUserID()%>");
			//��������
			setItemValue(0,0,"OperateDate","<%=StringFunction.getToday()%>");
			//�Ǽǻ���
			setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
			//�Ǽ���
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			//�Ǽ�����			
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			//��������
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			//�ݴ��־
			setItemValue(0,0,"TempSaveFlag","1");//�Ƿ��־��1���ǣ�0����
			//�ͻ�����Ĭ��Ϊ��˾�ͻ�
			setItemValue(0,0,"CustomerType","01");
			//������־
			setItemValue(0,0,"Flag5","010");//��־��010����ʼ��δ������020����������	
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo(){
		var sTableName = "BUSINESS_APPLY";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺
		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}

	/*~[Describe=�����Ϣ;InputParam=��;OutPutParam=������ˮ��;]~*/
	function clearData(){
		var sCustomerType = getItemValue(0,0,"CustomerType");
		if(sCustomerType=="01"){
			//����ͻ�����Ϊ��˾�ͻ�����Ĭ��Ϊ�ۺ����Ŷ�ȣ�����Ϊ3010
			setItemValue(0,0,"BusinessType","3010");
			setItemValue(0,0,"BusinessTypeName","�ڲ����Ŷ��");
		}else if(sCustomerType=="02"){
			//����ͻ�����Ϊ���ſͻ�����Ĭ��Ϊ�������Ŷ�ȣ�����Ϊ3020
			setItemValue(0,0,"BusinessType","3020");
			setItemValue(0,0,"BusinessTypeName","�������Ŷ��");
		}else{
			setItemValue(0,0,"BusinessTypeName","");
			setItemValue(0,0,"BusinessType","");
		}
		setItemValue(0,0,"CustomerID","");
		setItemValue(0,0,"CustomerName","");
	}
	initRow();
</script>	
<%@ include file="/Frame/resources/include/include_end.jspf"%>