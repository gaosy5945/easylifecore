<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%> 
<%@page import="com.amarsoft.app.alarm.*"%>
<%@page import="com.amarsoft.awe.util.ObjectConverts"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%>/AppConfig/AutoRiskDetect/resources/scenario.css">
<%
	//获得组件参数	
	String sScenarioNo = CurPage.getParameter("ScenarioNo");
	String sBizArg = CurPage.getParameter("BizArg");
	String sSubTypeNo = CurPage.getParameter("SubTypeNo");
	ARE.getLog().debug("传入业务参数:"+sBizArg);

	//加载器
	ScenarioContextLoader loader = new DefaultScenarioContextLoader();
	((DefaultScenarioContextLoader)loader).init(Sqlca,sScenarioNo,sBizArg,sSubTypeNo);
	
	ScenarioContext context = loader.getContext();				//获取下文容器
	context.setCheckItemRunner(new DefaultCheckItemRunner());	//模型运行器
	
	String scenarioSerializable = ObjectConverts.getString(context);	//序列化
%>
<body style="overflow:hidden;overflow-y:auto;height:100%">
    <div class="r_main">
    <%
    	List<ItemGroup> gList0 = context.getScenario().getGroupList();
        	List<ItemGroup> gList = new ArrayList<ItemGroup>();
        
        	//根据运行条件进行预处理,分组下检查项检查条件均没通过，则不显示该分组
        	for(int i=0;i<gList0.size();i++){
        		ItemGroup group = gList0.get(i);
        		List<CheckItem> ckList0 = group.getCheckItemList();
        		List<CheckItem> ckList1 = new ArrayList<CheckItem>();	//存放检查通过的
        		for(int j=0;j<ckList0.size();j++){
        			CheckItem ckItem = ckList0.get(j);
    	           	String sCondition = ckItem.getRunCondition();	//运行条件
    	           	if(sCondition!=null&&sCondition.length()>0){
    	           		sCondition=SpecialTools.amarsoft2Real(sCondition);
    	               	boolean bCondition = AmarScriptTool.runAmarScript(Sqlca, sCondition, context.getParameter()).booleanValue();
    	               	if(!bCondition)continue;
    	               	else ckList1.add(ckItem);
    	           	}else{
    	               	ckList1.add(ckItem);
    	           	}
        		}
        		if(ckList1.size()>0){	//重组分组
        			group.getCheckItemList().clear();
        			group.getCheckItemList().addAll(ckList1);
        			gList.add(group);
        		}
        	}
        	//生成界面
        	for(int i=0;i<gList.size();i++){
        		ItemGroup group = gList.get(i);
        		List<CheckItem> ckList = group.getCheckItemList();
    %>
        <div class="r_group" id="Group<%=group.getGroupID()%>" groupID="<%=group.getGroupID()%>" groupName="<%=group.getGroupName()%>">
            <div class="r_info">
                <div style="float:left;"><%=group.getGroupName()%></div>  
                <div class="group_result"></div>
            </div>
            <div class="r_head"></div>
            <div class="r_x">
                <table class="r_tb">
                    <thead>
	                    <tr>
	                        <td class="r_35 r_tb_tit">处理的任务</td>
	                        <td class="r_9 r_tb_tit">处理结果</td>
	                        <td class="r_55 r_tb_tit">提示信息</td>
	                        <td class="r_6 r_tb_tit">操作</td>
	                    </tr>
                    </thead>
                    <tbody>
                    <%
                    	for(int j=0;j<ckList.size();j++){
                                        	CheckItem ckItem = ckList.get(j);
                                        	String viewerScript = ckItem.getBizViewer();
                                        	if(viewerScript==null)viewerScript="";
                                        	else viewerScript = AmarScriptTool.pretreat(context.getParameter(), viewerScript);
                                        	String viewNode = "&nbsp;";
                                        	if(viewerScript.length()>0){
                                        		viewNode = "<a href='javascript:void(0);'>修改</a>";
                                        	}
                    %>
                    <tr class="ck_item default" groupID="<%=group.getGroupID()%>" itemID="<%=ckItem.getItemID()%>" noPassDeal="<%=ckItem.getNoPassDeal()%>">
                        <td class="r_35"><%=ckItem.getItemName()%></td>
                        <td class="r_9"><div class="icon"></div></td>
                        <td class="r_55 message">&nbsp;</td>
                        <td class="r_6 viewer"><span class="label"><%=viewNode%></span><span class="script"><%=viewerScript%></span></td>
                    </tr>
 					<%}%>
                    </tbody>
                </table>
            </div>
            <div class="r_footer"></div>
        </div>
        <%}%>
        <div class="r_ending">
	    	<table style="width: 820px">
				<tr>
					<td colspan="3" id="scenario-message" height="50px" vAlign="middle">&nbsp;
					</td>
				</tr>
				<tr id="scenario-button">
				    <td align="center">
					    <table>
					        <tr>
						       <td><%=new Button("重新检查","重新检查","reRun()","","").getHtmlText()%></td>
					        </tr>
					    </table>
				    </td>
				</tr>
			</table>
		</div>
    </div> 
</body>
<script type="text/javascript">
function alarm_exit(){
	top.close();
}

function alarm_ok(){
	var ctx = $(".r_main");
	var bComplete = ctx.isComplete();
	if(bComplete){
		top.returnValue = (bComplete&&ctx.isPass());
		top.close();
	}else{
		alert("没有运行完毕");
	}
}

$(document).ready(function(){
	run();
});
function run(){
	try{parent.ASCheck.autoCheckFlag = "";}catch(e){}
	var url = "<%=sWebRootPath%>/AppConfig/AutoRiskDetect/AlarmModelInvoker.jsp?CompClientID=<%=sCompClientID%>&randp="+randomNumber();
	var ser = "<%=scenarioSerializable%>";
	$(".r_main").riskScan({
		modelInvoker:url,
		scenarioSerial:ser
	});
	
	window.setTimeout("check();", 100);
}

function check(){
	var ctx = $(".r_main");
	var bComplete = ctx.isComplete();
	if(bComplete){
		try
		{
			parent.ASCheck.autoCheckFlag = (bComplete&&ctx.isPass());
		}catch(e){}
	}
	window.setTimeout("check();", 100);
}
function reRun(){
	run();
}

</script>
<%@	include file="/IncludeEnd.jsp"%>