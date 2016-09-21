<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";
	
	ASObjectModel doTemp = new ASObjectModel("BuildingList2");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	//dwTemp.ReadOnly = "1";	 //编辑模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(serialNo);
	
	String sButtons[][] = {
			{"true","ALL","Button","引入","引入","importBuilding()","","","","btn_icon_detail",""},
			{"true","ALL","Button","新增","新增","add()","","","","btn_icon_add",""},
			{"true","","Button","详情","详情","edit()","","","","btn_icon_detail",""},
			{"true","ALL","Button","删除","删除","if(confirm('确实要删除吗?'))as_delete(0)","","","","btn_icon_delete",""},
		};
%> 
<script type="text/javascript">

	/*引入楼盘*/
	function importBuilding(){
		var returnValue = setObjectValue("selectAllBuilding","","",0,0);
		if(typeof(returnValue) == "undefined" || returnValue.length == 0){
			return;
		}
		returnValue = returnValue.split("@");
		//alert(returnValue);
		var param = "objectNo=<%=serialNo%>,accessoryNo=" + returnValue[0] +",accessoryType=Building,accessoryName="+returnValue[1];
		returnValue = RunJavaMethodTrans("com.amarsoft.app.als.customer.partner.action.BuildingRelativeAction","initRelative",param);
		if(returnValue == "true"){
			//alert("引入成功");
			reloadSelf();
		}else if(returnValue == "error"){
			alert("引入异常");
		}else if(returnValue == "false"){
			alert("已经有项目引入过此楼盘请确认");
			return;
		}
	}
	
	/*新增*/
	function add(){
		 var sUrl = "/CustomerManage/PartnerManage/BuildingInfo.jsp?ProjectNo=<%=serialNo%>";
		 OpenPage(sUrl,'_self','');
	}
	function edit(){
		var serialNo = getItemValue(0,getRow(0),"SerialNo");
		if(typeof(serialNo) == "undefined" || serialNo.lentgh == 0){
			alert("请选择一条记录");
			return;
		}
		 var sUrl = "/CustomerManage/PartnerManage/BuildingInfo.jsp?ProjectNo=<%=serialNo%>&SerialNo=" + serialNo;
		 OpenPage(sUrl,'_self','');
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
