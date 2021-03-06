<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%-- 页面说明: 客户信息详情->客户授信一览->客户提供所有质押物情况页面--%>
<%	
	String sSerialNo = CurPage.getParameter("serialNo");
	if(sSerialNo == null) sSerialNo = "";
	ASObjectModel doTemp = new ASObjectModel("IndCustomerAllMortgageList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	//dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(sSerialNo);

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			/* {"true","All","Button","新增","新增","add()","","","","btn_icon_add",""},
 */			{"true","","Button","详情","详情","edit()","","","","btn_icon_detail",""},
			/* {"true","","Button","删除","删除","if(confirm('确实要删除吗?'))as_delete(0,'alert(getRowCount(0))')","","","","btn_icon_delete",""},
 */		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		 var sUrl = "";
		 AsControl.OpenPage(sUrl,'_self','');
	}
	function edit(){
		 var sUrl = "";
		 var sPara = getItemValue(0,getRow(0),'SerialNo');
		 if(typeof(sPara)=="undefined" || sPara.length==0 ){
			alert("参数不能为空！");
			return ;
		 }
		AsControl.OpenPage(sUrl,'SerialNo=' +sPara ,'_self','');
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
