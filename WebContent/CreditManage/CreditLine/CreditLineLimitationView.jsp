<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "授信额度限制条件"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;授信额度限制条件&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	
	//获得组件参数	
	String sSubLineID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SubLineID"));
	if(sSubLineID == null) sSubLineID = "";

	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"授信额度限制条件详情","right");
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件
	
	int iOrder = 1;	
	String sFolder = tviTemp.insertFolder("root","限制条件","",iOrder++);	
	String sSql = " select CLS.LimitationSetID,CLS.LimitationType,CLT.TypeName,CLS.ObjectType "+
				  " from CL_LIMITATION_SET CLS,CL_LIMITATION_TYPE CLT "+
				  " where CLS.LimitationType = CLT.TypeID "+
				  " and CLS.LineID =:CLS.LineID ";
	String[][] sLimitationSets = Sqlca.getStringMatrix(new SqlObject(sSql).setParameter("CLS.LineID",sSubLineID));
	for(int i=0;i<sLimitationSets.length;i++){
		tviTemp.insertPage(sFolder,sLimitationSets[i][2],sLimitationSets[i][0],"javascript:parent.openLimitationSet('"+sLimitationSets[i][0]+"')",iOrder++);
	}

	tviTemp.insertPage(sFolder," [添加一组限制条件]","javascript:parent.addLimitationSet()",iOrder++);
%><%@include file="/Resources/CodeParts/View04.jsp"%>
<script type="text/javascript"> 
	//treeview单击选中事件	
	function TreeViewOnClick(){
		setTitle(getCurTVItem().name);
	}
	
	function addLimitationSet(){
		//获取限制条件
		sReturn = setObjectValue("SelectLimitationType","","",0,0,"");
		//判断是否返回有效信息
		if(sReturn == "" || sReturn == "_CANCEL_" || sReturn == "_NONE_" || sReturn == "_CLEAR_" || typeof(sReturn) == "undefined") return;
		sReturn = sReturn.split('@');
		sLimitationType = sReturn[0];
		
		//在数据库中新增一个限制组
		var sLimitationSetID = getSerialNo("CL_LIMITATION_SET","LimitationSetID","");
		var sReturn = RunMethod("CreditLine","NewLimitaionSet","<%=sSubLineID%>,"+sLimitationSetID+","+sLimitationType);
		reloadSelf();
	}
	
	function openLimitationSet(sLimitationSetID){
		
		OpenPage("/CreditManage/CreditLine/LimitationSetInfo.jsp?SubLineID=<%=sSubLineID%>&LimitationSetID="+sLimitationSetID,"right","");
	}
	
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}

	startMenu();
	expandNode('root');
	expandNode('<%=sFolder%>');
</script>
<%@ include file="/IncludeEnd.jsp"%>