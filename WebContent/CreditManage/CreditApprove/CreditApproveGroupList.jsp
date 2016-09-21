<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
    String taskSerialNo = CurPage.getParameter("TaskSerialNo");
    String objectNo = CurPage.getParameter("ObjectNo");
    if(objectNo == null) objectNo = "";
    if(taskSerialNo == null) taskSerialNo = "";
	ASObjectModel doTemp = new ASObjectModel("CreditApproveGroupList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	//dwTemp.MultiSelect = true;	 //多选/**修改模板时请不要修改这一行*/
	//dwTemp.ShowSummary="1";	 	 //汇总/**修改模板时请不要修改这一行*/
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.setParameter("APPLYSERIALNO", objectNo);
	dwTemp.setParameter("TaskSerialNo", taskSerialNo);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","新增","新增","add()","","","","btn_icon_add",""},
			{"true","","Button","详情","详情","edit()","","","","btn_icon_detail",""}
	};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
    function add(){
	     AsControl.OpenPage("/CreditManage/CreditApprove/CreditApproveGroupInfo.jsp","",'_self','');
         }
    
	function edit(){
		 var SerialNo = getItemValue(0,getRow(0),'SerialNo');
		 if(typeof(SerialNo)=="undefined" || SerialNo.length==0 ){
			alert("请选择一条信息！");
			return ;
		 }
		AsControl.OpenPage("/CreditManage/CreditApprove/CreditApproveGroupInfo.jsp",'SerialNo=' +SerialNo ,'_self','');
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
