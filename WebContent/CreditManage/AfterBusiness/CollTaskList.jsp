<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String objectType = DataConvert.toString(CurPage.getParameter("ObjectType"));
	String objectNo = DataConvert.toString(CurPage.getParameter("ObjectNo"));
	ASObjectModel doTemp = new ASObjectModel("CollTaskList");
	doTemp.setJboWhere("CT.SERIALNO=O.TASKSERIALNO AND CT.OBJECTTYPE=:OBJECTTYPE and CT.OBJECTNO=:OBJECTNO ");

	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setParameter("ObjectType",objectType);
	dwTemp.setParameter("ObjectNo",objectNo);

	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(objectType+","+objectNo);

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
