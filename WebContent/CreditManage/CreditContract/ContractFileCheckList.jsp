<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	/*
	Author:   qzhang  2004/12/04
	Tester:
	Content: ��ͬ��ǩ��Ϣ�б�
	Input Param:	 
	Output param:
	History Log: 
	*/

	//��ȡǰ�˴���Ĳ���
	String sObjectNo =  DataConvert.toString(CurPage.getParameter("ObjectNo"));
	String sObjectType =  DataConvert.toString(CurPage.getParameter("ObjectType"));
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	
	ASObjectModel doTemp = new ASObjectModel("ContractFileCheckList");
	doTemp.setDDDWJbo("STATUS","jbo.sys.CODE_LIBRARY,itemNo,ItemName,Codeno='BPMCheckItemStatus'  and ItemNo like '1%' and IsInuse='1' ");	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "0";	 //ֻ��ģʽ
	dwTemp.setPageSize(3);
	dwTemp.genHTMLObjectWindow(sObjectNo);

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","save()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">

	function save(){
		as_save("myiframe0","");
	}

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
