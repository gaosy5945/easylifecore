<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow_Info.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow_List.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow.js"></script>
<%	
	String codeNo = CurPage.getParameter("CodeNo");
	String templateNo = CurPage.getParameter("TemplateNo");//ģ���
	BusinessObject inputParameters= BusinessObject.createBusinessObject();
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List(templateNo,inputParameters,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "0";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("CodeNo", codeNo);
	dwTemp.genHTMLObjectWindow(codeNo);

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","add()","","","","",""},
			{"true","","Button","����","����","saveRecord()","","","","",""},
			{"true","","Button","ɾ��","ɾ��","del()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		ALSObjectWindowFunctions.addRow(0,"","addAfterEvent()");
	}
	function addAfterEvent(){
		var codeNo = "<%=codeNo%>";
		var itemNo = getSerialNo("CODE_LIBRARY","ItemNo");// ��ȡ��ˮ��
		var sItemNo = itemNo.substring(3, 8) + itemNo.substring(13, 16);
		setItemValue(0,getRow(0),"ItemNo",sItemNo);
		setItemValue(0,getRow(0),"SortNo",sItemNo);
		setItemValue(0,getRow(0),"CodeNo",codeNo);
		setItemValue(0,getRow(0),"IsInUse","1");
		setItemValue(0,getRow(0),"InputUser","<%=CurUser.getUserID()%>");
		setItemValue(0,getRow(0),"InputOrg","<%=CurUser.getOrgID()%>");
		setItemValue(0,getRow(0),"InputTime","<%=com.amarsoft.app.base.util.DateHelper.getBusinessDate()%>");
	}
	function saveRecord(){
		setItemValue(0,getRow(),"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,getRow(),"UpdateTime","<%=com.amarsoft.app.base.util.DateHelper.getBusinessDate()%>");
		as_save("myiframe0");
	}
	function del(){
		var itemNo = getItemValue(0,getRow(),"ItemNo");
		var codeno = getItemValue(0, getRow(0), "CodeNo");
		if (typeof(itemNo) == "undefined" || itemNo.length == 0){
		    alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		    return;
		}
		if(confirm('ȷʵҪɾ����?')){
			ALSObjectWindowFunctions.deleteSelectRow(0);
		}
    }
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
