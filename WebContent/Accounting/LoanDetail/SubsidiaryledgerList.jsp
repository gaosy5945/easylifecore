<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>

	<%
	String PG_TITLE = "������Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	
	String sObjectNo = CurPage.getParameter("ObjectNo");
	String sObjectType = CurPage.getParameter("ObjectType");
	if(sObjectNo==null) sObjectNo = "";
	if(sObjectType==null) sObjectType = "";

	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "SubsidiaryledgerList";

	
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    dwTemp.setPageSize(20);
	
	
	//���ӹ�����	
	
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    dwTemp.setPageSize(20);
    dwTemp.genHTMLObjectWindow(sObjectNo+","+sObjectType);
	//����HTMLDataWindow
	
	String sButtons[][] = {
		};
	%> 


<%@include file="/Frame/resources/include/ui/include_list.jspf"%>


<script type="text/javascript">	
// 	AsOne.AsInit();
// 	init();
// 	my_load(2,0,'myiframe0');
</script>	

<%@ include file="/Frame/resources/include/include_end.jspf"%>
