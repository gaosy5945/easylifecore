<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String estateNo = CurPage.getParameter("EstateNo");
	if(estateNo == null) estateNo = "";

	ASObjectModel doTemp = new ASObjectModel("BuildingDetailList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	//dwTemp.ReadOnly = "1";	 //编辑模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(estateNo);
	String sButtons[][] = {
			{"true","","Button","新增","新增","add()","","","","btn_icon_add",""},
			{"false","","Button","详情","详情","edit()","","","","btn_icon_detail",""},
			{"true","","Button","删除","删除","if(confirm('确实要删除吗?'))as_delete(0,'mySelectRow()')","","","","btn_icon_delete",""},
		};
%> 
<script type="text/javascript">
<%/*~[Describe=新增记录;]~*/%>	
	function add(){
		OpenPage("/CustomerManage/PartnerManage/BuildingDetailInfo.jsp?","rightdown","");
	}
	
	<%/*~[Describe=单击打开记录;]~*/%>	
	function mySelectRow(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			OpenPage("/Blank.jsp","rightdown","");//如果没有记录的情况 打开空白页面
		}else{
			OpenPage("/CustomerManage/PartnerManage/BuildingDetailInfo.jsp?"+"PSerialNo=" + serialNo +"&EstateNo=<%=estateNo%>","rightdown");
		}
	}
	
	<%/*~[Describe=编辑记录;]~*/%>	
	function edit(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			alert(getHtmlMessage('1'));
			return;
		}else{
			AsControl.OpenView("/CustomerManage/PartnerManage/BuildingDetailInfo.jsp","PSerialNo=" + serialNo +",EstateNo=<%=estateNo%>","rightdown","");
		}
	}
	AsControl.OpenView("/Blank.jsp","TextToShow=请先选择相应的信息!","rightdown","");	
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
