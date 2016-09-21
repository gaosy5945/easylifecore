<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String prjSerialNo = CurPage.getParameter("SerialNo");
	if(prjSerialNo == null) prjSerialNo = "";

	ASObjectModel doTemp = new ASObjectModel("ProjectGMGCList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.setParameter("ProjectSerialNo", prjSerialNo);
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","","Button","详情","详情","viewAndEdit()","","","","btn_icon_detail",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	<%/*记录被选中时触发事件*/%>
	function mySelectRow(){
		var ObjectType = getItemValue(0,getRow(),"ObjectType");
		var clSerialNo = getItemValue(0,getRow(),"SerialNo");
		var divideType = getItemValue(0,getRow(),"divideType");
		if(!ObjectType) return;
		parent.OpenInfo(ObjectType,divideType,clSerialNo);
	}
	function viewAndEdit(){
		var prjSerialNo = "<%=prjSerialNo%>";
		var CLType = getItemValue(0,getRow(),"PROJECTCREDITTYPE");
		var templetNo = "";
		if(CLType == "规模额度"){
			templetNo="GMCLView";
		}else if(CLType == "担保额度"){
			templetNo="DBCLView";
		}
		if(templetNo == ""){
			alert("请选择一条额度信息！");
			return;
		}
		AsControl.PopView("/ProjectManage/ProjectNewApply/GMCLView.jsp", "templetNo="+templetNo+"&ProjectSerialNo="+prjSerialNo, "resizable=yes;dialogWidth=500px;dialogHeight=300px;center:yes;status:no;statusbar:no");
	}
	$(document).ready(function(){
		mySelectRow();
	});
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
