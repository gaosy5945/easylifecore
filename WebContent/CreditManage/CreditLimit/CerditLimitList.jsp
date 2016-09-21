<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String templateNo = DataConvert.toString(CurPage.getParameter("TemplateNo"));//模板号
	String codeNo = DataConvert.toString(CurPage.getParameter("CodeNo"));
	ASObjectModel doTemp = new ASObjectModel(templateNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "0";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");

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
		as_add("myiframe0");
		//var itemNo = getSerialNo("CODE_LIBRARY","ItemNo");// 获取流水号
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
		    alert(getHtmlMessage('1'));//请选择一条信息！
		    return;
		}
		if(confirm('确实要删除吗?')){
			as_delete(0);
		}
    }
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
