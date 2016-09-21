<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String authorizeType = CurPage.getParameter("AuthorizeType");
	if(authorizeType == null || authorizeType == "undefined") authorizeType = "01";
	String orgID = CurUser.getOrgID();
	ASObjectModel doTemp = new ASObjectModel("MarketActivityList");
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(7);
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","新增","新增","add()","","","","",""},
			{"false","","Button","详情","详情","edit()","","","","",""},
			{"true","All","Button","删除","删除","deleteRecord()","","","","",""},
			{"false","All","Button","复制","复制","copySceneGroup()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		//alert("s");
		 AsControl.OpenView("/ProjectManage/BuildingManage/MarketActivityInfo.jsp","SerialNo="+"","rightdown","");
		 //reloadSelf();
	}
	function deleteRecord(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		as_delete('myiframe0');
		reloadSelf();
	}
	/*记录被选中时触发事件*/
	function mySelectRow(){
		var serialNo = getItemValue(0,getRow(),"SERIALNO");//getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0) {
			return;
		}else{
			AsControl.OpenView("/ProjectManage/BuildingManage/MarketActivityInfo.jsp","SerialNo="+serialNo,"rightdown","");
		}
	}
	mySelectRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
