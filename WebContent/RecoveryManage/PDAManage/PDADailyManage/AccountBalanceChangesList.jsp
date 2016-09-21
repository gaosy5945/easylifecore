<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String sDASerialNo = CurPage.getParameter("SerialNo");
	if(sDASerialNo == null) sDASerialNo = "";
out.println("科目余额变动台账（**该数据请与会计部门科目余额保持一致**）");
	ASObjectModel doTemp = new ASObjectModel("AccountBalanceChangesList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(sDASerialNo);

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","新增","新增","add()","","","","btn_icon_add",""},
			{"true","","Button","详情","详情","edit()","","","","btn_icon_detail",""},
			{"false","","Button","删除","删除","if(confirm('确实要删除吗?'))as_delete(0,'alert(getRowCount(0))')","","","","btn_icon_delete",""},
		};
	
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		var sDASerialNo = "<%=sDASerialNo%>";
		var sSql = "select count(1) as cnt from lawcase_book where LAWCASESERIALNO='"+sDASerialNo+"'   and BOOKTYPE='310'";
		var sReturnValue =  RunMethod("PublicMethod","RunSql",sSql);
		if(sReturnValue<1){
			 var sUrl = "/RecoveryManage/PDAManage/PDADailyManage/AccountBalanceChangesInfo.jsp";
			 var sSerialNo = getSerialNo("LAWCASE_BOOK","SerialNo","");
			 var sBookType = "310";
			 AsControl.PopComp(sUrl,"DASerialNo=<%=sDASerialNo%>&SerialNo="+sSerialNo+"&BookType"+sBookType,"","");
		}else{
			alert("该台账仅支持新增一条记录");
		}	
		reloadSelf();
		
	}
	function edit(){
		 var sUrl = "/RecoveryManage/PDAManage/PDADailyManage/AccountBalanceChangesInfo.jsp";
		 var sPara = getItemValue(0,getRow(0),'SerialNo');
		 if(typeof(sPara)=="undefined" || sPara.length==0 ){
			alert("参数不能为空！");
			return ;
		 }
		AsControl.PopComp(sUrl,"DASerialNo=<%=sDASerialNo%>&SerialNo=" +sPara ,"","");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
