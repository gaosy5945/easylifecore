<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("SignContractListY");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow(CurUser.getUserID());

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","","Button","任务详情","任务详情","task()","","","","btn_icon_detail",""}
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function task(){
		var objectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(objectNo)=="undefined" || objectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		AsCredit.openFunction("ContractSignTask_Y", param, "");
		reloadSelf();
	}
	//dwTemp.setEvent("AfterDelete","!BusinessManage.DeleteBusiness(BusinessContract,#SerialNo,DeleteBusiness)+!BusinessManage.UpdateBusiness(BusinessContract,#RelativeserialNo,UpdateBusiness)"); 
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>