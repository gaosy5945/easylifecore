<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%><%
	String PG_TITLE = "��Ȩ������Ϣ����"; // ��������ڱ��� <title> PG_TITLE </title>
	
	//���ҳ��������������͡������š�������Ϣ��š���Ѻ���š���������
	String sDimensionID = CurPage.getParameter("DimensionID");
	//����ֵת��Ϊ���ַ���
	if(sDimensionID == null) sDimensionID = "";
		
	//ͨ����ʾģ�����ASDataObject����doTemp
	ASObjectModel doTemp = new ASObjectModel("AuthorDimensionInfo");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
		
	//����setEvent
	dwTemp.setEvent("AfterInsert", "!PublicMethod.AuthorObjectManage('update','dimension',#DIMENSIONID)");
	dwTemp.setEvent("AfterUpdate", "!PublicMethod.AuthorObjectManage('update','dimension',#DIMENSIONID)");

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sDimensionID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","���������޸�","saveRecord()","","","",""},
	};
%><%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<script language=javascript>
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents){
		//¼��������Ч�Լ��
		if(bIsInsert){		
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0","parent.reloadSelf();");	
	}
	
	function selectImpl(colId){
		var sStyle = "dialogWidth:680px;dialogHeight:540px;resizable:yes;scrollbars:no;status:no;help:no";
		var sReturn = PopPage("/Common/Configurator/Authorization/TreeNodeSelector.jsp?SelName=Impl&ParaString=","",sStyle);
		if(typeof(sReturn)=="undefined" || sReturn.length==0 || sReturn=="_CANCEL_"){
			return ;		//do nothing
		}
		if(sReturn=="_CLEAR_"){
			setItemValue(0,0,colId,"");
			return;
		}
		var selectedValue = sReturn.split("@");
		if(typeof(selectedValue[0])!="undefined" && selectedValue[0].length > 0){		//û������ѡ��
			setItemValue(0,0,colId,selectedValue[0]);
		}
	}

	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert(){
		initSerialNo();//��ʼ����ˮ���ֶ�
		bIsInsert = false;
	}
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate(){
	}
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow(){
		if (getRowCount(0) == 0){
			as_add("myiframe0");//������¼
			setItemValue(0,0,"INPUTDATE","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
			bIsInsert = true;			
		}
    }

	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo(){
		var sTableName = "SADRE_DIMENSION";//����
		var sColumnName = "DIMENSIONID";//�ֶ���
		var sPrefix = "D";//ǰ׺

		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		//var sDimensionID = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","");
		var sDimensionID = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),"DIMENSIONID",sDimensionID);				
	}
	
	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>