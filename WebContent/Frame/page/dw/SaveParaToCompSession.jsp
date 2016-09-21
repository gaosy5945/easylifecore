<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMD.jsp"%><%
	String sTempParaString = CurPage.getParameter("TempParaString");
	String sParas[][];
	int iParas = 0;
	if(sTempParaString!=null && !sTempParaString.equals("")){
		sTempParaString = SpecialTools.amarsoft2Real(sTempParaString);
		iParas = StringFunction.getSeparateSum(sTempParaString,"&");
		if(sTempParaString.substring(0,1).equals("&")) iParas--;
		sParas = new String[iParas][2];
		for(int i=0;i<sParas.length;i++){
			String sSeg = StringFunction.getSeparate(sTempParaString,"&",i+1);
			sParas[i][0] = sSeg.substring(0,sSeg.indexOf("=")).trim();
			sParas[i][1] = sSeg.substring(sSeg.indexOf("=")+1).trim();
			CurCompSession.setAttribute(sParas[i][0],sParas[i][1]);
		}
	}
%><%@ include file="/IncludeEnd.jsp"%>