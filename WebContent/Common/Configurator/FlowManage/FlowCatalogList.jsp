<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%
	/*
		Content: ����ģ���б�
	 */
	String PG_TITLE = "����ģ���б�"; // ��������ڱ��� <title> PG_TITLE </title>
	 
	String sTempletNo = "FlowCatalogList";
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);

	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(200);

	//��������¼�
// 	dwTemp.setEvent("BeforeDelete","!Configurator.DelFlowModel(#FlowNo,#FlowVersion)");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","����","����һ����¼","newRecord()","","","",""},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()","","","",""},
		{"true","","Button","����ģ���б�","�鿴/�޸�����ģ���б�","viewAndEdit2()","","","",""},
		{"true","","Button","���̲����б�","�鿴/�޸����̲����б�","viewAndEdit3()","","","",""},
		{"true","","Button","��ΪĬ��","��ΪĬ��","setDefault()","","","",""},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()","","","",""},
	};
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function newRecord(){
		AsControl.OpenView("/Common/Configurator/FlowManage/FlowCatalogInfo.jsp","Flag=N","_self","");
	}
	
    /*~[Describe=�鿴���޸�����;]~*/
	function viewAndEdit(){
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sFlowVersion = getItemValue(0,getRow(),"FlowVersion");
		if(typeof(sFlowNo)=="undefined" || sFlowNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
       popComp("FlowCatalogInfo","/Common/Configurator/FlowManage/FlowCatalogInfo.jsp","FlowNo="+sFlowNo+"&FlowVersion="+sFlowVersion+"&Flag=Y&ItemID=0010","");
	}
    
    /*~[Describe=�鿴/�޸�����ģ���б�;]~*/
	function viewAndEdit2(){
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sFlowVersion = getItemValue(0,getRow(),"FlowVersion");
		if(typeof(sFlowNo)=="undefined" || sFlowNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
       popComp("FlowModelList","/Common/Configurator/FlowManage/FlowModelList.jsp","FlowNo="+sFlowNo+"&FlowVersion="+sFlowVersion+"&ItemID=0020","");  
	}
    
	/*~[Describe=��ΪĬ��;]~*/
	function setDefault(){
		var flowNo = getItemValue(0,getRow(),"FlowNo");
		var flowVersion = getItemValue(0,getRow(),"FlowVersion");
		if(typeof(flowNo)=="undefined" || flowNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		var i = AsControl.RunASMethod("WorkFlowEngine","setDefault",flowNo+","+flowVersion);
		if(parseInt(i) > 0)
		{
			alert("���óɹ���");
		}
		else
			alert("����ʧ�ܣ�");
	}
	
	/*~[Describe=�鿴/�޸����̲����б�;]~*/
	function viewAndEdit3(){
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sFlowVersion = getItemValue(0,getRow(),"FlowVersion");
		if(typeof(sFlowNo)=="undefined" || sFlowNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
       popComp("�鿴/�޸����̲����б�","/Common/Configurator/FlowManage/FlowParameterList.jsp","FlowNo="+sFlowNo+"&FlowVersion="+sFlowVersion+"&PhaseNo=init0010","");  
	}

	/*~[Describe=ɾ����¼;]~*/
	function deleteRecord(){
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sFlowVersion = getItemValue(0,getRow(),"FlowVersion");
		if(typeof(sFlowNo)=="undefined" || sFlowNo.length==0 || typeof(sFlowVersion)=="undefined" || sFlowVersion.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		
		if(confirm(getHtmlMessage('49'))){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	AsOne.AsInit();
	init();
	var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/Frame/resources/include/include_end.jspf"%>