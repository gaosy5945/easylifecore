<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String CustomerID = CurPage.getParameter("CustomerID");
	if(CustomerID == null) CustomerID = "";

	ASObjectModel doTemp = new ASObjectModel("ProjectMerge");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	//dwTemp.MultiSelect = true; //允许多选
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.setParameter("CustomerID", CustomerID);
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
		};
	sASWizardHtml = "<p><font color='red' size='2'>【可合并项目列表】</font></p>" ; 
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">

	function mySelectRow(){
		var prjSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(!prjSerialNo) return;
		parent.OpenInfo(prjSerialNo);
	}
	
		mySelectRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
