<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow_Info.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow_List.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow.js"></script>
<%	
	String codeNo = CurPage.getParameter("CodeNo");
	String templateNo = CurPage.getParameter("TemplateNo");//模板号
	BusinessObject inputParameters= BusinessObject.createBusinessObject();
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List(templateNo,inputParameters,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "0";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.setParameter("CodeNo", codeNo);
	dwTemp.genHTMLObjectWindow(codeNo);

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","新增","新增","add()","","","","",""},
			{"true","","Button","保存","保存","saveRecord()","","","","",""},
			{"true","","Button","删除","删除","del()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		ALSObjectWindowFunctions.addRow(0,"","addAfterEvent()");
	}
	function addAfterEvent(){
		var codeNo = "<%=codeNo%>";
		var itemNo = getSerialNo("CODE_LIBRARY","ItemNo");// 获取流水号
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
		    alert(getHtmlMessage('1'));//请选择一条信息！
		    return;
		}
		if(confirm('确实要删除吗?')){
			ALSObjectWindowFunctions.deleteSelectRow(0);
		}
    }
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
