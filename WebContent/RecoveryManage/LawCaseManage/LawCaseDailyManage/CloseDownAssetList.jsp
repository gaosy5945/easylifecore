<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
out.println("<b><font size='3'>- 查封资产列表</font></b>");
	//定义变量
	//获得组件参数（案件流水号、台帐类型）	
	String sSerialNo = (String)CurComp.getParameter("SerialNo");
	String sBookType = (String)CurComp.getParameter("BookType");
	//将空值转化为空字符串
	if(sBookType == null) sBookType = "";
	if(sSerialNo == null) sSerialNo = "";

	ASObjectModel doTemp = new ASObjectModel("CloseDownAssetList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(sSerialNo);

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","新增","新增","add()","","","","btn_icon_add",""},
			{"true","","Button","详情","详情","edit()","","","","btn_icon_detail",""},
			{"true","All","Button","删除","删除","deleteRecord()","","","","btn_icon_delete",""},
			{"true","All","Button","退出查封","退出查封","outEdit()","","","","btn_icon_detail",""},	
	};
	
	
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		var sUrl = "/RecoveryManage/LawCaseManage/LawCaseDailyManage/CloseDownAssetInfo.jsp";
		AsControl.PopComp(sUrl,"LAWCASESERIALNO=<%=sSerialNo%>","");
		reloadSelf();
	}
	function edit(){
		 var sUrl = "/RecoveryManage/LawCaseManage/LawCaseDailyManage/CloseDownAssetInfo.jsp";
		 var sPara = getItemValue(0,getRow(0),'SerialNo');
		 if(typeof(sPara)=="undefined" || sPara.length==0 ){
			alert("参数不能为空！");
			return ;
		 }
		AsControl.PopComp(sUrl,'SerialNo=' +sPara ,'');
		reloadSelf();
	}
	function outEdit(){
		var sUrl = "/RecoveryManage/LawCaseManage/LawCaseDailyManage/OutCloseDownAssetInfo.jsp";
		 var sPara = getItemValue(0,getRow(0),'SerialNo');
		 if(typeof(sPara)=="undefined" || sPara.length==0 ){
			alert("参数不能为空！");
			return ;
		 }
		AsControl.PopComp(sUrl,'SerialNo=' +sPara ,'');
		reloadSelf();		
		AsControl.OpenView("/RecoveryManage/LawCaseManage/LawCaseDailyManage/OutCloseDownAssetList.jsp","SerialNo=<%=sSerialNo%>&BookType=<%=sBookType%>","rightdown","");
	}
	
	function deleteRecord(){
		if(confirm('确实要删除吗?'))as_delete(0);//,'alert(getRowCount(0))'
	}
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "LAWCASE_BOOK";//表名
		var sColumnName = "SERIALNO";//字段名
		var sPrefix = "";//前缀
		//var sSerialNo = PopPageAjax("/Frame/page/sys/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
