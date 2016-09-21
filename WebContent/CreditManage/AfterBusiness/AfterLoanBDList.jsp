<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String customerID = DataConvert.toString(CurPage.getParameter("CustomerID"));
    String ObjectNo = DataConvert.toString(CurPage.getParameter("ObjectNo"));//项目编号
    if(ObjectNo==null) ObjectNo="";
	ASObjectModel doTemp = new ASObjectModel("AfterLoanBDList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.setParameter("ProjectSerialNo", ObjectNo);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			//{"true","","Button","详情","详情","edit()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function edit(){
		 var duebillSerialNo = getItemValue(0,getRow(0),'SerialNo');
		 if(typeof(duebillSerialNo)=="undefined" || duebillSerialNo.length==0 ){
			alert("参数不能为空！");
			return ;
		 }
		AsControl.PopView("/CreditManage/AfterBusiness/DuebillInfo.jsp",'DuebillSerialNo=' +duebillSerialNo ,'','');
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
