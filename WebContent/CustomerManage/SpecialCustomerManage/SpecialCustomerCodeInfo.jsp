<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:
		Tester:
		Content: ������������ҳ��
		Input Param:
		       --SerialNO:��ˮ��
		Output param:
		History Log: 
		-- fbkang ��������ҳ��

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "������������ҳ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>

<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	
	//�������
	
		//���ҳ�����	����������ˮ��
    	String itemNo = CurPage.getParameter("ItemNo");
		// ͨ��DWģ�Ͳ���ASDataObject����doTemp
		String sTempletNo = "SpecialCustCodeInfo";//ģ�ͱ��
		ASObjectModel doTemp = new ASObjectModel(sTempletNo,"");
		
		ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
		dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
		dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д

		//ʹ������ģ��ǰ�ġ���ʾ��׺��
		//doTemp.setUnit("CustomerName"," <input type=button value=.. onclick=parent.selectCustomer()>");
		//doTemp.setHTMLStyle("CertID"," onchange=parent.getCustomerName() ");
		
		//����HTMLDataWindow
		dwTemp.genHTMLObjectWindow(itemNo);
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ��
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��
	String sButtons[][] = {
		{"true","","Button","����","���������޸�","saveRecord()","","","",""},
		{"true","","Button","����","�����б�ҳ��","goBack()","","","",""}
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
<%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents){
		beforeInsert();
		if(bIsInsert){
			//��������,���Ϊ��������,�����ҳ��ˢ��һ��,��ֹ�������޸�
			beforeUpdate();
			as_save("myiframe0","pageReload()");
			return;
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}

	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack(){
	OpenPage("/CustomerManage/SpecialCustomerManage/ SpecialCustomerCodeList.jsp","_self","");
	}	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	/*~[Describe=��������ҳ��ˢ�¶���;InputParam=��;OutPutParam=��;]~*/
	function pageReload(){
		var itemNo = getItemValue(0,getRow(),"ItemNo");//--���»����ˮ��
		OpenPage("/CustomerManage/SpecialCustomerManage/SpecialCustomerCodeInfo.jsp?ItemNo="+itemNo+"", "_self","");
	}
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UPDATETIME","<%=StringFunction.getToday()%>");
	}
	
	function beforeInsert(){
		var listTemplet = getItemValue(0,getRow(),"ATTRIBUTE1");
		var infoTemplet = getItemValue(0,getRow(),"ATTRIBUTE2");
		var importTemplet = getItemValue(0,getRow(),"ATTRIBUTE3");
		var specialCustomerType = getItemValue(0,getRow(),"ItemNo");
		var paraString = "SpecialCustomerType="+specialCustomerType+"&DoListTemplet="+listTemplet+
		"&DoInfoTemplet="+infoTemplet+"&ImportTemplet="+importTemplet;
		var url = "/CustomerManage/SpecialCustomerManage/SpecialCustomerList.jsp";
		setItemValue(0,0,"ITEMDESCRIBE",url+"@@"+paraString);
	}
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow(){
		if (getRowCount(0)==0){
			bIsInsert = true;
			setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTORG","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"INPUTTIME","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"INPUTUSERNAME","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"INPUTORGNAME","<%=CurUser.getOrgName()%>");
		}
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	initRow();
</script>	
<%/*~END~*/%>


<%@ include file="/Frame/resources/include/include_end.jspf"%>
