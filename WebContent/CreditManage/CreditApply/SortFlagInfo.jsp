<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%><%
	String PG_TITLE = "��Ʒ�����־λ"; // ��������ڱ��� <title> PG_TITLE </title>
	//��������������Ʒ���
	String sTypeNo = CurComp.getParameter("TypeNo");
	String sObjectNo = CurComp.getParameter("ObjectNo");

	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "SortFlagInfo";
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","ȷ��","���������޸�","saveRecord()","","","",""},
		{"false","","Button","����","�����б�ҳ��","goBack()","","","",""}
	};
%>
<%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<script type="text/javascript">
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(){
		//�ֱ��ȡ�����ֶε�ֵ
		sLiquidity = getItemValue(0,getRow(),"IsLiquidity");
		sFixed = getItemValue(0,getRow(),"IsFixed");
		sProject = getItemValue(0,getRow(),"IsProject");
		//��־λ��ȡֵ�߼�У��
		sReturn = RunJavaMethod("ProductSort","CheckSortFlag","IsLiquidity="+sLiquidity+",IsFixed="+sFixed+",IsProject="+sProject);
		var sReturn = sReturn.split("@");
		if(sReturn[0]=="FALSE"){
			alert(sReturn[1]);
			return;
		}
		as_save("myiframe0");
		top.close();
	}
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack(){
		top.close();
	}
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow(){
		if (getRowCount(0) == 0){
			as_add("myiframe0");//������¼
		}
    }    
	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>