<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	/*
		Content:    ����ģ����Ϣ����
	 */
	String PG_TITLE = "����ģ����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	
	//����������	FlowNo�����̱��
	String sFlowNo =  CurComp.getParameter("FlowNo"));
	String sFlowVersion =  CurComp.getParameter("FlowVersion"));
	String sFlag =  CurComp.getParameter("Flag"));
	if(sFlowNo==null) sFlowNo="";
	if(sFlowVersion==null) sFlowVersion="";
	if(sFlag==null) sFlag = "N";
   	
   	String sTempletNo = "FlowCatalogInfo";
   	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	
   	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sFlowNo+","+sFlowVersion);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","����","�����޸�","saveRecord()","","","",""},
		{("Y".equals(sFlag) ? "false" : "true"),"","Button","����","�����б�ҳ��","goBack()","","","",""}
	};
%>
<%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	
	function saveRecord(){
       as_save("myiframe0","");
       reloadself();
	}
    
	function saveRecordAndAdd(){
       var sAAEnabled = getItemValue(0,getRow(),"AAEnabled");
		if(sAAEnabled == "1"){ //�Ƿ������Ȩ����
			sAAPolicyName = getItemValue(0,getRow(),"AAPolicyName");
			if (typeof(sAAPolicyName)=="undefined" || sAAPolicyName.length==0){
				alert("��ѡ����Ȩ������"); 
				return;
			}
		}else{
			//������д����Ȩ������Ϊ���ַ���
			setItemValue(0,0,"AAPolicy","");
			setItemValue(0,0,"AAPolicyName",""); 
		}
       as_save("myiframe0","newRecord()");        
	}
	
	function newRecord(){
        OpenComp("FlowCatalogInfo","/Common/Configurator/FlowManage/FlowCatalogInfo.jsp","","_self","");
	}

	function goBack(){
		AsControl.OpenView("/Common/Configurator/FlowManage/FlowCatalogList.jsp","","_self");
	}
	
	/*~[Describe=������Ȩ����ѡ�񴰿�;InputParam=��;OutPutParam=��;]~*/
	function getPolicyID(){
		var sParaString = "Today"+",<%=StringFunction.getToday()%>";
		setObjectValue("SelectPolicy",sParaString,"@AAPolicy@0@AAPolicyName@1",0,0,"");
	}
	
	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"InputDate","<%=com.amarsoft.app.base.util.DateHelper.getToday()%>");
			bIsInsert = true;
		}
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%@ include file="/Frame/resources/include/include_end.jspf"%>