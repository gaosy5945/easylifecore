<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("TestCustomerList");
	doTemp.setReadOnly("SERIALNO",true);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "0";//编辑模式
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","","Button","新增","新增","as_add(0)","","","",""},
		{"true","","Button","保存","保存","as_save(0)","","","",""},
		{"true","","Button","删除","删除","if(confirm('确实要删除吗?'))as_delete(0)","","","",""},
		{"true","","Button","setitemvalue","setitemvalue","testv(0)","","","",""},
		{"true","","Button","getitemvalue","getitemvalue","testv2(0)","","","",""},
	};
%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<%@
 include file="/Frame/resources/include/include_end.jspf"%>
<script type="text/javascript">
function testv(){
	setItemValue(0,getRow(),"CustomerName",prompt("高管名称",getItemValue(0,getRow(),"CustomerName")));
}
function testv2(){
	alert(getItemValue(0,getRow(),"CustomerName"));
}
function testColInnerBtEvent(sString, iInt){
	var str = "按钮触发事件";
	str += "\n传入字符串参数："+sString+" ,传入数字参数："+iInt;
	str += "\n获取到行号："+getRow(0);
	alert(str);
}
</script>