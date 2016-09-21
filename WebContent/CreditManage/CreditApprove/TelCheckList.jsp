<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	
	String objectNo = CurPage.getParameter("ObjectNo");
	String objectType = CurPage.getParameter("ObjectType");
	
	ASObjectModel doTemp = new ASObjectModel("TelCheckList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "0";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.setParameter("ObjectNo", objectNo);
	dwTemp.setParameter("ObjectType", objectType);
	dwTemp.genHTMLObjectWindow(objectType+","+objectNo);

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","新增","新增","add()","","","","btn_icon_add",""},
			{"true","All","Button","保存","保存","saveRecord()","","","","btn_icon_detail",""},
			{"true","All","Button","删除","删除","del()","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		as_add("myiframe0");
	 	var serialNo = getSerialNo("FLOW_CHECKLIST","SerialNo");// 获取流水号
		setItemValue(0,getRow(),"SerialNo",serialNo);
		setItemValue(0,getRow(),"ObjectNo","<%=objectNo%>");
		setItemValue(0,getRow(),"ObjectType","<%=objectType%>");
		setItemValue(0,getRow(),"CheckItem","0020");
		setItemValue(0,getRow(),"Status","1");
		setItemValue(0,getRow(),"InputUserID","<%=CurUser.getUserID()%>");
		setItemValue(0,getRow(),"InputOrgID","<%=CurUser.getOrgID()%>");
		setItemValue(0,getRow(),"InputTime","<%=com.amarsoft.app.base.util.DateHelper.getBusinessDate()%>");
	}
	function saveRecord(){		
		for(var i = 0 ; i < getRowCount(0) ; i ++){	
			setItemValue(0,i,"UpdateTime","<%=com.amarsoft.app.base.util.DateHelper.getBusinessTime()%>");
			var remark =getItemValue(0, i, "REMARK");
			if (remark.indexOf("\\")>-1){
				alert("录入信息包含特殊字符，请检查！");
				return;
			}
		}
		as_save("myiframe0");
	}
	function del(){
		if(confirm('确实要删除吗?')){
			as_delete(0);
		}
    }
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
