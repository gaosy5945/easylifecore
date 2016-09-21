<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%@ page import="com.amarsoft.app.als.assetTransfer.util.AssetProjectCodeConstant"%>

<%
	//接收参数
	String tempNo = DataConvert.toString(CurPage.getParameter("TempNo"));//模板号
	ASObjectModel doTemp = null;
	//doTemp = new ASObjectModel("CLInfoList");
	doTemp = new ASObjectModel(tempNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	//dwTemp.setParameter(name, value)
	dwTemp.Style="1";      	     //设置为Grid风格
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","详情","详情","view()","","","","",""},
		};
%> 

<script type="text/javascript">
function view(){
	var SerialNo = getItemValue(0,getRow(0),"OBJECTNO");
	var RightType = "ReadOnly";
	AsCredit.openFunction("CLViewMainInfo","SerialNo="+SerialNo+"&RightType="+RightType);
}
</script>

<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
