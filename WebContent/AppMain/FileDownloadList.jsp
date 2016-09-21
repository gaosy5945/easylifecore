<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("FileDownloadList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(15);
	dwTemp.setParameter("StartUserID", CurUser.getUserID());
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","","Button","下载","下载","downLoad()","","","","btn_icon_add",""},
			{"true","","Button","删除","删除","deleterow()","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function downLoad(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(serialNo)=="undefined" || serialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		var url = getItemValue(0,getRow(),"ActionParam");
		
		
		popComp("DownFile","/CreditManage/HouseFund/DownFile.jsp","FileName="+url.substring(url.lastIndexOf("/")+1)+"&FileUrl="+url.substring(0,url.lastIndexOf("/")));
	}
	function deleterow(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(serialNo)=="undefined" || serialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		if(!confirm('确实要删除吗?')) return;
		as_delete(0);
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
