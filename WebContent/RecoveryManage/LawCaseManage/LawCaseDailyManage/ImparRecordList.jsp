<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	//获得组件参数（案件流水号）	BOOKTYPE='100' 庭审记录
	String sSerialNo = (String)CurComp.getParameter("SerialNo");
	if(sSerialNo == null) sSerialNo = "";

	ASObjectModel doTemp = new ASObjectModel("ImparRecordList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(sSerialNo);

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","新增","新增","add()","","","","btn_icon_add",""},
			{"true","","Button","详情","详情","edit()","","","","btn_icon_detail",""},
			{"true","All","Button","删除","删除","del()","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		var sObjectNo="<%=sSerialNo%>";
		AsControl.OpenPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/ImparRecordInfo.jsp","ObjectNo="+sObjectNo,"right","");    

		 //var sUrl = "";
		// AsControl.OpenPage(sUrl,'_self','');
	}
	function edit(){
		/*  var sUrl = "";
		 var sPara = getItemValue(0,getRow(0),'SerialNo');
		 if(typeof(sPara)=="undefined" || sPara.length==0 ){
			alert("参数不能为空！");
			return ;
		 }
		AsControl.OpenPage(sUrl,'SerialNo=' +sPara ,'_self',''); */
		//获得记录流水号、案件编号
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");	
		var sObjectNo = getItemValue(0,getRow(),"LAWCASESERIALNO");
		
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		AsControl.OpenPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/ImparRecordInfo.jsp","SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo ,"right","");
	
	}
	function del(){
		//if(confirm('确实要删除吗?'))as_delete(0,'alert(getRowCount(0))');
		if(confirm('确实要删除吗?'))as_delete(0);
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
