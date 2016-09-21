<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("AssetForChangeList");

	doTemp.setJboWhereWhenNoFilter(" and 1=2 ");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	dwTemp.setPageSize(10);
	dwTemp.setParameter("OrgID", CurUser.getOrgID());
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","","Button","专户资金一次性转备用金","专户资金一次性转备用金","assetchange()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
function assetchange(){
	var serialNo = getItemValue(0,getRow(),"SERIALNO");
	if(typeof(serialNo)=="undefined" || serialNo.length==0){
		alert("请选择一笔借据信息！");
		return;
	}else{
		AsControl.OpenView("/CreditManage/CreditChange/AssetChangeInfo.jsp","SerialNo="+serialNo,"_blank");
	}
}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>

