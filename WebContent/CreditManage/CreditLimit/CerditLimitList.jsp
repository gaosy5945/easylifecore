<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String templateNo = DataConvert.toString(CurPage.getParameter("TemplateNo"));//ģ���
	String codeNo = DataConvert.toString(CurPage.getParameter("CodeNo"));
	ASObjectModel doTemp = new ASObjectModel(templateNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "0";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");

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
		as_add("myiframe0");
		//var itemNo = getSerialNo("CODE_LIBRARY","ItemNo");// ��ȡ��ˮ��
		//var sItemNo = itemNo.substring(3, 8) + itemNo.substring(13, 16);
		//setItemValue(0,getRow(),"ItemNo",sItemNo);
		setItemValue(0,getRow(0),"CodeNo","<%=codeNo%>");
		setItemValue(0,getRow(0),"IsInUse","1");
		setItemValue(0,getRow(0),"InputUser","<%=CurUser.getUserID()%>");
		setItemValue(0,getRow(0),"InputOrg","<%=CurUser.getOrgID()%>");
		setItemValue(0,getRow(0),"InputTime","<%=com.amarsoft.app.als.common.util.DateHelper.getToday()%>");
	}
	function saveRecord(){
		var itemNo = getItemValue(0, getRow(0), "ItemNo");
		setItemValue(0,getRow(0),"SortNo",itemNo);
		setItemValue(0,getRow(0),"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,getRow(0),"UpdateTime","<%=com.amarsoft.app.als.common.util.DateHelper.getToday()%>");
		as_save("myiframe0");
	}
	function del(){
		var codeNo = getItemValue(0,getRow(0),"CodeNo");
		if (typeof(codeNo) == "undefined" || codeNo.length == 0){
		    alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		    return;
		}
		if(confirm('ȷʵҪɾ����?')){
			as_delete(0);
		}
    }
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
