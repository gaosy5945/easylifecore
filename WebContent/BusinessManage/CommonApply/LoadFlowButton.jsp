<%@page import="com.amarsoft.awe.ui.widget.Button"%>
<%@page import="com.amarsoft.biz.workflow.FlowTask"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%
	try{
		String taskNo=CurPage.getParameter("TaskNo");
		int kNum=0;
		String phaseOpinionStr="";
		FlowTask ftBusiness = new FlowTask(taskNo,Sqlca);
		String[] phaseOpinion = ftBusiness.getChoiceList();
		for(int k=0;k<phaseOpinion.length;k++){
			if(phaseOpinion[k].contains("提交")){
				kNum++;
			}
		}
		for(int j=0;j<phaseOpinion.length;j++){
			if(phaseOpinion[j].contains("提交") && kNum > 1){
				phaseOpinionStr+="@"+phaseOpinion[j];
			}else{
				Button	aButton = new Button(phaseOpinion[j], phaseOpinion[j],"doAction('"+phaseOpinion[j]+"')", "", "", "");
				out.print("<span id='doAction"+j+"'>"+aButton.getHtmlText()+"</span>");
			}
		}
		
	}catch(Exception e){
		
	}

%>

<%@ include file="/IncludeEndAJAX.jsp"%>