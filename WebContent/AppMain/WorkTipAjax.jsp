<%@ page language="java" contentType="text/html; charset=GBK"%><%@
include file="/Frame/resources/include/include_begin_ajax.jspf"%><%@
page import="com.amarsoft.app.awe.config.worktip.WorkTipRun"%><%@
page import="com.amarsoft.app.awe.config.worktip.WorkTips"%><%@
page import="com.amarsoft.app.awe.config.worktip.WorkTip"%><%
	String sRunner = CurPage.getParameter("Runner");
	if(sRunner == null) return;
	
	String[] aRunner = sRunner.split("@");
	if(aRunner.length < 1) return;
	
	HashMap<String, String> params = new HashMap<String, String>();
	if(aRunner.length > 1){
		String[] sParams = aRunner[1].split("~");
		for(int i = 0; i < sParams.length; i++){
			String[] sParam = sParams[i].split("=");
			if(StringX.isSpace(sParam[0])) continue;
			String sValue = null;
			if(sParam.length > 1) sValue = sParam[1];
			params.put(sParam[0], sValue);
		}
	}
	WorkTipRun run = (WorkTipRun)Class.forName(aRunner[0]).newInstance();
	WorkTips tips = null;
	try{
		tips = run.run(params, CurUser, Sqlca);
	}catch(Exception e){
		tips = new WorkTips();
		WorkTip exception = new WorkTip("<span style='color:#f00;'>º”‘ÿ“Ï≥£</span>", "void(0)");
		exception.setNum(0);
		tips.information.add(exception);
	}
	if(tips != null) out.print(tips.getInformation());
%><%@ include file="/Frame/resources/include/include_end_ajax.jspf"%>