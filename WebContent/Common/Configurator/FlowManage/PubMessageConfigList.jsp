<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("PubMessageConfigList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "0";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","新增","新增","add()","","","","btn_icon_add",""},
			{"true","","Button","保存","保存","saveRecord()","","","","btn_icon_detail",""},
			{"true","","Button","删除","删除","if(confirm('确实要删除吗?'))as_delete(0);","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	var bIsInsert = false; // 标记DW是否处于“新增状态”
	function add(){
		as_add("myiframe0");
		bIsInsert=true;
	}
	function saveRecord(){
		if(bIsInsert){
			var checkresult = ChageMessageID();
			if(!checkresult)return;
		}
		as_save("myiframe0","selfRefresh()");
	}
	function ChageMessageID(){
		var messageID = getItemValue(0, getRow(0), "MESSAGEID");
		if(typeof(messageID)=="undefined"||messageID.length==0){
			return;
		}
		var returnValue = AsControl.RunASMethod("WorkFlowEngine","CheckMessageID",messageID);
		if(returnValue.split("@")[0] == "false"){
			alert(returnValue.split("@")[1]);
			return false;
		}
		
		return true;
	}

	function selfRefresh()
	{
		AsControl.OpenPage("/Common/Configurator/FlowManage/PubMessageConfigList.jsp", "", "_self");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
