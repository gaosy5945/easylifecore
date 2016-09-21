<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	

	ASObjectModel doTemp = new ASObjectModel("CustomerListRelative");
	doTemp.getCustomProperties().setProperty("JboWhereWhenNoFilter"," and 1=2 ");
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.MultiSelect = true; //允许多选
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","失效","失效","LoseEfficacy()","","","","",""},
			{"true","All","Button","白名单简表下载","白名单简表下载","downLoad()","","","","",""},
			{"true","All","Button","下载","下载","exportPage('"+sWebRootPath+"',0,'excel','')","","","","",""},
	};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
function LoseEfficacy(){
	var updateSerialNos = '';
	var recordArray = getCheckedRows(0); //获取勾选的行
	if (typeof(recordArray)=="undefined" || recordArray.length==0){
		alert("请至少选择一条记录！");
		return;
	}
	for(var i = 1;i <= recordArray.length;i++){ //通过循环获取serialNo
		var SerialNo = getItemValue(0,recordArray[i-1],"SERIALNO");
		updateSerialNos += SerialNo+"@";
	}
	if(confirm('确定要将所选白名单置为失效吗？')){
		var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.activeCredit.customerBase.LoseEfficacy", "lose", "updateSerialNos="+updateSerialNos+",updateDate="+"<%=DateHelper.getBusinessDate()%>");
		if(sReturn == "SUCCEED"){
			alert("操作成功！");
			reloadSelf();
		}else{
			alert("操作失败！");
			reloadSelf();
		}

	}
}
function downLoad(){
	AsControl.PopPage("/ActiveCreditManage/CustomerAppoveManage/CustomerListRelativeListJB.jsp","","resizable=yes;dialogWidth=1000px;dialogHeight=500px;center:yes;status:no;statusbar:no");
}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
