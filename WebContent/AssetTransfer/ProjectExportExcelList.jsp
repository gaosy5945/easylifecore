<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	//参数
	String sPRISerialNoList = CurPage.getParameter("PRISerialNoList");
	if(StringX.isEmpty(sPRISerialNoList) || null == sPRISerialNoList || "null" == sPRISerialNoList) sPRISerialNoList = "";
	ASObjectModel doTemp = new ASObjectModel("ProjectAssetList");
	if(!StringX.isEmpty(sPRISerialNoList)){
		sPRISerialNoList = sPRISerialNoList.replace(",","','");
	}
	doTemp.appendJboWhere(" and O.SERIALNO in('"+sPRISerialNoList+"') ");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","","Button","导出","导出","exportRecord()","","","","btn_icon_add",""},
			{"true","","Button","取消","取消","cancle()","","","","btn_icon_detail",""},
		};
	//sButtonPosition = "south"; 
%>

<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	
	function exportRecord(){
		if(confirm("是否导出资产信息！")){
			exportPage('<%=sWebRootPath%>',0,'excel','0'); 
		}
	}
	function cancle(){
		//返回上个界面
		self.close();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
