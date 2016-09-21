<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	

	String sShelvesType = CurPage.getParameter("ShelvesType");
	if(sShelvesType == null) sShelvesType = "";
	String sWhereSql = "";
	ASObjectModel doTemp = new ASObjectModel("Doc2PullOfShelvesList");
	
	if("0010".equals(sShelvesType) || "0010" == sShelvesType){
		sWhereSql = " and O.PACKAGETYPE='02' and O.POSITION is not null";
		doTemp.setJboWhere(doTemp.getJboWhere() + sWhereSql);
	}else 	if("0020".equals(sShelvesType) || "0020" == sShelvesType){
		doTemp.setJboWhere(doTemp.getJboWhere() + " and O.POSITION is null");
	}
		
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			//{"true","All","Button","新增","新增","add()","","","","btn_icon_add",""},
			{"true","","Button","详情","详情","edit()","","","","btn_icon_detail",""},
			{"true","","Button","下架","下架","PullOfShelves()","","","","btn_icon_detail",""},
			{"true","","Button","强制上架","强制上架","EntryOfShelves()","","","","btn_icon_detail",""},
			//{"true","","Button","删除","删除","if(confirm('确实要删除吗?'))as_delete(0,'alert(getRowCount(0))')","","","","btn_icon_delete",""},
		};

	if("0010".equals(sShelvesType) || "0010" == sShelvesType){
		sButtons[2][0] = "false";
	}else 	if("0020".equals(sShelvesType) || "0020" == sShelvesType){
		sButtons[1][0] = "false";
	}
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
	
	function PullOfShelves(){
		if(confirm('确实要下架吗?')) {//将位置置为空
			var sDOObjectType = getItemValue(0,getRow(0),'ObjectType');
			if(sDOObjectType == null) sObjesDOObjectTypectType = "";
			var sObjectNo = getItemValue(0,getRow(0),'ObjectNo');
			if(sObjectNo == null) sObjectNo = "";
			var sDOSerialNo = getItemValue(0,getRow(0),'SerialNo');
			if(sDOSerialNo == null) sDOSerialNo = "";
			var sUserId = "<%=CurUser.getUserID()%>";
			var sOrgId = "<%=CurUser.getOrgID()%>";
			var sDate = "<%=StringFunction.getToday()%>";
			var sOperationType = "";//预归档
			var sRemark = "";
			var sPosition = "";//取消专夹保管  专夹架位
			var sMsg = "";
			var sPara = "OperationType="+sOperationType+"&DOSerialNo="+sDOSerialNo+"&ObjectType="+sDOObjectType+"&ObjectNo="+sObjectNo+"&Position="+sPosition;
			//插入一条操作数据
			var sReturn=PopPageAjax("/DocManage/Doc2Manage/Doc2BPManage/Doc2specialKeepingAjax.jsp?"+sPara+"","","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");//
			if(sReturn || (typeof(sReturn)!="undefined" && sReturn=="true")){
					sMsg = "下架成功";
			} else {
				sMsg = "下架失败";
			}
			alert(sMsg);
		}
		reloadSelf();
	}
	//强制上架
	function EntryOfShelves(){
		if(confirm('确实要强制上架吗?')) {//
			var sSerialNo = getItemValue(0,getRow(0),'SerialNo');
			if(sSerialNo == null) sSerialNo = "";
			var sObjectType = getItemValue(0,getRow(0),'ObjectType');
			if(sObjectType == null) sObjectType = "";
			var sObjectNo = getItemValue(0,getRow(0),'ObjectNo');
			if(sObjectNo == null) sObjectNo = "";
			var sParaValue = "SerialNo="+sSerialNo + "&ObjectType=" + sObjectType + "&ObjectNo=" + sObjectNo + "&sShelvesType=01" ;
			var returnValue = PopPage("/DocManage/Doc2Manage/Doc2BPManage/DocWarehouseAddDialog.jsp?"+sParaValue,"","resizable=yes;dialogWidth=500;dialogHeight=200;center:yes;status:no;statusbar:no");
			returnValue = returnValue.split("@");
			var returnSerialNo = returnValue[1];
			if(returnSerialNo == null || returnSerialNo == "undefine" || returnSerialNo == "null"){
				returnSerialNo = "";
			}
			if(returnValue[0] == "TRUE"){
				alert(returnSerialNo+"强制上架成功！");
			}else {
				alert(returnSerialNo+"强制上架失败！");
			}
		}
		reloadSelf();
	}	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
