<%@page import="com.amarsoft.app.base.util.SystemHelper"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String objectNo = CurPage.getParameter("ObjectNo");
	String objectType = CurPage.getParameter("ObjectType");
	
    if(objectNo == null) objectNo = "";
    if(objectType == null) objectType = "";
	
    ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List("PutoutConditionList", SystemHelper.getPageComponentParameters(CurPage), CurPage, request);
	ASDataObject doTemp=dwTemp.getDataObject();
	doTemp.setDDDWJbo("STATUS","jbo.sys.CODE_LIBRARY,itemNo,ItemName,Codeno='BPMCheckItemStatus'  and ItemNo like '2%' and IsInuse='1' ");
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "0";	 //ֻ��ģʽ
	dwTemp.setPageSize(3);
	dwTemp.genHTMLObjectWindow(objectNo+","+objectType);

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","save()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function save(){
		if(getRowCount(0)<=0){
			return;
		}
		as_save("myiframe0","");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
