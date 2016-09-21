<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String customerID = CurPage.getAttribute("CustomerID");
	String DoFlag = CurPage.getAttribute("DoFlag");
	if(DoFlag==null) DoFlag="";
	ASObjectModel doTemp = new ASObjectModel("ALCustomerTelList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.setParameter("CustomerID", customerID);
	dwTemp.genHTMLObjectWindow(customerID);

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"check".equals(DoFlag)?"false":"true","","Button","新增","新增","add()","","","","",""},
			{"check".equals(DoFlag)?"false":"true","","Button","修改","修改","edit()","","","","",""},
			{"check".equals(DoFlag)?"false":"true","","Button","删除","删除","del()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		AsControl.PopView("/CreditManage/Collection/ALCustomerTelInfo.jsp","","dialogWidth:600px;dialogHeight:400px;");
		reloadSelf();
	}
	function edit(){
		 var serialNo = getItemValue(0,getRow(0),'SerialNo');
		 if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert("参数不能为空！");
			return ;
		 }
		 AsControl.PopView("/CreditManage/Collection/ALCustomerTelInfo.jsp","SerialNo="+serialNo,"dialogWidth:600px;dialogHeight:400px;");
		 reloadSelf();
	}
	function del(){
		 var serialNo = getItemValue(0,getRow(0),'SerialNo');
		 if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert("参数不能为空！");
			return ;
		 }
		 if(!confirm("确认删除联系人信息吗?")) return;
		 as_delete(0);
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
