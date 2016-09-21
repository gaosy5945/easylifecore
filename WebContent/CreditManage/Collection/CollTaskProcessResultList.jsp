<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String sTaskBatchNo = CurPage.getParameter("PTISerialNo");
	if(StringX.isEmpty(sTaskBatchNo) || null == sTaskBatchNo ) sTaskBatchNo = "";
	String sCTSerialNo = CurPage.getParameter("CTSerialNo");
	if(StringX.isEmpty(sCTSerialNo) || null == sCTSerialNo) sCTSerialNo = "";
	ASObjectModel doTemp = new ASObjectModel("CollTaskProcessResultList");
	String sWhereSql = " and 1=2 ";
	if(sCTSerialNo != "" && sTaskBatchNo != ""){
		sWhereSql = " and O.TASKSERIALNO = '" + sCTSerialNo + "' and CT.TASKBATCHNO ='"+sTaskBatchNo+"'";
	}
	doTemp.setJboWhere(doTemp.getJboWhere() + sWhereSql);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","催收结果登记","催收结果登记","add()","","","","btn_icon_add",""},
			{"true","","Button","催收结果详情","催收结果详情","edit()","","","","btn_icon_detail",""},
			//{"true","","Button","删除","删除","if(confirm('确实要删除吗?'))as_delete(0,'alert(getRowCount(0))')","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		 var sUrl = "";
		 AsControl.OpenPage(sUrl,'_self','');
	}
	function edit(){
		var sResUrl = "/CreditManage/Collection/OutCollRegistrateInfo.jsp";
		var sPTISerialNo = "<%=sTaskBatchNo%>";
		var sCTSerialNo = "<%=sCTSerialNo%>";
		var sCTPSerialNo = getItemValue(0,getRow(0),'SERIALNO');
		//判断流水号是否为空
		if (typeof(sPTISerialNo)=="undefined" || sPTISerialNo.length==0 || typeof(sPTISerialNo)=="undefined" || sPTISerialNo.length==0 || typeof(sCTPSerialNo)=="undefined" || sCTPSerialNo.length==0){
			alert('请选择一条记录');
			return;
		}
		AsControl.PopComp(sResUrl,'PTISerialNo=' +sPTISerialNo+'&CTSerialNo=' +sCTSerialNo+'&CTPSerialNo=' +sCTPSerialNo+'&RightType=ReadOnly','');
		reloadSelf();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
